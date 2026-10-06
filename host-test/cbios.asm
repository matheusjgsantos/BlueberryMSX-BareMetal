; z80dasm 1.2.0
; command line: z80dasm -a -g 0x0000 cbios.bin

	org 00000h

	di			;0000
	jp 00d12h		;0001
	cp a			;0004
	dec de			;0005
	sbc a,b			;0006
	sbc a,b			;0007
	jp 01112h		;0008
	nop			;000b
	jp 023bfh		;000c
	nop			;000f
	jp 01124h		;0010
	nop			;0013
	jp 02400h		;0014
	nop			;0017
	jp 01140h		;0018
	nop			;001b
	jp 02434h		;001c
	nop			;001f
	jp 01146h		;0020
	nop			;0023
	jp 02473h		;0024
	nop			;0027
	jp 0114ch		;0028
	and c			;002b
	ld (bc),a		;002c
	nop			;002d
	nop			;002e
	nop			;002f
	jp 0115eh		;0030
	nop			;0033
	nop			;0034
	nop			;0035
	nop			;0036
	nop			;0037
	jp 0190bh		;0038
	jp 01173h		;003b
	jp 0117dh		;003e
	jp 00216h		;0041
	jp 00222h		;0044
	jp 0022eh		;0047
	jp 00245h		;004a
	jp 0024bh		;004d
	jp 00253h		;0050
	jp 0025eh		;0053
	jp 0026bh		;0056
	jp 0027eh		;0059
	jp 00291h		;005c
	jp 002a4h		;005f
	jp 002cbh		;0062
	nop			;0065
	jp 01983h		;0066
	jp 00315h		;0069
	jp 00374h		;006c
	jp 003b4h		;006f
	jp 003f7h		;0072
	jp 00435h		;0075
	jp 00481h		;0078
	jp 004a9h		;007b
	jp 004d8h		;007e
	jp 0050bh		;0081
	jp 00561h		;0084
	jp 00574h		;0087
	jp 0057eh		;008a
	jp 00589h		;008d
	jp 0175fh		;0090
	jp 01777h		;0093
	jp 01781h		;0096
	jp 0118fh		;0099
	jp 011a1h		;009c
	jp 011b4h		;009f
	jp 011d9h		;00a2
	jp 014feh		;00a5
	jp 01528h		;00a8
	jp 01536h		;00ab
	jp 0155bh		;00ae
	jp 01579h		;00b1
	jp 01570h		;00b4
	jp 0164ah		;00b7
	jp 01666h		;00ba
	jp 01678h		;00bd
	jp 0167bh		;00c0
	jp 007a1h		;00c3
	jp 0168bh		;00c6
	jp 0168fh		;00c9
	jp 016a0h		;00cc
	jp 016b2h		;00cf
	jp 016c4h		;00d2
	jp 017b4h		;00d5
	jp 01827h		;00d8
	jp 0186ch		;00db
	jp 0187eh		;00de
	jp 016d7h		;00e1
	jp 016eah		;00e4
	jp 016fch		;00e7
	jp 0170eh		;00ea
	jp 01721h		;00ed
	jp 01734h		;00f0
	jp 01746h		;00f3
	jp 0188fh		;00f6
	jp 0189eh		;00f9
	jp 00830h		;00fc
	jp 00842h		;00ff
	jp 00853h		;0102
	jp 00862h		;0105
	jp 00872h		;0108
	jp 00883h		;010b
	jp 00895h		;010e
	jp 008a5h		;0111
	jp 008e0h		;0114
	jp 008eeh		;0117
	jp 00900h		;011a
	jp 00912h		;011d
	jp 00923h		;0120
	jp 00933h		;0123
	jp 00945h		;0126
	jp 00957h		;0129
	jp 00969h		;012c
	jp 0097ah		;012f
	jp 018cch		;0132
	jp 01786h		;0135
	jp 0178fh		;0138
	jp 01792h		;013b
	jp 01795h		;013e
	jp 01798h		;0141
	jp 017a7h		;0144
	jp 017abh		;0147
	jp 017afh		;014a
	jp 018d8h		;014d
	jp 018eah		;0150
	jp 018eeh		;0153
	jp 01904h		;0156
	jp 01a97h		;0159
	nop			;015c
	nop			;015d
	nop			;015e
	ret			;015f
	nop			;0160
	nop			;0161
	nop			;0162
	nop			;0163
	nop			;0164
	nop			;0165
	nop			;0166
	nop			;0167
	nop			;0168
	nop			;0169
	nop			;016a
	nop			;016b
	nop			;016c
	nop			;016d
	nop			;016e
	nop			;016f
	nop			;0170
	nop			;0171
	nop			;0172
	nop			;0173
	nop			;0174
	nop			;0175
	nop			;0176
	nop			;0177
	nop			;0178
	nop			;0179
	nop			;017a
	nop			;017b
	nop			;017c
	nop			;017d
	nop			;017e
	nop			;017f
	nop			;0180
	nop			;0181
	nop			;0182
	nop			;0183
	nop			;0184
	nop			;0185
	nop			;0186
	nop			;0187
	nop			;0188
	nop			;0189
	nop			;018a
	nop			;018b
	nop			;018c
	nop			;018d
	nop			;018e
	nop			;018f
	nop			;0190
	nop			;0191
	nop			;0192
	nop			;0193
	nop			;0194
	nop			;0195
	nop			;0196
	nop			;0197
	nop			;0198
	nop			;0199
	nop			;019a
	nop			;019b
	nop			;019c
	nop			;019d
	nop			;019e
	nop			;019f
	nop			;01a0
	nop			;01a1
	nop			;01a2
	nop			;01a3
	nop			;01a4
	nop			;01a5
	nop			;01a6
	nop			;01a7
	nop			;01a8
	nop			;01a9
	nop			;01aa
	nop			;01ab
	nop			;01ac
	nop			;01ad
	nop			;01ae
	nop			;01af
	nop			;01b0
	nop			;01b1
	nop			;01b2
	nop			;01b3
	nop			;01b4
	nop			;01b5
	nop			;01b6
	nop			;01b7
	nop			;01b8
	nop			;01b9
	nop			;01ba
	nop			;01bb
	nop			;01bc
	nop			;01bd
	nop			;01be
	nop			;01bf
	nop			;01c0
	nop			;01c1
	nop			;01c2
	nop			;01c3
	nop			;01c4
	nop			;01c5
	nop			;01c6
	nop			;01c7
	nop			;01c8
	nop			;01c9
	nop			;01ca
	nop			;01cb
	nop			;01cc
	nop			;01cd
	nop			;01ce
	nop			;01cf
	nop			;01d0
	nop			;01d1
	nop			;01d2
	nop			;01d3
	nop			;01d4
	nop			;01d5
	nop			;01d6
	nop			;01d7
	nop			;01d8
	nop			;01d9
	nop			;01da
	nop			;01db
	nop			;01dc
	nop			;01dd
	nop			;01de
	nop			;01df
	nop			;01e0
	nop			;01e1
	nop			;01e2
	nop			;01e3
	nop			;01e4
	nop			;01e5
	nop			;01e6
	nop			;01e7
	nop			;01e8
	nop			;01e9
	nop			;01ea
	nop			;01eb
	nop			;01ec
	nop			;01ed
	nop			;01ee
	nop			;01ef
	nop			;01f0
	nop			;01f1
	nop			;01f2
	nop			;01f3
	nop			;01f4
	nop			;01f5
	nop			;01f6
	nop			;01f7
	nop			;01f8
	nop			;01f9
	nop			;01fa
	nop			;01fb
	nop			;01fc
	nop			;01fd
	nop			;01fe
	nop			;01ff
	ld c,a			;0200
	ld b,000h		;0201
	add hl,bc		;0203
	add hl,bc		;0204
	jp 00211h		;0205
	cp (hl)			;0208
	inc hl			;0209
	jr z,$+7		;020a
	inc hl			;020c
	inc hl			;020d
	djnz $-6		;020e
	ret			;0210
	ld c,(hl)		;0211
	inc hl			;0212
	ld h,(hl)		;0213
	ld l,c			;0214
	jp (hl)			;0215
	ld a,(0f3e0h)		;0216
	and 0bfh		;0219
	ld b,a			;021b
	ld c,001h		;021c
	call 0022eh		;021e
	ret			;0221
	ld a,(0f3e0h)		;0222
	or 040h			;0225
	ld b,a			;0227
	ld c,001h		;0228
	call 0022eh		;022a
	ret			;022d
	di			;022e
	res 7,c			;022f
	ld a,b			;0231
	out (099h),a		;0232
	ld a,c			;0234
	or 080h			;0235
	out (099h),a		;0237
	ei			;0239
	push hl			;023a
	ld hl,0f3dfh		;023b
	ld a,b			;023e
	ld b,000h		;023f
	add hl,bc		;0241
	ld (hl),a		;0242
	pop hl			;0243
	ret			;0244
	call 00253h		;0245
	in a,(098h)		;0248
	ret			;024a
	push af			;024b
	call 0025eh		;024c
	pop af			;024f
	out (098h),a		;0250
	ret			;0252
	di			;0253
	ld a,l			;0254
	out (099h),a		;0255
	ld a,h			;0257
	and 03fh		;0258
	out (099h),a		;025a
	ei			;025c
	ret			;025d
	di			;025e
	ld a,l			;025f
	out (099h),a		;0260
	ld a,h			;0262
	and 03fh		;0263
	or 040h			;0265
	out (099h),a		;0267
	ei			;0269
	ret			;026a
	push af			;026b
	call 0025eh		;026c
	dec bc			;026f
	inc c			;0270
	ld a,b			;0271
	ld b,c			;0272
	ld c,a			;0273
	inc c			;0274
	pop af			;0275
	out (098h),a		;0276
	djnz $-2		;0278
	dec c			;027a
	jr nz,$-5		;027b
	ret			;027d
	call 00253h		;027e
	push hl			;0281
	ex de,hl		;0282
	dec bc			;0283
	inc c			;0284
	ld a,b			;0285
	ld b,c			;0286
	inc a			;0287
	ld c,098h		;0288
	inir			;028a
	dec a			;028c
	jr nz,$-3		;028d
	pop hl			;028f
	ret			;0290
	ex de,hl		;0291
	call 0025eh		;0292
	ex de,hl		;0295
	dec bc			;0296
	inc c			;0297
	ld a,b			;0298
	ld b,c			;0299
	inc a			;029a
	ld c,098h		;029b
	otir			;029d
	dec a			;029f
	jr nz,$-3		;02a0
	ex de,hl		;02a2
	ret			;02a3
	cp 004h			;02a4
	ret nc			;02a6
	ld hl,002adh		;02a7
	jp 00200h		;02aa
	ld (hl),h		;02ad
	inc bc			;02ae
	or h			;02af
	inc bc			;02b0
	rst 30h			;02b1
	inc bc			;02b2
	dec (hl)		;02b3
	inc b			;02b4
	di			;02b5
	ld hl,0f3dfh		;02b6
	ld bc,00899h		;02b9
	ld d,080h		;02bc
	outi			;02be
	ld a,b			;02c0
	out (c),d		;02c1
	inc d			;02c3
	or a			;02c4
	jr nz,$-7		;02c5
	ei			;02c7
	jp 00222h		;02c8
	ld a,(0fcafh)		;02cb
	cp 008h			;02ce
	jr z,$+60		;02d0
	dec a			;02d2
	push af			;02d3
	ld a,(0f3e9h)		;02d4
	rlca			;02d7
	rlca			;02d8
	rlca			;02d9
	rlca			;02da
	and 0f0h		;02db
	ld l,a			;02dd
	ld a,(0f3ebh)		;02de
	or l			;02e1
	ld b,a			;02e2
	ld c,007h		;02e3
	call 0022eh		;02e5
	pop af			;02e8
	ret nz			;02e9
	ld a,(0f3e9h)		;02ea
	rlca			;02ed
	rlca			;02ee
	rlca			;02ef
	rlca			;02f0
	and 0f0h		;02f1
	ld hl,0f3eah		;02f3
	or (hl)			;02f6
	ld hl,(0f3bfh)		;02f7
	ld bc,00020h		;02fa
	push af			;02fd
	call 0025eh		;02fe
	pop af			;0301
	out (098h),a		;0302
	push af			;0304
	dec bc			;0305
	ld a,b			;0306
	or c			;0307
	jr nz,$-7		;0308
	pop af			;030a
	ret			;030b
	ld a,(0f3ebh)		;030c
	ld b,a			;030f
	ld c,007h		;0310
	jp 0022eh		;0312
	ld a,(0fcafh)		;0315
	or a			;0318
	ret z			;0319
	call 0033fh		;031a
	ld a,(0fcafh)		;031d
	cp 004h			;0320
	jr c,$+18		;0322
	ld hl,(0f928h)		;0324
	dec h			;0327
	dec h			;0328
	ld bc,00200h		;0329
	ld a,(0f3e9h)		;032c
	and 00fh		;032f
	call 006c2h		;0331
	ld hl,(0f926h)		;0334
	ld bc,00800h		;0337
	xor a			;033a
	call 0026bh		;033b
	ret			;033e
	ld a,(0fcafh)		;033f
	cp 004h			;0342
	jr c,$+6		;0344
	ld e,0d9h		;0346
	jr $+4			;0348
	ld e,0d1h		;034a
	ld hl,(0f928h)		;034c
	call 0025eh		;034f
	ld a,(0f3e9h)		;0352
	ld d,a			;0355
	ld bc,02000h		;0356
	di			;0359
	ld a,e			;035a
	out (098h),a		;035b
	ld a,000h		;035d
	out (098h),a		;035f
	ld a,c			;0361
	out (098h),a		;0362
	inc c			;0364
	call 0057eh		;0365
	jr nc,$+5		;0368
	inc c			;036a
	inc c			;036b
	inc c			;036c
	ld a,d			;036d
	out (098h),a		;036e
	djnz $-22		;0370
	ei			;0372
	ret			;0373
	call 00216h		;0374
	ld a,000h		;0377
	ld (0fcafh),a		;0379
	ld (0fcb0h),a		;037c
	ld a,(0f3aeh)		;037f
	ld (0f3b0h),a		;0382
	ld a,001h		;0385
	ld (0f3dch),a		;0387
	ld (0f3ddh),a		;038a
	ld hl,(0f3b3h)		;038d
	ld (0f922h),hl		;0390
	ld hl,(0f3b7h)		;0393
	ld (0f924h),hl		;0396
	ld hl,(0f3b9h)		;0399
	ld (0f928h),hl		;039c
	ld hl,(0f3bbh)		;039f
	ld (0f926h),hl		;03a2
	call 002cbh		;03a5
	call 00481h		;03a8
	call 00794h		;03ab
	call 007b9h		;03ae
	jp 002b5h		;03b1
	call 00216h		;03b4
	ld a,001h		;03b7
	ld (0fcafh),a		;03b9
	ld (0fcb0h),a		;03bc
	ld a,001h		;03bf
	ld (0f3dch),a		;03c1
	ld (0f3ddh),a		;03c4
	call 002cbh		;03c7
	ld hl,(0f3bdh)		;03ca
	ld (0f922h),hl		;03cd
	ld hl,(0f3c1h)		;03d0
	ld (0f924h),hl		;03d3
	ld hl,(0f3c5h)		;03d6
	ld (0f926h),hl		;03d9
	ld hl,(0f3c3h)		;03dc
	ld (0f928h),hl		;03df
	call 00794h		;03e2
	ld a,(0f3afh)		;03e5
	ld (0f3b0h),a		;03e8
	call 004a9h		;03eb
	call 0034ah		;03ee
	call 007c8h		;03f1
	jp 002b5h		;03f4
	call 00216h		;03f7
	ld a,002h		;03fa
	ld (0fcafh),a		;03fc
	call 002cbh		;03ff
	ld hl,(0f3c7h)		;0402
	ld (0f922h),hl		;0405
	call 0025eh		;0408
	ld b,003h		;040b
	xor a			;040d
	di			;040e
	out (098h),a		;040f
	inc a			;0411
	jr nz,$-3		;0412
	djnz $-5		;0414
	ei			;0416
	ld hl,(0f3cbh)		;0417
	ld (0f924h),hl		;041a
	ld hl,(0f3cdh)		;041d
	ld (0f928h),hl		;0420
	ld hl,(0f3cfh)		;0423
	ld (0f926h),hl		;0426
	call 004d8h		;0429
	call 0034ah		;042c
	call 007e4h		;042f
	jp 002b5h		;0432
	call 00216h		;0435
	ld a,003h		;0438
	ld (0fcafh),a		;043a
	call 002cbh		;043d
	ld hl,(0f3d1h)		;0440
	ld (0f922h),hl		;0443
	call 0025eh		;0446
	xor a			;0449
	ld c,006h		;044a
	di			;044c
	push af			;044d
	ld e,004h		;044e
	push af			;0450
	ld b,020h		;0451
	out (098h),a		;0453
	inc a			;0455
	djnz $-3		;0456
	pop af			;0458
	dec e			;0459
	jr nz,$-10		;045a
	pop af			;045c
	add a,020h		;045d
	dec c			;045f
	jr nz,$-19		;0460
	ei			;0462
	ld hl,(0f3d5h)		;0463
	ld (0f924h),hl		;0466
	ld hl,(0f3d7h)		;0469
	ld (0f928h),hl		;046c
	ld hl,(0f3d9h)		;046f
	ld (0f926h),hl		;0472
	call 0050bh		;0475
	call 0034ah		;0478
	call 007fah		;047b
	jp 002b5h		;047e
	ld a,(0f3dfh)		;0481
	and 0f1h		;0484
	ld b,a			;0486
	ld c,000h		;0487
	call 0022eh		;0489
	ld a,(0f3e0h)		;048c
	and 0e7h		;048f
	or 010h			;0491
	ld b,a			;0493
	inc c			;0494
	call 0022eh		;0495
	ld de,0f3b3h		;0498
	ld c,002h		;049b
	xor a			;049d
	call 0053ch		;049e
	inc de			;04a1
	inc de			;04a2
	inc c			;04a3
	xor a			;04a4
	call 0053ch		;04a5
	ret			;04a8
	ld a,(0f3dfh)		;04a9
	and 0f1h		;04ac
	ld b,a			;04ae
	ld c,000h		;04af
	call 0022eh		;04b1
	ld a,(0f3e0h)		;04b4
	and 0e7h		;04b7
	ld b,a			;04b9
	inc c			;04ba
	call 0022eh		;04bb
	ld de,0f3bdh		;04be
	ld c,002h		;04c1
	xor a			;04c3
	call 0053ch		;04c4
	xor a			;04c7
	call 0053ch		;04c8
	xor a			;04cb
	call 0053ch		;04cc
	xor a			;04cf
	call 0053ch		;04d0
	xor a			;04d3
	call 0053ch		;04d4
	ret			;04d7
	ld a,(0f3dfh)		;04d8
	and 0f1h		;04db
	or 002h			;04dd
	ld b,a			;04df
	ld c,000h		;04e0
	call 0022eh		;04e2
	ld a,(0f3e0h)		;04e5
	and 0e7h		;04e8
	ld b,a			;04ea
	inc c			;04eb
	call 0022eh		;04ec
	ld de,0f3c7h		;04ef
	ld c,002h		;04f2
	xor a			;04f4
	call 0053ch		;04f5
	ld a,07fh		;04f8
	call 0053ch		;04fa
	ld a,003h		;04fd
	call 0053ch		;04ff
	xor a			;0502
	call 0053ch		;0503
	xor a			;0506
	call 0053ch		;0507
	ret			;050a
	ld a,(0f3dfh)		;050b
	and 0f1h		;050e
	ld b,a			;0510
	ld c,000h		;0511
	call 0022eh		;0513
	ld a,(0f3e0h)		;0516
	and 0e7h		;0519
	or 008h			;051b
	ld b,a			;051d
	inc c			;051e
	call 0022eh		;051f
	ld de,0f3d1h		;0522
	ld c,002h		;0525
	xor a			;0527
	call 0053ch		;0528
	xor a			;052b
	call 0053ch		;052c
	xor a			;052f
	call 0053ch		;0530
	xor a			;0533
	call 0053ch		;0534
	xor a			;0537
	call 0053ch		;0538
	ret			;053b
	push de			;053c
	push af			;053d
	ld hl,0055ah		;053e
	ld b,000h		;0541
	add hl,bc		;0543
	ld b,(hl)		;0544
	ex de,hl		;0545
	ld a,(hl)		;0546
	inc hl			;0547
	ld h,(hl)		;0548
	ld l,a			;0549
	add hl,hl		;054a
	adc a,a			;054b
	djnz $-2		;054c
	ld b,a			;054e
	pop af			;054f
	or b			;0550
	ld b,a			;0551
	call 0022eh		;0552
	pop de			;0555
	inc de			;0556
	inc de			;0557
	inc c			;0558
	ret			;0559
	nop			;055a
	nop			;055b
	ld b,00ah		;055c
	dec b			;055e
	add hl,bc		;055f
	dec b			;0560
	ld h,000h		;0561
	ld l,a			;0563
	add hl,hl		;0564
	add hl,hl		;0565
	add hl,hl		;0566
	call 0057eh		;0567
	jr nc,$+4		;056a
	add hl,hl		;056c
	add hl,hl		;056d
	ld de,(0f926h)		;056e
	add hl,de		;0572
	ret			;0573
	add a,a			;0574
	add a,a			;0575
	ld hl,(0f928h)		;0576
	ld d,000h		;0579
	ld e,a			;057b
	add hl,de		;057c
	ret			;057d
	ld a,(0f3e0h)		;057e
	rrca			;0581
	rrca			;0582
	ld a,008h		;0583
	ret nc			;0585
	ld a,020h		;0586
	ret			;0588
	push af			;0589
	cp 020h			;058a
	jr c,$+15		;058c
	ld a,(0fcafh)		;058e
	cp 002h			;0591
	jr z,$+36		;0593
	cp 005h			;0595
	jr nc,$+30		;0597
	pop af			;0599
	ret			;059a
	cp 00dh			;059b
	jr nz,$-4		;059d
	pop af			;059f
	push hl			;05a0
	push bc			;05a1
	ld hl,(0fcb9h)		;05a2
	ld bc,00008h		;05a5
	add hl,bc		;05a8
	ld (0fcb9h),hl		;05a9
	ld hl,00000h		;05ac
	ld (0fcb7h),hl		;05af
	pop bc			;05b2
	pop hl			;05b3
	ret			;05b4
	pop af			;05b5
	ret			;05b6
	pop af			;05b7
	push hl			;05b8
	push de			;05b9
	push bc			;05ba
	push af			;05bb
	call 0080eh		;05bc
	ld de,(0fcb9h)		;05bf
	ld bc,(0fcb7h)		;05c3
	call 008a5h		;05c7
	ld a,(0f3e9h)		;05ca
	ld (0f3f2h),a		;05cd
	ld hl,(0f92ah)		;05d0
	ld bc,(0f3cbh)		;05d3
	add hl,bc		;05d7
	ld de,0fc40h		;05d8
	ld a,(0fcb9h)		;05db
	and 007h		;05de
	ld b,000h		;05e0
	ld c,a			;05e2
	add hl,bc		;05e3
	call 00604h		;05e4
	ld bc,000f0h		;05e7
	add hl,bc		;05ea
	ld a,(0fcb9h)		;05eb
	cpl			;05ee
	and 007h		;05ef
	ld c,a			;05f1
	call 00604h		;05f2
	ld hl,(0fcb7h)		;05f5
	ld bc,00008h		;05f8
	add hl,bc		;05fb
	ld (0fcb7h),hl		;05fc
	pop af			;05ff
	pop bc			;0600
	pop de			;0601
	pop hl			;0602
	ret			;0603
	ld a,(0fcb7h)		;0604
	and 007h		;0607
	push af			;0609
	push bc			;060a
	push de			;060b
	push hl			;060c
	call 0068dh		;060d
	ld a,(0fcb7h)		;0610
	and 007h		;0613
	jr z,$+28		;0615
	ld a,(0f92ch)		;0617
	cpl			;061a
	ld (0f92ch),a		;061b
	pop hl			;061e
	ld bc,00008h		;061f
	add hl,bc		;0622
	pop de			;0623
	pop bc			;0624
	pop af			;0625
	call 0068dh		;0626
	ld a,(0f92ch)		;0629
	cpl			;062c
	ld (0f92ch),a		;062d
	ret			;0630
	pop bc			;0631
	ld bc,00008h		;0632
	add hl,bc		;0635
	pop bc			;0636
	pop bc			;0637
	pop af			;0638
	ret			;0639
	push af			;063a
	push hl			;063b
	push bc			;063c
	push de			;063d
	ld d,a			;063e
	ld e,b			;063f
	ld bc,(0f3c9h)		;0640
	add hl,bc		;0644
	ld c,a			;0645
	ld a,(0f3f2h)		;0646
	and 00fh		;0649
	ld b,a			;064b
	call 00245h		;064c
	push af			;064f
	and 00fh		;0650
	cp b			;0652
	jr z,$+19		;0653
	pop af			;0655
	push af			;0656
	rrca			;0657
	rrca			;0658
	rrca			;0659
	rrca			;065a
	and 00fh		;065b
	cp b			;065d
	jr nz,$+15		;065e
	pop af			;0660
	pop de			;0661
	pop bc			;0662
	pop hl			;0663
	pop af			;0664
	ret			;0665
	pop af			;0666
	pop de			;0667
	pop bc			;0668
	pop hl			;0669
	pop af			;066a
	cpl			;066b
	ret			;066c
	ld a,d			;066d
	or e			;066e
	cp 0ffh			;066f
	jr z,$+19		;0671
	pop af			;0673
	rlc b			;0674
	rlc b			;0676
	rlc b			;0678
	rlc b			;067a
	and 00fh		;067c
	or b			;067e
	call 0024bh		;067f
	jr $-33			;0682
	pop af			;0684
	and 0f0h		;0685
	or b			;0687
	call 0024bh		;0688
	jr $-36			;068b
	ld b,c			;068d
	inc a			;068e
	ld c,a			;068f
	ld a,007h		;0690
	xor b			;0692
	inc a			;0693
	ld b,a			;0694
	push bc			;0695
	call 00245h		;0696
	ld b,a			;0699
	ld a,(de)		;069a
	call 0063ah		;069b
	dec c			;069e
	jr z,$+5		;069f
	rrca			;06a1
	jr $-4			;06a2
	ld c,a			;06a4
	ld a,(0f92ch)		;06a5
	and c			;06a8
	ld c,a			;06a9
	ld a,b			;06aa
	or c			;06ab
	call 0024bh		;06ac
	inc hl			;06af
	inc de			;06b0
	pop bc			;06b1
	djnz $-29		;06b2
	ret			;06b4
	ld b,a			;06b5
	ld d,d			;06b6
	ld d,b			;06b7
	ld d,b			;06b8
	ld d,d			;06b9
	ld d,h			;06ba
	nop			;06bb
	ld a,(0fcafh)		;06bc
	cp 005h			;06bf
	ret			;06c1
	push af			;06c2
	call 006e1h		;06c3
	dec bc			;06c6
	inc c			;06c7
	ld a,b			;06c8
	ld b,c			;06c9
	ld c,a			;06ca
	inc c			;06cb
	pop af			;06cc
	di			;06cd
	out (098h),a		;06ce
	djnz $-2		;06d0
	dec c			;06d2
	jr nz,$-5		;06d3
	ei			;06d5
	ret			;06d6
	call 006edh		;06d7
	ld a,h			;06da
	and 03fh		;06db
	out (099h),a		;06dd
	ei			;06df
	ret			;06e0
	call 006edh		;06e1
	ld a,h			;06e4
	and 03fh		;06e5
	or 040h			;06e7
	out (099h),a		;06e9
	ei			;06eb
	ret			;06ec
	ld a,(0faf6h)		;06ed
	or a			;06f0
	jr z,$+18		;06f1
	ld a,(0fcafh)		;06f3
	cp 005h			;06f6
	jp c,0025eh		;06f8
	cp 007h			;06fb
	ld a,(0faf6h)		;06fd
	jr c,$+3		;0700
	add a,a			;0702
	push hl			;0703
	and 003h		;0704
	rrca			;0706
	ld l,a			;0707
	and 080h		;0708
	xor h			;070a
	rla			;070b
	rl l			;070c
	rla			;070e
	ld a,l			;070f
	rla			;0710
	di			;0711
	out (099h),a		;0712
	ld a,08eh		;0714
	out (099h),a		;0716
	pop hl			;0718
	ld a,l			;0719
	out (099h),a		;071a
	ret			;071c
	call 006d7h		;071d
	in a,(098h)		;0720
	ret			;0722
	push af			;0723
	call 006e1h		;0724
	pop af			;0727
	out (098h),a		;0728
	ret			;072a
	di			;072b
	out (099h),a		;072c
	ld a,08fh		;072e
	out (099h),a		;0730
	in a,(099h)		;0732
	push af			;0734
	xor a			;0735
	out (099h),a		;0736
	ld a,08fh		;0738
	out (099h),a		;073a
	ei			;073c
	pop af			;073d
	ret			;073e
	in a,(099h)		;073f
	ld bc,00000h		;0741
	call 0022eh		;0744
	ld bc,0e001h		;0747
	call 0022eh		;074a
	ld bc,00002h		;074d
	call 0022eh		;0750
	ld bc,08003h		;0753
	call 0022eh		;0756
	ld bc,00104h		;0759
	call 0022eh		;075c
	ld a,001h		;075f
	ld (0f3dch),a		;0761
	ld (0f3ddh),a		;0764
	call 007c8h		;0767
	ld a,000h		;076a
	ld hl,00800h		;076c
	ld bc,00800h		;076f
	call 0026bh		;0772
	ld a,0f5h		;0775
	ld hl,02000h		;0777
	ld bc,00020h		;077a
	call 0026bh		;077d
	ld bc,0f507h		;0780
	call 0022eh		;0783
	ld hl,01bbfh		;0786
	ld de,00800h		;0789
	ld bc,00800h		;078c
	call 00291h		;078f
	ret			;0792
	ret			;0793
	ld hl,01bbfh		;0794
	ld de,(0f924h)		;0797
	ld bc,00800h		;079b
	jp 00291h		;079e
	ret nz			;07a1
	ld a,(0fcafh)		;07a2
	cp 004h			;07a5
	ret nc			;07a7
	push hl			;07a8
	ld hl,007b1h		;07a9
	call 00200h		;07ac
	pop hl			;07af
	ret			;07b0
	cp c			;07b1
	rlca			;07b2
	ret z			;07b3
	rlca			;07b4
	call po,0fa07h		;07b5
	rlca			;07b8
	ld a,(0f3b0h)		;07b9
	cp 028h			;07bc
	ld bc,003c0h		;07be
	jr c,$+10		;07c1
	ld bc,00780h		;07c3
	jr $+5			;07c6
	ld bc,00300h		;07c8
	ld hl,(0f922h)		;07cb
	ld a,020h		;07ce
	call 0026bh		;07d0
	ld a,001h		;07d3
	ld hl,0fbb2h		;07d5
	ld (hl),a		;07d8
	ld de,0fbb3h		;07d9
	ld bc,00017h		;07dc
	ldir			;07df
	jp 0126ah		;07e1
	xor a			;07e4
	ld bc,01800h		;07e5
	ld hl,(0f924h)		;07e8
	ld l,a			;07eb
	push bc			;07ec
	call 0026bh		;07ed
	pop bc			;07f0
	ld a,(0f3eah)		;07f1
	ld hl,(0f3c9h)		;07f4
	jp 0026bh		;07f7
	ld a,(0f3eah)		;07fa
	and 00fh		;07fd
	ld b,a			;07ff
	rlca			;0800
	rlca			;0801
	rlca			;0802
	rlca			;0803
	or b			;0804
	ld bc,00800h		;0805
	ld hl,(0f924h)		;0808
	jp 0026bh		;080b
	ld bc,(0f920h)		;080e
	ld l,a			;0812
	ld h,000h		;0813
	add hl,hl		;0815
	add hl,hl		;0816
	add hl,hl		;0817
	add hl,bc		;0818
	ld b,008h		;0819
	ld de,0fc40h		;081b
	push bc			;081e
	push de			;081f
	push hl			;0820
	ld a,(0f91fh)		;0821
	call 023bfh		;0824
	pop hl			;0827
	pop de			;0828
	pop bc			;0829
	ld (de),a		;082a
	inc de			;082b
	inc hl			;082c
	djnz $-15		;082d
	ret			;082f
	push hl			;0830
	push af			;0831
	ld hl,0083bh		;0832
	call 0098bh		;0835
	pop af			;0838
	pop hl			;0839
	ret			;083a
	ld d,d			;083b
	ld c,c			;083c
	ld b,a			;083d
	ld c,b			;083e
	ld d,h			;083f
	ld b,e			;0840
	nop			;0841
	push hl			;0842
	push af			;0843
	ld hl,0084dh		;0844
	call 0098bh		;0847
	pop af			;084a
	pop hl			;084b
	ret			;084c
	ld c,h			;084d
	ld b,l			;084e
	ld b,(hl)		;084f
	ld d,h			;0850
	ld b,e			;0851
	nop			;0852
	push hl			;0853
	push af			;0854
	ld hl,0085eh		;0855
	call 0098bh		;0858
	pop af			;085b
	pop hl			;085c
	ret			;085d
	ld d,l			;085e
	ld d,b			;085f
	ld b,e			;0860
	nop			;0861
	push hl			;0862
	push af			;0863
	ld hl,0086dh		;0864
	call 0098bh		;0867
	pop af			;086a
	pop hl			;086b
	ret			;086c
	ld d,h			;086d
	ld d,l			;086e
	ld d,b			;086f
	ld b,e			;0870
	nop			;0871
	push hl			;0872
	push af			;0873
	ld hl,0087dh		;0874
	call 0098bh		;0877
	pop af			;087a
	pop hl			;087b
	ret			;087c
	ld b,h			;087d
	ld c,a			;087e
	ld d,a			;087f
	ld c,(hl)		;0880
	ld b,e			;0881
	nop			;0882
	push hl			;0883
	push af			;0884
	ld hl,0088eh		;0885
	call 0098bh		;0888
	pop af			;088b
	pop hl			;088c
	ret			;088d
	ld d,h			;088e
	ld b,h			;088f
	ld c,a			;0890
	ld d,a			;0891
	ld c,(hl)		;0892
	ld b,e			;0893
	nop			;0894
	ld bc,(0fcb7h)		;0895
	ld de,(0fcb9h)		;0899
	ret			;089d
	ld d,e			;089e
	ld b,e			;089f
	ld b,c			;08a0
	ld c,h			;08a1
	ld e,b			;08a2
	ld e,c			;08a3
	nop			;08a4
	push bc			;08a5
	ld (0fcb7h),bc		;08a6
	ld (0fcb9h),de		;08aa
	ld hl,(0fcb9h)		;08ae
	add hl,hl		;08b1
	add hl,hl		;08b2
	add hl,hl		;08b3
	add hl,hl		;08b4
	add hl,hl		;08b5
	ld l,000h		;08b6
	ld b,000h		;08b8
	ld a,0ffh		;08ba
	ld (0f92ch),a		;08bc
	ld a,c			;08bf
	and 007h		;08c0
	jr z,$+12		;08c2
	ld b,a			;08c4
	ld a,0ffh		;08c5
	and a			;08c7
	rra			;08c8
	djnz $-2		;08c9
	ld (0f92ch),a		;08cb
	ld a,c			;08ce
	and 0f8h		;08cf
	ld c,a			;08d1
	ld b,000h		;08d2
	add hl,bc		;08d4
	ld (0f92ah),hl		;08d5
	pop bc			;08d8
	ret			;08d9
	ld c,l			;08da
	ld b,c			;08db
	ld d,b			;08dc
	ld e,b			;08dd
	ld e,c			;08de
	nop			;08df
	ld a,(0f92ch)		;08e0
	ld hl,(0f92ah)		;08e3
	ret			;08e6
	ld b,(hl)		;08e7
	ld b,l			;08e8
	ld d,h			;08e9
	ld b,e			;08ea
	ld c,b			;08eb
	ld b,e			;08ec
	nop			;08ed
	push hl			;08ee
	push af			;08ef
	ld hl,008f9h		;08f0
	call 0098bh		;08f3
	pop af			;08f6
	pop hl			;08f7
	ret			;08f8
	ld d,e			;08f9
	ld d,h			;08fa
	ld c,a			;08fb
	ld d,d			;08fc
	ld b,l			;08fd
	ld b,e			;08fe
	nop			;08ff
	push hl			;0900
	push af			;0901
	ld hl,0090bh		;0902
	call 0098bh		;0905
	pop af			;0908
	pop hl			;0909
	ret			;090a
	ld d,e			;090b
	ld b,l			;090c
	ld d,h			;090d
	ld b,c			;090e
	ld d,h			;090f
	ld d,d			;0910
	nop			;0911
	push hl			;0912
	push af			;0913
	ld hl,0091dh		;0914
	call 0098bh		;0917
	pop af			;091a
	pop hl			;091b
	ret			;091c
	ld d,d			;091d
	ld b,l			;091e
	ld b,c			;091f
	ld b,h			;0920
	ld b,e			;0921
	nop			;0922
	push hl			;0923
	push af			;0924
	ld hl,0092eh		;0925
	call 0098bh		;0928
	pop af			;092b
	pop hl			;092c
	ret			;092d
	ld d,e			;092e
	ld b,l			;092f
	ld d,h			;0930
	ld b,e			;0931
	nop			;0932
	push hl			;0933
	push af			;0934
	ld hl,0093eh		;0935
	call 0098bh		;0938
	pop af			;093b
	pop hl			;093c
	ret			;093d
	ld c,(hl)		;093e
	ld d,e			;093f
	ld b,l			;0940
	ld d,h			;0941
	ld b,e			;0942
	ld e,b			;0943
	nop			;0944
	push hl			;0945
	push af			;0946
	ld hl,00950h		;0947
	call 0098bh		;094a
	pop af			;094d
	pop hl			;094e
	ret			;094f
	ld b,a			;0950
	ld d,h			;0951
	ld b,c			;0952
	ld d,e			;0953
	ld d,b			;0954
	ld b,e			;0955
	nop			;0956
	push hl			;0957
	push af			;0958
	ld hl,00962h		;0959
	call 0098bh		;095c
	pop af			;095f
	pop hl			;0960
	ret			;0961
	ld d,b			;0962
	ld c,(hl)		;0963
	ld d,h			;0964
	ld c,c			;0965
	ld c,(hl)		;0966
	ld c,c			;0967
	nop			;0968
	push hl			;0969
	push af			;096a
	ld hl,00974h		;096b
	call 0098bh		;096e
	pop af			;0971
	pop hl			;0972
	ret			;0973
	ld d,e			;0974
	ld b,e			;0975
	ld b,c			;0976
	ld c,(hl)		;0977
	ld d,d			;0978
	nop			;0979
	push hl			;097a
	push af			;097b
	ld hl,00985h		;097c
	call 0098bh		;097f
	pop af			;0982
	pop hl			;0983
	ret			;0984
	ld d,e			;0985
	ld b,e			;0986
	ld b,c			;0987
	ld c,(hl)		;0988
	ld c,h			;0989
	nop			;098a
	ld a,023h		;098b
	out (02eh),a		;098d
	call 00997h		;098f
	ld a,000h		;0992
	out (02eh),a		;0994
	ret			;0996
	ld a,(hl)		;0997
	inc hl			;0998
	or a			;0999
	ret z			;099a
	out (02fh),a		;099b
	jr $-6			;099d
	and 00fh		;099f
	cp 00ah			;09a1
	jr nc,$+7		;09a3
	add a,030h		;09a5
	out (02fh),a		;09a7
	ret			;09a9
	add a,037h		;09aa
	out (02fh),a		;09ac
	ret			;09ae
	push af			;09af
	rrca			;09b0
	rrca			;09b1
	rrca			;09b2
	rrca			;09b3
	call 0099fh		;09b4
	pop af			;09b7
	call 0099fh		;09b8
	ret			;09bb
	ld a,h			;09bc
	call 009afh		;09bd
	ld a,l			;09c0
	call 009afh		;09c1
	ret			;09c4
	nop			;09c5
	nop			;09c6
	nop			;09c7
	nop			;09c8
	nop			;09c9
	nop			;09ca
	nop			;09cb
	nop			;09cc
	nop			;09cd
	nop			;09ce
	nop			;09cf
	nop			;09d0
	nop			;09d1
	nop			;09d2
	nop			;09d3
	nop			;09d4
	nop			;09d5
	nop			;09d6
	nop			;09d7
	nop			;09d8
	nop			;09d9
	nop			;09da
	nop			;09db
	nop			;09dc
	nop			;09dd
	nop			;09de
	nop			;09df
	nop			;09e0
	nop			;09e1
	nop			;09e2
	nop			;09e3
	nop			;09e4
	nop			;09e5
	nop			;09e6
	nop			;09e7
	nop			;09e8
	nop			;09e9
	nop			;09ea
	nop			;09eb
	nop			;09ec
	nop			;09ed
	nop			;09ee
	nop			;09ef
	nop			;09f0
	nop			;09f1
	nop			;09f2
	nop			;09f3
	nop			;09f4
	nop			;09f5
	nop			;09f6
	nop			;09f7
	nop			;09f8
	nop			;09f9
	nop			;09fa
	nop			;09fb
	nop			;09fc
	nop			;09fd
	nop			;09fe
	nop			;09ff
	nop			;0a00
	nop			;0a01
	nop			;0a02
	nop			;0a03
	nop			;0a04
	nop			;0a05
	nop			;0a06
	nop			;0a07
	nop			;0a08
	nop			;0a09
	nop			;0a0a
	nop			;0a0b
	nop			;0a0c
	nop			;0a0d
	nop			;0a0e
	nop			;0a0f
	nop			;0a10
	nop			;0a11
	nop			;0a12
	nop			;0a13
	nop			;0a14
	nop			;0a15
	nop			;0a16
	nop			;0a17
	nop			;0a18
	nop			;0a19
	nop			;0a1a
	nop			;0a1b
	nop			;0a1c
	nop			;0a1d
	nop			;0a1e
	nop			;0a1f
	nop			;0a20
	nop			;0a21
	nop			;0a22
	nop			;0a23
	nop			;0a24
	nop			;0a25
	nop			;0a26
	nop			;0a27
	nop			;0a28
	nop			;0a29
	nop			;0a2a
	nop			;0a2b
	nop			;0a2c
	nop			;0a2d
	nop			;0a2e
	nop			;0a2f
	nop			;0a30
	nop			;0a31
	nop			;0a32
	nop			;0a33
	nop			;0a34
	nop			;0a35
	nop			;0a36
	nop			;0a37
	nop			;0a38
	nop			;0a39
	nop			;0a3a
	nop			;0a3b
	nop			;0a3c
	nop			;0a3d
	nop			;0a3e
	nop			;0a3f
	nop			;0a40
	nop			;0a41
	nop			;0a42
	nop			;0a43
	nop			;0a44
	nop			;0a45
	nop			;0a46
	nop			;0a47
	nop			;0a48
	nop			;0a49
	nop			;0a4a
	nop			;0a4b
	nop			;0a4c
	nop			;0a4d
	nop			;0a4e
	nop			;0a4f
	nop			;0a50
	nop			;0a51
	nop			;0a52
	nop			;0a53
	nop			;0a54
	nop			;0a55
	nop			;0a56
	nop			;0a57
	nop			;0a58
	nop			;0a59
	nop			;0a5a
	nop			;0a5b
	nop			;0a5c
	nop			;0a5d
	nop			;0a5e
	nop			;0a5f
	nop			;0a60
	nop			;0a61
	nop			;0a62
	nop			;0a63
	nop			;0a64
	nop			;0a65
	nop			;0a66
	nop			;0a67
	nop			;0a68
	nop			;0a69
	nop			;0a6a
	nop			;0a6b
	nop			;0a6c
	nop			;0a6d
	nop			;0a6e
	nop			;0a6f
	nop			;0a70
	nop			;0a71
	nop			;0a72
	nop			;0a73
	nop			;0a74
	nop			;0a75
	nop			;0a76
	nop			;0a77
	nop			;0a78
	nop			;0a79
	nop			;0a7a
	nop			;0a7b
	nop			;0a7c
	nop			;0a7d
	nop			;0a7e
	nop			;0a7f
	nop			;0a80
	nop			;0a81
	nop			;0a82
	nop			;0a83
	nop			;0a84
	nop			;0a85
	nop			;0a86
	nop			;0a87
	nop			;0a88
	nop			;0a89
	nop			;0a8a
	nop			;0a8b
	nop			;0a8c
	nop			;0a8d
	nop			;0a8e
	nop			;0a8f
	nop			;0a90
	nop			;0a91
	nop			;0a92
	nop			;0a93
	nop			;0a94
	nop			;0a95
	nop			;0a96
	nop			;0a97
	nop			;0a98
	nop			;0a99
	nop			;0a9a
	nop			;0a9b
	nop			;0a9c
	nop			;0a9d
	nop			;0a9e
	nop			;0a9f
	nop			;0aa0
	nop			;0aa1
	nop			;0aa2
	nop			;0aa3
	nop			;0aa4
	nop			;0aa5
	nop			;0aa6
	nop			;0aa7
	nop			;0aa8
	nop			;0aa9
	nop			;0aaa
	nop			;0aab
	nop			;0aac
	nop			;0aad
	nop			;0aae
	nop			;0aaf
	nop			;0ab0
	nop			;0ab1
	nop			;0ab2
	nop			;0ab3
	nop			;0ab4
	nop			;0ab5
	nop			;0ab6
	nop			;0ab7
	nop			;0ab8
	nop			;0ab9
	nop			;0aba
	nop			;0abb
	nop			;0abc
	nop			;0abd
	nop			;0abe
	nop			;0abf
	nop			;0ac0
	nop			;0ac1
	nop			;0ac2
	nop			;0ac3
	nop			;0ac4
	nop			;0ac5
	nop			;0ac6
	nop			;0ac7
	nop			;0ac8
	nop			;0ac9
	nop			;0aca
	nop			;0acb
	nop			;0acc
	nop			;0acd
	nop			;0ace
	nop			;0acf
	nop			;0ad0
	nop			;0ad1
	nop			;0ad2
	nop			;0ad3
	nop			;0ad4
	nop			;0ad5
	nop			;0ad6
	nop			;0ad7
	nop			;0ad8
	nop			;0ad9
	nop			;0ada
	nop			;0adb
	nop			;0adc
	nop			;0add
	nop			;0ade
	nop			;0adf
	nop			;0ae0
	nop			;0ae1
	nop			;0ae2
	nop			;0ae3
	nop			;0ae4
	nop			;0ae5
	nop			;0ae6
	nop			;0ae7
	nop			;0ae8
	nop			;0ae9
	nop			;0aea
	nop			;0aeb
	nop			;0aec
	nop			;0aed
	nop			;0aee
	nop			;0aef
	nop			;0af0
	nop			;0af1
	nop			;0af2
	nop			;0af3
	nop			;0af4
	nop			;0af5
	nop			;0af6
	nop			;0af7
	nop			;0af8
	nop			;0af9
	nop			;0afa
	nop			;0afb
	nop			;0afc
	nop			;0afd
	nop			;0afe
	nop			;0aff
	nop			;0b00
	nop			;0b01
	nop			;0b02
	nop			;0b03
	nop			;0b04
	nop			;0b05
	nop			;0b06
	nop			;0b07
	nop			;0b08
	nop			;0b09
	nop			;0b0a
	nop			;0b0b
	nop			;0b0c
	nop			;0b0d
	nop			;0b0e
	nop			;0b0f
	nop			;0b10
	nop			;0b11
	nop			;0b12
	nop			;0b13
	nop			;0b14
	nop			;0b15
	nop			;0b16
	nop			;0b17
	nop			;0b18
	nop			;0b19
	nop			;0b1a
	nop			;0b1b
	nop			;0b1c
	nop			;0b1d
	nop			;0b1e
	nop			;0b1f
	nop			;0b20
	nop			;0b21
	nop			;0b22
	nop			;0b23
	nop			;0b24
	nop			;0b25
	nop			;0b26
	nop			;0b27
	nop			;0b28
	nop			;0b29
	nop			;0b2a
	nop			;0b2b
	nop			;0b2c
	nop			;0b2d
	nop			;0b2e
	nop			;0b2f
	nop			;0b30
	nop			;0b31
	nop			;0b32
	nop			;0b33
	nop			;0b34
	nop			;0b35
	nop			;0b36
	nop			;0b37
	nop			;0b38
	nop			;0b39
	nop			;0b3a
	nop			;0b3b
	nop			;0b3c
	nop			;0b3d
	nop			;0b3e
	nop			;0b3f
	nop			;0b40
	nop			;0b41
	nop			;0b42
	nop			;0b43
	nop			;0b44
	nop			;0b45
	nop			;0b46
	nop			;0b47
	nop			;0b48
	nop			;0b49
	nop			;0b4a
	nop			;0b4b
	nop			;0b4c
	nop			;0b4d
	nop			;0b4e
	nop			;0b4f
	nop			;0b50
	nop			;0b51
	nop			;0b52
	nop			;0b53
	nop			;0b54
	nop			;0b55
	nop			;0b56
	nop			;0b57
	nop			;0b58
	nop			;0b59
	nop			;0b5a
	nop			;0b5b
	nop			;0b5c
	nop			;0b5d
	nop			;0b5e
	nop			;0b5f
	nop			;0b60
	nop			;0b61
	nop			;0b62
	nop			;0b63
	nop			;0b64
	nop			;0b65
	nop			;0b66
	nop			;0b67
	nop			;0b68
	nop			;0b69
	nop			;0b6a
	nop			;0b6b
	nop			;0b6c
	nop			;0b6d
	nop			;0b6e
	nop			;0b6f
	nop			;0b70
	nop			;0b71
	nop			;0b72
	nop			;0b73
	nop			;0b74
	nop			;0b75
	nop			;0b76
	nop			;0b77
	nop			;0b78
	nop			;0b79
	nop			;0b7a
	nop			;0b7b
	nop			;0b7c
	nop			;0b7d
	nop			;0b7e
	nop			;0b7f
	nop			;0b80
	nop			;0b81
	nop			;0b82
	nop			;0b83
	nop			;0b84
	nop			;0b85
	nop			;0b86
	nop			;0b87
	nop			;0b88
	nop			;0b89
	nop			;0b8a
	nop			;0b8b
	nop			;0b8c
	nop			;0b8d
	nop			;0b8e
	nop			;0b8f
	nop			;0b90
	nop			;0b91
	nop			;0b92
	nop			;0b93
	nop			;0b94
	nop			;0b95
	nop			;0b96
	nop			;0b97
	nop			;0b98
	nop			;0b99
	nop			;0b9a
	nop			;0b9b
	nop			;0b9c
	nop			;0b9d
	nop			;0b9e
	nop			;0b9f
	nop			;0ba0
	nop			;0ba1
	nop			;0ba2
	nop			;0ba3
	nop			;0ba4
	nop			;0ba5
	nop			;0ba6
	nop			;0ba7
	nop			;0ba8
	nop			;0ba9
	nop			;0baa
	nop			;0bab
	nop			;0bac
	nop			;0bad
	nop			;0bae
	nop			;0baf
	nop			;0bb0
	nop			;0bb1
	nop			;0bb2
	nop			;0bb3
	nop			;0bb4
	nop			;0bb5
	nop			;0bb6
	nop			;0bb7
	nop			;0bb8
	nop			;0bb9
	nop			;0bba
	nop			;0bbb
	nop			;0bbc
	nop			;0bbd
	nop			;0bbe
	nop			;0bbf
	nop			;0bc0
	nop			;0bc1
	nop			;0bc2
	nop			;0bc3
	nop			;0bc4
	nop			;0bc5
	nop			;0bc6
	nop			;0bc7
	nop			;0bc8
	nop			;0bc9
	nop			;0bca
	nop			;0bcb
	nop			;0bcc
	nop			;0bcd
	nop			;0bce
	nop			;0bcf
	nop			;0bd0
	nop			;0bd1
	nop			;0bd2
	nop			;0bd3
	nop			;0bd4
	nop			;0bd5
	nop			;0bd6
	nop			;0bd7
	nop			;0bd8
	nop			;0bd9
	nop			;0bda
	nop			;0bdb
	nop			;0bdc
	nop			;0bdd
	nop			;0bde
	nop			;0bdf
	nop			;0be0
	nop			;0be1
	nop			;0be2
	nop			;0be3
	nop			;0be4
	nop			;0be5
	nop			;0be6
	nop			;0be7
	nop			;0be8
	nop			;0be9
	nop			;0bea
	nop			;0beb
	nop			;0bec
	nop			;0bed
	nop			;0bee
	nop			;0bef
	nop			;0bf0
	nop			;0bf1
	nop			;0bf2
	nop			;0bf3
	nop			;0bf4
	nop			;0bf5
	nop			;0bf6
	nop			;0bf7
	nop			;0bf8
	nop			;0bf9
	nop			;0bfa
	nop			;0bfb
	nop			;0bfc
	nop			;0bfd
	nop			;0bfe
	nop			;0bff
	nop			;0c00
	nop			;0c01
	nop			;0c02
	nop			;0c03
	nop			;0c04
	nop			;0c05
	nop			;0c06
	nop			;0c07
	nop			;0c08
	nop			;0c09
	nop			;0c0a
	nop			;0c0b
	nop			;0c0c
	nop			;0c0d
	nop			;0c0e
	nop			;0c0f
	nop			;0c10
	nop			;0c11
	nop			;0c12
	nop			;0c13
	nop			;0c14
	nop			;0c15
	nop			;0c16
	nop			;0c17
	nop			;0c18
	nop			;0c19
	nop			;0c1a
	nop			;0c1b
	nop			;0c1c
	nop			;0c1d
	nop			;0c1e
	nop			;0c1f
	nop			;0c20
	nop			;0c21
	nop			;0c22
	nop			;0c23
	nop			;0c24
	nop			;0c25
	nop			;0c26
	nop			;0c27
	nop			;0c28
	nop			;0c29
	nop			;0c2a
	nop			;0c2b
	nop			;0c2c
	nop			;0c2d
	nop			;0c2e
	nop			;0c2f
	nop			;0c30
	nop			;0c31
	nop			;0c32
	nop			;0c33
	nop			;0c34
	nop			;0c35
	nop			;0c36
	nop			;0c37
	nop			;0c38
	nop			;0c39
	nop			;0c3a
	nop			;0c3b
	nop			;0c3c
	nop			;0c3d
	nop			;0c3e
	nop			;0c3f
	nop			;0c40
	nop			;0c41
	nop			;0c42
	nop			;0c43
	nop			;0c44
	nop			;0c45
	nop			;0c46
	nop			;0c47
	nop			;0c48
	nop			;0c49
	nop			;0c4a
	nop			;0c4b
	nop			;0c4c
	nop			;0c4d
	nop			;0c4e
	nop			;0c4f
	nop			;0c50
	nop			;0c51
	nop			;0c52
	nop			;0c53
	nop			;0c54
	nop			;0c55
	nop			;0c56
	nop			;0c57
	nop			;0c58
	nop			;0c59
	nop			;0c5a
	nop			;0c5b
	nop			;0c5c
	nop			;0c5d
	nop			;0c5e
	nop			;0c5f
	nop			;0c60
	nop			;0c61
	nop			;0c62
	nop			;0c63
	nop			;0c64
	nop			;0c65
	nop			;0c66
	nop			;0c67
	nop			;0c68
	nop			;0c69
	nop			;0c6a
	nop			;0c6b
	nop			;0c6c
	nop			;0c6d
	nop			;0c6e
	nop			;0c6f
	nop			;0c70
	nop			;0c71
	nop			;0c72
	nop			;0c73
	nop			;0c74
	nop			;0c75
	nop			;0c76
	nop			;0c77
	nop			;0c78
	nop			;0c79
	nop			;0c7a
	nop			;0c7b
	nop			;0c7c
	nop			;0c7d
	nop			;0c7e
	nop			;0c7f
	nop			;0c80
	nop			;0c81
	nop			;0c82
	nop			;0c83
	nop			;0c84
	nop			;0c85
	nop			;0c86
	nop			;0c87
	nop			;0c88
	nop			;0c89
	nop			;0c8a
	nop			;0c8b
	nop			;0c8c
	nop			;0c8d
	nop			;0c8e
	nop			;0c8f
	nop			;0c90
	nop			;0c91
	nop			;0c92
	nop			;0c93
	nop			;0c94
	nop			;0c95
	nop			;0c96
	nop			;0c97
	nop			;0c98
	nop			;0c99
	nop			;0c9a
	nop			;0c9b
	nop			;0c9c
	nop			;0c9d
	nop			;0c9e
	nop			;0c9f
	nop			;0ca0
	nop			;0ca1
	nop			;0ca2
	nop			;0ca3
	nop			;0ca4
	nop			;0ca5
	nop			;0ca6
	nop			;0ca7
	nop			;0ca8
	nop			;0ca9
	nop			;0caa
	nop			;0cab
	nop			;0cac
	nop			;0cad
	nop			;0cae
	nop			;0caf
	nop			;0cb0
	nop			;0cb1
	nop			;0cb2
	nop			;0cb3
	nop			;0cb4
	nop			;0cb5
	nop			;0cb6
	nop			;0cb7
	nop			;0cb8
	nop			;0cb9
	nop			;0cba
	nop			;0cbb
	nop			;0cbc
	nop			;0cbd
	nop			;0cbe
	nop			;0cbf
	nop			;0cc0
	nop			;0cc1
	nop			;0cc2
	nop			;0cc3
	nop			;0cc4
	nop			;0cc5
	nop			;0cc6
	nop			;0cc7
	nop			;0cc8
	nop			;0cc9
	nop			;0cca
	nop			;0ccb
	nop			;0ccc
	nop			;0ccd
	nop			;0cce
	nop			;0ccf
	nop			;0cd0
	nop			;0cd1
	nop			;0cd2
	nop			;0cd3
	nop			;0cd4
	nop			;0cd5
	nop			;0cd6
	nop			;0cd7
	nop			;0cd8
	nop			;0cd9
	nop			;0cda
	nop			;0cdb
	nop			;0cdc
	nop			;0cdd
	nop			;0cde
	nop			;0cdf
	nop			;0ce0
	nop			;0ce1
	nop			;0ce2
	nop			;0ce3
	nop			;0ce4
	nop			;0ce5
	nop			;0ce6
	nop			;0ce7
	nop			;0ce8
	nop			;0ce9
	nop			;0cea
	nop			;0ceb
	nop			;0cec
	nop			;0ced
	nop			;0cee
	nop			;0cef
	nop			;0cf0
	nop			;0cf1
	nop			;0cf2
	nop			;0cf3
	nop			;0cf4
	nop			;0cf5
	nop			;0cf6
	nop			;0cf7
	nop			;0cf8
	nop			;0cf9
	nop			;0cfa
	nop			;0cfb
	nop			;0cfc
	nop			;0cfd
	nop			;0cfe
	nop			;0cff
	nop			;0d00
	ret			;0d01
	pop ix			;0d02
	pop iy			;0d04
	pop af			;0d06
	pop bc			;0d07
	pop de			;0d08
	pop hl			;0d09
	exx			;0d0a
	ex af,af'		;0d0b
	pop af			;0d0c
	pop bc			;0d0d
	pop de			;0d0e
	pop hl			;0d0f
	ei			;0d10
	ret			;0d11
	ld a,082h		;0d12
	out (0abh),a		;0d14
	ld a,050h		;0d16
	out (0aah),a		;0d18
	xor a			;0d1a
	out (0ffh),a		;0d1b
	inc a			;0d1d
	out (0feh),a		;0d1e
	inc a			;0d20
	out (0fdh),a		;0d21
	inc a			;0d23
	out (0fch),a		;0d24
	ld hl,0ffffh		;0d26
	exx			;0d29
	in a,(0a8h)		;0d2a
	or 0f0h			;0d2c
	ld b,a			;0d2e
	ld a,b			;0d2f
	out (0a8h),a		;0d30
	ld a,(0ffffh)		;0d32
	cpl			;0d35
	or 0f0h			;0d36
	ld c,a			;0d38
	ld a,c			;0d39
	ld (0ffffh),a		;0d3a
	ld hl,0ff00h		;0d3d
	ld a,00fh		;0d40
	ld (hl),a		;0d42
	cp (hl)			;0d43
	jr nz,$+10		;0d44
	cpl			;0d46
	ld (hl),a		;0d47
	cp (hl)			;0d48
	jr nz,$+5		;0d49
	dec h			;0d4b
	jr $-12			;0d4c
	inc h			;0d4e
	ld a,h			;0d4f
	or a			;0d50
	jr z,$+23		;0d51
	exx			;0d53
	cp h			;0d54
	jr c,$+7		;0d55
	jr z,$+5		;0d57
	exx			;0d59
	jr $+14			;0d5a
	ld l,000h		;0d5c
	ld h,a			;0d5e
	exx			;0d5f
	ld a,b			;0d60
	exx			;0d61
	ld b,a			;0d62
	exx			;0d63
	ld a,c			;0d64
	exx			;0d65
	ld c,a			;0d66
	exx			;0d67
	ld a,c			;0d68
	sub 010h		;0d69
	ld c,a			;0d6b
	jr nc,$-51		;0d6c
	ld a,b			;0d6e
	sub 010h		;0d6f
	ld b,a			;0d71
	jr nc,$-67		;0d72
	exx			;0d74
	ld a,l			;0d75
	or a			;0d76
	jr z,$+8		;0d77
	ld de,025b2h		;0d79
	jp 01aaeh		;0d7c
	ld a,b			;0d7f
	out (0a8h),a		;0d80
	ld a,c			;0d82
	ld (0ffffh),a		;0d83
	exx			;0d86
	ld hl,0f300h		;0d87
	ld sp,hl		;0d8a
	call 00f39h		;0d8b
	call 01068h		;0d8e
	call 0073fh		;0d91
	xor a			;0d94
	ld (0f3ech),a		;0d95
	ei			;0d98
	call 01173h		;0d99
	ld b,00fh		;0d9c
	ld de,00e1ch		;0d9e
	ld hl,08000h		;0da1
	push bc			;0da4
	push hl			;0da5
	push de			;0da6
	ld a,(0fcc1h)		;0da7
	call 023bfh		;0daa
	pop hl			;0dad
	pop de			;0dae
	pop bc			;0daf
	cp (hl)			;0db0
	jr nz,$+20		;0db1
	ex de,hl		;0db3
	inc de			;0db4
	inc hl			;0db5
	djnz $-18		;0db6
	ld ix,08010h		;0db8
	ld iy,(0fcc0h)		;0dbc
	call 02434h		;0dc0
	jr $+26			;0dc3
	ld a,005h		;0dc5
	ld (0f3eah),a		;0dc7
	ld (0f3ebh),a		;0dca
	call 003b4h		;0dcd
	ld hl,00e2bh		;0dd0
	ld de,(0f922h)		;0dd3
	ld bc,0001dh		;0dd7
	call 00291h		;0dda
	ei			;0ddd
	ld b,078h		;0dde
	call 010afh		;0de0
	ld a,00fh		;0de3
	ld (0f3e9h),a		;0de5
	ld a,005h		;0de8
	ld (0f3eah),a		;0dea
	ld (0f3ebh),a		;0ded
	ld a,01dh		;0df0
	ld (0f3afh),a		;0df2
	call 003b4h		;0df5
	ld hl,02556h		;0df8
	call 010b3h		;0dfb
	call 00e48h		;0dfe
	call 0fedah		;0e01
	call 00f23h		;0e04
	ld a,001h		;0e07
	ld (0fd99h),a		;0e09
	xor a			;0e0c
	ld (0fb29h),a		;0e0d
	call 0fecbh		;0e10
	ld hl,025ech		;0e13
	call 010b3h		;0e16
	jp 01a8ch		;0e19
	ld b,e			;0e1c
	dec l			;0e1d
	ld b,d			;0e1e
	ld c,c			;0e1f
	ld c,a			;0e20
	ld d,e			;0e21
	jr nz,$+78		;0e22
	ld l,a			;0e24
	ld h,a			;0e25
	ld l,a			;0e26
	jr nz,$+84		;0e27
	ld c,a			;0e29
	ld c,l			;0e2a
	ld b,e			;0e2b
	dec l			;0e2c
	ld b,d			;0e2d
	ld c,c			;0e2e
	ld c,a			;0e2f
	ld d,e			;0e30
	jr nz,$+50		;0e31
	ld l,032h		;0e33
	inc sp			;0e35
	jr nz,$+34		;0e36
	jr nz,$+34		;0e38
	jr nz,$+34		;0e3a
	ld h,e			;0e3c
	ld h,d			;0e3d
	ld l,c			;0e3e
	ld l,a			;0e3f
	ld (hl),e		;0e40
	ld l,073h		;0e41
	ld h,(hl)		;0e43
	ld l,06eh		;0e44
	ld h,l			;0e46
	ld (hl),h		;0e47
	ld hl,0fcc9h		;0e48
	ld de,0fccah		;0e4b
	ld bc,0003fh		;0e4e
	ld (hl),000h		;0e51
	ldir			;0e53
	ld hl,0fcc1h		;0e55
	xor a			;0e58
	push hl			;0e59
	or (hl)			;0e5a
	ld hl,04000h		;0e5b
	call 00e8fh		;0e5e
	call z,00e9ch		;0e61
	ld hl,08000h		;0e64
	call 00e8fh		;0e67
	call z,00e9ch		;0e6a
	bit 7,a			;0e6d
	jr z,$+8		;0e6f
	add a,004h		;0e71
	bit 4,a			;0e73
	jr z,$-26		;0e75
	pop hl			;0e77
	inc hl			;0e78
	inc a			;0e79
	and 003h		;0e7a
	jr nz,$-35		;0e7c
	ret			;0e7e
	ld b,a			;0e7f
	call 023bfh		;0e80
	inc hl			;0e83
	push af			;0e84
	ld a,b			;0e85
	call 023bfh		;0e86
	inc hl			;0e89
	ld d,a			;0e8a
	pop af			;0e8b
	ld e,a			;0e8c
	ld a,b			;0e8d
	ret			;0e8e
	push hl			;0e8f
	call 00e7fh		;0e90
	ld hl,04241h		;0e93
	call 01146h		;0e96
	ld a,b			;0e99
	pop hl			;0e9a
	ret			;0e9b
	push hl			;0e9c
	push af			;0e9d
	ld hl,0257ah		;0e9e
	call 010b3h		;0ea1
	pop af			;0ea4
	push af			;0ea5
	ld b,a			;0ea6
	and 003h		;0ea7
	add a,030h		;0ea9
	call 011d9h		;0eab
	ld a,b			;0eae
	bit 7,b			;0eaf
	jr z,$+17		;0eb1
	ld a,02eh		;0eb3
	call 011d9h		;0eb5
	ld a,b			;0eb8
	rrca			;0eb9
	rrca			;0eba
	and 003h		;0ebb
	add a,030h		;0ebd
	call 011d9h		;0ebf
	ld a,00dh		;0ec2
	call 011d9h		;0ec4
	ld a,00ah		;0ec7
	call 011d9h		;0ec9
	pop af			;0ecc
	pop hl			;0ecd
	inc hl			;0ece
	inc hl			;0ecf
	call 00f1ah		;0ed0
	jr z,$+19		;0ed3
	ld c,a			;0ed5
	push de			;0ed6
	pop ix			;0ed7
	push af			;0ed9
	pop iy			;0eda
	ei			;0edc
	halt			;0edd
	push af			;0ede
	push hl			;0edf
	call 02434h		;0ee0
	di			;0ee3
	pop hl			;0ee4
	pop af			;0ee5
	ld c,000h		;0ee6
	call 00f1ah		;0ee8
	jr z,$+4		;0eeb
	set 5,c			;0eed
	call 00f1ah		;0eef
	jr z,$+4		;0ef2
	set 6,c			;0ef4
	call 00f1ah		;0ef6
	jr z,$+4		;0ef9
	set 7,c			;0efb
	ld b,a			;0efd
	and 00ch		;0efe
	ld e,a			;0f00
	ld a,b			;0f01
	rlca			;0f02
	rlca			;0f03
	rlca			;0f04
	rlca			;0f05
	and 030h		;0f06
	or e			;0f08
	ld e,a			;0f09
	ld a,h			;0f0a
	rlca			;0f0b
	rlca			;0f0c
	and 003h		;0f0d
	or e			;0f0f
	ld hl,0fcc9h		;0f10
	ld d,000h		;0f13
	ld e,a			;0f15
	add hl,de		;0f16
	ld (hl),c		;0f17
	ld a,b			;0f18
	ret			;0f19
	push bc			;0f1a
	call 00e7fh		;0f1b
	ld a,d			;0f1e
	or e			;0f1f
	ld a,b			;0f20
	pop bc			;0f21
	ret			;0f22
	ld hl,0fcc9h		;0f23
	ld b,040h		;0f26
	ld a,(hl)		;0f28
	bit 7,a			;0f29
	jr z,$+10		;0f2b
	push hl			;0f2d
	ld hl,0258dh		;0f2e
	call 010b3h		;0f31
	pop hl			;0f34
	inc hl			;0f35
	djnz $-14		;0f36
	ret			;0f38
	ld a,000h		;0f39
	ld hl,0f380h		;0f3b
	ld (hl),a		;0f3e
	ld de,0f381h		;0f3f
	ld bc,00c7dh		;0f42
	ldir			;0f45
	ld a,0c9h		;0f47
	ld hl,0f300h		;0f49
	ld (hl),a		;0f4c
	ld de,0f301h		;0f4d
	ld bc,0007fh		;0f50
	ldir			;0f53
	ld a,0c9h		;0f55
	ld hl,0fd9ah		;0f57
	ld (hl),a		;0f5a
	ld de,0fd9bh		;0f5b
	ld bc,0024dh		;0f5e
	ldir			;0f61
	ld a,0ffh		;0f63
	ld hl,0fbdah		;0f65
	ld (hl),a		;0f68
	ld de,0fbdbh		;0f69
	ld bc,00015h		;0f6c
	ldir			;0f6f
	ld a,000h		;0f71
	ld hl,0fbf0h		;0f73
	ld (hl),a		;0f76
	ld de,0fbf1h		;0f77
	ld bc,00027h		;0f7a
	ldir			;0f7d
	ld hl,0fbf0h		;0f7f
	ld (0f3f8h),hl		;0f82
	ld (0f3fah),hl		;0f85
	exx			;0f88
	ld (0fc48h),hl		;0f89
	exx			;0f8c
	ld hl,0f380h		;0f8d
	ld (0fc4ah),hl		;0f90
	ld (0f674h),hl		;0f93
	ld hl,0253bh		;0f96
	ld de,0f380h		;0f99
	ld bc,0001ah		;0f9c
	ldir			;0f9f
	ld hl,00000h		;0fa1
	ld (0f3b3h),hl		;0fa4
	ld hl,00800h		;0fa7
	ld (0f3b7h),hl		;0faa
	ld hl,01800h		;0fad
	ld (0f3bdh),hl		;0fb0
	ld hl,02000h		;0fb3
	ld (0f3bfh),hl		;0fb6
	ld hl,00000h		;0fb9
	ld (0f3c1h),hl		;0fbc
	ld hl,01b00h		;0fbf
	ld (0f3c3h),hl		;0fc2
	ld hl,03800h		;0fc5
	ld (0f3c5h),hl		;0fc8
	ld hl,01800h		;0fcb
	ld (0f3c7h),hl		;0fce
	ld hl,02000h		;0fd1
	ld (0f3c9h),hl		;0fd4
	ld hl,00000h		;0fd7
	ld (0f3cbh),hl		;0fda
	ld hl,01b00h		;0fdd
	ld (0f3cdh),hl		;0fe0
	ld hl,03800h		;0fe3
	ld (0f3cfh),hl		;0fe6
	ld hl,00800h		;0fe9
	ld (0f3d1h),hl		;0fec
	ld hl,00000h		;0fef
	ld (0f3d5h),hl		;0ff2
	ld hl,01b00h		;0ff5
	ld (0f3d7h),hl		;0ff8
	ld hl,03800h		;0ffb
	ld (0f3d9h),hl		;0ffe
	ld hl,0f959h		;1001
	ld (0f3f3h),hl		;1004
	ld hl,0f975h		;1007
	ld (0f95dh),hl		;100a
	ld hl,0f9f5h		;100d
	ld (0f963h),hl		;1010
	ld hl,0fa75h		;1013
	ld (0f969h),hl		;1016
	ld a,07fh		;1019
	ld (0f95ch),a		;101b
	ld (0f962h),a		;101e
	ld (0f968h),a		;1021
	ld a,027h		;1024
	ld (0f3aeh),a		;1026
	ld a,020h		;1029
	ld (0f3afh),a		;102b
	ld a,(0f3afh)		;102e
	ld (0f3b0h),a		;1031
	ld a,018h		;1034
	ld (0f3b1h),a		;1036
	ld a,004h		;1039
	ld (0f3ebh),a		;103b
	ld (0f3eah),a		;103e
	ld a,00fh		;1041
	ld (0f3e9h),a		;1043
	ld a,0a0h		;1046
	ld (0f3e0h),a		;1048
	ld a,008h		;104b
	ld (0ffe7h),a		;104d
	ld a,(0fcc5h)		;1050
	ld (0f91fh),a		;1053
	ld hl,(00004h)		;1056
	ld (0f920h),hl		;1059
	ld a,0c3h		;105c
	ld hl,011d9h		;105e
	ld (0fee5h),hl		;1061
	ld (0fee4h),a		;1064
	ret			;1067
	di			;1068
	ld hl,0fcc1h		;1069
	in a,(0a8h)		;106c
	ld d,a			;106e
	and 03fh		;106f
	ld c,a			;1071
	out (0a8h),a		;1072
	ld a,(0ffffh)		;1074
	cpl			;1077
	ld e,a			;1078
	and 00fh		;1079
	ld (0ffffh),a		;107b
	ld b,a			;107e
	ld a,(0ffffh)		;107f
	cpl			;1082
	cp b			;1083
	jr nz,$+23		;1084
	ld a,e			;1086
	and 00fh		;1087
	or 050h			;1089
	ld (0ffffh),a		;108b
	ld b,a			;108e
	ld a,(0ffffh)		;108f
	cpl			;1092
	cp b			;1093
	jr nz,$+7		;1094
	ld b,080h		;1096
	ld a,e			;1098
	jr $+6			;1099
	ld b,000h		;109b
	ld a,e			;109d
	cpl			;109e
	ld (0ffffh),a		;109f
	ld a,d			;10a2
	out (0a8h),a		;10a3
	ld (hl),b		;10a5
	inc hl			;10a6
	ld a,c			;10a7
	add a,040h		;10a8
	ld c,a			;10aa
	jr nc,$-57		;10ab
	ei			;10ad
	ret			;10ae
	halt			;10af
	djnz $-1		;10b0
	ret			;10b2
	ld a,(0fcafh)		;10b3
	cp 005h			;10b6
	jr nc,$+11		;10b8
	ld a,(hl)		;10ba
	or a			;10bb
	ret z			;10bc
	call 011d9h		;10bd
	inc hl			;10c0
	jr $-7			;10c1
	ld a,(hl)		;10c3
	or a			;10c4
	ret z			;10c5
	ld ix,00089h		;10c6
	call 01a66h		;10ca
	inc hl			;10cd
	jr $-11			;10ce
	ld c,020h		;10d0
	ld a,(0fcafh)		;10d2
	or a			;10d5
	ret nz			;10d6
	ld c,028h		;10d7
	ld a,(0f3b0h)		;10d9
	cp 029h			;10dc
	ret c			;10de
	ld c,050h		;10df
	ret			;10e1
	push bc			;10e2
	push af			;10e3
	call 010d0h		;10e4
	ld a,(0f3b0h)		;10e7
	neg			;10ea
	add a,c			;10ec
	inc a			;10ed
	srl a			;10ee
	ld l,a			;10f0
	ld a,(0f3ddh)		;10f1
	dec a			;10f4
	add a,l			;10f5
	ld l,a			;10f6
	ld h,000h		;10f7
	ld b,h			;10f9
	ld a,(0f3dch)		;10fa
	dec a			;10fd
	srl a			;10fe
	jr nc,$+3		;1100
	add hl,bc		;1102
	sla c			;1103
	rl b			;1105
	or a			;1107
	jr nz,$-10		;1108
	ld bc,(0f922h)		;110a
	add hl,bc		;110e
	pop af			;110f
	pop bc			;1110
	ret			;1111
	push hl			;1112
	push af			;1113
	ld hl,0111dh		;1114
	call 0098bh		;1117
	pop af			;111a
	pop hl			;111b
	ret			;111c
	ld d,e			;111d
	ld e,c			;111e
	ld c,(hl)		;111f
	ld b,e			;1120
	ld c,b			;1121
	ld d,d			;1122
	nop			;1123
	call 0ff48h		;1124
	ld a,(hl)		;1127
	inc hl			;1128
	cp 000h			;1129
	ret z			;112b
	cp 03ah			;112c
	ret z			;112e
	cp 030h			;112f
	jr c,$+5		;1131
	cp 03ah			;1133
	ret c			;1135
	cp 020h			;1136
	jr z,$-17		;1138
	cp 009h			;113a
	jr z,$-21		;113c
	or a			;113e
	ret			;113f
	push af			;1140
	call 0fee4h		;1141
	pop af			;1144
	ret			;1145
	ld a,h			;1146
	cp d			;1147
	ret nz			;1148
	ld a,l			;1149
	cp e			;114a
	ret			;114b
	push hl			;114c
	push af			;114d
	ld hl,01157h		;114e
	call 0098bh		;1151
	pop af			;1154
	pop hl			;1155
	ret			;1156
	ld b,a			;1157
	ld b,l			;1158
	ld d,h			;1159
	ld e,c			;115a
	ld d,b			;115b
	ld d,d			;115c
	nop			;115d
	ex af,af'		;115e
	exx			;115f
	pop hl			;1160
	ld a,(hl)		;1161
	inc hl			;1162
	ld e,(hl)		;1163
	inc hl			;1164
	ld d,(hl)		;1165
	inc hl			;1166
	push de			;1167
	pop ix			;1168
	push af			;116a
	pop iy			;116b
	push hl			;116d
	ex af,af'		;116e
	exx			;116f
	jp 02434h		;1170
	ld e,08fh		;1173
	ld a,00fh		;1175
	call 01777h		;1177
	jp 0175fh		;117a
	push hl			;117d
	push af			;117e
	ld hl,01188h		;117f
	call 0098bh		;1182
	pop af			;1185
	pop hl			;1186
	ret			;1187
	ld c,c			;1188
	ld c,(hl)		;1189
	ld c,c			;118a
	ld b,(hl)		;118b
	ld c,(hl)		;118c
	ld c,e			;118d
	nop			;118e
	push hl			;118f
	push af			;1190
	ld hl,0119ah		;1191
	call 0098bh		;1194
	pop af			;1197
	pop hl			;1198
	ret			;1199
	ld d,e			;119a
	ld d,h			;119b
	ld d,d			;119c
	ld d,h			;119d
	ld c,l			;119e
	ld d,e			;119f
	nop			;11a0
	ei			;11a1
	push hl			;11a2
	push de			;11a3
	ld hl,(0f3fah)		;11a4
	ld de,(0f3f8h)		;11a7
	rst 20h			;11ab
	ld a,0ffh		;11ac
	jr nz,$+3		;11ae
	xor a			;11b0
	pop de			;11b1
	pop hl			;11b2
	ret			;11b3
	call 0fdc2h		;11b4
	push hl			;11b7
	push de			;11b8
	ld hl,(0f3fah)		;11b9
	ld de,(0f3f8h)		;11bc
	rst 20h			;11c0
	jr nz,$+6		;11c1
	ei			;11c3
	halt			;11c4
	jr $-12			;11c5
	ld a,(hl)		;11c7
	push af			;11c8
	inc hl			;11c9
	ld a,l			;11ca
	cp 018h			;11cb
	jr nz,$+5		;11cd
	ld hl,0fbf0h		;11cf
	ld (0f3fah),hl		;11d2
	pop af			;11d5
	pop de			;11d6
	pop hl			;11d7
	ret			;11d8
	push hl			;11d9
	push de			;11da
	push bc			;11db
	push af			;11dc
	call 0fda4h		;11dd
	ld a,(0fcafh)		;11e0
	cp 002h			;11e3
	jr nc,$+21		;11e5
	pop af			;11e7
	push af			;11e8
	call 01429h		;11e9
	pop af			;11ec
	push af			;11ed
	call 011ffh		;11ee
	call 0143eh		;11f1
	ld a,(0f3ddh)		;11f4
	ld (0f661h),a		;11f7
	pop af			;11fa
	pop bc			;11fb
	pop de			;11fc
	pop hl			;11fd
	ret			;11fe
	call 01536h		;11ff
	ret nc			;1202
	jr z,$+20		;1203
	push af			;1205
	ld a,(0fca7h)		;1206
	or a			;1209
	jp nz,012e2h		;120a
	pop af			;120d
	cp 020h			;120e
	jr c,$+44		;1210
	cp 07fh			;1212
	jp z,0141bh		;1214
	call 010e2h		;1217
	call 0024bh		;121a
	ld hl,(0f3dch)		;121d
	ld a,(0f3b0h)		;1220
	inc h			;1223
	cp h			;1224
	jr c,$+6		;1225
	ld (0f3dch),hl		;1227
	ret			;122a
	ld de,0fbb1h		;122b
	ld h,000h		;122e
	add hl,de		;1230
	xor a			;1231
	ld (hl),a		;1232
	ld hl,(0f3dch)		;1233
	call 01291h		;1236
	jp 01253h		;1239
	ld b,00ch		;123c
	ld hl,014adh		;123e
	jp 00208h		;1241
	ld a,020h		;1244
	call 01217h		;1246
	ld a,(0f3ddh)		;1249
	and 007h		;124c
	cp 001h			;124e
	jr nz,$-12		;1250
	ret			;1252
	ld hl,(0f3dch)		;1253
	ld a,(0f3b1h)		;1256
	inc l			;1259
	cp l			;125a
	jr nc,$+11		;125b
	push hl			;125d
	call 0126ah		;125e
	call 013b5h		;1261
	pop hl			;1264
	dec l			;1265
	ld (0f3dch),hl		;1266
	ret			;1269
	ld hl,00101h		;126a
	ld (0f3dch),hl		;126d
	ret			;1270
	call 01353h		;1271
	ld hl,(0f3dch)		;1274
	push hl			;1277
	call 01291h		;1278
	ld a,(0f3dch)		;127b
	ld hl,0f3b1h		;127e
	cp (hl)			;1281
	jr nc,$+10		;1282
	call 01253h		;1284
	call 01353h		;1287
	jr $-15			;128a
	pop hl			;128c
	ld (0f3dch),hl		;128d
	ret			;1290
	ld a,001h		;1291
	ld (0f3ddh),a		;1293
	ret			;1296
	ld a,0ffh		;1297
	ld (0fca7h),a		;1299
	ret			;129c
	ld a,(0f3ddh)		;129d
	ld hl,0f3b0h		;12a0
	cp (hl)			;12a3
	jr nc,$+5		;12a4
	inc a			;12a6
	jr $+33			;12a7
	ld a,(0f3dch)		;12a9
	ld hl,0f3b1h		;12ac
	cp (hl)			;12af
	ret nc			;12b0
	inc a			;12b1
	ld (0f3dch),a		;12b2
	jr $-36			;12b5
	ld a,(0f3ddh)		;12b7
	dec a			;12ba
	jr nz,$+13		;12bb
	ld a,(0f3dch)		;12bd
	dec a			;12c0
	ret z			;12c1
	ld (0f3dch),a		;12c2
	ld a,(0f3b0h)		;12c5
	ld (0f3ddh),a		;12c8
	ret			;12cb
	ld a,(0f3dch)		;12cc
	dec a			;12cf
	ret z			;12d0
	ld (0f3dch),a		;12d1
	ret			;12d4
	ld a,(0f3dch)		;12d5
	ld hl,0f3b1h		;12d8
	cp (hl)			;12db
	ret nc			;12dc
	inc a			;12dd
	ld (0f3dch),a		;12de
	ret			;12e1
	ld b,a			;12e2
	inc a			;12e3
	jr nz,$+14		;12e4
	ld (0fca7h),a		;12e6
	pop af			;12e9
	ld b,00fh		;12ea
	ld hl,014d1h		;12ec
	jp 00208h		;12ef
	pop af			;12f2
	djnz $+6		;12f3
	ld c,000h		;12f5
	jr $+6			;12f7
	djnz $+26		;12f9
	ld c,001h		;12fb
	cp 034h			;12fd
	jr z,$+8		;12ff
	cp 035h			;1301
	jr z,$+10		;1303
	jr $+48			;1305
	ld a,c			;1307
	ld (0fcaah),a		;1308
	jr $+42			;130b
	ld a,c			;130d
	ld (0fca9h),a		;130e
	jr $+36			;1311
	djnz $+10		;1313
	ld b,01fh		;1315
	sub b			;1317
	ld (0f3ddh),a		;1318
	jr $+26			;131b
	djnz $+24		;131d
	ld b,01fh		;131f
	sub b			;1321
	ld (0f3dch),a		;1322
	ld a,003h		;1325
	jr $+15			;1327
	ld a,001h		;1329
	jr $+11			;132b
	ld a,002h		;132d
	jr $+7			;132f
	ld a,004h		;1331
	jr $+3			;1333
	xor a			;1335
	ld (0fca7h),a		;1336
	ret			;1339
	ld a,(0f3ddh)		;133a
	ld hl,0f3b0h		;133d
	cp (hl)			;1340
	ret nc			;1341
	inc a			;1342
	ld (0f3ddh),a		;1343
	ret			;1346
	ld a,(0f3ddh)		;1347
	dec a			;134a
	ret z			;134b
	ld (0f3ddh),a		;134c
	ret			;134f
	call 01291h		;1350
	ld hl,0fbb1h		;1353
	ld a,(0f3dch)		;1356
	ld e,a			;1359
	ld d,000h		;135a
	add hl,de		;135c
	ld (hl),a		;135d
	ld a,(0f3b0h)		;135e
	inc a			;1361
	ld hl,0f3ddh		;1362
	sub (hl)		;1365
	ld c,a			;1366
	ld b,000h		;1367
	ld a,020h		;1369
	call 010e2h		;136b
	jp 0026bh		;136e
	call 01291h		;1371
	ld hl,(0f3dch)		;1374
	push hl			;1377
	ld b,l			;1378
	ld a,(0f3b1h)		;1379
	ld (0f3dch),a		;137c
	sub b			;137f
	ld b,a			;1380
	inc b			;1381
	ld a,(0f3dch)		;1382
	jr $+16			;1385
	call 010e2h		;1387
	ex de,hl		;138a
	dec a			;138b
	ld (0f3dch),a		;138c
	call 010e2h		;138f
	call 013f3h		;1392
	djnz $-14		;1395
	pop hl			;1397
	ld (0f3dch),hl		;1398
	ld h,000h		;139b
	ld a,(0f3b1h)		;139d
	ld d,a			;13a0
	ld e,000h		;13a1
	sub l			;13a3
	dec a			;13a4
	ld c,a			;13a5
	ld b,000h		;13a6
	ld hl,0fbb1h		;13a8
	add hl,de		;13ab
	ex de,hl		;13ac
	ld h,d			;13ad
	ld l,e			;13ae
	dec hl			;13af
	lddr			;13b0
	jp 01353h		;13b2
	call 01291h		;13b5
	ld hl,(0f3dch)		;13b8
	push hl			;13bb
	ld b,l			;13bc
	ld a,(0f3b1h)		;13bd
	sub b			;13c0
	ld b,a			;13c1
	inc b			;13c2
	ld a,(0f3dch)		;13c3
	jr $+16			;13c6
	call 010e2h		;13c8
	ex de,hl		;13cb
	inc a			;13cc
	ld (0f3dch),a		;13cd
	call 010e2h		;13d0
	call 013f3h		;13d3
	djnz $-14		;13d6
	call 01353h		;13d8
	pop hl			;13db
	ld (0f3dch),hl		;13dc
	ld h,000h		;13df
	ld a,(0f3b1h)		;13e1
	sub l			;13e4
	dec a			;13e5
	ld c,a			;13e6
	ld b,000h		;13e7
	ld de,0fbb1h		;13e9
	add hl,de		;13ec
	ld d,h			;13ed
	ld e,l			;13ee
	inc hl			;13ef
	ldir			;13f0
	ret			;13f2
	push af			;13f3
	push bc			;13f4
	ld b,000h		;13f5
	ld a,(0f3b0h)		;13f7
	ld c,a			;13fa
	call 01401h		;13fb
	pop bc			;13fe
	pop af			;13ff
	ret			;1400
	push hl			;1401
	push de			;1402
	push bc			;1403
	ld de,0fc18h		;1404
	call 0027eh		;1407
	pop bc			;140a
	pop de			;140b
	push de			;140c
	push bc			;140d
	ld hl,0fc18h		;140e
	call 00291h		;1411
	pop bc			;1414
	pop hl			;1415
	add hl,bc		;1416
	ex de,hl		;1417
	pop hl			;1418
	add hl,bc		;1419
	ret			;141a
	ld a,(0f3ddh)		;141b
	cp 001h			;141e
	ret z			;1420
	ld a,020h		;1421
	call 01217h		;1423
	jp 012b7h		;1426
	ld a,(0fca9h)		;1429
	cp 001h			;142c
	ret nz			;142e
	ld a,(0fcafh)		;142f
	cp 002h			;1432
	ret nc			;1434
	ld a,(0fbcch)		;1435
	call 010e2h		;1438
	jp 0024bh		;143b
	ld a,(0fca9h)		;143e
	cp 001h			;1441
	ret nz			;1443
	ld a,(0fcafh)		;1444
	cp 002h			;1447
	ret nc			;1449
	call 010e2h		;144a
	call 00245h		;144d
	ld (0fbcch),a		;1450
	and a			;1453
	ld d,000h		;1454
	ld e,a			;1456
	rl e			;1457
	rl d			;1459
	rl e			;145b
	rl d			;145d
	rl e			;145f
	rl d			;1461
	xor a			;1463
	ld hl,0fcafh		;1464
	cp (hl)			;1467
	jr nz,$+7		;1468
	ld hl,(0f3b7h)		;146a
	jr $+5			;146d
	ld hl,(0f3c1h)		;146f
	push hl			;1472
	add hl,de		;1473
	ld de,0fc18h		;1474
	ld bc,00008h		;1477
	call 0027eh		;147a
	ld a,(0fcaah)		;147d
	cp 000h			;1480
	jr nz,$+9		;1482
	ld hl,0fc18h		;1484
	ld b,008h		;1487
	jr $+7			;1489
	ld hl,0fc1eh		;148b
	ld b,002h		;148e
	ld a,(hl)		;1490
	cpl			;1491
	ld (hl),a		;1492
	inc hl			;1493
	djnz $-4		;1494
	pop hl			;1496
	ld de,007f8h		;1497
	add hl,de		;149a
	ex de,hl		;149b
	ld hl,0fc18h		;149c
	ld bc,00008h		;149f
	call 00291h		;14a2
	call 010e2h		;14a5
	ld a,0ffh		;14a8
	jp 0024bh		;14aa
	rlca			;14ad
	ld a,e			;14ae
	ld d,008h		;14af
	or a			;14b1
	ld (de),a		;14b2
	add hl,bc		;14b3
	ld b,h			;14b4
	ld (de),a		;14b5
	ld a,(bc)		;14b6
	ld d,e			;14b7
	ld (de),a		;14b8
	dec bc			;14b9
	ld l,d			;14ba
	ld (de),a		;14bb
	inc c			;14bc
	and d			;14bd
	rlca			;14be
	dec c			;14bf
	sub c			;14c0
	ld (de),a		;14c1
	dec de			;14c2
	sub a			;14c3
	ld (de),a		;14c4
	inc e			;14c5
	sbc a,l			;14c6
	ld (de),a		;14c7
	dec e			;14c8
	or a			;14c9
	ld (de),a		;14ca
	ld e,0cch		;14cb
	ld (de),a		;14cd
	rra			;14ce
	push de			;14cf
	ld (de),a		;14d0
	ld l,d			;14d1
	and d			;14d2
	rlca			;14d3
	ld b,l			;14d4
	and d			;14d5
	rlca			;14d6
	ld c,e			;14d7
	ld d,e			;14d8
	inc de			;14d9
	ld c,d			;14da
	ld (hl),c		;14db
	ld (de),a		;14dc
	ld l,h			;14dd
	ld d,b			;14de
	inc de			;14df
	ld c,h			;14e0
	ld (hl),c		;14e1
	inc de			;14e2
	ld c,l			;14e3
	or l			;14e4
	inc de			;14e5
	ld e,c			;14e6
	ld sp,04113h		;14e7
	call z,04212h		;14ea
	push de			;14ed
	ld (de),a		;14ee
	ld b,e			;14ef
	ld a,(04413h)		;14f0
	ld b,a			;14f3
	inc de			;14f4
	ld c,b			;14f5
	ld l,d			;14f6
	ld (de),a		;14f7
	ld a,b			;14f8
	add hl,hl		;14f9
	inc de			;14fa
	ld a,c			;14fb
	dec l			;14fc
	inc de			;14fd
	call 0ffb6h		;14fe
	push af			;1501
	call 0164ah		;1502
	jr c,$+10		;1505
	call 01528h		;1507
	jr z,$-8		;150a
	pop af			;150c
	jr $+14			;150d
	ld a,00dh		;150f
	call 0151bh		;1511
	xor a			;1514
	ld (0f415h),a		;1515
	pop af			;1518
	scf			;1519
	ret			;151a
	push af			;151b
	out (091h),a		;151c
	ld a,000h		;151e
	out (090h),a		;1520
	cpl			;1522
	out (090h),a		;1523
	pop af			;1525
	and a			;1526
	ret			;1527
	call 0ffbbh		;1528
	in a,(090h)		;152b
	rra			;152d
	rra			;152e
	ld a,0ffh		;152f
	jr nc,$+3		;1531
	cpl			;1533
	and a			;1534
	ret			;1535
	push hl			;1536
	push af			;1537
	ld hl,0fca6h		;1538
	xor a			;153b
	cp (hl)			;153c
	ld (hl),a		;153d
	jr nz,$+10		;153e
	pop af			;1540
	cp 001h			;1541
	jr nz,$+21		;1543
	ld (hl),a		;1545
	jr $+19			;1546
	pop af			;1548
	cp 040h			;1549
	jr c,$+11		;154b
	cp 060h			;154d
	jr nc,$+7		;154f
	sub 040h		;1551
	cp a			;1553
	jr $+4			;1554
	cp 050h			;1556
	scf			;1558
	pop hl			;1559
	ret			;155a
	call 0fddbh		;155b
	ld a,(0f6aah)		;155e
	and a			;1561
	jp z,01579h		;1562
	ld a,001h		;1565
	ld (0f3ddh),a		;1567
	jp 01579h		;156a
	ccf			;156d
	jr nz,$+2		;156e
	call 0fde0h		;1570
	ld hl,0156dh		;1573
	call 010b3h		;1576
	ld hl,(0f3ddh)		;1579
	ld (0fbcah),hl		;157c
	ld de,0fbb0h		;157f
	ld h,000h		;1582
	ld a,l			;1584
	add hl,de		;1585
	ld (hl),a		;1586
	call 011b4h		;1587
	cp 07fh			;158a
	jp z,01609h		;158c
	cp 020h			;158f
	jr nc,$+19		;1591
	ld b,014h		;1593
	ld hl,0160ah		;1595
	call 00200h		;1598
	xor a			;159b
	ld (0fca8h),a		;159c
	ld (0fcaah),a		;159f
	jr $-27			;15a2
	push af			;15a4
	ld a,(0fca8h)		;15a5
	and a			;15a8
	call nz,015b0h		;15a9
	pop af			;15ac
	rst 18h			;15ad
	jr $-53			;15ae
	call 01429h		;15b0
	ld hl,(0f3dch)		;15b3
	ld (0f6bch),hl		;15b6
	ld a,020h		;15b9
	ld (0f6a7h),a		;15bb
	call 010e2h		;15be
	call 00245h		;15c1
	cp 020h			;15c4
	jr nz,$+42		;15c6
	ld hl,(0f3dch)		;15c8
	ld a,(0f3b0h)		;15cb
	cp h			;15ce
	jr nz,$+31		;15cf
	ld h,000h		;15d1
	ld de,0fbb1h		;15d3
	add hl,de		;15d6
	ld a,(hl)		;15d7
	or a			;15d8
	jr z,$+21		;15d9
	ld a,(0f6a7h)		;15db
	call 010e2h		;15de
	call 0024bh		;15e1
	ld hl,(0f6bch)		;15e4
	ld (0f3dch),hl		;15e7
	ret			;15ea
	jp 0143eh		;15eb
	ld a,020h		;15ee
	push af			;15f0
	ld a,(0f6a7h)		;15f1
	rst 18h			;15f4
	pop af			;15f5
	ld (0f6a7h),a		;15f6
	jr $-59			;15f9
	ret			;15fb
	scf			;15fc
	pop hl			;15fd
	ret			;15fe
	ret			;15ff
	ret			;1600
	ret			;1601
	ret			;1602
	xor a			;1603
	pop hl			;1604
	ret			;1605
	ret			;1606
	ret			;1607
	ret			;1608
	ret			;1609
	jr $+2			;160a
	jr $+2			;160c
	ei			;160e
	dec d			;160f
	call m,01815h		;1610
	nop			;1613
	rst 38h			;1614
	dec d			;1615
	nop			;1616
	ld d,018h		;1617
	nop			;1619
	ld bc,01816h		;161a
	nop			;161d
	jr $+2			;161e
	jr $+2			;1620
	jr $+2			;1622
	ld (bc),a		;1624
	ld d,003h		;1625
	ld d,018h		;1627
	nop			;1629
	jr $+2			;162a
	jr $+2			;162c
	ld b,016h		;162e
	jr $+2			;1630
	jr $+2			;1632
	rlca			;1634
	ld d,018h		;1635
	nop			;1637
	jr $+2			;1638
	jr $+2			;163a
	jr $+2			;163c
	jr $+2			;163e
	ex af,af'		;1640
	ld d,018h		;1641
	nop			;1643
	jr $+2			;1644
	jr $+2			;1646
	jr $+2			;1648
	in a,(0aah)		;164a
	and 0f0h		;164c
	or 007h			;164e
	out (0aah),a		;1650
	in a,(0a9h)		;1652
	and 010h		;1654
	ret nz			;1656
	in a,(0aah)		;1657
	and 0f0h		;1659
	or 006h			;165b
	out (0aah),a		;165d
	in a,(0a9h)		;165f
	and 002h		;1661
	ret nz			;1663
	scf			;1664
	ret			;1665
	push hl			;1666
	push af			;1667
	ld hl,01671h		;1668
	call 0098bh		;166b
	pop af			;166e
	pop hl			;166f
	ret			;1670
	ld c,c			;1671
	ld d,e			;1672
	ld b,e			;1673
	ld c,(hl)		;1674
	ld d,h			;1675
	ld b,e			;1676
	nop			;1677
	jp 01666h		;1678
	push hl			;167b
	push af			;167c
	ld hl,01686h		;167d
	call 0098bh		;1680
	pop af			;1683
	pop hl			;1684
	ret			;1685
	ld b,d			;1686
	ld b,l			;1687
	ld b,l			;1688
	ld d,b			;1689
	nop			;168a
	ld (0f3dch),hl		;168b
	ret			;168e
	push hl			;168f
	push af			;1690
	ld hl,0169ah		;1691
	call 0098bh		;1694
	pop af			;1697
	pop hl			;1698
	ret			;1699
	ld b,(hl)		;169a
	ld c,(hl)		;169b
	ld c,e			;169c
	ld d,e			;169d
	ld b,d			;169e
	nop			;169f
	push hl			;16a0
	push af			;16a1
	ld hl,016abh		;16a2
	call 0098bh		;16a5
	pop af			;16a8
	pop hl			;16a9
	ret			;16aa
	ld b,l			;16ab
	ld d,d			;16ac
	ld b,c			;16ad
	ld b,(hl)		;16ae
	ld c,(hl)		;16af
	ld c,e			;16b0
	nop			;16b1
	push hl			;16b2
	push af			;16b3
	ld hl,016bdh		;16b4
	call 0098bh		;16b7
	pop af			;16ba
	pop hl			;16bb
	ret			;16bc
	ld b,h			;16bd
	ld d,e			;16be
	ld d,b			;16bf
	ld b,(hl)		;16c0
	ld c,(hl)		;16c1
	ld c,e			;16c2
	nop			;16c3
	ld a,(0fcafh)		;16c4
	cp 002h			;16c7
	ret c			;16c9
	ld a,(0fcb0h)		;16ca
	call 0fdbdh		;16cd
	or a			;16d0
	jp z,00374h		;16d1
	jp 003b4h		;16d4
	push hl			;16d7
	push af			;16d8
	ld hl,016e3h		;16d9
	call 0098bh		;16dc
	pop af			;16df
	pop hl			;16e0
	scf			;16e1
	ret			;16e2
	ld d,h			;16e3
	ld b,c			;16e4
	ld d,b			;16e5
	ld c,c			;16e6
	ld c,a			;16e7
	ld c,(hl)		;16e8
	nop			;16e9
	push hl			;16ea
	push af			;16eb
	ld hl,016f6h		;16ec
	call 0098bh		;16ef
	pop af			;16f2
	pop hl			;16f3
	scf			;16f4
	ret			;16f5
	ld d,h			;16f6
	ld b,c			;16f7
	ld d,b			;16f8
	ld c,c			;16f9
	ld c,(hl)		;16fa
	nop			;16fb
	push hl			;16fc
	push af			;16fd
	ld hl,01707h		;16fe
	call 0098bh		;1701
	pop af			;1704
	pop hl			;1705
	ret			;1706
	ld d,h			;1707
	ld b,c			;1708
	ld d,b			;1709
	ld c,c			;170a
	ld c,a			;170b
	ld b,(hl)		;170c
	nop			;170d
	push hl			;170e
	push af			;170f
	ld hl,0171ah		;1710
	call 0098bh		;1713
	pop af			;1716
	pop hl			;1717
	scf			;1718
	ret			;1719
	ld d,h			;171a
	ld b,c			;171b
	ld d,b			;171c
	ld c,a			;171d
	ld c,a			;171e
	ld c,(hl)		;171f
	nop			;1720
	push hl			;1721
	push af			;1722
	ld hl,0172dh		;1723
	call 0098bh		;1726
	pop af			;1729
	pop hl			;172a
	scf			;172b
	ret			;172c
	ld d,h			;172d
	ld b,c			;172e
	ld d,b			;172f
	ld c,a			;1730
	ld d,l			;1731
	ld d,h			;1732
	nop			;1733
	push hl			;1734
	push af			;1735
	ld hl,0173fh		;1736
	call 0098bh		;1739
	pop af			;173c
	pop hl			;173d
	ret			;173e
	ld d,h			;173f
	ld b,c			;1740
	ld d,b			;1741
	ld c,a			;1742
	ld c,a			;1743
	ld b,(hl)		;1744
	nop			;1745
	push bc			;1746
	ld b,a			;1747
	in a,(0aah)		;1748
	inc b			;174a
	jr z,$+14		;174b
	set 4,a			;174d
	dec b			;174f
	jr z,$+11		;1750
	res 4,a			;1752
	dec b			;1754
	jr z,$+6		;1755
	pop bc			;1757
	ret			;1758
	xor 010h		;1759
	out (0aah),a		;175b
	pop bc			;175d
	ret			;175e
	ld e,000h		;175f
	ld a,008h		;1761
	call 01777h		;1763
	inc a			;1766
	call 01777h		;1767
	inc a			;176a
	call 01777h		;176b
	inc a			;176e
	ld e,0b8h		;176f
	ld a,007h		;1771
	call 01777h		;1773
	ret			;1776
	di			;1777
	out (0a0h),a		;1778
	push af			;177a
	ld a,e			;177b
	out (0a1h),a		;177c
	ei			;177e
	pop af			;177f
	ret			;1780
	out (0a0h),a		;1781
	in a,(0a2h)		;1783
	ret			;1785
	or a			;1786
	ld a,00eh		;1787
	jr z,$+3		;1789
	inc a			;178b
	out (0abh),a		;178c
	ret			;178e
	in a,(0a8h)		;178f
	ret			;1791
	out (0a8h),a		;1792
	ret			;1794
	in a,(099h)		;1795
	ret			;1797
	di			;1798
	push bc			;1799
	ld c,a			;179a
	in a,(0aah)		;179b
	and 0f0h		;179d
	or c			;179f
	out (0aah),a		;17a0
	in a,(0a9h)		;17a2
	pop bc			;17a4
	ei			;17a5
	ret			;17a6
	call 0ffa7h		;17a7
	ret			;17aa
	call 0ffach		;17ab
	ret			;17ae
	ld a,(0f864h)		;17af
	and a			;17b2
	ret			;17b3
	push bc			;17b4
	cp 000h			;17b5
	jr nz,$+27		;17b7
	ld a,008h		;17b9
	call 01798h		;17bb
	rrca			;17be
	rrca			;17bf
	rrca			;17c0
	rrca			;17c1
	cpl			;17c2
	and 00fh		;17c3
	push hl			;17c5
	ld hl,01817h		;17c6
	ld d,000h		;17c9
	ld e,a			;17cb
	add hl,de		;17cc
	ld a,(hl)		;17cd
	pop hl			;17ce
	pop bc			;17cf
	and a			;17d0
	ret			;17d1
	push hl			;17d2
	push de			;17d3
	ld e,000h		;17d4
	dec a			;17d6
	jr z,$+4		;17d7
	set 6,e			;17d9
	ld a,00fh		;17db
	di			;17dd
	call 01781h		;17de
	ei			;17e1
	and 0bfh		;17e2
	or e			;17e4
	ld e,a			;17e5
	ld a,00fh		;17e6
	call 01777h		;17e8
	ld a,00eh		;17eb
	di			;17ed
	call 01781h		;17ee
	ei			;17f1
	cpl			;17f2
	and 00fh		;17f3
	ld hl,01807h		;17f5
	ld b,000h		;17f8
	ld c,a			;17fa
	add hl,bc		;17fb
	ld a,(hl)		;17fc
	pop de			;17fd
	pop hl			;17fe
	pop bc			;17ff
	and a			;1800
	ret			;1801
	ld a,000h		;1802
	pop bc			;1804
	and a			;1805
	ret			;1806
	nop			;1807
	ld bc,00005h		;1808
	rlca			;180b
	ex af,af'		;180c
	ld b,007h		;180d
	inc bc			;180f
	ld (bc),a		;1810
	inc b			;1811
	inc bc			;1812
	nop			;1813
	ld bc,00005h		;1814
	nop			;1817
	rlca			;1818
	ld bc,00508h		;1819
	ld b,000h		;181c
	rlca			;181e
	inc bc			;181f
	nop			;1820
	ld (bc),a		;1821
	ld bc,00504h		;1822
	inc bc			;1825
	nop			;1826
	cp 005h			;1827
	jr nc,$+5		;1829
	or a			;182b
	jr nz,$+11		;182c
	ld a,008h		;182e
	call 01798h		;1830
	or 0feh			;1833
	inc a			;1835
	ret			;1836
	di			;1837
	dec a			;1838
	push de			;1839
	ld e,003h		;183a
	ld b,a			;183c
	and 001h		;183d
	jr z,$+4		;183f
	ld e,04ch		;1841
	ld a,00fh		;1843
	call 01781h		;1845
	and 0bfh		;1848
	or e			;184a
	ld e,a			;184b
	ld a,00fh		;184c
	call 01777h		;184e
	ld a,b			;1851
	ld b,010h		;1852
	and 002h		;1854
	jr z,$+4		;1856
	ld b,020h		;1858
	ld a,00eh		;185a
	di			;185c
	call 01781h		;185d
	ei			;1860
	pop de			;1861
	and b			;1862
	jr z,$+4		;1863
	jr $+5			;1865
	ld a,0ffh		;1867
	ret			;1869
	xor a			;186a
	ret			;186b
	push hl			;186c
	push af			;186d
	ld hl,01878h		;186e
	call 0098bh		;1871
	pop af			;1874
	pop hl			;1875
	xor a			;1876
	ret			;1877
	ld b,a			;1878
	ld d,h			;1879
	ld d,b			;187a
	ld b,c			;187b
	ld b,h			;187c
	nop			;187d
	push hl			;187e
	push af			;187f
	ld hl,01889h		;1880
	call 0098bh		;1883
	pop af			;1886
	pop hl			;1887
	ret			;1888
	ld b,a			;1889
	ld d,h			;188a
	ld d,b			;188b
	ld b,h			;188c
	ld c,h			;188d
	nop			;188e
	call 018bfh		;188f
	ld b,(hl)		;1892
	inc b			;1893
	inc hl			;1894
	ld a,(hl)		;1895
	sub b			;1896
	inc hl			;1897
	inc hl			;1898
	and (hl)		;1899
	ld l,a			;189a
	ld h,000h		;189b
	ret			;189d
	call 018bfh		;189e
	ld a,(hl)		;18a1
	inc a			;18a2
	ld b,a			;18a3
	inc hl			;18a4
	sub (hl)		;18a5
	ret z			;18a6
	ld a,b			;18a7
	inc hl			;18a8
	inc hl			;18a9
	push hl			;18aa
	and (hl)		;18ab
	dec hl			;18ac
	dec hl			;18ad
	dec hl			;18ae
	ld (hl),a		;18af
	pop hl			;18b0
	inc hl			;18b1
	ld a,(hl)		;18b2
	inc hl			;18b3
	ld h,(hl)		;18b4
	ld l,a			;18b5
	dec b			;18b6
	ld c,b			;18b7
	ld b,000h		;18b8
	add hl,bc		;18ba
	ld (hl),e		;18bb
	or 001h			;18bc
	ret			;18be
	ld hl,(0f3f3h)		;18bf
	ld b,a			;18c2
	rlca			;18c3
	rlca			;18c4
	add a,b			;18c5
	add a,b			;18c6
	ld c,a			;18c7
	ld b,000h		;18c8
	add hl,bc		;18ca
	ret			;18cb
	or a			;18cc
	in a,(0aah)		;18cd
	res 6,a			;18cf
	jr nz,$+4		;18d1
	set 6,a			;18d3
	out (0aah),a		;18d5
	ret			;18d7
	push hl			;18d8
	push af			;18d9
	ld hl,018e3h		;18da
	call 0098bh		;18dd
	pop af			;18e0
	pop hl			;18e1
	ret			;18e2
	ld c,a			;18e3
	ld d,l			;18e4
	ld d,h			;18e5
	ld b,h			;18e6
	ld c,h			;18e7
	ld d,b			;18e8
	nop			;18e9
	ld l,002h		;18ea
	jr $+5			;18ec
	ld a,(0fb38h)		;18ee
	push de			;18f1
	ld d,000h		;18f2
	ld e,l			;18f4
	ld hl,0fb41h		;18f5
	add hl,de		;18f8
	ld e,025h		;18f9
	or a			;18fb
	jr z,$+6		;18fc
	add hl,de		;18fe
	dec a			;18ff
	jr $-5			;1900
	pop de			;1902
	ret			;1903
	ld hl,(0f3fah)		;1904
	ld (0f3f8h),hl		;1907
	ret			;190a
	push hl			;190b
	push de			;190c
	push bc			;190d
	push af			;190e
	exx			;190f
	ex af,af'		;1910
	push hl			;1911
	push de			;1912
	push bc			;1913
	push af			;1914
	push iy			;1915
	push ix			;1917
	call 0fd9ah		;1919
	in a,(099h)		;191c
	or a			;191e
	ld (0f3e7h),a		;191f
	jp p,01973h		;1922
	call 0fd9fh		;1925
	ld hl,(0fc9eh)		;1928
	inc hl			;192b
	ld (0fc9eh),hl		;192c
	xor a			;192f
	ld (0fbd9h),a		;1930
	ld a,(0f3f6h)		;1933
	dec a			;1936
	ld (0f3f6h),a		;1937
	jr nz,$+57		;193a
	ld a,003h		;193c
	ld (0f3f6h),a		;193e
	xor a			;1941
	call 01827h		;1942
	cpl			;1945
	and 001h		;1946
	ld (0f3e8h),a		;1948
	call 01988h		;194b
	ld hl,(0f3f8h)		;194e
	ld de,(0f3fah)		;1951
	rst 20h			;1955
	jr nz,$+29		;1956
	ld a,(0f3f7h)		;1958
	dec a			;195b
	ld (0f3f7h),a		;195c
	jr nz,$+20		;195f
	ld hl,0fbdah		;1961
	ld bc,00bffh		;1964
	ld (hl),c		;1967
	inc hl			;1968
	djnz $-2		;1969
	call 01988h		;196b
	ld a,001h		;196e
	ld (0f3f7h),a		;1970
	pop ix			;1973
	pop iy			;1975
	pop af			;1977
	pop bc			;1978
	pop de			;1979
	pop hl			;197a
	exx			;197b
	ex af,af'		;197c
	pop af			;197d
	pop bc			;197e
	pop de			;197f
	pop hl			;1980
	ei			;1981
	ret			;1982
	call 0fdd6h		;1983
	retn			;1986
	in a,(0aah)		;1988
	and 0f0h		;198a
	ld c,a			;198c
	ld b,00bh		;198d
	ld hl,0fbe5h		;198f
	ld a,c			;1992
	out (0aah),a		;1993
	in a,(0a9h)		;1995
	ld (hl),a		;1997
	inc hl			;1998
	inc c			;1999
	djnz $-8		;199a
	ld ix,0fbdah		;199c
	ld de,0fbe5h		;19a0
	ld a,(0fbebh)		;19a3
	rrca			;19a6
	jr nc,$+7		;19a7
	ld hl,0267bh		;19a9
	jr $+5			;19ac
	ld hl,026abh		;19ae
	ld b,006h		;19b1
	call 019bbh		;19b3
	ld hl,0279bh		;19b6
	ld b,005h		;19b9
	ld a,(de)		;19bb
	cp (ix+000h)		;19bc
	call nz,019dbh		;19bf
	cpl			;19c2
	and (ix+000h)		;19c3
	ex af,af'		;19c6
	ld a,(de)		;19c7
	ld (ix+000h),a		;19c8
	ex af,af'		;19cb
	ld c,008h		;19cc
	rrca			;19ce
	jr c,$+20		;19cf
	inc hl			;19d1
	dec c			;19d2
	jr nz,$-5		;19d3
	inc ix			;19d5
	inc de			;19d7
	djnz $-29		;19d8
	ret			;19da
	push af			;19db
	ld a,005h		;19dc
	ld (0f3f7h),a		;19de
	pop af			;19e1
	ret			;19e2
	push af			;19e3
	ld a,b			;19e4
	cp 005h			;19e5
	jr z,$+9		;19e7
	cp 004h			;19e9
	jr z,$+30		;19eb
	jp 01a3ah		;19ed
	ld a,c			;19f0
	cp 003h			;19f1
	jr nz,$+6		;19f3
	ld a,000h		;19f5
	jr $+35			;19f7
	cp 002h			;19f9
	jr nz,$+6		;19fb
	ld a,001h		;19fd
	jr $+27			;19ff
	cp 001h			;1a01
	jr nz,$+55		;1a03
	ld a,002h		;1a05
	jr $+19			;1a07
	ld a,c			;1a09
	cp 008h			;1a0a
	jr nz,$+6		;1a0c
	ld a,003h		;1a0e
	jr $+10			;1a10
	cp 007h			;1a12
	jr nz,$+38		;1a14
	ld a,004h		;1a16
	jr $+2			;1a18
	push hl			;1a1a
	push bc			;1a1b
	push de			;1a1c
	rlca			;1a1d
	rlca			;1a1e
	rlca			;1a1f
	rlca			;1a20
	ld hl,0f87fh		;1a21
	ld d,000h		;1a24
	ld e,a			;1a26
	add hl,de		;1a27
	ex de,hl		;1a28
	ld a,(de)		;1a29
	and a			;1a2a
	jr z,$+10		;1a2b
	push de			;1a2d
	call 01a47h		;1a2e
	pop de			;1a31
	inc de			;1a32
	jr $-10			;1a33
	pop de			;1a35
	pop bc			;1a36
	pop hl			;1a37
	jr $+11			;1a38
	ld a,(hl)		;1a3a
	and a			;1a3b
	jr z,$+7		;1a3c
	push hl			;1a3e
	call 01a47h		;1a3f
	pop hl			;1a42
	pop af			;1a43
	jp 019d1h		;1a44
	ld hl,(0f3f8h)		;1a47
	ld (hl),a		;1a4a
	inc hl			;1a4b
	ld a,l			;1a4c
	cp 018h			;1a4d
	jr nz,$+5		;1a4f
	ld hl,0fbf0h		;1a51
	push de			;1a54
	ld de,(0f3fah)		;1a55
	rst 20h			;1a59
	pop de			;1a5a
	ret z			;1a5b
	ld (0f3f8h),hl		;1a5c
	ret			;1a5f
	call 01a66h		;1a60
	pop ix			;1a63
	ret			;1a65
	ex af,af'		;1a66
	exx			;1a67
	push af			;1a68
	push bc			;1a69
	push de			;1a6a
	push hl			;1a6b
	ld a,i			;1a6c
	push af			;1a6e
	exx			;1a6f
	push iy			;1a70
	ld a,(0faf8h)		;1a72
	push af			;1a75
	pop iy			;1a76
	ex af,af'		;1a78
	call 02434h		;1a79
	pop iy			;1a7c
	ex af,af'		;1a7e
	exx			;1a7f
	pop af			;1a80
	jp po,01a85h		;1a81
	ei			;1a84
	pop hl			;1a85
	pop de			;1a86
	pop bc			;1a87
	pop af			;1a88
	exx			;1a89
	ex af,af'		;1a8a
	ret			;1a8b
	di			;1a8c
	halt			;1a8d
	call 0fedah		;1a8e
	ld de,025dfh		;1a91
	jp 01aaeh		;1a94
	push hl			;1a97
	push af			;1a98
	ld hl,01aa7h		;1a99
	call 0098bh		;1a9c
	pop af			;1a9f
	pop hl			;1aa0
	ld de,025c4h		;1aa1
	jp 01aaeh		;1aa4
	ld b,e			;1aa7
	ld b,c			;1aa8
	ld c,h			;1aa9
	ld b,d			;1aaa
	ld b,c			;1aab
	ld d,e			;1aac
	nop			;1aad
	in a,(099h)		;1aae
	ld hl,027c3h		;1ab0
	ld b,00ch		;1ab3
	ld c,099h		;1ab5
	otir			;1ab7
	ld bc,00800h		;1ab9
	xor a			;1abc
	out (098h),a		;1abd
	dec bc			;1abf
	ld a,b			;1ac0
	or c			;1ac1
	jr nz,$-6		;1ac2
	ld hl,01bbfh		;1ac4
	ld bc,00800h		;1ac7
	ld a,(hl)		;1aca
	out (098h),a		;1acb
	inc hl			;1acd
	dec bc			;1ace
	ld a,b			;1acf
	or c			;1ad0
	jr nz,$-7		;1ad1
	ld a,000h		;1ad3
	out (099h),a		;1ad5
	ld a,040h		;1ad7
	out (099h),a		;1ad9
	ld hl,025abh		;1adb
	ld a,(hl)		;1ade
	out (098h),a		;1adf
	inc hl			;1ae1
	ld a,(hl)		;1ae2
	and a			;1ae3
	jr nz,$-5		;1ae4
	ld a,(de)		;1ae6
	out (098h),a		;1ae7
	inc de			;1ae9
	ld a,(de)		;1aea
	and a			;1aeb
	jr nz,$-5		;1aec
	jp 01a8ch		;1aee
	nop			;1af1
	nop			;1af2
	nop			;1af3
	nop			;1af4
	nop			;1af5
	nop			;1af6
	nop			;1af7
	nop			;1af8
	nop			;1af9
	nop			;1afa
	nop			;1afb
	nop			;1afc
	nop			;1afd
	nop			;1afe
	nop			;1aff
	nop			;1b00
	nop			;1b01
	nop			;1b02
	nop			;1b03
	nop			;1b04
	nop			;1b05
	nop			;1b06
	nop			;1b07
	nop			;1b08
	nop			;1b09
	nop			;1b0a
	nop			;1b0b
	nop			;1b0c
	nop			;1b0d
	nop			;1b0e
	nop			;1b0f
	nop			;1b10
	nop			;1b11
	nop			;1b12
	nop			;1b13
	nop			;1b14
	nop			;1b15
	nop			;1b16
	nop			;1b17
	nop			;1b18
	nop			;1b19
	nop			;1b1a
	nop			;1b1b
	nop			;1b1c
	nop			;1b1d
	nop			;1b1e
	nop			;1b1f
	nop			;1b20
	nop			;1b21
	nop			;1b22
	nop			;1b23
	nop			;1b24
	nop			;1b25
	nop			;1b26
	nop			;1b27
	nop			;1b28
	nop			;1b29
	nop			;1b2a
	nop			;1b2b
	nop			;1b2c
	nop			;1b2d
	nop			;1b2e
	nop			;1b2f
	nop			;1b30
	nop			;1b31
	nop			;1b32
	nop			;1b33
	nop			;1b34
	nop			;1b35
	nop			;1b36
	nop			;1b37
	nop			;1b38
	nop			;1b39
	nop			;1b3a
	nop			;1b3b
	nop			;1b3c
	nop			;1b3d
	nop			;1b3e
	nop			;1b3f
	nop			;1b40
	nop			;1b41
	nop			;1b42
	nop			;1b43
	nop			;1b44
	nop			;1b45
	nop			;1b46
	nop			;1b47
	nop			;1b48
	nop			;1b49
	nop			;1b4a
	nop			;1b4b
	nop			;1b4c
	nop			;1b4d
	nop			;1b4e
	nop			;1b4f
	nop			;1b50
	nop			;1b51
	nop			;1b52
	nop			;1b53
	nop			;1b54
	nop			;1b55
	nop			;1b56
	nop			;1b57
	nop			;1b58
	nop			;1b59
	nop			;1b5a
	nop			;1b5b
	nop			;1b5c
	nop			;1b5d
	nop			;1b5e
	nop			;1b5f
	nop			;1b60
	nop			;1b61
	nop			;1b62
	nop			;1b63
	nop			;1b64
	nop			;1b65
	nop			;1b66
	nop			;1b67
	nop			;1b68
	nop			;1b69
	nop			;1b6a
	nop			;1b6b
	nop			;1b6c
	nop			;1b6d
	nop			;1b6e
	nop			;1b6f
	nop			;1b70
	nop			;1b71
	nop			;1b72
	nop			;1b73
	nop			;1b74
	nop			;1b75
	nop			;1b76
	nop			;1b77
	nop			;1b78
	nop			;1b79
	nop			;1b7a
	nop			;1b7b
	nop			;1b7c
	nop			;1b7d
	nop			;1b7e
	nop			;1b7f
	nop			;1b80
	nop			;1b81
	nop			;1b82
	nop			;1b83
	nop			;1b84
	nop			;1b85
	nop			;1b86
	nop			;1b87
	nop			;1b88
	nop			;1b89
	nop			;1b8a
	nop			;1b8b
	nop			;1b8c
	nop			;1b8d
	nop			;1b8e
	nop			;1b8f
	nop			;1b90
	nop			;1b91
	nop			;1b92
	nop			;1b93
	nop			;1b94
	nop			;1b95
	nop			;1b96
	nop			;1b97
	nop			;1b98
	nop			;1b99
	nop			;1b9a
	nop			;1b9b
	nop			;1b9c
	nop			;1b9d
	nop			;1b9e
	nop			;1b9f
	nop			;1ba0
	nop			;1ba1
	nop			;1ba2
	nop			;1ba3
	nop			;1ba4
	nop			;1ba5
	nop			;1ba6
	nop			;1ba7
	nop			;1ba8
	nop			;1ba9
	nop			;1baa
	nop			;1bab
	nop			;1bac
	nop			;1bad
	nop			;1bae
	nop			;1baf
	nop			;1bb0
	nop			;1bb1
	nop			;1bb2
	nop			;1bb3
	nop			;1bb4
	nop			;1bb5
	nop			;1bb6
	nop			;1bb7
	nop			;1bb8
	nop			;1bb9
	nop			;1bba
	nop			;1bbb
	nop			;1bbc
	nop			;1bbd
	nop			;1bbe
	nop			;1bbf
	nop			;1bc0
	nop			;1bc1
	nop			;1bc2
	nop			;1bc3
	nop			;1bc4
	nop			;1bc5
	nop			;1bc6
	inc a			;1bc7
	ld b,d			;1bc8
	and l			;1bc9
	and l			;1bca
	jp 042bdh		;1bcb
	inc a			;1bce
	inc a			;1bcf
	ld a,(hl)		;1bd0
	in a,(0dbh)		;1bd1
	cp l			;1bd3
	jp 03c7eh		;1bd4
	ld l,h			;1bd7
	xor d			;1bd8
	sub d			;1bd9
	ld b,h			;1bda
	ld b,h			;1bdb
	jr z,$+18		;1bdc
	nop			;1bde
	djnz $+42		;1bdf
	ld b,h			;1be1
	add a,d			;1be2
	ld b,h			;1be3
	jr z,$+18		;1be4
	nop			;1be6
	djnz $+58		;1be7
	jr c,$-40		;1be9
	cp 0d6h			;1beb
	jr c,$+2		;1bed
	djnz $+58		;1bef
	ld a,h			;1bf1
	ld a,h			;1bf2
	cp 0d6h			;1bf3
	jr c,$+2		;1bf5
	nop			;1bf7
	nop			;1bf8
	nop			;1bf9
	jr $+26			;1bfa
	nop			;1bfc
	nop			;1bfd
	nop			;1bfe
	rst 38h			;1bff
	rst 38h			;1c00
	rst 38h			;1c01
	rst 20h			;1c02
	rst 20h			;1c03
	rst 38h			;1c04
	rst 38h			;1c05
	rst 38h			;1c06
	inc a			;1c07
	ld b,d			;1c08
	add a,c			;1c09
	add a,c			;1c0a
	add a,c			;1c0b
	add a,c			;1c0c
	ld b,d			;1c0d
	inc a			;1c0e
	jp 07ebdh		;1c0f
	ld a,(hl)		;1c12
	ld a,(hl)		;1c13
	ld a,(hl)		;1c14
	cp l			;1c15
	jp 0040ch		;1c16
	ex af,af'		;1c19
	ld (hl),b		;1c1a
	adc a,b			;1c1b
	adc a,b			;1c1c
	ld (hl),b		;1c1d
	nop			;1c1e
	nop			;1c1f
	ld (hl),b		;1c20
	adc a,b			;1c21
	adc a,b			;1c22
	ld (hl),b		;1c23
	jr nz,$+114		;1c24
	jr nz,$+34		;1c26
	jr nc,$+42		;1c28
	jr z,$+34		;1c2a
	ret po			;1c2c
	ret nz			;1c2d
	nop			;1c2e
	jr c,$+62		;1c2f
	inc h			;1c31
	inc h			;1c32
	call po,018dch		;1c33
	nop			;1c36
	djnz $+70		;1c37
	jr c,$-84		;1c39
	jr c,$+70		;1c3b
	djnz $+2		;1c3d
	djnz $+18		;1c3f
	djnz $+58		;1c41
	djnz $+18		;1c43
	djnz $+18		;1c45
	djnz $+18		;1c47
	djnz $-15		;1c49
	nop			;1c4b
	nop			;1c4c
	nop			;1c4d
	nop			;1c4e
	nop			;1c4f
	nop			;1c50
	nop			;1c51
	rst 28h			;1c52
	djnz $+18		;1c53
	djnz $+18		;1c55
	djnz $+18		;1c57
	djnz $-30		;1c59
	djnz $+18		;1c5b
	djnz $+18		;1c5d
	djnz $+18		;1c5f
	djnz $+17		;1c61
	djnz $+18		;1c63
	djnz $+18		;1c65
	djnz $+18		;1c67
	djnz $-15		;1c69
	djnz $+18		;1c6b
	djnz $+18		;1c6d
	djnz $+18		;1c6f
	djnz $+18		;1c71
	djnz $+18		;1c73
	djnz $+18		;1c75
	nop			;1c77
	nop			;1c78
	nop			;1c79
	rst 38h			;1c7a
	nop			;1c7b
	nop			;1c7c
	nop			;1c7d
	nop			;1c7e
	nop			;1c7f
	nop			;1c80
	nop			;1c81
	rrca			;1c82
	djnz $+18		;1c83
	djnz $+18		;1c85
	nop			;1c87
	nop			;1c88
	nop			;1c89
	ret po			;1c8a
	djnz $+18		;1c8b
	djnz $+18		;1c8d
	djnz $+18		;1c8f
	djnz $+17		;1c91
	nop			;1c93
	nop			;1c94
	nop			;1c95
	nop			;1c96
	djnz $+18		;1c97
	djnz $-30		;1c99
	nop			;1c9b
	nop			;1c9c
	nop			;1c9d
	nop			;1c9e
	add a,c			;1c9f
	ld b,d			;1ca0
	inc h			;1ca1
	jr $+26			;1ca2
	inc h			;1ca4
	ld b,d			;1ca5
	add a,c			;1ca6
	ld bc,00402h		;1ca7
	ex af,af'		;1caa
	djnz $+34		;1cab
	ld b,b			;1cad
	add a,b			;1cae
	add a,b			;1caf
	ld b,b			;1cb0
	jr nz,$+18		;1cb1
	ex af,af'		;1cb3
	inc b			;1cb4
	ld (bc),a		;1cb5
	ld bc,00000h		;1cb6
	djnz $+1		;1cb9
	djnz $+2		;1cbb
	nop			;1cbd
	nop			;1cbe
	nop			;1cbf
	nop			;1cc0
	nop			;1cc1
	nop			;1cc2
	nop			;1cc3
	nop			;1cc4
	nop			;1cc5
	nop			;1cc6
	jr nz,$+34		;1cc7
	jr nz,$+34		;1cc9
	nop			;1ccb
	jr nz,$+2		;1ccc
	nop			;1cce
	ld d,b			;1ccf
	ld d,b			;1cd0
	nop			;1cd1
	nop			;1cd2
	nop			;1cd3
	nop			;1cd4
	nop			;1cd5
	nop			;1cd6
	nop			;1cd7
	ld d,b			;1cd8
	ret m			;1cd9
	ld d,b			;1cda
	ret m			;1cdb
	ld d,b			;1cdc
	nop			;1cdd
	nop			;1cde
	jr nz,$+114		;1cdf
	and b			;1ce1
	ld (hl),b		;1ce2
	jr z,$+114		;1ce3
	jr nz,$+2		;1ce5
	nop			;1ce7
	ret z			;1ce8
	ret nc			;1ce9
	jr nz,$+90		;1cea
	sbc a,b			;1cec
	nop			;1ced
	nop			;1cee
	ld h,b			;1cef
	sub b			;1cf0
	ld h,b			;1cf1
	xor b			;1cf2
	sbc a,b			;1cf3
	ld h,b			;1cf4
	nop			;1cf5
	nop			;1cf6
	ld b,b			;1cf7
	ld b,b			;1cf8
	nop			;1cf9
	nop			;1cfa
	nop			;1cfb
	nop			;1cfc
	nop			;1cfd
	nop			;1cfe
	jr nz,$+66		;1cff
	ld b,b			;1d01
	ld b,b			;1d02
	ld b,b			;1d03
	jr nz,$+2		;1d04
	nop			;1d06
	jr nz,$+18		;1d07
	djnz $+18		;1d09
	djnz $+34		;1d0b
	nop			;1d0d
	nop			;1d0e
	nop			;1d0f
	jr nz,$-86		;1d10
	ld (hl),b		;1d12
	ld d,b			;1d13
	adc a,b			;1d14
	nop			;1d15
	nop			;1d16
	nop			;1d17
	jr nz,$+34		;1d18
	ret m			;1d1a
	jr nz,$+34		;1d1b
	nop			;1d1d
	nop			;1d1e
	nop			;1d1f
	nop			;1d20
	nop			;1d21
	nop			;1d22
	nop			;1d23
	ld b,b			;1d24
	ld b,b			;1d25
	nop			;1d26
	nop			;1d27
	nop			;1d28
	nop			;1d29
	ret m			;1d2a
	nop			;1d2b
	nop			;1d2c
	nop			;1d2d
	nop			;1d2e
	nop			;1d2f
	nop			;1d30
	nop			;1d31
	nop			;1d32
	nop			;1d33
	ld b,b			;1d34
	nop			;1d35
	nop			;1d36
	nop			;1d37
	ex af,af'		;1d38
	djnz $+34		;1d39
	ld b,b			;1d3b
	add a,b			;1d3c
	nop			;1d3d
	nop			;1d3e
	ld (hl),b		;1d3f
	adc a,b			;1d40
	xor b			;1d41
	xor b			;1d42
	adc a,b			;1d43
	ld (hl),b		;1d44
	nop			;1d45
	nop			;1d46
	jr nz,$+98		;1d47
	jr nz,$+34		;1d49
	jr nz,$+114		;1d4b
	nop			;1d4d
	nop			;1d4e
	ld (hl),b		;1d4f
	adc a,b			;1d50
	ex af,af'		;1d51
	ld (hl),b		;1d52
	add a,b			;1d53
	ret m			;1d54
	nop			;1d55
	nop			;1d56
	ret m			;1d57
	ex af,af'		;1d58
	jr nc,$+10		;1d59
	adc a,b			;1d5b
	ld (hl),b		;1d5c
	nop			;1d5d
	nop			;1d5e
	djnz $+50		;1d5f
	ld d,b			;1d61
	ret m			;1d62
	djnz $+18		;1d63
	nop			;1d65
	nop			;1d66
	ret m			;1d67
	add a,b			;1d68
	ld (hl),b		;1d69
	ex af,af'		;1d6a
	adc a,b			;1d6b
	ld (hl),b		;1d6c
	nop			;1d6d
	nop			;1d6e
	jr nc,$+66		;1d6f
	ld (hl),b		;1d71
	adc a,b			;1d72
	adc a,b			;1d73
	ld (hl),b		;1d74
	nop			;1d75
	nop			;1d76
	ret m			;1d77
	adc a,b			;1d78
	djnz $+34		;1d79
	jr nz,$+34		;1d7b
	nop			;1d7d
	nop			;1d7e
	ld (hl),b		;1d7f
	adc a,b			;1d80
	ld (hl),b		;1d81
	adc a,b			;1d82
	adc a,b			;1d83
	ld (hl),b		;1d84
	nop			;1d85
	nop			;1d86
	ld (hl),b		;1d87
	adc a,b			;1d88
	adc a,b			;1d89
	ld a,b			;1d8a
	ex af,af'		;1d8b
	ld (hl),b		;1d8c
	nop			;1d8d
	nop			;1d8e
	nop			;1d8f
	nop			;1d90
	ld b,b			;1d91
	nop			;1d92
	nop			;1d93
	ld b,b			;1d94
	nop			;1d95
	nop			;1d96
	nop			;1d97
	nop			;1d98
	ld b,b			;1d99
	nop			;1d9a
	nop			;1d9b
	ld b,b			;1d9c
	ld b,b			;1d9d
	nop			;1d9e
	nop			;1d9f
	jr $+98			;1da0
	add a,b			;1da2
	ld h,b			;1da3
	jr $+2			;1da4
	nop			;1da6
	nop			;1da7
	nop			;1da8
	ret m			;1da9
	nop			;1daa
	ret m			;1dab
	nop			;1dac
	nop			;1dad
	nop			;1dae
	nop			;1daf
	ret nz			;1db0
	jr nc,$+10		;1db1
	jr nc,$-62		;1db3
	nop			;1db5
	nop			;1db6
	ld (hl),b		;1db7
	adc a,b			;1db8
	jr nc,$+34		;1db9
	nop			;1dbb
	jr nz,$+2		;1dbc
	nop			;1dbe
	ld (hl),b		;1dbf
	adc a,b			;1dc0
	sbc a,b			;1dc1
	xor b			;1dc2
	xor b			;1dc3
	sbc a,b			;1dc4
	ld b,b			;1dc5
	nop			;1dc6
	ld (hl),b		;1dc7
	adc a,b			;1dc8
	adc a,b			;1dc9
	ret m			;1dca
	adc a,b			;1dcb
	adc a,b			;1dcc
	nop			;1dcd
	nop			;1dce
	ret po			;1dcf
	sub b			;1dd0
	ret po			;1dd1
	sub b			;1dd2
	adc a,b			;1dd3
	ret p			;1dd4
	nop			;1dd5
	nop			;1dd6
	ld (hl),b		;1dd7
	adc a,b			;1dd8
	add a,b			;1dd9
	add a,b			;1dda
	adc a,b			;1ddb
	ld (hl),b		;1ddc
	nop			;1ddd
	nop			;1dde
	ret p			;1ddf
	ld c,b			;1de0
	ld c,b			;1de1
	ld c,b			;1de2
	ld c,b			;1de3
	ret p			;1de4
	nop			;1de5
	nop			;1de6
	ret m			;1de7
	add a,b			;1de8
	ret po			;1de9
	add a,b			;1dea
	add a,b			;1deb
	ret m			;1dec
	nop			;1ded
	nop			;1dee
	ret m			;1def
	add a,b			;1df0
	add a,b			;1df1
	ret po			;1df2
	add a,b			;1df3
	add a,b			;1df4
	nop			;1df5
	nop			;1df6
	ld (hl),b		;1df7
	adc a,b			;1df8
	add a,b			;1df9
	cp b			;1dfa
	adc a,b			;1dfb
	ld (hl),b		;1dfc
	nop			;1dfd
	nop			;1dfe
	adc a,b			;1dff
	adc a,b			;1e00
	ret m			;1e01
	adc a,b			;1e02
	adc a,b			;1e03
	adc a,b			;1e04
	nop			;1e05
	nop			;1e06
	ld (hl),b		;1e07
	jr nz,$+34		;1e08
	jr nz,$+34		;1e0a
	ld (hl),b		;1e0c
	nop			;1e0d
	nop			;1e0e
	jr c,$+10		;1e0f
	ex af,af'		;1e11
	ex af,af'		;1e12
	adc a,b			;1e13
	ld (hl),b		;1e14
	nop			;1e15
	nop			;1e16
	adc a,b			;1e17
	sub b			;1e18
	and b			;1e19
	ret po			;1e1a
	sub b			;1e1b
	adc a,b			;1e1c
	nop			;1e1d
	nop			;1e1e
	add a,b			;1e1f
	add a,b			;1e20
	add a,b			;1e21
	add a,b			;1e22
	add a,b			;1e23
	ret m			;1e24
	nop			;1e25
	nop			;1e26
	ret c			;1e27
	xor b			;1e28
	xor b			;1e29
	adc a,b			;1e2a
	adc a,b			;1e2b
	adc a,b			;1e2c
	nop			;1e2d
	nop			;1e2e
	ret z			;1e2f
	xor b			;1e30
	xor b			;1e31
	sbc a,b			;1e32
	sbc a,b			;1e33
	adc a,b			;1e34
	nop			;1e35
	nop			;1e36
	ld (hl),b		;1e37
	adc a,b			;1e38
	adc a,b			;1e39
	adc a,b			;1e3a
	adc a,b			;1e3b
	ld (hl),b		;1e3c
	nop			;1e3d
	nop			;1e3e
	ret p			;1e3f
	adc a,b			;1e40
	adc a,b			;1e41
	ret p			;1e42
	add a,b			;1e43
	add a,b			;1e44
	nop			;1e45
	nop			;1e46
	ld (hl),b		;1e47
	adc a,b			;1e48
	adc a,b			;1e49
	xor b			;1e4a
	sub b			;1e4b
	ld l,b			;1e4c
	nop			;1e4d
	nop			;1e4e
	ret p			;1e4f
	adc a,b			;1e50
	adc a,b			;1e51
	ret p			;1e52
	and b			;1e53
	sbc a,b			;1e54
	nop			;1e55
	nop			;1e56
	ld (hl),b		;1e57
	add a,b			;1e58
	ld (hl),b		;1e59
	ex af,af'		;1e5a
	ex af,af'		;1e5b
	ret p			;1e5c
	nop			;1e5d
	nop			;1e5e
	ret m			;1e5f
	jr nz,$+34		;1e60
	jr nz,$+34		;1e62
	jr nz,$+2		;1e64
	nop			;1e66
	adc a,b			;1e67
	adc a,b			;1e68
	adc a,b			;1e69
	adc a,b			;1e6a
	adc a,b			;1e6b
	ld a,b			;1e6c
	nop			;1e6d
	nop			;1e6e
	adc a,b			;1e6f
	adc a,b			;1e70
	adc a,b			;1e71
	ld d,b			;1e72
	ld d,b			;1e73
	jr nz,$+2		;1e74
	nop			;1e76
	adc a,b			;1e77
	adc a,b			;1e78
	xor b			;1e79
	xor b			;1e7a
	xor b			;1e7b
	ret c			;1e7c
	nop			;1e7d
	nop			;1e7e
	adc a,b			;1e7f
	ld d,b			;1e80
	jr nz,$+82		;1e81
	adc a,b			;1e83
	adc a,b			;1e84
	nop			;1e85
	nop			;1e86
	adc a,b			;1e87
	adc a,b			;1e88
	ld (hl),b		;1e89
	jr nz,$+34		;1e8a
	jr nz,$+2		;1e8c
	nop			;1e8e
	ret m			;1e8f
	djnz $+34		;1e90
	ld b,b			;1e92
	add a,b			;1e93
	ret m			;1e94
	nop			;1e95
	nop			;1e96
	ld (hl),b		;1e97
	ld b,b			;1e98
	ld b,b			;1e99
	ld b,b			;1e9a
	ld b,b			;1e9b
	ld (hl),b		;1e9c
	nop			;1e9d
	nop			;1e9e
	nop			;1e9f
	add a,b			;1ea0
	ld b,b			;1ea1
	jr nz,$+18		;1ea2
	ex af,af'		;1ea4
	nop			;1ea5
	nop			;1ea6
	ld (hl),b		;1ea7
	djnz $+18		;1ea8
	djnz $+18		;1eaa
	ld (hl),b		;1eac
	nop			;1ead
	nop			;1eae
	ld b,b			;1eaf
	and b			;1eb0
	nop			;1eb1
	nop			;1eb2
	nop			;1eb3
	nop			;1eb4
	nop			;1eb5
	nop			;1eb6
	nop			;1eb7
	nop			;1eb8
	nop			;1eb9
	nop			;1eba
	nop			;1ebb
	nop			;1ebc
	ret m			;1ebd
	nop			;1ebe
	jr nz,$+18		;1ebf
	nop			;1ec1
	nop			;1ec2
	nop			;1ec3
	nop			;1ec4
	nop			;1ec5
	nop			;1ec6
	nop			;1ec7
	nop			;1ec8
	ld a,b			;1ec9
	adc a,b			;1eca
	sbc a,b			;1ecb
	ld l,b			;1ecc
	nop			;1ecd
	nop			;1ece
	add a,b			;1ecf
	add a,b			;1ed0
	ret p			;1ed1
	adc a,b			;1ed2
	adc a,b			;1ed3
	ret p			;1ed4
	nop			;1ed5
	nop			;1ed6
	nop			;1ed7
	nop			;1ed8
	ld a,b			;1ed9
	add a,b			;1eda
	add a,b			;1edb
	ld a,b			;1edc
	nop			;1edd
	nop			;1ede
	ex af,af'		;1edf
	ex af,af'		;1ee0
	ld a,b			;1ee1
	adc a,b			;1ee2
	adc a,b			;1ee3
	ld a,b			;1ee4
	nop			;1ee5
	nop			;1ee6
	nop			;1ee7
	nop			;1ee8
	ld (hl),b		;1ee9
	sbc a,b			;1eea
	ret po			;1eeb
	ld a,b			;1eec
	nop			;1eed
	nop			;1eee
	jr nc,$+74		;1eef
	ld b,b			;1ef1
	ld b,b			;1ef2
	ret po			;1ef3
	ld b,b			;1ef4
	ld b,b			;1ef5
	ld b,b			;1ef6
	nop			;1ef7
	nop			;1ef8
	ld a,b			;1ef9
	adc a,b			;1efa
	adc a,b			;1efb
	ld a,b			;1efc
	ex af,af'		;1efd
	ld (hl),b		;1efe
	add a,b			;1eff
	add a,b			;1f00
	ret p			;1f01
	adc a,b			;1f02
	adc a,b			;1f03
	adc a,b			;1f04
	nop			;1f05
	nop			;1f06
	jr nz,$+2		;1f07
	ld h,b			;1f09
	jr nz,$+34		;1f0a
	ld (hl),b		;1f0c
	nop			;1f0d
	nop			;1f0e
	djnz $+2		;1f0f
	jr nc,$+18		;1f11
	djnz $+18		;1f13
	djnz $+98		;1f15
	add a,b			;1f17
	add a,b			;1f18
	sbc a,b			;1f19
	and b			;1f1a
	ret po			;1f1b
	sbc a,b			;1f1c
	nop			;1f1d
	nop			;1f1e
	ret nz			;1f1f
	ld b,b			;1f20
	ld b,b			;1f21
	ld b,b			;1f22
	ld b,b			;1f23
	ld (hl),b		;1f24
	nop			;1f25
	nop			;1f26
	nop			;1f27
	nop			;1f28
	ret p			;1f29
	xor b			;1f2a
	xor b			;1f2b
	xor b			;1f2c
	nop			;1f2d
	nop			;1f2e
	nop			;1f2f
	nop			;1f30
	ret p			;1f31
	adc a,b			;1f32
	adc a,b			;1f33
	adc a,b			;1f34
	nop			;1f35
	nop			;1f36
	nop			;1f37
	nop			;1f38
	ld (hl),b		;1f39
	adc a,b			;1f3a
	adc a,b			;1f3b
	ld (hl),b		;1f3c
	nop			;1f3d
	nop			;1f3e
	nop			;1f3f
	nop			;1f40
	ret p			;1f41
	adc a,b			;1f42
	adc a,b			;1f43
	ret p			;1f44
	add a,b			;1f45
	add a,b			;1f46
	nop			;1f47
	nop			;1f48
	ld a,b			;1f49
	adc a,b			;1f4a
	adc a,b			;1f4b
	ld a,b			;1f4c
	ex af,af'		;1f4d
	ex af,af'		;1f4e
	nop			;1f4f
	nop			;1f50
	cp b			;1f51
	ret nz			;1f52
	add a,b			;1f53
	add a,b			;1f54
	nop			;1f55
	nop			;1f56
	nop			;1f57
	nop			;1f58
	ld a,b			;1f59
	ret p			;1f5a
	ex af,af'		;1f5b
	ret p			;1f5c
	nop			;1f5d
	nop			;1f5e
	ld b,b			;1f5f
	ld b,b			;1f60
	ret p			;1f61
	ld b,b			;1f62
	ld c,b			;1f63
	jr nc,$+2		;1f64
	nop			;1f66
	nop			;1f67
	nop			;1f68
	adc a,b			;1f69
	adc a,b			;1f6a
	adc a,b			;1f6b
	ld a,b			;1f6c
	nop			;1f6d
	nop			;1f6e
	nop			;1f6f
	nop			;1f70
	adc a,b			;1f71
	adc a,b			;1f72
	ld d,b			;1f73
	jr nz,$+2		;1f74
	nop			;1f76
	nop			;1f77
	nop			;1f78
	adc a,b			;1f79
	xor b			;1f7a
	xor b			;1f7b
	ret c			;1f7c
	nop			;1f7d
	nop			;1f7e
	nop			;1f7f
	nop			;1f80
	ret z			;1f81
	jr nc,$+98		;1f82
	sbc a,b			;1f84
	nop			;1f85
	nop			;1f86
	nop			;1f87
	nop			;1f88
	adc a,b			;1f89
	adc a,b			;1f8a
	adc a,b			;1f8b
	ld a,b			;1f8c
	ex af,af'		;1f8d
	ld (hl),b		;1f8e
	nop			;1f8f
	nop			;1f90
	ret m			;1f91
	jr nc,$+66		;1f92
	ret m			;1f94
	nop			;1f95
	nop			;1f96
	djnz $+34		;1f97
	jr nz,$+66		;1f99
	jr nz,$+34		;1f9b
	djnz $+2		;1f9d
	jr nz,$+34		;1f9f
	jr nz,$+34		;1fa1
	jr nz,$+34		;1fa3
	jr nz,$+2		;1fa5
	ld b,b			;1fa7
	jr nz,$+34		;1fa8
	djnz $+34		;1faa
	jr nz,$+66		;1fac
	nop			;1fae
	ld d,b			;1faf
	and b			;1fb0
	nop			;1fb1
	nop			;1fb2
	nop			;1fb3
	nop			;1fb4
	nop			;1fb5
	nop			;1fb6
	nop			;1fb7
	jr nz,$+82		;1fb8
	ld d,b			;1fba
	ret m			;1fbb
	nop			;1fbc
	nop			;1fbd
	nop			;1fbe
	ld (hl),b		;1fbf
	adc a,b			;1fc0
	add a,b			;1fc1
	add a,b			;1fc2
	adc a,b			;1fc3
	ld (hl),b		;1fc4
	jr nz,$+66		;1fc5
	ld d,b			;1fc7
	nop			;1fc8
	adc a,b			;1fc9
	adc a,b			;1fca
	adc a,b			;1fcb
	ld a,b			;1fcc
	nop			;1fcd
	nop			;1fce
	ex af,af'		;1fcf
	djnz $+114		;1fd0
	sbc a,b			;1fd2
	ret po			;1fd3
	ld a,b			;1fd4
	nop			;1fd5
	nop			;1fd6
	jr nz,$+82		;1fd7
	ld a,b			;1fd9
	adc a,b			;1fda
	sbc a,b			;1fdb
	ld l,b			;1fdc
	nop			;1fdd
	nop			;1fde
	ld d,b			;1fdf
	nop			;1fe0
	ld a,b			;1fe1
	adc a,b			;1fe2
	sbc a,b			;1fe3
	ld l,b			;1fe4
	nop			;1fe5
	nop			;1fe6
	ld b,b			;1fe7
	jr nz,$+122		;1fe8
	adc a,b			;1fea
	sbc a,b			;1feb
	ld l,b			;1fec
	nop			;1fed
	nop			;1fee
	jr nz,$+2		;1fef
	ld a,b			;1ff1
	adc a,b			;1ff2
	sbc a,b			;1ff3
	ld l,b			;1ff4
	nop			;1ff5
	nop			;1ff6
	nop			;1ff7
	nop			;1ff8
	ld a,b			;1ff9
	add a,b			;1ffa
	add a,b			;1ffb
	ld a,b			;1ffc
	jr nz,$+66		;1ffd
	jr nz,$+82		;1fff
	ld (hl),b		;2001
	sbc a,b			;2002
	ret po			;2003
	ld a,b			;2004
	nop			;2005
	nop			;2006
	ld d,b			;2007
	nop			;2008
	ld (hl),b		;2009
	sbc a,b			;200a
	ret po			;200b
	ld a,b			;200c
	nop			;200d
	nop			;200e
	ld b,b			;200f
	jr nz,$+114		;2010
	sbc a,b			;2012
	ret po			;2013
	ld a,b			;2014
	nop			;2015
	nop			;2016
	ld d,b			;2017
	nop			;2018
	ld h,b			;2019
	jr nz,$+34		;201a
	ld (hl),b		;201c
	nop			;201d
	nop			;201e
	jr nz,$+82		;201f
	ld h,b			;2021
	jr nz,$+34		;2022
	ld (hl),b		;2024
	nop			;2025
	nop			;2026
	ld b,b			;2027
	jr nz,$+98		;2028
	jr nz,$+34		;202a
	ld (hl),b		;202c
	nop			;202d
	nop			;202e
	ld d,b			;202f
	ld (hl),b		;2030
	adc a,b			;2031
	adc a,b			;2032
	ret m			;2033
	adc a,b			;2034
	nop			;2035
	nop			;2036
	jr nz,$+114		;2037
	adc a,b			;2039
	adc a,b			;203a
	ret m			;203b
	adc a,b			;203c
	nop			;203d
	nop			;203e
	jr $-6			;203f
	add a,b			;2041
	ret po			;2042
	add a,b			;2043
	ret m			;2044
	nop			;2045
	nop			;2046
	nop			;2047
	nop			;2048
	ret nc			;2049
	ld l,b			;204a
	or b			;204b
	ret c			;204c
	nop			;204d
	nop			;204e
	ld a,b			;204f
	and b			;2050
	or b			;2051
	ret po			;2052
	and b			;2053
	cp b			;2054
	nop			;2055
	nop			;2056
	jr nz,$+82		;2057
	ld (hl),b		;2059
	adc a,b			;205a
	adc a,b			;205b
	ld (hl),b		;205c
	nop			;205d
	nop			;205e
	ld d,b			;205f
	nop			;2060
	ld (hl),b		;2061
	adc a,b			;2062
	adc a,b			;2063
	ld (hl),b		;2064
	nop			;2065
	nop			;2066
	ld b,b			;2067
	jr nz,$+114		;2068
	adc a,b			;206a
	adc a,b			;206b
	ld (hl),b		;206c
	nop			;206d
	nop			;206e
	jr nz,$+82		;206f
	adc a,b			;2071
	adc a,b			;2072
	adc a,b			;2073
	ld a,b			;2074
	nop			;2075
	nop			;2076
	ld b,b			;2077
	jr nz,$-118		;2078
	adc a,b			;207a
	adc a,b			;207b
	ld a,b			;207c
	nop			;207d
	nop			;207e
	ld d,b			;207f
	nop			;2080
	adc a,b			;2081
	adc a,b			;2082
	adc a,b			;2083
	ld a,b			;2084
	ex af,af'		;2085
	ld (hl),b		;2086
	ld d,b			;2087
	ld (hl),b		;2088
	adc a,b			;2089
	adc a,b			;208a
	adc a,b			;208b
	ld (hl),b		;208c
	nop			;208d
	nop			;208e
	ld d,b			;208f
	adc a,b			;2090
	adc a,b			;2091
	adc a,b			;2092
	adc a,b			;2093
	ld (hl),b		;2094
	nop			;2095
	nop			;2096
	jr nz,$+34		;2097
	ld a,b			;2099
	add a,b			;209a
	add a,b			;209b
	ld a,b			;209c
	jr nz,$+34		;209d
	jr nz,$+82		;209f
	ld b,b			;20a1
	ret po			;20a2
	ld b,b			;20a3
	ld c,b			;20a4
	or b			;20a5
	nop			;20a6
	adc a,b			;20a7
	adc a,b			;20a8
	ld d,b			;20a9
	ret m			;20aa
	jr nz,$+114		;20ab
	jr nz,$+2		;20ad
	add a,b			;20af
	ret nc			;20b0
	or b			;20b1
	or b			;20b2
	cp b			;20b3
	ret nc			;20b4
	adc a,b			;20b5
	add a,b			;20b6
	jr c,$+66		;20b7
	ret p			;20b9
	ld b,b			;20ba
	ret p			;20bb
	ld b,b			;20bc
	jr c,$+2		;20bd
	ex af,af'		;20bf
	djnz $+122		;20c0
	adc a,b			;20c2
	sbc a,b			;20c3
	ld l,b			;20c4
	nop			;20c5
	nop			;20c6
	djnz $+34		;20c7
	ld h,b			;20c9
	jr nz,$+34		;20ca
	ld (hl),b		;20cc
	nop			;20cd
	nop			;20ce
	djnz $+34		;20cf
	ld (hl),b		;20d1
	adc a,b			;20d2
	adc a,b			;20d3
	ld (hl),b		;20d4
	nop			;20d5
	nop			;20d6
	djnz $+34		;20d7
	adc a,b			;20d9
	adc a,b			;20da
	adc a,b			;20db
	ld a,b			;20dc
	nop			;20dd
	nop			;20de
	jr z,$+82		;20df
	ret p			;20e1
	adc a,b			;20e2
	adc a,b			;20e3
	adc a,b			;20e4
	nop			;20e5
	nop			;20e6
	jr z,$-46		;20e7
	xor b			;20e9
	xor b			;20ea
	sbc a,b			;20eb
	adc a,b			;20ec
	nop			;20ed
	nop			;20ee
	nop			;20ef
	nop			;20f0
	ld a,b			;20f1
	adc a,b			;20f2
	sbc a,b			;20f3
	ld l,b			;20f4
	nop			;20f5
	ld (hl),b		;20f6
	nop			;20f7
	nop			;20f8
	ld (hl),b		;20f9
	adc a,b			;20fa
	adc a,b			;20fb
	ld (hl),b		;20fc
	nop			;20fd
	ld (hl),b		;20fe
	jr nz,$+2		;20ff
	jr nz,$+98		;2101
	adc a,b			;2103
	ld (hl),b		;2104
	nop			;2105
	nop			;2106
	nop			;2107
	nop			;2108
	nop			;2109
	ret po			;210a
	add a,b			;210b
	nop			;210c
	nop			;210d
	nop			;210e
	nop			;210f
	nop			;2110
	nop			;2111
	ret po			;2112
	jr nz,$+2		;2113
	nop			;2115
	nop			;2116
	ld b,b			;2117
	ld c,b			;2118
	ld d,b			;2119
	jr nc,$+74		;211a
	sub b			;211c
	jr c,$+2		;211d
	ld b,b			;211f
	ld c,b			;2120
	ld d,b			;2121
	jr z,$+90		;2122
	cp b			;2124
	ex af,af'		;2125
	nop			;2126
	jr nz,$+2		;2127
	jr nz,$+34		;2129
	jr nz,$+34		;212b
	nop			;212d
	nop			;212e
	nop			;212f
	nop			;2130
	nop			;2131
	ld c,b			;2132
	sub b			;2133
	ld c,b			;2134
	nop			;2135
	nop			;2136
	nop			;2137
	nop			;2138
	nop			;2139
	sub b			;213a
	ld c,b			;213b
	sub b			;213c
	nop			;213d
	nop			;213e
	jr z,$+82		;213f
	ld (hl),b		;2141
	adc a,b			;2142
	ret m			;2143
	adc a,b			;2144
	nop			;2145
	nop			;2146
	jr z,$+82		;2147
	ld a,b			;2149
	adc a,b			;214a
	sbc a,b			;214b
	ld l,b			;214c
	nop			;214d
	nop			;214e
	jr z,$+82		;214f
	ld (hl),b		;2151
	jr nz,$+34		;2152
	ld (hl),b		;2154
	nop			;2155
	nop			;2156
	jr z,$+82		;2157
	ld h,b			;2159
	jr nz,$+34		;215a
	ld (hl),b		;215c
	nop			;215d
	nop			;215e
	jr z,$+114		;215f
	adc a,b			;2161
	adc a,b			;2162
	adc a,b			;2163
	ld (hl),b		;2164
	nop			;2165
	nop			;2166
	jr z,$+82		;2167
	ld (hl),b		;2169
	adc a,b			;216a
	adc a,b			;216b
	ld (hl),b		;216c
	nop			;216d
	nop			;216e
	jr z,$+82		;216f
	adc a,b			;2171
	adc a,b			;2172
	adc a,b			;2173
	ld a,b			;2174
	nop			;2175
	nop			;2176
	jr z,$+82		;2177
	nop			;2179
	adc a,b			;217a
	adc a,b			;217b
	ld a,b			;217c
	nop			;217d
	nop			;217e
	call m,04848h		;217f
	ld c,b			;2182
	ld c,b			;2183
	ret pe			;2184
	ex af,af'		;2185
	jr nc,$+74		;2186
	nop			;2188
	ret c			;2189
	ld c,b			;218a
	ld c,b			;218b
	ret pe			;218c
	ex af,af'		;218d
	jr nc,$-30		;218e
	ld l,b			;2190
	jr nc,$-22		;2191
	ld e,b			;2193
	cp b			;2194
	ex af,af'		;2195
	nop			;2196
	ld d,b			;2197
	jr z,$+2		;2198
	nop			;219a
	nop			;219b
	nop			;219c
	nop			;219d
	nop			;219e
	nop			;219f
	jr nz,$+82		;21a0
	adc a,b			;21a2
	ld d,b			;21a3
	jr nz,$+2		;21a4
	nop			;21a6
	nop			;21a7
	ld c,b			;21a8
	ld d,b			;21a9
	jr nz,$+106		;21aa
	xor b			;21ac
	nop			;21ad
	nop			;21ae
	ld a,h			;21af
	xor b			;21b0
	xor b			;21b1
	xor b			;21b2
	ld l,b			;21b3
	jr z,$+42		;21b4
	ld b,h			;21b6
	ld (hl),b		;21b7
	add a,b			;21b8
	ld (hl),b		;21b9
	adc a,b			;21ba
	ld (hl),b		;21bb
	ex af,af'		;21bc
	adc a,b			;21bd
	ld (hl),b		;21be
	nop			;21bf
	nop			;21c0
	nop			;21c1
	nop			;21c2
	nop			;21c3
	nop			;21c4
	rst 38h			;21c5
	rst 38h			;21c6
	ret p			;21c7
	ret p			;21c8
	ret p			;21c9
	ret p			;21ca
	rrca			;21cb
	rrca			;21cc
	rrca			;21cd
	rrca			;21ce
	nop			;21cf
	nop			;21d0
	rst 38h			;21d1
	rst 38h			;21d2
	rst 38h			;21d3
	rst 38h			;21d4
	rst 38h			;21d5
	rst 38h			;21d6
	rst 38h			;21d7
	rst 38h			;21d8
	nop			;21d9
	nop			;21da
	nop			;21db
	nop			;21dc
	nop			;21dd
	nop			;21de
	nop			;21df
	nop			;21e0
	nop			;21e1
	inc a			;21e2
	inc a			;21e3
	nop			;21e4
	nop			;21e5
	nop			;21e6
	rst 38h			;21e7
	rst 38h			;21e8
	rst 38h			;21e9
	rst 38h			;21ea
	rst 38h			;21eb
	rst 38h			;21ec
	nop			;21ed
	nop			;21ee
	ret nz			;21ef
	ret nz			;21f0
	ret nz			;21f1
	ret nz			;21f2
	ret nz			;21f3
	ret nz			;21f4
	ret nz			;21f5
	ret nz			;21f6
	rrca			;21f7
	rrca			;21f8
	rrca			;21f9
	rrca			;21fa
	ret p			;21fb
	ret p			;21fc
	ret p			;21fd
	ret p			;21fe
	call m,0fcfch		;21ff
	call m,0fcfch		;2202
	call m,003fch		;2205
	inc bc			;2208
	inc bc			;2209
	inc bc			;220a
	inc bc			;220b
	inc bc			;220c
	inc bc			;220d
	inc bc			;220e
	ccf			;220f
	ccf			;2210
	ccf			;2211
	ccf			;2212
	ccf			;2213
	ccf			;2214
	ccf			;2215
	ccf			;2216
	ld de,04422h		;2217
	adc a,b			;221a
	ld de,04422h		;221b
	adc a,b			;221e
	adc a,b			;221f
	ld b,h			;2220
	ld (08811h),hl		;2221
	ld b,h			;2224
	ld (0fe11h),hl		;2225
	ld a,h			;2228
	jr c,$+18		;2229
	nop			;222b
	nop			;222c
	nop			;222d
	nop			;222e
	nop			;222f
	nop			;2230
	nop			;2231
	nop			;2232
	djnz $+58		;2233
	ld a,h			;2235
	cp 080h			;2236
	ret nz			;2238
	ret po			;2239
	ret p			;223a
	ret po			;223b
	ret nz			;223c
	add a,b			;223d
	nop			;223e
	ld bc,00703h		;223f
	rrca			;2242
	rlca			;2243
	inc bc			;2244
	ld bc,0ff00h		;2245
	ld a,(hl)		;2248
	inc a			;2249
	jr $+26			;224a
	inc a			;224c
	ld a,(hl)		;224d
	rst 38h			;224e
	add a,c			;224f
	jp 0ffe7h		;2250
	rst 38h			;2253
	rst 20h			;2254
	jp 0f081h		;2255
	ret p			;2258
	ret p			;2259
	ret p			;225a
	nop			;225b
	nop			;225c
	nop			;225d
	nop			;225e
	nop			;225f
	nop			;2260
	nop			;2261
	nop			;2262
	rrca			;2263
	rrca			;2264
	rrca			;2265
	rrca			;2266
	rrca			;2267
	rrca			;2268
	rrca			;2269
	rrca			;226a
	nop			;226b
	nop			;226c
	nop			;226d
	nop			;226e
	nop			;226f
	nop			;2270
	nop			;2271
	nop			;2272
	ret p			;2273
	ret p			;2274
	ret p			;2275
	ret p			;2276
	inc sp			;2277
	inc sp			;2278
	call z,033cch		;2279
	inc sp			;227c
	call z,000cch		;227d
	djnz $+42		;2280
	jr z,$+126		;2282
	nop			;2284
	nop			;2285
	nop			;2286
	djnz $+18		;2287
	jr c,$+18		;2289
	jr c,$+18		;228b
	djnz $+2		;228d
	nop			;228f
	nop			;2290
	ld d,b			;2291
	adc a,b			;2292
	xor b			;2293
	ld d,b			;2294
	nop			;2295
	nop			;2296
	rst 38h			;2297
	rst 38h			;2298
	rst 38h			;2299
	rst 38h			;229a
	rst 38h			;229b
	rst 38h			;229c
	rst 38h			;229d
	rst 38h			;229e
	nop			;229f
	nop			;22a0
	nop			;22a1
	nop			;22a2
	rst 38h			;22a3
	rst 38h			;22a4
	rst 38h			;22a5
	rst 38h			;22a6
	ret p			;22a7
	ret p			;22a8
	ret p			;22a9
	ret p			;22aa
	ret p			;22ab
	ret p			;22ac
	ret p			;22ad
	ret p			;22ae
	rrca			;22af
	rrca			;22b0
	rrca			;22b1
	rrca			;22b2
	rrca			;22b3
	rrca			;22b4
	rrca			;22b5
	rrca			;22b6
	rst 38h			;22b7
	rst 38h			;22b8
	rst 38h			;22b9
	rst 38h			;22ba
	nop			;22bb
	nop			;22bc
	nop			;22bd
	nop			;22be
	nop			;22bf
	nop			;22c0
	ld l,b			;22c1
	sub b			;22c2
	sub b			;22c3
	ld l,b			;22c4
	nop			;22c5
	nop			;22c6
	ld h,b			;22c7
	sub b			;22c8
	ret po			;22c9
	sub b			;22ca
	sub b			;22cb
	ret po			;22cc
	add a,b			;22cd
	nop			;22ce
	ret m			;22cf
	adc a,b			;22d0
	add a,b			;22d1
	add a,b			;22d2
	add a,b			;22d3
	add a,b			;22d4
	nop			;22d5
	nop			;22d6
	ret m			;22d7
	ld d,b			;22d8
	ld d,b			;22d9
	ld d,b			;22da
	ld d,b			;22db
	ld c,b			;22dc
	add a,b			;22dd
	nop			;22de
	ret m			;22df
	ld c,b			;22e0
	jr nz,$+66		;22e1
	adc a,b			;22e3
	ret m			;22e4
	nop			;22e5
	nop			;22e6
	nop			;22e7
	nop			;22e8
	ld a,b			;22e9
	sub b			;22ea
	adc a,b			;22eb
	ld (hl),b		;22ec
	nop			;22ed
	nop			;22ee
	nop			;22ef
	nop			;22f0
	adc a,b			;22f1
	adc a,b			;22f2
	ret z			;22f3
	or b			;22f4
	add a,b			;22f5
	add a,b			;22f6
	nop			;22f7
	nop			;22f8
	ld d,b			;22f9
	ld d,b			;22fa
	jr nz,$+82		;22fb
	ld d,b			;22fd
	jr nz,$+114		;22fe
	jr nz,$+114		;2300
	xor b			;2302
	xor b			;2303
	ld (hl),b		;2304
	jr nz,$+114		;2305
	ld (hl),b		;2307
	adc a,b			;2308
	ret m			;2309
	adc a,b			;230a
	adc a,b			;230b
	ld (hl),b		;230c
	nop			;230d
	nop			;230e
	ld (hl),b		;230f
	adc a,b			;2310
	adc a,b			;2311
	adc a,b			;2312
	ld d,b			;2313
	ret c			;2314
	nop			;2315
	nop			;2316
	jr nc,$+66		;2317
	jr nc,$+74		;2319
	ld c,b			;231b
	jr nc,$+2		;231c
	nop			;231e
	nop			;231f
	nop			;2320
	ld d,b			;2321
	xor b			;2322
	xor b			;2323
	ld d,b			;2324
	nop			;2325
	nop			;2326
	nop			;2327
	djnz $+114		;2328
	xor b			;232a
	xor b			;232b
	ld (hl),b		;232c
	ld b,b			;232d
	nop			;232e
	nop			;232f
	ld (hl),b		;2330
	add a,b			;2331
	ret po			;2332
	add a,b			;2333
	ld (hl),b		;2334
	nop			;2335
	nop			;2336
	ld (hl),b		;2337
	adc a,b			;2338
	adc a,b			;2339
	adc a,b			;233a
	adc a,b			;233b
	adc a,b			;233c
	nop			;233d
	nop			;233e
	nop			;233f
	ret m			;2340
	nop			;2341
	ret m			;2342
	nop			;2343
	ret m			;2344
	nop			;2345
	nop			;2346
	nop			;2347
	jr nz,$+34		;2348
	ret m			;234a
	jr nz,$+34		;234b
	ret m			;234d
	nop			;234e
	nop			;234f
	ret nz			;2350
	jr nc,$+10		;2351
	jr nc,$-62		;2353
	ret m			;2355
	nop			;2356
	nop			;2357
	jr $+98			;2358
	add a,b			;235a
	ld h,b			;235b
	jr $-6			;235c
	nop			;235e
	nop			;235f
	jr $+34			;2360
	jr nz,$+34		;2362
	jr nz,$+34		;2364
	jr nz,$+34		;2366
	jr nz,$+34		;2368
	jr nz,$+34		;236a
	jr nz,$-62		;236c
	nop			;236e
	nop			;236f
	jr nz,$+2		;2370
	ret m			;2372
	nop			;2373
	jr nz,$+2		;2374
	nop			;2376
	nop			;2377
	ld l,b			;2378
	or b			;2379
	nop			;237a
	ld l,b			;237b
	or b			;237c
	nop			;237d
	nop			;237e
	nop			;237f
	jr nc,$+74		;2380
	ld c,b			;2382
	jr nc,$+2		;2383
	nop			;2385
	nop			;2386
	nop			;2387
	jr nc,$+122		;2388
	ld a,b			;238a
	jr nc,$+2		;238b
	nop			;238d
	nop			;238e
	nop			;238f
	nop			;2390
	nop			;2391
	nop			;2392
	jr nc,$+2		;2393
	nop			;2395
	nop			;2396
	inc e			;2397
	djnz $+18		;2398
	sub b			;239a
	ld d,b			;239b
	jr nc,$+18		;239c
	nop			;239e
	ret po			;239f
	sub b			;23a0
	sub b			;23a1
	nop			;23a2
	nop			;23a3
	nop			;23a4
	nop			;23a5
	nop			;23a6
	ld h,b			;23a7
	djnz $+98		;23a8
	ret p			;23aa
	nop			;23ab
	nop			;23ac
	nop			;23ad
	nop			;23ae
	nop			;23af
	ld (hl),b		;23b0
	ld (hl),b		;23b1
	ld (hl),b		;23b2
	ld (hl),b		;23b3
	ld (hl),b		;23b4
	ld (hl),b		;23b5
	nop			;23b6
	xor d			;23b7
	ld d,l			;23b8
	xor d			;23b9
	ld d,l			;23ba
	xor d			;23bb
	ld d,l			;23bc
	xor d			;23bd
	ld d,l			;23be
	push bc			;23bf
	push hl			;23c0
	push af			;23c1
	ld d,a			;23c2
	and a			;23c3
	di			;23c4
	call m,024deh		;23c5
	pop af			;23c8
	pop hl			;23c9
	push hl			;23ca
	push de			;23cb
	push hl			;23cc
	push af			;23cd
	ld a,h			;23ce
	rlca			;23cf
	rlca			;23d0
	and 003h		;23d1
	ld l,a			;23d3
	ld b,a			;23d4
	ld a,0fch		;23d5
	call 023f8h		;23d7
	ld e,a			;23da
	ld b,l			;23db
	pop af			;23dc
	and 003h		;23dd
	call 023f8h		;23df
	ld b,a			;23e2
	in a,(0a8h)		;23e3
	ld d,a			;23e5
	and e			;23e6
	or b			;23e7
	pop hl			;23e8
	call 0f380h		;23e9
	ld a,e			;23ec
	pop de			;23ed
	push af			;23ee
	bit 7,d			;23ef
	call nz,0251ah		;23f1
	pop af			;23f4
	pop hl			;23f5
	pop bc			;23f6
	ret			;23f7
	inc b			;23f8
	dec b			;23f9
	ret z			;23fa
	rlca			;23fb
	rlca			;23fc
	djnz $-2		;23fd
	ret			;23ff
	push hl			;2400
	ld d,a			;2401
	push de			;2402
	and a			;2403
	di			;2404
	call m,024deh		;2405
	pop bc			;2408
	pop hl			;2409
	push de			;240a
	push hl			;240b
	ld a,h			;240c
	rlca			;240d
	rlca			;240e
	and 003h		;240f
	ld l,a			;2411
	ld b,a			;2412
	ld a,0fch		;2413
	call 023f8h		;2415
	ld e,a			;2418
	ld b,l			;2419
	ld a,d			;241a
	and 003h		;241b
	call 023f8h		;241d
	ld b,a			;2420
	in a,(0a8h)		;2421
	ld d,a			;2423
	and e			;2424
	or b			;2425
	pop hl			;2426
	ld e,c			;2427
	call 0f385h		;2428
	pop de			;242b
	push hl			;242c
	bit 7,d			;242d
	call nz,0251ah		;242f
	pop hl			;2432
	ret			;2433
	ex af,af'		;2434
	exx			;2435
	di			;2436
	push iy			;2437
	pop af			;2439
	push ix			;243a
	pop hl			;243c
	ld d,a			;243d
	and a			;243e
	call m,024deh		;243f
	push de			;2442
	ld a,d			;2443
	and 003h		;2444
	ld b,a			;2446
	ld c,0fch		;2447
	push ix			;2449
	pop af			;244b
	rlca			;244c
	rlca			;244d
	and 003h		;244e
	add a,a			;2450
	jr z,$+9		;2451
	rlc b			;2453
	rlc c			;2455
	dec a			;2457
	jr nz,$-5		;2458
	ld hl,02467h		;245a
	push hl			;245d
	in a,(0a8h)		;245e
	push af			;2460
	and c			;2461
	or b			;2462
	exx			;2463
	jp 0f38ch		;2464
	ex af,af'		;2467
	exx			;2468
	di			;2469
	pop de			;246a
	bit 7,d			;246b
	call nz,0251ah		;246d
	ex af,af'		;2470
	exx			;2471
	ret			;2472
	di			;2473
	push hl			;2474
	ld l,a			;2475
	and 003h		;2476
	ld b,a			;2478
	ld a,0abh		;2479
	add a,055h		;247b
	dec b			;247d
	jp p,0247bh		;247e
	ld d,a			;2481
	ld a,h			;2482
	rlca			;2483
	rlca			;2484
	and 003h		;2485
	ld h,a			;2487
	ld b,a			;2488
	ld a,0c0h		;2489
	rlca			;248b
	rlca			;248c
	dec b			;248d
	jp p,0248bh		;248e
	ld e,a			;2491
	cpl			;2492
	ld c,a			;2493
	ld a,d			;2494
	and e			;2495
	ld b,a			;2496
	ld a,l			;2497
	and a			;2498
	jp p,024d6h		;2499
	rrca			;249c
	rrca			;249d
	and 003h		;249e
	push hl			;24a0
	push bc			;24a1
	ld b,a			;24a2
	ld a,0abh		;24a3
	add a,055h		;24a5
	dec b			;24a7
	jp p,024a5h		;24a8
	and e			;24ab
	ld b,a			;24ac
	ld a,d			;24ad
	and 0c0h		;24ae
	ld h,a			;24b0
	in a,(0a8h)		;24b1
	ld l,a			;24b3
	and 0c0h		;24b4
	or h			;24b6
	out (0a8h),a		;24b7
	ld a,(0ffffh)		;24b9
	cpl			;24bc
	and c			;24bd
	or b			;24be
	ld c,a			;24bf
	ld (0ffffh),a		;24c0
	ld a,l			;24c3
	out (0a8h),a		;24c4
	ld hl,0fcc5h		;24c6
	ld a,d			;24c9
	and 003h		;24ca
	add a,l			;24cc
	ld l,a			;24cd
	ld a,h			;24ce
	adc a,000h		;24cf
	ld h,a			;24d1
	ld a,c			;24d2
	ld (hl),a		;24d3
	pop bc			;24d4
	pop hl			;24d5
	in a,(0a8h)		;24d6
	and c			;24d8
	or b			;24d9
	out (0a8h),a		;24da
	pop hl			;24dc
	ret			;24dd
	ld d,a			;24de
	rrca			;24df
	rrca			;24e0
	ld e,a			;24e1
	and 0c0h		;24e2
	ld l,a			;24e4
	in a,(0a8h)		;24e5
	ld c,a			;24e7
	and 03fh		;24e8
	or l			;24ea
	out (0a8h),a		;24eb
	ld a,e			;24ed
	and 003h		;24ee
	ld l,a			;24f0
	ld a,h			;24f1
	ld h,003h		;24f2
	jr $+4			;24f4
	add hl,hl		;24f6
	add hl,hl		;24f7
	sub 040h		;24f8
	jr nc,$-4		;24fa
	ld a,h			;24fc
	cpl			;24fd
	ld h,a			;24fe
	ld a,(0ffffh)		;24ff
	cpl			;2502
	ld e,a			;2503
	and h			;2504
	or l			;2505
	ld (0ffffh),a		;2506
	ld l,a			;2509
	ld a,c			;250a
	out (0a8h),a		;250b
	ld a,d			;250d
	and 003h		;250e
	ld c,a			;2510
	ld b,000h		;2511
	ld a,l			;2513
	ld hl,0fcc5h		;2514
	add hl,bc		;2517
	ld (hl),a		;2518
	ret			;2519
	ld a,d			;251a
	rrca			;251b
	rrca			;251c
	and 0c0h		;251d
	ld b,a			;251f
	in a,(0a8h)		;2520
	ld c,a			;2522
	and 03fh		;2523
	or b			;2525
	out (0a8h),a		;2526
	ld a,e			;2528
	ld (0ffffh),a		;2529
	ld a,c			;252c
	out (0a8h),a		;252d
	ld a,d			;252f
	and 003h		;2530
	ld c,a			;2532
	ld b,000h		;2533
	ld hl,0fcc5h		;2535
	add hl,bc		;2538
	ld (hl),e		;2539
	ret			;253a
	out (0a8h),a		;253b
	ld e,(hl)		;253d
	jr $+5			;253e
	out (0a8h),a		;2540
	ld (hl),e		;2542
	ld a,d			;2543
	out (0a8h),a		;2544
	ret			;2546
	out (0a8h),a		;2547
	ex af,af'		;2549
	call 0f398h		;254a
	ex af,af'		;254d
	pop af			;254e
	out (0a8h),a		;254f
	ex af,af'		;2551
	ret			;2552
	jp (ix)			;2553
	nop			;2555
	ld b,e			;2556
	dec l			;2557
	ld b,d			;2558
	ld c,c			;2559
	ld c,a			;255a
	ld d,e			;255b
	jr nz,$+50		;255c
	ld l,032h		;255e
	inc sp			;2560
	jr nz,$+34		;2561
	jr nz,$+34		;2563
	jr nz,$+34		;2565
	ld h,e			;2567
	ld h,d			;2568
	ld l,c			;2569
	ld l,a			;256a
	ld (hl),e		;256b
	ld l,073h		;256c
	ld h,(hl)		;256e
	ld l,06eh		;256f
	ld h,l			;2571
	ld (hl),h		;2572
	dec c			;2573
	ld a,(bc)		;2574
	dec c			;2575
	ld a,(bc)		;2576
	dec c			;2577
	ld a,(bc)		;2578
	nop			;2579
	ld c,c			;257a
	ld l,(hl)		;257b
	ld l,c			;257c
	ld (hl),h		;257d
	jr nz,$+84		;257e
	ld c,a			;2580
	ld c,l			;2581
	jr nz,$+107		;2582
	ld l,(hl)		;2584
	jr nz,$+117		;2585
	ld l,h			;2587
	ld l,a			;2588
	ld (hl),h		;2589
	ld a,(00020h)		;258a
	ld b,e			;258d
	ld h,c			;258e
	ld l,(hl)		;258f
	ld l,(hl)		;2590
	ld l,a			;2591
	ld (hl),h		;2592
	jr nz,$+103		;2593
	ld a,b			;2595
	ld h,l			;2596
	ld h,e			;2597
	ld (hl),l		;2598
	ld (hl),h		;2599
	ld h,l			;259a
	jr nz,$+99		;259b
	jr nz,$+68		;259d
	ld b,c			;259f
	ld d,e			;25a0
	ld c,c			;25a1
	ld b,e			;25a2
	jr nz,$+84		;25a3
	ld c,a			;25a5
	ld c,l			;25a6
	ld l,00dh		;25a7
	ld a,(bc)		;25a9
	nop			;25aa
	ld b,l			;25ab
	ld d,d			;25ac
	ld d,d			;25ad
	ld c,a			;25ae
	ld d,d			;25af
	ld a,(04d00h)		;25b0
	ld b,l			;25b3
	ld c,l			;25b4
	ld c,a			;25b5
	ld d,d			;25b6
	ld e,c			;25b7
	jr nz,$+80		;25b8
	ld c,a			;25ba
	ld d,h			;25bb
	jr nz,$+72		;25bc
	ld c,a			;25be
	ld d,l			;25bf
	ld c,(hl)		;25c0
	ld b,h			;25c1
	ld l,000h		;25c2
	ld b,e			;25c4
	ld b,c			;25c5
	ld c,h			;25c6
	ld c,h			;25c7
	ld b,l			;25c8
	ld b,h			;25c9
	jr nz,$+80		;25ca
	ld c,a			;25cc
	ld c,(hl)		;25cd
	jr nz,$+71		;25ce
	ld e,b			;25d0
	ld c,c			;25d1
	ld d,e			;25d2
	ld d,h			;25d3
	ld c,c			;25d4
	ld c,(hl)		;25d5
	ld b,a			;25d6
	jr nz,$+68		;25d7
	ld b,c			;25d9
	ld d,e			;25da
	ld c,c			;25db
	ld b,e			;25dc
	ld l,000h		;25dd
	ld d,e			;25df
	ld d,h			;25e0
	ld b,c			;25e1
	ld b,e			;25e2
	ld c,e			;25e3
	jr nz,$+71		;25e4
	ld d,d			;25e6
	ld d,d			;25e7
	ld c,a			;25e8
	ld d,d			;25e9
	ld l,000h		;25ea
	dec c			;25ec
	ld a,(bc)		;25ed
	dec c			;25ee
	ld a,(bc)		;25ef
	ld c,(hl)		;25f0
	ld l,a			;25f1
	jr nz,$+101		;25f2
	ld h,c			;25f4
	ld (hl),d		;25f5
	ld (hl),h		;25f6
	ld (hl),d		;25f7
	ld l,c			;25f8
	ld h,h			;25f9
	ld h,a			;25fa
	ld h,l			;25fb
	jr nz,$+104		;25fc
	ld l,a			;25fe
	ld (hl),l		;25ff
	ld l,(hl)		;2600
	ld h,h			;2601
	ld l,00dh		;2602
	ld a,(bc)		;2604
	dec c			;2605
	ld a,(bc)		;2606
	ld d,h			;2607
	ld l,b			;2608
	ld l,c			;2609
	ld (hl),e		;260a
	jr nz,$+120		;260b
	ld h,l			;260d
	ld (hl),d		;260e
	ld (hl),e		;260f
	ld l,c			;2610
	ld l,a			;2611
	ld l,(hl)		;2612
	jr nz,$+113		;2613
	ld h,(hl)		;2615
	jr nz,$+69		;2616
	dec l			;2618
	ld b,d			;2619
	ld c,c			;261a
	ld c,a			;261b
	ld d,e			;261c
	jr nz,$+101		;261d
	ld h,c			;261f
	ld l,(hl)		;2620
	dec c			;2621
	ld a,(bc)		;2622
	ld l,a			;2623
	ld l,(hl)		;2624
	ld l,h			;2625
	ld a,c			;2626
	jr nz,$+117		;2627
	ld (hl),h		;2629
	ld h,c			;262a
	ld (hl),d		;262b
	ld (hl),h		;262c
	jr nz,$+101		;262d
	ld h,c			;262f
	ld (hl),d		;2630
	ld (hl),h		;2631
	ld (hl),d		;2632
	ld l,c			;2633
	ld h,h			;2634
	ld h,a			;2635
	ld h,l			;2636
	ld (hl),e		;2637
	ld l,00dh		;2638
	ld a,(bc)		;263a
	ld d,b			;263b
	ld l,h			;263c
	ld h,l			;263d
	ld h,c			;263e
	ld (hl),e		;263f
	ld h,l			;2640
	jr nz,$+116		;2641
	ld h,l			;2643
	ld (hl),e		;2644
	ld (hl),h		;2645
	ld h,c			;2646
	ld (hl),d		;2647
	ld (hl),h		;2648
	jr nz,$+123		;2649
	ld l,a			;264b
	ld (hl),l		;264c
	ld (hl),d		;264d
	jr nz,$+79		;264e
	ld d,e			;2650
	ld e,b			;2651
	dec c			;2652
	ld a,(bc)		;2653
	jr z,$+103		;2654
	ld l,l			;2656
	ld (hl),l		;2657
	ld l,h			;2658
	ld h,c			;2659
	ld (hl),h		;265a
	ld l,a			;265b
	ld (hl),d		;265c
	add hl,hl		;265d
	jr nz,$+121		;265e
	ld l,c			;2660
	ld (hl),h		;2661
	ld l,b			;2662
	jr nz,$+99		;2663
	jr nz,$+101		;2665
	ld h,c			;2667
	ld (hl),d		;2668
	ld (hl),h		;2669
	ld (hl),d		;266a
	ld l,c			;266b
	ld h,h			;266c
	ld h,a			;266d
	ld h,l			;266e
	dec c			;266f
	ld a,(bc)		;2670
	ld l,c			;2671
	ld l,(hl)		;2672
	ld (hl),e		;2673
	ld h,l			;2674
	ld (hl),d		;2675
	ld (hl),h		;2676
	ld h,l			;2677
	ld h,h			;2678
	ld l,000h		;2679
	jr nc,$+51		;267b
	ld (03433h),a		;267d
	dec (hl)		;2680
	ld (hl),037h		;2681
	jr c,$+59		;2683
	dec l			;2685
	dec a			;2686
	ld e,h			;2687
	ld e,e			;2688
	ld e,l			;2689
	dec sp			;268a
	daa			;268b
	ld h,b			;268c
	inc l			;268d
	ld l,02fh		;268e
	nop			;2690
	ld h,c			;2691
	ld h,d			;2692
	ld h,e			;2693
	ld h,h			;2694
	ld h,l			;2695
	ld h,(hl)		;2696
	ld h,a			;2697
	ld l,b			;2698
	ld l,c			;2699
	ld l,d			;269a
	ld l,e			;269b
	ld l,h			;269c
	ld l,l			;269d
	ld l,(hl)		;269e
	ld l,a			;269f
	ld (hl),b		;26a0
	ld (hl),c		;26a1
	ld (hl),d		;26a2
	ld (hl),e		;26a3
	ld (hl),h		;26a4
	ld (hl),l		;26a5
	halt			;26a6
	ld (hl),a		;26a7
	ld a,b			;26a8
	ld a,c			;26a9
	ld a,d			;26aa
	add hl,hl		;26ab
	ld hl,02340h		;26ac
	inc h			;26af
	dec h			;26b0
	ld e,(hl)		;26b1
	ld h,02ah		;26b2
	jr z,$+97		;26b4
	dec hl			;26b6
	ld a,h			;26b7
	ld a,e			;26b8
	ld a,l			;26b9
	ld a,(07e22h)		;26ba
	inc a			;26bd
	ld a,03fh		;26be
	nop			;26c0
	ld b,c			;26c1
	ld b,d			;26c2
	ld b,e			;26c3
	ld b,h			;26c4
	ld b,l			;26c5
	ld b,(hl)		;26c6
	ld b,a			;26c7
	ld c,b			;26c8
	ld c,c			;26c9
	ld c,d			;26ca
	ld c,e			;26cb
	ld c,h			;26cc
	ld c,l			;26cd
	ld c,(hl)		;26ce
	ld c,a			;26cf
	ld d,b			;26d0
	ld d,c			;26d1
	ld d,d			;26d2
	ld d,e			;26d3
	ld d,h			;26d4
	ld d,l			;26d5
	ld d,(hl)		;26d6
	ld d,a			;26d7
	ld e,b			;26d8
	ld e,c			;26d9
	ld e,d			;26da
	add hl,bc		;26db
	xor h			;26dc
	xor e			;26dd
	cp d			;26de
	rst 28h			;26df
	cp l			;26e0
	call p,0ecfbh		;26e1
	rlca			;26e4
	rla			;26e5
	pop af			;26e6
	ld e,001h		;26e7
	dec c			;26e9
	ld b,005h		;26ea
	cp e			;26ec
	di			;26ed
	jp p,0001dh		;26ee
	call nz,0bc11h		;26f1
	rst 0			;26f4
	call 01514h		;26f5
	inc de			;26f8
	call c,0ddc6h		;26f9
	ret z			;26fc
	dec bc			;26fd
	dec de			;26fe
	jp nz,0ccdbh		;26ff
	jr $-44			;2702
	ld (de),a		;2704
	ret nz			;2705
	ld a,(de)		;2706
	rst 8			;2707
	inc e			;2708
	add hl,de		;2709
	rrca			;270a
	ld a,(bc)		;270b
	nop			;270c
	defb 0fdh,0fch,000h ;illegal sequence	;270d
	nop			;2710
	push af			;2711
	nop			;2712
	nop			;2713
	ex af,af'		;2714
	rra			;2715
	ret p			;2716
	ld d,002h		;2717
	ld c,004h		;2719
	inc bc			;271b
	rst 30h			;271c
	xor (hl)		;271d
	xor a			;271e
	or 000h			;271f
	cp 000h			;2721
	jp m,0cec1h		;2723
	call nc,0d610h		;2726
	rst 18h			;2729
	jp z,0c9deh		;272a
	inc c			;272d
	out (0c3h),a		;272e
	rst 10h			;2730
	res 5,c			;2731
	pop de			;2733
	nop			;2734
	push bc			;2735
	push de			;2736
	ret nc			;2737
	ld sp,hl		;2738
	xor d			;2739
	ret m			;273a
	ex de,hl		;273b
	sbc a,a			;273c
	exx			;273d
	cp a			;273e
	sbc a,e			;273f
	sbc a,b			;2740
	ret po			;2741
	pop hl			;2742
	rst 20h			;2743
	add a,a			;2744
	xor 0e9h		;2745
	nop			;2747
	defb 0edh ;next byte illegal after ed	;2748
	jp c,0b9b7h		;2749
	push hl			;274c
	add a,(hl)		;274d
	and (hl)		;274e
	and a			;274f
	nop			;2750
	add a,h			;2751
	sub a			;2752
	adc a,l			;2753
	adc a,e			;2754
	adc a,h			;2755
	sub h			;2756
	add a,c			;2757
	or c			;2758
	and c			;2759
	sub c			;275a
	or e			;275b
	or l			;275c
	and 0a4h		;275d
	and d			;275f
	and e			;2760
	add a,e			;2761
	sub e			;2762
	adc a,c			;2763
	sub (hl)		;2764
	add a,d			;2765
	sub l			;2766
	adc a,b			;2767
	adc a,d			;2768
	and b			;2769
	add a,l			;276a
	ret c			;276b
	xor l			;276c
	sbc a,(hl)		;276d
	cp (hl)			;276e
	sbc a,h			;276f
	sbc a,l			;2770
	nop			;2771
	nop			;2772
	jp po,00080h		;2773
	nop			;2776
	nop			;2777
	ret pe			;2778
	jp pe,0b8b6h		;2779
	call po,0008fh		;277c
	xor b			;277f
	nop			;2780
	adc a,(hl)		;2781
	nop			;2782
	nop			;2783
	nop			;2784
	nop			;2785
	sbc a,c			;2786
	sbc a,d			;2787
	or b			;2788
	nop			;2789
	sub d			;278a
	or d			;278b
	or h			;278c
	nop			;278d
	and l			;278e
	nop			;278f
	ex (sp),hl		;2790
	nop			;2791
	nop			;2792
	nop			;2793
	nop			;2794
	sub b			;2795
	nop			;2796
	nop			;2797
	nop			;2798
	nop			;2799
	nop			;279a
	nop			;279b
	nop			;279c
	nop			;279d
	nop			;279e
	nop			;279f
	nop			;27a0
	nop			;27a1
	nop			;27a2
	nop			;27a3
	nop			;27a4
	dec de			;27a5
	add hl,bc		;27a6
	nop			;27a7
	ex af,af'		;27a8
	nop			;27a9
	dec c			;27aa
	jr nz,$+14		;27ab
	nop			;27ad
	nop			;27ae
	dec e			;27af
	ld e,01fh		;27b0
	inc e			;27b2
	ld hl,(02f2bh)		;27b3
	jr nc,$+51		;27b6
	ld (03433h),a		;27b8
	dec (hl)		;27bb
	ld (hl),037h		;27bc
	jr c,$+59		;27be
	dec l			;27c0
	inc l			;27c1
	ld l,000h		;27c2
	add a,b			;27c4
	ld (hl),b		;27c5
	add a,c			;27c6
	nop			;27c7
	add a,d			;27c8
	ld bc,0f584h		;27c9
	add a,a			;27cc
	nop			;27cd
	ld b,b			;27ce
	nop			;27cf
	nop			;27d0
	nop			;27d1
	nop			;27d2
	nop			;27d3
	nop			;27d4
	nop			;27d5
	nop			;27d6
	nop			;27d7
	nop			;27d8
	nop			;27d9
	nop			;27da
	nop			;27db
	nop			;27dc
	nop			;27dd
	nop			;27de
	nop			;27df
	nop			;27e0
	nop			;27e1
	nop			;27e2
	nop			;27e3
	nop			;27e4
	nop			;27e5
	nop			;27e6
	nop			;27e7
	nop			;27e8
	nop			;27e9
	nop			;27ea
	nop			;27eb
	nop			;27ec
	nop			;27ed
	nop			;27ee
	nop			;27ef
	nop			;27f0
	nop			;27f1
	nop			;27f2
	nop			;27f3
	nop			;27f4
	nop			;27f5
	nop			;27f6
	nop			;27f7
	nop			;27f8
	nop			;27f9
	nop			;27fa
	nop			;27fb
	nop			;27fc
	nop			;27fd
	nop			;27fe
	nop			;27ff
	nop			;2800
	nop			;2801
	nop			;2802
	nop			;2803
	nop			;2804
	nop			;2805
	nop			;2806
	nop			;2807
	nop			;2808
	nop			;2809
	nop			;280a
	nop			;280b
	nop			;280c
	nop			;280d
	nop			;280e
	nop			;280f
	nop			;2810
	nop			;2811
	nop			;2812
	nop			;2813
	nop			;2814
	nop			;2815
	nop			;2816
	nop			;2817
	nop			;2818
	nop			;2819
	nop			;281a
	nop			;281b
	nop			;281c
	nop			;281d
	nop			;281e
	nop			;281f
	nop			;2820
	nop			;2821
	nop			;2822
	nop			;2823
	nop			;2824
	nop			;2825
	nop			;2826
	nop			;2827
	nop			;2828
	nop			;2829
	nop			;282a
	nop			;282b
	nop			;282c
	nop			;282d
	nop			;282e
	nop			;282f
	nop			;2830
	nop			;2831
	nop			;2832
	nop			;2833
	nop			;2834
	nop			;2835
	nop			;2836
	nop			;2837
	nop			;2838
	nop			;2839
	nop			;283a
	nop			;283b
	nop			;283c
	nop			;283d
	nop			;283e
	nop			;283f
	nop			;2840
	nop			;2841
	nop			;2842
	nop			;2843
	nop			;2844
	nop			;2845
	nop			;2846
	nop			;2847
	nop			;2848
	nop			;2849
	nop			;284a
	nop			;284b
	nop			;284c
	nop			;284d
	nop			;284e
	nop			;284f
	nop			;2850
	nop			;2851
	nop			;2852
	nop			;2853
	nop			;2854
	nop			;2855
	nop			;2856
	nop			;2857
	nop			;2858
	nop			;2859
	nop			;285a
	nop			;285b
	nop			;285c
	nop			;285d
	nop			;285e
	nop			;285f
	nop			;2860
	nop			;2861
	nop			;2862
	nop			;2863
	nop			;2864
	nop			;2865
	nop			;2866
	nop			;2867
	nop			;2868
	nop			;2869
	nop			;286a
	nop			;286b
	nop			;286c
	nop			;286d
	nop			;286e
	nop			;286f
	nop			;2870
	nop			;2871
	nop			;2872
	nop			;2873
	nop			;2874
	nop			;2875
	nop			;2876
	nop			;2877
	nop			;2878
	nop			;2879
	nop			;287a
	nop			;287b
	nop			;287c
	nop			;287d
	nop			;287e
	nop			;287f
	nop			;2880
	nop			;2881
	nop			;2882
	nop			;2883
	nop			;2884
	nop			;2885
	nop			;2886
	nop			;2887
	nop			;2888
	nop			;2889
	nop			;288a
	nop			;288b
	nop			;288c
	nop			;288d
	nop			;288e
	nop			;288f
	nop			;2890
	nop			;2891
	nop			;2892
	nop			;2893
	nop			;2894
	nop			;2895
	nop			;2896
	nop			;2897
	nop			;2898
	nop			;2899
	nop			;289a
	nop			;289b
	nop			;289c
	nop			;289d
	nop			;289e
	nop			;289f
	nop			;28a0
	nop			;28a1
	nop			;28a2
	nop			;28a3
	nop			;28a4
	nop			;28a5
	nop			;28a6
	nop			;28a7
	nop			;28a8
	nop			;28a9
	nop			;28aa
	nop			;28ab
	nop			;28ac
	nop			;28ad
	nop			;28ae
	nop			;28af
	nop			;28b0
	nop			;28b1
	nop			;28b2
	nop			;28b3
	nop			;28b4
	nop			;28b5
	nop			;28b6
	nop			;28b7
	nop			;28b8
	nop			;28b9
	nop			;28ba
	nop			;28bb
	nop			;28bc
	nop			;28bd
	nop			;28be
	nop			;28bf
	nop			;28c0
	nop			;28c1
	nop			;28c2
	nop			;28c3
	nop			;28c4
	nop			;28c5
	nop			;28c6
	nop			;28c7
	nop			;28c8
	nop			;28c9
	nop			;28ca
	nop			;28cb
	nop			;28cc
	nop			;28cd
	nop			;28ce
	nop			;28cf
	nop			;28d0
	nop			;28d1
	nop			;28d2
	nop			;28d3
	nop			;28d4
	nop			;28d5
	nop			;28d6
	nop			;28d7
	nop			;28d8
	nop			;28d9
	nop			;28da
	nop			;28db
	nop			;28dc
	nop			;28dd
	nop			;28de
	nop			;28df
	nop			;28e0
	nop			;28e1
	nop			;28e2
	nop			;28e3
	nop			;28e4
	nop			;28e5
	nop			;28e6
	nop			;28e7
	nop			;28e8
	nop			;28e9
	nop			;28ea
	nop			;28eb
	nop			;28ec
	nop			;28ed
	nop			;28ee
	nop			;28ef
	nop			;28f0
	nop			;28f1
	nop			;28f2
	nop			;28f3
	nop			;28f4
	nop			;28f5
	nop			;28f6
	nop			;28f7
	nop			;28f8
	nop			;28f9
	nop			;28fa
	nop			;28fb
	nop			;28fc
	nop			;28fd
	nop			;28fe
	nop			;28ff
	nop			;2900
	nop			;2901
	nop			;2902
	nop			;2903
	nop			;2904
	nop			;2905
	nop			;2906
	nop			;2907
	nop			;2908
	nop			;2909
	nop			;290a
	nop			;290b
	nop			;290c
	nop			;290d
	nop			;290e
	nop			;290f
	nop			;2910
	nop			;2911
	nop			;2912
	nop			;2913
	nop			;2914
	nop			;2915
	nop			;2916
	nop			;2917
	nop			;2918
	nop			;2919
	nop			;291a
	nop			;291b
	nop			;291c
	nop			;291d
	nop			;291e
	nop			;291f
	nop			;2920
	nop			;2921
	nop			;2922
	nop			;2923
	nop			;2924
	nop			;2925
	nop			;2926
	nop			;2927
	nop			;2928
	nop			;2929
	nop			;292a
	nop			;292b
	nop			;292c
	nop			;292d
	nop			;292e
	nop			;292f
	nop			;2930
	nop			;2931
	nop			;2932
	nop			;2933
	nop			;2934
	nop			;2935
	nop			;2936
	nop			;2937
	nop			;2938
	nop			;2939
	nop			;293a
	nop			;293b
	nop			;293c
	nop			;293d
	nop			;293e
	nop			;293f
	nop			;2940
	nop			;2941
	nop			;2942
	nop			;2943
	nop			;2944
	nop			;2945
	nop			;2946
	nop			;2947
	nop			;2948
	nop			;2949
	nop			;294a
	nop			;294b
	nop			;294c
	nop			;294d
	nop			;294e
	nop			;294f
	nop			;2950
	nop			;2951
	nop			;2952
	nop			;2953
	nop			;2954
	nop			;2955
	nop			;2956
	nop			;2957
	nop			;2958
	nop			;2959
	nop			;295a
	nop			;295b
	nop			;295c
	nop			;295d
	nop			;295e
	nop			;295f
	nop			;2960
	nop			;2961
	nop			;2962
	nop			;2963
	nop			;2964
	nop			;2965
	nop			;2966
	nop			;2967
	nop			;2968
	nop			;2969
	nop			;296a
	nop			;296b
	nop			;296c
	nop			;296d
	nop			;296e
	nop			;296f
	nop			;2970
	nop			;2971
	nop			;2972
	nop			;2973
	nop			;2974
	nop			;2975
	nop			;2976
	nop			;2977
	nop			;2978
	nop			;2979
	nop			;297a
	nop			;297b
	nop			;297c
	nop			;297d
	nop			;297e
	nop			;297f
	nop			;2980
	nop			;2981
	nop			;2982
	nop			;2983
	nop			;2984
	nop			;2985
	nop			;2986
	nop			;2987
	nop			;2988
	nop			;2989
	nop			;298a
	nop			;298b
	nop			;298c
	nop			;298d
	nop			;298e
	nop			;298f
	nop			;2990
	nop			;2991
	nop			;2992
	nop			;2993
	nop			;2994
	nop			;2995
	nop			;2996
	nop			;2997
	nop			;2998
	nop			;2999
	nop			;299a
	nop			;299b
	nop			;299c
	nop			;299d
	nop			;299e
	nop			;299f
	nop			;29a0
	nop			;29a1
	nop			;29a2
	nop			;29a3
	nop			;29a4
	nop			;29a5
	nop			;29a6
	nop			;29a7
	nop			;29a8
	nop			;29a9
	nop			;29aa
	nop			;29ab
	nop			;29ac
	nop			;29ad
	nop			;29ae
	nop			;29af
	nop			;29b0
	nop			;29b1
	nop			;29b2
	nop			;29b3
	nop			;29b4
	nop			;29b5
	nop			;29b6
	nop			;29b7
	nop			;29b8
	nop			;29b9
	nop			;29ba
	nop			;29bb
	nop			;29bc
	nop			;29bd
	nop			;29be
	nop			;29bf
	nop			;29c0
	nop			;29c1
	nop			;29c2
	nop			;29c3
	nop			;29c4
	nop			;29c5
	nop			;29c6
	nop			;29c7
	nop			;29c8
	nop			;29c9
	nop			;29ca
	nop			;29cb
	nop			;29cc
	nop			;29cd
	nop			;29ce
	nop			;29cf
	nop			;29d0
	nop			;29d1
	nop			;29d2
	nop			;29d3
	nop			;29d4
	nop			;29d5
	nop			;29d6
	nop			;29d7
	nop			;29d8
	nop			;29d9
	nop			;29da
	nop			;29db
	nop			;29dc
	nop			;29dd
	nop			;29de
	nop			;29df
	nop			;29e0
	nop			;29e1
	nop			;29e2
	nop			;29e3
	nop			;29e4
	nop			;29e5
	nop			;29e6
	nop			;29e7
	nop			;29e8
	nop			;29e9
	nop			;29ea
	nop			;29eb
	nop			;29ec
	nop			;29ed
	nop			;29ee
	nop			;29ef
	nop			;29f0
	nop			;29f1
	nop			;29f2
	nop			;29f3
	nop			;29f4
	nop			;29f5
	nop			;29f6
	nop			;29f7
	nop			;29f8
	nop			;29f9
	nop			;29fa
	nop			;29fb
	nop			;29fc
	nop			;29fd
	nop			;29fe
	nop			;29ff
	nop			;2a00
	nop			;2a01
	nop			;2a02
	nop			;2a03
	nop			;2a04
	nop			;2a05
	nop			;2a06
	nop			;2a07
	nop			;2a08
	nop			;2a09
	nop			;2a0a
	nop			;2a0b
	nop			;2a0c
	nop			;2a0d
	nop			;2a0e
	nop			;2a0f
	nop			;2a10
	nop			;2a11
	nop			;2a12
	nop			;2a13
	nop			;2a14
	nop			;2a15
	nop			;2a16
	nop			;2a17
	nop			;2a18
	nop			;2a19
	nop			;2a1a
	nop			;2a1b
	nop			;2a1c
	nop			;2a1d
	nop			;2a1e
	nop			;2a1f
	nop			;2a20
	nop			;2a21
	nop			;2a22
	nop			;2a23
	nop			;2a24
	nop			;2a25
	nop			;2a26
	nop			;2a27
	nop			;2a28
	nop			;2a29
	nop			;2a2a
	nop			;2a2b
	nop			;2a2c
	nop			;2a2d
	nop			;2a2e
	nop			;2a2f
	nop			;2a30
	nop			;2a31
	nop			;2a32
	nop			;2a33
	nop			;2a34
	nop			;2a35
	nop			;2a36
	nop			;2a37
	nop			;2a38
	nop			;2a39
	nop			;2a3a
	nop			;2a3b
	nop			;2a3c
	nop			;2a3d
	nop			;2a3e
	nop			;2a3f
	nop			;2a40
	nop			;2a41
	nop			;2a42
	nop			;2a43
	nop			;2a44
	nop			;2a45
	nop			;2a46
	nop			;2a47
	nop			;2a48
	nop			;2a49
	nop			;2a4a
	nop			;2a4b
	nop			;2a4c
	nop			;2a4d
	nop			;2a4e
	nop			;2a4f
	nop			;2a50
	nop			;2a51
	nop			;2a52
	nop			;2a53
	nop			;2a54
	nop			;2a55
	nop			;2a56
	nop			;2a57
	nop			;2a58
	nop			;2a59
	nop			;2a5a
	nop			;2a5b
	nop			;2a5c
	nop			;2a5d
	nop			;2a5e
	nop			;2a5f
	nop			;2a60
	nop			;2a61
	nop			;2a62
	nop			;2a63
	nop			;2a64
	nop			;2a65
	nop			;2a66
	nop			;2a67
	nop			;2a68
	nop			;2a69
	nop			;2a6a
	nop			;2a6b
	nop			;2a6c
	nop			;2a6d
	nop			;2a6e
	nop			;2a6f
	nop			;2a70
	nop			;2a71
	nop			;2a72
	nop			;2a73
	nop			;2a74
	nop			;2a75
	nop			;2a76
	nop			;2a77
	nop			;2a78
	nop			;2a79
	nop			;2a7a
	nop			;2a7b
	nop			;2a7c
	nop			;2a7d
	nop			;2a7e
	nop			;2a7f
	nop			;2a80
	nop			;2a81
	nop			;2a82
	nop			;2a83
	nop			;2a84
	nop			;2a85
	nop			;2a86
	nop			;2a87
	nop			;2a88
	nop			;2a89
	nop			;2a8a
	nop			;2a8b
	nop			;2a8c
	nop			;2a8d
	nop			;2a8e
	nop			;2a8f
	nop			;2a90
	nop			;2a91
	nop			;2a92
	nop			;2a93
	nop			;2a94
	nop			;2a95
	nop			;2a96
	nop			;2a97
	nop			;2a98
	nop			;2a99
	nop			;2a9a
	nop			;2a9b
	nop			;2a9c
	nop			;2a9d
	nop			;2a9e
	nop			;2a9f
	nop			;2aa0
	nop			;2aa1
	nop			;2aa2
	nop			;2aa3
	nop			;2aa4
	nop			;2aa5
	nop			;2aa6
	nop			;2aa7
	nop			;2aa8
	nop			;2aa9
	nop			;2aaa
	nop			;2aab
	nop			;2aac
	nop			;2aad
	nop			;2aae
	nop			;2aaf
	nop			;2ab0
	nop			;2ab1
	nop			;2ab2
	nop			;2ab3
	nop			;2ab4
	nop			;2ab5
	nop			;2ab6
	nop			;2ab7
	nop			;2ab8
	nop			;2ab9
	nop			;2aba
	nop			;2abb
	nop			;2abc
	nop			;2abd
	nop			;2abe
	nop			;2abf
	nop			;2ac0
	nop			;2ac1
	nop			;2ac2
	nop			;2ac3
	nop			;2ac4
	nop			;2ac5
	nop			;2ac6
	nop			;2ac7
	nop			;2ac8
	nop			;2ac9
	nop			;2aca
	nop			;2acb
	nop			;2acc
	nop			;2acd
	nop			;2ace
	nop			;2acf
	nop			;2ad0
	nop			;2ad1
	nop			;2ad2
	nop			;2ad3
	nop			;2ad4
	nop			;2ad5
	nop			;2ad6
	nop			;2ad7
	nop			;2ad8
	nop			;2ad9
	nop			;2ada
	nop			;2adb
	nop			;2adc
	nop			;2add
	nop			;2ade
	nop			;2adf
	nop			;2ae0
	nop			;2ae1
	nop			;2ae2
	nop			;2ae3
	nop			;2ae4
	nop			;2ae5
	nop			;2ae6
	nop			;2ae7
	nop			;2ae8
	nop			;2ae9
	nop			;2aea
	nop			;2aeb
	nop			;2aec
	nop			;2aed
	nop			;2aee
	nop			;2aef
	nop			;2af0
	nop			;2af1
	nop			;2af2
	nop			;2af3
	nop			;2af4
	nop			;2af5
	nop			;2af6
	nop			;2af7
	nop			;2af8
	nop			;2af9
	nop			;2afa
	nop			;2afb
	nop			;2afc
	nop			;2afd
	nop			;2afe
	nop			;2aff
	nop			;2b00
	nop			;2b01
	nop			;2b02
	nop			;2b03
	nop			;2b04
	nop			;2b05
	nop			;2b06
	nop			;2b07
	nop			;2b08
	nop			;2b09
	nop			;2b0a
	nop			;2b0b
	nop			;2b0c
	nop			;2b0d
	nop			;2b0e
	nop			;2b0f
	nop			;2b10
	nop			;2b11
	nop			;2b12
	nop			;2b13
	nop			;2b14
	nop			;2b15
	nop			;2b16
	nop			;2b17
	nop			;2b18
	nop			;2b19
	nop			;2b1a
	nop			;2b1b
	nop			;2b1c
	nop			;2b1d
	nop			;2b1e
	nop			;2b1f
	nop			;2b20
	nop			;2b21
	nop			;2b22
	nop			;2b23
	nop			;2b24
	nop			;2b25
	nop			;2b26
	nop			;2b27
	nop			;2b28
	nop			;2b29
	nop			;2b2a
	nop			;2b2b
	nop			;2b2c
	nop			;2b2d
	nop			;2b2e
	nop			;2b2f
	nop			;2b30
	nop			;2b31
	nop			;2b32
	nop			;2b33
	nop			;2b34
	nop			;2b35
	nop			;2b36
	nop			;2b37
	nop			;2b38
	nop			;2b39
	nop			;2b3a
	nop			;2b3b
	nop			;2b3c
	nop			;2b3d
	nop			;2b3e
	nop			;2b3f
	nop			;2b40
	nop			;2b41
	nop			;2b42
	nop			;2b43
	nop			;2b44
	nop			;2b45
	nop			;2b46
	nop			;2b47
	nop			;2b48
	nop			;2b49
	nop			;2b4a
	nop			;2b4b
	nop			;2b4c
	nop			;2b4d
	nop			;2b4e
	nop			;2b4f
	nop			;2b50
	nop			;2b51
	nop			;2b52
	nop			;2b53
	nop			;2b54
	nop			;2b55
	nop			;2b56
	nop			;2b57
	nop			;2b58
	nop			;2b59
	nop			;2b5a
	nop			;2b5b
	nop			;2b5c
	nop			;2b5d
	nop			;2b5e
	nop			;2b5f
	nop			;2b60
	nop			;2b61
	nop			;2b62
	nop			;2b63
	nop			;2b64
	nop			;2b65
	nop			;2b66
	nop			;2b67
	nop			;2b68
	nop			;2b69
	nop			;2b6a
	nop			;2b6b
	nop			;2b6c
	nop			;2b6d
	nop			;2b6e
	nop			;2b6f
	nop			;2b70
	nop			;2b71
	nop			;2b72
	nop			;2b73
	nop			;2b74
	nop			;2b75
	nop			;2b76
	nop			;2b77
	nop			;2b78
	nop			;2b79
	nop			;2b7a
	nop			;2b7b
	nop			;2b7c
	nop			;2b7d
	nop			;2b7e
	nop			;2b7f
	nop			;2b80
	nop			;2b81
	nop			;2b82
	nop			;2b83
	nop			;2b84
	nop			;2b85
	nop			;2b86
	nop			;2b87
	nop			;2b88
	nop			;2b89
	nop			;2b8a
	nop			;2b8b
	nop			;2b8c
	nop			;2b8d
	nop			;2b8e
	nop			;2b8f
	nop			;2b90
	nop			;2b91
	nop			;2b92
	nop			;2b93
	nop			;2b94
	nop			;2b95
	nop			;2b96
	nop			;2b97
	nop			;2b98
	nop			;2b99
	nop			;2b9a
	nop			;2b9b
	nop			;2b9c
	nop			;2b9d
	nop			;2b9e
	nop			;2b9f
	nop			;2ba0
	nop			;2ba1
	nop			;2ba2
	nop			;2ba3
	nop			;2ba4
	nop			;2ba5
	nop			;2ba6
	nop			;2ba7
	nop			;2ba8
	nop			;2ba9
	nop			;2baa
	nop			;2bab
	nop			;2bac
	nop			;2bad
	nop			;2bae
	nop			;2baf
	nop			;2bb0
	nop			;2bb1
	nop			;2bb2
	nop			;2bb3
	nop			;2bb4
	nop			;2bb5
	nop			;2bb6
	nop			;2bb7
	nop			;2bb8
	nop			;2bb9
	nop			;2bba
	nop			;2bbb
	nop			;2bbc
	nop			;2bbd
	nop			;2bbe
	nop			;2bbf
	nop			;2bc0
	nop			;2bc1
	nop			;2bc2
	nop			;2bc3
	nop			;2bc4
	nop			;2bc5
	nop			;2bc6
	nop			;2bc7
	nop			;2bc8
	nop			;2bc9
	nop			;2bca
	nop			;2bcb
	nop			;2bcc
	nop			;2bcd
	nop			;2bce
	nop			;2bcf
	nop			;2bd0
	nop			;2bd1
	nop			;2bd2
	nop			;2bd3
	nop			;2bd4
	nop			;2bd5
	nop			;2bd6
	nop			;2bd7
	nop			;2bd8
	nop			;2bd9
	nop			;2bda
	nop			;2bdb
	nop			;2bdc
	nop			;2bdd
	nop			;2bde
	nop			;2bdf
	nop			;2be0
	nop			;2be1
	nop			;2be2
	nop			;2be3
	nop			;2be4
	nop			;2be5
	nop			;2be6
	nop			;2be7
	nop			;2be8
	nop			;2be9
	nop			;2bea
	nop			;2beb
	nop			;2bec
	nop			;2bed
	nop			;2bee
	nop			;2bef
	nop			;2bf0
	nop			;2bf1
	nop			;2bf2
	nop			;2bf3
	nop			;2bf4
	nop			;2bf5
	nop			;2bf6
	nop			;2bf7
	nop			;2bf8
	nop			;2bf9
	nop			;2bfa
	nop			;2bfb
	nop			;2bfc
	nop			;2bfd
	nop			;2bfe
	nop			;2bff
	nop			;2c00
	nop			;2c01
	nop			;2c02
	nop			;2c03
	nop			;2c04
	nop			;2c05
	nop			;2c06
	nop			;2c07
	nop			;2c08
	nop			;2c09
	nop			;2c0a
	nop			;2c0b
	nop			;2c0c
	nop			;2c0d
	nop			;2c0e
	nop			;2c0f
	nop			;2c10
	nop			;2c11
	nop			;2c12
	nop			;2c13
	nop			;2c14
	nop			;2c15
	nop			;2c16
	nop			;2c17
	nop			;2c18
	nop			;2c19
	nop			;2c1a
	nop			;2c1b
	nop			;2c1c
	nop			;2c1d
	nop			;2c1e
	nop			;2c1f
	nop			;2c20
	nop			;2c21
	nop			;2c22
	nop			;2c23
	nop			;2c24
	nop			;2c25
	nop			;2c26
	nop			;2c27
	nop			;2c28
	nop			;2c29
	nop			;2c2a
	nop			;2c2b
	nop			;2c2c
	nop			;2c2d
	nop			;2c2e
	nop			;2c2f
	nop			;2c30
	nop			;2c31
	nop			;2c32
	nop			;2c33
	nop			;2c34
	nop			;2c35
	nop			;2c36
	nop			;2c37
	nop			;2c38
	nop			;2c39
	nop			;2c3a
	nop			;2c3b
	nop			;2c3c
	nop			;2c3d
	nop			;2c3e
	nop			;2c3f
	nop			;2c40
	nop			;2c41
	nop			;2c42
	nop			;2c43
	nop			;2c44
	nop			;2c45
	nop			;2c46
	nop			;2c47
	nop			;2c48
	nop			;2c49
	nop			;2c4a
	nop			;2c4b
	nop			;2c4c
	nop			;2c4d
	nop			;2c4e
	nop			;2c4f
	nop			;2c50
	nop			;2c51
	nop			;2c52
	nop			;2c53
	nop			;2c54
	nop			;2c55
	nop			;2c56
	nop			;2c57
	nop			;2c58
	nop			;2c59
	nop			;2c5a
	nop			;2c5b
	nop			;2c5c
	nop			;2c5d
	nop			;2c5e
	nop			;2c5f
	nop			;2c60
	nop			;2c61
	nop			;2c62
	nop			;2c63
	nop			;2c64
	nop			;2c65
	nop			;2c66
	nop			;2c67
	nop			;2c68
	nop			;2c69
	nop			;2c6a
	nop			;2c6b
	nop			;2c6c
	nop			;2c6d
	nop			;2c6e
	nop			;2c6f
	nop			;2c70
	nop			;2c71
	nop			;2c72
	nop			;2c73
	nop			;2c74
	nop			;2c75
	nop			;2c76
	nop			;2c77
	nop			;2c78
	nop			;2c79
	nop			;2c7a
	nop			;2c7b
	nop			;2c7c
	nop			;2c7d
	nop			;2c7e
	nop			;2c7f
	nop			;2c80
	nop			;2c81
	nop			;2c82
	nop			;2c83
	nop			;2c84
	nop			;2c85
	nop			;2c86
	nop			;2c87
	nop			;2c88
	nop			;2c89
	nop			;2c8a
	nop			;2c8b
	nop			;2c8c
	nop			;2c8d
	nop			;2c8e
	nop			;2c8f
	nop			;2c90
	nop			;2c91
	nop			;2c92
	nop			;2c93
	nop			;2c94
	nop			;2c95
	nop			;2c96
	nop			;2c97
	nop			;2c98
	nop			;2c99
	nop			;2c9a
	nop			;2c9b
	nop			;2c9c
	nop			;2c9d
	nop			;2c9e
	nop			;2c9f
	nop			;2ca0
	nop			;2ca1
	nop			;2ca2
	nop			;2ca3
	nop			;2ca4
	nop			;2ca5
	nop			;2ca6
	nop			;2ca7
	nop			;2ca8
	nop			;2ca9
	nop			;2caa
	nop			;2cab
	nop			;2cac
	nop			;2cad
	nop			;2cae
	nop			;2caf
	nop			;2cb0
	nop			;2cb1
	nop			;2cb2
	nop			;2cb3
	nop			;2cb4
	nop			;2cb5
	nop			;2cb6
	nop			;2cb7
	nop			;2cb8
	nop			;2cb9
	nop			;2cba
	nop			;2cbb
	nop			;2cbc
	nop			;2cbd
	nop			;2cbe
	nop			;2cbf
	nop			;2cc0
	nop			;2cc1
	nop			;2cc2
	nop			;2cc3
	nop			;2cc4
	nop			;2cc5
	nop			;2cc6
	nop			;2cc7
	nop			;2cc8
	nop			;2cc9
	nop			;2cca
	nop			;2ccb
	nop			;2ccc
	nop			;2ccd
	nop			;2cce
	nop			;2ccf
	nop			;2cd0
	nop			;2cd1
	nop			;2cd2
	nop			;2cd3
	nop			;2cd4
	nop			;2cd5
	nop			;2cd6
	nop			;2cd7
	nop			;2cd8
	nop			;2cd9
	nop			;2cda
	nop			;2cdb
	nop			;2cdc
	nop			;2cdd
	nop			;2cde
	nop			;2cdf
	nop			;2ce0
	nop			;2ce1
	nop			;2ce2
	nop			;2ce3
	nop			;2ce4
	nop			;2ce5
	nop			;2ce6
	nop			;2ce7
	nop			;2ce8
	nop			;2ce9
	nop			;2cea
	nop			;2ceb
	nop			;2cec
	nop			;2ced
	nop			;2cee
	nop			;2cef
	nop			;2cf0
	nop			;2cf1
	nop			;2cf2
	nop			;2cf3
	nop			;2cf4
	nop			;2cf5
	nop			;2cf6
	nop			;2cf7
	nop			;2cf8
	nop			;2cf9
	nop			;2cfa
	nop			;2cfb
	nop			;2cfc
	nop			;2cfd
	nop			;2cfe
	nop			;2cff
	nop			;2d00
	nop			;2d01
	nop			;2d02
	nop			;2d03
	nop			;2d04
	nop			;2d05
	nop			;2d06
	nop			;2d07
	nop			;2d08
	nop			;2d09
	nop			;2d0a
	nop			;2d0b
	nop			;2d0c
	nop			;2d0d
	nop			;2d0e
	nop			;2d0f
	nop			;2d10
	nop			;2d11
	nop			;2d12
	nop			;2d13
	nop			;2d14
	nop			;2d15
	nop			;2d16
	nop			;2d17
	nop			;2d18
	nop			;2d19
	nop			;2d1a
	nop			;2d1b
	nop			;2d1c
	nop			;2d1d
	nop			;2d1e
	nop			;2d1f
	nop			;2d20
	nop			;2d21
	nop			;2d22
	nop			;2d23
	nop			;2d24
	nop			;2d25
	nop			;2d26
	nop			;2d27
	nop			;2d28
	nop			;2d29
	nop			;2d2a
	nop			;2d2b
	nop			;2d2c
	nop			;2d2d
	nop			;2d2e
	nop			;2d2f
	nop			;2d30
	nop			;2d31
	nop			;2d32
	nop			;2d33
	nop			;2d34
	nop			;2d35
	nop			;2d36
	nop			;2d37
	nop			;2d38
	nop			;2d39
	nop			;2d3a
	nop			;2d3b
	nop			;2d3c
	nop			;2d3d
	nop			;2d3e
	nop			;2d3f
	nop			;2d40
	nop			;2d41
	nop			;2d42
	nop			;2d43
	nop			;2d44
	nop			;2d45
	nop			;2d46
	nop			;2d47
	nop			;2d48
	nop			;2d49
	nop			;2d4a
	nop			;2d4b
	nop			;2d4c
	nop			;2d4d
	nop			;2d4e
	nop			;2d4f
	nop			;2d50
	nop			;2d51
	nop			;2d52
	nop			;2d53
	nop			;2d54
	nop			;2d55
	nop			;2d56
	nop			;2d57
	nop			;2d58
	nop			;2d59
	nop			;2d5a
	nop			;2d5b
	nop			;2d5c
	nop			;2d5d
	nop			;2d5e
	nop			;2d5f
	nop			;2d60
	nop			;2d61
	nop			;2d62
	nop			;2d63
	nop			;2d64
	nop			;2d65
	nop			;2d66
	nop			;2d67
	nop			;2d68
	nop			;2d69
	nop			;2d6a
	nop			;2d6b
	nop			;2d6c
	nop			;2d6d
	nop			;2d6e
	nop			;2d6f
	nop			;2d70
	nop			;2d71
	nop			;2d72
	nop			;2d73
	nop			;2d74
	nop			;2d75
	nop			;2d76
	nop			;2d77
	nop			;2d78
	nop			;2d79
	nop			;2d7a
	nop			;2d7b
	nop			;2d7c
	nop			;2d7d
	nop			;2d7e
	nop			;2d7f
	nop			;2d80
	nop			;2d81
	nop			;2d82
	nop			;2d83
	nop			;2d84
	nop			;2d85
	nop			;2d86
	nop			;2d87
	nop			;2d88
	nop			;2d89
	nop			;2d8a
	nop			;2d8b
	nop			;2d8c
	nop			;2d8d
	nop			;2d8e
	nop			;2d8f
	nop			;2d90
	nop			;2d91
	nop			;2d92
	nop			;2d93
	nop			;2d94
	nop			;2d95
	nop			;2d96
	nop			;2d97
	nop			;2d98
	nop			;2d99
	nop			;2d9a
	nop			;2d9b
	nop			;2d9c
	nop			;2d9d
	nop			;2d9e
	nop			;2d9f
	nop			;2da0
	nop			;2da1
	nop			;2da2
	nop			;2da3
	nop			;2da4
	nop			;2da5
	nop			;2da6
	nop			;2da7
	nop			;2da8
	nop			;2da9
	nop			;2daa
	nop			;2dab
	nop			;2dac
	nop			;2dad
	nop			;2dae
	nop			;2daf
	nop			;2db0
	nop			;2db1
	nop			;2db2
	nop			;2db3
	nop			;2db4
	nop			;2db5
	nop			;2db6
	nop			;2db7
	nop			;2db8
	nop			;2db9
	nop			;2dba
	nop			;2dbb
	nop			;2dbc
	nop			;2dbd
	nop			;2dbe
	nop			;2dbf
	nop			;2dc0
	nop			;2dc1
	nop			;2dc2
	nop			;2dc3
	nop			;2dc4
	nop			;2dc5
	nop			;2dc6
	nop			;2dc7
	nop			;2dc8
	nop			;2dc9
	nop			;2dca
	nop			;2dcb
	nop			;2dcc
	nop			;2dcd
	nop			;2dce
	nop			;2dcf
	nop			;2dd0
	nop			;2dd1
	nop			;2dd2
	nop			;2dd3
	nop			;2dd4
	nop			;2dd5
	nop			;2dd6
	nop			;2dd7
	nop			;2dd8
	nop			;2dd9
	nop			;2dda
	nop			;2ddb
	nop			;2ddc
	nop			;2ddd
	nop			;2dde
	nop			;2ddf
	nop			;2de0
	nop			;2de1
	nop			;2de2
	nop			;2de3
	nop			;2de4
	nop			;2de5
	nop			;2de6
	nop			;2de7
	nop			;2de8
	nop			;2de9
	nop			;2dea
	nop			;2deb
	nop			;2dec
	nop			;2ded
	nop			;2dee
	nop			;2def
	nop			;2df0
	nop			;2df1
	nop			;2df2
	nop			;2df3
	nop			;2df4
	nop			;2df5
	nop			;2df6
	nop			;2df7
	nop			;2df8
	nop			;2df9
	nop			;2dfa
	nop			;2dfb
	nop			;2dfc
	nop			;2dfd
	nop			;2dfe
	nop			;2dff
	nop			;2e00
	nop			;2e01
	nop			;2e02
	nop			;2e03
	nop			;2e04
	nop			;2e05
	nop			;2e06
	nop			;2e07
	nop			;2e08
	nop			;2e09
	nop			;2e0a
	nop			;2e0b
	nop			;2e0c
	nop			;2e0d
	nop			;2e0e
	nop			;2e0f
	nop			;2e10
	nop			;2e11
	nop			;2e12
	nop			;2e13
	nop			;2e14
	nop			;2e15
	nop			;2e16
	nop			;2e17
	nop			;2e18
	nop			;2e19
	nop			;2e1a
	nop			;2e1b
	nop			;2e1c
	nop			;2e1d
	nop			;2e1e
	nop			;2e1f
	nop			;2e20
	nop			;2e21
	nop			;2e22
	nop			;2e23
	nop			;2e24
	nop			;2e25
	nop			;2e26
	nop			;2e27
	nop			;2e28
	nop			;2e29
	nop			;2e2a
	nop			;2e2b
	nop			;2e2c
	nop			;2e2d
	nop			;2e2e
	nop			;2e2f
	nop			;2e30
	nop			;2e31
	nop			;2e32
	nop			;2e33
	nop			;2e34
	nop			;2e35
	nop			;2e36
	nop			;2e37
	nop			;2e38
	nop			;2e39
	nop			;2e3a
	nop			;2e3b
	nop			;2e3c
	nop			;2e3d
	nop			;2e3e
	nop			;2e3f
	nop			;2e40
	nop			;2e41
	nop			;2e42
	nop			;2e43
	nop			;2e44
	nop			;2e45
	nop			;2e46
	nop			;2e47
	nop			;2e48
	nop			;2e49
	nop			;2e4a
	nop			;2e4b
	nop			;2e4c
	nop			;2e4d
	nop			;2e4e
	nop			;2e4f
	nop			;2e50
	nop			;2e51
	nop			;2e52
	nop			;2e53
	nop			;2e54
	nop			;2e55
	nop			;2e56
	nop			;2e57
	nop			;2e58
	nop			;2e59
	nop			;2e5a
	nop			;2e5b
	nop			;2e5c
	nop			;2e5d
	nop			;2e5e
	nop			;2e5f
	nop			;2e60
	nop			;2e61
	nop			;2e62
	nop			;2e63
	nop			;2e64
	nop			;2e65
	nop			;2e66
	nop			;2e67
	nop			;2e68
	nop			;2e69
	nop			;2e6a
	nop			;2e6b
	nop			;2e6c
	nop			;2e6d
	nop			;2e6e
	nop			;2e6f
	nop			;2e70
	nop			;2e71
	nop			;2e72
	nop			;2e73
	nop			;2e74
	nop			;2e75
	nop			;2e76
	nop			;2e77
	nop			;2e78
	nop			;2e79
	nop			;2e7a
	nop			;2e7b
	nop			;2e7c
	nop			;2e7d
	nop			;2e7e
	nop			;2e7f
	nop			;2e80
	nop			;2e81
	nop			;2e82
	nop			;2e83
	nop			;2e84
	nop			;2e85
	nop			;2e86
	nop			;2e87
	nop			;2e88
	nop			;2e89
	nop			;2e8a
	nop			;2e8b
	nop			;2e8c
	nop			;2e8d
	nop			;2e8e
	nop			;2e8f
	nop			;2e90
	nop			;2e91
	nop			;2e92
	nop			;2e93
	nop			;2e94
	nop			;2e95
	nop			;2e96
	nop			;2e97
	nop			;2e98
	nop			;2e99
	nop			;2e9a
	nop			;2e9b
	nop			;2e9c
	nop			;2e9d
	nop			;2e9e
	nop			;2e9f
	nop			;2ea0
	nop			;2ea1
	nop			;2ea2
	nop			;2ea3
	nop			;2ea4
	nop			;2ea5
	nop			;2ea6
	nop			;2ea7
	nop			;2ea8
	nop			;2ea9
	nop			;2eaa
	nop			;2eab
	nop			;2eac
	nop			;2ead
	nop			;2eae
	nop			;2eaf
	nop			;2eb0
	nop			;2eb1
	nop			;2eb2
	nop			;2eb3
	nop			;2eb4
	nop			;2eb5
	nop			;2eb6
	nop			;2eb7
	nop			;2eb8
	nop			;2eb9
	nop			;2eba
	nop			;2ebb
	nop			;2ebc
	nop			;2ebd
	nop			;2ebe
	nop			;2ebf
	nop			;2ec0
	nop			;2ec1
	nop			;2ec2
	nop			;2ec3
	nop			;2ec4
	nop			;2ec5
	nop			;2ec6
	nop			;2ec7
	nop			;2ec8
	nop			;2ec9
	nop			;2eca
	nop			;2ecb
	nop			;2ecc
	nop			;2ecd
	nop			;2ece
	nop			;2ecf
	nop			;2ed0
	nop			;2ed1
	nop			;2ed2
	nop			;2ed3
	nop			;2ed4
	nop			;2ed5
	nop			;2ed6
	nop			;2ed7
	nop			;2ed8
	nop			;2ed9
	nop			;2eda
	nop			;2edb
	nop			;2edc
	nop			;2edd
	nop			;2ede
	nop			;2edf
	nop			;2ee0
	nop			;2ee1
	nop			;2ee2
	nop			;2ee3
	nop			;2ee4
	nop			;2ee5
	nop			;2ee6
	nop			;2ee7
	nop			;2ee8
	nop			;2ee9
	nop			;2eea
	nop			;2eeb
	nop			;2eec
	nop			;2eed
	nop			;2eee
	nop			;2eef
	nop			;2ef0
	nop			;2ef1
	nop			;2ef2
	nop			;2ef3
	nop			;2ef4
	nop			;2ef5
	nop			;2ef6
	nop			;2ef7
	nop			;2ef8
	nop			;2ef9
	nop			;2efa
	nop			;2efb
	nop			;2efc
	nop			;2efd
	nop			;2efe
	nop			;2eff
	nop			;2f00
	nop			;2f01
	nop			;2f02
	nop			;2f03
	nop			;2f04
	nop			;2f05
	nop			;2f06
	nop			;2f07
	nop			;2f08
	nop			;2f09
	nop			;2f0a
	nop			;2f0b
	nop			;2f0c
	nop			;2f0d
	nop			;2f0e
	nop			;2f0f
	nop			;2f10
	nop			;2f11
	nop			;2f12
	nop			;2f13
	nop			;2f14
	nop			;2f15
	nop			;2f16
	nop			;2f17
	nop			;2f18
	nop			;2f19
	nop			;2f1a
	nop			;2f1b
	nop			;2f1c
	nop			;2f1d
	nop			;2f1e
	nop			;2f1f
	nop			;2f20
	nop			;2f21
	nop			;2f22
	nop			;2f23
	nop			;2f24
	nop			;2f25
	nop			;2f26
	nop			;2f27
	nop			;2f28
	nop			;2f29
	nop			;2f2a
	nop			;2f2b
	nop			;2f2c
	nop			;2f2d
	nop			;2f2e
	nop			;2f2f
	nop			;2f30
	nop			;2f31
	nop			;2f32
	nop			;2f33
	nop			;2f34
	nop			;2f35
	nop			;2f36
	nop			;2f37
	nop			;2f38
	nop			;2f39
	nop			;2f3a
	nop			;2f3b
	nop			;2f3c
	nop			;2f3d
	nop			;2f3e
	nop			;2f3f
	nop			;2f40
	nop			;2f41
	nop			;2f42
	nop			;2f43
	nop			;2f44
	nop			;2f45
	nop			;2f46
	nop			;2f47
	nop			;2f48
	nop			;2f49
	nop			;2f4a
	nop			;2f4b
	nop			;2f4c
	nop			;2f4d
	nop			;2f4e
	nop			;2f4f
	nop			;2f50
	nop			;2f51
	nop			;2f52
	nop			;2f53
	nop			;2f54
	nop			;2f55
	nop			;2f56
	nop			;2f57
	nop			;2f58
	nop			;2f59
	nop			;2f5a
	nop			;2f5b
	nop			;2f5c
	nop			;2f5d
	nop			;2f5e
	nop			;2f5f
	nop			;2f60
	nop			;2f61
	nop			;2f62
	nop			;2f63
	nop			;2f64
	nop			;2f65
	nop			;2f66
	nop			;2f67
	nop			;2f68
	nop			;2f69
	nop			;2f6a
	nop			;2f6b
	nop			;2f6c
	nop			;2f6d
	nop			;2f6e
	nop			;2f6f
	nop			;2f70
	nop			;2f71
	nop			;2f72
	nop			;2f73
	nop			;2f74
	nop			;2f75
	nop			;2f76
	nop			;2f77
	nop			;2f78
	nop			;2f79
	nop			;2f7a
	nop			;2f7b
	nop			;2f7c
	nop			;2f7d
	nop			;2f7e
	nop			;2f7f
	nop			;2f80
	nop			;2f81
	nop			;2f82
	nop			;2f83
	nop			;2f84
	nop			;2f85
	nop			;2f86
	nop			;2f87
	nop			;2f88
	nop			;2f89
	nop			;2f8a
	nop			;2f8b
	nop			;2f8c
	nop			;2f8d
	nop			;2f8e
	nop			;2f8f
	nop			;2f90
	nop			;2f91
	nop			;2f92
	nop			;2f93
	nop			;2f94
	nop			;2f95
	nop			;2f96
	nop			;2f97
	nop			;2f98
	nop			;2f99
	nop			;2f9a
	nop			;2f9b
	nop			;2f9c
	nop			;2f9d
	nop			;2f9e
	nop			;2f9f
	nop			;2fa0
	nop			;2fa1
	nop			;2fa2
	nop			;2fa3
	nop			;2fa4
	nop			;2fa5
	nop			;2fa6
	nop			;2fa7
	nop			;2fa8
	nop			;2fa9
	nop			;2faa
	nop			;2fab
	nop			;2fac
	nop			;2fad
	nop			;2fae
	nop			;2faf
	nop			;2fb0
	nop			;2fb1
	nop			;2fb2
	nop			;2fb3
	nop			;2fb4
	nop			;2fb5
	nop			;2fb6
	nop			;2fb7
	nop			;2fb8
	nop			;2fb9
	nop			;2fba
	nop			;2fbb
	nop			;2fbc
	nop			;2fbd
	nop			;2fbe
	nop			;2fbf
	nop			;2fc0
	nop			;2fc1
	nop			;2fc2
	nop			;2fc3
	nop			;2fc4
	nop			;2fc5
	nop			;2fc6
	nop			;2fc7
	nop			;2fc8
	nop			;2fc9
	nop			;2fca
	nop			;2fcb
	nop			;2fcc
	nop			;2fcd
	nop			;2fce
	nop			;2fcf
	nop			;2fd0
	nop			;2fd1
	nop			;2fd2
	nop			;2fd3
	nop			;2fd4
	nop			;2fd5
	nop			;2fd6
	nop			;2fd7
	nop			;2fd8
	nop			;2fd9
	nop			;2fda
	nop			;2fdb
	nop			;2fdc
	nop			;2fdd
	nop			;2fde
	nop			;2fdf
	nop			;2fe0
	nop			;2fe1
	nop			;2fe2
	nop			;2fe3
	nop			;2fe4
	nop			;2fe5
	nop			;2fe6
	nop			;2fe7
	nop			;2fe8
	nop			;2fe9
	nop			;2fea
	nop			;2feb
	nop			;2fec
	nop			;2fed
	nop			;2fee
	nop			;2fef
	nop			;2ff0
	nop			;2ff1
	nop			;2ff2
	nop			;2ff3
	nop			;2ff4
	nop			;2ff5
	nop			;2ff6
	nop			;2ff7
	nop			;2ff8
	nop			;2ff9
	nop			;2ffa
	nop			;2ffb
	nop			;2ffc
	nop			;2ffd
	nop			;2ffe
	nop			;2fff
	nop			;3000
	nop			;3001
	nop			;3002
	nop			;3003
	nop			;3004
	nop			;3005
	nop			;3006
	nop			;3007
	nop			;3008
	nop			;3009
	nop			;300a
	nop			;300b
	nop			;300c
	nop			;300d
	nop			;300e
	nop			;300f
	nop			;3010
	nop			;3011
	nop			;3012
	nop			;3013
	nop			;3014
	nop			;3015
	nop			;3016
	nop			;3017
	nop			;3018
	nop			;3019
	nop			;301a
	nop			;301b
	nop			;301c
	nop			;301d
	nop			;301e
	nop			;301f
	nop			;3020
	nop			;3021
	nop			;3022
	nop			;3023
	nop			;3024
	nop			;3025
	nop			;3026
	nop			;3027
	nop			;3028
	nop			;3029
	nop			;302a
	nop			;302b
	nop			;302c
	nop			;302d
	nop			;302e
	nop			;302f
	nop			;3030
	nop			;3031
	nop			;3032
	nop			;3033
	nop			;3034
	nop			;3035
	nop			;3036
	nop			;3037
	nop			;3038
	nop			;3039
	nop			;303a
	nop			;303b
	nop			;303c
	nop			;303d
	nop			;303e
	nop			;303f
	nop			;3040
	nop			;3041
	nop			;3042
	nop			;3043
	nop			;3044
	nop			;3045
	nop			;3046
	nop			;3047
	nop			;3048
	nop			;3049
	nop			;304a
	nop			;304b
	nop			;304c
	nop			;304d
	nop			;304e
	nop			;304f
	nop			;3050
	nop			;3051
	nop			;3052
	nop			;3053
	nop			;3054
	nop			;3055
	nop			;3056
	nop			;3057
	nop			;3058
	nop			;3059
	nop			;305a
	nop			;305b
	nop			;305c
	nop			;305d
	nop			;305e
	nop			;305f
	nop			;3060
	nop			;3061
	nop			;3062
	nop			;3063
	nop			;3064
	nop			;3065
	nop			;3066
	nop			;3067
	nop			;3068
	nop			;3069
	nop			;306a
	nop			;306b
	nop			;306c
	nop			;306d
	nop			;306e
	nop			;306f
	nop			;3070
	nop			;3071
	nop			;3072
	nop			;3073
	nop			;3074
	nop			;3075
	nop			;3076
	nop			;3077
	nop			;3078
	nop			;3079
	nop			;307a
	nop			;307b
	nop			;307c
	nop			;307d
	nop			;307e
	nop			;307f
	nop			;3080
	nop			;3081
	nop			;3082
	nop			;3083
	nop			;3084
	nop			;3085
	nop			;3086
	nop			;3087
	nop			;3088
	nop			;3089
	nop			;308a
	nop			;308b
	nop			;308c
	nop			;308d
	nop			;308e
	nop			;308f
	nop			;3090
	nop			;3091
	nop			;3092
	nop			;3093
	nop			;3094
	nop			;3095
	nop			;3096
	nop			;3097
	nop			;3098
	nop			;3099
	nop			;309a
	nop			;309b
	nop			;309c
	nop			;309d
	nop			;309e
	nop			;309f
	nop			;30a0
	nop			;30a1
	nop			;30a2
	nop			;30a3
	nop			;30a4
	nop			;30a5
	nop			;30a6
	nop			;30a7
	nop			;30a8
	nop			;30a9
	nop			;30aa
	nop			;30ab
	nop			;30ac
	nop			;30ad
	nop			;30ae
	nop			;30af
	nop			;30b0
	nop			;30b1
	nop			;30b2
	nop			;30b3
	nop			;30b4
	nop			;30b5
	nop			;30b6
	nop			;30b7
	nop			;30b8
	nop			;30b9
	nop			;30ba
	nop			;30bb
	nop			;30bc
	nop			;30bd
	nop			;30be
	nop			;30bf
	nop			;30c0
	nop			;30c1
	nop			;30c2
	nop			;30c3
	nop			;30c4
	nop			;30c5
	nop			;30c6
	nop			;30c7
	nop			;30c8
	nop			;30c9
	nop			;30ca
	nop			;30cb
	nop			;30cc
	nop			;30cd
	nop			;30ce
	nop			;30cf
	nop			;30d0
	nop			;30d1
	nop			;30d2
	nop			;30d3
	nop			;30d4
	nop			;30d5
	nop			;30d6
	nop			;30d7
	nop			;30d8
	nop			;30d9
	nop			;30da
	nop			;30db
	nop			;30dc
	nop			;30dd
	nop			;30de
	nop			;30df
	nop			;30e0
	nop			;30e1
	nop			;30e2
	nop			;30e3
	nop			;30e4
	nop			;30e5
	nop			;30e6
	nop			;30e7
	nop			;30e8
	nop			;30e9
	nop			;30ea
	nop			;30eb
	nop			;30ec
	nop			;30ed
	nop			;30ee
	nop			;30ef
	nop			;30f0
	nop			;30f1
	nop			;30f2
	nop			;30f3
	nop			;30f4
	nop			;30f5
	nop			;30f6
	nop			;30f7
	nop			;30f8
	nop			;30f9
	nop			;30fa
	nop			;30fb
	nop			;30fc
	nop			;30fd
	nop			;30fe
	nop			;30ff
	nop			;3100
	nop			;3101
	nop			;3102
	nop			;3103
	nop			;3104
	nop			;3105
	nop			;3106
	nop			;3107
	nop			;3108
	nop			;3109
	nop			;310a
	nop			;310b
	nop			;310c
	nop			;310d
	nop			;310e
	nop			;310f
	nop			;3110
	nop			;3111
	nop			;3112
	nop			;3113
	nop			;3114
	nop			;3115
	nop			;3116
	nop			;3117
	nop			;3118
	nop			;3119
	nop			;311a
	nop			;311b
	nop			;311c
	nop			;311d
	nop			;311e
	nop			;311f
	nop			;3120
	nop			;3121
	nop			;3122
	nop			;3123
	nop			;3124
	nop			;3125
	nop			;3126
	nop			;3127
	nop			;3128
	nop			;3129
	nop			;312a
	nop			;312b
	nop			;312c
	nop			;312d
	nop			;312e
	nop			;312f
	nop			;3130
	nop			;3131
	nop			;3132
	nop			;3133
	nop			;3134
	nop			;3135
	nop			;3136
	nop			;3137
	nop			;3138
	nop			;3139
	nop			;313a
	nop			;313b
	nop			;313c
	nop			;313d
	nop			;313e
	nop			;313f
	nop			;3140
	nop			;3141
	nop			;3142
	nop			;3143
	nop			;3144
	nop			;3145
	nop			;3146
	nop			;3147
	nop			;3148
	nop			;3149
	nop			;314a
	nop			;314b
	nop			;314c
	nop			;314d
	nop			;314e
	nop			;314f
	nop			;3150
	nop			;3151
	nop			;3152
	nop			;3153
	nop			;3154
	nop			;3155
	nop			;3156
	nop			;3157
	nop			;3158
	nop			;3159
	nop			;315a
	nop			;315b
	nop			;315c
	nop			;315d
	nop			;315e
	nop			;315f
	nop			;3160
	nop			;3161
	nop			;3162
	nop			;3163
	nop			;3164
	nop			;3165
	nop			;3166
	nop			;3167
	nop			;3168
	nop			;3169
	nop			;316a
	nop			;316b
	nop			;316c
	nop			;316d
	nop			;316e
	nop			;316f
	nop			;3170
	nop			;3171
	nop			;3172
	nop			;3173
	nop			;3174
	nop			;3175
	nop			;3176
	nop			;3177
	nop			;3178
	nop			;3179
	nop			;317a
	nop			;317b
	nop			;317c
	nop			;317d
	nop			;317e
	nop			;317f
	nop			;3180
	nop			;3181
	nop			;3182
	nop			;3183
	nop			;3184
	nop			;3185
	nop			;3186
	nop			;3187
	nop			;3188
	nop			;3189
	nop			;318a
	nop			;318b
	nop			;318c
	nop			;318d
	nop			;318e
	nop			;318f
	nop			;3190
	nop			;3191
	nop			;3192
	push bc			;3193
	push hl			;3194
	pop bc			;3195
	dec de			;3196
	ld a,e			;3197
	or d			;3198
	jr z,$+5		;3199
	add hl,bc		;319b
	jr $-6			;319c
	pop bc			;319e
	ret			;319f
	push hl			;31a0
	push af			;31a1
	ld hl,031b5h		;31a2
	call 0098bh		;31a5
	ld a,020h		;31a8
	out (02eh),a		;31aa
	ld a,d			;31ac
	out (02fh),a		;31ad
	ld a,e			;31af
	out (02fh),a		;31b0
	pop af			;31b2
	pop hl			;31b3
	ret			;31b4
	ld d,d			;31b5
	ld c,a			;31b6
	ld c,l			;31b7
	ld b,d			;31b8
	ld b,c			;31b9
	ld d,e			;31ba
	nop			;31bb
	nop			;31bc
	nop			;31bd
	nop			;31be
	nop			;31bf
	nop			;31c0
	nop			;31c1
	nop			;31c2
	nop			;31c3
	nop			;31c4
	nop			;31c5
	nop			;31c6
	nop			;31c7
	nop			;31c8
	nop			;31c9
	nop			;31ca
	nop			;31cb
	nop			;31cc
	nop			;31cd
	nop			;31ce
	nop			;31cf
	nop			;31d0
	nop			;31d1
	nop			;31d2
	nop			;31d3
	nop			;31d4
	nop			;31d5
	nop			;31d6
	nop			;31d7
	nop			;31d8
	nop			;31d9
	nop			;31da
	nop			;31db
	nop			;31dc
	nop			;31dd
	nop			;31de
	nop			;31df
	nop			;31e0
	nop			;31e1
	nop			;31e2
	nop			;31e3
	nop			;31e4
	nop			;31e5
	nop			;31e6
	nop			;31e7
	nop			;31e8
	nop			;31e9
	nop			;31ea
	nop			;31eb
	nop			;31ec
	nop			;31ed
	nop			;31ee
	nop			;31ef
	nop			;31f0
	nop			;31f1
	nop			;31f2
	nop			;31f3
	nop			;31f4
	nop			;31f5
	nop			;31f6
	nop			;31f7
	nop			;31f8
	nop			;31f9
	nop			;31fa
	nop			;31fb
	nop			;31fc
	nop			;31fd
	nop			;31fe
	nop			;31ff
	nop			;3200
	nop			;3201
	nop			;3202
	nop			;3203
	nop			;3204
	nop			;3205
	nop			;3206
	nop			;3207
	nop			;3208
	nop			;3209
	nop			;320a
	nop			;320b
	nop			;320c
	nop			;320d
	nop			;320e
	nop			;320f
	nop			;3210
	nop			;3211
	nop			;3212
	nop			;3213
	nop			;3214
	nop			;3215
	nop			;3216
	nop			;3217
	nop			;3218
	nop			;3219
	nop			;321a
	nop			;321b
	nop			;321c
	nop			;321d
	nop			;321e
	nop			;321f
	nop			;3220
	nop			;3221
	nop			;3222
	nop			;3223
	nop			;3224
	nop			;3225
	nop			;3226
	nop			;3227
	nop			;3228
	nop			;3229
	nop			;322a
	nop			;322b
	nop			;322c
	nop			;322d
	nop			;322e
	nop			;322f
	nop			;3230
	nop			;3231
	nop			;3232
	nop			;3233
	nop			;3234
	nop			;3235
	nop			;3236
	nop			;3237
	nop			;3238
	nop			;3239
	nop			;323a
	nop			;323b
	nop			;323c
	nop			;323d
	nop			;323e
	nop			;323f
	nop			;3240
	nop			;3241
	nop			;3242
	nop			;3243
	nop			;3244
	nop			;3245
	nop			;3246
	nop			;3247
	nop			;3248
	nop			;3249
	nop			;324a
	nop			;324b
	nop			;324c
	nop			;324d
	nop			;324e
	nop			;324f
	nop			;3250
	nop			;3251
	nop			;3252
	nop			;3253
	nop			;3254
	nop			;3255
	nop			;3256
	nop			;3257
	nop			;3258
	nop			;3259
	nop			;325a
	nop			;325b
	nop			;325c
	nop			;325d
	nop			;325e
	nop			;325f
	nop			;3260
	nop			;3261
	nop			;3262
	nop			;3263
	nop			;3264
	nop			;3265
	nop			;3266
	nop			;3267
	nop			;3268
	nop			;3269
	nop			;326a
	nop			;326b
	nop			;326c
	nop			;326d
	nop			;326e
	nop			;326f
	nop			;3270
	nop			;3271
	nop			;3272
	nop			;3273
	nop			;3274
	nop			;3275
	nop			;3276
	nop			;3277
	nop			;3278
	nop			;3279
	nop			;327a
	nop			;327b
	nop			;327c
	nop			;327d
	nop			;327e
	nop			;327f
	nop			;3280
	nop			;3281
	nop			;3282
	nop			;3283
	nop			;3284
	nop			;3285
	nop			;3286
	nop			;3287
	nop			;3288
	nop			;3289
	nop			;328a
	nop			;328b
	nop			;328c
	nop			;328d
	nop			;328e
	nop			;328f
	nop			;3290
	nop			;3291
	nop			;3292
	nop			;3293
	nop			;3294
	nop			;3295
	nop			;3296
	nop			;3297
	nop			;3298
	nop			;3299
	nop			;329a
	nop			;329b
	nop			;329c
	nop			;329d
	nop			;329e
	nop			;329f
	nop			;32a0
	nop			;32a1
	nop			;32a2
	nop			;32a3
	nop			;32a4
	nop			;32a5
	nop			;32a6
	nop			;32a7
	nop			;32a8
	nop			;32a9
	nop			;32aa
	nop			;32ab
	nop			;32ac
	nop			;32ad
	nop			;32ae
	nop			;32af
	nop			;32b0
	nop			;32b1
	nop			;32b2
	nop			;32b3
	nop			;32b4
	nop			;32b5
	nop			;32b6
	nop			;32b7
	nop			;32b8
	nop			;32b9
	nop			;32ba
	nop			;32bb
	nop			;32bc
	nop			;32bd
	nop			;32be
	nop			;32bf
	nop			;32c0
	nop			;32c1
	nop			;32c2
	nop			;32c3
	nop			;32c4
	nop			;32c5
	nop			;32c6
	nop			;32c7
	nop			;32c8
	nop			;32c9
	nop			;32ca
	nop			;32cb
	nop			;32cc
	nop			;32cd
	nop			;32ce
	nop			;32cf
	nop			;32d0
	nop			;32d1
	nop			;32d2
	nop			;32d3
	nop			;32d4
	nop			;32d5
	nop			;32d6
	nop			;32d7
	nop			;32d8
	nop			;32d9
	nop			;32da
	nop			;32db
	nop			;32dc
	nop			;32dd
	nop			;32de
	nop			;32df
	nop			;32e0
	nop			;32e1
	nop			;32e2
	nop			;32e3
	nop			;32e4
	nop			;32e5
	nop			;32e6
	nop			;32e7
	nop			;32e8
	nop			;32e9
	nop			;32ea
	nop			;32eb
	nop			;32ec
	nop			;32ed
	nop			;32ee
	nop			;32ef
	nop			;32f0
	nop			;32f1
	nop			;32f2
	nop			;32f3
	nop			;32f4
	nop			;32f5
	nop			;32f6
	nop			;32f7
	nop			;32f8
	nop			;32f9
	nop			;32fa
	nop			;32fb
	nop			;32fc
	nop			;32fd
	nop			;32fe
	nop			;32ff
	nop			;3300
	nop			;3301
	nop			;3302
	nop			;3303
	nop			;3304
	nop			;3305
	nop			;3306
	nop			;3307
	nop			;3308
	nop			;3309
	nop			;330a
	nop			;330b
	nop			;330c
	nop			;330d
	nop			;330e
	nop			;330f
	nop			;3310
	nop			;3311
	nop			;3312
	nop			;3313
	nop			;3314
	nop			;3315
	nop			;3316
	nop			;3317
	nop			;3318
	nop			;3319
	nop			;331a
	nop			;331b
	nop			;331c
	nop			;331d
	nop			;331e
	nop			;331f
	nop			;3320
	nop			;3321
	nop			;3322
	nop			;3323
	nop			;3324
	nop			;3325
	nop			;3326
	nop			;3327
	nop			;3328
	nop			;3329
	nop			;332a
	nop			;332b
	nop			;332c
	nop			;332d
	nop			;332e
	nop			;332f
	nop			;3330
	nop			;3331
	nop			;3332
	nop			;3333
	nop			;3334
	nop			;3335
	nop			;3336
	nop			;3337
	nop			;3338
	nop			;3339
	nop			;333a
	nop			;333b
	nop			;333c
	nop			;333d
	nop			;333e
	nop			;333f
	nop			;3340
	nop			;3341
	nop			;3342
	nop			;3343
	nop			;3344
	nop			;3345
	nop			;3346
	nop			;3347
	nop			;3348
	nop			;3349
	nop			;334a
	nop			;334b
	nop			;334c
	nop			;334d
	nop			;334e
	nop			;334f
	nop			;3350
	nop			;3351
	nop			;3352
	nop			;3353
	nop			;3354
	nop			;3355
	nop			;3356
	nop			;3357
	nop			;3358
	nop			;3359
	nop			;335a
	nop			;335b
	nop			;335c
	nop			;335d
	nop			;335e
	nop			;335f
	nop			;3360
	nop			;3361
	nop			;3362
	nop			;3363
	nop			;3364
	nop			;3365
	nop			;3366
	nop			;3367
	nop			;3368
	nop			;3369
	nop			;336a
	nop			;336b
	nop			;336c
	nop			;336d
	nop			;336e
	nop			;336f
	nop			;3370
	nop			;3371
	nop			;3372
	nop			;3373
	nop			;3374
	nop			;3375
	nop			;3376
	nop			;3377
	nop			;3378
	nop			;3379
	nop			;337a
	nop			;337b
	nop			;337c
	nop			;337d
	nop			;337e
	nop			;337f
	nop			;3380
	nop			;3381
	nop			;3382
	nop			;3383
	nop			;3384
	nop			;3385
	nop			;3386
	nop			;3387
	nop			;3388
	nop			;3389
	nop			;338a
	nop			;338b
	nop			;338c
	nop			;338d
	nop			;338e
	nop			;338f
	nop			;3390
	nop			;3391
	nop			;3392
	nop			;3393
	nop			;3394
	nop			;3395
	nop			;3396
	nop			;3397
	nop			;3398
	nop			;3399
	nop			;339a
	nop			;339b
	nop			;339c
	nop			;339d
	nop			;339e
	nop			;339f
	nop			;33a0
	nop			;33a1
	nop			;33a2
	nop			;33a3
	nop			;33a4
	nop			;33a5
	nop			;33a6
	nop			;33a7
	nop			;33a8
	nop			;33a9
	nop			;33aa
	nop			;33ab
	nop			;33ac
	nop			;33ad
	nop			;33ae
	nop			;33af
	nop			;33b0
	nop			;33b1
	nop			;33b2
	nop			;33b3
	nop			;33b4
	nop			;33b5
	nop			;33b6
	nop			;33b7
	nop			;33b8
	nop			;33b9
	nop			;33ba
	nop			;33bb
	nop			;33bc
	nop			;33bd
	nop			;33be
	nop			;33bf
	nop			;33c0
	nop			;33c1
	nop			;33c2
	nop			;33c3
	nop			;33c4
	nop			;33c5
	nop			;33c6
	nop			;33c7
	nop			;33c8
	nop			;33c9
	nop			;33ca
	nop			;33cb
	nop			;33cc
	nop			;33cd
	nop			;33ce
	nop			;33cf
	nop			;33d0
	nop			;33d1
	nop			;33d2
	nop			;33d3
	nop			;33d4
	nop			;33d5
	nop			;33d6
	nop			;33d7
	nop			;33d8
	nop			;33d9
	nop			;33da
	nop			;33db
	nop			;33dc
	nop			;33dd
	nop			;33de
	nop			;33df
	nop			;33e0
	nop			;33e1
	nop			;33e2
	nop			;33e3
	nop			;33e4
	nop			;33e5
	nop			;33e6
	nop			;33e7
	nop			;33e8
	nop			;33e9
	nop			;33ea
	nop			;33eb
	nop			;33ec
	nop			;33ed
	nop			;33ee
	nop			;33ef
	nop			;33f0
	nop			;33f1
	nop			;33f2
	nop			;33f3
	nop			;33f4
	nop			;33f5
	nop			;33f6
	nop			;33f7
	nop			;33f8
	nop			;33f9
	nop			;33fa
	nop			;33fb
	nop			;33fc
	nop			;33fd
	nop			;33fe
	nop			;33ff
	nop			;3400
	nop			;3401
	nop			;3402
	nop			;3403
	nop			;3404
	nop			;3405
	nop			;3406
	nop			;3407
	nop			;3408
	nop			;3409
	nop			;340a
	nop			;340b
	nop			;340c
	nop			;340d
	nop			;340e
	nop			;340f
	nop			;3410
	nop			;3411
	nop			;3412
	nop			;3413
	nop			;3414
	nop			;3415
	nop			;3416
	nop			;3417
	nop			;3418
	nop			;3419
	nop			;341a
	nop			;341b
	nop			;341c
	nop			;341d
	nop			;341e
	nop			;341f
	nop			;3420
	nop			;3421
	nop			;3422
	nop			;3423
	nop			;3424
	nop			;3425
	nop			;3426
	nop			;3427
	nop			;3428
	nop			;3429
	nop			;342a
	nop			;342b
	nop			;342c
	nop			;342d
	nop			;342e
	nop			;342f
	nop			;3430
	nop			;3431
	nop			;3432
	nop			;3433
	nop			;3434
	nop			;3435
	nop			;3436
	nop			;3437
	nop			;3438
	nop			;3439
	nop			;343a
	nop			;343b
	nop			;343c
	nop			;343d
	nop			;343e
	nop			;343f
	nop			;3440
	nop			;3441
	nop			;3442
	nop			;3443
	nop			;3444
	nop			;3445
	nop			;3446
	nop			;3447
	nop			;3448
	nop			;3449
	nop			;344a
	nop			;344b
	nop			;344c
	nop			;344d
	nop			;344e
	nop			;344f
	nop			;3450
	nop			;3451
	nop			;3452
	nop			;3453
	nop			;3454
	nop			;3455
	nop			;3456
	nop			;3457
	nop			;3458
	nop			;3459
	nop			;345a
	nop			;345b
	nop			;345c
	nop			;345d
	nop			;345e
	nop			;345f
	nop			;3460
	nop			;3461
	nop			;3462
	nop			;3463
	nop			;3464
	nop			;3465
	nop			;3466
	nop			;3467
	nop			;3468
	nop			;3469
	nop			;346a
	nop			;346b
	nop			;346c
	nop			;346d
	nop			;346e
	nop			;346f
	nop			;3470
	nop			;3471
	nop			;3472
	nop			;3473
	nop			;3474
	nop			;3475
	nop			;3476
	nop			;3477
	nop			;3478
	nop			;3479
	nop			;347a
	nop			;347b
	nop			;347c
	nop			;347d
	nop			;347e
	nop			;347f
	nop			;3480
	nop			;3481
	nop			;3482
	nop			;3483
	nop			;3484
	nop			;3485
	nop			;3486
	nop			;3487
	nop			;3488
	nop			;3489
	nop			;348a
	nop			;348b
	nop			;348c
	nop			;348d
	nop			;348e
	nop			;348f
	nop			;3490
	nop			;3491
	nop			;3492
	nop			;3493
	nop			;3494
	nop			;3495
	nop			;3496
	nop			;3497
	nop			;3498
	nop			;3499
	nop			;349a
	nop			;349b
	nop			;349c
	nop			;349d
	nop			;349e
	nop			;349f
	nop			;34a0
	nop			;34a1
	nop			;34a2
	nop			;34a3
	nop			;34a4
	nop			;34a5
	nop			;34a6
	nop			;34a7
	nop			;34a8
	nop			;34a9
	nop			;34aa
	nop			;34ab
	nop			;34ac
	nop			;34ad
	nop			;34ae
	nop			;34af
	nop			;34b0
	nop			;34b1
	nop			;34b2
	nop			;34b3
	nop			;34b4
	nop			;34b5
	nop			;34b6
	nop			;34b7
	nop			;34b8
	nop			;34b9
	nop			;34ba
	nop			;34bb
	nop			;34bc
	nop			;34bd
	nop			;34be
	nop			;34bf
	nop			;34c0
	nop			;34c1
	nop			;34c2
	nop			;34c3
	nop			;34c4
	nop			;34c5
	nop			;34c6
	nop			;34c7
	nop			;34c8
	nop			;34c9
	nop			;34ca
	nop			;34cb
	nop			;34cc
	nop			;34cd
	nop			;34ce
	nop			;34cf
	nop			;34d0
	nop			;34d1
	nop			;34d2
	nop			;34d3
	nop			;34d4
	nop			;34d5
	nop			;34d6
	nop			;34d7
	nop			;34d8
	nop			;34d9
	nop			;34da
	nop			;34db
	nop			;34dc
	nop			;34dd
	nop			;34de
	nop			;34df
	nop			;34e0
	nop			;34e1
	nop			;34e2
	nop			;34e3
	nop			;34e4
	nop			;34e5
	nop			;34e6
	nop			;34e7
	nop			;34e8
	nop			;34e9
	nop			;34ea
	nop			;34eb
	nop			;34ec
	nop			;34ed
	nop			;34ee
	nop			;34ef
	nop			;34f0
	nop			;34f1
	nop			;34f2
	nop			;34f3
	nop			;34f4
	nop			;34f5
	nop			;34f6
	nop			;34f7
	nop			;34f8
	nop			;34f9
	nop			;34fa
	nop			;34fb
	nop			;34fc
	nop			;34fd
	nop			;34fe
	nop			;34ff
	nop			;3500
	nop			;3501
	nop			;3502
	nop			;3503
	nop			;3504
	nop			;3505
	nop			;3506
	nop			;3507
	nop			;3508
	nop			;3509
	nop			;350a
	nop			;350b
	nop			;350c
	nop			;350d
	nop			;350e
	nop			;350f
	nop			;3510
	nop			;3511
	nop			;3512
	nop			;3513
	nop			;3514
	nop			;3515
	nop			;3516
	nop			;3517
	nop			;3518
	nop			;3519
	nop			;351a
	nop			;351b
	nop			;351c
	nop			;351d
	nop			;351e
	nop			;351f
	nop			;3520
	nop			;3521
	nop			;3522
	nop			;3523
	nop			;3524
	nop			;3525
	nop			;3526
	nop			;3527
	nop			;3528
	nop			;3529
	nop			;352a
	nop			;352b
	nop			;352c
	nop			;352d
	nop			;352e
	nop			;352f
	nop			;3530
	nop			;3531
	nop			;3532
	nop			;3533
	nop			;3534
	nop			;3535
	nop			;3536
	nop			;3537
	nop			;3538
	nop			;3539
	nop			;353a
	nop			;353b
	nop			;353c
	nop			;353d
	nop			;353e
	nop			;353f
	nop			;3540
	nop			;3541
	nop			;3542
	nop			;3543
	nop			;3544
	nop			;3545
	nop			;3546
	nop			;3547
	nop			;3548
	nop			;3549
	nop			;354a
	nop			;354b
	nop			;354c
	nop			;354d
	nop			;354e
	nop			;354f
	nop			;3550
	nop			;3551
	nop			;3552
	nop			;3553
	nop			;3554
	nop			;3555
	nop			;3556
	nop			;3557
	nop			;3558
	nop			;3559
	nop			;355a
	nop			;355b
	nop			;355c
	nop			;355d
	nop			;355e
	nop			;355f
	nop			;3560
	nop			;3561
	nop			;3562
	nop			;3563
	nop			;3564
	nop			;3565
	nop			;3566
	nop			;3567
	nop			;3568
	nop			;3569
	nop			;356a
	nop			;356b
	nop			;356c
	nop			;356d
	nop			;356e
	nop			;356f
	nop			;3570
	nop			;3571
	nop			;3572
	nop			;3573
	nop			;3574
	nop			;3575
	nop			;3576
	nop			;3577
	nop			;3578
	nop			;3579
	nop			;357a
	nop			;357b
	nop			;357c
	nop			;357d
	nop			;357e
	nop			;357f
	nop			;3580
	nop			;3581
	nop			;3582
	nop			;3583
	nop			;3584
	nop			;3585
	nop			;3586
	nop			;3587
	nop			;3588
	nop			;3589
	nop			;358a
	nop			;358b
	nop			;358c
	nop			;358d
	nop			;358e
	nop			;358f
	nop			;3590
	nop			;3591
	nop			;3592
	nop			;3593
	nop			;3594
	nop			;3595
	nop			;3596
	nop			;3597
	nop			;3598
	nop			;3599
	nop			;359a
	nop			;359b
	nop			;359c
	nop			;359d
	nop			;359e
	nop			;359f
	nop			;35a0
	nop			;35a1
	nop			;35a2
	nop			;35a3
	nop			;35a4
	nop			;35a5
	nop			;35a6
	nop			;35a7
	nop			;35a8
	nop			;35a9
	nop			;35aa
	nop			;35ab
	nop			;35ac
	nop			;35ad
	nop			;35ae
	nop			;35af
	nop			;35b0
	nop			;35b1
	nop			;35b2
	nop			;35b3
	nop			;35b4
	nop			;35b5
	nop			;35b6
	nop			;35b7
	nop			;35b8
	nop			;35b9
	nop			;35ba
	nop			;35bb
	nop			;35bc
	nop			;35bd
	nop			;35be
	nop			;35bf
	nop			;35c0
	nop			;35c1
	nop			;35c2
	nop			;35c3
	nop			;35c4
	nop			;35c5
	nop			;35c6
	nop			;35c7
	nop			;35c8
	nop			;35c9
	nop			;35ca
	nop			;35cb
	nop			;35cc
	nop			;35cd
	nop			;35ce
	nop			;35cf
	nop			;35d0
	nop			;35d1
	nop			;35d2
	nop			;35d3
	nop			;35d4
	nop			;35d5
	nop			;35d6
	nop			;35d7
	nop			;35d8
	nop			;35d9
	nop			;35da
	nop			;35db
	nop			;35dc
	nop			;35dd
	nop			;35de
	nop			;35df
	nop			;35e0
	nop			;35e1
	nop			;35e2
	nop			;35e3
	nop			;35e4
	nop			;35e5
	nop			;35e6
	nop			;35e7
	nop			;35e8
	nop			;35e9
	nop			;35ea
	nop			;35eb
	nop			;35ec
	nop			;35ed
	nop			;35ee
	nop			;35ef
	nop			;35f0
	nop			;35f1
	nop			;35f2
	nop			;35f3
	nop			;35f4
	nop			;35f5
	nop			;35f6
	nop			;35f7
	nop			;35f8
	nop			;35f9
	nop			;35fa
	nop			;35fb
	nop			;35fc
	nop			;35fd
	nop			;35fe
	nop			;35ff
	nop			;3600
	nop			;3601
	nop			;3602
	nop			;3603
	nop			;3604
	nop			;3605
	nop			;3606
	nop			;3607
	nop			;3608
	nop			;3609
	nop			;360a
	nop			;360b
	nop			;360c
	nop			;360d
	nop			;360e
	nop			;360f
	nop			;3610
	nop			;3611
	nop			;3612
	nop			;3613
	nop			;3614
	nop			;3615
	nop			;3616
	nop			;3617
	nop			;3618
	nop			;3619
	nop			;361a
	nop			;361b
	nop			;361c
	nop			;361d
	nop			;361e
	nop			;361f
	nop			;3620
	nop			;3621
	nop			;3622
	nop			;3623
	nop			;3624
	nop			;3625
	nop			;3626
	nop			;3627
	nop			;3628
	nop			;3629
	nop			;362a
	nop			;362b
	nop			;362c
	nop			;362d
	nop			;362e
	nop			;362f
	nop			;3630
	nop			;3631
	nop			;3632
	nop			;3633
	nop			;3634
	nop			;3635
	nop			;3636
	nop			;3637
	nop			;3638
	nop			;3639
	nop			;363a
	nop			;363b
	nop			;363c
	nop			;363d
	nop			;363e
	nop			;363f
	nop			;3640
	nop			;3641
	nop			;3642
	nop			;3643
	nop			;3644
	nop			;3645
	nop			;3646
	nop			;3647
	nop			;3648
	nop			;3649
	nop			;364a
	nop			;364b
	nop			;364c
	nop			;364d
	nop			;364e
	nop			;364f
	nop			;3650
	nop			;3651
	nop			;3652
	nop			;3653
	nop			;3654
	nop			;3655
	nop			;3656
	nop			;3657
	nop			;3658
	nop			;3659
	nop			;365a
	nop			;365b
	nop			;365c
	nop			;365d
	nop			;365e
	nop			;365f
	nop			;3660
	nop			;3661
	nop			;3662
	nop			;3663
	nop			;3664
	nop			;3665
	nop			;3666
	nop			;3667
	nop			;3668
	nop			;3669
	nop			;366a
	nop			;366b
	nop			;366c
	nop			;366d
	nop			;366e
	nop			;366f
	nop			;3670
	nop			;3671
	nop			;3672
	nop			;3673
	nop			;3674
	nop			;3675
	nop			;3676
	nop			;3677
	nop			;3678
	nop			;3679
	nop			;367a
	nop			;367b
	nop			;367c
	nop			;367d
	nop			;367e
	nop			;367f
	nop			;3680
	nop			;3681
	nop			;3682
	nop			;3683
	nop			;3684
	nop			;3685
	nop			;3686
	nop			;3687
	nop			;3688
	nop			;3689
	nop			;368a
	nop			;368b
	nop			;368c
	nop			;368d
	nop			;368e
	nop			;368f
	nop			;3690
	nop			;3691
	nop			;3692
	nop			;3693
	nop			;3694
	nop			;3695
	nop			;3696
	nop			;3697
	nop			;3698
	nop			;3699
	nop			;369a
	nop			;369b
	nop			;369c
	nop			;369d
	nop			;369e
	nop			;369f
	nop			;36a0
	nop			;36a1
	nop			;36a2
	nop			;36a3
	nop			;36a4
	nop			;36a5
	nop			;36a6
	nop			;36a7
	nop			;36a8
	nop			;36a9
	nop			;36aa
	nop			;36ab
	nop			;36ac
	nop			;36ad
	nop			;36ae
	nop			;36af
	nop			;36b0
	nop			;36b1
	nop			;36b2
	nop			;36b3
	nop			;36b4
	nop			;36b5
	nop			;36b6
	nop			;36b7
	nop			;36b8
	nop			;36b9
	nop			;36ba
	nop			;36bb
	nop			;36bc
	nop			;36bd
	nop			;36be
	nop			;36bf
	nop			;36c0
	nop			;36c1
	nop			;36c2
	nop			;36c3
	nop			;36c4
	nop			;36c5
	nop			;36c6
	nop			;36c7
	nop			;36c8
	nop			;36c9
	nop			;36ca
	nop			;36cb
	nop			;36cc
	nop			;36cd
	nop			;36ce
	nop			;36cf
	nop			;36d0
	nop			;36d1
	nop			;36d2
	nop			;36d3
	nop			;36d4
	nop			;36d5
	nop			;36d6
	nop			;36d7
	nop			;36d8
	nop			;36d9
	nop			;36da
	nop			;36db
	nop			;36dc
	nop			;36dd
	nop			;36de
	nop			;36df
	nop			;36e0
	nop			;36e1
	nop			;36e2
	nop			;36e3
	nop			;36e4
	nop			;36e5
	nop			;36e6
	nop			;36e7
	nop			;36e8
	nop			;36e9
	nop			;36ea
	nop			;36eb
	nop			;36ec
	nop			;36ed
	nop			;36ee
	nop			;36ef
	nop			;36f0
	nop			;36f1
	nop			;36f2
	nop			;36f3
	nop			;36f4
	nop			;36f5
	nop			;36f6
	nop			;36f7
	nop			;36f8
	nop			;36f9
	nop			;36fa
	nop			;36fb
	nop			;36fc
	nop			;36fd
	nop			;36fe
	nop			;36ff
	nop			;3700
	nop			;3701
	nop			;3702
	nop			;3703
	nop			;3704
	nop			;3705
	nop			;3706
	nop			;3707
	nop			;3708
	nop			;3709
	nop			;370a
	nop			;370b
	nop			;370c
	nop			;370d
	nop			;370e
	nop			;370f
	nop			;3710
	nop			;3711
	nop			;3712
	nop			;3713
	nop			;3714
	nop			;3715
	nop			;3716
	nop			;3717
	nop			;3718
	nop			;3719
	nop			;371a
	nop			;371b
	nop			;371c
	nop			;371d
	nop			;371e
	nop			;371f
	nop			;3720
	nop			;3721
	nop			;3722
	nop			;3723
	nop			;3724
	nop			;3725
	nop			;3726
	nop			;3727
	nop			;3728
	nop			;3729
	nop			;372a
	nop			;372b
	nop			;372c
	nop			;372d
	nop			;372e
	nop			;372f
	nop			;3730
	nop			;3731
	nop			;3732
	nop			;3733
	nop			;3734
	nop			;3735
	nop			;3736
	nop			;3737
	nop			;3738
	nop			;3739
	nop			;373a
	nop			;373b
	nop			;373c
	nop			;373d
	nop			;373e
	nop			;373f
	nop			;3740
	nop			;3741
	nop			;3742
	nop			;3743
	nop			;3744
	nop			;3745
	nop			;3746
	nop			;3747
	nop			;3748
	nop			;3749
	nop			;374a
	nop			;374b
	nop			;374c
	nop			;374d
	nop			;374e
	nop			;374f
	nop			;3750
	nop			;3751
	nop			;3752
	nop			;3753
	nop			;3754
	nop			;3755
	nop			;3756
	nop			;3757
	nop			;3758
	nop			;3759
	nop			;375a
	nop			;375b
	nop			;375c
	nop			;375d
	nop			;375e
	nop			;375f
	nop			;3760
	nop			;3761
	nop			;3762
	nop			;3763
	nop			;3764
	nop			;3765
	nop			;3766
	nop			;3767
	nop			;3768
	nop			;3769
	nop			;376a
	nop			;376b
	nop			;376c
	nop			;376d
	nop			;376e
	nop			;376f
	nop			;3770
	nop			;3771
	nop			;3772
	nop			;3773
	nop			;3774
	nop			;3775
	nop			;3776
	nop			;3777
	nop			;3778
	nop			;3779
	nop			;377a
	nop			;377b
	nop			;377c
	nop			;377d
	nop			;377e
	nop			;377f
	nop			;3780
	nop			;3781
	nop			;3782
	nop			;3783
	nop			;3784
	nop			;3785
	nop			;3786
	nop			;3787
	nop			;3788
	nop			;3789
	nop			;378a
	nop			;378b
	nop			;378c
	nop			;378d
	nop			;378e
	nop			;378f
	nop			;3790
	nop			;3791
	nop			;3792
	nop			;3793
	nop			;3794
	nop			;3795
	nop			;3796
	nop			;3797
	nop			;3798
	nop			;3799
	nop			;379a
	nop			;379b
	nop			;379c
	nop			;379d
	nop			;379e
	nop			;379f
	nop			;37a0
	nop			;37a1
	nop			;37a2
	nop			;37a3
	nop			;37a4
	nop			;37a5
	nop			;37a6
	nop			;37a7
	nop			;37a8
	nop			;37a9
	nop			;37aa
	nop			;37ab
	nop			;37ac
	nop			;37ad
	nop			;37ae
	nop			;37af
	nop			;37b0
	nop			;37b1
	nop			;37b2
	nop			;37b3
	nop			;37b4
	nop			;37b5
	nop			;37b6
	nop			;37b7
	nop			;37b8
	nop			;37b9
	nop			;37ba
	nop			;37bb
	nop			;37bc
	nop			;37bd
	nop			;37be
	nop			;37bf
	nop			;37c0
	nop			;37c1
	nop			;37c2
	nop			;37c3
	nop			;37c4
	nop			;37c5
	nop			;37c6
	nop			;37c7
	nop			;37c8
	nop			;37c9
	nop			;37ca
	nop			;37cb
	nop			;37cc
	nop			;37cd
	nop			;37ce
	nop			;37cf
	nop			;37d0
	nop			;37d1
	nop			;37d2
	nop			;37d3
	nop			;37d4
	nop			;37d5
	nop			;37d6
	nop			;37d7
	nop			;37d8
	nop			;37d9
	nop			;37da
	nop			;37db
	nop			;37dc
	nop			;37dd
	nop			;37de
	nop			;37df
	nop			;37e0
	nop			;37e1
	nop			;37e2
	nop			;37e3
	nop			;37e4
	nop			;37e5
	nop			;37e6
	nop			;37e7
	nop			;37e8
	nop			;37e9
	nop			;37ea
	nop			;37eb
	nop			;37ec
	nop			;37ed
	nop			;37ee
	nop			;37ef
	nop			;37f0
	nop			;37f1
	nop			;37f2
	nop			;37f3
	nop			;37f4
	nop			;37f5
	nop			;37f6
	nop			;37f7
	nop			;37f8
	nop			;37f9
	nop			;37fa
	nop			;37fb
	nop			;37fc
	nop			;37fd
	nop			;37fe
	nop			;37ff
	nop			;3800
	nop			;3801
	nop			;3802
	nop			;3803
	nop			;3804
	nop			;3805
	nop			;3806
	nop			;3807
	nop			;3808
	nop			;3809
	nop			;380a
	nop			;380b
	nop			;380c
	nop			;380d
	nop			;380e
	nop			;380f
	nop			;3810
	nop			;3811
	nop			;3812
	nop			;3813
	nop			;3814
	nop			;3815
	nop			;3816
	nop			;3817
	nop			;3818
	nop			;3819
	nop			;381a
	nop			;381b
	nop			;381c
	nop			;381d
	nop			;381e
	nop			;381f
	nop			;3820
	nop			;3821
	nop			;3822
	nop			;3823
	nop			;3824
	nop			;3825
	nop			;3826
	nop			;3827
	nop			;3828
	nop			;3829
	nop			;382a
	nop			;382b
	nop			;382c
	nop			;382d
	nop			;382e
	nop			;382f
	nop			;3830
	nop			;3831
	nop			;3832
	nop			;3833
	nop			;3834
	nop			;3835
	nop			;3836
	nop			;3837
	nop			;3838
	nop			;3839
	nop			;383a
	nop			;383b
	nop			;383c
	nop			;383d
	nop			;383e
	nop			;383f
	nop			;3840
	nop			;3841
	nop			;3842
	nop			;3843
	nop			;3844
	nop			;3845
	nop			;3846
	nop			;3847
	nop			;3848
	nop			;3849
	nop			;384a
	nop			;384b
	nop			;384c
	nop			;384d
	nop			;384e
	nop			;384f
	nop			;3850
	nop			;3851
	nop			;3852
	nop			;3853
	nop			;3854
	nop			;3855
	nop			;3856
	nop			;3857
	nop			;3858
	nop			;3859
	nop			;385a
	nop			;385b
	nop			;385c
	nop			;385d
	nop			;385e
	nop			;385f
	nop			;3860
	nop			;3861
	nop			;3862
	nop			;3863
	nop			;3864
	nop			;3865
	nop			;3866
	nop			;3867
	nop			;3868
	nop			;3869
	nop			;386a
	nop			;386b
	nop			;386c
	nop			;386d
	nop			;386e
	nop			;386f
	nop			;3870
	nop			;3871
	nop			;3872
	nop			;3873
	nop			;3874
	nop			;3875
	nop			;3876
	nop			;3877
	nop			;3878
	nop			;3879
	nop			;387a
	nop			;387b
	nop			;387c
	nop			;387d
	nop			;387e
	nop			;387f
	nop			;3880
	nop			;3881
	nop			;3882
	nop			;3883
	nop			;3884
	nop			;3885
	nop			;3886
	nop			;3887
	nop			;3888
	nop			;3889
	nop			;388a
	nop			;388b
	nop			;388c
	nop			;388d
	nop			;388e
	nop			;388f
	nop			;3890
	nop			;3891
	nop			;3892
	nop			;3893
	nop			;3894
	nop			;3895
	nop			;3896
	nop			;3897
	nop			;3898
	nop			;3899
	nop			;389a
	nop			;389b
	nop			;389c
	nop			;389d
	nop			;389e
	nop			;389f
	nop			;38a0
	nop			;38a1
	nop			;38a2
	nop			;38a3
	nop			;38a4
	nop			;38a5
	nop			;38a6
	nop			;38a7
	nop			;38a8
	nop			;38a9
	nop			;38aa
	nop			;38ab
	nop			;38ac
	nop			;38ad
	nop			;38ae
	nop			;38af
	nop			;38b0
	nop			;38b1
	nop			;38b2
	nop			;38b3
	nop			;38b4
	nop			;38b5
	nop			;38b6
	nop			;38b7
	nop			;38b8
	nop			;38b9
	nop			;38ba
	nop			;38bb
	nop			;38bc
	nop			;38bd
	nop			;38be
	nop			;38bf
	nop			;38c0
	nop			;38c1
	nop			;38c2
	nop			;38c3
	nop			;38c4
	nop			;38c5
	nop			;38c6
	nop			;38c7
	nop			;38c8
	nop			;38c9
	nop			;38ca
	nop			;38cb
	nop			;38cc
	nop			;38cd
	nop			;38ce
	nop			;38cf
	nop			;38d0
	nop			;38d1
	nop			;38d2
	nop			;38d3
	nop			;38d4
	nop			;38d5
	nop			;38d6
	nop			;38d7
	nop			;38d8
	nop			;38d9
	nop			;38da
	nop			;38db
	nop			;38dc
	nop			;38dd
	nop			;38de
	nop			;38df
	nop			;38e0
	nop			;38e1
	nop			;38e2
	nop			;38e3
	nop			;38e4
	nop			;38e5
	nop			;38e6
	nop			;38e7
	nop			;38e8
	nop			;38e9
	nop			;38ea
	nop			;38eb
	nop			;38ec
	nop			;38ed
	nop			;38ee
	nop			;38ef
	nop			;38f0
	nop			;38f1
	nop			;38f2
	nop			;38f3
	nop			;38f4
	nop			;38f5
	nop			;38f6
	nop			;38f7
	nop			;38f8
	nop			;38f9
	nop			;38fa
	nop			;38fb
	nop			;38fc
	nop			;38fd
	nop			;38fe
	nop			;38ff
	nop			;3900
	nop			;3901
	nop			;3902
	nop			;3903
	nop			;3904
	nop			;3905
	nop			;3906
	nop			;3907
	nop			;3908
	nop			;3909
	nop			;390a
	nop			;390b
	nop			;390c
	nop			;390d
	nop			;390e
	nop			;390f
	nop			;3910
	nop			;3911
	nop			;3912
	nop			;3913
	nop			;3914
	nop			;3915
	nop			;3916
	nop			;3917
	nop			;3918
	nop			;3919
	nop			;391a
	nop			;391b
	nop			;391c
	nop			;391d
	nop			;391e
	nop			;391f
	nop			;3920
	nop			;3921
	nop			;3922
	nop			;3923
	nop			;3924
	nop			;3925
	nop			;3926
	nop			;3927
	nop			;3928
	nop			;3929
	nop			;392a
	nop			;392b
	nop			;392c
	nop			;392d
	ld a,03ah		;392e
	ld a,03ah		;3930
	ld a,03ah		;3932
	ld a,03ah		;3934
	ld a,03ah		;3936
	ld a,03ah		;3938
	ld a,03ah		;393a
	ld a,03ah		;393c
	ld a,03ah		;393e
	ld a,03ah		;3940
	ld a,03ah		;3942
	ld a,03ah		;3944
	ld a,03ah		;3946
	ld a,03ah		;3948
	ld a,03ah		;394a
	ld a,03ah		;394c
	ld a,03ah		;394e
	ld a,03ah		;3950
	ld a,03ah		;3952
	ld a,03ah		;3954
	ld a,03ah		;3956
	ld a,03ah		;3958
	ld a,03ah		;395a
	ld a,03ah		;395c
	ld a,03ah		;395e
	ld a,03ah		;3960
	ld a,03ah		;3962
	ld a,03ah		;3964
	ld a,03ah		;3966
	ld a,03ah		;3968
	ld a,03ah		;396a
	ld a,03ah		;396c
	ld a,03ah		;396e
	ld a,03ah		;3970
	ld a,03ah		;3972
	ld a,03ah		;3974
	ld a,03ah		;3976
	ld a,03ah		;3978
	ld a,03ah		;397a
	ld a,03ah		;397c
	ld a,03ah		;397e
	ld a,03ah		;3980
	ld a,03ah		;3982
	ld a,03ah		;3984
	ld a,03ah		;3986
	ld a,03ah		;3988
	ld a,03ah		;398a
	ld a,03ah		;398c
	ld a,03ah		;398e
	ld a,03ah		;3990
	ld a,03ah		;3992
	ld a,03ah		;3994
	ld a,03ah		;3996
	ld a,03ah		;3998
	ld a,03ah		;399a
	ld a,03ah		;399c
	ld a,03ah		;399e
	ld a,03ah		;39a0
	ld a,03ah		;39a2
	ld a,03ah		;39a4
	ld a,03ah		;39a6
	ld a,03ah		;39a8
	ld a,03ah		;39aa
	ld a,03ah		;39ac
	ld a,03ah		;39ae
	ld a,03ah		;39b0
	ld a,03ah		;39b2
	ld a,03ah		;39b4
	ld a,03ah		;39b6
	ld a,03ah		;39b8
	ld a,03ah		;39ba
	ld a,03ah		;39bc
	ld a,03ah		;39be
	ld a,03ah		;39c0
	ld a,03ah		;39c2
	ld a,03ah		;39c4
	ld a,03ah		;39c6
	ld a,03ah		;39c8
	ld a,03ah		;39ca
	ld a,03ah		;39cc
	ld a,03ah		;39ce
	ld a,03ah		;39d0
	ld a,03ah		;39d2
	ld a,03ah		;39d4
	ld a,03ah		;39d6
	ld a,03ah		;39d8
	ld a,03ah		;39da
	ld a,03ah		;39dc
	ld a,03ah		;39de
	ld a,03ah		;39e0
	ld a,03ah		;39e2
	ld a,03ah		;39e4
	ld a,03ah		;39e6
	ld a,03ah		;39e8
	ld a,03ah		;39ea
	ld a,03ah		;39ec
	ld a,03ah		;39ee
	ld a,03ah		;39f0
	ld a,03ah		;39f2
	ld a,03ah		;39f4
	ld a,03ah		;39f6
	ld a,03ah		;39f8
	ld a,03ah		;39fa
	ld a,03ah		;39fc
	ld a,03ah		;39fe
	ld a,03ah		;3a00
	ld a,03ah		;3a02
	ld a,03ah		;3a04
	ld a,03ah		;3a06
	ld a,03ah		;3a08
	ld a,03ah		;3a0a
	ld a,03ah		;3a0c
	ld a,03ah		;3a0e
	ld a,03ah		;3a10
	ld a,03ah		;3a12
	ld a,03ah		;3a14
	ld a,03ah		;3a16
	ld a,03ah		;3a18
	ld a,03ah		;3a1a
	ld a,03ah		;3a1c
	ld a,03ah		;3a1e
	ld a,03ah		;3a20
	ld a,03ah		;3a22
	ld a,03ah		;3a24
	ld a,03ah		;3a26
	ld a,03ah		;3a28
	ld a,03ah		;3a2a
	ld a,03ah		;3a2c
	ld a,03ah		;3a2e
	ld a,03ah		;3a30
	ld a,03ah		;3a32
	ld a,03ah		;3a34
	ld a,03ah		;3a36
	ld a,03ah		;3a38
	ld a,03ah		;3a3a
	ld a,03ah		;3a3c
	push hl			;3a3e
	push af			;3a3f
	ld hl,03a49h		;3a40
	call 0098bh		;3a43
	pop af			;3a46
	pop hl			;3a47
	ret			;3a48
	ld b,d			;3a49
	ld b,c			;3a4a
	ld d,e			;3a4b
	ld c,c			;3a4c
	ld b,e			;3a4d
	jr nz,$+117		;3a4e
	ld (hl),h		;3a50
	ld h,c			;3a51
	ld (hl),h		;3a52
	ld h,l			;3a53
	ld l,l			;3a54
	ld h,l			;3a55
	ld l,(hl)		;3a56
	ld (hl),h		;3a57
	ld (hl),e		;3a58
	jr nz,$+99		;3a59
	ld (hl),d		;3a5b
	ld h,l			;3a5c
	jr nz,$+112		;3a5d
	ld l,a			;3a5f
	ld (hl),h		;3a60
	jr nz,$+107		;3a61
	ld l,l			;3a63
	ld (hl),b		;3a64
	ld l,h			;3a65
	ld h,l			;3a66
	ld l,l			;3a67
	ld h,l			;3a68
	ld l,(hl)		;3a69
	ld (hl),h		;3a6a
	ld h,l			;3a6b
	ld h,h			;3a6c
	jr nz,$+123		;3a6d
	ld h,l			;3a6f
	ld (hl),h		;3a70
	nop			;3a71
	nop			;3a72
	nop			;3a73
	nop			;3a74
	nop			;3a75
	nop			;3a76
	nop			;3a77
	nop			;3a78
	nop			;3a79
	nop			;3a7a
	nop			;3a7b
	nop			;3a7c
	nop			;3a7d
	nop			;3a7e
	nop			;3a7f
	nop			;3a80
	nop			;3a81
	nop			;3a82
	nop			;3a83
	nop			;3a84
	nop			;3a85
	nop			;3a86
	nop			;3a87
	nop			;3a88
	nop			;3a89
	nop			;3a8a
	nop			;3a8b
	nop			;3a8c
	nop			;3a8d
	nop			;3a8e
	nop			;3a8f
	nop			;3a90
	nop			;3a91
	nop			;3a92
	nop			;3a93
	nop			;3a94
	nop			;3a95
	nop			;3a96
	nop			;3a97
	nop			;3a98
	nop			;3a99
	nop			;3a9a
	nop			;3a9b
	nop			;3a9c
	nop			;3a9d
	nop			;3a9e
	nop			;3a9f
	nop			;3aa0
	nop			;3aa1
	nop			;3aa2
	nop			;3aa3
	nop			;3aa4
	nop			;3aa5
	nop			;3aa6
	nop			;3aa7
	nop			;3aa8
	nop			;3aa9
	nop			;3aaa
	nop			;3aab
	nop			;3aac
	nop			;3aad
	nop			;3aae
	nop			;3aaf
	nop			;3ab0
	nop			;3ab1
	nop			;3ab2
	nop			;3ab3
	nop			;3ab4
	nop			;3ab5
	nop			;3ab6
	nop			;3ab7
	nop			;3ab8
	nop			;3ab9
	nop			;3aba
	nop			;3abb
	nop			;3abc
	nop			;3abd
	nop			;3abe
	nop			;3abf
	nop			;3ac0
	nop			;3ac1
	nop			;3ac2
	nop			;3ac3
	nop			;3ac4
	nop			;3ac5
	nop			;3ac6
	nop			;3ac7
	nop			;3ac8
	nop			;3ac9
	nop			;3aca
	nop			;3acb
	nop			;3acc
	nop			;3acd
	nop			;3ace
	nop			;3acf
	nop			;3ad0
	nop			;3ad1
	nop			;3ad2
	nop			;3ad3
	nop			;3ad4
	nop			;3ad5
	nop			;3ad6
	nop			;3ad7
	nop			;3ad8
	nop			;3ad9
	nop			;3ada
	nop			;3adb
	nop			;3adc
	nop			;3add
	nop			;3ade
	nop			;3adf
	nop			;3ae0
	nop			;3ae1
	nop			;3ae2
	nop			;3ae3
	nop			;3ae4
	nop			;3ae5
	nop			;3ae6
	nop			;3ae7
	nop			;3ae8
	nop			;3ae9
	nop			;3aea
	nop			;3aeb
	nop			;3aec
	nop			;3aed
	nop			;3aee
	nop			;3aef
	nop			;3af0
	nop			;3af1
	nop			;3af2
	nop			;3af3
	nop			;3af4
	nop			;3af5
	nop			;3af6
	nop			;3af7
	nop			;3af8
	nop			;3af9
	nop			;3afa
	nop			;3afb
	nop			;3afc
	nop			;3afd
	nop			;3afe
	nop			;3aff
	nop			;3b00
	nop			;3b01
	nop			;3b02
	nop			;3b03
	nop			;3b04
	nop			;3b05
	nop			;3b06
	nop			;3b07
	nop			;3b08
	nop			;3b09
	nop			;3b0a
	nop			;3b0b
	nop			;3b0c
	nop			;3b0d
	nop			;3b0e
	nop			;3b0f
	nop			;3b10
	nop			;3b11
	nop			;3b12
	nop			;3b13
	nop			;3b14
	nop			;3b15
	nop			;3b16
	nop			;3b17
	nop			;3b18
	nop			;3b19
	nop			;3b1a
	nop			;3b1b
	nop			;3b1c
	nop			;3b1d
	nop			;3b1e
	nop			;3b1f
	nop			;3b20
	nop			;3b21
	nop			;3b22
	nop			;3b23
	nop			;3b24
	nop			;3b25
	nop			;3b26
	nop			;3b27
	nop			;3b28
	nop			;3b29
	nop			;3b2a
	nop			;3b2b
	nop			;3b2c
	nop			;3b2d
	nop			;3b2e
	nop			;3b2f
	nop			;3b30
	nop			;3b31
	nop			;3b32
	nop			;3b33
	nop			;3b34
	nop			;3b35
	nop			;3b36
	nop			;3b37
	nop			;3b38
	nop			;3b39
	nop			;3b3a
	nop			;3b3b
	nop			;3b3c
	nop			;3b3d
	nop			;3b3e
	nop			;3b3f
	nop			;3b40
	nop			;3b41
	nop			;3b42
	nop			;3b43
	nop			;3b44
	nop			;3b45
	nop			;3b46
	nop			;3b47
	nop			;3b48
	nop			;3b49
	nop			;3b4a
	nop			;3b4b
	nop			;3b4c
	nop			;3b4d
	nop			;3b4e
	nop			;3b4f
	nop			;3b50
	nop			;3b51
	nop			;3b52
	nop			;3b53
	nop			;3b54
	nop			;3b55
	nop			;3b56
	nop			;3b57
	nop			;3b58
	nop			;3b59
	nop			;3b5a
	nop			;3b5b
	nop			;3b5c
	nop			;3b5d
	nop			;3b5e
	nop			;3b5f
	nop			;3b60
	nop			;3b61
	nop			;3b62
	nop			;3b63
	nop			;3b64
	nop			;3b65
	nop			;3b66
	nop			;3b67
	nop			;3b68
	nop			;3b69
	nop			;3b6a
	nop			;3b6b
	nop			;3b6c
	nop			;3b6d
	nop			;3b6e
	nop			;3b6f
	nop			;3b70
	nop			;3b71
	nop			;3b72
	nop			;3b73
	nop			;3b74
	nop			;3b75
	nop			;3b76
	nop			;3b77
	nop			;3b78
	nop			;3b79
	nop			;3b7a
	nop			;3b7b
	nop			;3b7c
	nop			;3b7d
	nop			;3b7e
	nop			;3b7f
	nop			;3b80
	nop			;3b81
	nop			;3b82
	nop			;3b83
	nop			;3b84
	nop			;3b85
	nop			;3b86
	nop			;3b87
	nop			;3b88
	nop			;3b89
	nop			;3b8a
	nop			;3b8b
	nop			;3b8c
	nop			;3b8d
	nop			;3b8e
	nop			;3b8f
	nop			;3b90
	nop			;3b91
	nop			;3b92
	nop			;3b93
	nop			;3b94
	nop			;3b95
	nop			;3b96
	nop			;3b97
	nop			;3b98
	nop			;3b99
	nop			;3b9a
	nop			;3b9b
	nop			;3b9c
	nop			;3b9d
	nop			;3b9e
	nop			;3b9f
	nop			;3ba0
	nop			;3ba1
	nop			;3ba2
	nop			;3ba3
	nop			;3ba4
	nop			;3ba5
	nop			;3ba6
	nop			;3ba7
	nop			;3ba8
	nop			;3ba9
	nop			;3baa
	nop			;3bab
	nop			;3bac
	nop			;3bad
	nop			;3bae
	nop			;3baf
	nop			;3bb0
	nop			;3bb1
	nop			;3bb2
	nop			;3bb3
	nop			;3bb4
	nop			;3bb5
	nop			;3bb6
	nop			;3bb7
	nop			;3bb8
	nop			;3bb9
	nop			;3bba
	nop			;3bbb
	nop			;3bbc
	nop			;3bbd
	nop			;3bbe
	nop			;3bbf
	nop			;3bc0
	nop			;3bc1
	nop			;3bc2
	nop			;3bc3
	nop			;3bc4
	nop			;3bc5
	nop			;3bc6
	nop			;3bc7
	nop			;3bc8
	nop			;3bc9
	nop			;3bca
	nop			;3bcb
	nop			;3bcc
	nop			;3bcd
	nop			;3bce
	nop			;3bcf
	nop			;3bd0
	nop			;3bd1
	nop			;3bd2
	nop			;3bd3
	nop			;3bd4
	nop			;3bd5
	nop			;3bd6
	nop			;3bd7
	nop			;3bd8
	nop			;3bd9
	nop			;3bda
	nop			;3bdb
	nop			;3bdc
	nop			;3bdd
	nop			;3bde
	nop			;3bdf
	nop			;3be0
	nop			;3be1
	nop			;3be2
	nop			;3be3
	nop			;3be4
	nop			;3be5
	nop			;3be6
	nop			;3be7
	nop			;3be8
	nop			;3be9
	nop			;3bea
	nop			;3beb
	nop			;3bec
	nop			;3bed
	nop			;3bee
	nop			;3bef
	nop			;3bf0
	nop			;3bf1
	nop			;3bf2
	nop			;3bf3
	nop			;3bf4
	nop			;3bf5
	nop			;3bf6
	nop			;3bf7
	nop			;3bf8
	nop			;3bf9
	nop			;3bfa
	nop			;3bfb
	nop			;3bfc
	nop			;3bfd
	nop			;3bfe
	nop			;3bff
	nop			;3c00
	nop			;3c01
	nop			;3c02
	nop			;3c03
	nop			;3c04
	nop			;3c05
	nop			;3c06
	nop			;3c07
	nop			;3c08
	nop			;3c09
	nop			;3c0a
	nop			;3c0b
	nop			;3c0c
	nop			;3c0d
	nop			;3c0e
	nop			;3c0f
	nop			;3c10
	nop			;3c11
	nop			;3c12
	nop			;3c13
	nop			;3c14
	nop			;3c15
	nop			;3c16
	nop			;3c17
	nop			;3c18
	nop			;3c19
	nop			;3c1a
	nop			;3c1b
	nop			;3c1c
	nop			;3c1d
	nop			;3c1e
	nop			;3c1f
	nop			;3c20
	nop			;3c21
	nop			;3c22
	nop			;3c23
	nop			;3c24
	nop			;3c25
	nop			;3c26
	nop			;3c27
	nop			;3c28
	nop			;3c29
	nop			;3c2a
	nop			;3c2b
	nop			;3c2c
	nop			;3c2d
	nop			;3c2e
	nop			;3c2f
	nop			;3c30
	nop			;3c31
	nop			;3c32
	nop			;3c33
	nop			;3c34
	nop			;3c35
	nop			;3c36
	nop			;3c37
	nop			;3c38
	nop			;3c39
	nop			;3c3a
	nop			;3c3b
	nop			;3c3c
	nop			;3c3d
	nop			;3c3e
	nop			;3c3f
	nop			;3c40
	nop			;3c41
	nop			;3c42
	nop			;3c43
	nop			;3c44
	nop			;3c45
	nop			;3c46
	nop			;3c47
	nop			;3c48
	nop			;3c49
	nop			;3c4a
	nop			;3c4b
	nop			;3c4c
	nop			;3c4d
	nop			;3c4e
	nop			;3c4f
	nop			;3c50
	nop			;3c51
	nop			;3c52
	nop			;3c53
	nop			;3c54
	nop			;3c55
	nop			;3c56
	nop			;3c57
	nop			;3c58
	nop			;3c59
	nop			;3c5a
	nop			;3c5b
	nop			;3c5c
	nop			;3c5d
	nop			;3c5e
	nop			;3c5f
	nop			;3c60
	nop			;3c61
	nop			;3c62
	nop			;3c63
	nop			;3c64
	nop			;3c65
	nop			;3c66
	nop			;3c67
	nop			;3c68
	nop			;3c69
	nop			;3c6a
	nop			;3c6b
	nop			;3c6c
	nop			;3c6d
	nop			;3c6e
	nop			;3c6f
	nop			;3c70
	nop			;3c71
	nop			;3c72
	nop			;3c73
	nop			;3c74
	nop			;3c75
	nop			;3c76
	nop			;3c77
	nop			;3c78
	nop			;3c79
	nop			;3c7a
	nop			;3c7b
	nop			;3c7c
	nop			;3c7d
	nop			;3c7e
	nop			;3c7f
	nop			;3c80
	nop			;3c81
	nop			;3c82
	nop			;3c83
	nop			;3c84
	nop			;3c85
	nop			;3c86
	nop			;3c87
	nop			;3c88
	nop			;3c89
	nop			;3c8a
	nop			;3c8b
	nop			;3c8c
	nop			;3c8d
	nop			;3c8e
	nop			;3c8f
	nop			;3c90
	nop			;3c91
	nop			;3c92
	nop			;3c93
	nop			;3c94
	nop			;3c95
	nop			;3c96
	nop			;3c97
	nop			;3c98
	nop			;3c99
	nop			;3c9a
	nop			;3c9b
	nop			;3c9c
	nop			;3c9d
	nop			;3c9e
	nop			;3c9f
	nop			;3ca0
	nop			;3ca1
	nop			;3ca2
	nop			;3ca3
	nop			;3ca4
	nop			;3ca5
	nop			;3ca6
	nop			;3ca7
	nop			;3ca8
	nop			;3ca9
	nop			;3caa
	nop			;3cab
	nop			;3cac
	nop			;3cad
	nop			;3cae
	nop			;3caf
	nop			;3cb0
	nop			;3cb1
	nop			;3cb2
	nop			;3cb3
	nop			;3cb4
	nop			;3cb5
	nop			;3cb6
	nop			;3cb7
	nop			;3cb8
	nop			;3cb9
	nop			;3cba
	nop			;3cbb
	nop			;3cbc
	nop			;3cbd
	nop			;3cbe
	nop			;3cbf
	nop			;3cc0
	nop			;3cc1
	nop			;3cc2
	nop			;3cc3
	nop			;3cc4
	nop			;3cc5
	nop			;3cc6
	nop			;3cc7
	nop			;3cc8
	nop			;3cc9
	nop			;3cca
	nop			;3ccb
	nop			;3ccc
	nop			;3ccd
	nop			;3cce
	nop			;3ccf
	nop			;3cd0
	nop			;3cd1
	nop			;3cd2
	nop			;3cd3
	nop			;3cd4
	nop			;3cd5
	nop			;3cd6
	nop			;3cd7
	nop			;3cd8
	nop			;3cd9
	nop			;3cda
	nop			;3cdb
	nop			;3cdc
	nop			;3cdd
	nop			;3cde
	nop			;3cdf
	nop			;3ce0
	nop			;3ce1
	nop			;3ce2
	nop			;3ce3
	nop			;3ce4
	nop			;3ce5
	nop			;3ce6
	nop			;3ce7
	nop			;3ce8
	nop			;3ce9
	nop			;3cea
	nop			;3ceb
	nop			;3cec
	nop			;3ced
	nop			;3cee
	nop			;3cef
	nop			;3cf0
	nop			;3cf1
	nop			;3cf2
	nop			;3cf3
	nop			;3cf4
	nop			;3cf5
	nop			;3cf6
	nop			;3cf7
	nop			;3cf8
	nop			;3cf9
	nop			;3cfa
	nop			;3cfb
	nop			;3cfc
	nop			;3cfd
	nop			;3cfe
	nop			;3cff
	nop			;3d00
	nop			;3d01
	nop			;3d02
	nop			;3d03
	nop			;3d04
	nop			;3d05
	nop			;3d06
	nop			;3d07
	nop			;3d08
	nop			;3d09
	nop			;3d0a
	nop			;3d0b
	nop			;3d0c
	nop			;3d0d
	nop			;3d0e
	nop			;3d0f
	nop			;3d10
	nop			;3d11
	nop			;3d12
	nop			;3d13
	nop			;3d14
	nop			;3d15
	nop			;3d16
	nop			;3d17
	nop			;3d18
	nop			;3d19
	nop			;3d1a
	nop			;3d1b
	nop			;3d1c
	nop			;3d1d
	nop			;3d1e
	nop			;3d1f
	nop			;3d20
	nop			;3d21
	nop			;3d22
	nop			;3d23
	nop			;3d24
	nop			;3d25
	nop			;3d26
	nop			;3d27
	nop			;3d28
	nop			;3d29
	nop			;3d2a
	nop			;3d2b
	nop			;3d2c
	nop			;3d2d
	nop			;3d2e
	nop			;3d2f
	nop			;3d30
	nop			;3d31
	nop			;3d32
	nop			;3d33
	nop			;3d34
	nop			;3d35
	nop			;3d36
	nop			;3d37
	nop			;3d38
	nop			;3d39
	nop			;3d3a
	nop			;3d3b
	nop			;3d3c
	nop			;3d3d
	nop			;3d3e
	nop			;3d3f
	nop			;3d40
	nop			;3d41
	nop			;3d42
	nop			;3d43
	nop			;3d44
	nop			;3d45
	nop			;3d46
	nop			;3d47
	nop			;3d48
	nop			;3d49
	nop			;3d4a
	nop			;3d4b
	nop			;3d4c
	nop			;3d4d
	nop			;3d4e
	nop			;3d4f
	nop			;3d50
	nop			;3d51
	nop			;3d52
	nop			;3d53
	nop			;3d54
	nop			;3d55
	nop			;3d56
	nop			;3d57
	nop			;3d58
	nop			;3d59
	nop			;3d5a
	nop			;3d5b
	nop			;3d5c
	nop			;3d5d
	nop			;3d5e
	nop			;3d5f
	nop			;3d60
	nop			;3d61
	nop			;3d62
	nop			;3d63
	nop			;3d64
	nop			;3d65
	nop			;3d66
	nop			;3d67
	nop			;3d68
	nop			;3d69
	nop			;3d6a
	nop			;3d6b
	nop			;3d6c
	nop			;3d6d
	nop			;3d6e
	nop			;3d6f
	nop			;3d70
	nop			;3d71
	nop			;3d72
	nop			;3d73
	nop			;3d74
	nop			;3d75
	nop			;3d76
	nop			;3d77
	nop			;3d78
	nop			;3d79
	nop			;3d7a
	nop			;3d7b
	nop			;3d7c
	nop			;3d7d
	nop			;3d7e
	nop			;3d7f
	nop			;3d80
	nop			;3d81
	nop			;3d82
	nop			;3d83
	nop			;3d84
	nop			;3d85
	nop			;3d86
	nop			;3d87
	nop			;3d88
	nop			;3d89
	nop			;3d8a
	nop			;3d8b
	nop			;3d8c
	nop			;3d8d
	nop			;3d8e
	nop			;3d8f
	nop			;3d90
	nop			;3d91
	nop			;3d92
	nop			;3d93
	nop			;3d94
	nop			;3d95
	nop			;3d96
	nop			;3d97
	nop			;3d98
	nop			;3d99
	nop			;3d9a
	nop			;3d9b
	nop			;3d9c
	nop			;3d9d
	nop			;3d9e
	nop			;3d9f
	nop			;3da0
	nop			;3da1
	nop			;3da2
	nop			;3da3
	nop			;3da4
	nop			;3da5
	nop			;3da6
	nop			;3da7
	nop			;3da8
	nop			;3da9
	nop			;3daa
	nop			;3dab
	nop			;3dac
	nop			;3dad
	nop			;3dae
	nop			;3daf
	nop			;3db0
	nop			;3db1
	nop			;3db2
	nop			;3db3
	nop			;3db4
	nop			;3db5
	nop			;3db6
	nop			;3db7
	nop			;3db8
	nop			;3db9
	nop			;3dba
	nop			;3dbb
	nop			;3dbc
	nop			;3dbd
	nop			;3dbe
	nop			;3dbf
	nop			;3dc0
	nop			;3dc1
	nop			;3dc2
	nop			;3dc3
	nop			;3dc4
	nop			;3dc5
	nop			;3dc6
	nop			;3dc7
	nop			;3dc8
	nop			;3dc9
	nop			;3dca
	nop			;3dcb
	nop			;3dcc
	nop			;3dcd
	nop			;3dce
	nop			;3dcf
	nop			;3dd0
	nop			;3dd1
	nop			;3dd2
	nop			;3dd3
	nop			;3dd4
	nop			;3dd5
	nop			;3dd6
	nop			;3dd7
	nop			;3dd8
	nop			;3dd9
	nop			;3dda
	nop			;3ddb
	nop			;3ddc
	nop			;3ddd
	nop			;3dde
	nop			;3ddf
	nop			;3de0
	nop			;3de1
	nop			;3de2
	nop			;3de3
	nop			;3de4
	nop			;3de5
	nop			;3de6
	nop			;3de7
	nop			;3de8
	nop			;3de9
	nop			;3dea
	nop			;3deb
	nop			;3dec
	nop			;3ded
	nop			;3dee
	nop			;3def
	nop			;3df0
	nop			;3df1
	nop			;3df2
	nop			;3df3
	nop			;3df4
	nop			;3df5
	nop			;3df6
	nop			;3df7
	nop			;3df8
	nop			;3df9
	nop			;3dfa
	nop			;3dfb
	nop			;3dfc
	nop			;3dfd
	nop			;3dfe
	nop			;3dff
	nop			;3e00
	nop			;3e01
	nop			;3e02
	nop			;3e03
	nop			;3e04
	nop			;3e05
	nop			;3e06
	nop			;3e07
	nop			;3e08
	nop			;3e09
	nop			;3e0a
	nop			;3e0b
	nop			;3e0c
	nop			;3e0d
	nop			;3e0e
	nop			;3e0f
	nop			;3e10
	nop			;3e11
	nop			;3e12
	nop			;3e13
	nop			;3e14
	nop			;3e15
	nop			;3e16
	nop			;3e17
	nop			;3e18
	nop			;3e19
	nop			;3e1a
	nop			;3e1b
	nop			;3e1c
	nop			;3e1d
	nop			;3e1e
	nop			;3e1f
	nop			;3e20
	nop			;3e21
	nop			;3e22
	nop			;3e23
	nop			;3e24
	nop			;3e25
	nop			;3e26
	nop			;3e27
	nop			;3e28
	nop			;3e29
	nop			;3e2a
	nop			;3e2b
	nop			;3e2c
	nop			;3e2d
	nop			;3e2e
	nop			;3e2f
	nop			;3e30
	nop			;3e31
	nop			;3e32
	nop			;3e33
	nop			;3e34
	nop			;3e35
	nop			;3e36
	nop			;3e37
	nop			;3e38
	nop			;3e39
	nop			;3e3a
	nop			;3e3b
	nop			;3e3c
	nop			;3e3d
	nop			;3e3e
	nop			;3e3f
	nop			;3e40
	nop			;3e41
	nop			;3e42
	nop			;3e43
	nop			;3e44
	nop			;3e45
	nop			;3e46
	nop			;3e47
	nop			;3e48
	nop			;3e49
	nop			;3e4a
	nop			;3e4b
	nop			;3e4c
	nop			;3e4d
	nop			;3e4e
	nop			;3e4f
	nop			;3e50
	nop			;3e51
	nop			;3e52
	nop			;3e53
	nop			;3e54
	nop			;3e55
	nop			;3e56
	nop			;3e57
	nop			;3e58
	nop			;3e59
	nop			;3e5a
	nop			;3e5b
	nop			;3e5c
	nop			;3e5d
	nop			;3e5e
	nop			;3e5f
	nop			;3e60
	nop			;3e61
	nop			;3e62
	nop			;3e63
	nop			;3e64
	nop			;3e65
	nop			;3e66
	nop			;3e67
	nop			;3e68
	nop			;3e69
	nop			;3e6a
	nop			;3e6b
	nop			;3e6c
	nop			;3e6d
	nop			;3e6e
	nop			;3e6f
	nop			;3e70
	nop			;3e71
	nop			;3e72
	nop			;3e73
	nop			;3e74
	nop			;3e75
	nop			;3e76
	nop			;3e77
	nop			;3e78
	nop			;3e79
	nop			;3e7a
	nop			;3e7b
	nop			;3e7c
	nop			;3e7d
	nop			;3e7e
	nop			;3e7f
	nop			;3e80
	nop			;3e81
	nop			;3e82
	nop			;3e83
	nop			;3e84
	nop			;3e85
	nop			;3e86
	nop			;3e87
	nop			;3e88
	nop			;3e89
	nop			;3e8a
	nop			;3e8b
	nop			;3e8c
	nop			;3e8d
	nop			;3e8e
	nop			;3e8f
	nop			;3e90
	nop			;3e91
	nop			;3e92
	nop			;3e93
	nop			;3e94
	nop			;3e95
	nop			;3e96
	nop			;3e97
	nop			;3e98
	nop			;3e99
	nop			;3e9a
	nop			;3e9b
	nop			;3e9c
	nop			;3e9d
	nop			;3e9e
	nop			;3e9f
	nop			;3ea0
	nop			;3ea1
	nop			;3ea2
	nop			;3ea3
	nop			;3ea4
	nop			;3ea5
	nop			;3ea6
	nop			;3ea7
	nop			;3ea8
	nop			;3ea9
	nop			;3eaa
	nop			;3eab
	nop			;3eac
	nop			;3ead
	nop			;3eae
	nop			;3eaf
	nop			;3eb0
	nop			;3eb1
	nop			;3eb2
	nop			;3eb3
	nop			;3eb4
	nop			;3eb5
	nop			;3eb6
	nop			;3eb7
	nop			;3eb8
	nop			;3eb9
	nop			;3eba
	nop			;3ebb
	nop			;3ebc
	nop			;3ebd
	nop			;3ebe
	nop			;3ebf
	nop			;3ec0
	nop			;3ec1
	nop			;3ec2
	nop			;3ec3
	nop			;3ec4
	nop			;3ec5
	nop			;3ec6
	nop			;3ec7
	nop			;3ec8
	nop			;3ec9
	nop			;3eca
	nop			;3ecb
	nop			;3ecc
	nop			;3ecd
	nop			;3ece
	nop			;3ecf
	nop			;3ed0
	nop			;3ed1
	nop			;3ed2
	nop			;3ed3
	nop			;3ed4
	nop			;3ed5
	nop			;3ed6
	nop			;3ed7
	nop			;3ed8
	nop			;3ed9
	nop			;3eda
	nop			;3edb
	nop			;3edc
	nop			;3edd
	nop			;3ede
	nop			;3edf
	nop			;3ee0
	nop			;3ee1
	nop			;3ee2
	nop			;3ee3
	nop			;3ee4
	nop			;3ee5
	nop			;3ee6
	nop			;3ee7
	nop			;3ee8
	nop			;3ee9
	nop			;3eea
	nop			;3eeb
	nop			;3eec
	nop			;3eed
	nop			;3eee
	nop			;3eef
	nop			;3ef0
	nop			;3ef1
	nop			;3ef2
	nop			;3ef3
	nop			;3ef4
	nop			;3ef5
	nop			;3ef6
	nop			;3ef7
	nop			;3ef8
	nop			;3ef9
	nop			;3efa
	nop			;3efb
	nop			;3efc
	nop			;3efd
	nop			;3efe
	nop			;3eff
	nop			;3f00
	nop			;3f01
	nop			;3f02
	nop			;3f03
	nop			;3f04
	nop			;3f05
	nop			;3f06
	nop			;3f07
	nop			;3f08
	nop			;3f09
	nop			;3f0a
	nop			;3f0b
	nop			;3f0c
	nop			;3f0d
	nop			;3f0e
	nop			;3f0f
	nop			;3f10
	nop			;3f11
	nop			;3f12
	nop			;3f13
	nop			;3f14
	nop			;3f15
	nop			;3f16
	nop			;3f17
	nop			;3f18
	nop			;3f19
	nop			;3f1a
	nop			;3f1b
	nop			;3f1c
	nop			;3f1d
	nop			;3f1e
	nop			;3f1f
	nop			;3f20
	nop			;3f21
	nop			;3f22
	nop			;3f23
	nop			;3f24
	nop			;3f25
	nop			;3f26
	nop			;3f27
	nop			;3f28
	nop			;3f29
	nop			;3f2a
	nop			;3f2b
	nop			;3f2c
	nop			;3f2d
	nop			;3f2e
	nop			;3f2f
	nop			;3f30
	nop			;3f31
	nop			;3f32
	nop			;3f33
	nop			;3f34
	nop			;3f35
	nop			;3f36
	nop			;3f37
	nop			;3f38
	nop			;3f39
	nop			;3f3a
	nop			;3f3b
	nop			;3f3c
	nop			;3f3d
	nop			;3f3e
	nop			;3f3f
	nop			;3f40
	nop			;3f41
	nop			;3f42
	nop			;3f43
	nop			;3f44
	nop			;3f45
	nop			;3f46
	nop			;3f47
	nop			;3f48
	nop			;3f49
	nop			;3f4a
	nop			;3f4b
	nop			;3f4c
	nop			;3f4d
	nop			;3f4e
	nop			;3f4f
	nop			;3f50
	nop			;3f51
	nop			;3f52
	nop			;3f53
	nop			;3f54
	nop			;3f55
	nop			;3f56
	nop			;3f57
	nop			;3f58
	nop			;3f59
	nop			;3f5a
	nop			;3f5b
	nop			;3f5c
	nop			;3f5d
	nop			;3f5e
	nop			;3f5f
	nop			;3f60
	nop			;3f61
	nop			;3f62
	nop			;3f63
	nop			;3f64
	nop			;3f65
	nop			;3f66
	nop			;3f67
	nop			;3f68
	nop			;3f69
	nop			;3f6a
	nop			;3f6b
	nop			;3f6c
	nop			;3f6d
	nop			;3f6e
	nop			;3f6f
	nop			;3f70
	nop			;3f71
	nop			;3f72
	nop			;3f73
	nop			;3f74
	nop			;3f75
	nop			;3f76
	nop			;3f77
	nop			;3f78
	nop			;3f79
	nop			;3f7a
	nop			;3f7b
	nop			;3f7c
	nop			;3f7d
	nop			;3f7e
	nop			;3f7f
	nop			;3f80
	nop			;3f81
	nop			;3f82
	nop			;3f83
	nop			;3f84
	nop			;3f85
	nop			;3f86
	nop			;3f87
	nop			;3f88
	nop			;3f89
	nop			;3f8a
	nop			;3f8b
	nop			;3f8c
	nop			;3f8d
	nop			;3f8e
	nop			;3f8f
	nop			;3f90
	nop			;3f91
	nop			;3f92
	nop			;3f93
	nop			;3f94
	nop			;3f95
	nop			;3f96
	nop			;3f97
	nop			;3f98
	nop			;3f99
	nop			;3f9a
	nop			;3f9b
	nop			;3f9c
	nop			;3f9d
	nop			;3f9e
	nop			;3f9f
	nop			;3fa0
	nop			;3fa1
	nop			;3fa2
	nop			;3fa3
	nop			;3fa4
	nop			;3fa5
	nop			;3fa6
	nop			;3fa7
	nop			;3fa8
	nop			;3fa9
	nop			;3faa
	nop			;3fab
	nop			;3fac
	nop			;3fad
	nop			;3fae
	nop			;3faf
	nop			;3fb0
	nop			;3fb1
	nop			;3fb2
	nop			;3fb3
	nop			;3fb4
	nop			;3fb5
	nop			;3fb6
	nop			;3fb7
	nop			;3fb8
	nop			;3fb9
	nop			;3fba
	nop			;3fbb
	nop			;3fbc
	nop			;3fbd
	nop			;3fbe
	nop			;3fbf
	nop			;3fc0
	nop			;3fc1
	nop			;3fc2
	nop			;3fc3
	nop			;3fc4
	nop			;3fc5
	nop			;3fc6
	nop			;3fc7
	nop			;3fc8
	nop			;3fc9
	nop			;3fca
	nop			;3fcb
	nop			;3fcc
	nop			;3fcd
	nop			;3fce
	nop			;3fcf
	nop			;3fd0
	nop			;3fd1
	nop			;3fd2
	nop			;3fd3
	nop			;3fd4
	nop			;3fd5
	nop			;3fd6
	nop			;3fd7
	nop			;3fd8
	nop			;3fd9
	nop			;3fda
	nop			;3fdb
	nop			;3fdc
	nop			;3fdd
	nop			;3fde
	nop			;3fdf
	nop			;3fe0
	nop			;3fe1
	nop			;3fe2
	nop			;3fe3
	nop			;3fe4
	nop			;3fe5
	nop			;3fe6
	nop			;3fe7
	nop			;3fe8
	nop			;3fe9
	nop			;3fea
	nop			;3feb
	nop			;3fec
	nop			;3fed
	nop			;3fee
	nop			;3fef
	nop			;3ff0
	nop			;3ff1
	nop			;3ff2
	nop			;3ff3
	nop			;3ff4
	nop			;3ff5
	nop			;3ff6
	nop			;3ff7
	nop			;3ff8
	nop			;3ff9
	nop			;3ffa
	nop			;3ffb
	nop			;3ffc
	nop			;3ffd
	nop			;3ffe
	nop			;3fff
	nop			;4000
	nop			;4001
	nop			;4002
	nop			;4003
	nop			;4004
	nop			;4005
	nop			;4006
	nop			;4007
	nop			;4008
	nop			;4009
	nop			;400a
	nop			;400b
	nop			;400c
	nop			;400d
	nop			;400e
	nop			;400f
	nop			;4010
	nop			;4011
	nop			;4012
	nop			;4013
	nop			;4014
	nop			;4015
	nop			;4016
	nop			;4017
	nop			;4018
	nop			;4019
	nop			;401a
	nop			;401b
	nop			;401c
	nop			;401d
	nop			;401e
	nop			;401f
	nop			;4020
	nop			;4021
	nop			;4022
	nop			;4023
	nop			;4024
	nop			;4025
	nop			;4026
	nop			;4027
	nop			;4028
	nop			;4029
	nop			;402a
	nop			;402b
	nop			;402c
	nop			;402d
	nop			;402e
	nop			;402f
	nop			;4030
	nop			;4031
	nop			;4032
	nop			;4033
	nop			;4034
	nop			;4035
	nop			;4036
	nop			;4037
	nop			;4038
	nop			;4039
	nop			;403a
	nop			;403b
	nop			;403c
	nop			;403d
	nop			;403e
	nop			;403f
	nop			;4040
	nop			;4041
	nop			;4042
	nop			;4043
	nop			;4044
	nop			;4045
	nop			;4046
	nop			;4047
	nop			;4048
	nop			;4049
	nop			;404a
	nop			;404b
	nop			;404c
	nop			;404d
	nop			;404e
	nop			;404f
	nop			;4050
	nop			;4051
	nop			;4052
	nop			;4053
	nop			;4054
	nop			;4055
	nop			;4056
	nop			;4057
	nop			;4058
	nop			;4059
	nop			;405a
	nop			;405b
	nop			;405c
	nop			;405d
	nop			;405e
	nop			;405f
	nop			;4060
	nop			;4061
	nop			;4062
	nop			;4063
	nop			;4064
	nop			;4065
	nop			;4066
	nop			;4067
	nop			;4068
	nop			;4069
	nop			;406a
	nop			;406b
	nop			;406c
	nop			;406d
	nop			;406e
	nop			;406f
	nop			;4070
	nop			;4071
	nop			;4072
	nop			;4073
	nop			;4074
	nop			;4075
	nop			;4076
	nop			;4077
	nop			;4078
	nop			;4079
	nop			;407a
	nop			;407b
	nop			;407c
	nop			;407d
	nop			;407e
	nop			;407f
	nop			;4080
	nop			;4081
	nop			;4082
	nop			;4083
	nop			;4084
	nop			;4085
	nop			;4086
	nop			;4087
	nop			;4088
	nop			;4089
	nop			;408a
	nop			;408b
	nop			;408c
	nop			;408d
	nop			;408e
	nop			;408f
	nop			;4090
	nop			;4091
	nop			;4092
	nop			;4093
	nop			;4094
	nop			;4095
	nop			;4096
	nop			;4097
	nop			;4098
	nop			;4099
	nop			;409a
	nop			;409b
	nop			;409c
	nop			;409d
	nop			;409e
	nop			;409f
	nop			;40a0
	nop			;40a1
	nop			;40a2
	nop			;40a3
	nop			;40a4
	nop			;40a5
	nop			;40a6
	nop			;40a7
	nop			;40a8
	nop			;40a9
	nop			;40aa
	nop			;40ab
	nop			;40ac
	nop			;40ad
	nop			;40ae
	nop			;40af
	nop			;40b0
	nop			;40b1
	nop			;40b2
	nop			;40b3
	nop			;40b4
	nop			;40b5
	nop			;40b6
	nop			;40b7
	nop			;40b8
	nop			;40b9
	nop			;40ba
	nop			;40bb
	nop			;40bc
	nop			;40bd
	nop			;40be
	nop			;40bf
	nop			;40c0
	nop			;40c1
	nop			;40c2
	nop			;40c3
	nop			;40c4
	nop			;40c5
	nop			;40c6
	nop			;40c7
	nop			;40c8
	nop			;40c9
	nop			;40ca
	nop			;40cb
	nop			;40cc
	nop			;40cd
	nop			;40ce
	nop			;40cf
	nop			;40d0
	nop			;40d1
	nop			;40d2
	nop			;40d3
	nop			;40d4
	nop			;40d5
	nop			;40d6
	nop			;40d7
	nop			;40d8
	nop			;40d9
	nop			;40da
	nop			;40db
	nop			;40dc
	nop			;40dd
	nop			;40de
	nop			;40df
	nop			;40e0
	nop			;40e1
	nop			;40e2
	nop			;40e3
	nop			;40e4
	nop			;40e5
	nop			;40e6
	nop			;40e7
	nop			;40e8
	nop			;40e9
	nop			;40ea
	nop			;40eb
	nop			;40ec
	nop			;40ed
	nop			;40ee
	nop			;40ef
	nop			;40f0
	nop			;40f1
	nop			;40f2
	nop			;40f3
	nop			;40f4
	nop			;40f5
	nop			;40f6
	nop			;40f7
	nop			;40f8
	nop			;40f9
	nop			;40fa
	nop			;40fb
	nop			;40fc
	nop			;40fd
	nop			;40fe
	nop			;40ff
	nop			;4100
	nop			;4101
	nop			;4102
	nop			;4103
	nop			;4104
	nop			;4105
	nop			;4106
	nop			;4107
	nop			;4108
	nop			;4109
	nop			;410a
	nop			;410b
	nop			;410c
	nop			;410d
	nop			;410e
	nop			;410f
	nop			;4110
	nop			;4111
	nop			;4112
	nop			;4113
	nop			;4114
	nop			;4115
	nop			;4116
	nop			;4117
	nop			;4118
	nop			;4119
	nop			;411a
	nop			;411b
	nop			;411c
	nop			;411d
	nop			;411e
	nop			;411f
	nop			;4120
	nop			;4121
	nop			;4122
	nop			;4123
	nop			;4124
	nop			;4125
	nop			;4126
	nop			;4127
	nop			;4128
	nop			;4129
	nop			;412a
	nop			;412b
	nop			;412c
	nop			;412d
	nop			;412e
	nop			;412f
	nop			;4130
	nop			;4131
	nop			;4132
	nop			;4133
	nop			;4134
	nop			;4135
	nop			;4136
	nop			;4137
	nop			;4138
	nop			;4139
	nop			;413a
	nop			;413b
	nop			;413c
	nop			;413d
	nop			;413e
	nop			;413f
	nop			;4140
	nop			;4141
	nop			;4142
	nop			;4143
	nop			;4144
	nop			;4145
	nop			;4146
	nop			;4147
	nop			;4148
	nop			;4149
	nop			;414a
	nop			;414b
	nop			;414c
	nop			;414d
	nop			;414e
	nop			;414f
	nop			;4150
	nop			;4151
	nop			;4152
	nop			;4153
	nop			;4154
	nop			;4155
	nop			;4156
	nop			;4157
	nop			;4158
	nop			;4159
	nop			;415a
	nop			;415b
	nop			;415c
	nop			;415d
	nop			;415e
	nop			;415f
	nop			;4160
	nop			;4161
	nop			;4162
	nop			;4163
	nop			;4164
	nop			;4165
	nop			;4166
	nop			;4167
	nop			;4168
	nop			;4169
	nop			;416a
	nop			;416b
	nop			;416c
	nop			;416d
	nop			;416e
	nop			;416f
	nop			;4170
	nop			;4171
	nop			;4172
	nop			;4173
	nop			;4174
	nop			;4175
	nop			;4176
	nop			;4177
	nop			;4178
	nop			;4179
	nop			;417a
	nop			;417b
	nop			;417c
	nop			;417d
	nop			;417e
	nop			;417f
	nop			;4180
	nop			;4181
	nop			;4182
	nop			;4183
	nop			;4184
	nop			;4185
	nop			;4186
	nop			;4187
	nop			;4188
	nop			;4189
	nop			;418a
	nop			;418b
	nop			;418c
	nop			;418d
	nop			;418e
	nop			;418f
	nop			;4190
	nop			;4191
	nop			;4192
	nop			;4193
	nop			;4194
	nop			;4195
	nop			;4196
	nop			;4197
	nop			;4198
	nop			;4199
	nop			;419a
	nop			;419b
	nop			;419c
	nop			;419d
	nop			;419e
	nop			;419f
	nop			;41a0
	nop			;41a1
	nop			;41a2
	nop			;41a3
	nop			;41a4
	nop			;41a5
	nop			;41a6
	nop			;41a7
	nop			;41a8
	nop			;41a9
	nop			;41aa
	nop			;41ab
	nop			;41ac
	nop			;41ad
	nop			;41ae
	nop			;41af
	nop			;41b0
	nop			;41b1
	nop			;41b2
	nop			;41b3
	nop			;41b4
	nop			;41b5
	nop			;41b6
	nop			;41b7
	nop			;41b8
	nop			;41b9
	nop			;41ba
	nop			;41bb
	nop			;41bc
	nop			;41bd
	nop			;41be
	nop			;41bf
	nop			;41c0
	nop			;41c1
	nop			;41c2
	nop			;41c3
	nop			;41c4
	nop			;41c5
	nop			;41c6
	nop			;41c7
	nop			;41c8
	nop			;41c9
	nop			;41ca
	nop			;41cb
	nop			;41cc
	nop			;41cd
	nop			;41ce
	nop			;41cf
	nop			;41d0
	nop			;41d1
	nop			;41d2
	nop			;41d3
	nop			;41d4
	nop			;41d5
	nop			;41d6
	nop			;41d7
	nop			;41d8
	nop			;41d9
	nop			;41da
	nop			;41db
	nop			;41dc
	nop			;41dd
	nop			;41de
	nop			;41df
	nop			;41e0
	nop			;41e1
	nop			;41e2
	nop			;41e3
	nop			;41e4
	nop			;41e5
	nop			;41e6
	nop			;41e7
	nop			;41e8
	nop			;41e9
	nop			;41ea
	nop			;41eb
	nop			;41ec
	nop			;41ed
	nop			;41ee
	nop			;41ef
	nop			;41f0
	nop			;41f1
	nop			;41f2
	nop			;41f3
	nop			;41f4
	nop			;41f5
	nop			;41f6
	nop			;41f7
	nop			;41f8
	nop			;41f9
	nop			;41fa
	nop			;41fb
	nop			;41fc
	nop			;41fd
	nop			;41fe
	nop			;41ff
	nop			;4200
	nop			;4201
	nop			;4202
	nop			;4203
	nop			;4204
	nop			;4205
	nop			;4206
	nop			;4207
	nop			;4208
	nop			;4209
	nop			;420a
	nop			;420b
	nop			;420c
	nop			;420d
	nop			;420e
	nop			;420f
	nop			;4210
	nop			;4211
	nop			;4212
	nop			;4213
	nop			;4214
	nop			;4215
	nop			;4216
	nop			;4217
	nop			;4218
	nop			;4219
	nop			;421a
	nop			;421b
	nop			;421c
	nop			;421d
	nop			;421e
	nop			;421f
	nop			;4220
	nop			;4221
	nop			;4222
	nop			;4223
	nop			;4224
	nop			;4225
	nop			;4226
	nop			;4227
	nop			;4228
	nop			;4229
	nop			;422a
	nop			;422b
	nop			;422c
	nop			;422d
	nop			;422e
	nop			;422f
	nop			;4230
	nop			;4231
	nop			;4232
	nop			;4233
	nop			;4234
	nop			;4235
	nop			;4236
	nop			;4237
	nop			;4238
	nop			;4239
	nop			;423a
	nop			;423b
	nop			;423c
	nop			;423d
	nop			;423e
	nop			;423f
	nop			;4240
	nop			;4241
	nop			;4242
	nop			;4243
	nop			;4244
	nop			;4245
	nop			;4246
	nop			;4247
	nop			;4248
	nop			;4249
	nop			;424a
	nop			;424b
	nop			;424c
	nop			;424d
	nop			;424e
	nop			;424f
	nop			;4250
	nop			;4251
	nop			;4252
	nop			;4253
	nop			;4254
	nop			;4255
	nop			;4256
	nop			;4257
	nop			;4258
	nop			;4259
	nop			;425a
	nop			;425b
	nop			;425c
	nop			;425d
	nop			;425e
	nop			;425f
	nop			;4260
	nop			;4261
	nop			;4262
	nop			;4263
	nop			;4264
	nop			;4265
	nop			;4266
	nop			;4267
	nop			;4268
	nop			;4269
	nop			;426a
	nop			;426b
	nop			;426c
	nop			;426d
	nop			;426e
	nop			;426f
	nop			;4270
	nop			;4271
	nop			;4272
	nop			;4273
	nop			;4274
	nop			;4275
	nop			;4276
	nop			;4277
	nop			;4278
	nop			;4279
	nop			;427a
	nop			;427b
	nop			;427c
	nop			;427d
	nop			;427e
	nop			;427f
	nop			;4280
	nop			;4281
	nop			;4282
	nop			;4283
	nop			;4284
	nop			;4285
	nop			;4286
	nop			;4287
	nop			;4288
	nop			;4289
	nop			;428a
	nop			;428b
	nop			;428c
	nop			;428d
	nop			;428e
	nop			;428f
	nop			;4290
	nop			;4291
	nop			;4292
	nop			;4293
	nop			;4294
	nop			;4295
	nop			;4296
	nop			;4297
	nop			;4298
	nop			;4299
	nop			;429a
	nop			;429b
	nop			;429c
	nop			;429d
	nop			;429e
	nop			;429f
	nop			;42a0
	nop			;42a1
	nop			;42a2
	nop			;42a3
	nop			;42a4
	nop			;42a5
	nop			;42a6
	nop			;42a7
	nop			;42a8
	nop			;42a9
	nop			;42aa
	nop			;42ab
	nop			;42ac
	nop			;42ad
	nop			;42ae
	nop			;42af
	nop			;42b0
	nop			;42b1
	nop			;42b2
	nop			;42b3
	nop			;42b4
	nop			;42b5
	nop			;42b6
	nop			;42b7
	nop			;42b8
	nop			;42b9
	nop			;42ba
	nop			;42bb
	nop			;42bc
	nop			;42bd
	nop			;42be
	nop			;42bf
	nop			;42c0
	nop			;42c1
	nop			;42c2
	nop			;42c3
	nop			;42c4
	nop			;42c5
	nop			;42c6
	nop			;42c7
	nop			;42c8
	nop			;42c9
	nop			;42ca
	nop			;42cb
	nop			;42cc
	nop			;42cd
	nop			;42ce
	nop			;42cf
	nop			;42d0
	nop			;42d1
	nop			;42d2
	nop			;42d3
	nop			;42d4
	nop			;42d5
	nop			;42d6
	nop			;42d7
	nop			;42d8
	nop			;42d9
	nop			;42da
	nop			;42db
	nop			;42dc
	nop			;42dd
	nop			;42de
	nop			;42df
	nop			;42e0
	nop			;42e1
	nop			;42e2
	nop			;42e3
	nop			;42e4
	nop			;42e5
	nop			;42e6
	nop			;42e7
	nop			;42e8
	nop			;42e9
	nop			;42ea
	nop			;42eb
	nop			;42ec
	nop			;42ed
	nop			;42ee
	nop			;42ef
	nop			;42f0
	nop			;42f1
	nop			;42f2
	nop			;42f3
	nop			;42f4
	nop			;42f5
	nop			;42f6
	nop			;42f7
	nop			;42f8
	nop			;42f9
	nop			;42fa
	nop			;42fb
	nop			;42fc
	nop			;42fd
	nop			;42fe
	nop			;42ff
	nop			;4300
	nop			;4301
	nop			;4302
	nop			;4303
	nop			;4304
	nop			;4305
	nop			;4306
	nop			;4307
	nop			;4308
	nop			;4309
	nop			;430a
	nop			;430b
	nop			;430c
	nop			;430d
	nop			;430e
	nop			;430f
	nop			;4310
	nop			;4311
	nop			;4312
	nop			;4313
	nop			;4314
	nop			;4315
	nop			;4316
	nop			;4317
	nop			;4318
	nop			;4319
	nop			;431a
	nop			;431b
	nop			;431c
	nop			;431d
	nop			;431e
	nop			;431f
	nop			;4320
	nop			;4321
	nop			;4322
	nop			;4323
	nop			;4324
	nop			;4325
	nop			;4326
	nop			;4327
	nop			;4328
	nop			;4329
	nop			;432a
	nop			;432b
	nop			;432c
	nop			;432d
	nop			;432e
	nop			;432f
	nop			;4330
	nop			;4331
	nop			;4332
	nop			;4333
	nop			;4334
	nop			;4335
	nop			;4336
	nop			;4337
	nop			;4338
	nop			;4339
	nop			;433a
	nop			;433b
	nop			;433c
	nop			;433d
	nop			;433e
	nop			;433f
	nop			;4340
	nop			;4341
	nop			;4342
	nop			;4343
	nop			;4344
	nop			;4345
	nop			;4346
	nop			;4347
	nop			;4348
	nop			;4349
	nop			;434a
	nop			;434b
	nop			;434c
	nop			;434d
	nop			;434e
	nop			;434f
	nop			;4350
	nop			;4351
	nop			;4352
	nop			;4353
	nop			;4354
	nop			;4355
	nop			;4356
	nop			;4357
	nop			;4358
	nop			;4359
	nop			;435a
	nop			;435b
	nop			;435c
	nop			;435d
	nop			;435e
	nop			;435f
	nop			;4360
	nop			;4361
	nop			;4362
	nop			;4363
	nop			;4364
	nop			;4365
	nop			;4366
	nop			;4367
	nop			;4368
	nop			;4369
	nop			;436a
	nop			;436b
	nop			;436c
	nop			;436d
	nop			;436e
	nop			;436f
	nop			;4370
	nop			;4371
	nop			;4372
	nop			;4373
	nop			;4374
	nop			;4375
	nop			;4376
	nop			;4377
	nop			;4378
	nop			;4379
	nop			;437a
	nop			;437b
	nop			;437c
	nop			;437d
	nop			;437e
	nop			;437f
	nop			;4380
	nop			;4381
	nop			;4382
	nop			;4383
	nop			;4384
	nop			;4385
	nop			;4386
	nop			;4387
	nop			;4388
	nop			;4389
	nop			;438a
	nop			;438b
	nop			;438c
	nop			;438d
	nop			;438e
	nop			;438f
	nop			;4390
	nop			;4391
	nop			;4392
	nop			;4393
	nop			;4394
	nop			;4395
	nop			;4396
	nop			;4397
	nop			;4398
	nop			;4399
	nop			;439a
	nop			;439b
	nop			;439c
	nop			;439d
	nop			;439e
	nop			;439f
	nop			;43a0
	nop			;43a1
	nop			;43a2
	nop			;43a3
	nop			;43a4
	nop			;43a5
	nop			;43a6
	nop			;43a7
	nop			;43a8
	nop			;43a9
	nop			;43aa
	nop			;43ab
	nop			;43ac
	nop			;43ad
	nop			;43ae
	nop			;43af
	nop			;43b0
	nop			;43b1
	nop			;43b2
	nop			;43b3
	nop			;43b4
	nop			;43b5
	nop			;43b6
	nop			;43b7
	nop			;43b8
	nop			;43b9
	nop			;43ba
	nop			;43bb
	nop			;43bc
	nop			;43bd
	nop			;43be
	nop			;43bf
	nop			;43c0
	nop			;43c1
	nop			;43c2
	nop			;43c3
	nop			;43c4
	nop			;43c5
	nop			;43c6
	nop			;43c7
	nop			;43c8
	nop			;43c9
	nop			;43ca
	nop			;43cb
	nop			;43cc
	nop			;43cd
	nop			;43ce
	nop			;43cf
	nop			;43d0
	nop			;43d1
	nop			;43d2
	nop			;43d3
	nop			;43d4
	nop			;43d5
	nop			;43d6
	nop			;43d7
	nop			;43d8
	nop			;43d9
	nop			;43da
	nop			;43db
	nop			;43dc
	nop			;43dd
	nop			;43de
	nop			;43df
	nop			;43e0
	nop			;43e1
	nop			;43e2
	nop			;43e3
	nop			;43e4
	nop			;43e5
	nop			;43e6
	nop			;43e7
	nop			;43e8
	nop			;43e9
	nop			;43ea
	nop			;43eb
	nop			;43ec
	nop			;43ed
	nop			;43ee
	nop			;43ef
	nop			;43f0
	nop			;43f1
	nop			;43f2
	nop			;43f3
	nop			;43f4
	nop			;43f5
	nop			;43f6
	nop			;43f7
	nop			;43f8
	nop			;43f9
	nop			;43fa
	nop			;43fb
	nop			;43fc
	nop			;43fd
	nop			;43fe
	nop			;43ff
	nop			;4400
	nop			;4401
	nop			;4402
	nop			;4403
	nop			;4404
	nop			;4405
	nop			;4406
	nop			;4407
	nop			;4408
	nop			;4409
	nop			;440a
	nop			;440b
	nop			;440c
	nop			;440d
	nop			;440e
	nop			;440f
	nop			;4410
	nop			;4411
	nop			;4412
	nop			;4413
	nop			;4414
	nop			;4415
	nop			;4416
	nop			;4417
	nop			;4418
	nop			;4419
	nop			;441a
	nop			;441b
	nop			;441c
	nop			;441d
	nop			;441e
	nop			;441f
	nop			;4420
	nop			;4421
	nop			;4422
	nop			;4423
	nop			;4424
	nop			;4425
	nop			;4426
	nop			;4427
	nop			;4428
	nop			;4429
	nop			;442a
	nop			;442b
	nop			;442c
	nop			;442d
	nop			;442e
	nop			;442f
	nop			;4430
	nop			;4431
	nop			;4432
	nop			;4433
	nop			;4434
	nop			;4435
	nop			;4436
	nop			;4437
	nop			;4438
	nop			;4439
	nop			;443a
	nop			;443b
	nop			;443c
	nop			;443d
	nop			;443e
	nop			;443f
	nop			;4440
	nop			;4441
	nop			;4442
	nop			;4443
	nop			;4444
	nop			;4445
	nop			;4446
	nop			;4447
	nop			;4448
	nop			;4449
	nop			;444a
	nop			;444b
	nop			;444c
	nop			;444d
	nop			;444e
	nop			;444f
	nop			;4450
	nop			;4451
	nop			;4452
	nop			;4453
	nop			;4454
	nop			;4455
	nop			;4456
	nop			;4457
	nop			;4458
	nop			;4459
	nop			;445a
	nop			;445b
	nop			;445c
	nop			;445d
	nop			;445e
	nop			;445f
	nop			;4460
	nop			;4461
	nop			;4462
	nop			;4463
	nop			;4464
	nop			;4465
	nop			;4466
	nop			;4467
	nop			;4468
	nop			;4469
	nop			;446a
	nop			;446b
	nop			;446c
	nop			;446d
	nop			;446e
	nop			;446f
	nop			;4470
	nop			;4471
	nop			;4472
	nop			;4473
	nop			;4474
	nop			;4475
	nop			;4476
	nop			;4477
	nop			;4478
	nop			;4479
	nop			;447a
	nop			;447b
	nop			;447c
	nop			;447d
	nop			;447e
	nop			;447f
	nop			;4480
	nop			;4481
	nop			;4482
	nop			;4483
	nop			;4484
	nop			;4485
	nop			;4486
	nop			;4487
	nop			;4488
	nop			;4489
	nop			;448a
	nop			;448b
	nop			;448c
	nop			;448d
	nop			;448e
	nop			;448f
	nop			;4490
	nop			;4491
	nop			;4492
	nop			;4493
	nop			;4494
	nop			;4495
	nop			;4496
	nop			;4497
	nop			;4498
	nop			;4499
	nop			;449a
	nop			;449b
	nop			;449c
	nop			;449d
	nop			;449e
	nop			;449f
	nop			;44a0
	nop			;44a1
	nop			;44a2
	nop			;44a3
	nop			;44a4
	nop			;44a5
	nop			;44a6
	nop			;44a7
	nop			;44a8
	nop			;44a9
	nop			;44aa
	nop			;44ab
	nop			;44ac
	nop			;44ad
	nop			;44ae
	nop			;44af
	nop			;44b0
	nop			;44b1
	nop			;44b2
	nop			;44b3
	nop			;44b4
	nop			;44b5
	nop			;44b6
	nop			;44b7
	nop			;44b8
	nop			;44b9
	nop			;44ba
	nop			;44bb
	nop			;44bc
	nop			;44bd
	nop			;44be
	nop			;44bf
	nop			;44c0
	nop			;44c1
	nop			;44c2
	nop			;44c3
	nop			;44c4
	nop			;44c5
	nop			;44c6
	nop			;44c7
	nop			;44c8
	nop			;44c9
	nop			;44ca
	nop			;44cb
	nop			;44cc
	nop			;44cd
	nop			;44ce
	nop			;44cf
	nop			;44d0
	nop			;44d1
	nop			;44d2
	nop			;44d3
	nop			;44d4
	nop			;44d5
	nop			;44d6
	nop			;44d7
	nop			;44d8
	nop			;44d9
	nop			;44da
	nop			;44db
	nop			;44dc
	nop			;44dd
	nop			;44de
	nop			;44df
	nop			;44e0
	nop			;44e1
	nop			;44e2
	nop			;44e3
	nop			;44e4
	nop			;44e5
	nop			;44e6
	nop			;44e7
	nop			;44e8
	nop			;44e9
	nop			;44ea
	nop			;44eb
	nop			;44ec
	nop			;44ed
	nop			;44ee
	nop			;44ef
	nop			;44f0
	nop			;44f1
	nop			;44f2
	nop			;44f3
	nop			;44f4
	nop			;44f5
	nop			;44f6
	nop			;44f7
	nop			;44f8
	nop			;44f9
	nop			;44fa
	nop			;44fb
	nop			;44fc
	nop			;44fd
	nop			;44fe
	nop			;44ff
	nop			;4500
	nop			;4501
	nop			;4502
	nop			;4503
	nop			;4504
	nop			;4505
	nop			;4506
	nop			;4507
	nop			;4508
	nop			;4509
	nop			;450a
	nop			;450b
	nop			;450c
	nop			;450d
	nop			;450e
	nop			;450f
	nop			;4510
	nop			;4511
	nop			;4512
	nop			;4513
	nop			;4514
	nop			;4515
	nop			;4516
	nop			;4517
	nop			;4518
	nop			;4519
	nop			;451a
	nop			;451b
	nop			;451c
	nop			;451d
	nop			;451e
	nop			;451f
	nop			;4520
	nop			;4521
	nop			;4522
	nop			;4523
	nop			;4524
	nop			;4525
	nop			;4526
	nop			;4527
	nop			;4528
	nop			;4529
	nop			;452a
	nop			;452b
	nop			;452c
	nop			;452d
	nop			;452e
	nop			;452f
	nop			;4530
	nop			;4531
	nop			;4532
	nop			;4533
	nop			;4534
	nop			;4535
	nop			;4536
	nop			;4537
	nop			;4538
	nop			;4539
	nop			;453a
	nop			;453b
	nop			;453c
	nop			;453d
	nop			;453e
	nop			;453f
	nop			;4540
	nop			;4541
	nop			;4542
	nop			;4543
	nop			;4544
	nop			;4545
	nop			;4546
	nop			;4547
	nop			;4548
	nop			;4549
	nop			;454a
	nop			;454b
	nop			;454c
	nop			;454d
	nop			;454e
	nop			;454f
	nop			;4550
	nop			;4551
	nop			;4552
	nop			;4553
	nop			;4554
	nop			;4555
	nop			;4556
	nop			;4557
	nop			;4558
	nop			;4559
	nop			;455a
	nop			;455b
	nop			;455c
	nop			;455d
	nop			;455e
	nop			;455f
	nop			;4560
	nop			;4561
	nop			;4562
	nop			;4563
	nop			;4564
	nop			;4565
	nop			;4566
	nop			;4567
	nop			;4568
	nop			;4569
	nop			;456a
	nop			;456b
	nop			;456c
	nop			;456d
	nop			;456e
	nop			;456f
	nop			;4570
	nop			;4571
	nop			;4572
	nop			;4573
	nop			;4574
	nop			;4575
	nop			;4576
	nop			;4577
	nop			;4578
	nop			;4579
	nop			;457a
	nop			;457b
	nop			;457c
	nop			;457d
	nop			;457e
	nop			;457f
	nop			;4580
	nop			;4581
	nop			;4582
	nop			;4583
	nop			;4584
	nop			;4585
	nop			;4586
	nop			;4587
	nop			;4588
	nop			;4589
	nop			;458a
	nop			;458b
	nop			;458c
	nop			;458d
	nop			;458e
	nop			;458f
	nop			;4590
	nop			;4591
	nop			;4592
	nop			;4593
	nop			;4594
	nop			;4595
	nop			;4596
	nop			;4597
	nop			;4598
	nop			;4599
	nop			;459a
	nop			;459b
	nop			;459c
	nop			;459d
	nop			;459e
	nop			;459f
	nop			;45a0
	nop			;45a1
	nop			;45a2
	nop			;45a3
	nop			;45a4
	nop			;45a5
	nop			;45a6
	nop			;45a7
	nop			;45a8
	nop			;45a9
	nop			;45aa
	nop			;45ab
	nop			;45ac
	nop			;45ad
	nop			;45ae
	nop			;45af
	nop			;45b0
	nop			;45b1
	nop			;45b2
	nop			;45b3
	nop			;45b4
	nop			;45b5
	nop			;45b6
	nop			;45b7
	nop			;45b8
	nop			;45b9
	nop			;45ba
	nop			;45bb
	nop			;45bc
	nop			;45bd
	nop			;45be
	nop			;45bf
	nop			;45c0
	nop			;45c1
	nop			;45c2
	nop			;45c3
	nop			;45c4
	nop			;45c5
	nop			;45c6
	nop			;45c7
	nop			;45c8
	nop			;45c9
	nop			;45ca
	nop			;45cb
	nop			;45cc
	nop			;45cd
	nop			;45ce
	nop			;45cf
	nop			;45d0
	nop			;45d1
	nop			;45d2
	nop			;45d3
	nop			;45d4
	nop			;45d5
	nop			;45d6
	nop			;45d7
	nop			;45d8
	nop			;45d9
	nop			;45da
	nop			;45db
	nop			;45dc
	nop			;45dd
	nop			;45de
	nop			;45df
	nop			;45e0
	nop			;45e1
	nop			;45e2
	nop			;45e3
	nop			;45e4
	nop			;45e5
	nop			;45e6
	nop			;45e7
	nop			;45e8
	nop			;45e9
	nop			;45ea
	nop			;45eb
	nop			;45ec
	nop			;45ed
	nop			;45ee
	nop			;45ef
	nop			;45f0
	nop			;45f1
	nop			;45f2
	nop			;45f3
	nop			;45f4
	nop			;45f5
	nop			;45f6
	nop			;45f7
	nop			;45f8
	nop			;45f9
	nop			;45fa
	nop			;45fb
	nop			;45fc
	nop			;45fd
	nop			;45fe
	nop			;45ff
	nop			;4600
	nop			;4601
	nop			;4602
	nop			;4603
	nop			;4604
	nop			;4605
	nop			;4606
	nop			;4607
	nop			;4608
	nop			;4609
	nop			;460a
	nop			;460b
	nop			;460c
	nop			;460d
	nop			;460e
	nop			;460f
	nop			;4610
	nop			;4611
	nop			;4612
	nop			;4613
	nop			;4614
	nop			;4615
	nop			;4616
	nop			;4617
	nop			;4618
	nop			;4619
	nop			;461a
	nop			;461b
	nop			;461c
	nop			;461d
	nop			;461e
	nop			;461f
	nop			;4620
	nop			;4621
	nop			;4622
	nop			;4623
	nop			;4624
	nop			;4625
	nop			;4626
	nop			;4627
	nop			;4628
	nop			;4629
	nop			;462a
	nop			;462b
	nop			;462c
	nop			;462d
	nop			;462e
	nop			;462f
	nop			;4630
	nop			;4631
	nop			;4632
	nop			;4633
	nop			;4634
	nop			;4635
	nop			;4636
	nop			;4637
	nop			;4638
	nop			;4639
	nop			;463a
	nop			;463b
	nop			;463c
	nop			;463d
	nop			;463e
	nop			;463f
	nop			;4640
	nop			;4641
	nop			;4642
	nop			;4643
	nop			;4644
	nop			;4645
	nop			;4646
	nop			;4647
	nop			;4648
	nop			;4649
	nop			;464a
	nop			;464b
	nop			;464c
	nop			;464d
	nop			;464e
	nop			;464f
	nop			;4650
	nop			;4651
	nop			;4652
	nop			;4653
	nop			;4654
	nop			;4655
	nop			;4656
	nop			;4657
	nop			;4658
	nop			;4659
	nop			;465a
	nop			;465b
	nop			;465c
	nop			;465d
	nop			;465e
	nop			;465f
	nop			;4660
	nop			;4661
	nop			;4662
	nop			;4663
	nop			;4664
	nop			;4665
	nop			;4666
	nop			;4667
	nop			;4668
	nop			;4669
	nop			;466a
	nop			;466b
	nop			;466c
	nop			;466d
	nop			;466e
	nop			;466f
	nop			;4670
	nop			;4671
	nop			;4672
	nop			;4673
	nop			;4674
	nop			;4675
	nop			;4676
	nop			;4677
	nop			;4678
	nop			;4679
	nop			;467a
	nop			;467b
	nop			;467c
	nop			;467d
	nop			;467e
	nop			;467f
	nop			;4680
	nop			;4681
	nop			;4682
	nop			;4683
	nop			;4684
	nop			;4685
	nop			;4686
	nop			;4687
	nop			;4688
	nop			;4689
	nop			;468a
	nop			;468b
	nop			;468c
	nop			;468d
	nop			;468e
	nop			;468f
	nop			;4690
	nop			;4691
	nop			;4692
	nop			;4693
	nop			;4694
	nop			;4695
	nop			;4696
	nop			;4697
	nop			;4698
	nop			;4699
	nop			;469a
	nop			;469b
	nop			;469c
	nop			;469d
	nop			;469e
	nop			;469f
	nop			;46a0
	nop			;46a1
	nop			;46a2
	nop			;46a3
	nop			;46a4
	nop			;46a5
	nop			;46a6
	nop			;46a7
	nop			;46a8
	nop			;46a9
	nop			;46aa
	nop			;46ab
	nop			;46ac
	nop			;46ad
	nop			;46ae
	nop			;46af
	nop			;46b0
	nop			;46b1
	nop			;46b2
	nop			;46b3
	nop			;46b4
	nop			;46b5
	nop			;46b6
	nop			;46b7
	nop			;46b8
	nop			;46b9
	nop			;46ba
	nop			;46bb
	nop			;46bc
	nop			;46bd
	nop			;46be
	nop			;46bf
	nop			;46c0
	nop			;46c1
	nop			;46c2
	nop			;46c3
	nop			;46c4
	nop			;46c5
	nop			;46c6
	nop			;46c7
	nop			;46c8
	nop			;46c9
	nop			;46ca
	nop			;46cb
	nop			;46cc
	nop			;46cd
	nop			;46ce
	nop			;46cf
	nop			;46d0
	nop			;46d1
	nop			;46d2
	nop			;46d3
	nop			;46d4
	nop			;46d5
	nop			;46d6
	nop			;46d7
	nop			;46d8
	nop			;46d9
	nop			;46da
	nop			;46db
	nop			;46dc
	nop			;46dd
	nop			;46de
	nop			;46df
	nop			;46e0
	nop			;46e1
	nop			;46e2
	nop			;46e3
	nop			;46e4
	nop			;46e5
	nop			;46e6
	nop			;46e7
	nop			;46e8
	nop			;46e9
	nop			;46ea
	nop			;46eb
	nop			;46ec
	nop			;46ed
	nop			;46ee
	nop			;46ef
	nop			;46f0
	nop			;46f1
	nop			;46f2
	nop			;46f3
	nop			;46f4
	nop			;46f5
	nop			;46f6
	nop			;46f7
	nop			;46f8
	nop			;46f9
	nop			;46fa
	nop			;46fb
	nop			;46fc
	nop			;46fd
	nop			;46fe
	nop			;46ff
	nop			;4700
	nop			;4701
	nop			;4702
	nop			;4703
	nop			;4704
	nop			;4705
	nop			;4706
	nop			;4707
	nop			;4708
	nop			;4709
	nop			;470a
	nop			;470b
	nop			;470c
	nop			;470d
	nop			;470e
	nop			;470f
	nop			;4710
	nop			;4711
	nop			;4712
	nop			;4713
	nop			;4714
	nop			;4715
	nop			;4716
	nop			;4717
	nop			;4718
	nop			;4719
	nop			;471a
	nop			;471b
	nop			;471c
	nop			;471d
	nop			;471e
	nop			;471f
	nop			;4720
	nop			;4721
	nop			;4722
	nop			;4723
	nop			;4724
	nop			;4725
	nop			;4726
	nop			;4727
	nop			;4728
	nop			;4729
	nop			;472a
	nop			;472b
	nop			;472c
	nop			;472d
	nop			;472e
	nop			;472f
	nop			;4730
	nop			;4731
	nop			;4732
	nop			;4733
	nop			;4734
	nop			;4735
	nop			;4736
	nop			;4737
	nop			;4738
	nop			;4739
	nop			;473a
	nop			;473b
	nop			;473c
	nop			;473d
	nop			;473e
	nop			;473f
	nop			;4740
	nop			;4741
	nop			;4742
	nop			;4743
	nop			;4744
	nop			;4745
	nop			;4746
	nop			;4747
	nop			;4748
	nop			;4749
	nop			;474a
	nop			;474b
	nop			;474c
	nop			;474d
	nop			;474e
	nop			;474f
	nop			;4750
	nop			;4751
	nop			;4752
	nop			;4753
	nop			;4754
	nop			;4755
	nop			;4756
	nop			;4757
	nop			;4758
	nop			;4759
	nop			;475a
	nop			;475b
	nop			;475c
	nop			;475d
	nop			;475e
	nop			;475f
	nop			;4760
	nop			;4761
	nop			;4762
	nop			;4763
	nop			;4764
	nop			;4765
	nop			;4766
	nop			;4767
	nop			;4768
	nop			;4769
	nop			;476a
	nop			;476b
	nop			;476c
	nop			;476d
	nop			;476e
	nop			;476f
	nop			;4770
	nop			;4771
	nop			;4772
	nop			;4773
	nop			;4774
	nop			;4775
	nop			;4776
	nop			;4777
	nop			;4778
	nop			;4779
	nop			;477a
	nop			;477b
	nop			;477c
	nop			;477d
	nop			;477e
	nop			;477f
	nop			;4780
	nop			;4781
	nop			;4782
	nop			;4783
	nop			;4784
	nop			;4785
	nop			;4786
	nop			;4787
	nop			;4788
	nop			;4789
	nop			;478a
	nop			;478b
	nop			;478c
	nop			;478d
	nop			;478e
	nop			;478f
	nop			;4790
	nop			;4791
	nop			;4792
	nop			;4793
	nop			;4794
	nop			;4795
	nop			;4796
	nop			;4797
	nop			;4798
	nop			;4799
	nop			;479a
	nop			;479b
	nop			;479c
	nop			;479d
	nop			;479e
	nop			;479f
	nop			;47a0
	nop			;47a1
	nop			;47a2
	nop			;47a3
	nop			;47a4
	nop			;47a5
	nop			;47a6
	nop			;47a7
	nop			;47a8
	nop			;47a9
	nop			;47aa
	nop			;47ab
	nop			;47ac
	nop			;47ad
	nop			;47ae
	nop			;47af
	nop			;47b0
	nop			;47b1
	nop			;47b2
	nop			;47b3
	nop			;47b4
	nop			;47b5
	nop			;47b6
	nop			;47b7
	nop			;47b8
	nop			;47b9
	nop			;47ba
	nop			;47bb
	nop			;47bc
	nop			;47bd
	nop			;47be
	nop			;47bf
	nop			;47c0
	nop			;47c1
	nop			;47c2
	nop			;47c3
	nop			;47c4
	nop			;47c5
	nop			;47c6
	nop			;47c7
	nop			;47c8
	nop			;47c9
	nop			;47ca
	nop			;47cb
	nop			;47cc
	nop			;47cd
	nop			;47ce
	nop			;47cf
	nop			;47d0
	nop			;47d1
	nop			;47d2
	nop			;47d3
	nop			;47d4
	nop			;47d5
	nop			;47d6
	nop			;47d7
	nop			;47d8
	nop			;47d9
	nop			;47da
	nop			;47db
	nop			;47dc
	nop			;47dd
	nop			;47de
	nop			;47df
	nop			;47e0
	nop			;47e1
	nop			;47e2
	nop			;47e3
	nop			;47e4
	nop			;47e5
	nop			;47e6
	nop			;47e7
	nop			;47e8
	nop			;47e9
	nop			;47ea
	nop			;47eb
	nop			;47ec
	nop			;47ed
	nop			;47ee
	nop			;47ef
	nop			;47f0
	nop			;47f1
	nop			;47f2
	nop			;47f3
	nop			;47f4
	nop			;47f5
	nop			;47f6
	nop			;47f7
	nop			;47f8
	nop			;47f9
	nop			;47fa
	nop			;47fb
	nop			;47fc
	nop			;47fd
	nop			;47fe
	nop			;47ff
	nop			;4800
	nop			;4801
	nop			;4802
	nop			;4803
	nop			;4804
	nop			;4805
	nop			;4806
	nop			;4807
	nop			;4808
	nop			;4809
	nop			;480a
	nop			;480b
	nop			;480c
	nop			;480d
	nop			;480e
	nop			;480f
	nop			;4810
	nop			;4811
	nop			;4812
	nop			;4813
	nop			;4814
	nop			;4815
	nop			;4816
	nop			;4817
	nop			;4818
	nop			;4819
	nop			;481a
	nop			;481b
	nop			;481c
	nop			;481d
	nop			;481e
	nop			;481f
	nop			;4820
	nop			;4821
	nop			;4822
	nop			;4823
	nop			;4824
	nop			;4825
	nop			;4826
	nop			;4827
	nop			;4828
	nop			;4829
	nop			;482a
	nop			;482b
	nop			;482c
	nop			;482d
	nop			;482e
	nop			;482f
	nop			;4830
	nop			;4831
	nop			;4832
	nop			;4833
	nop			;4834
	nop			;4835
	nop			;4836
	nop			;4837
	nop			;4838
	nop			;4839
	nop			;483a
	nop			;483b
	nop			;483c
	nop			;483d
	nop			;483e
	nop			;483f
	nop			;4840
	nop			;4841
	nop			;4842
	nop			;4843
	nop			;4844
	nop			;4845
	nop			;4846
	nop			;4847
	nop			;4848
	nop			;4849
	nop			;484a
	nop			;484b
	nop			;484c
	nop			;484d
	nop			;484e
	nop			;484f
	nop			;4850
	nop			;4851
	nop			;4852
	nop			;4853
	nop			;4854
	nop			;4855
	nop			;4856
	nop			;4857
	nop			;4858
	nop			;4859
	nop			;485a
	nop			;485b
	nop			;485c
	nop			;485d
	nop			;485e
	nop			;485f
	nop			;4860
	nop			;4861
	nop			;4862
	nop			;4863
	nop			;4864
	nop			;4865
	nop			;4866
	nop			;4867
	nop			;4868
	nop			;4869
	nop			;486a
	nop			;486b
	nop			;486c
	nop			;486d
	nop			;486e
	nop			;486f
	nop			;4870
	nop			;4871
	nop			;4872
	nop			;4873
	nop			;4874
	nop			;4875
	nop			;4876
	nop			;4877
	nop			;4878
	nop			;4879
	nop			;487a
	nop			;487b
	nop			;487c
	nop			;487d
	nop			;487e
	nop			;487f
	nop			;4880
	nop			;4881
	nop			;4882
	nop			;4883
	nop			;4884
	nop			;4885
	nop			;4886
	nop			;4887
	nop			;4888
	nop			;4889
	nop			;488a
	nop			;488b
	nop			;488c
	nop			;488d
	nop			;488e
	nop			;488f
	nop			;4890
	nop			;4891
	nop			;4892
	nop			;4893
	nop			;4894
	nop			;4895
	nop			;4896
	nop			;4897
	nop			;4898
	nop			;4899
	nop			;489a
	nop			;489b
	nop			;489c
	nop			;489d
	nop			;489e
	nop			;489f
	nop			;48a0
	nop			;48a1
	nop			;48a2
	nop			;48a3
	nop			;48a4
	nop			;48a5
	nop			;48a6
	nop			;48a7
	nop			;48a8
	nop			;48a9
	nop			;48aa
	nop			;48ab
	nop			;48ac
	nop			;48ad
	nop			;48ae
	nop			;48af
	nop			;48b0
	nop			;48b1
	nop			;48b2
	nop			;48b3
	nop			;48b4
	nop			;48b5
	nop			;48b6
	nop			;48b7
	nop			;48b8
	nop			;48b9
	nop			;48ba
	nop			;48bb
	nop			;48bc
	nop			;48bd
	nop			;48be
	nop			;48bf
	nop			;48c0
	nop			;48c1
	nop			;48c2
	nop			;48c3
	nop			;48c4
	nop			;48c5
	nop			;48c6
	nop			;48c7
	nop			;48c8
	nop			;48c9
	nop			;48ca
	nop			;48cb
	nop			;48cc
	nop			;48cd
	nop			;48ce
	nop			;48cf
	nop			;48d0
	nop			;48d1
	nop			;48d2
	nop			;48d3
	nop			;48d4
	nop			;48d5
	nop			;48d6
	nop			;48d7
	nop			;48d8
	nop			;48d9
	nop			;48da
	nop			;48db
	nop			;48dc
	nop			;48dd
	nop			;48de
	nop			;48df
	nop			;48e0
	nop			;48e1
	nop			;48e2
	nop			;48e3
	nop			;48e4
	nop			;48e5
	nop			;48e6
	nop			;48e7
	nop			;48e8
	nop			;48e9
	nop			;48ea
	nop			;48eb
	nop			;48ec
	nop			;48ed
	nop			;48ee
	nop			;48ef
	nop			;48f0
	nop			;48f1
	nop			;48f2
	nop			;48f3
	nop			;48f4
	nop			;48f5
	nop			;48f6
	nop			;48f7
	nop			;48f8
	nop			;48f9
	nop			;48fa
	nop			;48fb
	nop			;48fc
	nop			;48fd
	nop			;48fe
	nop			;48ff
	nop			;4900
	nop			;4901
	nop			;4902
	nop			;4903
	nop			;4904
	nop			;4905
	nop			;4906
	nop			;4907
	nop			;4908
	nop			;4909
	nop			;490a
	nop			;490b
	nop			;490c
	nop			;490d
	nop			;490e
	nop			;490f
	nop			;4910
	nop			;4911
	nop			;4912
	nop			;4913
	nop			;4914
	nop			;4915
	nop			;4916
	nop			;4917
	nop			;4918
	nop			;4919
	nop			;491a
	nop			;491b
	nop			;491c
	nop			;491d
	nop			;491e
	nop			;491f
	nop			;4920
	nop			;4921
	nop			;4922
	nop			;4923
	nop			;4924
	nop			;4925
	nop			;4926
	nop			;4927
	nop			;4928
	nop			;4929
	nop			;492a
	nop			;492b
	nop			;492c
	nop			;492d
	nop			;492e
	nop			;492f
	nop			;4930
	nop			;4931
	nop			;4932
	nop			;4933
	nop			;4934
	nop			;4935
	nop			;4936
	nop			;4937
	nop			;4938
	nop			;4939
	nop			;493a
	nop			;493b
	nop			;493c
	nop			;493d
	nop			;493e
	nop			;493f
	nop			;4940
	nop			;4941
	nop			;4942
	nop			;4943
	nop			;4944
	nop			;4945
	nop			;4946
	nop			;4947
	nop			;4948
	nop			;4949
	nop			;494a
	nop			;494b
	nop			;494c
	nop			;494d
	nop			;494e
	nop			;494f
	nop			;4950
	nop			;4951
	nop			;4952
	nop			;4953
	nop			;4954
	nop			;4955
	nop			;4956
	nop			;4957
	nop			;4958
	nop			;4959
	nop			;495a
	nop			;495b
	nop			;495c
	nop			;495d
	nop			;495e
	nop			;495f
	nop			;4960
	nop			;4961
	nop			;4962
	nop			;4963
	nop			;4964
	nop			;4965
	nop			;4966
	nop			;4967
	nop			;4968
	nop			;4969
	nop			;496a
	nop			;496b
	nop			;496c
	nop			;496d
	nop			;496e
	nop			;496f
	nop			;4970
	nop			;4971
	nop			;4972
	nop			;4973
	nop			;4974
	nop			;4975
	nop			;4976
	nop			;4977
	nop			;4978
	nop			;4979
	nop			;497a
	nop			;497b
	nop			;497c
	nop			;497d
	nop			;497e
	nop			;497f
	nop			;4980
	nop			;4981
	nop			;4982
	nop			;4983
	nop			;4984
	nop			;4985
	nop			;4986
	nop			;4987
	nop			;4988
	nop			;4989
	nop			;498a
	nop			;498b
	nop			;498c
	nop			;498d
	nop			;498e
	nop			;498f
	nop			;4990
	nop			;4991
	nop			;4992
	nop			;4993
	nop			;4994
	nop			;4995
	nop			;4996
	nop			;4997
	nop			;4998
	nop			;4999
	nop			;499a
	nop			;499b
	nop			;499c
	nop			;499d
	nop			;499e
	nop			;499f
	nop			;49a0
	nop			;49a1
	nop			;49a2
	nop			;49a3
	nop			;49a4
	nop			;49a5
	nop			;49a6
	nop			;49a7
	nop			;49a8
	nop			;49a9
	nop			;49aa
	nop			;49ab
	nop			;49ac
	nop			;49ad
	nop			;49ae
	nop			;49af
	nop			;49b0
	nop			;49b1
	nop			;49b2
	nop			;49b3
	nop			;49b4
	nop			;49b5
	nop			;49b6
	nop			;49b7
	nop			;49b8
	nop			;49b9
	nop			;49ba
	nop			;49bb
	nop			;49bc
	nop			;49bd
	nop			;49be
	nop			;49bf
	nop			;49c0
	nop			;49c1
	nop			;49c2
	nop			;49c3
	nop			;49c4
	nop			;49c5
	nop			;49c6
	nop			;49c7
	nop			;49c8
	nop			;49c9
	nop			;49ca
	nop			;49cb
	nop			;49cc
	nop			;49cd
	nop			;49ce
	nop			;49cf
	nop			;49d0
	nop			;49d1
	nop			;49d2
	nop			;49d3
	nop			;49d4
	nop			;49d5
	nop			;49d6
	nop			;49d7
	nop			;49d8
	nop			;49d9
	nop			;49da
	nop			;49db
	nop			;49dc
	nop			;49dd
	nop			;49de
	nop			;49df
	nop			;49e0
	nop			;49e1
	nop			;49e2
	nop			;49e3
	nop			;49e4
	nop			;49e5
	nop			;49e6
	nop			;49e7
	nop			;49e8
	nop			;49e9
	nop			;49ea
	nop			;49eb
	nop			;49ec
	nop			;49ed
	nop			;49ee
	nop			;49ef
	nop			;49f0
	nop			;49f1
	nop			;49f2
	nop			;49f3
	nop			;49f4
	nop			;49f5
	nop			;49f6
	nop			;49f7
	nop			;49f8
	nop			;49f9
	nop			;49fa
	nop			;49fb
	nop			;49fc
	nop			;49fd
	nop			;49fe
	nop			;49ff
	nop			;4a00
	nop			;4a01
	nop			;4a02
	nop			;4a03
	nop			;4a04
	nop			;4a05
	nop			;4a06
	nop			;4a07
	nop			;4a08
	nop			;4a09
	nop			;4a0a
	nop			;4a0b
	nop			;4a0c
	nop			;4a0d
	nop			;4a0e
	nop			;4a0f
	nop			;4a10
	nop			;4a11
	nop			;4a12
	nop			;4a13
	nop			;4a14
	nop			;4a15
	nop			;4a16
	nop			;4a17
	nop			;4a18
	nop			;4a19
	nop			;4a1a
	nop			;4a1b
	nop			;4a1c
	nop			;4a1d
	nop			;4a1e
	nop			;4a1f
	nop			;4a20
	nop			;4a21
	nop			;4a22
	nop			;4a23
	nop			;4a24
	nop			;4a25
	nop			;4a26
	nop			;4a27
	nop			;4a28
	nop			;4a29
	nop			;4a2a
	nop			;4a2b
	nop			;4a2c
	nop			;4a2d
	nop			;4a2e
	nop			;4a2f
	nop			;4a30
	nop			;4a31
	nop			;4a32
	nop			;4a33
	nop			;4a34
	nop			;4a35
	nop			;4a36
	nop			;4a37
	nop			;4a38
	nop			;4a39
	nop			;4a3a
	nop			;4a3b
	nop			;4a3c
	nop			;4a3d
	nop			;4a3e
	nop			;4a3f
	nop			;4a40
	nop			;4a41
	nop			;4a42
	nop			;4a43
	nop			;4a44
	nop			;4a45
	nop			;4a46
	nop			;4a47
	nop			;4a48
	nop			;4a49
	nop			;4a4a
	nop			;4a4b
	nop			;4a4c
	nop			;4a4d
	nop			;4a4e
	nop			;4a4f
	nop			;4a50
	nop			;4a51
	nop			;4a52
	nop			;4a53
	nop			;4a54
	nop			;4a55
	nop			;4a56
	nop			;4a57
	nop			;4a58
	nop			;4a59
	nop			;4a5a
	nop			;4a5b
	nop			;4a5c
	nop			;4a5d
	nop			;4a5e
	nop			;4a5f
	nop			;4a60
	nop			;4a61
	nop			;4a62
	nop			;4a63
	nop			;4a64
	nop			;4a65
	nop			;4a66
	nop			;4a67
	nop			;4a68
	nop			;4a69
	nop			;4a6a
	nop			;4a6b
	nop			;4a6c
	nop			;4a6d
	nop			;4a6e
	nop			;4a6f
	nop			;4a70
	nop			;4a71
	nop			;4a72
	nop			;4a73
	nop			;4a74
	nop			;4a75
	nop			;4a76
	nop			;4a77
	nop			;4a78
	nop			;4a79
	nop			;4a7a
	nop			;4a7b
	nop			;4a7c
	nop			;4a7d
	nop			;4a7e
	nop			;4a7f
	nop			;4a80
	nop			;4a81
	nop			;4a82
	nop			;4a83
	nop			;4a84
	nop			;4a85
	nop			;4a86
	nop			;4a87
	nop			;4a88
	nop			;4a89
	nop			;4a8a
	nop			;4a8b
	nop			;4a8c
	nop			;4a8d
	nop			;4a8e
	nop			;4a8f
	nop			;4a90
	nop			;4a91
	nop			;4a92
	nop			;4a93
	nop			;4a94
	nop			;4a95
	nop			;4a96
	nop			;4a97
	nop			;4a98
	nop			;4a99
	nop			;4a9a
	nop			;4a9b
	nop			;4a9c
	nop			;4a9d
	nop			;4a9e
	nop			;4a9f
	nop			;4aa0
	nop			;4aa1
	nop			;4aa2
	nop			;4aa3
	nop			;4aa4
	nop			;4aa5
	nop			;4aa6
	nop			;4aa7
	nop			;4aa8
	nop			;4aa9
	nop			;4aaa
	nop			;4aab
	nop			;4aac
	nop			;4aad
	nop			;4aae
	nop			;4aaf
	nop			;4ab0
	nop			;4ab1
	nop			;4ab2
	nop			;4ab3
	nop			;4ab4
	nop			;4ab5
	nop			;4ab6
	nop			;4ab7
	nop			;4ab8
	nop			;4ab9
	nop			;4aba
	nop			;4abb
	nop			;4abc
	nop			;4abd
	nop			;4abe
	nop			;4abf
	nop			;4ac0
	nop			;4ac1
	nop			;4ac2
	nop			;4ac3
	nop			;4ac4
	nop			;4ac5
	nop			;4ac6
	nop			;4ac7
	nop			;4ac8
	nop			;4ac9
	nop			;4aca
	nop			;4acb
	nop			;4acc
	nop			;4acd
	nop			;4ace
	nop			;4acf
	nop			;4ad0
	nop			;4ad1
	nop			;4ad2
	nop			;4ad3
	nop			;4ad4
	nop			;4ad5
	nop			;4ad6
	nop			;4ad7
	nop			;4ad8
	nop			;4ad9
	nop			;4ada
	nop			;4adb
	nop			;4adc
	nop			;4add
	nop			;4ade
	nop			;4adf
	nop			;4ae0
	nop			;4ae1
	nop			;4ae2
	nop			;4ae3
	nop			;4ae4
	nop			;4ae5
	nop			;4ae6
	nop			;4ae7
	nop			;4ae8
	nop			;4ae9
	nop			;4aea
	nop			;4aeb
	nop			;4aec
	nop			;4aed
	nop			;4aee
	nop			;4aef
	nop			;4af0
	nop			;4af1
	nop			;4af2
	nop			;4af3
	nop			;4af4
	nop			;4af5
	nop			;4af6
	nop			;4af7
	nop			;4af8
	nop			;4af9
	nop			;4afa
	nop			;4afb
	nop			;4afc
	nop			;4afd
	nop			;4afe
	nop			;4aff
	nop			;4b00
	nop			;4b01
	nop			;4b02
	nop			;4b03
	nop			;4b04
	nop			;4b05
	nop			;4b06
	nop			;4b07
	nop			;4b08
	nop			;4b09
	nop			;4b0a
	nop			;4b0b
	nop			;4b0c
	nop			;4b0d
	nop			;4b0e
	nop			;4b0f
	nop			;4b10
	nop			;4b11
	nop			;4b12
	nop			;4b13
	nop			;4b14
	nop			;4b15
	nop			;4b16
	nop			;4b17
	nop			;4b18
	nop			;4b19
	nop			;4b1a
	nop			;4b1b
	nop			;4b1c
	nop			;4b1d
	nop			;4b1e
	nop			;4b1f
	nop			;4b20
	nop			;4b21
	nop			;4b22
	nop			;4b23
	nop			;4b24
	nop			;4b25
	nop			;4b26
	nop			;4b27
	nop			;4b28
	nop			;4b29
	nop			;4b2a
	nop			;4b2b
	nop			;4b2c
	nop			;4b2d
	nop			;4b2e
	nop			;4b2f
	nop			;4b30
	nop			;4b31
	nop			;4b32
	nop			;4b33
	nop			;4b34
	nop			;4b35
	nop			;4b36
	nop			;4b37
	nop			;4b38
	nop			;4b39
	nop			;4b3a
	nop			;4b3b
	nop			;4b3c
	nop			;4b3d
	nop			;4b3e
	nop			;4b3f
	nop			;4b40
	nop			;4b41
	nop			;4b42
	nop			;4b43
	nop			;4b44
	nop			;4b45
	nop			;4b46
	nop			;4b47
	nop			;4b48
	nop			;4b49
	nop			;4b4a
	nop			;4b4b
	nop			;4b4c
	nop			;4b4d
	nop			;4b4e
	nop			;4b4f
	nop			;4b50
	nop			;4b51
	nop			;4b52
	nop			;4b53
	nop			;4b54
	nop			;4b55
	nop			;4b56
	nop			;4b57
	nop			;4b58
	nop			;4b59
	nop			;4b5a
	nop			;4b5b
	nop			;4b5c
	nop			;4b5d
	nop			;4b5e
	nop			;4b5f
	nop			;4b60
	nop			;4b61
	nop			;4b62
	nop			;4b63
	nop			;4b64
	nop			;4b65
	nop			;4b66
	nop			;4b67
	nop			;4b68
	nop			;4b69
	nop			;4b6a
	nop			;4b6b
	nop			;4b6c
	nop			;4b6d
	nop			;4b6e
	nop			;4b6f
	nop			;4b70
	nop			;4b71
	nop			;4b72
	nop			;4b73
	nop			;4b74
	nop			;4b75
	nop			;4b76
	nop			;4b77
	nop			;4b78
	nop			;4b79
	nop			;4b7a
	nop			;4b7b
	nop			;4b7c
	nop			;4b7d
	nop			;4b7e
	nop			;4b7f
	nop			;4b80
	nop			;4b81
	nop			;4b82
	nop			;4b83
	nop			;4b84
	nop			;4b85
	nop			;4b86
	nop			;4b87
	nop			;4b88
	nop			;4b89
	nop			;4b8a
	nop			;4b8b
	nop			;4b8c
	nop			;4b8d
	nop			;4b8e
	nop			;4b8f
	nop			;4b90
	nop			;4b91
	nop			;4b92
	nop			;4b93
	nop			;4b94
	nop			;4b95
	nop			;4b96
	nop			;4b97
	nop			;4b98
	nop			;4b99
	nop			;4b9a
	nop			;4b9b
	nop			;4b9c
	nop			;4b9d
	nop			;4b9e
	nop			;4b9f
	nop			;4ba0
	nop			;4ba1
	nop			;4ba2
	nop			;4ba3
	nop			;4ba4
	nop			;4ba5
	nop			;4ba6
	nop			;4ba7
	nop			;4ba8
	nop			;4ba9
	nop			;4baa
	nop			;4bab
	nop			;4bac
	nop			;4bad
	nop			;4bae
	nop			;4baf
	nop			;4bb0
	nop			;4bb1
	nop			;4bb2
	nop			;4bb3
	nop			;4bb4
	nop			;4bb5
	nop			;4bb6
	nop			;4bb7
	nop			;4bb8
	nop			;4bb9
	nop			;4bba
	nop			;4bbb
	nop			;4bbc
	nop			;4bbd
	nop			;4bbe
	nop			;4bbf
	nop			;4bc0
	nop			;4bc1
	nop			;4bc2
	nop			;4bc3
	nop			;4bc4
	nop			;4bc5
	nop			;4bc6
	nop			;4bc7
	nop			;4bc8
	nop			;4bc9
	nop			;4bca
	nop			;4bcb
	nop			;4bcc
	nop			;4bcd
	nop			;4bce
	nop			;4bcf
	nop			;4bd0
	nop			;4bd1
	nop			;4bd2
	nop			;4bd3
	nop			;4bd4
	nop			;4bd5
	nop			;4bd6
	nop			;4bd7
	nop			;4bd8
	nop			;4bd9
	nop			;4bda
	nop			;4bdb
	nop			;4bdc
	nop			;4bdd
	nop			;4bde
	nop			;4bdf
	nop			;4be0
	nop			;4be1
	nop			;4be2
	nop			;4be3
	nop			;4be4
	nop			;4be5
	nop			;4be6
	nop			;4be7
	nop			;4be8
	nop			;4be9
	nop			;4bea
	nop			;4beb
	nop			;4bec
	nop			;4bed
	nop			;4bee
	nop			;4bef
	nop			;4bf0
	nop			;4bf1
	nop			;4bf2
	nop			;4bf3
	nop			;4bf4
	nop			;4bf5
	nop			;4bf6
	nop			;4bf7
	nop			;4bf8
	nop			;4bf9
	nop			;4bfa
	nop			;4bfb
	nop			;4bfc
	nop			;4bfd
	nop			;4bfe
	nop			;4bff
	nop			;4c00
	nop			;4c01
	nop			;4c02
	nop			;4c03
	nop			;4c04
	nop			;4c05
	nop			;4c06
	nop			;4c07
	nop			;4c08
	nop			;4c09
	nop			;4c0a
	nop			;4c0b
	nop			;4c0c
	nop			;4c0d
	nop			;4c0e
	nop			;4c0f
	nop			;4c10
	nop			;4c11
	nop			;4c12
	nop			;4c13
	nop			;4c14
	nop			;4c15
	nop			;4c16
	nop			;4c17
	nop			;4c18
	nop			;4c19
	nop			;4c1a
	nop			;4c1b
	nop			;4c1c
	nop			;4c1d
	nop			;4c1e
	nop			;4c1f
	nop			;4c20
	nop			;4c21
	nop			;4c22
	nop			;4c23
	nop			;4c24
	nop			;4c25
	nop			;4c26
	nop			;4c27
	nop			;4c28
	nop			;4c29
	nop			;4c2a
	nop			;4c2b
	nop			;4c2c
	nop			;4c2d
	nop			;4c2e
	nop			;4c2f
	nop			;4c30
	nop			;4c31
	nop			;4c32
	nop			;4c33
	nop			;4c34
	nop			;4c35
	nop			;4c36
	nop			;4c37
	nop			;4c38
	nop			;4c39
	nop			;4c3a
	nop			;4c3b
	nop			;4c3c
	nop			;4c3d
	nop			;4c3e
	nop			;4c3f
	nop			;4c40
	nop			;4c41
	nop			;4c42
	nop			;4c43
	nop			;4c44
	nop			;4c45
	nop			;4c46
	nop			;4c47
	nop			;4c48
	nop			;4c49
	nop			;4c4a
	nop			;4c4b
	nop			;4c4c
	nop			;4c4d
	nop			;4c4e
	nop			;4c4f
	nop			;4c50
	nop			;4c51
	nop			;4c52
	nop			;4c53
	nop			;4c54
	nop			;4c55
	nop			;4c56
	nop			;4c57
	nop			;4c58
	nop			;4c59
	nop			;4c5a
	nop			;4c5b
	nop			;4c5c
	nop			;4c5d
	nop			;4c5e
	nop			;4c5f
	nop			;4c60
	nop			;4c61
	nop			;4c62
	nop			;4c63
	nop			;4c64
	nop			;4c65
	nop			;4c66
	nop			;4c67
	nop			;4c68
	nop			;4c69
	nop			;4c6a
	nop			;4c6b
	nop			;4c6c
	nop			;4c6d
	nop			;4c6e
	nop			;4c6f
	nop			;4c70
	nop			;4c71
	nop			;4c72
	nop			;4c73
	nop			;4c74
	nop			;4c75
	nop			;4c76
	nop			;4c77
	nop			;4c78
	nop			;4c79
	nop			;4c7a
	nop			;4c7b
	nop			;4c7c
	nop			;4c7d
	nop			;4c7e
	nop			;4c7f
	nop			;4c80
	nop			;4c81
	nop			;4c82
	nop			;4c83
	nop			;4c84
	nop			;4c85
	nop			;4c86
	nop			;4c87
	nop			;4c88
	nop			;4c89
	nop			;4c8a
	nop			;4c8b
	nop			;4c8c
	nop			;4c8d
	nop			;4c8e
	nop			;4c8f
	nop			;4c90
	nop			;4c91
	nop			;4c92
	nop			;4c93
	nop			;4c94
	nop			;4c95
	nop			;4c96
	nop			;4c97
	nop			;4c98
	nop			;4c99
	nop			;4c9a
	nop			;4c9b
	nop			;4c9c
	nop			;4c9d
	nop			;4c9e
	nop			;4c9f
	nop			;4ca0
	nop			;4ca1
	nop			;4ca2
	nop			;4ca3
	nop			;4ca4
	nop			;4ca5
	nop			;4ca6
	nop			;4ca7
	nop			;4ca8
	nop			;4ca9
	nop			;4caa
	nop			;4cab
	nop			;4cac
	nop			;4cad
	nop			;4cae
	nop			;4caf
	nop			;4cb0
	nop			;4cb1
	nop			;4cb2
	nop			;4cb3
	nop			;4cb4
	nop			;4cb5
	nop			;4cb6
	nop			;4cb7
	nop			;4cb8
	nop			;4cb9
	nop			;4cba
	nop			;4cbb
	nop			;4cbc
	nop			;4cbd
	nop			;4cbe
	nop			;4cbf
	nop			;4cc0
	nop			;4cc1
	nop			;4cc2
	nop			;4cc3
	nop			;4cc4
	nop			;4cc5
	nop			;4cc6
	nop			;4cc7
	nop			;4cc8
	nop			;4cc9
	nop			;4cca
	nop			;4ccb
	nop			;4ccc
	nop			;4ccd
	nop			;4cce
	nop			;4ccf
	nop			;4cd0
	nop			;4cd1
	nop			;4cd2
	nop			;4cd3
	nop			;4cd4
	nop			;4cd5
	nop			;4cd6
	nop			;4cd7
	nop			;4cd8
	nop			;4cd9
	nop			;4cda
	nop			;4cdb
	nop			;4cdc
	nop			;4cdd
	nop			;4cde
	nop			;4cdf
	nop			;4ce0
	nop			;4ce1
	nop			;4ce2
	nop			;4ce3
	nop			;4ce4
	nop			;4ce5
	nop			;4ce6
	nop			;4ce7
	nop			;4ce8
	nop			;4ce9
	nop			;4cea
	nop			;4ceb
	nop			;4cec
	nop			;4ced
	nop			;4cee
	nop			;4cef
	nop			;4cf0
	nop			;4cf1
	nop			;4cf2
	nop			;4cf3
	nop			;4cf4
	nop			;4cf5
	nop			;4cf6
	nop			;4cf7
	nop			;4cf8
	nop			;4cf9
	nop			;4cfa
	nop			;4cfb
	nop			;4cfc
	nop			;4cfd
	nop			;4cfe
	nop			;4cff
	nop			;4d00
	nop			;4d01
	nop			;4d02
	nop			;4d03
	nop			;4d04
	nop			;4d05
	nop			;4d06
	nop			;4d07
	nop			;4d08
	nop			;4d09
	nop			;4d0a
	nop			;4d0b
	nop			;4d0c
	nop			;4d0d
	nop			;4d0e
	nop			;4d0f
	nop			;4d10
	nop			;4d11
	nop			;4d12
	nop			;4d13
	nop			;4d14
	nop			;4d15
	nop			;4d16
	nop			;4d17
	nop			;4d18
	nop			;4d19
	nop			;4d1a
	nop			;4d1b
	nop			;4d1c
	nop			;4d1d
	nop			;4d1e
	nop			;4d1f
	nop			;4d20
	nop			;4d21
	nop			;4d22
	nop			;4d23
	nop			;4d24
	nop			;4d25
	nop			;4d26
	nop			;4d27
	nop			;4d28
	nop			;4d29
	nop			;4d2a
	nop			;4d2b
	nop			;4d2c
	nop			;4d2d
	nop			;4d2e
	nop			;4d2f
	nop			;4d30
	nop			;4d31
	nop			;4d32
	nop			;4d33
	nop			;4d34
	nop			;4d35
	nop			;4d36
	nop			;4d37
	nop			;4d38
	nop			;4d39
	nop			;4d3a
	nop			;4d3b
	nop			;4d3c
	nop			;4d3d
	nop			;4d3e
	nop			;4d3f
	nop			;4d40
	nop			;4d41
	nop			;4d42
	nop			;4d43
	nop			;4d44
	nop			;4d45
	nop			;4d46
	nop			;4d47
	nop			;4d48
	nop			;4d49
	nop			;4d4a
	nop			;4d4b
	nop			;4d4c
	nop			;4d4d
	nop			;4d4e
	nop			;4d4f
	nop			;4d50
	nop			;4d51
	nop			;4d52
	nop			;4d53
	nop			;4d54
	nop			;4d55
	nop			;4d56
	nop			;4d57
	nop			;4d58
	nop			;4d59
	nop			;4d5a
	nop			;4d5b
	nop			;4d5c
	nop			;4d5d
	nop			;4d5e
	nop			;4d5f
	nop			;4d60
	nop			;4d61
	nop			;4d62
	nop			;4d63
	nop			;4d64
	nop			;4d65
	nop			;4d66
	nop			;4d67
	nop			;4d68
	nop			;4d69
	nop			;4d6a
	nop			;4d6b
	nop			;4d6c
	nop			;4d6d
	nop			;4d6e
	nop			;4d6f
	nop			;4d70
	nop			;4d71
	nop			;4d72
	nop			;4d73
	nop			;4d74
	nop			;4d75
	nop			;4d76
	nop			;4d77
	nop			;4d78
	nop			;4d79
	nop			;4d7a
	nop			;4d7b
	nop			;4d7c
	nop			;4d7d
	nop			;4d7e
	nop			;4d7f
	nop			;4d80
	nop			;4d81
	nop			;4d82
	nop			;4d83
	nop			;4d84
	nop			;4d85
	nop			;4d86
	nop			;4d87
	nop			;4d88
	nop			;4d89
	nop			;4d8a
	nop			;4d8b
	nop			;4d8c
	nop			;4d8d
	nop			;4d8e
	nop			;4d8f
	nop			;4d90
	nop			;4d91
	nop			;4d92
	nop			;4d93
	nop			;4d94
	nop			;4d95
	nop			;4d96
	nop			;4d97
	nop			;4d98
	nop			;4d99
	nop			;4d9a
	nop			;4d9b
	nop			;4d9c
	nop			;4d9d
	nop			;4d9e
	nop			;4d9f
	nop			;4da0
	nop			;4da1
	nop			;4da2
	nop			;4da3
	nop			;4da4
	nop			;4da5
	nop			;4da6
	nop			;4da7
	nop			;4da8
	nop			;4da9
	nop			;4daa
	nop			;4dab
	nop			;4dac
	nop			;4dad
	nop			;4dae
	nop			;4daf
	nop			;4db0
	nop			;4db1
	nop			;4db2
	nop			;4db3
	nop			;4db4
	nop			;4db5
	nop			;4db6
	nop			;4db7
	nop			;4db8
	nop			;4db9
	nop			;4dba
	nop			;4dbb
	nop			;4dbc
	nop			;4dbd
	nop			;4dbe
	nop			;4dbf
	nop			;4dc0
	nop			;4dc1
	nop			;4dc2
	nop			;4dc3
	nop			;4dc4
	nop			;4dc5
	nop			;4dc6
	nop			;4dc7
	nop			;4dc8
	nop			;4dc9
	nop			;4dca
	nop			;4dcb
	nop			;4dcc
	nop			;4dcd
	nop			;4dce
	nop			;4dcf
	nop			;4dd0
	nop			;4dd1
	nop			;4dd2
	nop			;4dd3
	nop			;4dd4
	nop			;4dd5
	nop			;4dd6
	nop			;4dd7
	nop			;4dd8
	nop			;4dd9
	nop			;4dda
	nop			;4ddb
	nop			;4ddc
	nop			;4ddd
	nop			;4dde
	nop			;4ddf
	nop			;4de0
	nop			;4de1
	nop			;4de2
	nop			;4de3
	nop			;4de4
	nop			;4de5
	nop			;4de6
	nop			;4de7
	nop			;4de8
	nop			;4de9
	nop			;4dea
	nop			;4deb
	nop			;4dec
	nop			;4ded
	nop			;4dee
	nop			;4def
	nop			;4df0
	nop			;4df1
	nop			;4df2
	nop			;4df3
	nop			;4df4
	nop			;4df5
	nop			;4df6
	nop			;4df7
	nop			;4df8
	nop			;4df9
	nop			;4dfa
	nop			;4dfb
	nop			;4dfc
	nop			;4dfd
	nop			;4dfe
	nop			;4dff
	nop			;4e00
	nop			;4e01
	nop			;4e02
	nop			;4e03
	nop			;4e04
	nop			;4e05
	nop			;4e06
	nop			;4e07
	nop			;4e08
	nop			;4e09
	nop			;4e0a
	nop			;4e0b
	nop			;4e0c
	nop			;4e0d
	nop			;4e0e
	nop			;4e0f
	nop			;4e10
	nop			;4e11
	nop			;4e12
	nop			;4e13
	nop			;4e14
	nop			;4e15
	nop			;4e16
	nop			;4e17
	nop			;4e18
	nop			;4e19
	nop			;4e1a
	nop			;4e1b
	nop			;4e1c
	nop			;4e1d
	nop			;4e1e
	nop			;4e1f
	nop			;4e20
	nop			;4e21
	nop			;4e22
	nop			;4e23
	nop			;4e24
	nop			;4e25
	nop			;4e26
	nop			;4e27
	nop			;4e28
	nop			;4e29
	nop			;4e2a
	nop			;4e2b
	nop			;4e2c
	nop			;4e2d
	nop			;4e2e
	nop			;4e2f
	nop			;4e30
	nop			;4e31
	nop			;4e32
	nop			;4e33
	nop			;4e34
	nop			;4e35
	nop			;4e36
	nop			;4e37
	nop			;4e38
	nop			;4e39
	nop			;4e3a
	nop			;4e3b
	nop			;4e3c
	nop			;4e3d
	nop			;4e3e
	nop			;4e3f
	nop			;4e40
	nop			;4e41
	nop			;4e42
	nop			;4e43
	nop			;4e44
	nop			;4e45
	nop			;4e46
	nop			;4e47
	nop			;4e48
	nop			;4e49
	nop			;4e4a
	nop			;4e4b
	nop			;4e4c
	nop			;4e4d
	nop			;4e4e
	nop			;4e4f
	nop			;4e50
	nop			;4e51
	nop			;4e52
	nop			;4e53
	nop			;4e54
	nop			;4e55
	nop			;4e56
	nop			;4e57
	nop			;4e58
	nop			;4e59
	nop			;4e5a
	nop			;4e5b
	nop			;4e5c
	nop			;4e5d
	nop			;4e5e
	nop			;4e5f
	nop			;4e60
	nop			;4e61
	nop			;4e62
	nop			;4e63
	nop			;4e64
	nop			;4e65
	nop			;4e66
	nop			;4e67
	nop			;4e68
	nop			;4e69
	nop			;4e6a
	nop			;4e6b
	nop			;4e6c
	nop			;4e6d
	nop			;4e6e
	nop			;4e6f
	nop			;4e70
	nop			;4e71
	nop			;4e72
	nop			;4e73
	nop			;4e74
	nop			;4e75
	nop			;4e76
	nop			;4e77
	nop			;4e78
	nop			;4e79
	nop			;4e7a
	nop			;4e7b
	nop			;4e7c
	nop			;4e7d
	nop			;4e7e
	nop			;4e7f
	nop			;4e80
	nop			;4e81
	nop			;4e82
	nop			;4e83
	nop			;4e84
	nop			;4e85
	nop			;4e86
	nop			;4e87
	nop			;4e88
	nop			;4e89
	nop			;4e8a
	nop			;4e8b
	nop			;4e8c
	nop			;4e8d
	nop			;4e8e
	nop			;4e8f
	nop			;4e90
	nop			;4e91
	nop			;4e92
	nop			;4e93
	nop			;4e94
	nop			;4e95
	nop			;4e96
	nop			;4e97
	nop			;4e98
	nop			;4e99
	nop			;4e9a
	nop			;4e9b
	nop			;4e9c
	nop			;4e9d
	nop			;4e9e
	nop			;4e9f
	nop			;4ea0
	nop			;4ea1
	nop			;4ea2
	nop			;4ea3
	nop			;4ea4
	nop			;4ea5
	nop			;4ea6
	nop			;4ea7
	nop			;4ea8
	nop			;4ea9
	nop			;4eaa
	nop			;4eab
	nop			;4eac
	nop			;4ead
	nop			;4eae
	nop			;4eaf
	nop			;4eb0
	nop			;4eb1
	nop			;4eb2
	nop			;4eb3
	nop			;4eb4
	nop			;4eb5
	nop			;4eb6
	nop			;4eb7
	nop			;4eb8
	nop			;4eb9
	nop			;4eba
	nop			;4ebb
	nop			;4ebc
	nop			;4ebd
	nop			;4ebe
	nop			;4ebf
	nop			;4ec0
	nop			;4ec1
	nop			;4ec2
	nop			;4ec3
	nop			;4ec4
	nop			;4ec5
	nop			;4ec6
	nop			;4ec7
	nop			;4ec8
	nop			;4ec9
	nop			;4eca
	nop			;4ecb
	nop			;4ecc
	nop			;4ecd
	nop			;4ece
	nop			;4ecf
	nop			;4ed0
	nop			;4ed1
	nop			;4ed2
	nop			;4ed3
	nop			;4ed4
	nop			;4ed5
	nop			;4ed6
	nop			;4ed7
	nop			;4ed8
	nop			;4ed9
	nop			;4eda
	nop			;4edb
	nop			;4edc
	nop			;4edd
	nop			;4ede
	nop			;4edf
	nop			;4ee0
	nop			;4ee1
	nop			;4ee2
	nop			;4ee3
	nop			;4ee4
	nop			;4ee5
	nop			;4ee6
	nop			;4ee7
	nop			;4ee8
	nop			;4ee9
	nop			;4eea
	nop			;4eeb
	nop			;4eec
	nop			;4eed
	nop			;4eee
	nop			;4eef
	nop			;4ef0
	nop			;4ef1
	nop			;4ef2
	nop			;4ef3
	nop			;4ef4
	nop			;4ef5
	nop			;4ef6
	nop			;4ef7
	nop			;4ef8
	nop			;4ef9
	nop			;4efa
	nop			;4efb
	nop			;4efc
	nop			;4efd
	nop			;4efe
	nop			;4eff
	nop			;4f00
	nop			;4f01
	nop			;4f02
	nop			;4f03
	nop			;4f04
	nop			;4f05
	nop			;4f06
	nop			;4f07
	nop			;4f08
	nop			;4f09
	nop			;4f0a
	nop			;4f0b
	nop			;4f0c
	nop			;4f0d
	nop			;4f0e
	nop			;4f0f
	nop			;4f10
	nop			;4f11
	nop			;4f12
	nop			;4f13
	nop			;4f14
	nop			;4f15
	nop			;4f16
	nop			;4f17
	nop			;4f18
	nop			;4f19
	nop			;4f1a
	nop			;4f1b
	nop			;4f1c
	nop			;4f1d
	nop			;4f1e
	nop			;4f1f
	nop			;4f20
	nop			;4f21
	nop			;4f22
	nop			;4f23
	nop			;4f24
	nop			;4f25
	nop			;4f26
	nop			;4f27
	nop			;4f28
	nop			;4f29
	nop			;4f2a
	nop			;4f2b
	nop			;4f2c
	nop			;4f2d
	nop			;4f2e
	nop			;4f2f
	nop			;4f30
	nop			;4f31
	nop			;4f32
	nop			;4f33
	nop			;4f34
	nop			;4f35
	nop			;4f36
	nop			;4f37
	nop			;4f38
	nop			;4f39
	nop			;4f3a
	nop			;4f3b
	nop			;4f3c
	nop			;4f3d
	nop			;4f3e
	nop			;4f3f
	nop			;4f40
	nop			;4f41
	nop			;4f42
	nop			;4f43
	nop			;4f44
	nop			;4f45
	nop			;4f46
	nop			;4f47
	nop			;4f48
	nop			;4f49
	nop			;4f4a
	nop			;4f4b
	nop			;4f4c
	nop			;4f4d
	nop			;4f4e
	nop			;4f4f
	nop			;4f50
	nop			;4f51
	nop			;4f52
	nop			;4f53
	nop			;4f54
	nop			;4f55
	nop			;4f56
	nop			;4f57
	nop			;4f58
	nop			;4f59
	nop			;4f5a
	nop			;4f5b
	nop			;4f5c
	nop			;4f5d
	nop			;4f5e
	nop			;4f5f
	nop			;4f60
	nop			;4f61
	nop			;4f62
	nop			;4f63
	nop			;4f64
	nop			;4f65
	nop			;4f66
	nop			;4f67
	nop			;4f68
	nop			;4f69
	nop			;4f6a
	nop			;4f6b
	nop			;4f6c
	nop			;4f6d
	nop			;4f6e
	nop			;4f6f
	nop			;4f70
	nop			;4f71
	nop			;4f72
	nop			;4f73
	nop			;4f74
	nop			;4f75
	nop			;4f76
	nop			;4f77
	nop			;4f78
	nop			;4f79
	nop			;4f7a
	nop			;4f7b
	nop			;4f7c
	nop			;4f7d
	nop			;4f7e
	nop			;4f7f
	nop			;4f80
	nop			;4f81
	nop			;4f82
	nop			;4f83
	nop			;4f84
	nop			;4f85
	nop			;4f86
	nop			;4f87
	nop			;4f88
	nop			;4f89
	nop			;4f8a
	nop			;4f8b
	nop			;4f8c
	nop			;4f8d
	nop			;4f8e
	nop			;4f8f
	nop			;4f90
	nop			;4f91
	nop			;4f92
	nop			;4f93
	nop			;4f94
	nop			;4f95
	nop			;4f96
	nop			;4f97
	nop			;4f98
	nop			;4f99
	nop			;4f9a
	nop			;4f9b
	nop			;4f9c
	nop			;4f9d
	nop			;4f9e
	nop			;4f9f
	nop			;4fa0
	nop			;4fa1
	nop			;4fa2
	nop			;4fa3
	nop			;4fa4
	nop			;4fa5
	nop			;4fa6
	nop			;4fa7
	nop			;4fa8
	nop			;4fa9
	nop			;4faa
	nop			;4fab
	nop			;4fac
	nop			;4fad
	nop			;4fae
	nop			;4faf
	nop			;4fb0
	nop			;4fb1
	nop			;4fb2
	nop			;4fb3
	nop			;4fb4
	nop			;4fb5
	nop			;4fb6
	nop			;4fb7
	nop			;4fb8
	nop			;4fb9
	nop			;4fba
	nop			;4fbb
	nop			;4fbc
	nop			;4fbd
	nop			;4fbe
	nop			;4fbf
	nop			;4fc0
	nop			;4fc1
	nop			;4fc2
	nop			;4fc3
	nop			;4fc4
	nop			;4fc5
	nop			;4fc6
	nop			;4fc7
	nop			;4fc8
	nop			;4fc9
	nop			;4fca
	nop			;4fcb
	nop			;4fcc
	nop			;4fcd
	nop			;4fce
	nop			;4fcf
	nop			;4fd0
	nop			;4fd1
	nop			;4fd2
	nop			;4fd3
	nop			;4fd4
	nop			;4fd5
	nop			;4fd6
	nop			;4fd7
	nop			;4fd8
	nop			;4fd9
	nop			;4fda
	nop			;4fdb
	nop			;4fdc
	nop			;4fdd
	nop			;4fde
	nop			;4fdf
	nop			;4fe0
	nop			;4fe1
	nop			;4fe2
	nop			;4fe3
	nop			;4fe4
	nop			;4fe5
	nop			;4fe6
	nop			;4fe7
	nop			;4fe8
	nop			;4fe9
	nop			;4fea
	nop			;4feb
	nop			;4fec
	nop			;4fed
	nop			;4fee
	nop			;4fef
	nop			;4ff0
	nop			;4ff1
	nop			;4ff2
	nop			;4ff3
	nop			;4ff4
	nop			;4ff5
	nop			;4ff6
	nop			;4ff7
	nop			;4ff8
	nop			;4ff9
	nop			;4ffa
	nop			;4ffb
	nop			;4ffc
	nop			;4ffd
	nop			;4ffe
	nop			;4fff
	nop			;5000
	nop			;5001
	nop			;5002
	nop			;5003
	nop			;5004
	nop			;5005
	nop			;5006
	nop			;5007
	nop			;5008
	nop			;5009
	nop			;500a
	nop			;500b
	nop			;500c
	nop			;500d
	nop			;500e
	nop			;500f
	nop			;5010
	nop			;5011
	nop			;5012
	nop			;5013
	nop			;5014
	nop			;5015
	nop			;5016
	nop			;5017
	nop			;5018
	nop			;5019
	nop			;501a
	nop			;501b
	nop			;501c
	nop			;501d
	nop			;501e
	nop			;501f
	nop			;5020
	nop			;5021
	nop			;5022
	nop			;5023
	nop			;5024
	nop			;5025
	nop			;5026
	nop			;5027
	nop			;5028
	nop			;5029
	nop			;502a
	nop			;502b
	nop			;502c
	nop			;502d
	nop			;502e
	nop			;502f
	nop			;5030
	nop			;5031
	nop			;5032
	nop			;5033
	nop			;5034
	nop			;5035
	nop			;5036
	nop			;5037
	nop			;5038
	nop			;5039
	nop			;503a
	nop			;503b
	nop			;503c
	nop			;503d
	nop			;503e
	nop			;503f
	nop			;5040
	nop			;5041
	nop			;5042
	nop			;5043
	nop			;5044
	nop			;5045
	nop			;5046
	nop			;5047
	nop			;5048
	nop			;5049
	nop			;504a
	nop			;504b
	nop			;504c
	nop			;504d
	nop			;504e
	nop			;504f
	nop			;5050
	nop			;5051
	nop			;5052
	nop			;5053
	nop			;5054
	nop			;5055
	nop			;5056
	nop			;5057
	nop			;5058
	nop			;5059
	nop			;505a
	nop			;505b
	nop			;505c
	nop			;505d
	nop			;505e
	nop			;505f
	nop			;5060
	nop			;5061
	nop			;5062
	nop			;5063
	nop			;5064
	nop			;5065
	nop			;5066
	nop			;5067
	nop			;5068
	nop			;5069
	nop			;506a
	nop			;506b
	nop			;506c
	nop			;506d
	nop			;506e
	nop			;506f
	nop			;5070
	nop			;5071
	nop			;5072
	nop			;5073
	nop			;5074
	nop			;5075
	nop			;5076
	nop			;5077
	nop			;5078
	nop			;5079
	nop			;507a
	nop			;507b
	nop			;507c
	nop			;507d
	nop			;507e
	nop			;507f
	nop			;5080
	nop			;5081
	nop			;5082
	nop			;5083
	nop			;5084
	nop			;5085
	nop			;5086
	nop			;5087
	nop			;5088
	nop			;5089
	nop			;508a
	nop			;508b
	nop			;508c
	nop			;508d
	nop			;508e
	nop			;508f
	nop			;5090
	nop			;5091
	nop			;5092
	nop			;5093
	nop			;5094
	nop			;5095
	nop			;5096
	nop			;5097
	nop			;5098
	nop			;5099
	nop			;509a
	nop			;509b
	nop			;509c
	nop			;509d
	nop			;509e
	nop			;509f
	nop			;50a0
	nop			;50a1
	nop			;50a2
	nop			;50a3
	nop			;50a4
	nop			;50a5
	nop			;50a6
	nop			;50a7
	nop			;50a8
	nop			;50a9
	nop			;50aa
	nop			;50ab
	nop			;50ac
	nop			;50ad
	nop			;50ae
	nop			;50af
	nop			;50b0
	nop			;50b1
	nop			;50b2
	nop			;50b3
	nop			;50b4
	nop			;50b5
	nop			;50b6
	nop			;50b7
	nop			;50b8
	nop			;50b9
	nop			;50ba
	nop			;50bb
	nop			;50bc
	nop			;50bd
	nop			;50be
	nop			;50bf
	nop			;50c0
	nop			;50c1
	nop			;50c2
	nop			;50c3
	nop			;50c4
	nop			;50c5
	nop			;50c6
	nop			;50c7
	nop			;50c8
	nop			;50c9
	nop			;50ca
	nop			;50cb
	nop			;50cc
	nop			;50cd
	nop			;50ce
	nop			;50cf
	nop			;50d0
	nop			;50d1
	nop			;50d2
	nop			;50d3
	nop			;50d4
	nop			;50d5
	nop			;50d6
	nop			;50d7
	nop			;50d8
	nop			;50d9
	nop			;50da
	nop			;50db
	nop			;50dc
	nop			;50dd
	nop			;50de
	nop			;50df
	nop			;50e0
	nop			;50e1
	nop			;50e2
	nop			;50e3
	nop			;50e4
	nop			;50e5
	nop			;50e6
	nop			;50e7
	nop			;50e8
	nop			;50e9
	nop			;50ea
	nop			;50eb
	nop			;50ec
	nop			;50ed
	nop			;50ee
	nop			;50ef
	nop			;50f0
	nop			;50f1
	nop			;50f2
	nop			;50f3
	nop			;50f4
	nop			;50f5
	nop			;50f6
	nop			;50f7
	nop			;50f8
	nop			;50f9
	nop			;50fa
	nop			;50fb
	nop			;50fc
	nop			;50fd
	nop			;50fe
	nop			;50ff
	nop			;5100
	nop			;5101
	nop			;5102
	nop			;5103
	nop			;5104
	nop			;5105
	nop			;5106
	nop			;5107
	nop			;5108
	nop			;5109
	nop			;510a
	nop			;510b
	nop			;510c
	nop			;510d
	nop			;510e
	nop			;510f
	nop			;5110
	nop			;5111
	nop			;5112
	nop			;5113
	nop			;5114
	nop			;5115
	nop			;5116
	nop			;5117
	nop			;5118
	nop			;5119
	nop			;511a
	nop			;511b
	nop			;511c
	nop			;511d
	nop			;511e
	nop			;511f
	nop			;5120
	nop			;5121
	nop			;5122
	nop			;5123
	nop			;5124
	nop			;5125
	nop			;5126
	nop			;5127
	nop			;5128
	nop			;5129
	nop			;512a
	nop			;512b
	nop			;512c
	nop			;512d
	nop			;512e
	nop			;512f
	nop			;5130
	nop			;5131
	nop			;5132
	nop			;5133
	nop			;5134
	nop			;5135
	nop			;5136
	nop			;5137
	nop			;5138
	nop			;5139
	nop			;513a
	nop			;513b
	nop			;513c
	nop			;513d
	nop			;513e
	nop			;513f
	nop			;5140
	nop			;5141
	nop			;5142
	nop			;5143
	nop			;5144
	nop			;5145
	nop			;5146
	nop			;5147
	nop			;5148
	nop			;5149
	nop			;514a
	nop			;514b
	nop			;514c
	nop			;514d
	nop			;514e
	nop			;514f
	nop			;5150
	nop			;5151
	nop			;5152
	nop			;5153
	nop			;5154
	nop			;5155
	nop			;5156
	nop			;5157
	nop			;5158
	nop			;5159
	nop			;515a
	nop			;515b
	nop			;515c
	nop			;515d
	nop			;515e
	nop			;515f
	nop			;5160
	nop			;5161
	nop			;5162
	nop			;5163
	nop			;5164
	nop			;5165
	nop			;5166
	nop			;5167
	nop			;5168
	nop			;5169
	nop			;516a
	nop			;516b
	nop			;516c
	nop			;516d
	nop			;516e
	nop			;516f
	nop			;5170
	nop			;5171
	nop			;5172
	nop			;5173
	nop			;5174
	nop			;5175
	nop			;5176
	nop			;5177
	nop			;5178
	nop			;5179
	nop			;517a
	nop			;517b
	nop			;517c
	nop			;517d
	nop			;517e
	nop			;517f
	nop			;5180
	nop			;5181
	nop			;5182
	nop			;5183
	nop			;5184
	nop			;5185
	nop			;5186
	nop			;5187
	nop			;5188
	nop			;5189
	nop			;518a
	nop			;518b
	nop			;518c
	nop			;518d
	nop			;518e
	nop			;518f
	nop			;5190
	nop			;5191
	nop			;5192
	nop			;5193
	nop			;5194
	nop			;5195
	nop			;5196
	nop			;5197
	nop			;5198
	nop			;5199
	nop			;519a
	nop			;519b
	nop			;519c
	nop			;519d
	nop			;519e
	nop			;519f
	nop			;51a0
	nop			;51a1
	nop			;51a2
	nop			;51a3
	nop			;51a4
	nop			;51a5
	nop			;51a6
	nop			;51a7
	nop			;51a8
	nop			;51a9
	nop			;51aa
	nop			;51ab
	nop			;51ac
	nop			;51ad
	nop			;51ae
	nop			;51af
	nop			;51b0
	nop			;51b1
	nop			;51b2
	nop			;51b3
	nop			;51b4
	nop			;51b5
	nop			;51b6
	nop			;51b7
	nop			;51b8
	nop			;51b9
	nop			;51ba
	nop			;51bb
	nop			;51bc
	nop			;51bd
	nop			;51be
	nop			;51bf
	nop			;51c0
	nop			;51c1
	nop			;51c2
	nop			;51c3
	nop			;51c4
	nop			;51c5
	nop			;51c6
	nop			;51c7
	nop			;51c8
	nop			;51c9
	nop			;51ca
	nop			;51cb
	nop			;51cc
	nop			;51cd
	nop			;51ce
	nop			;51cf
	nop			;51d0
	nop			;51d1
	nop			;51d2
	nop			;51d3
	nop			;51d4
	nop			;51d5
	nop			;51d6
	nop			;51d7
	nop			;51d8
	nop			;51d9
	nop			;51da
	nop			;51db
	nop			;51dc
	nop			;51dd
	nop			;51de
	nop			;51df
	nop			;51e0
	nop			;51e1
	nop			;51e2
	nop			;51e3
	nop			;51e4
	nop			;51e5
	nop			;51e6
	nop			;51e7
	nop			;51e8
	nop			;51e9
	nop			;51ea
	nop			;51eb
	nop			;51ec
	nop			;51ed
	nop			;51ee
	nop			;51ef
	nop			;51f0
	nop			;51f1
	nop			;51f2
	nop			;51f3
	nop			;51f4
	nop			;51f5
	nop			;51f6
	nop			;51f7
	nop			;51f8
	nop			;51f9
	nop			;51fa
	nop			;51fb
	nop			;51fc
	nop			;51fd
	nop			;51fe
	nop			;51ff
	nop			;5200
	nop			;5201
	nop			;5202
	nop			;5203
	nop			;5204
	nop			;5205
	nop			;5206
	nop			;5207
	nop			;5208
	nop			;5209
	nop			;520a
	nop			;520b
	nop			;520c
	nop			;520d
	nop			;520e
	nop			;520f
	nop			;5210
	nop			;5211
	nop			;5212
	nop			;5213
	nop			;5214
	nop			;5215
	nop			;5216
	nop			;5217
	nop			;5218
	nop			;5219
	nop			;521a
	nop			;521b
	nop			;521c
	nop			;521d
	nop			;521e
	nop			;521f
	nop			;5220
	nop			;5221
	nop			;5222
	nop			;5223
	nop			;5224
	nop			;5225
	nop			;5226
	nop			;5227
	nop			;5228
	nop			;5229
	nop			;522a
	nop			;522b
	nop			;522c
	nop			;522d
	nop			;522e
	nop			;522f
	nop			;5230
	nop			;5231
	nop			;5232
	nop			;5233
	nop			;5234
	nop			;5235
	nop			;5236
	nop			;5237
	nop			;5238
	nop			;5239
	nop			;523a
	nop			;523b
	nop			;523c
	nop			;523d
	nop			;523e
	nop			;523f
	nop			;5240
	nop			;5241
	nop			;5242
	nop			;5243
	nop			;5244
	nop			;5245
	nop			;5246
	nop			;5247
	nop			;5248
	nop			;5249
	nop			;524a
	nop			;524b
	nop			;524c
	nop			;524d
	nop			;524e
	nop			;524f
	nop			;5250
	nop			;5251
	nop			;5252
	nop			;5253
	nop			;5254
	nop			;5255
	nop			;5256
	nop			;5257
	nop			;5258
	nop			;5259
	nop			;525a
	nop			;525b
	nop			;525c
	nop			;525d
	nop			;525e
	nop			;525f
	nop			;5260
	nop			;5261
	nop			;5262
	nop			;5263
	nop			;5264
	nop			;5265
	nop			;5266
	nop			;5267
	nop			;5268
	nop			;5269
	nop			;526a
	nop			;526b
	nop			;526c
	nop			;526d
	nop			;526e
	nop			;526f
	nop			;5270
	nop			;5271
	nop			;5272
	nop			;5273
	nop			;5274
	nop			;5275
	nop			;5276
	nop			;5277
	nop			;5278
	nop			;5279
	nop			;527a
	nop			;527b
	nop			;527c
	nop			;527d
	nop			;527e
	nop			;527f
	nop			;5280
	nop			;5281
	nop			;5282
	nop			;5283
	nop			;5284
	nop			;5285
	nop			;5286
	nop			;5287
	nop			;5288
	nop			;5289
	nop			;528a
	nop			;528b
	nop			;528c
	nop			;528d
	nop			;528e
	nop			;528f
	nop			;5290
	nop			;5291
	nop			;5292
	nop			;5293
	nop			;5294
	nop			;5295
	nop			;5296
	nop			;5297
	nop			;5298
	nop			;5299
	nop			;529a
	nop			;529b
	nop			;529c
	nop			;529d
	nop			;529e
	nop			;529f
	nop			;52a0
	nop			;52a1
	nop			;52a2
	nop			;52a3
	nop			;52a4
	nop			;52a5
	nop			;52a6
	nop			;52a7
	nop			;52a8
	nop			;52a9
	nop			;52aa
	nop			;52ab
	nop			;52ac
	nop			;52ad
	nop			;52ae
	nop			;52af
	nop			;52b0
	nop			;52b1
	nop			;52b2
	nop			;52b3
	nop			;52b4
	nop			;52b5
	nop			;52b6
	nop			;52b7
	nop			;52b8
	nop			;52b9
	nop			;52ba
	nop			;52bb
	nop			;52bc
	nop			;52bd
	nop			;52be
	nop			;52bf
	nop			;52c0
	nop			;52c1
	nop			;52c2
	nop			;52c3
	nop			;52c4
	nop			;52c5
	nop			;52c6
	nop			;52c7
	nop			;52c8
	nop			;52c9
	nop			;52ca
	nop			;52cb
	nop			;52cc
	nop			;52cd
	nop			;52ce
	nop			;52cf
	nop			;52d0
	nop			;52d1
	nop			;52d2
	nop			;52d3
	nop			;52d4
	nop			;52d5
	nop			;52d6
	nop			;52d7
	nop			;52d8
	nop			;52d9
	nop			;52da
	nop			;52db
	nop			;52dc
	nop			;52dd
	nop			;52de
	nop			;52df
	nop			;52e0
	nop			;52e1
	nop			;52e2
	nop			;52e3
	nop			;52e4
	nop			;52e5
	nop			;52e6
	nop			;52e7
	nop			;52e8
	nop			;52e9
	nop			;52ea
	nop			;52eb
	nop			;52ec
	nop			;52ed
	nop			;52ee
	nop			;52ef
	nop			;52f0
	nop			;52f1
	nop			;52f2
	nop			;52f3
	nop			;52f4
	nop			;52f5
	nop			;52f6
	nop			;52f7
	nop			;52f8
	nop			;52f9
	nop			;52fa
	nop			;52fb
	nop			;52fc
	nop			;52fd
	nop			;52fe
	nop			;52ff
	nop			;5300
	nop			;5301
	nop			;5302
	nop			;5303
	nop			;5304
	nop			;5305
	nop			;5306
	nop			;5307
	nop			;5308
	nop			;5309
	nop			;530a
	nop			;530b
	nop			;530c
	nop			;530d
	nop			;530e
	nop			;530f
	nop			;5310
	nop			;5311
	nop			;5312
	nop			;5313
	nop			;5314
	nop			;5315
	nop			;5316
	nop			;5317
	nop			;5318
	nop			;5319
	nop			;531a
	nop			;531b
	nop			;531c
	nop			;531d
	nop			;531e
	nop			;531f
	nop			;5320
	nop			;5321
	nop			;5322
	nop			;5323
	nop			;5324
	nop			;5325
	nop			;5326
	nop			;5327
	nop			;5328
	nop			;5329
	nop			;532a
	nop			;532b
	nop			;532c
	nop			;532d
	nop			;532e
	nop			;532f
	nop			;5330
	nop			;5331
	nop			;5332
	nop			;5333
	nop			;5334
	nop			;5335
	nop			;5336
	nop			;5337
	nop			;5338
	nop			;5339
	nop			;533a
	nop			;533b
	nop			;533c
	nop			;533d
	nop			;533e
	nop			;533f
	nop			;5340
	nop			;5341
	nop			;5342
	nop			;5343
	nop			;5344
	nop			;5345
	nop			;5346
	nop			;5347
	nop			;5348
	nop			;5349
	nop			;534a
	nop			;534b
	nop			;534c
	nop			;534d
	nop			;534e
	nop			;534f
	nop			;5350
	nop			;5351
	nop			;5352
	nop			;5353
	nop			;5354
	nop			;5355
	nop			;5356
	nop			;5357
	nop			;5358
	nop			;5359
	nop			;535a
	nop			;535b
	nop			;535c
	nop			;535d
	nop			;535e
	nop			;535f
	nop			;5360
	nop			;5361
	nop			;5362
	nop			;5363
	nop			;5364
	nop			;5365
	nop			;5366
	nop			;5367
	nop			;5368
	nop			;5369
	nop			;536a
	nop			;536b
	nop			;536c
	nop			;536d
	nop			;536e
	nop			;536f
	nop			;5370
	nop			;5371
	nop			;5372
	nop			;5373
	nop			;5374
	nop			;5375
	nop			;5376
	nop			;5377
	nop			;5378
	nop			;5379
	nop			;537a
	nop			;537b
	nop			;537c
	nop			;537d
	nop			;537e
	nop			;537f
	nop			;5380
	nop			;5381
	nop			;5382
	nop			;5383
	nop			;5384
	nop			;5385
	nop			;5386
	nop			;5387
	nop			;5388
	nop			;5389
	nop			;538a
	nop			;538b
	nop			;538c
	nop			;538d
	nop			;538e
	nop			;538f
	nop			;5390
	nop			;5391
	nop			;5392
	nop			;5393
	nop			;5394
	nop			;5395
	nop			;5396
	nop			;5397
	nop			;5398
	nop			;5399
	nop			;539a
	nop			;539b
	nop			;539c
	nop			;539d
	nop			;539e
	nop			;539f
	nop			;53a0
	nop			;53a1
	nop			;53a2
	nop			;53a3
	nop			;53a4
	nop			;53a5
	nop			;53a6
	nop			;53a7
	nop			;53a8
	nop			;53a9
	nop			;53aa
	nop			;53ab
	nop			;53ac
	nop			;53ad
	nop			;53ae
	nop			;53af
	nop			;53b0
	nop			;53b1
	nop			;53b2
	nop			;53b3
	nop			;53b4
	nop			;53b5
	nop			;53b6
	nop			;53b7
	nop			;53b8
	nop			;53b9
	nop			;53ba
	nop			;53bb
	nop			;53bc
	nop			;53bd
	nop			;53be
	nop			;53bf
	nop			;53c0
	nop			;53c1
	nop			;53c2
	nop			;53c3
	nop			;53c4
	nop			;53c5
	nop			;53c6
	nop			;53c7
	nop			;53c8
	nop			;53c9
	nop			;53ca
	nop			;53cb
	nop			;53cc
	nop			;53cd
	nop			;53ce
	nop			;53cf
	nop			;53d0
	nop			;53d1
	nop			;53d2
	nop			;53d3
	nop			;53d4
	nop			;53d5
	nop			;53d6
	nop			;53d7
	nop			;53d8
	nop			;53d9
	nop			;53da
	nop			;53db
	nop			;53dc
	nop			;53dd
	nop			;53de
	nop			;53df
	nop			;53e0
	nop			;53e1
	nop			;53e2
	nop			;53e3
	nop			;53e4
	nop			;53e5
	nop			;53e6
	nop			;53e7
	nop			;53e8
	nop			;53e9
	nop			;53ea
	nop			;53eb
	nop			;53ec
	nop			;53ed
	nop			;53ee
	nop			;53ef
	nop			;53f0
	nop			;53f1
	nop			;53f2
	nop			;53f3
	nop			;53f4
	nop			;53f5
	nop			;53f6
	nop			;53f7
	nop			;53f8
	nop			;53f9
	nop			;53fa
	nop			;53fb
	nop			;53fc
	nop			;53fd
	nop			;53fe
	nop			;53ff
	nop			;5400
	nop			;5401
	nop			;5402
	nop			;5403
	nop			;5404
	nop			;5405
	nop			;5406
	nop			;5407
	nop			;5408
	nop			;5409
	nop			;540a
	nop			;540b
	nop			;540c
	nop			;540d
	nop			;540e
	nop			;540f
	nop			;5410
	nop			;5411
	nop			;5412
	nop			;5413
	nop			;5414
	nop			;5415
	nop			;5416
	nop			;5417
	nop			;5418
	nop			;5419
	nop			;541a
	nop			;541b
	nop			;541c
	nop			;541d
	nop			;541e
	nop			;541f
	nop			;5420
	nop			;5421
	nop			;5422
	nop			;5423
	nop			;5424
	nop			;5425
	nop			;5426
	nop			;5427
	nop			;5428
	nop			;5429
	nop			;542a
	nop			;542b
	nop			;542c
	nop			;542d
	nop			;542e
	nop			;542f
	nop			;5430
	nop			;5431
	nop			;5432
	nop			;5433
	nop			;5434
	nop			;5435
	nop			;5436
	nop			;5437
	nop			;5438
	nop			;5439
	nop			;543a
	nop			;543b
	nop			;543c
	nop			;543d
	nop			;543e
	nop			;543f
	nop			;5440
	nop			;5441
	nop			;5442
	nop			;5443
	nop			;5444
	nop			;5445
	nop			;5446
	nop			;5447
	nop			;5448
	nop			;5449
	nop			;544a
	nop			;544b
	nop			;544c
	nop			;544d
	nop			;544e
	nop			;544f
	nop			;5450
	nop			;5451
	nop			;5452
	nop			;5453
	nop			;5454
	nop			;5455
	nop			;5456
	nop			;5457
	nop			;5458
	nop			;5459
	nop			;545a
	nop			;545b
	nop			;545c
	nop			;545d
	nop			;545e
	nop			;545f
	nop			;5460
	nop			;5461
	nop			;5462
	nop			;5463
	nop			;5464
	nop			;5465
	nop			;5466
	nop			;5467
	nop			;5468
	nop			;5469
	nop			;546a
	nop			;546b
	nop			;546c
	nop			;546d
	nop			;546e
	nop			;546f
	nop			;5470
	nop			;5471
	nop			;5472
	nop			;5473
	nop			;5474
	nop			;5475
	nop			;5476
	nop			;5477
	nop			;5478
	nop			;5479
	nop			;547a
	nop			;547b
	nop			;547c
	nop			;547d
	nop			;547e
	nop			;547f
	nop			;5480
	nop			;5481
	nop			;5482
	nop			;5483
	nop			;5484
	nop			;5485
	nop			;5486
	nop			;5487
	nop			;5488
	nop			;5489
	nop			;548a
	nop			;548b
	nop			;548c
	nop			;548d
	nop			;548e
	nop			;548f
	nop			;5490
	nop			;5491
	nop			;5492
	nop			;5493
	nop			;5494
	nop			;5495
	nop			;5496
	nop			;5497
	nop			;5498
	nop			;5499
	nop			;549a
	nop			;549b
	nop			;549c
	nop			;549d
	nop			;549e
	nop			;549f
	nop			;54a0
	nop			;54a1
	nop			;54a2
	nop			;54a3
	nop			;54a4
	nop			;54a5
	nop			;54a6
	nop			;54a7
	nop			;54a8
	nop			;54a9
	nop			;54aa
	nop			;54ab
	nop			;54ac
	nop			;54ad
	nop			;54ae
	nop			;54af
	nop			;54b0
	nop			;54b1
	nop			;54b2
	nop			;54b3
	nop			;54b4
	nop			;54b5
	nop			;54b6
	nop			;54b7
	nop			;54b8
	nop			;54b9
	nop			;54ba
	nop			;54bb
	nop			;54bc
	nop			;54bd
	nop			;54be
	nop			;54bf
	nop			;54c0
	nop			;54c1
	nop			;54c2
	nop			;54c3
	nop			;54c4
	nop			;54c5
	nop			;54c6
	nop			;54c7
	nop			;54c8
	nop			;54c9
	nop			;54ca
	nop			;54cb
	nop			;54cc
	nop			;54cd
	nop			;54ce
	nop			;54cf
	nop			;54d0
	nop			;54d1
	nop			;54d2
	nop			;54d3
	nop			;54d4
	nop			;54d5
	nop			;54d6
	nop			;54d7
	nop			;54d8
	nop			;54d9
	nop			;54da
	nop			;54db
	nop			;54dc
	nop			;54dd
	nop			;54de
	nop			;54df
	nop			;54e0
	nop			;54e1
	nop			;54e2
	nop			;54e3
	nop			;54e4
	nop			;54e5
	nop			;54e6
	nop			;54e7
	nop			;54e8
	nop			;54e9
	nop			;54ea
	nop			;54eb
	nop			;54ec
	nop			;54ed
	nop			;54ee
	nop			;54ef
	nop			;54f0
	nop			;54f1
	nop			;54f2
	nop			;54f3
	nop			;54f4
	nop			;54f5
	nop			;54f6
	nop			;54f7
	nop			;54f8
	nop			;54f9
	nop			;54fa
	nop			;54fb
	nop			;54fc
	nop			;54fd
	nop			;54fe
	nop			;54ff
	nop			;5500
	nop			;5501
	nop			;5502
	nop			;5503
	nop			;5504
	nop			;5505
	nop			;5506
	nop			;5507
	nop			;5508
	nop			;5509
	nop			;550a
	nop			;550b
	nop			;550c
	nop			;550d
	nop			;550e
	nop			;550f
	nop			;5510
	nop			;5511
	nop			;5512
	nop			;5513
	nop			;5514
	nop			;5515
	nop			;5516
	nop			;5517
	nop			;5518
	nop			;5519
	nop			;551a
	nop			;551b
	nop			;551c
	nop			;551d
	nop			;551e
	nop			;551f
	nop			;5520
	nop			;5521
	nop			;5522
	nop			;5523
	nop			;5524
	nop			;5525
	nop			;5526
	nop			;5527
	nop			;5528
	nop			;5529
	nop			;552a
	nop			;552b
	nop			;552c
	nop			;552d
	nop			;552e
	nop			;552f
	nop			;5530
	nop			;5531
	nop			;5532
	nop			;5533
	nop			;5534
	nop			;5535
	nop			;5536
	nop			;5537
	nop			;5538
	nop			;5539
	nop			;553a
	nop			;553b
	nop			;553c
	nop			;553d
	nop			;553e
	nop			;553f
	nop			;5540
	nop			;5541
	nop			;5542
	nop			;5543
	nop			;5544
	nop			;5545
	nop			;5546
	nop			;5547
	nop			;5548
	nop			;5549
	nop			;554a
	nop			;554b
	nop			;554c
	nop			;554d
	nop			;554e
	nop			;554f
	nop			;5550
	nop			;5551
	nop			;5552
	nop			;5553
	nop			;5554
	nop			;5555
	nop			;5556
	nop			;5557
	nop			;5558
	nop			;5559
	nop			;555a
	nop			;555b
	nop			;555c
	nop			;555d
	nop			;555e
	nop			;555f
	nop			;5560
	nop			;5561
	nop			;5562
	nop			;5563
	nop			;5564
	nop			;5565
	nop			;5566
	nop			;5567
	nop			;5568
	nop			;5569
	nop			;556a
	nop			;556b
	nop			;556c
	nop			;556d
	nop			;556e
	nop			;556f
	nop			;5570
	nop			;5571
	nop			;5572
	nop			;5573
	nop			;5574
	nop			;5575
	nop			;5576
	nop			;5577
	nop			;5578
	nop			;5579
	nop			;557a
	nop			;557b
	nop			;557c
	nop			;557d
	nop			;557e
	nop			;557f
	nop			;5580
	nop			;5581
	nop			;5582
	nop			;5583
	nop			;5584
	nop			;5585
	nop			;5586
	nop			;5587
	nop			;5588
	nop			;5589
	nop			;558a
	nop			;558b
	nop			;558c
	nop			;558d
	nop			;558e
	nop			;558f
	nop			;5590
	nop			;5591
	nop			;5592
	nop			;5593
	nop			;5594
	nop			;5595
	nop			;5596
	nop			;5597
	nop			;5598
	nop			;5599
	nop			;559a
	nop			;559b
	nop			;559c
	nop			;559d
	nop			;559e
	nop			;559f
	nop			;55a0
	nop			;55a1
	nop			;55a2
	nop			;55a3
	nop			;55a4
	nop			;55a5
	nop			;55a6
	nop			;55a7
	nop			;55a8
	nop			;55a9
	nop			;55aa
	nop			;55ab
	nop			;55ac
	nop			;55ad
	nop			;55ae
	nop			;55af
	nop			;55b0
	nop			;55b1
	nop			;55b2
	nop			;55b3
	nop			;55b4
	nop			;55b5
	nop			;55b6
	nop			;55b7
	nop			;55b8
	nop			;55b9
	nop			;55ba
	nop			;55bb
	nop			;55bc
	nop			;55bd
	nop			;55be
	nop			;55bf
	nop			;55c0
	nop			;55c1
	nop			;55c2
	nop			;55c3
	nop			;55c4
	nop			;55c5
	nop			;55c6
	nop			;55c7
	nop			;55c8
	nop			;55c9
	nop			;55ca
	nop			;55cb
	nop			;55cc
	nop			;55cd
	nop			;55ce
	nop			;55cf
	nop			;55d0
	nop			;55d1
	nop			;55d2
	nop			;55d3
	nop			;55d4
	nop			;55d5
	nop			;55d6
	nop			;55d7
	nop			;55d8
	nop			;55d9
	nop			;55da
	nop			;55db
	nop			;55dc
	nop			;55dd
	nop			;55de
	nop			;55df
	nop			;55e0
	nop			;55e1
	nop			;55e2
	nop			;55e3
	nop			;55e4
	nop			;55e5
	nop			;55e6
	nop			;55e7
	nop			;55e8
	nop			;55e9
	nop			;55ea
	nop			;55eb
	nop			;55ec
	nop			;55ed
	nop			;55ee
	nop			;55ef
	nop			;55f0
	nop			;55f1
	nop			;55f2
	nop			;55f3
	nop			;55f4
	nop			;55f5
	nop			;55f6
	nop			;55f7
	nop			;55f8
	nop			;55f9
	nop			;55fa
	nop			;55fb
	nop			;55fc
	nop			;55fd
	nop			;55fe
	nop			;55ff
	nop			;5600
	nop			;5601
	nop			;5602
	nop			;5603
	nop			;5604
	nop			;5605
	nop			;5606
	nop			;5607
	nop			;5608
	nop			;5609
	nop			;560a
	nop			;560b
	nop			;560c
	nop			;560d
	nop			;560e
	nop			;560f
	nop			;5610
	nop			;5611
	nop			;5612
	nop			;5613
	nop			;5614
	nop			;5615
	nop			;5616
	nop			;5617
	nop			;5618
	nop			;5619
	nop			;561a
	nop			;561b
	nop			;561c
	nop			;561d
	nop			;561e
	nop			;561f
	nop			;5620
	nop			;5621
	nop			;5622
	nop			;5623
	nop			;5624
	nop			;5625
	nop			;5626
	nop			;5627
	nop			;5628
	nop			;5629
	nop			;562a
	nop			;562b
	nop			;562c
	nop			;562d
	nop			;562e
	nop			;562f
	nop			;5630
	nop			;5631
	nop			;5632
	nop			;5633
	nop			;5634
	nop			;5635
	nop			;5636
	nop			;5637
	nop			;5638
	nop			;5639
	nop			;563a
	nop			;563b
	nop			;563c
	nop			;563d
	nop			;563e
	nop			;563f
	nop			;5640
	nop			;5641
	nop			;5642
	nop			;5643
	nop			;5644
	nop			;5645
	nop			;5646
	nop			;5647
	nop			;5648
	nop			;5649
	nop			;564a
	nop			;564b
	nop			;564c
	nop			;564d
	nop			;564e
	nop			;564f
	nop			;5650
	nop			;5651
	nop			;5652
	nop			;5653
	nop			;5654
	nop			;5655
	nop			;5656
	nop			;5657
	nop			;5658
	nop			;5659
	nop			;565a
	nop			;565b
	nop			;565c
	nop			;565d
	nop			;565e
	nop			;565f
	nop			;5660
	nop			;5661
	nop			;5662
	nop			;5663
	nop			;5664
	nop			;5665
	nop			;5666
	nop			;5667
	nop			;5668
	nop			;5669
	nop			;566a
	nop			;566b
	nop			;566c
	nop			;566d
	nop			;566e
	nop			;566f
	nop			;5670
	nop			;5671
	nop			;5672
	nop			;5673
	nop			;5674
	nop			;5675
	nop			;5676
	nop			;5677
	nop			;5678
	nop			;5679
	nop			;567a
	nop			;567b
	nop			;567c
	nop			;567d
	nop			;567e
	nop			;567f
	nop			;5680
	nop			;5681
	nop			;5682
	nop			;5683
	nop			;5684
	nop			;5685
	nop			;5686
	nop			;5687
	nop			;5688
	nop			;5689
	nop			;568a
	nop			;568b
	nop			;568c
	nop			;568d
	nop			;568e
	nop			;568f
	nop			;5690
	nop			;5691
	nop			;5692
	nop			;5693
	nop			;5694
	nop			;5695
	nop			;5696
	nop			;5697
	nop			;5698
	nop			;5699
	nop			;569a
	nop			;569b
	nop			;569c
	nop			;569d
	nop			;569e
	nop			;569f
	nop			;56a0
	nop			;56a1
	nop			;56a2
	nop			;56a3
	nop			;56a4
	nop			;56a5
	nop			;56a6
	nop			;56a7
	nop			;56a8
	nop			;56a9
	nop			;56aa
	nop			;56ab
	nop			;56ac
	nop			;56ad
	nop			;56ae
	nop			;56af
	nop			;56b0
	nop			;56b1
	nop			;56b2
	nop			;56b3
	nop			;56b4
	nop			;56b5
	nop			;56b6
	nop			;56b7
	nop			;56b8
	nop			;56b9
	nop			;56ba
	nop			;56bb
	nop			;56bc
	nop			;56bd
	nop			;56be
	nop			;56bf
	nop			;56c0
	nop			;56c1
	nop			;56c2
	nop			;56c3
	nop			;56c4
	nop			;56c5
	nop			;56c6
	nop			;56c7
	nop			;56c8
	nop			;56c9
	nop			;56ca
	nop			;56cb
	nop			;56cc
	nop			;56cd
	nop			;56ce
	nop			;56cf
	nop			;56d0
	nop			;56d1
	nop			;56d2
	nop			;56d3
	nop			;56d4
	nop			;56d5
	nop			;56d6
	nop			;56d7
	nop			;56d8
	nop			;56d9
	nop			;56da
	nop			;56db
	nop			;56dc
	nop			;56dd
	nop			;56de
	nop			;56df
	nop			;56e0
	nop			;56e1
	nop			;56e2
	nop			;56e3
	nop			;56e4
	nop			;56e5
	nop			;56e6
	nop			;56e7
	nop			;56e8
	nop			;56e9
	nop			;56ea
	nop			;56eb
	nop			;56ec
	nop			;56ed
	nop			;56ee
	nop			;56ef
	nop			;56f0
	nop			;56f1
	nop			;56f2
	nop			;56f3
	nop			;56f4
	nop			;56f5
	nop			;56f6
	nop			;56f7
	nop			;56f8
	nop			;56f9
	nop			;56fa
	nop			;56fb
	nop			;56fc
	nop			;56fd
	nop			;56fe
	nop			;56ff
	nop			;5700
	nop			;5701
	nop			;5702
	nop			;5703
	nop			;5704
	nop			;5705
	nop			;5706
	nop			;5707
	nop			;5708
	nop			;5709
	nop			;570a
	nop			;570b
	nop			;570c
	nop			;570d
	nop			;570e
	nop			;570f
	nop			;5710
	nop			;5711
	nop			;5712
	nop			;5713
	nop			;5714
	nop			;5715
	nop			;5716
	nop			;5717
	nop			;5718
	nop			;5719
	nop			;571a
	nop			;571b
	nop			;571c
	nop			;571d
	nop			;571e
	nop			;571f
	nop			;5720
	nop			;5721
	nop			;5722
	nop			;5723
	nop			;5724
	nop			;5725
	nop			;5726
	nop			;5727
	nop			;5728
	nop			;5729
	nop			;572a
	nop			;572b
	nop			;572c
	nop			;572d
	nop			;572e
	nop			;572f
	nop			;5730
	nop			;5731
	nop			;5732
	nop			;5733
	nop			;5734
	nop			;5735
	nop			;5736
	nop			;5737
	nop			;5738
	nop			;5739
	nop			;573a
	nop			;573b
	nop			;573c
	nop			;573d
	nop			;573e
	nop			;573f
	nop			;5740
	nop			;5741
	nop			;5742
	nop			;5743
	nop			;5744
	nop			;5745
	nop			;5746
	nop			;5747
	nop			;5748
	nop			;5749
	nop			;574a
	nop			;574b
	nop			;574c
	nop			;574d
	nop			;574e
	nop			;574f
	nop			;5750
	nop			;5751
	nop			;5752
	nop			;5753
	nop			;5754
	nop			;5755
	nop			;5756
	nop			;5757
	nop			;5758
	nop			;5759
	nop			;575a
	nop			;575b
	nop			;575c
	nop			;575d
	nop			;575e
	nop			;575f
	nop			;5760
	nop			;5761
	nop			;5762
	nop			;5763
	nop			;5764
	nop			;5765
	nop			;5766
	nop			;5767
	nop			;5768
	nop			;5769
	nop			;576a
	nop			;576b
	nop			;576c
	nop			;576d
	nop			;576e
	nop			;576f
	nop			;5770
	nop			;5771
	nop			;5772
	nop			;5773
	nop			;5774
	nop			;5775
	nop			;5776
	nop			;5777
	nop			;5778
	nop			;5779
	nop			;577a
	nop			;577b
	nop			;577c
	nop			;577d
	nop			;577e
	nop			;577f
	nop			;5780
	nop			;5781
	nop			;5782
	nop			;5783
	nop			;5784
	nop			;5785
	nop			;5786
	nop			;5787
	nop			;5788
	nop			;5789
	nop			;578a
	nop			;578b
	nop			;578c
	nop			;578d
	nop			;578e
	nop			;578f
	nop			;5790
	nop			;5791
	nop			;5792
	nop			;5793
	nop			;5794
	nop			;5795
	nop			;5796
	nop			;5797
	nop			;5798
	nop			;5799
	nop			;579a
	nop			;579b
	nop			;579c
	nop			;579d
	nop			;579e
	nop			;579f
	nop			;57a0
	nop			;57a1
	nop			;57a2
	nop			;57a3
	nop			;57a4
	nop			;57a5
	nop			;57a6
	nop			;57a7
	nop			;57a8
	nop			;57a9
	nop			;57aa
	nop			;57ab
	nop			;57ac
	nop			;57ad
	nop			;57ae
	nop			;57af
	nop			;57b0
	nop			;57b1
	nop			;57b2
	nop			;57b3
	nop			;57b4
	nop			;57b5
	nop			;57b6
	nop			;57b7
	nop			;57b8
	nop			;57b9
	nop			;57ba
	nop			;57bb
	nop			;57bc
	nop			;57bd
	nop			;57be
	nop			;57bf
	nop			;57c0
	nop			;57c1
	nop			;57c2
	nop			;57c3
	nop			;57c4
	nop			;57c5
	nop			;57c6
	nop			;57c7
	nop			;57c8
	nop			;57c9
	nop			;57ca
	nop			;57cb
	nop			;57cc
	nop			;57cd
	nop			;57ce
	nop			;57cf
	nop			;57d0
	nop			;57d1
	nop			;57d2
	nop			;57d3
	nop			;57d4
	nop			;57d5
	nop			;57d6
	nop			;57d7
	nop			;57d8
	nop			;57d9
	nop			;57da
	nop			;57db
	nop			;57dc
	nop			;57dd
	nop			;57de
	nop			;57df
	nop			;57e0
	nop			;57e1
	nop			;57e2
	nop			;57e3
	nop			;57e4
	nop			;57e5
	nop			;57e6
	nop			;57e7
	nop			;57e8
	nop			;57e9
	nop			;57ea
	nop			;57eb
	nop			;57ec
	nop			;57ed
	nop			;57ee
	nop			;57ef
	nop			;57f0
	nop			;57f1
	nop			;57f2
	nop			;57f3
	nop			;57f4
	nop			;57f5
	nop			;57f6
	nop			;57f7
	nop			;57f8
	nop			;57f9
	nop			;57fa
	nop			;57fb
	nop			;57fc
	nop			;57fd
	nop			;57fe
	nop			;57ff
	nop			;5800
	nop			;5801
	nop			;5802
	nop			;5803
	nop			;5804
	nop			;5805
	nop			;5806
	nop			;5807
	nop			;5808
	nop			;5809
	nop			;580a
	nop			;580b
	nop			;580c
	nop			;580d
	nop			;580e
	nop			;580f
	nop			;5810
	nop			;5811
	nop			;5812
	nop			;5813
	nop			;5814
	nop			;5815
	nop			;5816
	nop			;5817
	nop			;5818
	nop			;5819
	nop			;581a
	nop			;581b
	nop			;581c
	nop			;581d
	nop			;581e
	nop			;581f
	nop			;5820
	nop			;5821
	nop			;5822
	nop			;5823
	nop			;5824
	nop			;5825
	nop			;5826
	nop			;5827
	nop			;5828
	nop			;5829
	nop			;582a
	nop			;582b
	nop			;582c
	nop			;582d
	nop			;582e
	nop			;582f
	nop			;5830
	nop			;5831
	nop			;5832
	nop			;5833
	nop			;5834
	nop			;5835
	nop			;5836
	nop			;5837
	nop			;5838
	nop			;5839
	nop			;583a
	nop			;583b
	nop			;583c
	nop			;583d
	nop			;583e
	nop			;583f
	nop			;5840
	nop			;5841
	nop			;5842
	nop			;5843
	nop			;5844
	nop			;5845
	nop			;5846
	nop			;5847
	nop			;5848
	nop			;5849
	nop			;584a
	nop			;584b
	nop			;584c
	nop			;584d
	nop			;584e
	nop			;584f
	nop			;5850
	nop			;5851
	nop			;5852
	nop			;5853
	nop			;5854
	nop			;5855
	nop			;5856
	nop			;5857
	nop			;5858
	nop			;5859
	nop			;585a
	nop			;585b
	nop			;585c
	nop			;585d
	nop			;585e
	nop			;585f
	nop			;5860
	nop			;5861
	nop			;5862
	nop			;5863
	nop			;5864
	nop			;5865
	nop			;5866
	nop			;5867
	nop			;5868
	nop			;5869
	nop			;586a
	nop			;586b
	nop			;586c
	nop			;586d
	nop			;586e
	nop			;586f
	nop			;5870
	nop			;5871
	nop			;5872
	nop			;5873
	nop			;5874
	nop			;5875
	nop			;5876
	nop			;5877
	nop			;5878
	nop			;5879
	nop			;587a
	nop			;587b
	nop			;587c
	nop			;587d
	nop			;587e
	nop			;587f
	nop			;5880
	nop			;5881
	nop			;5882
	nop			;5883
	nop			;5884
	nop			;5885
	nop			;5886
	nop			;5887
	nop			;5888
	nop			;5889
	nop			;588a
	nop			;588b
	nop			;588c
	nop			;588d
	nop			;588e
	nop			;588f
	nop			;5890
	nop			;5891
	nop			;5892
	nop			;5893
	nop			;5894
	nop			;5895
	nop			;5896
	nop			;5897
	nop			;5898
	nop			;5899
	nop			;589a
	nop			;589b
	nop			;589c
	nop			;589d
	nop			;589e
	nop			;589f
	nop			;58a0
	nop			;58a1
	nop			;58a2
	nop			;58a3
	nop			;58a4
	nop			;58a5
	nop			;58a6
	nop			;58a7
	nop			;58a8
	nop			;58a9
	nop			;58aa
	nop			;58ab
	nop			;58ac
	nop			;58ad
	nop			;58ae
	nop			;58af
	nop			;58b0
	nop			;58b1
	nop			;58b2
	nop			;58b3
	nop			;58b4
	nop			;58b5
	nop			;58b6
	nop			;58b7
	nop			;58b8
	nop			;58b9
	nop			;58ba
	nop			;58bb
	nop			;58bc
	nop			;58bd
	nop			;58be
	nop			;58bf
	nop			;58c0
	nop			;58c1
	nop			;58c2
	nop			;58c3
	nop			;58c4
	nop			;58c5
	nop			;58c6
	nop			;58c7
	nop			;58c8
	nop			;58c9
	nop			;58ca
	nop			;58cb
	nop			;58cc
	nop			;58cd
	nop			;58ce
	nop			;58cf
	nop			;58d0
	nop			;58d1
	nop			;58d2
	nop			;58d3
	nop			;58d4
	nop			;58d5
	nop			;58d6
	nop			;58d7
	nop			;58d8
	nop			;58d9
	nop			;58da
	nop			;58db
	nop			;58dc
	nop			;58dd
	nop			;58de
	nop			;58df
	nop			;58e0
	nop			;58e1
	nop			;58e2
	nop			;58e3
	nop			;58e4
	nop			;58e5
	nop			;58e6
	nop			;58e7
	nop			;58e8
	nop			;58e9
	nop			;58ea
	nop			;58eb
	nop			;58ec
	nop			;58ed
	nop			;58ee
	nop			;58ef
	nop			;58f0
	nop			;58f1
	nop			;58f2
	nop			;58f3
	nop			;58f4
	nop			;58f5
	nop			;58f6
	nop			;58f7
	nop			;58f8
	nop			;58f9
	nop			;58fa
	nop			;58fb
	nop			;58fc
	nop			;58fd
	nop			;58fe
	nop			;58ff
	nop			;5900
	nop			;5901
	nop			;5902
	nop			;5903
	nop			;5904
	nop			;5905
	nop			;5906
	nop			;5907
	nop			;5908
	nop			;5909
	nop			;590a
	nop			;590b
	nop			;590c
	nop			;590d
	nop			;590e
	nop			;590f
	nop			;5910
	nop			;5911
	nop			;5912
	nop			;5913
	nop			;5914
	nop			;5915
	nop			;5916
	nop			;5917
	nop			;5918
	nop			;5919
	nop			;591a
	nop			;591b
	nop			;591c
	nop			;591d
	nop			;591e
	nop			;591f
	nop			;5920
	nop			;5921
	nop			;5922
	nop			;5923
	nop			;5924
	nop			;5925
	nop			;5926
	nop			;5927
	nop			;5928
	nop			;5929
	nop			;592a
	nop			;592b
	nop			;592c
	nop			;592d
	nop			;592e
	nop			;592f
	nop			;5930
	nop			;5931
	nop			;5932
	nop			;5933
	nop			;5934
	nop			;5935
	nop			;5936
	nop			;5937
	nop			;5938
	nop			;5939
	nop			;593a
	nop			;593b
	nop			;593c
	nop			;593d
	nop			;593e
	nop			;593f
	nop			;5940
	nop			;5941
	nop			;5942
	nop			;5943
	nop			;5944
	nop			;5945
	nop			;5946
	nop			;5947
	nop			;5948
	nop			;5949
	nop			;594a
	nop			;594b
	nop			;594c
	nop			;594d
	nop			;594e
	nop			;594f
	nop			;5950
	nop			;5951
	nop			;5952
	nop			;5953
	nop			;5954
	nop			;5955
	nop			;5956
	nop			;5957
	nop			;5958
	nop			;5959
	nop			;595a
	nop			;595b
	nop			;595c
	nop			;595d
	nop			;595e
	nop			;595f
	nop			;5960
	nop			;5961
	nop			;5962
	nop			;5963
	nop			;5964
	nop			;5965
	nop			;5966
	nop			;5967
	nop			;5968
	nop			;5969
	nop			;596a
	nop			;596b
	nop			;596c
	nop			;596d
	nop			;596e
	nop			;596f
	nop			;5970
	nop			;5971
	nop			;5972
	nop			;5973
	nop			;5974
	nop			;5975
	nop			;5976
	nop			;5977
	nop			;5978
	nop			;5979
	nop			;597a
	nop			;597b
	nop			;597c
	nop			;597d
	nop			;597e
	nop			;597f
	nop			;5980
	nop			;5981
	nop			;5982
	nop			;5983
	nop			;5984
	nop			;5985
	nop			;5986
	nop			;5987
	nop			;5988
	nop			;5989
	nop			;598a
	nop			;598b
	nop			;598c
	nop			;598d
	nop			;598e
	nop			;598f
	nop			;5990
	nop			;5991
	nop			;5992
	nop			;5993
	nop			;5994
	nop			;5995
	nop			;5996
	nop			;5997
	nop			;5998
	nop			;5999
	nop			;599a
	nop			;599b
	nop			;599c
	nop			;599d
	nop			;599e
	nop			;599f
	nop			;59a0
	nop			;59a1
	nop			;59a2
	nop			;59a3
	nop			;59a4
	nop			;59a5
	nop			;59a6
	nop			;59a7
	nop			;59a8
	nop			;59a9
	nop			;59aa
	nop			;59ab
	nop			;59ac
	nop			;59ad
	nop			;59ae
	nop			;59af
	nop			;59b0
	nop			;59b1
	nop			;59b2
	nop			;59b3
	nop			;59b4
	nop			;59b5
	nop			;59b6
	nop			;59b7
	nop			;59b8
	nop			;59b9
	nop			;59ba
	nop			;59bb
	nop			;59bc
	nop			;59bd
	nop			;59be
	nop			;59bf
	nop			;59c0
	nop			;59c1
	nop			;59c2
	nop			;59c3
	nop			;59c4
	nop			;59c5
	nop			;59c6
	nop			;59c7
	nop			;59c8
	nop			;59c9
	nop			;59ca
	nop			;59cb
	nop			;59cc
	nop			;59cd
	nop			;59ce
	nop			;59cf
	nop			;59d0
	nop			;59d1
	nop			;59d2
	nop			;59d3
	nop			;59d4
	nop			;59d5
	nop			;59d6
	nop			;59d7
	nop			;59d8
	nop			;59d9
	nop			;59da
	nop			;59db
	nop			;59dc
	nop			;59dd
	nop			;59de
	nop			;59df
	nop			;59e0
	nop			;59e1
	nop			;59e2
	nop			;59e3
	nop			;59e4
	nop			;59e5
	nop			;59e6
	nop			;59e7
	nop			;59e8
	nop			;59e9
	nop			;59ea
	nop			;59eb
	nop			;59ec
	nop			;59ed
	nop			;59ee
	nop			;59ef
	nop			;59f0
	nop			;59f1
	nop			;59f2
	nop			;59f3
	nop			;59f4
	nop			;59f5
	nop			;59f6
	nop			;59f7
	nop			;59f8
	nop			;59f9
	nop			;59fa
	nop			;59fb
	nop			;59fc
	nop			;59fd
	nop			;59fe
	nop			;59ff
	nop			;5a00
	nop			;5a01
	nop			;5a02
	nop			;5a03
	nop			;5a04
	nop			;5a05
	nop			;5a06
	nop			;5a07
	nop			;5a08
	nop			;5a09
	nop			;5a0a
	nop			;5a0b
	nop			;5a0c
	nop			;5a0d
	nop			;5a0e
	nop			;5a0f
	nop			;5a10
	nop			;5a11
	nop			;5a12
	nop			;5a13
	nop			;5a14
	nop			;5a15
	nop			;5a16
	nop			;5a17
	nop			;5a18
	nop			;5a19
	nop			;5a1a
	nop			;5a1b
	nop			;5a1c
	nop			;5a1d
	nop			;5a1e
	nop			;5a1f
	nop			;5a20
	nop			;5a21
	nop			;5a22
	nop			;5a23
	nop			;5a24
	nop			;5a25
	nop			;5a26
	nop			;5a27
	nop			;5a28
	nop			;5a29
	nop			;5a2a
	nop			;5a2b
	nop			;5a2c
	nop			;5a2d
	nop			;5a2e
	nop			;5a2f
	nop			;5a30
	nop			;5a31
	nop			;5a32
	nop			;5a33
	nop			;5a34
	nop			;5a35
	nop			;5a36
	nop			;5a37
	nop			;5a38
	nop			;5a39
	nop			;5a3a
	nop			;5a3b
	nop			;5a3c
	nop			;5a3d
	nop			;5a3e
	nop			;5a3f
	nop			;5a40
	nop			;5a41
	nop			;5a42
	nop			;5a43
	nop			;5a44
	nop			;5a45
	nop			;5a46
	nop			;5a47
	nop			;5a48
	nop			;5a49
	nop			;5a4a
	nop			;5a4b
	nop			;5a4c
	nop			;5a4d
	nop			;5a4e
	nop			;5a4f
	nop			;5a50
	nop			;5a51
	nop			;5a52
	nop			;5a53
	nop			;5a54
	nop			;5a55
	nop			;5a56
	nop			;5a57
	nop			;5a58
	nop			;5a59
	nop			;5a5a
	nop			;5a5b
	nop			;5a5c
	nop			;5a5d
	nop			;5a5e
	nop			;5a5f
	nop			;5a60
	nop			;5a61
	nop			;5a62
	nop			;5a63
	nop			;5a64
	nop			;5a65
	nop			;5a66
	nop			;5a67
	nop			;5a68
	nop			;5a69
	nop			;5a6a
	nop			;5a6b
	nop			;5a6c
	nop			;5a6d
	nop			;5a6e
	nop			;5a6f
	nop			;5a70
	nop			;5a71
	nop			;5a72
	nop			;5a73
	nop			;5a74
	nop			;5a75
	nop			;5a76
	nop			;5a77
	nop			;5a78
	nop			;5a79
	nop			;5a7a
	nop			;5a7b
	nop			;5a7c
	nop			;5a7d
	nop			;5a7e
	nop			;5a7f
	nop			;5a80
	nop			;5a81
	nop			;5a82
	nop			;5a83
	nop			;5a84
	nop			;5a85
	nop			;5a86
	nop			;5a87
	nop			;5a88
	nop			;5a89
	nop			;5a8a
	nop			;5a8b
	nop			;5a8c
	nop			;5a8d
	nop			;5a8e
	nop			;5a8f
	nop			;5a90
	nop			;5a91
	nop			;5a92
	nop			;5a93
	nop			;5a94
	nop			;5a95
	nop			;5a96
	nop			;5a97
	nop			;5a98
	nop			;5a99
	nop			;5a9a
	nop			;5a9b
	nop			;5a9c
	nop			;5a9d
	nop			;5a9e
	nop			;5a9f
	nop			;5aa0
	nop			;5aa1
	nop			;5aa2
	nop			;5aa3
	nop			;5aa4
	nop			;5aa5
	nop			;5aa6
	nop			;5aa7
	nop			;5aa8
	nop			;5aa9
	nop			;5aaa
	nop			;5aab
	nop			;5aac
	nop			;5aad
	nop			;5aae
	nop			;5aaf
	nop			;5ab0
	nop			;5ab1
	nop			;5ab2
	nop			;5ab3
	nop			;5ab4
	nop			;5ab5
	nop			;5ab6
	nop			;5ab7
	nop			;5ab8
	nop			;5ab9
	nop			;5aba
	nop			;5abb
	nop			;5abc
	nop			;5abd
	nop			;5abe
	nop			;5abf
	nop			;5ac0
	nop			;5ac1
	nop			;5ac2
	nop			;5ac3
	nop			;5ac4
	nop			;5ac5
	nop			;5ac6
	nop			;5ac7
	nop			;5ac8
	nop			;5ac9
	nop			;5aca
	nop			;5acb
	nop			;5acc
	nop			;5acd
	nop			;5ace
	nop			;5acf
	nop			;5ad0
	nop			;5ad1
	nop			;5ad2
	nop			;5ad3
	nop			;5ad4
	nop			;5ad5
	nop			;5ad6
	nop			;5ad7
	nop			;5ad8
	nop			;5ad9
	nop			;5ada
	nop			;5adb
	nop			;5adc
	nop			;5add
	nop			;5ade
	nop			;5adf
	nop			;5ae0
	nop			;5ae1
	nop			;5ae2
	nop			;5ae3
	nop			;5ae4
	nop			;5ae5
	nop			;5ae6
	nop			;5ae7
	nop			;5ae8
	nop			;5ae9
	nop			;5aea
	nop			;5aeb
	nop			;5aec
	nop			;5aed
	nop			;5aee
	nop			;5aef
	nop			;5af0
	nop			;5af1
	nop			;5af2
	nop			;5af3
	nop			;5af4
	nop			;5af5
	nop			;5af6
	nop			;5af7
	nop			;5af8
	nop			;5af9
	nop			;5afa
	nop			;5afb
	nop			;5afc
	nop			;5afd
	nop			;5afe
	nop			;5aff
	nop			;5b00
	nop			;5b01
	nop			;5b02
	nop			;5b03
	nop			;5b04
	nop			;5b05
	nop			;5b06
	nop			;5b07
	nop			;5b08
	nop			;5b09
	nop			;5b0a
	nop			;5b0b
	nop			;5b0c
	nop			;5b0d
	nop			;5b0e
	nop			;5b0f
	nop			;5b10
	nop			;5b11
	nop			;5b12
	nop			;5b13
	nop			;5b14
	nop			;5b15
	nop			;5b16
	nop			;5b17
	nop			;5b18
	nop			;5b19
	nop			;5b1a
	nop			;5b1b
	nop			;5b1c
	nop			;5b1d
	nop			;5b1e
	nop			;5b1f
	nop			;5b20
	nop			;5b21
	nop			;5b22
	nop			;5b23
	nop			;5b24
	nop			;5b25
	nop			;5b26
	nop			;5b27
	nop			;5b28
	nop			;5b29
	nop			;5b2a
	nop			;5b2b
	nop			;5b2c
	nop			;5b2d
	nop			;5b2e
	nop			;5b2f
	nop			;5b30
	nop			;5b31
	nop			;5b32
	nop			;5b33
	nop			;5b34
	nop			;5b35
	nop			;5b36
	nop			;5b37
	nop			;5b38
	nop			;5b39
	nop			;5b3a
	nop			;5b3b
	nop			;5b3c
	nop			;5b3d
	nop			;5b3e
	nop			;5b3f
	nop			;5b40
	nop			;5b41
	nop			;5b42
	nop			;5b43
	nop			;5b44
	nop			;5b45
	nop			;5b46
	nop			;5b47
	nop			;5b48
	nop			;5b49
	nop			;5b4a
	nop			;5b4b
	nop			;5b4c
	nop			;5b4d
	nop			;5b4e
	nop			;5b4f
	nop			;5b50
	nop			;5b51
	nop			;5b52
	nop			;5b53
	nop			;5b54
	nop			;5b55
	nop			;5b56
	nop			;5b57
	nop			;5b58
	nop			;5b59
	nop			;5b5a
	nop			;5b5b
	nop			;5b5c
	nop			;5b5d
	nop			;5b5e
	nop			;5b5f
	nop			;5b60
	nop			;5b61
	nop			;5b62
	nop			;5b63
	nop			;5b64
	nop			;5b65
	nop			;5b66
	nop			;5b67
	nop			;5b68
	nop			;5b69
	nop			;5b6a
	nop			;5b6b
	nop			;5b6c
	nop			;5b6d
	nop			;5b6e
	nop			;5b6f
	nop			;5b70
	nop			;5b71
	nop			;5b72
	nop			;5b73
	nop			;5b74
	nop			;5b75
	nop			;5b76
	nop			;5b77
	nop			;5b78
	nop			;5b79
	nop			;5b7a
	nop			;5b7b
	nop			;5b7c
	nop			;5b7d
	nop			;5b7e
	nop			;5b7f
	nop			;5b80
	nop			;5b81
	nop			;5b82
	nop			;5b83
	nop			;5b84
	nop			;5b85
	nop			;5b86
	nop			;5b87
	nop			;5b88
	nop			;5b89
	nop			;5b8a
	nop			;5b8b
	nop			;5b8c
	nop			;5b8d
	nop			;5b8e
	nop			;5b8f
	nop			;5b90
	nop			;5b91
	nop			;5b92
	nop			;5b93
	nop			;5b94
	nop			;5b95
	nop			;5b96
	nop			;5b97
	nop			;5b98
	nop			;5b99
	nop			;5b9a
	nop			;5b9b
	nop			;5b9c
	nop			;5b9d
	nop			;5b9e
	nop			;5b9f
	nop			;5ba0
	nop			;5ba1
	nop			;5ba2
	nop			;5ba3
	nop			;5ba4
	nop			;5ba5
	nop			;5ba6
	nop			;5ba7
	nop			;5ba8
	nop			;5ba9
	nop			;5baa
	nop			;5bab
	nop			;5bac
	nop			;5bad
	nop			;5bae
	nop			;5baf
	nop			;5bb0
	nop			;5bb1
	nop			;5bb2
	nop			;5bb3
	nop			;5bb4
	nop			;5bb5
	nop			;5bb6
	nop			;5bb7
	nop			;5bb8
	nop			;5bb9
	nop			;5bba
	nop			;5bbb
	nop			;5bbc
	nop			;5bbd
	nop			;5bbe
	nop			;5bbf
	nop			;5bc0
	nop			;5bc1
	nop			;5bc2
	nop			;5bc3
	nop			;5bc4
	nop			;5bc5
	nop			;5bc6
	nop			;5bc7
	nop			;5bc8
	nop			;5bc9
	nop			;5bca
	nop			;5bcb
	nop			;5bcc
	nop			;5bcd
	nop			;5bce
	nop			;5bcf
	nop			;5bd0
	nop			;5bd1
	nop			;5bd2
	nop			;5bd3
	nop			;5bd4
	nop			;5bd5
	nop			;5bd6
	nop			;5bd7
	nop			;5bd8
	nop			;5bd9
	nop			;5bda
	nop			;5bdb
	nop			;5bdc
	nop			;5bdd
	nop			;5bde
	nop			;5bdf
	nop			;5be0
	nop			;5be1
	nop			;5be2
	nop			;5be3
	nop			;5be4
	nop			;5be5
	nop			;5be6
	nop			;5be7
	nop			;5be8
	nop			;5be9
	nop			;5bea
	nop			;5beb
	nop			;5bec
	nop			;5bed
	nop			;5bee
	nop			;5bef
	nop			;5bf0
	nop			;5bf1
	nop			;5bf2
	nop			;5bf3
	nop			;5bf4
	nop			;5bf5
	nop			;5bf6
	nop			;5bf7
	nop			;5bf8
	nop			;5bf9
	nop			;5bfa
	nop			;5bfb
	nop			;5bfc
	nop			;5bfd
	nop			;5bfe
	nop			;5bff
	nop			;5c00
	nop			;5c01
	nop			;5c02
	nop			;5c03
	nop			;5c04
	nop			;5c05
	nop			;5c06
	nop			;5c07
	nop			;5c08
	nop			;5c09
	nop			;5c0a
	nop			;5c0b
	nop			;5c0c
	nop			;5c0d
	nop			;5c0e
	nop			;5c0f
	nop			;5c10
	nop			;5c11
	nop			;5c12
	nop			;5c13
	nop			;5c14
	nop			;5c15
	nop			;5c16
	nop			;5c17
	nop			;5c18
	nop			;5c19
	nop			;5c1a
	nop			;5c1b
	nop			;5c1c
	nop			;5c1d
	nop			;5c1e
	nop			;5c1f
	nop			;5c20
	nop			;5c21
	nop			;5c22
	nop			;5c23
	nop			;5c24
	nop			;5c25
	nop			;5c26
	nop			;5c27
	nop			;5c28
	nop			;5c29
	nop			;5c2a
	nop			;5c2b
	nop			;5c2c
	nop			;5c2d
	nop			;5c2e
	nop			;5c2f
	nop			;5c30
	nop			;5c31
	nop			;5c32
	nop			;5c33
	nop			;5c34
	nop			;5c35
	nop			;5c36
	nop			;5c37
	nop			;5c38
	nop			;5c39
	nop			;5c3a
	nop			;5c3b
	nop			;5c3c
	nop			;5c3d
	nop			;5c3e
	nop			;5c3f
	nop			;5c40
	nop			;5c41
	nop			;5c42
	nop			;5c43
	nop			;5c44
	nop			;5c45
	nop			;5c46
	nop			;5c47
	nop			;5c48
	nop			;5c49
	nop			;5c4a
	nop			;5c4b
	nop			;5c4c
	nop			;5c4d
	nop			;5c4e
	nop			;5c4f
	nop			;5c50
	nop			;5c51
	nop			;5c52
	nop			;5c53
	nop			;5c54
	nop			;5c55
	nop			;5c56
	nop			;5c57
	nop			;5c58
	nop			;5c59
	nop			;5c5a
	nop			;5c5b
	nop			;5c5c
	nop			;5c5d
	nop			;5c5e
	nop			;5c5f
	nop			;5c60
	nop			;5c61
	nop			;5c62
	nop			;5c63
	nop			;5c64
	nop			;5c65
	nop			;5c66
	nop			;5c67
	nop			;5c68
	nop			;5c69
	nop			;5c6a
	nop			;5c6b
	nop			;5c6c
	nop			;5c6d
	nop			;5c6e
	nop			;5c6f
	nop			;5c70
	nop			;5c71
	nop			;5c72
	nop			;5c73
	nop			;5c74
	nop			;5c75
	nop			;5c76
	nop			;5c77
	nop			;5c78
	nop			;5c79
	nop			;5c7a
	nop			;5c7b
	nop			;5c7c
	nop			;5c7d
	nop			;5c7e
	nop			;5c7f
	nop			;5c80
	nop			;5c81
	nop			;5c82
	nop			;5c83
	nop			;5c84
	nop			;5c85
	nop			;5c86
	nop			;5c87
	nop			;5c88
	nop			;5c89
	nop			;5c8a
	nop			;5c8b
	nop			;5c8c
	nop			;5c8d
	nop			;5c8e
	nop			;5c8f
	nop			;5c90
	nop			;5c91
	nop			;5c92
	nop			;5c93
	nop			;5c94
	nop			;5c95
	nop			;5c96
	nop			;5c97
	nop			;5c98
	nop			;5c99
	nop			;5c9a
	nop			;5c9b
	nop			;5c9c
	nop			;5c9d
	nop			;5c9e
	nop			;5c9f
	nop			;5ca0
	nop			;5ca1
	nop			;5ca2
	nop			;5ca3
	nop			;5ca4
	nop			;5ca5
	nop			;5ca6
	nop			;5ca7
	nop			;5ca8
	nop			;5ca9
	nop			;5caa
	nop			;5cab
	nop			;5cac
	nop			;5cad
	nop			;5cae
	nop			;5caf
	nop			;5cb0
	nop			;5cb1
	nop			;5cb2
	nop			;5cb3
	nop			;5cb4
	nop			;5cb5
	nop			;5cb6
	nop			;5cb7
	nop			;5cb8
	nop			;5cb9
	nop			;5cba
	nop			;5cbb
	nop			;5cbc
	nop			;5cbd
	nop			;5cbe
	nop			;5cbf
	nop			;5cc0
	nop			;5cc1
	nop			;5cc2
	nop			;5cc3
	nop			;5cc4
	nop			;5cc5
	nop			;5cc6
	nop			;5cc7
	nop			;5cc8
	nop			;5cc9
	nop			;5cca
	nop			;5ccb
	nop			;5ccc
	nop			;5ccd
	nop			;5cce
	nop			;5ccf
	nop			;5cd0
	nop			;5cd1
	nop			;5cd2
	nop			;5cd3
	nop			;5cd4
	nop			;5cd5
	nop			;5cd6
	nop			;5cd7
	nop			;5cd8
	nop			;5cd9
	nop			;5cda
	nop			;5cdb
	nop			;5cdc
	nop			;5cdd
	nop			;5cde
	nop			;5cdf
	nop			;5ce0
	nop			;5ce1
	nop			;5ce2
	nop			;5ce3
	nop			;5ce4
	nop			;5ce5
	nop			;5ce6
	nop			;5ce7
	nop			;5ce8
	nop			;5ce9
	nop			;5cea
	nop			;5ceb
	nop			;5cec
	nop			;5ced
	nop			;5cee
	nop			;5cef
	nop			;5cf0
	nop			;5cf1
	nop			;5cf2
	nop			;5cf3
	nop			;5cf4
	nop			;5cf5
	nop			;5cf6
	nop			;5cf7
	nop			;5cf8
	nop			;5cf9
	nop			;5cfa
	nop			;5cfb
	nop			;5cfc
	nop			;5cfd
	nop			;5cfe
	nop			;5cff
	nop			;5d00
	nop			;5d01
	nop			;5d02
	nop			;5d03
	nop			;5d04
	nop			;5d05
	nop			;5d06
	nop			;5d07
	nop			;5d08
	nop			;5d09
	nop			;5d0a
	nop			;5d0b
	nop			;5d0c
	nop			;5d0d
	nop			;5d0e
	nop			;5d0f
	nop			;5d10
	nop			;5d11
	nop			;5d12
	nop			;5d13
	nop			;5d14
	nop			;5d15
	nop			;5d16
	nop			;5d17
	nop			;5d18
	nop			;5d19
	nop			;5d1a
	nop			;5d1b
	nop			;5d1c
	nop			;5d1d
	nop			;5d1e
	nop			;5d1f
	nop			;5d20
	nop			;5d21
	nop			;5d22
	nop			;5d23
	nop			;5d24
	nop			;5d25
	nop			;5d26
	nop			;5d27
	nop			;5d28
	nop			;5d29
	nop			;5d2a
	nop			;5d2b
	nop			;5d2c
	nop			;5d2d
	nop			;5d2e
	nop			;5d2f
	nop			;5d30
	nop			;5d31
	nop			;5d32
	nop			;5d33
	nop			;5d34
	nop			;5d35
	nop			;5d36
	nop			;5d37
	nop			;5d38
	nop			;5d39
	nop			;5d3a
	nop			;5d3b
	nop			;5d3c
	nop			;5d3d
	nop			;5d3e
	nop			;5d3f
	nop			;5d40
	nop			;5d41
	nop			;5d42
	nop			;5d43
	nop			;5d44
	nop			;5d45
	nop			;5d46
	nop			;5d47
	nop			;5d48
	nop			;5d49
	nop			;5d4a
	nop			;5d4b
	nop			;5d4c
	nop			;5d4d
	nop			;5d4e
	nop			;5d4f
	nop			;5d50
	nop			;5d51
	nop			;5d52
	nop			;5d53
	nop			;5d54
	nop			;5d55
	nop			;5d56
	nop			;5d57
	nop			;5d58
	nop			;5d59
	nop			;5d5a
	nop			;5d5b
	nop			;5d5c
	nop			;5d5d
	nop			;5d5e
	nop			;5d5f
	nop			;5d60
	nop			;5d61
	nop			;5d62
	nop			;5d63
	nop			;5d64
	nop			;5d65
	nop			;5d66
	nop			;5d67
	nop			;5d68
	nop			;5d69
	nop			;5d6a
	nop			;5d6b
	nop			;5d6c
	nop			;5d6d
	nop			;5d6e
	nop			;5d6f
	nop			;5d70
	nop			;5d71
	nop			;5d72
	nop			;5d73
	nop			;5d74
	nop			;5d75
	nop			;5d76
	nop			;5d77
	nop			;5d78
	nop			;5d79
	nop			;5d7a
	nop			;5d7b
	nop			;5d7c
	nop			;5d7d
	nop			;5d7e
	nop			;5d7f
	nop			;5d80
	nop			;5d81
	nop			;5d82
	nop			;5d83
	nop			;5d84
	nop			;5d85
	nop			;5d86
	nop			;5d87
	nop			;5d88
	nop			;5d89
	nop			;5d8a
	nop			;5d8b
	nop			;5d8c
	nop			;5d8d
	nop			;5d8e
	nop			;5d8f
	nop			;5d90
	nop			;5d91
	nop			;5d92
	nop			;5d93
	nop			;5d94
	nop			;5d95
	nop			;5d96
	nop			;5d97
	nop			;5d98
	nop			;5d99
	nop			;5d9a
	nop			;5d9b
	nop			;5d9c
	nop			;5d9d
	nop			;5d9e
	nop			;5d9f
	nop			;5da0
	nop			;5da1
	nop			;5da2
	nop			;5da3
	nop			;5da4
	nop			;5da5
	nop			;5da6
	nop			;5da7
	nop			;5da8
	nop			;5da9
	nop			;5daa
	nop			;5dab
	nop			;5dac
	nop			;5dad
	nop			;5dae
	nop			;5daf
	nop			;5db0
	nop			;5db1
	nop			;5db2
	nop			;5db3
	nop			;5db4
	nop			;5db5
	nop			;5db6
	nop			;5db7
	nop			;5db8
	nop			;5db9
	nop			;5dba
	nop			;5dbb
	nop			;5dbc
	nop			;5dbd
	nop			;5dbe
	nop			;5dbf
	nop			;5dc0
	nop			;5dc1
	nop			;5dc2
	nop			;5dc3
	nop			;5dc4
	nop			;5dc5
	nop			;5dc6
	nop			;5dc7
	nop			;5dc8
	nop			;5dc9
	nop			;5dca
	nop			;5dcb
	nop			;5dcc
	nop			;5dcd
	nop			;5dce
	nop			;5dcf
	nop			;5dd0
	nop			;5dd1
	nop			;5dd2
	nop			;5dd3
	nop			;5dd4
	nop			;5dd5
	nop			;5dd6
	nop			;5dd7
	nop			;5dd8
	nop			;5dd9
	nop			;5dda
	nop			;5ddb
	nop			;5ddc
	nop			;5ddd
	nop			;5dde
	nop			;5ddf
	nop			;5de0
	nop			;5de1
	nop			;5de2
	nop			;5de3
	nop			;5de4
	nop			;5de5
	nop			;5de6
	nop			;5de7
	nop			;5de8
	nop			;5de9
	nop			;5dea
	nop			;5deb
	nop			;5dec
	nop			;5ded
	nop			;5dee
	nop			;5def
	nop			;5df0
	nop			;5df1
	nop			;5df2
	nop			;5df3
	nop			;5df4
	nop			;5df5
	nop			;5df6
	nop			;5df7
	nop			;5df8
	nop			;5df9
	nop			;5dfa
	nop			;5dfb
	nop			;5dfc
	nop			;5dfd
	nop			;5dfe
	nop			;5dff
	nop			;5e00
	nop			;5e01
	nop			;5e02
	nop			;5e03
	nop			;5e04
	nop			;5e05
	nop			;5e06
	nop			;5e07
	nop			;5e08
	nop			;5e09
	nop			;5e0a
	nop			;5e0b
	nop			;5e0c
	nop			;5e0d
	nop			;5e0e
	nop			;5e0f
	nop			;5e10
	nop			;5e11
	nop			;5e12
	nop			;5e13
	nop			;5e14
	nop			;5e15
	nop			;5e16
	nop			;5e17
	nop			;5e18
	nop			;5e19
	nop			;5e1a
	nop			;5e1b
	nop			;5e1c
	nop			;5e1d
	nop			;5e1e
	nop			;5e1f
	nop			;5e20
	nop			;5e21
	nop			;5e22
	nop			;5e23
	nop			;5e24
	nop			;5e25
	nop			;5e26
	nop			;5e27
	nop			;5e28
	nop			;5e29
	nop			;5e2a
	nop			;5e2b
	nop			;5e2c
	nop			;5e2d
	nop			;5e2e
	nop			;5e2f
	nop			;5e30
	nop			;5e31
	nop			;5e32
	nop			;5e33
	nop			;5e34
	nop			;5e35
	nop			;5e36
	nop			;5e37
	nop			;5e38
	nop			;5e39
	nop			;5e3a
	nop			;5e3b
	nop			;5e3c
	nop			;5e3d
	nop			;5e3e
	nop			;5e3f
	nop			;5e40
	nop			;5e41
	nop			;5e42
	nop			;5e43
	nop			;5e44
	nop			;5e45
	nop			;5e46
	nop			;5e47
	nop			;5e48
	nop			;5e49
	nop			;5e4a
	nop			;5e4b
	nop			;5e4c
	nop			;5e4d
	nop			;5e4e
	nop			;5e4f
	nop			;5e50
	nop			;5e51
	nop			;5e52
	nop			;5e53
	nop			;5e54
	nop			;5e55
	nop			;5e56
	nop			;5e57
	nop			;5e58
	nop			;5e59
	nop			;5e5a
	nop			;5e5b
	nop			;5e5c
	nop			;5e5d
	nop			;5e5e
	nop			;5e5f
	nop			;5e60
	nop			;5e61
	nop			;5e62
	nop			;5e63
	nop			;5e64
	nop			;5e65
	nop			;5e66
	nop			;5e67
	nop			;5e68
	nop			;5e69
	nop			;5e6a
	nop			;5e6b
	nop			;5e6c
	nop			;5e6d
	nop			;5e6e
	nop			;5e6f
	nop			;5e70
	nop			;5e71
	nop			;5e72
	nop			;5e73
	nop			;5e74
	nop			;5e75
	nop			;5e76
	nop			;5e77
	nop			;5e78
	nop			;5e79
	nop			;5e7a
	nop			;5e7b
	nop			;5e7c
	nop			;5e7d
	nop			;5e7e
	nop			;5e7f
	nop			;5e80
	nop			;5e81
	nop			;5e82
	nop			;5e83
	nop			;5e84
	nop			;5e85
	nop			;5e86
	nop			;5e87
	nop			;5e88
	nop			;5e89
	nop			;5e8a
	nop			;5e8b
	nop			;5e8c
	nop			;5e8d
	nop			;5e8e
	nop			;5e8f
	nop			;5e90
	nop			;5e91
	nop			;5e92
	nop			;5e93
	nop			;5e94
	nop			;5e95
	nop			;5e96
	nop			;5e97
	nop			;5e98
	nop			;5e99
	nop			;5e9a
	nop			;5e9b
	nop			;5e9c
	nop			;5e9d
	nop			;5e9e
	nop			;5e9f
	nop			;5ea0
	nop			;5ea1
	nop			;5ea2
	nop			;5ea3
	nop			;5ea4
	nop			;5ea5
	nop			;5ea6
	nop			;5ea7
	nop			;5ea8
	nop			;5ea9
	nop			;5eaa
	nop			;5eab
	nop			;5eac
	nop			;5ead
	nop			;5eae
	nop			;5eaf
	nop			;5eb0
	nop			;5eb1
	nop			;5eb2
	nop			;5eb3
	nop			;5eb4
	nop			;5eb5
	nop			;5eb6
	nop			;5eb7
	nop			;5eb8
	nop			;5eb9
	nop			;5eba
	nop			;5ebb
	nop			;5ebc
	nop			;5ebd
	nop			;5ebe
	nop			;5ebf
	nop			;5ec0
	nop			;5ec1
	nop			;5ec2
	nop			;5ec3
	nop			;5ec4
	nop			;5ec5
	nop			;5ec6
	nop			;5ec7
	nop			;5ec8
	nop			;5ec9
	nop			;5eca
	nop			;5ecb
	nop			;5ecc
	nop			;5ecd
	nop			;5ece
	nop			;5ecf
	nop			;5ed0
	nop			;5ed1
	nop			;5ed2
	nop			;5ed3
	nop			;5ed4
	nop			;5ed5
	nop			;5ed6
	nop			;5ed7
	nop			;5ed8
	nop			;5ed9
	nop			;5eda
	nop			;5edb
	nop			;5edc
	nop			;5edd
	nop			;5ede
	nop			;5edf
	nop			;5ee0
	nop			;5ee1
	nop			;5ee2
	nop			;5ee3
	nop			;5ee4
	nop			;5ee5
	nop			;5ee6
	nop			;5ee7
	nop			;5ee8
	nop			;5ee9
	nop			;5eea
	nop			;5eeb
	nop			;5eec
	nop			;5eed
	nop			;5eee
	nop			;5eef
	nop			;5ef0
	nop			;5ef1
	nop			;5ef2
	nop			;5ef3
	nop			;5ef4
	nop			;5ef5
	nop			;5ef6
	nop			;5ef7
	nop			;5ef8
	nop			;5ef9
	nop			;5efa
	nop			;5efb
	nop			;5efc
	nop			;5efd
	nop			;5efe
	nop			;5eff
	nop			;5f00
	nop			;5f01
	nop			;5f02
	nop			;5f03
	nop			;5f04
	nop			;5f05
	nop			;5f06
	nop			;5f07
	nop			;5f08
	nop			;5f09
	nop			;5f0a
	nop			;5f0b
	nop			;5f0c
	nop			;5f0d
	nop			;5f0e
	nop			;5f0f
	nop			;5f10
	nop			;5f11
	nop			;5f12
	nop			;5f13
	nop			;5f14
	nop			;5f15
	nop			;5f16
	nop			;5f17
	nop			;5f18
	nop			;5f19
	nop			;5f1a
	nop			;5f1b
	nop			;5f1c
	nop			;5f1d
	nop			;5f1e
	nop			;5f1f
	nop			;5f20
	nop			;5f21
	nop			;5f22
	nop			;5f23
	nop			;5f24
	nop			;5f25
	nop			;5f26
	nop			;5f27
	nop			;5f28
	nop			;5f29
	nop			;5f2a
	nop			;5f2b
	nop			;5f2c
	nop			;5f2d
	nop			;5f2e
	nop			;5f2f
	nop			;5f30
	nop			;5f31
	nop			;5f32
	nop			;5f33
	nop			;5f34
	nop			;5f35
	nop			;5f36
	nop			;5f37
	nop			;5f38
	nop			;5f39
	nop			;5f3a
	nop			;5f3b
	nop			;5f3c
	nop			;5f3d
	nop			;5f3e
	nop			;5f3f
	nop			;5f40
	nop			;5f41
	nop			;5f42
	nop			;5f43
	nop			;5f44
	nop			;5f45
	nop			;5f46
	nop			;5f47
	nop			;5f48
	nop			;5f49
	nop			;5f4a
	nop			;5f4b
	nop			;5f4c
	nop			;5f4d
	nop			;5f4e
	nop			;5f4f
	nop			;5f50
	nop			;5f51
	nop			;5f52
	nop			;5f53
	nop			;5f54
	nop			;5f55
	nop			;5f56
	nop			;5f57
	nop			;5f58
	nop			;5f59
	nop			;5f5a
	nop			;5f5b
	nop			;5f5c
	nop			;5f5d
	nop			;5f5e
	nop			;5f5f
	nop			;5f60
	nop			;5f61
	nop			;5f62
	nop			;5f63
	nop			;5f64
	nop			;5f65
	nop			;5f66
	nop			;5f67
	nop			;5f68
	nop			;5f69
	nop			;5f6a
	nop			;5f6b
	nop			;5f6c
	nop			;5f6d
	nop			;5f6e
	nop			;5f6f
	nop			;5f70
	nop			;5f71
	nop			;5f72
	nop			;5f73
	nop			;5f74
	nop			;5f75
	nop			;5f76
	nop			;5f77
	nop			;5f78
	nop			;5f79
	nop			;5f7a
	nop			;5f7b
	nop			;5f7c
	nop			;5f7d
	nop			;5f7e
	nop			;5f7f
	nop			;5f80
	nop			;5f81
	nop			;5f82
	nop			;5f83
	nop			;5f84
	nop			;5f85
	nop			;5f86
	nop			;5f87
	nop			;5f88
	nop			;5f89
	nop			;5f8a
	nop			;5f8b
	nop			;5f8c
	nop			;5f8d
	nop			;5f8e
	nop			;5f8f
	nop			;5f90
	nop			;5f91
	nop			;5f92
	nop			;5f93
	nop			;5f94
	nop			;5f95
	nop			;5f96
	nop			;5f97
	nop			;5f98
	nop			;5f99
	nop			;5f9a
	nop			;5f9b
	nop			;5f9c
	nop			;5f9d
	nop			;5f9e
	nop			;5f9f
	nop			;5fa0
	nop			;5fa1
	nop			;5fa2
	nop			;5fa3
	nop			;5fa4
	nop			;5fa5
	nop			;5fa6
	nop			;5fa7
	nop			;5fa8
	nop			;5fa9
	nop			;5faa
	nop			;5fab
	nop			;5fac
	nop			;5fad
	nop			;5fae
	nop			;5faf
	nop			;5fb0
	nop			;5fb1
	nop			;5fb2
	nop			;5fb3
	nop			;5fb4
	nop			;5fb5
	nop			;5fb6
	nop			;5fb7
	nop			;5fb8
	nop			;5fb9
	nop			;5fba
	nop			;5fbb
	nop			;5fbc
	nop			;5fbd
	nop			;5fbe
	nop			;5fbf
	nop			;5fc0
	nop			;5fc1
	nop			;5fc2
	nop			;5fc3
	nop			;5fc4
	nop			;5fc5
	nop			;5fc6
	nop			;5fc7
	nop			;5fc8
	nop			;5fc9
	nop			;5fca
	nop			;5fcb
	nop			;5fcc
	nop			;5fcd
	nop			;5fce
	nop			;5fcf
	nop			;5fd0
	nop			;5fd1
	nop			;5fd2
	nop			;5fd3
	nop			;5fd4
	nop			;5fd5
	nop			;5fd6
	nop			;5fd7
	nop			;5fd8
	nop			;5fd9
	nop			;5fda
	nop			;5fdb
	nop			;5fdc
	nop			;5fdd
	nop			;5fde
	nop			;5fdf
	nop			;5fe0
	nop			;5fe1
	nop			;5fe2
	nop			;5fe3
	nop			;5fe4
	nop			;5fe5
	nop			;5fe6
	nop			;5fe7
	nop			;5fe8
	nop			;5fe9
	nop			;5fea
	nop			;5feb
	nop			;5fec
	nop			;5fed
	nop			;5fee
	nop			;5fef
	nop			;5ff0
	nop			;5ff1
	nop			;5ff2
	nop			;5ff3
	nop			;5ff4
	nop			;5ff5
	nop			;5ff6
	nop			;5ff7
	nop			;5ff8
	nop			;5ff9
	nop			;5ffa
	nop			;5ffb
	nop			;5ffc
	nop			;5ffd
	nop			;5ffe
	nop			;5fff
	nop			;6000
	nop			;6001
	nop			;6002
	nop			;6003
	nop			;6004
	nop			;6005
	nop			;6006
	nop			;6007
	nop			;6008
	nop			;6009
	nop			;600a
	nop			;600b
	nop			;600c
	nop			;600d
	nop			;600e
	nop			;600f
	nop			;6010
	nop			;6011
	nop			;6012
	nop			;6013
	nop			;6014
	nop			;6015
	nop			;6016
	nop			;6017
	nop			;6018
	nop			;6019
	nop			;601a
	nop			;601b
	nop			;601c
	nop			;601d
	nop			;601e
	nop			;601f
	nop			;6020
	nop			;6021
	nop			;6022
	nop			;6023
	nop			;6024
	nop			;6025
	nop			;6026
	nop			;6027
	nop			;6028
	nop			;6029
	nop			;602a
	nop			;602b
	nop			;602c
	nop			;602d
	nop			;602e
	nop			;602f
	nop			;6030
	nop			;6031
	nop			;6032
	nop			;6033
	nop			;6034
	nop			;6035
	nop			;6036
	nop			;6037
	nop			;6038
	nop			;6039
	nop			;603a
	nop			;603b
	nop			;603c
	nop			;603d
	nop			;603e
	nop			;603f
	nop			;6040
	nop			;6041
	nop			;6042
	nop			;6043
	nop			;6044
	nop			;6045
	nop			;6046
	nop			;6047
	nop			;6048
	nop			;6049
	nop			;604a
	nop			;604b
	nop			;604c
	nop			;604d
	nop			;604e
	nop			;604f
	nop			;6050
	nop			;6051
	nop			;6052
	nop			;6053
	nop			;6054
	nop			;6055
	nop			;6056
	nop			;6057
	nop			;6058
	nop			;6059
	nop			;605a
	nop			;605b
	nop			;605c
	nop			;605d
	nop			;605e
	nop			;605f
	nop			;6060
	nop			;6061
	nop			;6062
	nop			;6063
	nop			;6064
	nop			;6065
	nop			;6066
	nop			;6067
	nop			;6068
	nop			;6069
	nop			;606a
	nop			;606b
	nop			;606c
	nop			;606d
	nop			;606e
	nop			;606f
	nop			;6070
	nop			;6071
	nop			;6072
	nop			;6073
	nop			;6074
	nop			;6075
	nop			;6076
	nop			;6077
	nop			;6078
	nop			;6079
	nop			;607a
	nop			;607b
	nop			;607c
	nop			;607d
	nop			;607e
	nop			;607f
	nop			;6080
	nop			;6081
	nop			;6082
	nop			;6083
	nop			;6084
	nop			;6085
	nop			;6086
	nop			;6087
	nop			;6088
	nop			;6089
	nop			;608a
	nop			;608b
	nop			;608c
	nop			;608d
	nop			;608e
	nop			;608f
	nop			;6090
	nop			;6091
	nop			;6092
	nop			;6093
	nop			;6094
	nop			;6095
	nop			;6096
	nop			;6097
	nop			;6098
	nop			;6099
	nop			;609a
	nop			;609b
	nop			;609c
	nop			;609d
	nop			;609e
	nop			;609f
	nop			;60a0
	nop			;60a1
	nop			;60a2
	nop			;60a3
	nop			;60a4
	nop			;60a5
	nop			;60a6
	nop			;60a7
	nop			;60a8
	nop			;60a9
	nop			;60aa
	nop			;60ab
	nop			;60ac
	nop			;60ad
	nop			;60ae
	nop			;60af
	nop			;60b0
	nop			;60b1
	nop			;60b2
	nop			;60b3
	nop			;60b4
	nop			;60b5
	nop			;60b6
	nop			;60b7
	nop			;60b8
	nop			;60b9
	nop			;60ba
	nop			;60bb
	nop			;60bc
	nop			;60bd
	nop			;60be
	nop			;60bf
	nop			;60c0
	nop			;60c1
	nop			;60c2
	nop			;60c3
	nop			;60c4
	nop			;60c5
	nop			;60c6
	nop			;60c7
	nop			;60c8
	nop			;60c9
	nop			;60ca
	nop			;60cb
	nop			;60cc
	nop			;60cd
	nop			;60ce
	nop			;60cf
	nop			;60d0
	nop			;60d1
	nop			;60d2
	nop			;60d3
	nop			;60d4
	nop			;60d5
	nop			;60d6
	nop			;60d7
	nop			;60d8
	nop			;60d9
	nop			;60da
	nop			;60db
	nop			;60dc
	nop			;60dd
	nop			;60de
	nop			;60df
	nop			;60e0
	nop			;60e1
	nop			;60e2
	nop			;60e3
	nop			;60e4
	nop			;60e5
	nop			;60e6
	nop			;60e7
	nop			;60e8
	nop			;60e9
	nop			;60ea
	nop			;60eb
	nop			;60ec
	nop			;60ed
	nop			;60ee
	nop			;60ef
	nop			;60f0
	nop			;60f1
	nop			;60f2
	nop			;60f3
	nop			;60f4
	nop			;60f5
	nop			;60f6
	nop			;60f7
	nop			;60f8
	nop			;60f9
	nop			;60fa
	nop			;60fb
	nop			;60fc
	nop			;60fd
	nop			;60fe
	nop			;60ff
	nop			;6100
	nop			;6101
	nop			;6102
	nop			;6103
	nop			;6104
	nop			;6105
	nop			;6106
	nop			;6107
	nop			;6108
	nop			;6109
	nop			;610a
	nop			;610b
	nop			;610c
	nop			;610d
	nop			;610e
	nop			;610f
	nop			;6110
	nop			;6111
	nop			;6112
	nop			;6113
	nop			;6114
	nop			;6115
	nop			;6116
	nop			;6117
	nop			;6118
	nop			;6119
	nop			;611a
	nop			;611b
	nop			;611c
	nop			;611d
	nop			;611e
	nop			;611f
	nop			;6120
	nop			;6121
	nop			;6122
	nop			;6123
	nop			;6124
	nop			;6125
	nop			;6126
	nop			;6127
	nop			;6128
	nop			;6129
	nop			;612a
	nop			;612b
	nop			;612c
	nop			;612d
	nop			;612e
	nop			;612f
	nop			;6130
	nop			;6131
	nop			;6132
	nop			;6133
	nop			;6134
	nop			;6135
	nop			;6136
	nop			;6137
	nop			;6138
	nop			;6139
	nop			;613a
	nop			;613b
	nop			;613c
	nop			;613d
	nop			;613e
	nop			;613f
	nop			;6140
	nop			;6141
	nop			;6142
	nop			;6143
	nop			;6144
	nop			;6145
	nop			;6146
	nop			;6147
	nop			;6148
	nop			;6149
	nop			;614a
	nop			;614b
	nop			;614c
	nop			;614d
	nop			;614e
	nop			;614f
	nop			;6150
	nop			;6151
	nop			;6152
	nop			;6153
	nop			;6154
	nop			;6155
	nop			;6156
	nop			;6157
	nop			;6158
	nop			;6159
	nop			;615a
	nop			;615b
	nop			;615c
	nop			;615d
	nop			;615e
	nop			;615f
	nop			;6160
	nop			;6161
	nop			;6162
	nop			;6163
	nop			;6164
	nop			;6165
	nop			;6166
	nop			;6167
	nop			;6168
	nop			;6169
	nop			;616a
	nop			;616b
	nop			;616c
	nop			;616d
	nop			;616e
	nop			;616f
	nop			;6170
	nop			;6171
	nop			;6172
	nop			;6173
	nop			;6174
	nop			;6175
	nop			;6176
	nop			;6177
	nop			;6178
	nop			;6179
	nop			;617a
	nop			;617b
	nop			;617c
	nop			;617d
	nop			;617e
	nop			;617f
	nop			;6180
	nop			;6181
	nop			;6182
	nop			;6183
	nop			;6184
	nop			;6185
	nop			;6186
	nop			;6187
	nop			;6188
	nop			;6189
	nop			;618a
	nop			;618b
	nop			;618c
	nop			;618d
	nop			;618e
	nop			;618f
	nop			;6190
	nop			;6191
	nop			;6192
	nop			;6193
	nop			;6194
	nop			;6195
	nop			;6196
	nop			;6197
	nop			;6198
	nop			;6199
	nop			;619a
	nop			;619b
	nop			;619c
	nop			;619d
	nop			;619e
	nop			;619f
	nop			;61a0
	nop			;61a1
	nop			;61a2
	nop			;61a3
	nop			;61a4
	nop			;61a5
	nop			;61a6
	nop			;61a7
	nop			;61a8
	nop			;61a9
	nop			;61aa
	nop			;61ab
	nop			;61ac
	nop			;61ad
	nop			;61ae
	nop			;61af
	nop			;61b0
	nop			;61b1
	nop			;61b2
	nop			;61b3
	nop			;61b4
	nop			;61b5
	nop			;61b6
	nop			;61b7
	nop			;61b8
	nop			;61b9
	nop			;61ba
	nop			;61bb
	nop			;61bc
	nop			;61bd
	nop			;61be
	nop			;61bf
	nop			;61c0
	nop			;61c1
	nop			;61c2
	nop			;61c3
	nop			;61c4
	nop			;61c5
	nop			;61c6
	nop			;61c7
	nop			;61c8
	nop			;61c9
	nop			;61ca
	nop			;61cb
	nop			;61cc
	nop			;61cd
	nop			;61ce
	nop			;61cf
	nop			;61d0
	nop			;61d1
	nop			;61d2
	nop			;61d3
	nop			;61d4
	nop			;61d5
	nop			;61d6
	nop			;61d7
	nop			;61d8
	nop			;61d9
	nop			;61da
	nop			;61db
	nop			;61dc
	nop			;61dd
	nop			;61de
	nop			;61df
	nop			;61e0
	nop			;61e1
	nop			;61e2
	nop			;61e3
	nop			;61e4
	nop			;61e5
	nop			;61e6
	nop			;61e7
	nop			;61e8
	nop			;61e9
	nop			;61ea
	nop			;61eb
	nop			;61ec
	nop			;61ed
	nop			;61ee
	nop			;61ef
	nop			;61f0
	nop			;61f1
	nop			;61f2
	nop			;61f3
	nop			;61f4
	nop			;61f5
	nop			;61f6
	nop			;61f7
	nop			;61f8
	nop			;61f9
	nop			;61fa
	nop			;61fb
	nop			;61fc
	nop			;61fd
	nop			;61fe
	nop			;61ff
	nop			;6200
	nop			;6201
	nop			;6202
	nop			;6203
	nop			;6204
	nop			;6205
	nop			;6206
	nop			;6207
	nop			;6208
	nop			;6209
	nop			;620a
	nop			;620b
	nop			;620c
	nop			;620d
	nop			;620e
	nop			;620f
	nop			;6210
	nop			;6211
	nop			;6212
	nop			;6213
	nop			;6214
	nop			;6215
	nop			;6216
	nop			;6217
	nop			;6218
	nop			;6219
	nop			;621a
	nop			;621b
	nop			;621c
	nop			;621d
	nop			;621e
	nop			;621f
	nop			;6220
	nop			;6221
	nop			;6222
	nop			;6223
	nop			;6224
	nop			;6225
	nop			;6226
	nop			;6227
	nop			;6228
	nop			;6229
	nop			;622a
	nop			;622b
	nop			;622c
	nop			;622d
	nop			;622e
	nop			;622f
	nop			;6230
	nop			;6231
	nop			;6232
	nop			;6233
	nop			;6234
	nop			;6235
	nop			;6236
	nop			;6237
	nop			;6238
	nop			;6239
	nop			;623a
	nop			;623b
	nop			;623c
	nop			;623d
	nop			;623e
	nop			;623f
	nop			;6240
	nop			;6241
	nop			;6242
	nop			;6243
	nop			;6244
	nop			;6245
	nop			;6246
	nop			;6247
	nop			;6248
	nop			;6249
	nop			;624a
	nop			;624b
	nop			;624c
	nop			;624d
	nop			;624e
	nop			;624f
	nop			;6250
	nop			;6251
	nop			;6252
	nop			;6253
	nop			;6254
	nop			;6255
	nop			;6256
	nop			;6257
	nop			;6258
	nop			;6259
	nop			;625a
	nop			;625b
	nop			;625c
	nop			;625d
	nop			;625e
	nop			;625f
	nop			;6260
	nop			;6261
	nop			;6262
	nop			;6263
	nop			;6264
	nop			;6265
	nop			;6266
	nop			;6267
	nop			;6268
	nop			;6269
	nop			;626a
	nop			;626b
	nop			;626c
	nop			;626d
	nop			;626e
	nop			;626f
	nop			;6270
	nop			;6271
	nop			;6272
	nop			;6273
	nop			;6274
	nop			;6275
	nop			;6276
	nop			;6277
	nop			;6278
	nop			;6279
	nop			;627a
	nop			;627b
	nop			;627c
	nop			;627d
	nop			;627e
	nop			;627f
	nop			;6280
	nop			;6281
	nop			;6282
	nop			;6283
	nop			;6284
	nop			;6285
	nop			;6286
	nop			;6287
	nop			;6288
	nop			;6289
	nop			;628a
	nop			;628b
	nop			;628c
	nop			;628d
	nop			;628e
	nop			;628f
	nop			;6290
	nop			;6291
	nop			;6292
	nop			;6293
	nop			;6294
	nop			;6295
	nop			;6296
	nop			;6297
	nop			;6298
	nop			;6299
	nop			;629a
	nop			;629b
	nop			;629c
	nop			;629d
	nop			;629e
	nop			;629f
	nop			;62a0
	nop			;62a1
	nop			;62a2
	nop			;62a3
	nop			;62a4
	nop			;62a5
	nop			;62a6
	nop			;62a7
	nop			;62a8
	nop			;62a9
	nop			;62aa
	nop			;62ab
	nop			;62ac
	nop			;62ad
	nop			;62ae
	nop			;62af
	nop			;62b0
	nop			;62b1
	nop			;62b2
	nop			;62b3
	nop			;62b4
	nop			;62b5
	nop			;62b6
	nop			;62b7
	nop			;62b8
	nop			;62b9
	nop			;62ba
	nop			;62bb
	nop			;62bc
	nop			;62bd
	nop			;62be
	nop			;62bf
	nop			;62c0
	nop			;62c1
	nop			;62c2
	nop			;62c3
	nop			;62c4
	nop			;62c5
	nop			;62c6
	nop			;62c7
	nop			;62c8
	nop			;62c9
	nop			;62ca
	nop			;62cb
	nop			;62cc
	nop			;62cd
	nop			;62ce
	nop			;62cf
	nop			;62d0
	nop			;62d1
	nop			;62d2
	nop			;62d3
	nop			;62d4
	nop			;62d5
	nop			;62d6
	nop			;62d7
	nop			;62d8
	nop			;62d9
	nop			;62da
	nop			;62db
	nop			;62dc
	nop			;62dd
	nop			;62de
	nop			;62df
	nop			;62e0
	nop			;62e1
	nop			;62e2
	nop			;62e3
	nop			;62e4
	nop			;62e5
	nop			;62e6
	nop			;62e7
	nop			;62e8
	nop			;62e9
	nop			;62ea
	nop			;62eb
	nop			;62ec
	nop			;62ed
	nop			;62ee
	nop			;62ef
	nop			;62f0
	nop			;62f1
	nop			;62f2
	nop			;62f3
	nop			;62f4
	nop			;62f5
	nop			;62f6
	nop			;62f7
	nop			;62f8
	nop			;62f9
	nop			;62fa
	nop			;62fb
	nop			;62fc
	nop			;62fd
	nop			;62fe
	nop			;62ff
	nop			;6300
	nop			;6301
	nop			;6302
	nop			;6303
	nop			;6304
	nop			;6305
	nop			;6306
	nop			;6307
	nop			;6308
	nop			;6309
	nop			;630a
	nop			;630b
	nop			;630c
	nop			;630d
	nop			;630e
	nop			;630f
	nop			;6310
	nop			;6311
	nop			;6312
	nop			;6313
	nop			;6314
	nop			;6315
	nop			;6316
	nop			;6317
	nop			;6318
	nop			;6319
	nop			;631a
	nop			;631b
	nop			;631c
	nop			;631d
	nop			;631e
	nop			;631f
	nop			;6320
	nop			;6321
	nop			;6322
	nop			;6323
	nop			;6324
	nop			;6325
	nop			;6326
	nop			;6327
	nop			;6328
	nop			;6329
	nop			;632a
	nop			;632b
	nop			;632c
	nop			;632d
	nop			;632e
	nop			;632f
	nop			;6330
	nop			;6331
	nop			;6332
	nop			;6333
	nop			;6334
	nop			;6335
	nop			;6336
	nop			;6337
	nop			;6338
	nop			;6339
	nop			;633a
	nop			;633b
	nop			;633c
	nop			;633d
	nop			;633e
	nop			;633f
	nop			;6340
	nop			;6341
	nop			;6342
	nop			;6343
	nop			;6344
	nop			;6345
	nop			;6346
	nop			;6347
	nop			;6348
	nop			;6349
	nop			;634a
	nop			;634b
	nop			;634c
	nop			;634d
	nop			;634e
	nop			;634f
	nop			;6350
	nop			;6351
	nop			;6352
	nop			;6353
	nop			;6354
	nop			;6355
	nop			;6356
	nop			;6357
	nop			;6358
	nop			;6359
	nop			;635a
	nop			;635b
	nop			;635c
	nop			;635d
	nop			;635e
	nop			;635f
	nop			;6360
	nop			;6361
	nop			;6362
	nop			;6363
	nop			;6364
	nop			;6365
	nop			;6366
	nop			;6367
	nop			;6368
	nop			;6369
	nop			;636a
	nop			;636b
	nop			;636c
	nop			;636d
	nop			;636e
	nop			;636f
	nop			;6370
	nop			;6371
	nop			;6372
	nop			;6373
	nop			;6374
	nop			;6375
	nop			;6376
	nop			;6377
	nop			;6378
	nop			;6379
	nop			;637a
	nop			;637b
	nop			;637c
	nop			;637d
	nop			;637e
	nop			;637f
	nop			;6380
	nop			;6381
	nop			;6382
	nop			;6383
	nop			;6384
	nop			;6385
	nop			;6386
	nop			;6387
	nop			;6388
	nop			;6389
	nop			;638a
	nop			;638b
	nop			;638c
	nop			;638d
	nop			;638e
	nop			;638f
	nop			;6390
	nop			;6391
	nop			;6392
	nop			;6393
	nop			;6394
	nop			;6395
	nop			;6396
	nop			;6397
	nop			;6398
	nop			;6399
	nop			;639a
	nop			;639b
	nop			;639c
	nop			;639d
	nop			;639e
	nop			;639f
	nop			;63a0
	nop			;63a1
	nop			;63a2
	nop			;63a3
	nop			;63a4
	nop			;63a5
	nop			;63a6
	nop			;63a7
	nop			;63a8
	nop			;63a9
	nop			;63aa
	nop			;63ab
	nop			;63ac
	nop			;63ad
	nop			;63ae
	nop			;63af
	nop			;63b0
	nop			;63b1
	nop			;63b2
	nop			;63b3
	nop			;63b4
	nop			;63b5
	nop			;63b6
	nop			;63b7
	nop			;63b8
	nop			;63b9
	nop			;63ba
	nop			;63bb
	nop			;63bc
	nop			;63bd
	nop			;63be
	nop			;63bf
	nop			;63c0
	nop			;63c1
	nop			;63c2
	nop			;63c3
	nop			;63c4
	nop			;63c5
	nop			;63c6
	nop			;63c7
	nop			;63c8
	nop			;63c9
	nop			;63ca
	nop			;63cb
	nop			;63cc
	nop			;63cd
	nop			;63ce
	nop			;63cf
	nop			;63d0
	nop			;63d1
	nop			;63d2
	nop			;63d3
	nop			;63d4
	nop			;63d5
	nop			;63d6
	nop			;63d7
	nop			;63d8
	nop			;63d9
	nop			;63da
	nop			;63db
	nop			;63dc
	nop			;63dd
	nop			;63de
	nop			;63df
	nop			;63e0
	nop			;63e1
	nop			;63e2
	nop			;63e3
	nop			;63e4
	nop			;63e5
	nop			;63e6
	nop			;63e7
	nop			;63e8
	nop			;63e9
	nop			;63ea
	nop			;63eb
	nop			;63ec
	nop			;63ed
	nop			;63ee
	nop			;63ef
	nop			;63f0
	nop			;63f1
	nop			;63f2
	nop			;63f3
	nop			;63f4
	nop			;63f5
	nop			;63f6
	nop			;63f7
	nop			;63f8
	nop			;63f9
	nop			;63fa
	nop			;63fb
	nop			;63fc
	nop			;63fd
	nop			;63fe
	nop			;63ff
	nop			;6400
	nop			;6401
	nop			;6402
	nop			;6403
	nop			;6404
	nop			;6405
	nop			;6406
	nop			;6407
	nop			;6408
	nop			;6409
	nop			;640a
	nop			;640b
	nop			;640c
	nop			;640d
	nop			;640e
	nop			;640f
	nop			;6410
	nop			;6411
	nop			;6412
	nop			;6413
	nop			;6414
	nop			;6415
	nop			;6416
	nop			;6417
	nop			;6418
	nop			;6419
	nop			;641a
	nop			;641b
	nop			;641c
	nop			;641d
	nop			;641e
	nop			;641f
	nop			;6420
	nop			;6421
	nop			;6422
	nop			;6423
	nop			;6424
	nop			;6425
	nop			;6426
	nop			;6427
	nop			;6428
	nop			;6429
	nop			;642a
	nop			;642b
	nop			;642c
	nop			;642d
	nop			;642e
	nop			;642f
	nop			;6430
	nop			;6431
	nop			;6432
	nop			;6433
	nop			;6434
	nop			;6435
	nop			;6436
	nop			;6437
	nop			;6438
	nop			;6439
	nop			;643a
	nop			;643b
	nop			;643c
	nop			;643d
	nop			;643e
	nop			;643f
	nop			;6440
	nop			;6441
	nop			;6442
	nop			;6443
	nop			;6444
	nop			;6445
	nop			;6446
	nop			;6447
	nop			;6448
	nop			;6449
	nop			;644a
	nop			;644b
	nop			;644c
	nop			;644d
	nop			;644e
	nop			;644f
	nop			;6450
	nop			;6451
	nop			;6452
	nop			;6453
	nop			;6454
	nop			;6455
	nop			;6456
	nop			;6457
	nop			;6458
	nop			;6459
	nop			;645a
	nop			;645b
	nop			;645c
	nop			;645d
	nop			;645e
	nop			;645f
	nop			;6460
	nop			;6461
	nop			;6462
	nop			;6463
	nop			;6464
	nop			;6465
	nop			;6466
	nop			;6467
	nop			;6468
	nop			;6469
	nop			;646a
	nop			;646b
	nop			;646c
	nop			;646d
	nop			;646e
	nop			;646f
	nop			;6470
	nop			;6471
	nop			;6472
	nop			;6473
	nop			;6474
	nop			;6475
	nop			;6476
	nop			;6477
	nop			;6478
	nop			;6479
	nop			;647a
	nop			;647b
	nop			;647c
	nop			;647d
	nop			;647e
	nop			;647f
	nop			;6480
	nop			;6481
	nop			;6482
	nop			;6483
	nop			;6484
	nop			;6485
	nop			;6486
	nop			;6487
	nop			;6488
	nop			;6489
	nop			;648a
	nop			;648b
	nop			;648c
	nop			;648d
	nop			;648e
	nop			;648f
	nop			;6490
	nop			;6491
	nop			;6492
	nop			;6493
	nop			;6494
	nop			;6495
	nop			;6496
	nop			;6497
	nop			;6498
	nop			;6499
	nop			;649a
	nop			;649b
	nop			;649c
	nop			;649d
	nop			;649e
	nop			;649f
	nop			;64a0
	nop			;64a1
	nop			;64a2
	nop			;64a3
	nop			;64a4
	nop			;64a5
	nop			;64a6
	nop			;64a7
	nop			;64a8
	nop			;64a9
	nop			;64aa
	nop			;64ab
	nop			;64ac
	nop			;64ad
	nop			;64ae
	nop			;64af
	nop			;64b0
	nop			;64b1
	nop			;64b2
	nop			;64b3
	nop			;64b4
	nop			;64b5
	nop			;64b6
	nop			;64b7
	nop			;64b8
	nop			;64b9
	nop			;64ba
	nop			;64bb
	nop			;64bc
	nop			;64bd
	nop			;64be
	nop			;64bf
	nop			;64c0
	nop			;64c1
	nop			;64c2
	nop			;64c3
	nop			;64c4
	nop			;64c5
	nop			;64c6
	nop			;64c7
	nop			;64c8
	nop			;64c9
	nop			;64ca
	nop			;64cb
	nop			;64cc
	nop			;64cd
	nop			;64ce
	nop			;64cf
	nop			;64d0
	nop			;64d1
	nop			;64d2
	nop			;64d3
	nop			;64d4
	nop			;64d5
	nop			;64d6
	nop			;64d7
	nop			;64d8
	nop			;64d9
	nop			;64da
	nop			;64db
	nop			;64dc
	nop			;64dd
	nop			;64de
	nop			;64df
	nop			;64e0
	nop			;64e1
	nop			;64e2
	nop			;64e3
	nop			;64e4
	nop			;64e5
	nop			;64e6
	nop			;64e7
	nop			;64e8
	nop			;64e9
	nop			;64ea
	nop			;64eb
	nop			;64ec
	nop			;64ed
	nop			;64ee
	nop			;64ef
	nop			;64f0
	nop			;64f1
	nop			;64f2
	nop			;64f3
	nop			;64f4
	nop			;64f5
	nop			;64f6
	nop			;64f7
	nop			;64f8
	nop			;64f9
	nop			;64fa
	nop			;64fb
	nop			;64fc
	nop			;64fd
	nop			;64fe
	nop			;64ff
	nop			;6500
	nop			;6501
	nop			;6502
	nop			;6503
	nop			;6504
	nop			;6505
	nop			;6506
	nop			;6507
	nop			;6508
	nop			;6509
	nop			;650a
	nop			;650b
	nop			;650c
	nop			;650d
	nop			;650e
	nop			;650f
	nop			;6510
	nop			;6511
	nop			;6512
	nop			;6513
	nop			;6514
	nop			;6515
	nop			;6516
	nop			;6517
	nop			;6518
	nop			;6519
	nop			;651a
	nop			;651b
	nop			;651c
	nop			;651d
	nop			;651e
	nop			;651f
	nop			;6520
	nop			;6521
	nop			;6522
	nop			;6523
	nop			;6524
	nop			;6525
	nop			;6526
	nop			;6527
	nop			;6528
	nop			;6529
	nop			;652a
	nop			;652b
	nop			;652c
	nop			;652d
	nop			;652e
	nop			;652f
	nop			;6530
	nop			;6531
	nop			;6532
	nop			;6533
	nop			;6534
	nop			;6535
	nop			;6536
	nop			;6537
	nop			;6538
	nop			;6539
	nop			;653a
	nop			;653b
	nop			;653c
	nop			;653d
	nop			;653e
	nop			;653f
	nop			;6540
	nop			;6541
	nop			;6542
	nop			;6543
	nop			;6544
	nop			;6545
	nop			;6546
	nop			;6547
	nop			;6548
	nop			;6549
	nop			;654a
	nop			;654b
	nop			;654c
	nop			;654d
	nop			;654e
	nop			;654f
	nop			;6550
	nop			;6551
	nop			;6552
	nop			;6553
	nop			;6554
	nop			;6555
	nop			;6556
	nop			;6557
	nop			;6558
	nop			;6559
	nop			;655a
	nop			;655b
	nop			;655c
	nop			;655d
	nop			;655e
	nop			;655f
	nop			;6560
	nop			;6561
	nop			;6562
	nop			;6563
	nop			;6564
	nop			;6565
	nop			;6566
	nop			;6567
	nop			;6568
	nop			;6569
	nop			;656a
	nop			;656b
	nop			;656c
	nop			;656d
	nop			;656e
	nop			;656f
	nop			;6570
	nop			;6571
	nop			;6572
	nop			;6573
	nop			;6574
	nop			;6575
	nop			;6576
	nop			;6577
	nop			;6578
	nop			;6579
	nop			;657a
	nop			;657b
	nop			;657c
	nop			;657d
	nop			;657e
	nop			;657f
	nop			;6580
	nop			;6581
	nop			;6582
	nop			;6583
	nop			;6584
	nop			;6585
	nop			;6586
	nop			;6587
	nop			;6588
	nop			;6589
	nop			;658a
	nop			;658b
	nop			;658c
	nop			;658d
	nop			;658e
	nop			;658f
	nop			;6590
	nop			;6591
	nop			;6592
	nop			;6593
	nop			;6594
	nop			;6595
	nop			;6596
	nop			;6597
	nop			;6598
	nop			;6599
	nop			;659a
	nop			;659b
	nop			;659c
	nop			;659d
	nop			;659e
	nop			;659f
	nop			;65a0
	nop			;65a1
	nop			;65a2
	nop			;65a3
	nop			;65a4
	nop			;65a5
	nop			;65a6
	nop			;65a7
	nop			;65a8
	nop			;65a9
	nop			;65aa
	nop			;65ab
	nop			;65ac
	nop			;65ad
	nop			;65ae
	nop			;65af
	nop			;65b0
	nop			;65b1
	nop			;65b2
	nop			;65b3
	nop			;65b4
	nop			;65b5
	nop			;65b6
	nop			;65b7
	nop			;65b8
	nop			;65b9
	nop			;65ba
	nop			;65bb
	nop			;65bc
	nop			;65bd
	nop			;65be
	nop			;65bf
	nop			;65c0
	nop			;65c1
	nop			;65c2
	nop			;65c3
	nop			;65c4
	nop			;65c5
	nop			;65c6
	nop			;65c7
	nop			;65c8
	nop			;65c9
	nop			;65ca
	nop			;65cb
	nop			;65cc
	nop			;65cd
	nop			;65ce
	nop			;65cf
	nop			;65d0
	nop			;65d1
	nop			;65d2
	nop			;65d3
	nop			;65d4
	nop			;65d5
	nop			;65d6
	nop			;65d7
	nop			;65d8
	nop			;65d9
	nop			;65da
	nop			;65db
	nop			;65dc
	nop			;65dd
	nop			;65de
	nop			;65df
	nop			;65e0
	nop			;65e1
	nop			;65e2
	nop			;65e3
	nop			;65e4
	nop			;65e5
	nop			;65e6
	nop			;65e7
	nop			;65e8
	nop			;65e9
	nop			;65ea
	nop			;65eb
	nop			;65ec
	nop			;65ed
	nop			;65ee
	nop			;65ef
	nop			;65f0
	nop			;65f1
	nop			;65f2
	nop			;65f3
	nop			;65f4
	nop			;65f5
	nop			;65f6
	nop			;65f7
	nop			;65f8
	nop			;65f9
	nop			;65fa
	nop			;65fb
	nop			;65fc
	nop			;65fd
	nop			;65fe
	nop			;65ff
	nop			;6600
	nop			;6601
	nop			;6602
	nop			;6603
	nop			;6604
	nop			;6605
	nop			;6606
	nop			;6607
	nop			;6608
	nop			;6609
	nop			;660a
	nop			;660b
	nop			;660c
	nop			;660d
	nop			;660e
	nop			;660f
	nop			;6610
	nop			;6611
	nop			;6612
	nop			;6613
	nop			;6614
	nop			;6615
	nop			;6616
	nop			;6617
	nop			;6618
	nop			;6619
	nop			;661a
	nop			;661b
	nop			;661c
	nop			;661d
	nop			;661e
	nop			;661f
	nop			;6620
	nop			;6621
	nop			;6622
	nop			;6623
	nop			;6624
	nop			;6625
	nop			;6626
	nop			;6627
	nop			;6628
	nop			;6629
	nop			;662a
	nop			;662b
	nop			;662c
	nop			;662d
	nop			;662e
	nop			;662f
	nop			;6630
	nop			;6631
	nop			;6632
	nop			;6633
	nop			;6634
	nop			;6635
	nop			;6636
	nop			;6637
	nop			;6638
	nop			;6639
	nop			;663a
	nop			;663b
	nop			;663c
	nop			;663d
	nop			;663e
	nop			;663f
	nop			;6640
	nop			;6641
	nop			;6642
	nop			;6643
	nop			;6644
	nop			;6645
	nop			;6646
	nop			;6647
	nop			;6648
	nop			;6649
	nop			;664a
	nop			;664b
	nop			;664c
	nop			;664d
	nop			;664e
	nop			;664f
	nop			;6650
	nop			;6651
	nop			;6652
	nop			;6653
	nop			;6654
	nop			;6655
	nop			;6656
	nop			;6657
	nop			;6658
	nop			;6659
	nop			;665a
	nop			;665b
	nop			;665c
	nop			;665d
	nop			;665e
	nop			;665f
	nop			;6660
	nop			;6661
	nop			;6662
	nop			;6663
	nop			;6664
	nop			;6665
	nop			;6666
	nop			;6667
	nop			;6668
	nop			;6669
	nop			;666a
	nop			;666b
	nop			;666c
	nop			;666d
	nop			;666e
	nop			;666f
	nop			;6670
	nop			;6671
	nop			;6672
	nop			;6673
	nop			;6674
	nop			;6675
	nop			;6676
	nop			;6677
	call 010b3h		;6678
	nop			;667b
	nop			;667c
	nop			;667d
	nop			;667e
	nop			;667f
	nop			;6680
	nop			;6681
	nop			;6682
	nop			;6683
	nop			;6684
	nop			;6685
	nop			;6686
	nop			;6687
	nop			;6688
	nop			;6689
	nop			;668a
	nop			;668b
	nop			;668c
	nop			;668d
	nop			;668e
	nop			;668f
	nop			;6690
	nop			;6691
	nop			;6692
	nop			;6693
	nop			;6694
	nop			;6695
	nop			;6696
	nop			;6697
	nop			;6698
	nop			;6699
	nop			;669a
	nop			;669b
	nop			;669c
	nop			;669d
	nop			;669e
	nop			;669f
	nop			;66a0
	nop			;66a1
	nop			;66a2
	nop			;66a3
	nop			;66a4
	nop			;66a5
	nop			;66a6
	nop			;66a7
	nop			;66a8
	nop			;66a9
	nop			;66aa
	nop			;66ab
	nop			;66ac
	nop			;66ad
	nop			;66ae
	nop			;66af
	nop			;66b0
	nop			;66b1
	nop			;66b2
	nop			;66b3
	nop			;66b4
	nop			;66b5
	nop			;66b6
	nop			;66b7
	nop			;66b8
	nop			;66b9
	nop			;66ba
	nop			;66bb
	nop			;66bc
	nop			;66bd
	nop			;66be
	nop			;66bf
	nop			;66c0
	nop			;66c1
	nop			;66c2
	nop			;66c3
	nop			;66c4
	nop			;66c5
	nop			;66c6
	nop			;66c7
	nop			;66c8
	nop			;66c9
	nop			;66ca
	nop			;66cb
	nop			;66cc
	nop			;66cd
	nop			;66ce
	nop			;66cf
	nop			;66d0
	nop			;66d1
	nop			;66d2
	nop			;66d3
	nop			;66d4
	nop			;66d5
	nop			;66d6
	nop			;66d7
	nop			;66d8
	nop			;66d9
	nop			;66da
	nop			;66db
	nop			;66dc
	nop			;66dd
	nop			;66de
	nop			;66df
	nop			;66e0
	nop			;66e1
	nop			;66e2
	nop			;66e3
	nop			;66e4
	nop			;66e5
	nop			;66e6
	nop			;66e7
	nop			;66e8
	nop			;66e9
	nop			;66ea
	nop			;66eb
	nop			;66ec
	nop			;66ed
	nop			;66ee
	nop			;66ef
	nop			;66f0
	nop			;66f1
	nop			;66f2
	nop			;66f3
	nop			;66f4
	nop			;66f5
	nop			;66f6
	nop			;66f7
	nop			;66f8
	nop			;66f9
	nop			;66fa
	nop			;66fb
	nop			;66fc
	nop			;66fd
	nop			;66fe
	nop			;66ff
	nop			;6700
	nop			;6701
	nop			;6702
	nop			;6703
	nop			;6704
	nop			;6705
	nop			;6706
	nop			;6707
	nop			;6708
	nop			;6709
	nop			;670a
	nop			;670b
	nop			;670c
	nop			;670d
	nop			;670e
	nop			;670f
	nop			;6710
	nop			;6711
	nop			;6712
	nop			;6713
	nop			;6714
	nop			;6715
	nop			;6716
	nop			;6717
	nop			;6718
	nop			;6719
	nop			;671a
	nop			;671b
	nop			;671c
	nop			;671d
	nop			;671e
	nop			;671f
	nop			;6720
	nop			;6721
	nop			;6722
	nop			;6723
	nop			;6724
	nop			;6725
	nop			;6726
	nop			;6727
	nop			;6728
	nop			;6729
	nop			;672a
	nop			;672b
	nop			;672c
	nop			;672d
	nop			;672e
	nop			;672f
	nop			;6730
	nop			;6731
	nop			;6732
	nop			;6733
	nop			;6734
	nop			;6735
	nop			;6736
	nop			;6737
	nop			;6738
	nop			;6739
	nop			;673a
	nop			;673b
	nop			;673c
	nop			;673d
	nop			;673e
	nop			;673f
	nop			;6740
	nop			;6741
	nop			;6742
	nop			;6743
	nop			;6744
	nop			;6745
	nop			;6746
	nop			;6747
	nop			;6748
	nop			;6749
	nop			;674a
	nop			;674b
	nop			;674c
	nop			;674d
	nop			;674e
	nop			;674f
	nop			;6750
	nop			;6751
	nop			;6752
	nop			;6753
	nop			;6754
	nop			;6755
	nop			;6756
	nop			;6757
	nop			;6758
	nop			;6759
	nop			;675a
	nop			;675b
	nop			;675c
	nop			;675d
	nop			;675e
	nop			;675f
	nop			;6760
	nop			;6761
	nop			;6762
	nop			;6763
	nop			;6764
	nop			;6765
	nop			;6766
	nop			;6767
	nop			;6768
	nop			;6769
	nop			;676a
	nop			;676b
	nop			;676c
	nop			;676d
	nop			;676e
	nop			;676f
	nop			;6770
	nop			;6771
	nop			;6772
	nop			;6773
	nop			;6774
	nop			;6775
	nop			;6776
	nop			;6777
	nop			;6778
	nop			;6779
	nop			;677a
	nop			;677b
	nop			;677c
	nop			;677d
	nop			;677e
	nop			;677f
	nop			;6780
	nop			;6781
	nop			;6782
	nop			;6783
	nop			;6784
	nop			;6785
	nop			;6786
	nop			;6787
	nop			;6788
	nop			;6789
	nop			;678a
	nop			;678b
	nop			;678c
	nop			;678d
	nop			;678e
	nop			;678f
	nop			;6790
	nop			;6791
	nop			;6792
	nop			;6793
	nop			;6794
	nop			;6795
	nop			;6796
	nop			;6797
	nop			;6798
	nop			;6799
	nop			;679a
	nop			;679b
	nop			;679c
	nop			;679d
	nop			;679e
	nop			;679f
	nop			;67a0
	nop			;67a1
	nop			;67a2
	nop			;67a3
	nop			;67a4
	nop			;67a5
	nop			;67a6
	nop			;67a7
	nop			;67a8
	nop			;67a9
	nop			;67aa
	nop			;67ab
	nop			;67ac
	nop			;67ad
	nop			;67ae
	nop			;67af
	nop			;67b0
	nop			;67b1
	nop			;67b2
	nop			;67b3
	nop			;67b4
	nop			;67b5
	nop			;67b6
	nop			;67b7
	nop			;67b8
	nop			;67b9
	nop			;67ba
	nop			;67bb
	nop			;67bc
	nop			;67bd
	nop			;67be
	nop			;67bf
	nop			;67c0
	nop			;67c1
	nop			;67c2
	nop			;67c3
	nop			;67c4
	nop			;67c5
	nop			;67c6
	nop			;67c7
	nop			;67c8
	nop			;67c9
	nop			;67ca
	nop			;67cb
	nop			;67cc
	nop			;67cd
	nop			;67ce
	nop			;67cf
	nop			;67d0
	nop			;67d1
	nop			;67d2
	nop			;67d3
	nop			;67d4
	nop			;67d5
	nop			;67d6
	nop			;67d7
	nop			;67d8
	nop			;67d9
	nop			;67da
	nop			;67db
	nop			;67dc
	nop			;67dd
	nop			;67de
	nop			;67df
	nop			;67e0
	nop			;67e1
	nop			;67e2
	nop			;67e3
	nop			;67e4
	nop			;67e5
	nop			;67e6
	nop			;67e7
	nop			;67e8
	nop			;67e9
	nop			;67ea
	nop			;67eb
	nop			;67ec
	nop			;67ed
	nop			;67ee
	nop			;67ef
	nop			;67f0
	nop			;67f1
	nop			;67f2
	nop			;67f3
	nop			;67f4
	nop			;67f5
	nop			;67f6
	nop			;67f7
	nop			;67f8
	nop			;67f9
	nop			;67fa
	nop			;67fb
	nop			;67fc
	nop			;67fd
	nop			;67fe
	nop			;67ff
	nop			;6800
	nop			;6801
	nop			;6802
	nop			;6803
	nop			;6804
	nop			;6805
	nop			;6806
	nop			;6807
	nop			;6808
	nop			;6809
	nop			;680a
	nop			;680b
	nop			;680c
	nop			;680d
	nop			;680e
	nop			;680f
	nop			;6810
	nop			;6811
	nop			;6812
	nop			;6813
	nop			;6814
	nop			;6815
	nop			;6816
	nop			;6817
	nop			;6818
	nop			;6819
	nop			;681a
	nop			;681b
	nop			;681c
	nop			;681d
	nop			;681e
	nop			;681f
	nop			;6820
	nop			;6821
	nop			;6822
	nop			;6823
	nop			;6824
	nop			;6825
	nop			;6826
	nop			;6827
	nop			;6828
	nop			;6829
	nop			;682a
	nop			;682b
	nop			;682c
	nop			;682d
	nop			;682e
	nop			;682f
	nop			;6830
	nop			;6831
	nop			;6832
	nop			;6833
	nop			;6834
	nop			;6835
	nop			;6836
	nop			;6837
	nop			;6838
	nop			;6839
	nop			;683a
	nop			;683b
	nop			;683c
	nop			;683d
	nop			;683e
	nop			;683f
	nop			;6840
	nop			;6841
	nop			;6842
	nop			;6843
	nop			;6844
	nop			;6845
	nop			;6846
	nop			;6847
	nop			;6848
	nop			;6849
	nop			;684a
	nop			;684b
	nop			;684c
	nop			;684d
	nop			;684e
	nop			;684f
	nop			;6850
	nop			;6851
	nop			;6852
	nop			;6853
	nop			;6854
	nop			;6855
	nop			;6856
	nop			;6857
	nop			;6858
	nop			;6859
	nop			;685a
	nop			;685b
	nop			;685c
	nop			;685d
	nop			;685e
	nop			;685f
	nop			;6860
	nop			;6861
	nop			;6862
	nop			;6863
	nop			;6864
	nop			;6865
	nop			;6866
	nop			;6867
	nop			;6868
	nop			;6869
	nop			;686a
	nop			;686b
	nop			;686c
	nop			;686d
	nop			;686e
	nop			;686f
	nop			;6870
	nop			;6871
	nop			;6872
	nop			;6873
	nop			;6874
	nop			;6875
	nop			;6876
	nop			;6877
	nop			;6878
	nop			;6879
	nop			;687a
	nop			;687b
	nop			;687c
	nop			;687d
	nop			;687e
	nop			;687f
	nop			;6880
	nop			;6881
	nop			;6882
	nop			;6883
	nop			;6884
	nop			;6885
	nop			;6886
	nop			;6887
	nop			;6888
	nop			;6889
	nop			;688a
	nop			;688b
	nop			;688c
	nop			;688d
	nop			;688e
	nop			;688f
	nop			;6890
	nop			;6891
	nop			;6892
	nop			;6893
	nop			;6894
	nop			;6895
	nop			;6896
	nop			;6897
	nop			;6898
	nop			;6899
	nop			;689a
	nop			;689b
	nop			;689c
	nop			;689d
	nop			;689e
	nop			;689f
	nop			;68a0
	nop			;68a1
	nop			;68a2
	nop			;68a3
	nop			;68a4
	nop			;68a5
	nop			;68a6
	nop			;68a7
	nop			;68a8
	nop			;68a9
	nop			;68aa
	nop			;68ab
	nop			;68ac
	nop			;68ad
	nop			;68ae
	nop			;68af
	nop			;68b0
	nop			;68b1
	nop			;68b2
	nop			;68b3
	nop			;68b4
	nop			;68b5
	nop			;68b6
	nop			;68b7
	nop			;68b8
	nop			;68b9
	nop			;68ba
	nop			;68bb
	nop			;68bc
	nop			;68bd
	nop			;68be
	nop			;68bf
	nop			;68c0
	nop			;68c1
	nop			;68c2
	nop			;68c3
	nop			;68c4
	nop			;68c5
	nop			;68c6
	nop			;68c7
	nop			;68c8
	nop			;68c9
	nop			;68ca
	nop			;68cb
	nop			;68cc
	nop			;68cd
	nop			;68ce
	nop			;68cf
	nop			;68d0
	nop			;68d1
	nop			;68d2
	nop			;68d3
	nop			;68d4
	nop			;68d5
	nop			;68d6
	nop			;68d7
	nop			;68d8
	nop			;68d9
	nop			;68da
	nop			;68db
	nop			;68dc
	nop			;68dd
	nop			;68de
	nop			;68df
	nop			;68e0
	nop			;68e1
	nop			;68e2
	nop			;68e3
	nop			;68e4
	nop			;68e5
	nop			;68e6
	nop			;68e7
	nop			;68e8
	nop			;68e9
	nop			;68ea
	nop			;68eb
	nop			;68ec
	nop			;68ed
	nop			;68ee
	nop			;68ef
	nop			;68f0
	nop			;68f1
	nop			;68f2
	nop			;68f3
	nop			;68f4
	nop			;68f5
	nop			;68f6
	nop			;68f7
	nop			;68f8
	nop			;68f9
	nop			;68fa
	nop			;68fb
	nop			;68fc
	nop			;68fd
	nop			;68fe
	nop			;68ff
	nop			;6900
	nop			;6901
	nop			;6902
	nop			;6903
	nop			;6904
	nop			;6905
	nop			;6906
	nop			;6907
	nop			;6908
	nop			;6909
	nop			;690a
	nop			;690b
	nop			;690c
	nop			;690d
	nop			;690e
	nop			;690f
	nop			;6910
	nop			;6911
	nop			;6912
	nop			;6913
	nop			;6914
	nop			;6915
	nop			;6916
	nop			;6917
	nop			;6918
	nop			;6919
	nop			;691a
	nop			;691b
	nop			;691c
	nop			;691d
	nop			;691e
	nop			;691f
	nop			;6920
	nop			;6921
	nop			;6922
	nop			;6923
	nop			;6924
	nop			;6925
	nop			;6926
	nop			;6927
	nop			;6928
	nop			;6929
	nop			;692a
	nop			;692b
	nop			;692c
	nop			;692d
	nop			;692e
	nop			;692f
	nop			;6930
	nop			;6931
	nop			;6932
	nop			;6933
	nop			;6934
	nop			;6935
	nop			;6936
	nop			;6937
	nop			;6938
	nop			;6939
	nop			;693a
	nop			;693b
	nop			;693c
	nop			;693d
	nop			;693e
	nop			;693f
	nop			;6940
	nop			;6941
	nop			;6942
	nop			;6943
	nop			;6944
	nop			;6945
	nop			;6946
	nop			;6947
	nop			;6948
	nop			;6949
	nop			;694a
	nop			;694b
	nop			;694c
	nop			;694d
	nop			;694e
	nop			;694f
	nop			;6950
	nop			;6951
	nop			;6952
	nop			;6953
	nop			;6954
	nop			;6955
	nop			;6956
	nop			;6957
	nop			;6958
	nop			;6959
	nop			;695a
	nop			;695b
	nop			;695c
	nop			;695d
	nop			;695e
	nop			;695f
	nop			;6960
	nop			;6961
	nop			;6962
	nop			;6963
	nop			;6964
	nop			;6965
	nop			;6966
	nop			;6967
	nop			;6968
	nop			;6969
	nop			;696a
	nop			;696b
	nop			;696c
	nop			;696d
	nop			;696e
	nop			;696f
	nop			;6970
	nop			;6971
	nop			;6972
	nop			;6973
	nop			;6974
	nop			;6975
	nop			;6976
	nop			;6977
	nop			;6978
	nop			;6979
	nop			;697a
	nop			;697b
	nop			;697c
	nop			;697d
	nop			;697e
	nop			;697f
	nop			;6980
	nop			;6981
	nop			;6982
	nop			;6983
	nop			;6984
	nop			;6985
	nop			;6986
	nop			;6987
	nop			;6988
	nop			;6989
	nop			;698a
	nop			;698b
	nop			;698c
	nop			;698d
	nop			;698e
	nop			;698f
	nop			;6990
	nop			;6991
	nop			;6992
	nop			;6993
	nop			;6994
	nop			;6995
	nop			;6996
	nop			;6997
	nop			;6998
	nop			;6999
	nop			;699a
	nop			;699b
	nop			;699c
	nop			;699d
	nop			;699e
	nop			;699f
	nop			;69a0
	nop			;69a1
	nop			;69a2
	nop			;69a3
	nop			;69a4
	nop			;69a5
	nop			;69a6
	nop			;69a7
	nop			;69a8
	nop			;69a9
	nop			;69aa
	nop			;69ab
	nop			;69ac
	nop			;69ad
	nop			;69ae
	nop			;69af
	nop			;69b0
	nop			;69b1
	nop			;69b2
	nop			;69b3
	nop			;69b4
	nop			;69b5
	nop			;69b6
	nop			;69b7
	nop			;69b8
	nop			;69b9
	nop			;69ba
	nop			;69bb
	nop			;69bc
	nop			;69bd
	nop			;69be
	nop			;69bf
	nop			;69c0
	nop			;69c1
	nop			;69c2
	nop			;69c3
	nop			;69c4
	nop			;69c5
	nop			;69c6
	nop			;69c7
	nop			;69c8
	nop			;69c9
	nop			;69ca
	nop			;69cb
	nop			;69cc
	nop			;69cd
	nop			;69ce
	nop			;69cf
	nop			;69d0
	nop			;69d1
	nop			;69d2
	nop			;69d3
	nop			;69d4
	nop			;69d5
	nop			;69d6
	nop			;69d7
	nop			;69d8
	nop			;69d9
	nop			;69da
	nop			;69db
	nop			;69dc
	nop			;69dd
	nop			;69de
	nop			;69df
	nop			;69e0
	nop			;69e1
	nop			;69e2
	nop			;69e3
	nop			;69e4
	nop			;69e5
	nop			;69e6
	nop			;69e7
	nop			;69e8
	nop			;69e9
	nop			;69ea
	nop			;69eb
	nop			;69ec
	nop			;69ed
	nop			;69ee
	nop			;69ef
	nop			;69f0
	nop			;69f1
	nop			;69f2
	nop			;69f3
	nop			;69f4
	nop			;69f5
	nop			;69f6
	nop			;69f7
	nop			;69f8
	nop			;69f9
	nop			;69fa
	nop			;69fb
	nop			;69fc
	nop			;69fd
	nop			;69fe
	nop			;69ff
	nop			;6a00
	nop			;6a01
	nop			;6a02
	nop			;6a03
	nop			;6a04
	nop			;6a05
	nop			;6a06
	nop			;6a07
	nop			;6a08
	nop			;6a09
	nop			;6a0a
	nop			;6a0b
	nop			;6a0c
	nop			;6a0d
	nop			;6a0e
	nop			;6a0f
	nop			;6a10
	nop			;6a11
	nop			;6a12
	nop			;6a13
	nop			;6a14
	nop			;6a15
	nop			;6a16
	nop			;6a17
	nop			;6a18
	nop			;6a19
	nop			;6a1a
	nop			;6a1b
	nop			;6a1c
	nop			;6a1d
	nop			;6a1e
	nop			;6a1f
	nop			;6a20
	nop			;6a21
	nop			;6a22
	nop			;6a23
	nop			;6a24
	nop			;6a25
	nop			;6a26
	nop			;6a27
	nop			;6a28
	nop			;6a29
	nop			;6a2a
	nop			;6a2b
	nop			;6a2c
	nop			;6a2d
	nop			;6a2e
	nop			;6a2f
	nop			;6a30
	nop			;6a31
	nop			;6a32
	nop			;6a33
	nop			;6a34
	nop			;6a35
	nop			;6a36
	nop			;6a37
	nop			;6a38
	nop			;6a39
	nop			;6a3a
	nop			;6a3b
	nop			;6a3c
	nop			;6a3d
	nop			;6a3e
	nop			;6a3f
	nop			;6a40
	nop			;6a41
	nop			;6a42
	nop			;6a43
	nop			;6a44
	nop			;6a45
	nop			;6a46
	nop			;6a47
	nop			;6a48
	nop			;6a49
	nop			;6a4a
	nop			;6a4b
	nop			;6a4c
	nop			;6a4d
	nop			;6a4e
	nop			;6a4f
	nop			;6a50
	nop			;6a51
	nop			;6a52
	nop			;6a53
	nop			;6a54
	nop			;6a55
	nop			;6a56
	nop			;6a57
	nop			;6a58
	nop			;6a59
	nop			;6a5a
	nop			;6a5b
	nop			;6a5c
	nop			;6a5d
	nop			;6a5e
	nop			;6a5f
	nop			;6a60
	nop			;6a61
	nop			;6a62
	nop			;6a63
	nop			;6a64
	nop			;6a65
	nop			;6a66
	nop			;6a67
	nop			;6a68
	nop			;6a69
	nop			;6a6a
	nop			;6a6b
	nop			;6a6c
	nop			;6a6d
	nop			;6a6e
	nop			;6a6f
	nop			;6a70
	nop			;6a71
	nop			;6a72
	nop			;6a73
	nop			;6a74
	nop			;6a75
	nop			;6a76
	nop			;6a77
	nop			;6a78
	nop			;6a79
	nop			;6a7a
	nop			;6a7b
	nop			;6a7c
	nop			;6a7d
	nop			;6a7e
	nop			;6a7f
	nop			;6a80
	nop			;6a81
	nop			;6a82
	nop			;6a83
	nop			;6a84
	nop			;6a85
	nop			;6a86
	nop			;6a87
	nop			;6a88
	nop			;6a89
	nop			;6a8a
	nop			;6a8b
	nop			;6a8c
	nop			;6a8d
	nop			;6a8e
	nop			;6a8f
	nop			;6a90
	nop			;6a91
	nop			;6a92
	nop			;6a93
	nop			;6a94
	nop			;6a95
	nop			;6a96
	nop			;6a97
	nop			;6a98
	nop			;6a99
	nop			;6a9a
	nop			;6a9b
	nop			;6a9c
	nop			;6a9d
	nop			;6a9e
	nop			;6a9f
	nop			;6aa0
	nop			;6aa1
	nop			;6aa2
	nop			;6aa3
	nop			;6aa4
	nop			;6aa5
	nop			;6aa6
	nop			;6aa7
	nop			;6aa8
	nop			;6aa9
	nop			;6aaa
	nop			;6aab
	nop			;6aac
	nop			;6aad
	nop			;6aae
	nop			;6aaf
	nop			;6ab0
	nop			;6ab1
	nop			;6ab2
	nop			;6ab3
	nop			;6ab4
	nop			;6ab5
	nop			;6ab6
	nop			;6ab7
	nop			;6ab8
	nop			;6ab9
	nop			;6aba
	nop			;6abb
	nop			;6abc
	nop			;6abd
	nop			;6abe
	nop			;6abf
	nop			;6ac0
	nop			;6ac1
	nop			;6ac2
	nop			;6ac3
	nop			;6ac4
	nop			;6ac5
	nop			;6ac6
	nop			;6ac7
	nop			;6ac8
	nop			;6ac9
	nop			;6aca
	nop			;6acb
	nop			;6acc
	nop			;6acd
	nop			;6ace
	nop			;6acf
	nop			;6ad0
	nop			;6ad1
	nop			;6ad2
	nop			;6ad3
	nop			;6ad4
	nop			;6ad5
	nop			;6ad6
	nop			;6ad7
	nop			;6ad8
	nop			;6ad9
	nop			;6ada
	nop			;6adb
	nop			;6adc
	nop			;6add
	nop			;6ade
	nop			;6adf
	nop			;6ae0
	nop			;6ae1
	nop			;6ae2
	nop			;6ae3
	nop			;6ae4
	nop			;6ae5
	nop			;6ae6
	nop			;6ae7
	nop			;6ae8
	nop			;6ae9
	nop			;6aea
	nop			;6aeb
	nop			;6aec
	nop			;6aed
	nop			;6aee
	nop			;6aef
	nop			;6af0
	nop			;6af1
	nop			;6af2
	nop			;6af3
	nop			;6af4
	nop			;6af5
	nop			;6af6
	nop			;6af7
	nop			;6af8
	nop			;6af9
	nop			;6afa
	nop			;6afb
	nop			;6afc
	nop			;6afd
	nop			;6afe
	nop			;6aff
	nop			;6b00
	nop			;6b01
	nop			;6b02
	nop			;6b03
	nop			;6b04
	nop			;6b05
	nop			;6b06
	nop			;6b07
	nop			;6b08
	nop			;6b09
	nop			;6b0a
	nop			;6b0b
	nop			;6b0c
	nop			;6b0d
	nop			;6b0e
	nop			;6b0f
	nop			;6b10
	nop			;6b11
	nop			;6b12
	nop			;6b13
	nop			;6b14
	nop			;6b15
	nop			;6b16
	nop			;6b17
	nop			;6b18
	nop			;6b19
	nop			;6b1a
	nop			;6b1b
	nop			;6b1c
	nop			;6b1d
	nop			;6b1e
	nop			;6b1f
	nop			;6b20
	nop			;6b21
	nop			;6b22
	nop			;6b23
	nop			;6b24
	nop			;6b25
	nop			;6b26
	nop			;6b27
	nop			;6b28
	nop			;6b29
	nop			;6b2a
	nop			;6b2b
	nop			;6b2c
	nop			;6b2d
	nop			;6b2e
	nop			;6b2f
	nop			;6b30
	nop			;6b31
	nop			;6b32
	nop			;6b33
	nop			;6b34
	nop			;6b35
	nop			;6b36
	nop			;6b37
	nop			;6b38
	nop			;6b39
	nop			;6b3a
	nop			;6b3b
	nop			;6b3c
	nop			;6b3d
	nop			;6b3e
	nop			;6b3f
	nop			;6b40
	nop			;6b41
	nop			;6b42
	nop			;6b43
	nop			;6b44
	nop			;6b45
	nop			;6b46
	nop			;6b47
	nop			;6b48
	nop			;6b49
	nop			;6b4a
	nop			;6b4b
	nop			;6b4c
	nop			;6b4d
	nop			;6b4e
	nop			;6b4f
	nop			;6b50
	nop			;6b51
	nop			;6b52
	nop			;6b53
	nop			;6b54
	nop			;6b55
	nop			;6b56
	nop			;6b57
	nop			;6b58
	nop			;6b59
	nop			;6b5a
	nop			;6b5b
	nop			;6b5c
	nop			;6b5d
	nop			;6b5e
	nop			;6b5f
	nop			;6b60
	nop			;6b61
	nop			;6b62
	nop			;6b63
	nop			;6b64
	nop			;6b65
	nop			;6b66
	nop			;6b67
	nop			;6b68
	nop			;6b69
	nop			;6b6a
	nop			;6b6b
	nop			;6b6c
	nop			;6b6d
	nop			;6b6e
	nop			;6b6f
	nop			;6b70
	nop			;6b71
	nop			;6b72
	nop			;6b73
	nop			;6b74
	nop			;6b75
	nop			;6b76
	nop			;6b77
	nop			;6b78
	nop			;6b79
	nop			;6b7a
	nop			;6b7b
	nop			;6b7c
	nop			;6b7d
	nop			;6b7e
	nop			;6b7f
	nop			;6b80
	nop			;6b81
	nop			;6b82
	nop			;6b83
	nop			;6b84
	nop			;6b85
	nop			;6b86
	nop			;6b87
	nop			;6b88
	nop			;6b89
	nop			;6b8a
	nop			;6b8b
	nop			;6b8c
	nop			;6b8d
	nop			;6b8e
	nop			;6b8f
	nop			;6b90
	nop			;6b91
	nop			;6b92
	nop			;6b93
	nop			;6b94
	nop			;6b95
	nop			;6b96
	nop			;6b97
	nop			;6b98
	nop			;6b99
	nop			;6b9a
	nop			;6b9b
	nop			;6b9c
	nop			;6b9d
	nop			;6b9e
	nop			;6b9f
	nop			;6ba0
	nop			;6ba1
	nop			;6ba2
	nop			;6ba3
	nop			;6ba4
	nop			;6ba5
	nop			;6ba6
	nop			;6ba7
	nop			;6ba8
	nop			;6ba9
	nop			;6baa
	nop			;6bab
	nop			;6bac
	nop			;6bad
	nop			;6bae
	nop			;6baf
	nop			;6bb0
	nop			;6bb1
	nop			;6bb2
	nop			;6bb3
	nop			;6bb4
	nop			;6bb5
	nop			;6bb6
	nop			;6bb7
	nop			;6bb8
	nop			;6bb9
	nop			;6bba
	nop			;6bbb
	nop			;6bbc
	nop			;6bbd
	nop			;6bbe
	nop			;6bbf
	nop			;6bc0
	nop			;6bc1
	nop			;6bc2
	nop			;6bc3
	nop			;6bc4
	nop			;6bc5
	nop			;6bc6
	nop			;6bc7
	nop			;6bc8
	nop			;6bc9
	nop			;6bca
	nop			;6bcb
	nop			;6bcc
	nop			;6bcd
	nop			;6bce
	nop			;6bcf
	nop			;6bd0
	nop			;6bd1
	nop			;6bd2
	nop			;6bd3
	nop			;6bd4
	nop			;6bd5
	nop			;6bd6
	nop			;6bd7
	nop			;6bd8
	nop			;6bd9
	nop			;6bda
	nop			;6bdb
	nop			;6bdc
	nop			;6bdd
	nop			;6bde
	nop			;6bdf
	nop			;6be0
	nop			;6be1
	nop			;6be2
	nop			;6be3
	nop			;6be4
	nop			;6be5
	nop			;6be6
	nop			;6be7
	nop			;6be8
	nop			;6be9
	nop			;6bea
	nop			;6beb
	nop			;6bec
	nop			;6bed
	nop			;6bee
	nop			;6bef
	nop			;6bf0
	nop			;6bf1
	nop			;6bf2
	nop			;6bf3
	nop			;6bf4
	nop			;6bf5
	nop			;6bf6
	nop			;6bf7
	nop			;6bf8
	nop			;6bf9
	nop			;6bfa
	nop			;6bfb
	nop			;6bfc
	nop			;6bfd
	nop			;6bfe
	nop			;6bff
	nop			;6c00
	nop			;6c01
	nop			;6c02
	nop			;6c03
	nop			;6c04
	nop			;6c05
	nop			;6c06
	nop			;6c07
	nop			;6c08
	nop			;6c09
	nop			;6c0a
	nop			;6c0b
	nop			;6c0c
	nop			;6c0d
	nop			;6c0e
	nop			;6c0f
	nop			;6c10
	nop			;6c11
	nop			;6c12
	nop			;6c13
	nop			;6c14
	nop			;6c15
	nop			;6c16
	nop			;6c17
	nop			;6c18
	nop			;6c19
	nop			;6c1a
	nop			;6c1b
	nop			;6c1c
	nop			;6c1d
	nop			;6c1e
	nop			;6c1f
	nop			;6c20
	nop			;6c21
	nop			;6c22
	nop			;6c23
	nop			;6c24
	nop			;6c25
	nop			;6c26
	nop			;6c27
	nop			;6c28
	nop			;6c29
	nop			;6c2a
	nop			;6c2b
	nop			;6c2c
	nop			;6c2d
	nop			;6c2e
	nop			;6c2f
	nop			;6c30
	nop			;6c31
	nop			;6c32
	nop			;6c33
	nop			;6c34
	nop			;6c35
	nop			;6c36
	nop			;6c37
	nop			;6c38
	nop			;6c39
	nop			;6c3a
	nop			;6c3b
	nop			;6c3c
	nop			;6c3d
	nop			;6c3e
	nop			;6c3f
	nop			;6c40
	nop			;6c41
	nop			;6c42
	nop			;6c43
	nop			;6c44
	nop			;6c45
	nop			;6c46
	nop			;6c47
	nop			;6c48
	nop			;6c49
	nop			;6c4a
	nop			;6c4b
	nop			;6c4c
	nop			;6c4d
	nop			;6c4e
	nop			;6c4f
	nop			;6c50
	nop			;6c51
	nop			;6c52
	nop			;6c53
	nop			;6c54
	nop			;6c55
	nop			;6c56
	nop			;6c57
	nop			;6c58
	nop			;6c59
	nop			;6c5a
	nop			;6c5b
	nop			;6c5c
	nop			;6c5d
	nop			;6c5e
	nop			;6c5f
	nop			;6c60
	nop			;6c61
	nop			;6c62
	nop			;6c63
	nop			;6c64
	nop			;6c65
	nop			;6c66
	nop			;6c67
	nop			;6c68
	nop			;6c69
	nop			;6c6a
	nop			;6c6b
	nop			;6c6c
	nop			;6c6d
	nop			;6c6e
	nop			;6c6f
	nop			;6c70
	nop			;6c71
	nop			;6c72
	nop			;6c73
	nop			;6c74
	nop			;6c75
	nop			;6c76
	nop			;6c77
	nop			;6c78
	nop			;6c79
	nop			;6c7a
	nop			;6c7b
	nop			;6c7c
	nop			;6c7d
	nop			;6c7e
	nop			;6c7f
	nop			;6c80
	nop			;6c81
	nop			;6c82
	nop			;6c83
	nop			;6c84
	nop			;6c85
	nop			;6c86
	nop			;6c87
	nop			;6c88
	nop			;6c89
	nop			;6c8a
	nop			;6c8b
	nop			;6c8c
	nop			;6c8d
	nop			;6c8e
	nop			;6c8f
	nop			;6c90
	nop			;6c91
	nop			;6c92
	nop			;6c93
	nop			;6c94
	nop			;6c95
	nop			;6c96
	nop			;6c97
	nop			;6c98
	nop			;6c99
	nop			;6c9a
	nop			;6c9b
	nop			;6c9c
	nop			;6c9d
	nop			;6c9e
	nop			;6c9f
	nop			;6ca0
	nop			;6ca1
	nop			;6ca2
	nop			;6ca3
	nop			;6ca4
	nop			;6ca5
	nop			;6ca6
	nop			;6ca7
	nop			;6ca8
	nop			;6ca9
	nop			;6caa
	nop			;6cab
	nop			;6cac
	nop			;6cad
	nop			;6cae
	nop			;6caf
	nop			;6cb0
	nop			;6cb1
	nop			;6cb2
	nop			;6cb3
	nop			;6cb4
	nop			;6cb5
	nop			;6cb6
	nop			;6cb7
	nop			;6cb8
	nop			;6cb9
	nop			;6cba
	nop			;6cbb
	nop			;6cbc
	nop			;6cbd
	nop			;6cbe
	nop			;6cbf
	nop			;6cc0
	nop			;6cc1
	nop			;6cc2
	nop			;6cc3
	nop			;6cc4
	nop			;6cc5
	nop			;6cc6
	nop			;6cc7
	nop			;6cc8
	nop			;6cc9
	nop			;6cca
	nop			;6ccb
	nop			;6ccc
	nop			;6ccd
	nop			;6cce
	nop			;6ccf
	nop			;6cd0
	nop			;6cd1
	nop			;6cd2
	nop			;6cd3
	nop			;6cd4
	nop			;6cd5
	nop			;6cd6
	nop			;6cd7
	nop			;6cd8
	nop			;6cd9
	nop			;6cda
	nop			;6cdb
	nop			;6cdc
	nop			;6cdd
	nop			;6cde
	nop			;6cdf
	nop			;6ce0
	nop			;6ce1
	nop			;6ce2
	nop			;6ce3
	nop			;6ce4
	nop			;6ce5
	nop			;6ce6
	nop			;6ce7
	nop			;6ce8
	nop			;6ce9
	nop			;6cea
	nop			;6ceb
	nop			;6cec
	nop			;6ced
	nop			;6cee
	nop			;6cef
	nop			;6cf0
	nop			;6cf1
	nop			;6cf2
	nop			;6cf3
	nop			;6cf4
	nop			;6cf5
	nop			;6cf6
	nop			;6cf7
	nop			;6cf8
	nop			;6cf9
	nop			;6cfa
	nop			;6cfb
	nop			;6cfc
	nop			;6cfd
	nop			;6cfe
	nop			;6cff
	nop			;6d00
	nop			;6d01
	nop			;6d02
	nop			;6d03
	nop			;6d04
	nop			;6d05
	nop			;6d06
	nop			;6d07
	nop			;6d08
	nop			;6d09
	nop			;6d0a
	nop			;6d0b
	nop			;6d0c
	nop			;6d0d
	nop			;6d0e
	nop			;6d0f
	nop			;6d10
	nop			;6d11
	nop			;6d12
	nop			;6d13
	nop			;6d14
	nop			;6d15
	nop			;6d16
	nop			;6d17
	nop			;6d18
	nop			;6d19
	nop			;6d1a
	nop			;6d1b
	nop			;6d1c
	nop			;6d1d
	nop			;6d1e
	nop			;6d1f
	nop			;6d20
	nop			;6d21
	nop			;6d22
	nop			;6d23
	nop			;6d24
	nop			;6d25
	nop			;6d26
	nop			;6d27
	nop			;6d28
	nop			;6d29
	nop			;6d2a
	nop			;6d2b
	nop			;6d2c
	nop			;6d2d
	nop			;6d2e
	nop			;6d2f
	nop			;6d30
	nop			;6d31
	nop			;6d32
	nop			;6d33
	nop			;6d34
	nop			;6d35
	nop			;6d36
	nop			;6d37
	nop			;6d38
	nop			;6d39
	nop			;6d3a
	nop			;6d3b
	nop			;6d3c
	nop			;6d3d
	nop			;6d3e
	nop			;6d3f
	nop			;6d40
	nop			;6d41
	nop			;6d42
	nop			;6d43
	nop			;6d44
	nop			;6d45
	nop			;6d46
	nop			;6d47
	nop			;6d48
	nop			;6d49
	nop			;6d4a
	nop			;6d4b
	nop			;6d4c
	nop			;6d4d
	nop			;6d4e
	nop			;6d4f
	nop			;6d50
	nop			;6d51
	nop			;6d52
	nop			;6d53
	nop			;6d54
	nop			;6d55
	nop			;6d56
	nop			;6d57
	nop			;6d58
	nop			;6d59
	nop			;6d5a
	nop			;6d5b
	nop			;6d5c
	nop			;6d5d
	nop			;6d5e
	nop			;6d5f
	nop			;6d60
	nop			;6d61
	nop			;6d62
	nop			;6d63
	nop			;6d64
	nop			;6d65
	nop			;6d66
	nop			;6d67
	nop			;6d68
	nop			;6d69
	nop			;6d6a
	nop			;6d6b
	nop			;6d6c
	nop			;6d6d
	nop			;6d6e
	nop			;6d6f
	nop			;6d70
	nop			;6d71
	nop			;6d72
	nop			;6d73
	nop			;6d74
	nop			;6d75
	nop			;6d76
	nop			;6d77
	nop			;6d78
	nop			;6d79
	nop			;6d7a
	nop			;6d7b
	nop			;6d7c
	nop			;6d7d
	nop			;6d7e
	nop			;6d7f
	nop			;6d80
	nop			;6d81
	nop			;6d82
	nop			;6d83
	nop			;6d84
	nop			;6d85
	nop			;6d86
	nop			;6d87
	nop			;6d88
	nop			;6d89
	nop			;6d8a
	nop			;6d8b
	nop			;6d8c
	nop			;6d8d
	nop			;6d8e
	nop			;6d8f
	nop			;6d90
	nop			;6d91
	nop			;6d92
	nop			;6d93
	nop			;6d94
	nop			;6d95
	nop			;6d96
	nop			;6d97
	nop			;6d98
	nop			;6d99
	nop			;6d9a
	nop			;6d9b
	nop			;6d9c
	nop			;6d9d
	nop			;6d9e
	nop			;6d9f
	nop			;6da0
	nop			;6da1
	nop			;6da2
	nop			;6da3
	nop			;6da4
	nop			;6da5
	nop			;6da6
	nop			;6da7
	nop			;6da8
	nop			;6da9
	nop			;6daa
	nop			;6dab
	nop			;6dac
	nop			;6dad
	nop			;6dae
	nop			;6daf
	nop			;6db0
	nop			;6db1
	nop			;6db2
	nop			;6db3
	nop			;6db4
	nop			;6db5
	nop			;6db6
	nop			;6db7
	nop			;6db8
	nop			;6db9
	nop			;6dba
	nop			;6dbb
	nop			;6dbc
	nop			;6dbd
	nop			;6dbe
	nop			;6dbf
	nop			;6dc0
	nop			;6dc1
	nop			;6dc2
	nop			;6dc3
	nop			;6dc4
	nop			;6dc5
	nop			;6dc6
	nop			;6dc7
	nop			;6dc8
	nop			;6dc9
	nop			;6dca
	nop			;6dcb
	nop			;6dcc
	nop			;6dcd
	nop			;6dce
	nop			;6dcf
	nop			;6dd0
	nop			;6dd1
	nop			;6dd2
	nop			;6dd3
	nop			;6dd4
	nop			;6dd5
	nop			;6dd6
	nop			;6dd7
	nop			;6dd8
	nop			;6dd9
	nop			;6dda
	nop			;6ddb
	nop			;6ddc
	nop			;6ddd
	nop			;6dde
	nop			;6ddf
	nop			;6de0
	nop			;6de1
	nop			;6de2
	nop			;6de3
	nop			;6de4
	nop			;6de5
	nop			;6de6
	nop			;6de7
	nop			;6de8
	nop			;6de9
	nop			;6dea
	nop			;6deb
	nop			;6dec
	nop			;6ded
	nop			;6dee
	nop			;6def
	nop			;6df0
	nop			;6df1
	nop			;6df2
	nop			;6df3
	nop			;6df4
	nop			;6df5
	nop			;6df6
	nop			;6df7
	nop			;6df8
	nop			;6df9
	nop			;6dfa
	nop			;6dfb
	nop			;6dfc
	nop			;6dfd
	nop			;6dfe
	nop			;6dff
	nop			;6e00
	nop			;6e01
	nop			;6e02
	nop			;6e03
	nop			;6e04
	nop			;6e05
	nop			;6e06
	nop			;6e07
	nop			;6e08
	nop			;6e09
	nop			;6e0a
	nop			;6e0b
	nop			;6e0c
	nop			;6e0d
	nop			;6e0e
	nop			;6e0f
	nop			;6e10
	nop			;6e11
	nop			;6e12
	nop			;6e13
	nop			;6e14
	nop			;6e15
	nop			;6e16
	nop			;6e17
	nop			;6e18
	nop			;6e19
	nop			;6e1a
	nop			;6e1b
	nop			;6e1c
	nop			;6e1d
	nop			;6e1e
	nop			;6e1f
	nop			;6e20
	nop			;6e21
	nop			;6e22
	nop			;6e23
	nop			;6e24
	nop			;6e25
	nop			;6e26
	nop			;6e27
	nop			;6e28
	nop			;6e29
	nop			;6e2a
	nop			;6e2b
	nop			;6e2c
	nop			;6e2d
	nop			;6e2e
	nop			;6e2f
	nop			;6e30
	nop			;6e31
	nop			;6e32
	nop			;6e33
	nop			;6e34
	nop			;6e35
	nop			;6e36
	nop			;6e37
	nop			;6e38
	nop			;6e39
	nop			;6e3a
	nop			;6e3b
	nop			;6e3c
	nop			;6e3d
	nop			;6e3e
	nop			;6e3f
	nop			;6e40
	nop			;6e41
	nop			;6e42
	nop			;6e43
	nop			;6e44
	nop			;6e45
	nop			;6e46
	nop			;6e47
	nop			;6e48
	nop			;6e49
	nop			;6e4a
	nop			;6e4b
	nop			;6e4c
	nop			;6e4d
	nop			;6e4e
	nop			;6e4f
	nop			;6e50
	nop			;6e51
	nop			;6e52
	nop			;6e53
	nop			;6e54
	nop			;6e55
	nop			;6e56
	nop			;6e57
	nop			;6e58
	nop			;6e59
	nop			;6e5a
	nop			;6e5b
	nop			;6e5c
	nop			;6e5d
	nop			;6e5e
	nop			;6e5f
	nop			;6e60
	nop			;6e61
	nop			;6e62
	nop			;6e63
	nop			;6e64
	nop			;6e65
	nop			;6e66
	nop			;6e67
	nop			;6e68
	nop			;6e69
	nop			;6e6a
	nop			;6e6b
	nop			;6e6c
	nop			;6e6d
	nop			;6e6e
	nop			;6e6f
	nop			;6e70
	nop			;6e71
	nop			;6e72
	nop			;6e73
	nop			;6e74
	nop			;6e75
	nop			;6e76
	nop			;6e77
	nop			;6e78
	nop			;6e79
	nop			;6e7a
	nop			;6e7b
	nop			;6e7c
	nop			;6e7d
	nop			;6e7e
	nop			;6e7f
	nop			;6e80
	nop			;6e81
	nop			;6e82
	nop			;6e83
	nop			;6e84
	nop			;6e85
	nop			;6e86
	nop			;6e87
	nop			;6e88
	nop			;6e89
	nop			;6e8a
	nop			;6e8b
	nop			;6e8c
	nop			;6e8d
	nop			;6e8e
	nop			;6e8f
	nop			;6e90
	nop			;6e91
	nop			;6e92
	nop			;6e93
	nop			;6e94
	nop			;6e95
	nop			;6e96
	nop			;6e97
	nop			;6e98
	nop			;6e99
	nop			;6e9a
	nop			;6e9b
	nop			;6e9c
	nop			;6e9d
	nop			;6e9e
	nop			;6e9f
	nop			;6ea0
	nop			;6ea1
	nop			;6ea2
	nop			;6ea3
	nop			;6ea4
	nop			;6ea5
	nop			;6ea6
	nop			;6ea7
	nop			;6ea8
	nop			;6ea9
	nop			;6eaa
	nop			;6eab
	nop			;6eac
	nop			;6ead
	nop			;6eae
	nop			;6eaf
	nop			;6eb0
	nop			;6eb1
	nop			;6eb2
	nop			;6eb3
	nop			;6eb4
	nop			;6eb5
	nop			;6eb6
	nop			;6eb7
	nop			;6eb8
	nop			;6eb9
	nop			;6eba
	nop			;6ebb
	nop			;6ebc
	nop			;6ebd
	nop			;6ebe
	nop			;6ebf
	nop			;6ec0
	nop			;6ec1
	nop			;6ec2
	nop			;6ec3
	nop			;6ec4
	nop			;6ec5
	nop			;6ec6
	nop			;6ec7
	nop			;6ec8
	nop			;6ec9
	nop			;6eca
	nop			;6ecb
	nop			;6ecc
	nop			;6ecd
	nop			;6ece
	nop			;6ecf
	nop			;6ed0
	nop			;6ed1
	nop			;6ed2
	nop			;6ed3
	nop			;6ed4
	nop			;6ed5
	nop			;6ed6
	nop			;6ed7
	nop			;6ed8
	nop			;6ed9
	nop			;6eda
	nop			;6edb
	nop			;6edc
	nop			;6edd
	nop			;6ede
	nop			;6edf
	nop			;6ee0
	nop			;6ee1
	nop			;6ee2
	nop			;6ee3
	nop			;6ee4
	nop			;6ee5
	nop			;6ee6
	nop			;6ee7
	nop			;6ee8
	nop			;6ee9
	nop			;6eea
	nop			;6eeb
	nop			;6eec
	nop			;6eed
	nop			;6eee
	nop			;6eef
	nop			;6ef0
	nop			;6ef1
	nop			;6ef2
	nop			;6ef3
	nop			;6ef4
	nop			;6ef5
	nop			;6ef6
	nop			;6ef7
	nop			;6ef8
	nop			;6ef9
	nop			;6efa
	nop			;6efb
	nop			;6efc
	nop			;6efd
	nop			;6efe
	nop			;6eff
	nop			;6f00
	nop			;6f01
	nop			;6f02
	nop			;6f03
	nop			;6f04
	nop			;6f05
	nop			;6f06
	nop			;6f07
	nop			;6f08
	nop			;6f09
	nop			;6f0a
	nop			;6f0b
	nop			;6f0c
	nop			;6f0d
	nop			;6f0e
	nop			;6f0f
	nop			;6f10
	nop			;6f11
	nop			;6f12
	nop			;6f13
	nop			;6f14
	nop			;6f15
	nop			;6f16
	nop			;6f17
	nop			;6f18
	nop			;6f19
	nop			;6f1a
	nop			;6f1b
	nop			;6f1c
	nop			;6f1d
	nop			;6f1e
	nop			;6f1f
	nop			;6f20
	nop			;6f21
	nop			;6f22
	nop			;6f23
	nop			;6f24
	nop			;6f25
	nop			;6f26
	nop			;6f27
	nop			;6f28
	nop			;6f29
	nop			;6f2a
	nop			;6f2b
	nop			;6f2c
	nop			;6f2d
	nop			;6f2e
	nop			;6f2f
	nop			;6f30
	nop			;6f31
	nop			;6f32
	nop			;6f33
	nop			;6f34
	nop			;6f35
	nop			;6f36
	nop			;6f37
	nop			;6f38
	nop			;6f39
	nop			;6f3a
	nop			;6f3b
	nop			;6f3c
	nop			;6f3d
	nop			;6f3e
	nop			;6f3f
	nop			;6f40
	nop			;6f41
	nop			;6f42
	nop			;6f43
	nop			;6f44
	nop			;6f45
	nop			;6f46
	nop			;6f47
	nop			;6f48
	nop			;6f49
	nop			;6f4a
	nop			;6f4b
	nop			;6f4c
	nop			;6f4d
	nop			;6f4e
	nop			;6f4f
	nop			;6f50
	nop			;6f51
	nop			;6f52
	nop			;6f53
	nop			;6f54
	nop			;6f55
	nop			;6f56
	nop			;6f57
	nop			;6f58
	nop			;6f59
	nop			;6f5a
	nop			;6f5b
	nop			;6f5c
	nop			;6f5d
	nop			;6f5e
	nop			;6f5f
	nop			;6f60
	nop			;6f61
	nop			;6f62
	nop			;6f63
	nop			;6f64
	nop			;6f65
	nop			;6f66
	nop			;6f67
	nop			;6f68
	nop			;6f69
	nop			;6f6a
	nop			;6f6b
	nop			;6f6c
	nop			;6f6d
	nop			;6f6e
	nop			;6f6f
	nop			;6f70
	nop			;6f71
	nop			;6f72
	nop			;6f73
	nop			;6f74
	nop			;6f75
	nop			;6f76
	nop			;6f77
	nop			;6f78
	nop			;6f79
	nop			;6f7a
	nop			;6f7b
	nop			;6f7c
	nop			;6f7d
	nop			;6f7e
	nop			;6f7f
	nop			;6f80
	nop			;6f81
	nop			;6f82
	nop			;6f83
	nop			;6f84
	nop			;6f85
	nop			;6f86
	nop			;6f87
	nop			;6f88
	nop			;6f89
	nop			;6f8a
	nop			;6f8b
	nop			;6f8c
	nop			;6f8d
	nop			;6f8e
	nop			;6f8f
	nop			;6f90
	nop			;6f91
	nop			;6f92
	nop			;6f93
	nop			;6f94
	nop			;6f95
	nop			;6f96
	nop			;6f97
	nop			;6f98
	nop			;6f99
	nop			;6f9a
	nop			;6f9b
	nop			;6f9c
	nop			;6f9d
	nop			;6f9e
	nop			;6f9f
	nop			;6fa0
	nop			;6fa1
	nop			;6fa2
	nop			;6fa3
	nop			;6fa4
	nop			;6fa5
	nop			;6fa6
	nop			;6fa7
	nop			;6fa8
	nop			;6fa9
	nop			;6faa
	nop			;6fab
	nop			;6fac
	nop			;6fad
	nop			;6fae
	nop			;6faf
	nop			;6fb0
	nop			;6fb1
	nop			;6fb2
	nop			;6fb3
	nop			;6fb4
	nop			;6fb5
	nop			;6fb6
	nop			;6fb7
	nop			;6fb8
	nop			;6fb9
	nop			;6fba
	nop			;6fbb
	nop			;6fbc
	nop			;6fbd
	nop			;6fbe
	nop			;6fbf
	nop			;6fc0
	nop			;6fc1
	nop			;6fc2
	nop			;6fc3
	nop			;6fc4
	nop			;6fc5
	nop			;6fc6
	nop			;6fc7
	nop			;6fc8
	nop			;6fc9
	nop			;6fca
	nop			;6fcb
	nop			;6fcc
	nop			;6fcd
	nop			;6fce
	nop			;6fcf
	nop			;6fd0
	nop			;6fd1
	nop			;6fd2
	nop			;6fd3
	nop			;6fd4
	nop			;6fd5
	nop			;6fd6
	nop			;6fd7
	nop			;6fd8
	nop			;6fd9
	nop			;6fda
	nop			;6fdb
	nop			;6fdc
	nop			;6fdd
	nop			;6fde
	nop			;6fdf
	nop			;6fe0
	nop			;6fe1
	nop			;6fe2
	nop			;6fe3
	nop			;6fe4
	nop			;6fe5
	nop			;6fe6
	nop			;6fe7
	nop			;6fe8
	nop			;6fe9
	nop			;6fea
	nop			;6feb
	nop			;6fec
	nop			;6fed
	nop			;6fee
	nop			;6fef
	nop			;6ff0
	nop			;6ff1
	nop			;6ff2
	nop			;6ff3
	nop			;6ff4
	nop			;6ff5
	nop			;6ff6
	nop			;6ff7
	nop			;6ff8
	nop			;6ff9
	nop			;6ffa
	nop			;6ffb
	nop			;6ffc
	nop			;6ffd
	nop			;6ffe
	nop			;6fff
	nop			;7000
	nop			;7001
	nop			;7002
	nop			;7003
	nop			;7004
	nop			;7005
	nop			;7006
	nop			;7007
	nop			;7008
	nop			;7009
	nop			;700a
	nop			;700b
	nop			;700c
	nop			;700d
	nop			;700e
	nop			;700f
	nop			;7010
	nop			;7011
	nop			;7012
	nop			;7013
	nop			;7014
	nop			;7015
	nop			;7016
	nop			;7017
	nop			;7018
	nop			;7019
	nop			;701a
	nop			;701b
	nop			;701c
	nop			;701d
	nop			;701e
	nop			;701f
	nop			;7020
	nop			;7021
	nop			;7022
	nop			;7023
	nop			;7024
	nop			;7025
	nop			;7026
	nop			;7027
	nop			;7028
	nop			;7029
	nop			;702a
	nop			;702b
	nop			;702c
	nop			;702d
	nop			;702e
	nop			;702f
	nop			;7030
	nop			;7031
	nop			;7032
	nop			;7033
	nop			;7034
	nop			;7035
	nop			;7036
	nop			;7037
	nop			;7038
	nop			;7039
	nop			;703a
	nop			;703b
	nop			;703c
	nop			;703d
	nop			;703e
	nop			;703f
	nop			;7040
	nop			;7041
	nop			;7042
	nop			;7043
	nop			;7044
	nop			;7045
	nop			;7046
	nop			;7047
	nop			;7048
	nop			;7049
	nop			;704a
	nop			;704b
	nop			;704c
	nop			;704d
	nop			;704e
	nop			;704f
	nop			;7050
	nop			;7051
	nop			;7052
	nop			;7053
	nop			;7054
	nop			;7055
	nop			;7056
	nop			;7057
	nop			;7058
	nop			;7059
	nop			;705a
	nop			;705b
	nop			;705c
	nop			;705d
	nop			;705e
	nop			;705f
	nop			;7060
	nop			;7061
	nop			;7062
	nop			;7063
	nop			;7064
	nop			;7065
	nop			;7066
	nop			;7067
	nop			;7068
	nop			;7069
	nop			;706a
	nop			;706b
	nop			;706c
	nop			;706d
	nop			;706e
	nop			;706f
	nop			;7070
	nop			;7071
	nop			;7072
	nop			;7073
	nop			;7074
	nop			;7075
	nop			;7076
	nop			;7077
	nop			;7078
	nop			;7079
	nop			;707a
	nop			;707b
	nop			;707c
	nop			;707d
	nop			;707e
	nop			;707f
	nop			;7080
	nop			;7081
	nop			;7082
	nop			;7083
	nop			;7084
	nop			;7085
	nop			;7086
	nop			;7087
	nop			;7088
	nop			;7089
	nop			;708a
	nop			;708b
	nop			;708c
	nop			;708d
	nop			;708e
	nop			;708f
	nop			;7090
	nop			;7091
	nop			;7092
	nop			;7093
	nop			;7094
	nop			;7095
	nop			;7096
	nop			;7097
	nop			;7098
	nop			;7099
	nop			;709a
	nop			;709b
	nop			;709c
	nop			;709d
	nop			;709e
	nop			;709f
	nop			;70a0
	nop			;70a1
	nop			;70a2
	nop			;70a3
	nop			;70a4
	nop			;70a5
	nop			;70a6
	nop			;70a7
	nop			;70a8
	nop			;70a9
	nop			;70aa
	nop			;70ab
	nop			;70ac
	nop			;70ad
	nop			;70ae
	nop			;70af
	nop			;70b0
	nop			;70b1
	nop			;70b2
	nop			;70b3
	nop			;70b4
	nop			;70b5
	nop			;70b6
	nop			;70b7
	nop			;70b8
	nop			;70b9
	nop			;70ba
	nop			;70bb
	nop			;70bc
	nop			;70bd
	nop			;70be
	nop			;70bf
	nop			;70c0
	nop			;70c1
	nop			;70c2
	nop			;70c3
	nop			;70c4
	nop			;70c5
	nop			;70c6
	nop			;70c7
	nop			;70c8
	nop			;70c9
	nop			;70ca
	nop			;70cb
	nop			;70cc
	nop			;70cd
	nop			;70ce
	nop			;70cf
	nop			;70d0
	nop			;70d1
	nop			;70d2
	nop			;70d3
	nop			;70d4
	nop			;70d5
	nop			;70d6
	nop			;70d7
	nop			;70d8
	nop			;70d9
	nop			;70da
	nop			;70db
	nop			;70dc
	nop			;70dd
	nop			;70de
	nop			;70df
	nop			;70e0
	nop			;70e1
	nop			;70e2
	nop			;70e3
	nop			;70e4
	nop			;70e5
	nop			;70e6
	nop			;70e7
	nop			;70e8
	nop			;70e9
	nop			;70ea
	nop			;70eb
	nop			;70ec
	nop			;70ed
	nop			;70ee
	nop			;70ef
	nop			;70f0
	nop			;70f1
	nop			;70f2
	nop			;70f3
	nop			;70f4
	nop			;70f5
	nop			;70f6
	nop			;70f7
	nop			;70f8
	nop			;70f9
	nop			;70fa
	nop			;70fb
	nop			;70fc
	nop			;70fd
	nop			;70fe
	nop			;70ff
	nop			;7100
	nop			;7101
	nop			;7102
	nop			;7103
	nop			;7104
	nop			;7105
	nop			;7106
	nop			;7107
	nop			;7108
	nop			;7109
	nop			;710a
	nop			;710b
	nop			;710c
	nop			;710d
	nop			;710e
	nop			;710f
	nop			;7110
	nop			;7111
	nop			;7112
	nop			;7113
	nop			;7114
	nop			;7115
	nop			;7116
	nop			;7117
	nop			;7118
	nop			;7119
	nop			;711a
	nop			;711b
	nop			;711c
	nop			;711d
	nop			;711e
	nop			;711f
	nop			;7120
	nop			;7121
	nop			;7122
	nop			;7123
	nop			;7124
	nop			;7125
	nop			;7126
	nop			;7127
	nop			;7128
	nop			;7129
	nop			;712a
	nop			;712b
	nop			;712c
	nop			;712d
	nop			;712e
	nop			;712f
	nop			;7130
	nop			;7131
	nop			;7132
	nop			;7133
	nop			;7134
	nop			;7135
	nop			;7136
	nop			;7137
	nop			;7138
	nop			;7139
	nop			;713a
	nop			;713b
	nop			;713c
	nop			;713d
	nop			;713e
	nop			;713f
	nop			;7140
	nop			;7141
	nop			;7142
	nop			;7143
	nop			;7144
	nop			;7145
	nop			;7146
	nop			;7147
	nop			;7148
	nop			;7149
	nop			;714a
	nop			;714b
	nop			;714c
	nop			;714d
	nop			;714e
	nop			;714f
	nop			;7150
	nop			;7151
	nop			;7152
	nop			;7153
	nop			;7154
	nop			;7155
	nop			;7156
	nop			;7157
	nop			;7158
	nop			;7159
	nop			;715a
	nop			;715b
	nop			;715c
	nop			;715d
	nop			;715e
	nop			;715f
	nop			;7160
	nop			;7161
	nop			;7162
	nop			;7163
	nop			;7164
	nop			;7165
	nop			;7166
	nop			;7167
	nop			;7168
	nop			;7169
	nop			;716a
	nop			;716b
	nop			;716c
	nop			;716d
	nop			;716e
	nop			;716f
	nop			;7170
	nop			;7171
	nop			;7172
	nop			;7173
	nop			;7174
	nop			;7175
	nop			;7176
	nop			;7177
	nop			;7178
	nop			;7179
	nop			;717a
	nop			;717b
	nop			;717c
	nop			;717d
	nop			;717e
	nop			;717f
	nop			;7180
	nop			;7181
	nop			;7182
	nop			;7183
	nop			;7184
	nop			;7185
	nop			;7186
	nop			;7187
	nop			;7188
	nop			;7189
	nop			;718a
	nop			;718b
	nop			;718c
	nop			;718d
	nop			;718e
	nop			;718f
	nop			;7190
	nop			;7191
	nop			;7192
	nop			;7193
	nop			;7194
	nop			;7195
	nop			;7196
	nop			;7197
	nop			;7198
	nop			;7199
	nop			;719a
	nop			;719b
	nop			;719c
	nop			;719d
	nop			;719e
	nop			;719f
	nop			;71a0
	nop			;71a1
	nop			;71a2
	nop			;71a3
	nop			;71a4
	nop			;71a5
	nop			;71a6
	nop			;71a7
	nop			;71a8
	nop			;71a9
	nop			;71aa
	nop			;71ab
	nop			;71ac
	nop			;71ad
	nop			;71ae
	nop			;71af
	nop			;71b0
	nop			;71b1
	nop			;71b2
	nop			;71b3
	nop			;71b4
	nop			;71b5
	nop			;71b6
	nop			;71b7
	nop			;71b8
	nop			;71b9
	nop			;71ba
	nop			;71bb
	nop			;71bc
	nop			;71bd
	nop			;71be
	nop			;71bf
	nop			;71c0
	nop			;71c1
	nop			;71c2
	nop			;71c3
	nop			;71c4
	nop			;71c5
	nop			;71c6
	nop			;71c7
	nop			;71c8
	nop			;71c9
	nop			;71ca
	nop			;71cb
	nop			;71cc
	nop			;71cd
	nop			;71ce
	nop			;71cf
	nop			;71d0
	nop			;71d1
	nop			;71d2
	nop			;71d3
	nop			;71d4
	nop			;71d5
	nop			;71d6
	nop			;71d7
	nop			;71d8
	nop			;71d9
	nop			;71da
	nop			;71db
	nop			;71dc
	nop			;71dd
	nop			;71de
	nop			;71df
	nop			;71e0
	nop			;71e1
	nop			;71e2
	nop			;71e3
	nop			;71e4
	nop			;71e5
	nop			;71e6
	nop			;71e7
	nop			;71e8
	nop			;71e9
	nop			;71ea
	nop			;71eb
	nop			;71ec
	nop			;71ed
	nop			;71ee
	nop			;71ef
	nop			;71f0
	nop			;71f1
	nop			;71f2
	nop			;71f3
	nop			;71f4
	nop			;71f5
	nop			;71f6
	nop			;71f7
	nop			;71f8
	nop			;71f9
	nop			;71fa
	nop			;71fb
	nop			;71fc
	nop			;71fd
	nop			;71fe
	nop			;71ff
	nop			;7200
	nop			;7201
	nop			;7202
	nop			;7203
	nop			;7204
	nop			;7205
	nop			;7206
	nop			;7207
	nop			;7208
	nop			;7209
	nop			;720a
	nop			;720b
	nop			;720c
	nop			;720d
	nop			;720e
	nop			;720f
	nop			;7210
	nop			;7211
	nop			;7212
	nop			;7213
	nop			;7214
	nop			;7215
	nop			;7216
	nop			;7217
	nop			;7218
	nop			;7219
	nop			;721a
	nop			;721b
	nop			;721c
	nop			;721d
	nop			;721e
	nop			;721f
	nop			;7220
	nop			;7221
	nop			;7222
	nop			;7223
	nop			;7224
	nop			;7225
	nop			;7226
	nop			;7227
	nop			;7228
	nop			;7229
	nop			;722a
	nop			;722b
	nop			;722c
	nop			;722d
	nop			;722e
	nop			;722f
	nop			;7230
	nop			;7231
	nop			;7232
	nop			;7233
	nop			;7234
	nop			;7235
	nop			;7236
	nop			;7237
	nop			;7238
	nop			;7239
	nop			;723a
	nop			;723b
	nop			;723c
	nop			;723d
	nop			;723e
	nop			;723f
	nop			;7240
	nop			;7241
	nop			;7242
	nop			;7243
	nop			;7244
	nop			;7245
	nop			;7246
	nop			;7247
	nop			;7248
	nop			;7249
	nop			;724a
	nop			;724b
	nop			;724c
	nop			;724d
	nop			;724e
	nop			;724f
	nop			;7250
	nop			;7251
	nop			;7252
	nop			;7253
	nop			;7254
	nop			;7255
	nop			;7256
	nop			;7257
	nop			;7258
	nop			;7259
	nop			;725a
	nop			;725b
	nop			;725c
	nop			;725d
	nop			;725e
	nop			;725f
	nop			;7260
	nop			;7261
	nop			;7262
	nop			;7263
	nop			;7264
	nop			;7265
	nop			;7266
	nop			;7267
	nop			;7268
	nop			;7269
	nop			;726a
	nop			;726b
	nop			;726c
	nop			;726d
	nop			;726e
	nop			;726f
	nop			;7270
	nop			;7271
	nop			;7272
	nop			;7273
	nop			;7274
	nop			;7275
	nop			;7276
	nop			;7277
	nop			;7278
	nop			;7279
	nop			;727a
	nop			;727b
	nop			;727c
	nop			;727d
	nop			;727e
	nop			;727f
	nop			;7280
	nop			;7281
	nop			;7282
	nop			;7283
	nop			;7284
	nop			;7285
	nop			;7286
	nop			;7287
	nop			;7288
	nop			;7289
	nop			;728a
	nop			;728b
	nop			;728c
	nop			;728d
	nop			;728e
	nop			;728f
	nop			;7290
	nop			;7291
	nop			;7292
	nop			;7293
	nop			;7294
	nop			;7295
	nop			;7296
	nop			;7297
	nop			;7298
	nop			;7299
	nop			;729a
	nop			;729b
	nop			;729c
	nop			;729d
	nop			;729e
	nop			;729f
	nop			;72a0
	nop			;72a1
	nop			;72a2
	nop			;72a3
	nop			;72a4
	nop			;72a5
	nop			;72a6
	nop			;72a7
	nop			;72a8
	nop			;72a9
	nop			;72aa
	nop			;72ab
	nop			;72ac
	nop			;72ad
	nop			;72ae
	nop			;72af
	nop			;72b0
	nop			;72b1
	nop			;72b2
	nop			;72b3
	nop			;72b4
	nop			;72b5
	nop			;72b6
	nop			;72b7
	nop			;72b8
	nop			;72b9
	nop			;72ba
	nop			;72bb
	nop			;72bc
	nop			;72bd
	nop			;72be
	nop			;72bf
	nop			;72c0
	nop			;72c1
	nop			;72c2
	nop			;72c3
	nop			;72c4
	nop			;72c5
	nop			;72c6
	nop			;72c7
	nop			;72c8
	nop			;72c9
	nop			;72ca
	nop			;72cb
	nop			;72cc
	nop			;72cd
	nop			;72ce
	nop			;72cf
	nop			;72d0
	nop			;72d1
	nop			;72d2
	nop			;72d3
	nop			;72d4
	nop			;72d5
	nop			;72d6
	nop			;72d7
	nop			;72d8
	nop			;72d9
	nop			;72da
	nop			;72db
	nop			;72dc
	nop			;72dd
	nop			;72de
	nop			;72df
	nop			;72e0
	nop			;72e1
	nop			;72e2
	nop			;72e3
	nop			;72e4
	nop			;72e5
	nop			;72e6
	nop			;72e7
	nop			;72e8
	nop			;72e9
	nop			;72ea
	nop			;72eb
	nop			;72ec
	nop			;72ed
	nop			;72ee
	nop			;72ef
	nop			;72f0
	nop			;72f1
	nop			;72f2
	nop			;72f3
	nop			;72f4
	nop			;72f5
	nop			;72f6
	nop			;72f7
	nop			;72f8
	nop			;72f9
	nop			;72fa
	nop			;72fb
	nop			;72fc
	nop			;72fd
	nop			;72fe
	nop			;72ff
	nop			;7300
	nop			;7301
	nop			;7302
	nop			;7303
	nop			;7304
	nop			;7305
	nop			;7306
	nop			;7307
	nop			;7308
	nop			;7309
	nop			;730a
	nop			;730b
	nop			;730c
	nop			;730d
	nop			;730e
	nop			;730f
	nop			;7310
	nop			;7311
	nop			;7312
	nop			;7313
	nop			;7314
	nop			;7315
	nop			;7316
	nop			;7317
	nop			;7318
	nop			;7319
	nop			;731a
	nop			;731b
	nop			;731c
	nop			;731d
	nop			;731e
	nop			;731f
	nop			;7320
	nop			;7321
	nop			;7322
	nop			;7323
	nop			;7324
	nop			;7325
	nop			;7326
	nop			;7327
	nop			;7328
	nop			;7329
	nop			;732a
	nop			;732b
	nop			;732c
	nop			;732d
	nop			;732e
	nop			;732f
	nop			;7330
	nop			;7331
	nop			;7332
	nop			;7333
	nop			;7334
	nop			;7335
	nop			;7336
	nop			;7337
	nop			;7338
	nop			;7339
	nop			;733a
	nop			;733b
	nop			;733c
	nop			;733d
	nop			;733e
	nop			;733f
	nop			;7340
	nop			;7341
	nop			;7342
	nop			;7343
	nop			;7344
	nop			;7345
	nop			;7346
	nop			;7347
	nop			;7348
	nop			;7349
	nop			;734a
	nop			;734b
	nop			;734c
	nop			;734d
	nop			;734e
	nop			;734f
	nop			;7350
	nop			;7351
	nop			;7352
	nop			;7353
	nop			;7354
	nop			;7355
	nop			;7356
	nop			;7357
	nop			;7358
	nop			;7359
	nop			;735a
	nop			;735b
	nop			;735c
	nop			;735d
	nop			;735e
	nop			;735f
	nop			;7360
	nop			;7361
	nop			;7362
	nop			;7363
	nop			;7364
	nop			;7365
	nop			;7366
	nop			;7367
	nop			;7368
	nop			;7369
	nop			;736a
	nop			;736b
	nop			;736c
	nop			;736d
	nop			;736e
	nop			;736f
	nop			;7370
	nop			;7371
	nop			;7372
	nop			;7373
	nop			;7374
	nop			;7375
	nop			;7376
	nop			;7377
	nop			;7378
	nop			;7379
	nop			;737a
	nop			;737b
	nop			;737c
	nop			;737d
	nop			;737e
	nop			;737f
	nop			;7380
	nop			;7381
	nop			;7382
	nop			;7383
	nop			;7384
	nop			;7385
	nop			;7386
	nop			;7387
	nop			;7388
	nop			;7389
	nop			;738a
	nop			;738b
	nop			;738c
	nop			;738d
	nop			;738e
	nop			;738f
	nop			;7390
	nop			;7391
	nop			;7392
	nop			;7393
	nop			;7394
	nop			;7395
	nop			;7396
	nop			;7397
	nop			;7398
	nop			;7399
	nop			;739a
	nop			;739b
	nop			;739c
	nop			;739d
	nop			;739e
	nop			;739f
	nop			;73a0
	nop			;73a1
	nop			;73a2
	nop			;73a3
	nop			;73a4
	nop			;73a5
	nop			;73a6
	nop			;73a7
	nop			;73a8
	nop			;73a9
	nop			;73aa
	nop			;73ab
	nop			;73ac
	nop			;73ad
	nop			;73ae
	nop			;73af
	nop			;73b0
	nop			;73b1
	nop			;73b2
	nop			;73b3
	nop			;73b4
	nop			;73b5
	nop			;73b6
	nop			;73b7
	nop			;73b8
	nop			;73b9
	nop			;73ba
	nop			;73bb
	nop			;73bc
	nop			;73bd
	nop			;73be
	nop			;73bf
	nop			;73c0
	nop			;73c1
	nop			;73c2
	nop			;73c3
	nop			;73c4
	nop			;73c5
	nop			;73c6
	nop			;73c7
	nop			;73c8
	nop			;73c9
	nop			;73ca
	nop			;73cb
	nop			;73cc
	nop			;73cd
	nop			;73ce
	nop			;73cf
	nop			;73d0
	nop			;73d1
	nop			;73d2
	nop			;73d3
	nop			;73d4
	nop			;73d5
	nop			;73d6
	nop			;73d7
	nop			;73d8
	nop			;73d9
	nop			;73da
	nop			;73db
	nop			;73dc
	nop			;73dd
	nop			;73de
	nop			;73df
	nop			;73e0
	nop			;73e1
	nop			;73e2
	nop			;73e3
	nop			;73e4
	nop			;73e5
	nop			;73e6
	nop			;73e7
	nop			;73e8
	nop			;73e9
	nop			;73ea
	nop			;73eb
	nop			;73ec
	nop			;73ed
	nop			;73ee
	nop			;73ef
	nop			;73f0
	nop			;73f1
	nop			;73f2
	nop			;73f3
	nop			;73f4
	nop			;73f5
	nop			;73f6
	nop			;73f7
	nop			;73f8
	nop			;73f9
	nop			;73fa
	nop			;73fb
	nop			;73fc
	nop			;73fd
	nop			;73fe
	nop			;73ff
	nop			;7400
	nop			;7401
	nop			;7402
	nop			;7403
	nop			;7404
	nop			;7405
	nop			;7406
	nop			;7407
	nop			;7408
	nop			;7409
	nop			;740a
	nop			;740b
	nop			;740c
	nop			;740d
	nop			;740e
	nop			;740f
	nop			;7410
	nop			;7411
	nop			;7412
	nop			;7413
	nop			;7414
	nop			;7415
	nop			;7416
	nop			;7417
	nop			;7418
	nop			;7419
	nop			;741a
	nop			;741b
	nop			;741c
	nop			;741d
	nop			;741e
	nop			;741f
	nop			;7420
	nop			;7421
	nop			;7422
	nop			;7423
	nop			;7424
	nop			;7425
	nop			;7426
	nop			;7427
	nop			;7428
	nop			;7429
	nop			;742a
	nop			;742b
	nop			;742c
	nop			;742d
	nop			;742e
	nop			;742f
	nop			;7430
	nop			;7431
	nop			;7432
	nop			;7433
	nop			;7434
	nop			;7435
	nop			;7436
	nop			;7437
	nop			;7438
	nop			;7439
	nop			;743a
	nop			;743b
	nop			;743c
	nop			;743d
	nop			;743e
	nop			;743f
	nop			;7440
	nop			;7441
	nop			;7442
	nop			;7443
	nop			;7444
	nop			;7445
	nop			;7446
	nop			;7447
	nop			;7448
	nop			;7449
	nop			;744a
	nop			;744b
	nop			;744c
	nop			;744d
	nop			;744e
	nop			;744f
	nop			;7450
	nop			;7451
	nop			;7452
	nop			;7453
	nop			;7454
	nop			;7455
	nop			;7456
	nop			;7457
	nop			;7458
	nop			;7459
	nop			;745a
	nop			;745b
	nop			;745c
	nop			;745d
	nop			;745e
	nop			;745f
	nop			;7460
	nop			;7461
	nop			;7462
	nop			;7463
	nop			;7464
	nop			;7465
	nop			;7466
	nop			;7467
	nop			;7468
	nop			;7469
	nop			;746a
	nop			;746b
	nop			;746c
	nop			;746d
	nop			;746e
	nop			;746f
	nop			;7470
	nop			;7471
	nop			;7472
	nop			;7473
	nop			;7474
	nop			;7475
	nop			;7476
	nop			;7477
	nop			;7478
	nop			;7479
	nop			;747a
	nop			;747b
	nop			;747c
	nop			;747d
	nop			;747e
	nop			;747f
	nop			;7480
	nop			;7481
	nop			;7482
	nop			;7483
	nop			;7484
	nop			;7485
	nop			;7486
	nop			;7487
	nop			;7488
	nop			;7489
	nop			;748a
	nop			;748b
	nop			;748c
	nop			;748d
	nop			;748e
	nop			;748f
	nop			;7490
	nop			;7491
	nop			;7492
	nop			;7493
	nop			;7494
	nop			;7495
	nop			;7496
	nop			;7497
	nop			;7498
	nop			;7499
	nop			;749a
	nop			;749b
	nop			;749c
	nop			;749d
	nop			;749e
	nop			;749f
	nop			;74a0
	nop			;74a1
	nop			;74a2
	nop			;74a3
	nop			;74a4
	nop			;74a5
	nop			;74a6
	nop			;74a7
	nop			;74a8
	nop			;74a9
	nop			;74aa
	nop			;74ab
	nop			;74ac
	nop			;74ad
	nop			;74ae
	nop			;74af
	nop			;74b0
	nop			;74b1
	nop			;74b2
	nop			;74b3
	nop			;74b4
	nop			;74b5
	nop			;74b6
	nop			;74b7
	nop			;74b8
	nop			;74b9
	nop			;74ba
	nop			;74bb
	nop			;74bc
	nop			;74bd
	nop			;74be
	nop			;74bf
	nop			;74c0
	nop			;74c1
	nop			;74c2
	nop			;74c3
	nop			;74c4
	nop			;74c5
	nop			;74c6
	nop			;74c7
	nop			;74c8
	nop			;74c9
	nop			;74ca
	nop			;74cb
	nop			;74cc
	nop			;74cd
	nop			;74ce
	nop			;74cf
	nop			;74d0
	nop			;74d1
	nop			;74d2
	nop			;74d3
	nop			;74d4
	nop			;74d5
	nop			;74d6
	nop			;74d7
	nop			;74d8
	nop			;74d9
	nop			;74da
	nop			;74db
	nop			;74dc
	nop			;74dd
	nop			;74de
	nop			;74df
	nop			;74e0
	nop			;74e1
	nop			;74e2
	nop			;74e3
	nop			;74e4
	nop			;74e5
	nop			;74e6
	nop			;74e7
	nop			;74e8
	nop			;74e9
	nop			;74ea
	nop			;74eb
	nop			;74ec
	nop			;74ed
	nop			;74ee
	nop			;74ef
	nop			;74f0
	nop			;74f1
	nop			;74f2
	nop			;74f3
	nop			;74f4
	nop			;74f5
	nop			;74f6
	nop			;74f7
	nop			;74f8
	nop			;74f9
	nop			;74fa
	nop			;74fb
	nop			;74fc
	nop			;74fd
	nop			;74fe
	nop			;74ff
	nop			;7500
	nop			;7501
	nop			;7502
	nop			;7503
	nop			;7504
	nop			;7505
	nop			;7506
	nop			;7507
	nop			;7508
	nop			;7509
	nop			;750a
	nop			;750b
	nop			;750c
	nop			;750d
	nop			;750e
	nop			;750f
	nop			;7510
	nop			;7511
	nop			;7512
	nop			;7513
	nop			;7514
	nop			;7515
	nop			;7516
	nop			;7517
	nop			;7518
	nop			;7519
	nop			;751a
	nop			;751b
	nop			;751c
	nop			;751d
	nop			;751e
	nop			;751f
	nop			;7520
	nop			;7521
	nop			;7522
	nop			;7523
	nop			;7524
	nop			;7525
	nop			;7526
	nop			;7527
	nop			;7528
	nop			;7529
	nop			;752a
	nop			;752b
	nop			;752c
	nop			;752d
	nop			;752e
	nop			;752f
	nop			;7530
	nop			;7531
	nop			;7532
	nop			;7533
	nop			;7534
	nop			;7535
	nop			;7536
	nop			;7537
	nop			;7538
	nop			;7539
	nop			;753a
	nop			;753b
	nop			;753c
	nop			;753d
	nop			;753e
	nop			;753f
	nop			;7540
	nop			;7541
	nop			;7542
	nop			;7543
	nop			;7544
	nop			;7545
	nop			;7546
	nop			;7547
	nop			;7548
	nop			;7549
	nop			;754a
	nop			;754b
	nop			;754c
	nop			;754d
	nop			;754e
	nop			;754f
	nop			;7550
	nop			;7551
	nop			;7552
	nop			;7553
	nop			;7554
	nop			;7555
	nop			;7556
	nop			;7557
	nop			;7558
	nop			;7559
	nop			;755a
	nop			;755b
	nop			;755c
	nop			;755d
	nop			;755e
	nop			;755f
	nop			;7560
	nop			;7561
	nop			;7562
	nop			;7563
	nop			;7564
	nop			;7565
	nop			;7566
	nop			;7567
	nop			;7568
	nop			;7569
	nop			;756a
	nop			;756b
	nop			;756c
	nop			;756d
	nop			;756e
	nop			;756f
	nop			;7570
	nop			;7571
	nop			;7572
	nop			;7573
	nop			;7574
	nop			;7575
	nop			;7576
	nop			;7577
	nop			;7578
	nop			;7579
	nop			;757a
	nop			;757b
	nop			;757c
	nop			;757d
	nop			;757e
	nop			;757f
	nop			;7580
	nop			;7581
	nop			;7582
	nop			;7583
	nop			;7584
	nop			;7585
	nop			;7586
	nop			;7587
	nop			;7588
	nop			;7589
	nop			;758a
	nop			;758b
	nop			;758c
	nop			;758d
	nop			;758e
	nop			;758f
	nop			;7590
	nop			;7591
	nop			;7592
	nop			;7593
	nop			;7594
	nop			;7595
	nop			;7596
	nop			;7597
	nop			;7598
	nop			;7599
	nop			;759a
	nop			;759b
	nop			;759c
	nop			;759d
	nop			;759e
	nop			;759f
	nop			;75a0
	nop			;75a1
	nop			;75a2
	nop			;75a3
	nop			;75a4
	nop			;75a5
	nop			;75a6
	nop			;75a7
	nop			;75a8
	nop			;75a9
	nop			;75aa
	nop			;75ab
	nop			;75ac
	nop			;75ad
	nop			;75ae
	nop			;75af
	nop			;75b0
	nop			;75b1
	nop			;75b2
	nop			;75b3
	nop			;75b4
	nop			;75b5
	nop			;75b6
	nop			;75b7
	nop			;75b8
	nop			;75b9
	nop			;75ba
	nop			;75bb
	nop			;75bc
	nop			;75bd
	nop			;75be
	nop			;75bf
	nop			;75c0
	nop			;75c1
	nop			;75c2
	nop			;75c3
	nop			;75c4
	nop			;75c5
	nop			;75c6
	nop			;75c7
	nop			;75c8
	nop			;75c9
	nop			;75ca
	nop			;75cb
	nop			;75cc
	nop			;75cd
	nop			;75ce
	nop			;75cf
	nop			;75d0
	nop			;75d1
	nop			;75d2
	nop			;75d3
	nop			;75d4
	nop			;75d5
	nop			;75d6
	nop			;75d7
	nop			;75d8
	nop			;75d9
	nop			;75da
	nop			;75db
	nop			;75dc
	nop			;75dd
	nop			;75de
	nop			;75df
	nop			;75e0
	nop			;75e1
	nop			;75e2
	nop			;75e3
	nop			;75e4
	nop			;75e5
	nop			;75e6
	nop			;75e7
	nop			;75e8
	nop			;75e9
	nop			;75ea
	nop			;75eb
	nop			;75ec
	nop			;75ed
	nop			;75ee
	nop			;75ef
	nop			;75f0
	nop			;75f1
	nop			;75f2
	nop			;75f3
	nop			;75f4
	nop			;75f5
	nop			;75f6
	nop			;75f7
	nop			;75f8
	nop			;75f9
	nop			;75fa
	nop			;75fb
	nop			;75fc
	nop			;75fd
	nop			;75fe
	nop			;75ff
	nop			;7600
	nop			;7601
	nop			;7602
	nop			;7603
	nop			;7604
	nop			;7605
	nop			;7606
	nop			;7607
	nop			;7608
	nop			;7609
	nop			;760a
	nop			;760b
	nop			;760c
	nop			;760d
	nop			;760e
	nop			;760f
	nop			;7610
	nop			;7611
	nop			;7612
	nop			;7613
	nop			;7614
	nop			;7615
	nop			;7616
	nop			;7617
	nop			;7618
	nop			;7619
	nop			;761a
	nop			;761b
	nop			;761c
	nop			;761d
	nop			;761e
	nop			;761f
	nop			;7620
	nop			;7621
	nop			;7622
	nop			;7623
	nop			;7624
	nop			;7625
	nop			;7626
	nop			;7627
	nop			;7628
	nop			;7629
	nop			;762a
	nop			;762b
	nop			;762c
	nop			;762d
	nop			;762e
	nop			;762f
	nop			;7630
	nop			;7631
	nop			;7632
	nop			;7633
	nop			;7634
	nop			;7635
	nop			;7636
	nop			;7637
	nop			;7638
	nop			;7639
	nop			;763a
	nop			;763b
	nop			;763c
	nop			;763d
	nop			;763e
	nop			;763f
	nop			;7640
	nop			;7641
	nop			;7642
	nop			;7643
	nop			;7644
	nop			;7645
	nop			;7646
	nop			;7647
	nop			;7648
	nop			;7649
	nop			;764a
	nop			;764b
	nop			;764c
	nop			;764d
	nop			;764e
	nop			;764f
	nop			;7650
	nop			;7651
	nop			;7652
	nop			;7653
	nop			;7654
	nop			;7655
	nop			;7656
	nop			;7657
	nop			;7658
	nop			;7659
	nop			;765a
	nop			;765b
	nop			;765c
	nop			;765d
	nop			;765e
	nop			;765f
	nop			;7660
	nop			;7661
	nop			;7662
	nop			;7663
	nop			;7664
	nop			;7665
	nop			;7666
	nop			;7667
	nop			;7668
	nop			;7669
	nop			;766a
	nop			;766b
	nop			;766c
	nop			;766d
	nop			;766e
	nop			;766f
	nop			;7670
	nop			;7671
	nop			;7672
	nop			;7673
	nop			;7674
	nop			;7675
	nop			;7676
	nop			;7677
	nop			;7678
	nop			;7679
	nop			;767a
	nop			;767b
	nop			;767c
	nop			;767d
	nop			;767e
	nop			;767f
	nop			;7680
	nop			;7681
	nop			;7682
	nop			;7683
	nop			;7684
	nop			;7685
	nop			;7686
	nop			;7687
	nop			;7688
	nop			;7689
	nop			;768a
	nop			;768b
	nop			;768c
	nop			;768d
	nop			;768e
	nop			;768f
	nop			;7690
	nop			;7691
	nop			;7692
	nop			;7693
	nop			;7694
	nop			;7695
	nop			;7696
	nop			;7697
	nop			;7698
	nop			;7699
	nop			;769a
	nop			;769b
	nop			;769c
	nop			;769d
	nop			;769e
	nop			;769f
	nop			;76a0
	nop			;76a1
	nop			;76a2
	nop			;76a3
	nop			;76a4
	nop			;76a5
	nop			;76a6
	nop			;76a7
	nop			;76a8
	nop			;76a9
	nop			;76aa
	nop			;76ab
	nop			;76ac
	nop			;76ad
	nop			;76ae
	nop			;76af
	nop			;76b0
	nop			;76b1
	nop			;76b2
	nop			;76b3
	nop			;76b4
	nop			;76b5
	nop			;76b6
	nop			;76b7
	nop			;76b8
	nop			;76b9
	nop			;76ba
	nop			;76bb
	nop			;76bc
	nop			;76bd
	nop			;76be
	nop			;76bf
	nop			;76c0
	nop			;76c1
	nop			;76c2
	nop			;76c3
	nop			;76c4
	nop			;76c5
	nop			;76c6
	nop			;76c7
	nop			;76c8
	nop			;76c9
	nop			;76ca
	nop			;76cb
	nop			;76cc
	nop			;76cd
	nop			;76ce
	nop			;76cf
	nop			;76d0
	nop			;76d1
	nop			;76d2
	nop			;76d3
	nop			;76d4
	nop			;76d5
	nop			;76d6
	nop			;76d7
	nop			;76d8
	nop			;76d9
	nop			;76da
	nop			;76db
	nop			;76dc
	nop			;76dd
	nop			;76de
	nop			;76df
	nop			;76e0
	nop			;76e1
	nop			;76e2
	nop			;76e3
	nop			;76e4
	nop			;76e5
	nop			;76e6
	nop			;76e7
	nop			;76e8
	nop			;76e9
	nop			;76ea
	nop			;76eb
	nop			;76ec
	nop			;76ed
	nop			;76ee
	nop			;76ef
	nop			;76f0
	nop			;76f1
	nop			;76f2
	nop			;76f3
	nop			;76f4
	nop			;76f5
	nop			;76f6
	nop			;76f7
	nop			;76f8
	nop			;76f9
	nop			;76fa
	nop			;76fb
	nop			;76fc
	nop			;76fd
	nop			;76fe
	nop			;76ff
	nop			;7700
	nop			;7701
	nop			;7702
	nop			;7703
	nop			;7704
	nop			;7705
	nop			;7706
	nop			;7707
	nop			;7708
	nop			;7709
	nop			;770a
	nop			;770b
	nop			;770c
	nop			;770d
	nop			;770e
	nop			;770f
	nop			;7710
	nop			;7711
	nop			;7712
	nop			;7713
	nop			;7714
	nop			;7715
	nop			;7716
	nop			;7717
	nop			;7718
	nop			;7719
	nop			;771a
	nop			;771b
	nop			;771c
	nop			;771d
	nop			;771e
	nop			;771f
	nop			;7720
	nop			;7721
	nop			;7722
	nop			;7723
	nop			;7724
	nop			;7725
	nop			;7726
	nop			;7727
	nop			;7728
	nop			;7729
	nop			;772a
	nop			;772b
	nop			;772c
	nop			;772d
	nop			;772e
	nop			;772f
	nop			;7730
	nop			;7731
	nop			;7732
	nop			;7733
	nop			;7734
	nop			;7735
	nop			;7736
	nop			;7737
	nop			;7738
	nop			;7739
	nop			;773a
	nop			;773b
	nop			;773c
	nop			;773d
	nop			;773e
	nop			;773f
	nop			;7740
	nop			;7741
	nop			;7742
	nop			;7743
	nop			;7744
	nop			;7745
	nop			;7746
	nop			;7747
	nop			;7748
	nop			;7749
	nop			;774a
	nop			;774b
	nop			;774c
	nop			;774d
	nop			;774e
	nop			;774f
	nop			;7750
	nop			;7751
	nop			;7752
	nop			;7753
	nop			;7754
	nop			;7755
	nop			;7756
	nop			;7757
	nop			;7758
	nop			;7759
	nop			;775a
	nop			;775b
	nop			;775c
	nop			;775d
	nop			;775e
	nop			;775f
	nop			;7760
	nop			;7761
	nop			;7762
	nop			;7763
	nop			;7764
	nop			;7765
	nop			;7766
	nop			;7767
	nop			;7768
	nop			;7769
	nop			;776a
	nop			;776b
	nop			;776c
	nop			;776d
	nop			;776e
	nop			;776f
	nop			;7770
	nop			;7771
	nop			;7772
	nop			;7773
	nop			;7774
	nop			;7775
	nop			;7776
	nop			;7777
	nop			;7778
	nop			;7779
	nop			;777a
	nop			;777b
	nop			;777c
	nop			;777d
	nop			;777e
	nop			;777f
	nop			;7780
	nop			;7781
	nop			;7782
	nop			;7783
	nop			;7784
	nop			;7785
	nop			;7786
	nop			;7787
	nop			;7788
	nop			;7789
	nop			;778a
	nop			;778b
	nop			;778c
	nop			;778d
	nop			;778e
	nop			;778f
	nop			;7790
	nop			;7791
	nop			;7792
	nop			;7793
	nop			;7794
	nop			;7795
	nop			;7796
	nop			;7797
	nop			;7798
	nop			;7799
	nop			;779a
	nop			;779b
	nop			;779c
	nop			;779d
	nop			;779e
	nop			;779f
	nop			;77a0
	nop			;77a1
	nop			;77a2
	nop			;77a3
	nop			;77a4
	nop			;77a5
	nop			;77a6
	nop			;77a7
	nop			;77a8
	nop			;77a9
	nop			;77aa
	nop			;77ab
	nop			;77ac
	nop			;77ad
	nop			;77ae
	nop			;77af
	nop			;77b0
	nop			;77b1
	nop			;77b2
	nop			;77b3
	nop			;77b4
	nop			;77b5
	nop			;77b6
	nop			;77b7
	nop			;77b8
	nop			;77b9
	nop			;77ba
	nop			;77bb
	nop			;77bc
	nop			;77bd
	nop			;77be
	nop			;77bf
	nop			;77c0
	nop			;77c1
	nop			;77c2
	nop			;77c3
	nop			;77c4
	nop			;77c5
	nop			;77c6
	nop			;77c7
	nop			;77c8
	nop			;77c9
	nop			;77ca
	nop			;77cb
	nop			;77cc
	ret			;77cd
	nop			;77ce
	nop			;77cf
	nop			;77d0
	nop			;77d1
	nop			;77d2
	nop			;77d3
	nop			;77d4
	nop			;77d5
	nop			;77d6
	nop			;77d7
	nop			;77d8
	nop			;77d9
	nop			;77da
	nop			;77db
	nop			;77dc
	nop			;77dd
	nop			;77de
	nop			;77df
	nop			;77e0
	nop			;77e1
	nop			;77e2
	nop			;77e3
	nop			;77e4
	nop			;77e5
	nop			;77e6
	nop			;77e7
	nop			;77e8
	nop			;77e9
	nop			;77ea
	nop			;77eb
	nop			;77ec
	nop			;77ed
	nop			;77ee
	nop			;77ef
	nop			;77f0
	nop			;77f1
	nop			;77f2
	nop			;77f3
	nop			;77f4
	nop			;77f5
	nop			;77f6
	nop			;77f7
	nop			;77f8
	nop			;77f9
	nop			;77fa
	nop			;77fb
	nop			;77fc
	nop			;77fd
	nop			;77fe
	nop			;77ff
	nop			;7800
	nop			;7801
	nop			;7802
	nop			;7803
	nop			;7804
	nop			;7805
	nop			;7806
	nop			;7807
	nop			;7808
	nop			;7809
	nop			;780a
	nop			;780b
	nop			;780c
	nop			;780d
	nop			;780e
	nop			;780f
	nop			;7810
	nop			;7811
	nop			;7812
	nop			;7813
	nop			;7814
	nop			;7815
	nop			;7816
	nop			;7817
	nop			;7818
	nop			;7819
	nop			;781a
	nop			;781b
	nop			;781c
	nop			;781d
	nop			;781e
	nop			;781f
	nop			;7820
	nop			;7821
	nop			;7822
	nop			;7823
	nop			;7824
	nop			;7825
	nop			;7826
	nop			;7827
	nop			;7828
	nop			;7829
	nop			;782a
	nop			;782b
	nop			;782c
	nop			;782d
	nop			;782e
	nop			;782f
	nop			;7830
	nop			;7831
	nop			;7832
	nop			;7833
	nop			;7834
	nop			;7835
	nop			;7836
	nop			;7837
	nop			;7838
	nop			;7839
	nop			;783a
	nop			;783b
	nop			;783c
	nop			;783d
	nop			;783e
	nop			;783f
	nop			;7840
	nop			;7841
	nop			;7842
	nop			;7843
	nop			;7844
	nop			;7845
	nop			;7846
	nop			;7847
	nop			;7848
	nop			;7849
	nop			;784a
	nop			;784b
	nop			;784c
	nop			;784d
	nop			;784e
	nop			;784f
	nop			;7850
	nop			;7851
	nop			;7852
	nop			;7853
	nop			;7854
	nop			;7855
	nop			;7856
	nop			;7857
	nop			;7858
	nop			;7859
	nop			;785a
	nop			;785b
	nop			;785c
	nop			;785d
	nop			;785e
	nop			;785f
	nop			;7860
	nop			;7861
	nop			;7862
	nop			;7863
	nop			;7864
	nop			;7865
	nop			;7866
	nop			;7867
	nop			;7868
	nop			;7869
	nop			;786a
	nop			;786b
	nop			;786c
	nop			;786d
	nop			;786e
	nop			;786f
	nop			;7870
	nop			;7871
	nop			;7872
	nop			;7873
	nop			;7874
	nop			;7875
	nop			;7876
	nop			;7877
	nop			;7878
	nop			;7879
	nop			;787a
	nop			;787b
	nop			;787c
	nop			;787d
	nop			;787e
	nop			;787f
	nop			;7880
	nop			;7881
	nop			;7882
	nop			;7883
	nop			;7884
	nop			;7885
	nop			;7886
	nop			;7887
	nop			;7888
	nop			;7889
	nop			;788a
	nop			;788b
	nop			;788c
	nop			;788d
	nop			;788e
	nop			;788f
	nop			;7890
	nop			;7891
	nop			;7892
	nop			;7893
	nop			;7894
	nop			;7895
	nop			;7896
	nop			;7897
	nop			;7898
	nop			;7899
	nop			;789a
	nop			;789b
	nop			;789c
	nop			;789d
	nop			;789e
	nop			;789f
	nop			;78a0
	nop			;78a1
	nop			;78a2
	nop			;78a3
	nop			;78a4
	nop			;78a5
	nop			;78a6
	nop			;78a7
	nop			;78a8
	nop			;78a9
	nop			;78aa
	nop			;78ab
	nop			;78ac
	nop			;78ad
	nop			;78ae
	nop			;78af
	nop			;78b0
	nop			;78b1
	nop			;78b2
	nop			;78b3
	nop			;78b4
	nop			;78b5
	nop			;78b6
	nop			;78b7
	nop			;78b8
	nop			;78b9
	nop			;78ba
	nop			;78bb
	nop			;78bc
	nop			;78bd
	nop			;78be
	nop			;78bf
	nop			;78c0
	nop			;78c1
	nop			;78c2
	nop			;78c3
	nop			;78c4
	nop			;78c5
	nop			;78c6
	nop			;78c7
	nop			;78c8
	nop			;78c9
	nop			;78ca
	nop			;78cb
	nop			;78cc
	nop			;78cd
	nop			;78ce
	nop			;78cf
	nop			;78d0
	nop			;78d1
	nop			;78d2
	nop			;78d3
	nop			;78d4
	nop			;78d5
	nop			;78d6
	nop			;78d7
	nop			;78d8
	nop			;78d9
	nop			;78da
	nop			;78db
	nop			;78dc
	nop			;78dd
	nop			;78de
	nop			;78df
	nop			;78e0
	nop			;78e1
	nop			;78e2
	nop			;78e3
	nop			;78e4
	nop			;78e5
	nop			;78e6
	nop			;78e7
	nop			;78e8
	nop			;78e9
	nop			;78ea
	nop			;78eb
	nop			;78ec
	nop			;78ed
	nop			;78ee
	nop			;78ef
	nop			;78f0
	nop			;78f1
	nop			;78f2
	nop			;78f3
	nop			;78f4
	nop			;78f5
	nop			;78f6
	nop			;78f7
	nop			;78f8
	nop			;78f9
	nop			;78fa
	nop			;78fb
	nop			;78fc
	nop			;78fd
	nop			;78fe
	nop			;78ff
	nop			;7900
	nop			;7901
	nop			;7902
	nop			;7903
	nop			;7904
	nop			;7905
	nop			;7906
	nop			;7907
	nop			;7908
	nop			;7909
	nop			;790a
	nop			;790b
	nop			;790c
	nop			;790d
	nop			;790e
	nop			;790f
	nop			;7910
	nop			;7911
	nop			;7912
	nop			;7913
	nop			;7914
	nop			;7915
	nop			;7916
	nop			;7917
	nop			;7918
	nop			;7919
	nop			;791a
	nop			;791b
	nop			;791c
	nop			;791d
	nop			;791e
	nop			;791f
	nop			;7920
	nop			;7921
	nop			;7922
	nop			;7923
	nop			;7924
	nop			;7925
	nop			;7926
	nop			;7927
	nop			;7928
	nop			;7929
	nop			;792a
	nop			;792b
	nop			;792c
	nop			;792d
	nop			;792e
	nop			;792f
	nop			;7930
	nop			;7931
	nop			;7932
	nop			;7933
	nop			;7934
	nop			;7935
	nop			;7936
	nop			;7937
	nop			;7938
	nop			;7939
	nop			;793a
	nop			;793b
	nop			;793c
	nop			;793d
	nop			;793e
	nop			;793f
	nop			;7940
	nop			;7941
	nop			;7942
	nop			;7943
	nop			;7944
	nop			;7945
	nop			;7946
	nop			;7947
	nop			;7948
	nop			;7949
	nop			;794a
	nop			;794b
	nop			;794c
	nop			;794d
	nop			;794e
	nop			;794f
	nop			;7950
	nop			;7951
	nop			;7952
	nop			;7953
	nop			;7954
	nop			;7955
	nop			;7956
	nop			;7957
	nop			;7958
	nop			;7959
	nop			;795a
	nop			;795b
	nop			;795c
	nop			;795d
	nop			;795e
	nop			;795f
	nop			;7960
	nop			;7961
	nop			;7962
	nop			;7963
	nop			;7964
	nop			;7965
	nop			;7966
	nop			;7967
	nop			;7968
	nop			;7969
	nop			;796a
	nop			;796b
	nop			;796c
	nop			;796d
	nop			;796e
	nop			;796f
	nop			;7970
	nop			;7971
	nop			;7972
	nop			;7973
	nop			;7974
	nop			;7975
	nop			;7976
	nop			;7977
	nop			;7978
	nop			;7979
	nop			;797a
	nop			;797b
	nop			;797c
	nop			;797d
	nop			;797e
	nop			;797f
	nop			;7980
	nop			;7981
	nop			;7982
	nop			;7983
	nop			;7984
	nop			;7985
	nop			;7986
	nop			;7987
	nop			;7988
	nop			;7989
	nop			;798a
	nop			;798b
	nop			;798c
	nop			;798d
	nop			;798e
	nop			;798f
	nop			;7990
	nop			;7991
	nop			;7992
	nop			;7993
	nop			;7994
	nop			;7995
	nop			;7996
	nop			;7997
	nop			;7998
	nop			;7999
	nop			;799a
	nop			;799b
	nop			;799c
	nop			;799d
	nop			;799e
	nop			;799f
	nop			;79a0
	nop			;79a1
	nop			;79a2
	nop			;79a3
	nop			;79a4
	nop			;79a5
	nop			;79a6
	nop			;79a7
	nop			;79a8
	nop			;79a9
	nop			;79aa
	nop			;79ab
	nop			;79ac
	nop			;79ad
	nop			;79ae
	nop			;79af
	nop			;79b0
	nop			;79b1
	nop			;79b2
	nop			;79b3
	nop			;79b4
	nop			;79b5
	nop			;79b6
	nop			;79b7
	nop			;79b8
	nop			;79b9
	nop			;79ba
	nop			;79bb
	nop			;79bc
	nop			;79bd
	nop			;79be
	nop			;79bf
	nop			;79c0
	nop			;79c1
	nop			;79c2
	nop			;79c3
	nop			;79c4
	nop			;79c5
	nop			;79c6
	nop			;79c7
	nop			;79c8
	nop			;79c9
	nop			;79ca
	nop			;79cb
	nop			;79cc
	nop			;79cd
	nop			;79ce
	nop			;79cf
	nop			;79d0
	nop			;79d1
	nop			;79d2
	nop			;79d3
	nop			;79d4
	nop			;79d5
	nop			;79d6
	nop			;79d7
	nop			;79d8
	nop			;79d9
	nop			;79da
	nop			;79db
	nop			;79dc
	nop			;79dd
	nop			;79de
	nop			;79df
	nop			;79e0
	nop			;79e1
	nop			;79e2
	nop			;79e3
	nop			;79e4
	nop			;79e5
	nop			;79e6
	nop			;79e7
	nop			;79e8
	nop			;79e9
	nop			;79ea
	nop			;79eb
	nop			;79ec
	nop			;79ed
	nop			;79ee
	nop			;79ef
	nop			;79f0
	nop			;79f1
	nop			;79f2
	nop			;79f3
	nop			;79f4
	nop			;79f5
	nop			;79f6
	nop			;79f7
	nop			;79f8
	nop			;79f9
	nop			;79fa
	nop			;79fb
	nop			;79fc
	nop			;79fd
	nop			;79fe
	nop			;79ff
	nop			;7a00
	nop			;7a01
	nop			;7a02
	nop			;7a03
	nop			;7a04
	nop			;7a05
	nop			;7a06
	nop			;7a07
	nop			;7a08
	nop			;7a09
	nop			;7a0a
	nop			;7a0b
	nop			;7a0c
	nop			;7a0d
	nop			;7a0e
	nop			;7a0f
	nop			;7a10
	nop			;7a11
	nop			;7a12
	nop			;7a13
	nop			;7a14
	nop			;7a15
	nop			;7a16
	nop			;7a17
	nop			;7a18
	nop			;7a19
	nop			;7a1a
	nop			;7a1b
	nop			;7a1c
	nop			;7a1d
	nop			;7a1e
	nop			;7a1f
	nop			;7a20
	nop			;7a21
	nop			;7a22
	nop			;7a23
	nop			;7a24
	nop			;7a25
	nop			;7a26
	nop			;7a27
	nop			;7a28
	nop			;7a29
	nop			;7a2a
	nop			;7a2b
	nop			;7a2c
	nop			;7a2d
	nop			;7a2e
	nop			;7a2f
	nop			;7a30
	nop			;7a31
	nop			;7a32
	nop			;7a33
	nop			;7a34
	nop			;7a35
	nop			;7a36
	nop			;7a37
	nop			;7a38
	nop			;7a39
	nop			;7a3a
	nop			;7a3b
	nop			;7a3c
	nop			;7a3d
	nop			;7a3e
	nop			;7a3f
	nop			;7a40
	nop			;7a41
	nop			;7a42
	nop			;7a43
	nop			;7a44
	nop			;7a45
	nop			;7a46
	nop			;7a47
	nop			;7a48
	nop			;7a49
	nop			;7a4a
	nop			;7a4b
	nop			;7a4c
	nop			;7a4d
	nop			;7a4e
	nop			;7a4f
	nop			;7a50
	nop			;7a51
	nop			;7a52
	nop			;7a53
	nop			;7a54
	nop			;7a55
	nop			;7a56
	nop			;7a57
	nop			;7a58
	nop			;7a59
	nop			;7a5a
	nop			;7a5b
	nop			;7a5c
	nop			;7a5d
	nop			;7a5e
	nop			;7a5f
	nop			;7a60
	nop			;7a61
	nop			;7a62
	nop			;7a63
	nop			;7a64
	nop			;7a65
	nop			;7a66
	nop			;7a67
	nop			;7a68
	nop			;7a69
	nop			;7a6a
	nop			;7a6b
	nop			;7a6c
	nop			;7a6d
	nop			;7a6e
	nop			;7a6f
	nop			;7a70
	nop			;7a71
	nop			;7a72
	nop			;7a73
	nop			;7a74
	nop			;7a75
	nop			;7a76
	nop			;7a77
	nop			;7a78
	nop			;7a79
	nop			;7a7a
	nop			;7a7b
	nop			;7a7c
	nop			;7a7d
	nop			;7a7e
	nop			;7a7f
	nop			;7a80
	nop			;7a81
	nop			;7a82
	nop			;7a83
	nop			;7a84
	nop			;7a85
	nop			;7a86
	nop			;7a87
	nop			;7a88
	nop			;7a89
	nop			;7a8a
	nop			;7a8b
	nop			;7a8c
	nop			;7a8d
	nop			;7a8e
	nop			;7a8f
	nop			;7a90
	nop			;7a91
	nop			;7a92
	nop			;7a93
	nop			;7a94
	nop			;7a95
	nop			;7a96
	nop			;7a97
	nop			;7a98
	nop			;7a99
	nop			;7a9a
	nop			;7a9b
	nop			;7a9c
	nop			;7a9d
	nop			;7a9e
	nop			;7a9f
	nop			;7aa0
	nop			;7aa1
	nop			;7aa2
	nop			;7aa3
	nop			;7aa4
	nop			;7aa5
	nop			;7aa6
	nop			;7aa7
	nop			;7aa8
	nop			;7aa9
	nop			;7aaa
	nop			;7aab
	nop			;7aac
	nop			;7aad
	nop			;7aae
	nop			;7aaf
	nop			;7ab0
	nop			;7ab1
	nop			;7ab2
	nop			;7ab3
	nop			;7ab4
	nop			;7ab5
	nop			;7ab6
	nop			;7ab7
	nop			;7ab8
	nop			;7ab9
	nop			;7aba
	nop			;7abb
	nop			;7abc
	nop			;7abd
	nop			;7abe
	nop			;7abf
	nop			;7ac0
	nop			;7ac1
	nop			;7ac2
	nop			;7ac3
	nop			;7ac4
	nop			;7ac5
	nop			;7ac6
	nop			;7ac7
	nop			;7ac8
	nop			;7ac9
	nop			;7aca
	nop			;7acb
	nop			;7acc
	nop			;7acd
	nop			;7ace
	nop			;7acf
	nop			;7ad0
	nop			;7ad1
	nop			;7ad2
	nop			;7ad3
	nop			;7ad4
	nop			;7ad5
	nop			;7ad6
	nop			;7ad7
	nop			;7ad8
	nop			;7ad9
	nop			;7ada
	nop			;7adb
	nop			;7adc
	nop			;7add
	nop			;7ade
	nop			;7adf
	nop			;7ae0
	nop			;7ae1
	nop			;7ae2
	nop			;7ae3
	nop			;7ae4
	nop			;7ae5
	nop			;7ae6
	nop			;7ae7
	nop			;7ae8
	nop			;7ae9
	nop			;7aea
	nop			;7aeb
	nop			;7aec
	nop			;7aed
	nop			;7aee
	nop			;7aef
	nop			;7af0
	nop			;7af1
	nop			;7af2
	nop			;7af3
	nop			;7af4
	nop			;7af5
	nop			;7af6
	nop			;7af7
	nop			;7af8
	nop			;7af9
	nop			;7afa
	nop			;7afb
	nop			;7afc
	nop			;7afd
	nop			;7afe
	nop			;7aff
	nop			;7b00
	nop			;7b01
	nop			;7b02
	nop			;7b03
	nop			;7b04
	nop			;7b05
	nop			;7b06
	nop			;7b07
	nop			;7b08
	nop			;7b09
	nop			;7b0a
	nop			;7b0b
	nop			;7b0c
	nop			;7b0d
	nop			;7b0e
	nop			;7b0f
	nop			;7b10
	nop			;7b11
	nop			;7b12
	nop			;7b13
	nop			;7b14
	nop			;7b15
	nop			;7b16
	nop			;7b17
	nop			;7b18
	nop			;7b19
	nop			;7b1a
	nop			;7b1b
	nop			;7b1c
	nop			;7b1d
	nop			;7b1e
	nop			;7b1f
	nop			;7b20
	nop			;7b21
	nop			;7b22
	nop			;7b23
	nop			;7b24
	nop			;7b25
	nop			;7b26
	nop			;7b27
	nop			;7b28
	nop			;7b29
	nop			;7b2a
	nop			;7b2b
	nop			;7b2c
	nop			;7b2d
	nop			;7b2e
	nop			;7b2f
	nop			;7b30
	nop			;7b31
	nop			;7b32
	nop			;7b33
	nop			;7b34
	nop			;7b35
	nop			;7b36
	nop			;7b37
	nop			;7b38
	nop			;7b39
	nop			;7b3a
	nop			;7b3b
	nop			;7b3c
	nop			;7b3d
	nop			;7b3e
	nop			;7b3f
	nop			;7b40
	nop			;7b41
	nop			;7b42
	nop			;7b43
	nop			;7b44
	nop			;7b45
	nop			;7b46
	nop			;7b47
	nop			;7b48
	nop			;7b49
	nop			;7b4a
	nop			;7b4b
	nop			;7b4c
	nop			;7b4d
	nop			;7b4e
	nop			;7b4f
	nop			;7b50
	nop			;7b51
	nop			;7b52
	nop			;7b53
	nop			;7b54
	nop			;7b55
	nop			;7b56
	nop			;7b57
	nop			;7b58
	nop			;7b59
	nop			;7b5a
	nop			;7b5b
	nop			;7b5c
	nop			;7b5d
	nop			;7b5e
	nop			;7b5f
	nop			;7b60
	nop			;7b61
	nop			;7b62
	nop			;7b63
	nop			;7b64
	nop			;7b65
	nop			;7b66
	nop			;7b67
	nop			;7b68
	nop			;7b69
	nop			;7b6a
	nop			;7b6b
	nop			;7b6c
	nop			;7b6d
	nop			;7b6e
	nop			;7b6f
	nop			;7b70
	nop			;7b71
	nop			;7b72
	nop			;7b73
	nop			;7b74
	nop			;7b75
	nop			;7b76
	nop			;7b77
	nop			;7b78
	nop			;7b79
	nop			;7b7a
	nop			;7b7b
	nop			;7b7c
	nop			;7b7d
	nop			;7b7e
	nop			;7b7f
	nop			;7b80
	nop			;7b81
	nop			;7b82
	nop			;7b83
	nop			;7b84
	nop			;7b85
	nop			;7b86
	nop			;7b87
	nop			;7b88
	nop			;7b89
	nop			;7b8a
	nop			;7b8b
	nop			;7b8c
	nop			;7b8d
	nop			;7b8e
	nop			;7b8f
	nop			;7b90
	nop			;7b91
	nop			;7b92
	nop			;7b93
	nop			;7b94
	nop			;7b95
	nop			;7b96
	nop			;7b97
	nop			;7b98
	nop			;7b99
	nop			;7b9a
	nop			;7b9b
	nop			;7b9c
	nop			;7b9d
	nop			;7b9e
	nop			;7b9f
	nop			;7ba0
	nop			;7ba1
	nop			;7ba2
	nop			;7ba3
	nop			;7ba4
	nop			;7ba5
	nop			;7ba6
	nop			;7ba7
	nop			;7ba8
	nop			;7ba9
	nop			;7baa
	nop			;7bab
	nop			;7bac
	nop			;7bad
	nop			;7bae
	nop			;7baf
	nop			;7bb0
	nop			;7bb1
	nop			;7bb2
	nop			;7bb3
	nop			;7bb4
	nop			;7bb5
	nop			;7bb6
	nop			;7bb7
	nop			;7bb8
	nop			;7bb9
	nop			;7bba
	nop			;7bbb
	nop			;7bbc
	nop			;7bbd
	nop			;7bbe
	nop			;7bbf
	nop			;7bc0
	nop			;7bc1
	nop			;7bc2
	nop			;7bc3
	nop			;7bc4
	nop			;7bc5
	nop			;7bc6
	nop			;7bc7
	nop			;7bc8
	nop			;7bc9
	nop			;7bca
	nop			;7bcb
	nop			;7bcc
	nop			;7bcd
	nop			;7bce
	nop			;7bcf
	nop			;7bd0
	nop			;7bd1
	nop			;7bd2
	nop			;7bd3
	nop			;7bd4
	nop			;7bd5
	nop			;7bd6
	nop			;7bd7
	nop			;7bd8
	nop			;7bd9
	nop			;7bda
	nop			;7bdb
	nop			;7bdc
	nop			;7bdd
	nop			;7bde
	nop			;7bdf
	nop			;7be0
	nop			;7be1
	nop			;7be2
	nop			;7be3
	nop			;7be4
	nop			;7be5
	nop			;7be6
	nop			;7be7
	nop			;7be8
	nop			;7be9
	nop			;7bea
	nop			;7beb
	nop			;7bec
	nop			;7bed
	nop			;7bee
	nop			;7bef
	nop			;7bf0
	nop			;7bf1
	nop			;7bf2
	nop			;7bf3
	nop			;7bf4
	nop			;7bf5
	nop			;7bf6
	nop			;7bf7
	nop			;7bf8
	nop			;7bf9
	nop			;7bfa
	nop			;7bfb
	nop			;7bfc
	nop			;7bfd
	nop			;7bfe
	nop			;7bff
	nop			;7c00
	nop			;7c01
	nop			;7c02
	nop			;7c03
	nop			;7c04
	nop			;7c05
	nop			;7c06
	nop			;7c07
	nop			;7c08
	nop			;7c09
	nop			;7c0a
	nop			;7c0b
	nop			;7c0c
	nop			;7c0d
	nop			;7c0e
	nop			;7c0f
	nop			;7c10
	nop			;7c11
	nop			;7c12
	nop			;7c13
	nop			;7c14
	nop			;7c15
	nop			;7c16
	nop			;7c17
	nop			;7c18
	nop			;7c19
	nop			;7c1a
	nop			;7c1b
	nop			;7c1c
	nop			;7c1d
	nop			;7c1e
	nop			;7c1f
	nop			;7c20
	nop			;7c21
	nop			;7c22
	nop			;7c23
	nop			;7c24
	nop			;7c25
	nop			;7c26
	nop			;7c27
	nop			;7c28
	nop			;7c29
	nop			;7c2a
	nop			;7c2b
	nop			;7c2c
	nop			;7c2d
	nop			;7c2e
	nop			;7c2f
	nop			;7c30
	nop			;7c31
	nop			;7c32
	nop			;7c33
	nop			;7c34
	nop			;7c35
	nop			;7c36
	nop			;7c37
	nop			;7c38
	nop			;7c39
	nop			;7c3a
	nop			;7c3b
	nop			;7c3c
	nop			;7c3d
	nop			;7c3e
	nop			;7c3f
	nop			;7c40
	nop			;7c41
	nop			;7c42
	nop			;7c43
	nop			;7c44
	nop			;7c45
	nop			;7c46
	nop			;7c47
	nop			;7c48
	nop			;7c49
	nop			;7c4a
	nop			;7c4b
	nop			;7c4c
	nop			;7c4d
	nop			;7c4e
	nop			;7c4f
	nop			;7c50
	nop			;7c51
	nop			;7c52
	nop			;7c53
	nop			;7c54
	nop			;7c55
	nop			;7c56
	nop			;7c57
	nop			;7c58
	nop			;7c59
	nop			;7c5a
	nop			;7c5b
	nop			;7c5c
	nop			;7c5d
	nop			;7c5e
	nop			;7c5f
	nop			;7c60
	nop			;7c61
	nop			;7c62
	nop			;7c63
	nop			;7c64
	nop			;7c65
	nop			;7c66
	nop			;7c67
	nop			;7c68
	nop			;7c69
	nop			;7c6a
	nop			;7c6b
	nop			;7c6c
	nop			;7c6d
	nop			;7c6e
	nop			;7c6f
	nop			;7c70
	nop			;7c71
	nop			;7c72
	nop			;7c73
	nop			;7c74
	nop			;7c75
	nop			;7c76
	nop			;7c77
	nop			;7c78
	nop			;7c79
	nop			;7c7a
	nop			;7c7b
	nop			;7c7c
	nop			;7c7d
	nop			;7c7e
	nop			;7c7f
	nop			;7c80
	nop			;7c81
	nop			;7c82
	nop			;7c83
	nop			;7c84
	nop			;7c85
	nop			;7c86
	nop			;7c87
	nop			;7c88
	nop			;7c89
	nop			;7c8a
	nop			;7c8b
	nop			;7c8c
	nop			;7c8d
	nop			;7c8e
	nop			;7c8f
	nop			;7c90
	nop			;7c91
	nop			;7c92
	nop			;7c93
	nop			;7c94
	nop			;7c95
	nop			;7c96
	nop			;7c97
	nop			;7c98
	nop			;7c99
	nop			;7c9a
	nop			;7c9b
	nop			;7c9c
	nop			;7c9d
	nop			;7c9e
	nop			;7c9f
	nop			;7ca0
	nop			;7ca1
	nop			;7ca2
	nop			;7ca3
	nop			;7ca4
	nop			;7ca5
	nop			;7ca6
	nop			;7ca7
	nop			;7ca8
	nop			;7ca9
	nop			;7caa
	nop			;7cab
	nop			;7cac
	nop			;7cad
	nop			;7cae
	nop			;7caf
	nop			;7cb0
	nop			;7cb1
	nop			;7cb2
	nop			;7cb3
	nop			;7cb4
	nop			;7cb5
	nop			;7cb6
	nop			;7cb7
	nop			;7cb8
	nop			;7cb9
	nop			;7cba
	nop			;7cbb
	nop			;7cbc
	nop			;7cbd
	nop			;7cbe
	nop			;7cbf
	nop			;7cc0
	nop			;7cc1
	nop			;7cc2
	nop			;7cc3
	nop			;7cc4
	nop			;7cc5
	nop			;7cc6
	nop			;7cc7
	nop			;7cc8
	nop			;7cc9
	nop			;7cca
	nop			;7ccb
	nop			;7ccc
	nop			;7ccd
	nop			;7cce
	nop			;7ccf
	nop			;7cd0
	nop			;7cd1
	nop			;7cd2
	nop			;7cd3
	nop			;7cd4
	nop			;7cd5
	nop			;7cd6
	nop			;7cd7
	nop			;7cd8
	nop			;7cd9
	nop			;7cda
	nop			;7cdb
	nop			;7cdc
	nop			;7cdd
	nop			;7cde
	nop			;7cdf
	nop			;7ce0
	nop			;7ce1
	nop			;7ce2
	nop			;7ce3
	nop			;7ce4
	nop			;7ce5
	nop			;7ce6
	nop			;7ce7
	nop			;7ce8
	nop			;7ce9
	nop			;7cea
	nop			;7ceb
	nop			;7cec
	nop			;7ced
	nop			;7cee
	nop			;7cef
	nop			;7cf0
	nop			;7cf1
	nop			;7cf2
	nop			;7cf3
	nop			;7cf4
	nop			;7cf5
	nop			;7cf6
	nop			;7cf7
	nop			;7cf8
	nop			;7cf9
	nop			;7cfa
	nop			;7cfb
	nop			;7cfc
	nop			;7cfd
	nop			;7cfe
	nop			;7cff
	nop			;7d00
	nop			;7d01
	nop			;7d02
	nop			;7d03
	nop			;7d04
	nop			;7d05
	nop			;7d06
	nop			;7d07
	nop			;7d08
	nop			;7d09
	nop			;7d0a
	nop			;7d0b
	nop			;7d0c
	nop			;7d0d
	nop			;7d0e
	nop			;7d0f
	nop			;7d10
	nop			;7d11
	nop			;7d12
	nop			;7d13
	nop			;7d14
	nop			;7d15
	nop			;7d16
	push hl			;7d17
	push af			;7d18
	ld hl,07d22h		;7d19
	call 0098bh		;7d1c
	pop af			;7d1f
	pop hl			;7d20
	ret			;7d21
	ld (hl),l		;7d22
	ld l,(hl)		;7d23
	ld l,e			;7d24
	ld l,(hl)		;7d25
	ld l,a			;7d26
	ld (hl),a		;7d27
	ld l,(hl)		;7d28
	ld b,b			;7d29
	scf			;7d2a
	ld b,h			;7d2b
	ld sp,00037h		;7d2c
	add hl,sp		;7d2f
	ld a,l			;7d30
	ld ix,00189h		;7d31
	call 01a66h		;7d35
	ret			;7d38
	ld ix,00185h		;7d39
	jp 01a66h		;7d3d
	nop			;7d40
	nop			;7d41
	nop			;7d42
	nop			;7d43
	nop			;7d44
	nop			;7d45
	nop			;7d46
	nop			;7d47
	nop			;7d48
	nop			;7d49
	nop			;7d4a
	nop			;7d4b
	nop			;7d4c
	nop			;7d4d
	nop			;7d4e
	nop			;7d4f
	nop			;7d50
	nop			;7d51
	nop			;7d52
	nop			;7d53
	nop			;7d54
	nop			;7d55
	nop			;7d56
	nop			;7d57
	nop			;7d58
	nop			;7d59
	nop			;7d5a
	nop			;7d5b
	nop			;7d5c
	nop			;7d5d
	nop			;7d5e
	nop			;7d5f
	nop			;7d60
	nop			;7d61
	nop			;7d62
	nop			;7d63
	nop			;7d64
	nop			;7d65
	nop			;7d66
	nop			;7d67
	nop			;7d68
	nop			;7d69
	nop			;7d6a
	nop			;7d6b
	nop			;7d6c
	nop			;7d6d
	nop			;7d6e
	nop			;7d6f
	nop			;7d70
	nop			;7d71
	nop			;7d72
	nop			;7d73
	nop			;7d74
	nop			;7d75
	nop			;7d76
	nop			;7d77
	nop			;7d78
	nop			;7d79
	nop			;7d7a
	nop			;7d7b
	nop			;7d7c
	nop			;7d7d
	nop			;7d7e
	nop			;7d7f
	nop			;7d80
	nop			;7d81
	nop			;7d82
	nop			;7d83
	nop			;7d84
	nop			;7d85
	nop			;7d86
	nop			;7d87
	nop			;7d88
	nop			;7d89
	nop			;7d8a
	nop			;7d8b
	nop			;7d8c
	nop			;7d8d
	nop			;7d8e
	nop			;7d8f
	nop			;7d90
	nop			;7d91
	nop			;7d92
	nop			;7d93
	nop			;7d94
	nop			;7d95
	nop			;7d96
	nop			;7d97
	nop			;7d98
	nop			;7d99
	nop			;7d9a
	nop			;7d9b
	nop			;7d9c
	nop			;7d9d
	nop			;7d9e
	nop			;7d9f
	nop			;7da0
	nop			;7da1
	nop			;7da2
	nop			;7da3
	nop			;7da4
	nop			;7da5
	nop			;7da6
	nop			;7da7
	nop			;7da8
	nop			;7da9
	nop			;7daa
	nop			;7dab
	nop			;7dac
	nop			;7dad
	nop			;7dae
	nop			;7daf
	nop			;7db0
	nop			;7db1
	nop			;7db2
	nop			;7db3
	nop			;7db4
	nop			;7db5
	nop			;7db6
	nop			;7db7
	nop			;7db8
	nop			;7db9
	nop			;7dba
	nop			;7dbb
	nop			;7dbc
	nop			;7dbd
	nop			;7dbe
	nop			;7dbf
	nop			;7dc0
	nop			;7dc1
	nop			;7dc2
	nop			;7dc3
	nop			;7dc4
	nop			;7dc5
	nop			;7dc6
	nop			;7dc7
	nop			;7dc8
	nop			;7dc9
	nop			;7dca
	nop			;7dcb
	nop			;7dcc
	nop			;7dcd
	nop			;7dce
	nop			;7dcf
	nop			;7dd0
	nop			;7dd1
	nop			;7dd2
	nop			;7dd3
	nop			;7dd4
	nop			;7dd5
	nop			;7dd6
	nop			;7dd7
	nop			;7dd8
	nop			;7dd9
	nop			;7dda
	nop			;7ddb
	nop			;7ddc
	nop			;7ddd
	nop			;7dde
	nop			;7ddf
	nop			;7de0
	nop			;7de1
	nop			;7de2
	nop			;7de3
	nop			;7de4
	nop			;7de5
	nop			;7de6
	nop			;7de7
	nop			;7de8
	nop			;7de9
	nop			;7dea
	nop			;7deb
	nop			;7dec
	nop			;7ded
	nop			;7dee
	nop			;7def
	nop			;7df0
	nop			;7df1
	nop			;7df2
	nop			;7df3
	nop			;7df4
	nop			;7df5
	nop			;7df6
	nop			;7df7
	nop			;7df8
	nop			;7df9
	nop			;7dfa
	nop			;7dfb
	nop			;7dfc
	nop			;7dfd
	nop			;7dfe
	nop			;7dff
	nop			;7e00
	nop			;7e01
	nop			;7e02
	nop			;7e03
	nop			;7e04
	nop			;7e05
	nop			;7e06
	nop			;7e07
	nop			;7e08
	nop			;7e09
	nop			;7e0a
	nop			;7e0b
	nop			;7e0c
	nop			;7e0d
	nop			;7e0e
	nop			;7e0f
	nop			;7e10
	nop			;7e11
	nop			;7e12
	nop			;7e13
	push hl			;7e14
	push af			;7e15
	ld hl,07e1fh		;7e16
	call 0098bh		;7e19
	pop af			;7e1c
	pop hl			;7e1d
	ret			;7e1e
	ld (hl),l		;7e1f
	ld l,(hl)		;7e20
	ld l,e			;7e21
	ld l,(hl)		;7e22
	ld l,a			;7e23
	ld (hl),a		;7e24
	ld l,(hl)		;7e25
	ld b,b			;7e26
	scf			;7e27
	ld b,l			;7e28
	ld sp,00034h		;7e29
	nop			;7e2c
	nop			;7e2d
	nop			;7e2e
	nop			;7e2f
	nop			;7e30
	nop			;7e31
	nop			;7e32
	nop			;7e33
	nop			;7e34
	nop			;7e35
	nop			;7e36
	nop			;7e37
	nop			;7e38
	nop			;7e39
	nop			;7e3a
	nop			;7e3b
	nop			;7e3c
	nop			;7e3d
	nop			;7e3e
	nop			;7e3f
	nop			;7e40
	nop			;7e41
	nop			;7e42
	nop			;7e43
	nop			;7e44
	nop			;7e45
	nop			;7e46
	nop			;7e47
	nop			;7e48
	nop			;7e49
	nop			;7e4a
	nop			;7e4b
	nop			;7e4c
	nop			;7e4d
	nop			;7e4e
	nop			;7e4f
	nop			;7e50
	nop			;7e51
	nop			;7e52
	nop			;7e53
	nop			;7e54
	nop			;7e55
	nop			;7e56
	nop			;7e57
	nop			;7e58
	nop			;7e59
	nop			;7e5a
	nop			;7e5b
	nop			;7e5c
	nop			;7e5d
	nop			;7e5e
	nop			;7e5f
	nop			;7e60
	nop			;7e61
	nop			;7e62
	nop			;7e63
	nop			;7e64
	nop			;7e65
	nop			;7e66
	nop			;7e67
	nop			;7e68
	nop			;7e69
	nop			;7e6a
	ret			;7e6b
	nop			;7e6c
	nop			;7e6d
	nop			;7e6e
	nop			;7e6f
	nop			;7e70
	nop			;7e71
	nop			;7e72
	nop			;7e73
	nop			;7e74
	nop			;7e75
	nop			;7e76
	nop			;7e77
	nop			;7e78
	nop			;7e79
	nop			;7e7a
	nop			;7e7b
	nop			;7e7c
	nop			;7e7d
	nop			;7e7e
	nop			;7e7f
	nop			;7e80
	nop			;7e81
	nop			;7e82
	nop			;7e83
	nop			;7e84
	nop			;7e85
	nop			;7e86
	nop			;7e87
	nop			;7e88
	nop			;7e89
	nop			;7e8a
	nop			;7e8b
	nop			;7e8c
	nop			;7e8d
	nop			;7e8e
	nop			;7e8f
	nop			;7e90
	nop			;7e91
	nop			;7e92
	nop			;7e93
	nop			;7e94
	nop			;7e95
	nop			;7e96
	nop			;7e97
	nop			;7e98
	nop			;7e99
	nop			;7e9a
	nop			;7e9b
	nop			;7e9c
	nop			;7e9d
	nop			;7e9e
	nop			;7e9f
	nop			;7ea0
	nop			;7ea1
	nop			;7ea2
	nop			;7ea3
	nop			;7ea4
	nop			;7ea5
	nop			;7ea6
	nop			;7ea7
	nop			;7ea8
	nop			;7ea9
	nop			;7eaa
	nop			;7eab
	nop			;7eac
	nop			;7ead
	nop			;7eae
	nop			;7eaf
	nop			;7eb0
	nop			;7eb1
	nop			;7eb2
	nop			;7eb3
	nop			;7eb4
	nop			;7eb5
	nop			;7eb6
	nop			;7eb7
	nop			;7eb8
	nop			;7eb9
	nop			;7eba
	nop			;7ebb
	nop			;7ebc
	nop			;7ebd
	nop			;7ebe
	nop			;7ebf
	nop			;7ec0
	nop			;7ec1
	nop			;7ec2
	nop			;7ec3
	nop			;7ec4
	nop			;7ec5
	nop			;7ec6
	nop			;7ec7
	nop			;7ec8
	nop			;7ec9
	nop			;7eca
	nop			;7ecb
	nop			;7ecc
	nop			;7ecd
	nop			;7ece
	nop			;7ecf
	nop			;7ed0
	nop			;7ed1
	nop			;7ed2
	nop			;7ed3
	nop			;7ed4
	nop			;7ed5
	nop			;7ed6
	nop			;7ed7
	nop			;7ed8
	nop			;7ed9
	nop			;7eda
	nop			;7edb
	nop			;7edc
	nop			;7edd
	nop			;7ede
	nop			;7edf
	nop			;7ee0
	nop			;7ee1
	nop			;7ee2
	nop			;7ee3
	nop			;7ee4
	nop			;7ee5
	nop			;7ee6
	nop			;7ee7
	nop			;7ee8
	nop			;7ee9
	nop			;7eea
	nop			;7eeb
	nop			;7eec
	nop			;7eed
	nop			;7eee
	nop			;7eef
	nop			;7ef0
	nop			;7ef1
	nop			;7ef2
	nop			;7ef3
	nop			;7ef4
	nop			;7ef5
	nop			;7ef6
	nop			;7ef7
	nop			;7ef8
	nop			;7ef9
	nop			;7efa
	nop			;7efb
	nop			;7efc
	nop			;7efd
	nop			;7efe
	nop			;7eff
	nop			;7f00
	nop			;7f01
	nop			;7f02
	nop			;7f03
	nop			;7f04
	nop			;7f05
	nop			;7f06
	nop			;7f07
	nop			;7f08
	nop			;7f09
	nop			;7f0a
	nop			;7f0b
	nop			;7f0c
	nop			;7f0d
	nop			;7f0e
	nop			;7f0f
	nop			;7f10
	nop			;7f11
	nop			;7f12
	nop			;7f13
	nop			;7f14
	nop			;7f15
	nop			;7f16
	nop			;7f17
	nop			;7f18
	nop			;7f19
	nop			;7f1a
	nop			;7f1b
	nop			;7f1c
	nop			;7f1d
	nop			;7f1e
	nop			;7f1f
	nop			;7f20
	nop			;7f21
	nop			;7f22
	nop			;7f23
	nop			;7f24
	nop			;7f25
	nop			;7f26
	nop			;7f27
	nop			;7f28
	nop			;7f29
	nop			;7f2a
	nop			;7f2b
	nop			;7f2c
	nop			;7f2d
	nop			;7f2e
	nop			;7f2f
	nop			;7f30
	nop			;7f31
	nop			;7f32
	nop			;7f33
	nop			;7f34
	nop			;7f35
	nop			;7f36
	nop			;7f37
	nop			;7f38
	nop			;7f39
	nop			;7f3a
	nop			;7f3b
	nop			;7f3c
	nop			;7f3d
	nop			;7f3e
	nop			;7f3f
	nop			;7f40
	nop			;7f41
	nop			;7f42
	nop			;7f43
	nop			;7f44
	nop			;7f45
	nop			;7f46
	nop			;7f47
	nop			;7f48
	nop			;7f49
	nop			;7f4a
	nop			;7f4b
	nop			;7f4c
	nop			;7f4d
	nop			;7f4e
	nop			;7f4f
	nop			;7f50
	nop			;7f51
	nop			;7f52
	nop			;7f53
	nop			;7f54
	nop			;7f55
	nop			;7f56
	nop			;7f57
	nop			;7f58
	nop			;7f59
	nop			;7f5a
	nop			;7f5b
	nop			;7f5c
	nop			;7f5d
	nop			;7f5e
	nop			;7f5f
	nop			;7f60
	nop			;7f61
	nop			;7f62
	nop			;7f63
	nop			;7f64
	nop			;7f65
	nop			;7f66
	nop			;7f67
	nop			;7f68
	nop			;7f69
	nop			;7f6a
	nop			;7f6b
	nop			;7f6c
	nop			;7f6d
	nop			;7f6e
	nop			;7f6f
	nop			;7f70
	nop			;7f71
	nop			;7f72
	nop			;7f73
	nop			;7f74
	nop			;7f75
	nop			;7f76
	nop			;7f77
	nop			;7f78
	nop			;7f79
	nop			;7f7a
	nop			;7f7b
	nop			;7f7c
	nop			;7f7d
	nop			;7f7e
	nop			;7f7f
	nop			;7f80
	nop			;7f81
	nop			;7f82
	nop			;7f83
	nop			;7f84
	nop			;7f85
	nop			;7f86
	nop			;7f87
	nop			;7f88
	nop			;7f89
	nop			;7f8a
	nop			;7f8b
	nop			;7f8c
	nop			;7f8d
	nop			;7f8e
	nop			;7f8f
	nop			;7f90
	nop			;7f91
	nop			;7f92
	nop			;7f93
	nop			;7f94
	nop			;7f95
	nop			;7f96
	nop			;7f97
	nop			;7f98
	nop			;7f99
	nop			;7f9a
	nop			;7f9b
	nop			;7f9c
	nop			;7f9d
	nop			;7f9e
	nop			;7f9f
	nop			;7fa0
	nop			;7fa1
	nop			;7fa2
	nop			;7fa3
	nop			;7fa4
	nop			;7fa5
	nop			;7fa6
	nop			;7fa7
	nop			;7fa8
	nop			;7fa9
	nop			;7faa
	nop			;7fab
	nop			;7fac
	nop			;7fad
	nop			;7fae
	nop			;7faf
	nop			;7fb0
	nop			;7fb1
	nop			;7fb2
	nop			;7fb3
	nop			;7fb4
	nop			;7fb5
	nop			;7fb6
	nop			;7fb7
	nop			;7fb8
	nop			;7fb9
	nop			;7fba
	nop			;7fbb
	nop			;7fbc
	nop			;7fbd
	nop			;7fbe
	nop			;7fbf
	nop			;7fc0
	nop			;7fc1
	nop			;7fc2
	nop			;7fc3
	nop			;7fc4
	nop			;7fc5
	nop			;7fc6
	nop			;7fc7
	nop			;7fc8
	nop			;7fc9
	nop			;7fca
	nop			;7fcb
	nop			;7fcc
	nop			;7fcd
	nop			;7fce
	nop			;7fcf
	nop			;7fd0
	nop			;7fd1
	nop			;7fd2
	nop			;7fd3
	nop			;7fd4
	nop			;7fd5
	nop			;7fd6
	nop			;7fd7
	nop			;7fd8
	nop			;7fd9
	nop			;7fda
	nop			;7fdb
	nop			;7fdc
	nop			;7fdd
	nop			;7fde
	nop			;7fdf
	nop			;7fe0
	nop			;7fe1
	nop			;7fe2
	nop			;7fe3
	nop			;7fe4
	nop			;7fe5
	nop			;7fe6
	nop			;7fe7
	nop			;7fe8
	nop			;7fe9
	nop			;7fea
	nop			;7feb
	nop			;7fec
	nop			;7fed
	nop			;7fee
	nop			;7fef
	nop			;7ff0
	nop			;7ff1
	nop			;7ff2
	nop			;7ff3
	nop			;7ff4
	nop			;7ff5
	nop			;7ff6
	nop			;7ff7
	nop			;7ff8
	nop			;7ff9
	nop			;7ffa
	nop			;7ffb
	nop			;7ffc
	nop			;7ffd
	nop			;7ffe
	nop			;7fff
