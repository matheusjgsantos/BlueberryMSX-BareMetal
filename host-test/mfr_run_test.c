/* mfr_run_test.c -- run C-BIOS + the MFR menu ROM (emulated slot 1) and report
 * whether the ROM reaches its "needs >=64KiB RAM" error path at 0x453A. */
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
extern int g_trace_io;
extern unsigned g_trace_cap;
extern unsigned g_trace_count;

static long g_frame = 0;
static void diag(const char *line, void *opaque){ (void)opaque; printf("[f%ld] %s\n", g_frame, line); }

int main(int argc, char **argv)
{
    const char *path = (argc>1)?argv[1]:"/data/Projects/MSX/carts/MFR1.ROM";
    int frames = (argc>2)?atoi(argv[2]):600;
    static uint8_t cart[0x10000];
    FILE *f=fopen(path,"rb");
    if(!f){perror("open cart");return 2;}
    size_t n=fread(cart,1,sizeof cart,f); fclose(f);
    printf("cart %s: read %zu bytes\n", path, n);

    MSX_Machine *m=msx_create();
    if(!m) return 2;
    m->diag_log=diag; m->diag_log_budget=20000; m->diag_log_count=0;

    msx_set_slot(m,3,0,0,0);
    memset(m->slots[3].subslots[0].data,0,SLOT_MAX_SIZE);
    msx_load_data(m,0,0,0x0000,(uint8_t*)cbios_main_rom,(int)cbios_main_rom_size);
    msx_load_data(m,0,0,0x8000,(uint8_t*)cbios_logo_rom,(int)cbios_logo_rom_size);
    msx_load_data(m,1,0,0x4000,cart,0x4000);
    msx_load_data(m,1,0,0x8000,cart+0x4000,0x4000);
    m->bus.write_io(m->bus.ref,0xA8,0xC0);

    int hit=0, cartEntered=0, cartInit=0;
    unsigned cartFirstPc=0;
    int injectFrame = (argc>3)?atoi(argv[3]):-1;
    unsigned injectPc = (argc>4)?(unsigned)strtoul(argv[4],0,16):0x423C;
    int injectBank = (argc>5)?atoi(argv[5]):7;
    for(int i=0;i<frames;i++){
        g_frame = i;
        if(i==injectFrame){
            printf("*** INJECT at frame %d: PC=0x%04X A=%d slotReg=%02X active=[%d %d %d %d] ***\n",
                   i,injectPc, injectBank, m->slotReg,
                   m->activeSlot[0],m->activeSlot[1],m->activeSlot[2],m->activeSlot[3]);
            ((R800*)m->z80)->regs.PC.W = (UInt16)injectPc;
            ((R800*)m->z80)->regs.AF.B.h = (UInt8)injectBank;
            g_trace_cap = 5000;
            g_trace_count = 0;
            g_trace_io = 1;
        }
        msx_step_frame(m,12000);
        unsigned pc=((R800*)m->z80)->regs.PC.W;
        if(pc>=0x453A && pc<=0x454F){ printf("*** ERROR PATH at frame %d pc=%04X ***\n",i,pc); hit=1; break; }
        if(pc>=0x4080 && pc<=0x40FF) cartInit=1;
        if(pc>=0x4000 && pc<=0xBFFF) cartEntered=1;
    }
    printf("cart region entered=%d firstPc=%04X cartInit(0x4080)=%d\n", cartEntered, cartFirstPc, cartInit);
    uint8_t *ram=m->slots[3].subslots[0].data;
    printf("final PC=%04X hit=%d slotReg=%02X active=[%d %d %d %d]\n",
        ((R800*)m->z80)->regs.PC.W, hit, m->slotReg,
        m->activeSlot[0],m->activeSlot[1],m->activeSlot[2],m->activeSlot[3]);
    printf("RAM: F341=%02X F342=%02X F343=%02X E200=%02X F3E9=%02X F380..F38F=",
        ram[0xF341],ram[0xF342],ram[0xF343],ram[0xE200],ram[0xF3E9]);
    for(int i=0xF380;i<0xF390;i++) printf("%02X ",ram[i]);
    printf("\n");
    printf("E210=%02X  EXPTBL=%02X %02X %02X %02X\n",
        ram[0xE210], ram[0xFCC1],ram[0xFCC2],ram[0xFCC3],ram[0xFCC4]);
    unsigned nEv = msx_slot_event_count();
    printf("SLOT EVT count=%u\n", nEv);
    for (unsigned i=0;i<nEv;i++){
        unsigned pc,p,val;
        if(!msx_slot_event_get(i,&pc,&p,&val)) break;
        const char *nm = p==0?"A8":p==1?"E200":"E210";
        printf("  %02u %s=%02X pc=%04X\n", i, nm, val, pc);
    }
    return 0;
}
