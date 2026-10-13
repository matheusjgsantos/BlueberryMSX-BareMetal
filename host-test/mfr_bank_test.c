/* mfr_bank_test.c -- model the MFR as an 8KB-banked bus cart (Konami-style
 * registers at 0x4000/0x6000/0x8000/0xA000), run C-BIOS + the menu, inject a
 * game selection, and check whether the loader launches a distinct "game" bank
 * instead of re-entering the menu INIT. Purpose: isolate whether the emulator's
 * bus plumbing + core switch banks correctly (the Pi failure is bank-related). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "msx.h"
#include "R800.h"

extern const uint8_t cbios_main_rom[];
extern const uint32_t cbios_main_rom_size;
extern const uint8_t cbios_logo_rom[];
extern const uint32_t cbios_logo_rom_size;

static long g_frame = 0;
static void diag(const char *line, void *o){ (void)o; printf("[f%ld] %s\n", g_frame, line); }

/* 512KB flash / 8KB banks = 64 banks */
static uint8_t g_image[512*1024];
static int g_reg[4] = {0,1,2,3};
static int g_bank_writes = 0;

static UInt8 bus_read(void *ref, int bslot, UInt16 addr)
{
    (void)ref; (void)bslot;
    if (addr >= 0x4000 && addr < 0xC000) {
        int region = (addr - 0x4000) >> 13;
        return g_image[g_reg[region]*0x2000 + (addr & 0x1FFF)];
    }
    return 0xFF;
}
static void bus_write(void *ref, int bslot, UInt16 addr, UInt8 val)
{
    (void)ref; (void)bslot;
    if (addr >= 0x4000 && addr < 0xC000) {
        int region = (addr - 0x4000) >> 13;
        printf("  [BANK] write %04X=%02X -> reg[%d] %d->%d now=[%d %d %d %d]\n",
               addr, val, region, g_reg[region], val,
               region==0?val:g_reg[0], region==1?val:g_reg[1],
               region==2?val:g_reg[2], region==3?val:g_reg[3]);
        g_reg[region] = val;
        g_bank_writes++;
    }
}
static UInt8 bus_read_io(void *ref, UInt16 p){ (void)ref;(void)p; return 0xFF; }
static void  bus_write_io(void *ref, UInt16 p, UInt8 v){ (void)ref;(void)p;(void)v; }

int main(int argc, char **argv)
{
    const char *path = (argc>1)?argv[1]:"/home/opencode/MSX/host-test/mfr1_64k.bin";
    int frames = (argc>2)?atoi(argv[2]):300;
    int injectFrame = (argc>3)?atoi(argv[3]):200;
    unsigned injectPc = (argc>4)?(unsigned)strtoul(argv[4],0,16):0x423C;
    int injectBank = (argc>5)?atoi(argv[5]):7;

    FILE *f = fopen(path,"rb");
    if (!f){ perror("open cart"); return 2; }
    static uint8_t menu[0x10000];
    size_t n = fread(menu,1,sizeof menu,f); fclose(f);
    printf("cart %s: read %zu bytes (using first 16KB as menu)\n", path, n);

    /* Lay out the fake flash: bank0/1 = menu page1, bank2/3 = menu page2
     * (mirror), bank 7/8 = a distinct "game" whose entry (page2 offset 2) is
     * 0x4010 with a stub there that writes 0xAA to 0xE300 and halts. */
    memset(g_image, 0, sizeof g_image);
    memcpy(g_image+0x0000, menu, 0x4000);   /* banks 0,1: menu page1 */
    memcpy(g_image+0x4000, menu, 0x4000);   /* banks 2,3: menu page2 (mirror) */
    /* bank 7 = game low 8KB */
    int b7 = 7*0x2000;
    g_image[b7+2] = 0x10; g_image[b7+3] = 0x40;   /* entry -> 0x4010 */
    static const uint8_t stub[] = {0x3E,0xAA, 0x32,0x00,0xE3, 0x76}; /* ld a,AA ; ld (E300),a ; halt */
    memcpy(g_image+b7+0x10, stub, sizeof stub);

    MSX_Machine *m = msx_create();
    if (!m) return 2;
    m->diag_log = diag; m->diag_log_budget = 20000; m->diag_log_count = 0;

    msx_set_slot(m,3,0,0,0);                                  /* RAM slot */
    memset(m->slots[3].subslots[0].data,0,SLOT_MAX_SIZE);
    msx_load_data(m,0,0,0x0000,(uint8_t*)cbios_main_rom,(int)cbios_main_rom_size);
    msx_load_data(m,0,0,0x8000,(uint8_t*)cbios_logo_rom,(int)cbios_logo_rom_size);

    /* slot1 subslot0 -> bus (connector 0), fake MFR mapper */
    m->bus_read = bus_read; m->bus_write = bus_write;
    m->bus_read_io = bus_read_io; m->bus_write_io = bus_write_io;
    msx_slot_set_bus(m,1,0,0);

    m->bus.write_io(m->bus.ref,0xA8,0xC0);

    for (int i=0;i<frames;i++){
        g_frame = i;
        if (i==injectFrame){
            printf("*** INJECT frame %d: PC=%04X A(bank)=%d slotReg=%02X active=[%d %d %d %d] regs=[%d %d %d %d] ***\n",
                   i, injectPc, injectBank, m->slotReg,
                   m->activeSlot[0],m->activeSlot[1],m->activeSlot[2],m->activeSlot[3],
                   g_reg[0],g_reg[1],g_reg[2],g_reg[3]);
            ((R800*)m->z80)->regs.PC.W = (UInt16)injectPc;
            ((R800*)m->z80)->regs.AF.B.h = (UInt8)injectBank;
        }
        msx_step_frame(m,12000);
        unsigned pc=((R800*)m->z80)->regs.PC.W;
        if (pc>=0x453A && pc<=0x454F){ printf("*** ERROR PATH frame %d pc=%04X ***\n",i,pc); break; }
    }

    uint8_t *ram = m->slots[3].subslots[0].data;
    printf("final PC=%04X  E300(marker)=%02X  E200=%02X  F342=%02X F343=%02X  bank_writes=%d  regs=[%d %d %d %d]\n",
        ((R800*)m->z80)->regs.PC.W, ram[0xE300], ram[0xE200], ram[0xF342], ram[0xF343],
        g_bank_writes, g_reg[0],g_reg[1],g_reg[2],g_reg[3]);
    return 0;
}
