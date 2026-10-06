; z80dasm 1.2.0
; command line: z80dasm -a -g 0x4000 knightmare.bin

	org 04000h

	ld b,c			;4000
	ld b,d			;4001
	ld a,(hl)		;4002
	ld b,b			;4003
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
	ld b,e			;4010
	ld b,h			;4011
	rlca			;4012
	add hl,sp		;4013
	jr nz,$+2		;4014
	ret po			;4016
	inc b			;4017
	ld h,c			;4018
	ret po			;4019
	ex af,af'		;401a
	ld h,b			;401b
	ret po			;401c
	ld d,e			;401d
	ret po			;401e
	ld d,(hl)		;401f
	ret po			;4020
	ld (bc),a		;4021
	ret po			;4022
	ret z			;4023
	ld d,(hl)		;4024
	ld hl,0c9e1h		;4025
	ld (04112h),hl		;4028
	jp 046ddh		;402b
	call 0013eh		;402e
	di			;4031
	call 049c0h		;4032
	ld hl,0e005h		;4035
	bit 0,(hl)		;4038
	jr nz,$+14		;403a
	inc (hl)		;403c
	ei			;403d
	call 044d2h		;403e
	call 040d3h		;4041
	xor a			;4044
	ld (0e005h),a		;4045
	call 0013eh		;4048
	or a			;404b
	di			;404c
	call m,049c0h		;404d
	ei			;4050
	ret			;4051
	ld hl,00000h		;4052
	ld (0411eh),hl		;4055
	jp 00047h		;4058
	add a,l			;405b
	ld l,a			;405c
	ret nc			;405d
	inc h			;405e
	ret			;405f
	add a,e			;4060
	ld e,a			;4061
	ret nc			;4062
	inc d			;4063
	ret			;4064
	ld a,(ix+000h)		;4065
	dec a			;4068
	ret m			;4069
	jr $+3			;406a
	pop hl			;406c
	call 04079h		;406d
	jp (hl)			;4070
	add a,a			;4071
	call 0405bh		;4072
	ld e,(hl)		;4075
	inc hl			;4076
	ld d,(hl)		;4077
	ret			;4078
	call 04071h		;4079
	ex de,hl		;407c
	ret			;407d
	di			;407e
	im 1			;407f
	ld sp,0e800h		;4081
	call 00138h		;4084
	rrca			;4087
	rrca			;4088
	and 003h		;4089
	ld c,a			;408b
	ld b,000h		;408c
	ld hl,0fcc1h		;408e
	add hl,bc		;4091
	or (hl)			;4092
	ld c,a			;4093
	inc hl			;4094
	inc hl			;4095
	inc hl			;4096
	inc hl			;4097
	ld a,(hl)		;4098
	and 00ch		;4099
	or c			;409b
	ld h,080h		;409c
	call 00024h		;409e
	ld a,0c3h		;40a1
	ld (0fd9ah),a		;40a3
	ld hl,0402eh		;40a6
	ld (0fd9bh),hl		;40a9
	ld hl,0e000h		;40ac
	ld de,0e001h		;40af
	ld bc,007ffh		;40b2
	ld (hl),000h		;40b5
	ldir			;40b7
	ld a,001h		;40b9
	ld (0e005h),a		;40bb
	call 044a0h		;40be
	xor a			;40c1
	ld (0e005h),a		;40c2
	call 0013eh		;40c5
	ei			;40c8
	jr $+0			;40c9
	ld hl,044c6h		;40cb
	res 6,(hl)		;40ce
	jp 0490ch		;40d0
	ld hl,0e003h		;40d3
	inc (hl)		;40d6
	ld a,(0e000h)		;40d7
	cp 003h			;40da
	jr nc,$+6		;40dc
	ld hl,04262h		;40de
	push hl			;40e1
	ld bc,(0e000h)		;40e2
	ld a,c			;40e6
	call 0406ch		;40e7
	cp 040h			;40ea
	ld l,041h		;40ec
	dec (hl)		;40ee
	ld b,c			;40ef
	ld l,d			;40f0
	ld b,c			;40f1
	sbc a,h			;40f2
	ld b,c			;40f3
	pop hl			;40f4
	ld b,c			;40f5
	call p,00b41h		;40f6
	ld b,d			;40f9
	dec hl			;40fa
	ld b,d			;40fb
	ld e,a			;40fc
	ld b,d			;40fd
	djnz $+20		;40fe
	ld a,(0e003h)		;4100
	rra			;4103
	ret nc			;4104
	call 046f1h		;4105
	ret nz			;4108
	ld de,04518h		;4109
	call 0440ch		;410c
	xor a			;410f
	jr $+82			;4110
	djnz $+14		;4112
	ld hl,0e004h		;4114
	dec (hl)		;4117
	ret nz			;4118
	call 047bah		;4119
	xor a			;411c
	jp 04187h		;411d
	call 044b4h		;4120
	call 04386h		;4123
	call 04595h		;4126
	call 046cfh		;4129
	jr $+57			;412c
	ld hl,0e004h		;412e
	dec (hl)		;4131
	ret nz			;4132
	jr $+82			;4133
	djnz $+32		;4135
	call 05a73h		;4137
	call 056d2h		;413a
	ld a,(0e064h)		;413d
	or a			;4140
	ret nz			;4141
	ld hl,0e062h		;4142
	ld a,(hl)		;4145
	inc a			;4146
	and 007h		;4147
	ld (hl),a		;4149
	xor a			;414a
	ld (0e000h),a		;414b
	ld a,020h		;414e
	ld (0e004h),a		;4150
	jr $+59			;4153
	ld b,0e0h		;4155
	call 044cdh		;4157
	call 04386h		;415a
	call 05a46h		;415d
	ld a,020h		;4160
	ld (0e004h),a		;4162
	ld hl,0e001h		;4165
	inc (hl)		;4168
	ret			;4169
	djnz $+19		;416a
	ld hl,0e004h		;416c
	dec (hl)		;416f
	jr z,$-11		;4170
	bit 2,(hl)		;4172
	ld de,04556h		;4174
	jp z,043f1h		;4177
	jp 04408h		;417a
	djnz $+22		;417d
	call 04290h		;417f
	call 06f44h		;4182
	ld a,020h		;4185
	ld (0e004h),a		;4187
	ld hl,0e000h		;418a
	inc (hl)		;418d
	xor a			;418e
	ld (0e001h),a		;418f
	ret			;4192
	ld a,0b7h		;4193
	call 0490ch		;4195
	ld a,040h		;4198
	jr $-56			;419a
	djnz $+30		;419c
	ld a,(0e073h)		;419e
	or a			;41a1
	jr nz,$+9		;41a2
	ld a,(0e02eh)		;41a4
	or a			;41a7
	ret nz			;41a8
	jr $+7			;41a9
	ld hl,0e004h		;41ab
	dec (hl)		;41ae
	ret nz			;41af
	call 053d3h		;41b0
	ld a,001h		;41b3
	ld (0e064h),a		;41b5
	jr $-46			;41b8
	ld b,0e0h		;41ba
	call 044cdh		;41bc
	call 04386h		;41bf
	call 0565ch		;41c2
	ld hl,0e060h		;41c5
	ld a,(hl)		;41c8
	sub 001h		;41c9
	daa			;41cb
	ld (hl),a		;41cc
	call 0431fh		;41cd
	ld de,04582h		;41d0
	ld hl,0392ch		;41d3
	call 043f9h		;41d6
	inc l			;41d9
	call 04341h		;41da
	ld a,078h		;41dd
	jr $-69			;41df
	call 056d2h		;41e1
	ld a,(0e00dh)		;41e4
	and a			;41e7
	ld a,008h		;41e8
	jp nz,0414bh		;41ea
	ld a,(0e064h)		;41ed
	or a			;41f0
	ret nz			;41f1
	jr $-109		;41f2
	ld a,(0e060h)		;41f4
	or a			;41f7
	jr z,$+7		;41f8
	ld a,004h		;41fa
	jp 0414bh		;41fc
	ld a,0bah		;41ff
	call 0490ch		;4201
	ld b,0e0h		;4204
	call 044cdh		;4206
	jr $-23			;4209
	djnz $+17		;420b
	ld a,(0e012h)		;420d
	or a			;4210
	ret nz			;4211
	ld hl,0e002h		;4212
	ld a,(hl)		;4215
	and 0bfh		;4216
	ld (hl),a		;4218
	jp 0414ah		;4219
	call 04386h		;421c
	ld de,04588h		;421f
	call 043f1h		;4222
	call 0431fh		;4225
	jp 04165h		;4228
	xor a			;422b
	ld (0e00dh),a		;422c
	ld (0e073h),a		;422f
	ld hl,0e006h		;4232
	ld a,(hl)		;4235
	cp 004h			;4236
	jr nc,$+9		;4238
	ld a,(0e061h)		;423a
	cp (hl)			;423d
	jr c,$+3		;423e
	ld (hl),a		;4240
	ld hl,0e060h		;4241
	ld a,(hl)		;4244
	add a,001h		;4245
	daa			;4247
	ld (hl),a		;4248
	inc hl			;4249
	ld a,(hl)		;424a
	add a,001h		;424b
	daa			;424d
	ld (hl),a		;424e
	inc hl			;424f
	inc (hl)		;4250
	ld a,(hl)		;4251
	and 007h		;4252
	ld (hl),a		;4254
	jp nz,041fah		;4255
	ld a,001h		;4258
	ld (0e068h),a		;425a
	jr $-107		;425d
	jp 05b0bh		;425f
	call 044dfh		;4262
	ld hl,0e052h		;4265
	call 044d8h		;4268
	or a			;426b
	ret z			;426c
	ld hl,0e004h		;426d
	ld (hl),000h		;4270
	ld hl,0e000h		;4272
	ld b,(hl)		;4275
	djnz $+16		;4276
	and 030h		;4278
	ret z			;427a
	ld a,040h		;427b
	ld (0e002h),a		;427d
	ld (hl),003h		;4280
	inc hl			;4282
	ld (hl),000h		;4283
	ret			;4285
	ld (hl),001h		;4286
	ld a,03dh		;4288
	call 0490ch		;428a
	jp 047bah		;428d
	ld hl,0e056h		;4290
	ld bc,006fah		;4293
	ld d,h			;4296
	ld e,l			;4297
	inc e			;4298
	ld (hl),000h		;4299
	ldir			;429b
	ld hl,042a9h		;429d
	ld de,0e060h		;42a0
	ld bc,00004h		;42a3
	ldir			;42a6
	ret			;42a8
	inc bc			;42a9
	ld bc,01000h		;42aa
	ld c,000h		;42ad
	ld a,(0e002h)		;42af
	add a,a			;42b2
	ret p			;42b3
	ld hl,0e056h		;42b4
	ld a,(hl)		;42b7
	add a,e			;42b8
	daa			;42b9
	ld (hl),a		;42ba
	inc hl			;42bb
	ld a,(hl)		;42bc
	adc a,d			;42bd
	daa			;42be
	ld (hl),a		;42bf
	inc hl			;42c0
	ld a,(hl)		;42c1
	adc a,c			;42c2
	daa			;42c3
	ld (hl),a		;42c4
	jr nc,$+15		;42c5
	ld bc,09999h		;42c7
	ld (0e053h),bc		;42ca
	ld (0e054h),bc		;42ce
	jr $+89			;42d2
	ex de,hl		;42d4
	ld hl,0e063h		;42d5
	cp (hl)			;42d8
	jr c,$+17		;42d9
	ld a,(hl)		;42db
	ld b,010h		;42dc
	add a,b			;42de
	daa			;42df
	jr nc,$+4		;42e0
	ld a,0ffh		;42e2
	ld (hl),a		;42e4
	push de			;42e5
	call 04305h		;42e6
	pop de			;42e9
	ld b,003h		;42ea
	ld hl,0e055h		;42ec
	ex de,hl		;42ef
	ld a,(de)		;42f0
	sub (hl)		;42f1
	jr c,$+8		;42f2
	jr nz,$+55		;42f4
	dec l			;42f6
	dec e			;42f7
	djnz $-8		;42f8
	ld bc,00003h		;42fa
	ld e,055h		;42fd
	ld l,058h		;42ff
	lddr			;4301
	jr $+40			;4303
	ld hl,0e060h		;4305
	ld a,(hl)		;4308
	cp 099h			;4309
	ret z			;430b
	add a,001h		;430c
	daa			;430e
	ld (hl),a		;430f
	ld a,015h		;4310
	call 04901h		;4312
	ld hl,03af5h		;4315
	ld de,0e060h		;4318
	ld b,001h		;431b
	jr $+41			;431d
	ld de,04567h		;431f
	call 043f1h		;4322
	call 04315h		;4325
	call 0433eh		;4328
	ld hl,03aebh		;432b
	ld de,0e055h		;432e
	call 0433ah		;4331
	ld hl,03ae2h		;4334
	ld de,0e058h		;4337
	ld b,003h		;433a
	jr $+10			;433c
	ld hl,03afch		;433e
	ld de,0e061h		;4341
	ld b,001h		;4344
	ld c,000h		;4346
	ld a,(de)		;4348
	rra			;4349
	rra			;434a
	rra			;434b
	rra			;434c
	and 00fh		;434d
	jr z,$+4		;434f
	ld c,0ffh		;4351
	dec b			;4353
	jr nz,$+4		;4354
	ld c,0ffh		;4356
	inc b			;4358
	add a,010h		;4359
	and c			;435b
	call 0004dh		;435c
	inc hl			;435f
	ld a,(de)		;4360
	and 00fh		;4361
	jr z,$+4		;4363
	ld c,0ffh		;4365
	add a,010h		;4367
	and c			;4369
	call 0004dh		;436a
	dec de			;436d
	inc hl			;436e
	djnz $-39		;436f
	ret			;4371
	ld a,l			;4372
	rra			;4373
	rra			;4374
	rra			;4375
	rra			;4376
	rr h			;4377
	rra			;4379
	rr h			;437a
	rra			;437c
	rr h			;437d
	ld l,h			;437f
	and 003h		;4380
	add a,038h		;4382
	ld h,a			;4384
	ret			;4385
	ld hl,03b00h		;4386
	ld a,0d0h		;4389
	call 0004dh		;438b
	ld hl,03b01h		;438e
	ld bc,0007fh		;4391
	ld a,0c3h		;4394
	call 00056h		;4396
	ld hl,0e320h		;4399
	ld de,0e321h		;439c
	ld bc,0005fh		;439f
	ld (hl),0c3h		;43a2
	ldir			;43a4
	ld hl,03800h		;43a6
	ld bc,00300h		;43a9
	xor a			;43ac
	jp 00056h		;43ad
	ex af,af'		;43b0
	call 00053h		;43b1
	exx			;43b4
	ld a,(00007h)		;43b5
	ld c,a			;43b8
	exx			;43b9
	ex af,af'		;43ba
	ret			;43bb
	ex de,hl		;43bc
	jp 0005ch		;43bd
	ld d,003h		;43c0
	push bc			;43c2
	push de			;43c3
	call 00056h		;43c4
	ld de,00800h		;43c7
	add hl,de		;43ca
	pop de			;43cb
	pop bc			;43cc
	dec d			;43cd
	jr nz,$-12		;43ce
	ret			;43d0
	ld b,003h		;43d1
	push bc			;43d3
	push de			;43d4
	call 04412h		;43d5
	ld de,00800h		;43d8
	add hl,de		;43db
	pop de			;43dc
	pop bc			;43dd
	djnz $-11		;43de
	ret			;43e0
	ld b,003h		;43e1
	push bc			;43e3
	push de			;43e4
	call 04474h		;43e5
	ld de,00800h		;43e8
	add hl,de		;43eb
	pop de			;43ec
	pop bc			;43ed
	djnz $-11		;43ee
	ret			;43f0
	ld c,0ffh		;43f1
	ex de,hl		;43f3
	ld e,(hl)		;43f4
	inc hl			;43f5
	ld d,(hl)		;43f6
	ex de,hl		;43f7
	inc de			;43f8
	ld a,(de)		;43f9
	inc de			;43fa
	ld b,a			;43fb
	inc b			;43fc
	ret z			;43fd
	inc b			;43fe
	jr z,$-12		;43ff
	and c			;4401
	call 0004dh		;4402
	inc hl			;4405
	jr $-13			;4406
	ld c,000h		;4408
	jr $-23			;440a
	ex de,hl		;440c
	ld e,(hl)		;440d
	inc hl			;440e
	ld d,(hl)		;440f
	ex de,hl		;4410
	inc de			;4411
	ld c,000h		;4412
	call 043b0h		;4414
	ld a,(de)		;4417
	and a			;4418
	ret z			;4419
	inc de			;441a
	ld b,a			;441b
	and 07fh		;441c
	cp b			;441e
	jr z,$+17		;441f
	and a			;4421
	jr z,$-22		;4422
	ld b,a			;4424
	call 0443bh		;4425
	exx			;4428
	out (c),a		;4429
	exx			;442b
	djnz $-7		;442c
	jr $-23			;442e
	call 0443bh		;4430
	exx			;4433
	out (c),a		;4434
	exx			;4436
	djnz $-4		;4437
	jr $-34			;4439
	ld a,(0e661h)		;443b
	or a			;443e
	ld a,(de)		;443f
	inc de			;4440
	jr z,$+37		;4441
	cp 0e1h			;4443
	jr z,$+17		;4445
	cp 0ech			;4447
	jr z,$+13		;4449
	cp 0e8h			;444b
	jr z,$+9		;444d
	cp 0e6h			;444f
	jr z,$+5		;4451
	cp 0e5h			;4453
	ret nz			;4455
	sub 050h		;4456
	ex af,af'		;4458
	ld a,(0e661h)		;4459
	push bc			;445c
	ld b,a			;445d
	ex af,af'		;445e
	bit 1,b			;445f
	pop bc			;4461
	ret z			;4462
	sub 050h		;4463
	ret			;4465
	bit 0,c			;4466
	ret z			;4468
	push bc			;4469
	ld c,a			;446a
	ld b,008h		;446b
	rr c			;446d
	rla			;446f
	djnz $-3		;4470
	pop bc			;4472
	ret			;4473
	ld c,001h		;4474
	jr $-98			;4476
	call 04484h		;4478
	ld a,020h		;447b
	call 04060h		;447d
	dec c			;4480
	jr nz,$-9		;4481
	ret			;4483
	push de			;4484
	ld b,010h		;4485
	call 0004ah		;4487
	call 04469h		;448a
	ex de,hl		;448d
	call 0004dh		;448e
	ex de,hl		;4491
	inc e			;4492
	inc hl			;4493
	djnz $-13		;4494
	ld a,e			;4496
	sub 020h		;4497
	ld e,a			;4499
	bit 4,e			;449a
	jr z,$-23		;449c
	pop de			;449e
	ret			;449f
	ld a,0b8h		;44a0
	call 049b7h		;44a2
	ld a,03dh		;44a5
	call 040cbh		;44a7
	ld hl,00000h		;44aa
	ld bc,04000h		;44ad
	xor a			;44b0
	call 00056h		;44b1
	ld hl,044c5h		;44b4
	ld d,008h		;44b7
	ld c,000h		;44b9
	ld b,(hl)		;44bb
	call 00047h		;44bc
	inc hl			;44bf
	inc c			;44c0
	dec d			;44c1
	jr nz,$-7		;44c2
	ret			;44c4
	ld (bc),a		;44c5
	jp po,07f0eh		;44c6
	rlca			;44c9
	halt			;44ca
	inc bc			;44cb
	call po,0070eh		;44cc
	jp 04052h		;44cf
	call 044dfh		;44d2
	ld hl,0e009h		;44d5
	ld c,(hl)		;44d8
	ld (hl),a		;44d9
	xor c			;44da
	and (hl)		;44db
	dec hl			;44dc
	ld (hl),a		;44dd
	ret			;44de
	ld e,08fh		;44df
	ld a,00fh		;44e1
	call 00093h		;44e3
	ld a,00eh		;44e6
	di			;44e8
	call 00096h		;44e9
	ei			;44ec
	cpl			;44ed
	and 03fh		;44ee
	push af			;44f0
	ld a,007h		;44f1
	call 00141h		;44f3
	cpl			;44f6
	rrca			;44f7
	and 020h		;44f8
	ld e,a			;44fa
	ld a,008h		;44fb
	call 00141h		;44fd
	cpl			;4500
	rrca			;4501
	rrca			;4502
	ld b,a			;4503
	and 004h		;4504
	or e			;4506
	ld c,a			;4507
	ld a,b			;4508
	rrca			;4509
	rrca			;450a
	ld b,a			;450b
	and 018h		;450c
	or c			;450e
	ld c,a			;450f
	ld a,b			;4510
	rrca			;4511
	and 003h		;4512
	or c			;4514
	pop bc			;4515
	or b			;4516
	ret			;4517
	ld c,d			;4518
	add hl,sp		;4519
	inc c			;451a
	ld e,d			;451b
	add a,b			;451c
	ld l,h			;451d
	add hl,sp		;451e
	adc a,b			;451f
	inc h			;4520
	ld (02527h),hl		;4521
	dec l			;4524
	dec de			;4525
	inc hl			;4526
	dec e			;4527
	nop			;4528
	adc a,e			;4529
	jr c,$+42		;452a
	ld hl,(01e20h)		;452c
	rra			;452f
	dec h			;4530
	ld hl,0231bh		;4531
	dec e			;4534
	cp 08ah			;4535
	add hl,sp		;4537
	ld a,(de)		;4538
	jr z,$+36		;4539
	ld hl,(0211bh)		;453b
	jr nz,$+2		;453e
	ld de,01819h		;4540
	ld d,0feh		;4543
	add hl,bc		;4545
	ld a,(02c2bh)		;4546
	inc h			;4549
	rra			;454a
	nop			;454b
	inc h			;454c
	dec hl			;454d
	dec de			;454e
	inc e			;454f
	dec e			;4550
	nop			;4551
	jr z,$+31		;4552
	ld l,0ffh		;4554
	add hl,bc		;4556
	ld a,(00000h)		;4557
	dec hl			;455a
	add hl,hl		;455b
	dec de			;455c
	ld l,000h		;455d
	inc h			;455f
	dec h			;4560
	dec de			;4561
	inc hl			;4562
	dec h			;4563
	nop			;4564
	nop			;4565
	rst 38h			;4566
	jp z,01f3ah		;4567
	jr nz,$+38		;456a
	inc e			;456c
	ld (01d23h),hl		;456d
	cp 0c3h			;4570
	ld a,(01c24h)		;4572
	ld (01d23h),hl		;4575
	cp 0d3h			;4578
	ld a,(01d23h)		;457a
	inc h			;457d
	dec h			;457e
	cp 0d9h			;457f
	ld a,(02524h)		;4581
	dec de			;4584
	ld e,01dh		;4585
	rst 38h			;4587
	dec hl			;4588
	add hl,sp		;4589
	ld e,01bh		;458a
	ld hl,0001dh		;458c
	nop			;458f
	ld (01d26h),hl		;4590
	inc hl			;4593
	rst 38h			;4594
	ld hl,02000h		;4595
	ld bc,00080h		;4598
	xor a			;459b
	call 043c0h		;459c
	ld hl,00000h		;459f
	ld de,00008h		;45a2
	ld b,010h		;45a5
	push bc			;45a7
	ld bc,00008h		;45a8
	push hl			;45ab
	call 043c0h		;45ac
	pop hl			;45af
	add hl,de		;45b0
	inc a			;45b1
	pop bc			;45b2
	djnz $-12		;45b3
	ld de,045c9h		;45b5
	ld hl,02080h		;45b8
	call 043d1h		;45bb
	ld a,0f0h		;45be
	ld hl,00080h		;45c0
	ld bc,00118h		;45c3
	jp 043c0h		;45c6
	add a,e			;45c9
	nop			;45ca
	inc e			;45cb
	ld (06303h),hl		;45cc
	add a,l			;45cf
	ld (0001ch),hl		;45d0
	jr $+58			;45d3
	inc b			;45d5
	jr $-80			;45d6
	ld a,(hl)		;45d8
	nop			;45d9
	ld a,063h		;45da
	inc bc			;45dc
	ld c,03ch		;45dd
	ld (hl),b		;45df
	ld a,a			;45e0
	nop			;45e1
	ld a,063h		;45e2
	inc bc			;45e4
	ld c,003h		;45e5
	ld h,e			;45e7
	ld a,000h		;45e8
	ld c,01eh		;45ea
	ld (hl),066h		;45ec
	ld h,(hl)		;45ee
	ld a,a			;45ef
	ld b,000h		;45f0
	ld a,a			;45f2
	ld h,b			;45f3
	ld a,(hl)		;45f4
	ld h,e			;45f5
	inc bc			;45f6
	ld h,e			;45f7
	ld a,000h		;45f8
	ld a,063h		;45fa
	ld h,b			;45fc
	ld a,(hl)		;45fd
	ld h,e			;45fe
	ld h,e			;45ff
	ld a,000h		;4600
	ld a,a			;4602
	ld h,e			;4603
	ld b,00ch		;4604
	inc bc			;4606
	jr $-91			;4607
	nop			;4609
	ld a,063h		;460a
	ld h,e			;460c
	ld a,063h		;460d
	ld h,e			;460f
	ld a,000h		;4610
	ld a,063h		;4612
	ld h,e			;4614
	ccf			;4615
	inc bc			;4616
	ld h,e			;4617
	ld a,03ch		;4618
	ld b,d			;461a
	sbc a,c			;461b
	and c			;461c
	and c			;461d
	sbc a,c			;461e
	ld b,d			;461f
	inc a			;4620
	nop			;4621
	inc e			;4622
	ld (hl),063h		;4623
	ld h,e			;4625
	ld a,a			;4626
	ld h,e			;4627
	ld h,e			;4628
	nop			;4629
	ld a,063h		;462a
	inc bc			;462c
	ld h,b			;462d
	sub e			;462e
	ld h,e			;462f
	ld a,000h		;4630
	ld a,a			;4632
	ld h,b			;4633
	ld h,b			;4634
	ld a,(hl)		;4635
	ld h,b			;4636
	ld h,b			;4637
	ld a,a			;4638
	nop			;4639
	ld a,063h		;463a
	ld h,b			;463c
	ld h,a			;463d
	ld h,e			;463e
	ld h,e			;463f
	ccf			;4640
	nop			;4641
	inc bc			;4642
	ld h,e			;4643
	add a,c			;4644
	ld a,a			;4645
	inc bc			;4646
	ld h,e			;4647
	add a,d			;4648
	nop			;4649
	inc a			;464a
	dec b			;464b
	jr $-115		;464c
	inc a			;464e
	nop			;464f
	ld h,e			;4650
	ld (hl),a		;4651
	ld a,a			;4652
	ld a,a			;4653
	ld l,e			;4654
	ld h,e			;4655
	ld h,e			;4656
	nop			;4657
	ld a,005h		;4658
	ld h,e			;465a
	sub e			;465b
	ld a,000h		;465c
	ld a,(hl)		;465e
	ld h,e			;465f
	ld h,e			;4660
	ld h,d			;4661
	ld a,h			;4662
	ld h,(hl)		;4663
	ld h,e			;4664
	nop			;4665
	ld a,063h		;4666
	ld h,b			;4668
	ld a,003h		;4669
	ld h,e			;466b
	ld a,000h		;466c
	ld a,(hl)		;466e
	ld b,018h		;466f
	add a,c			;4671
	nop			;4672
	inc b			;4673
	ld h,e			;4674
	adc a,b			;4675
	ld (hl),01ch		;4676
	ex af,af'		;4678
	nop			;4679
	ld a,a			;467a
	ld h,b			;467b
	ld h,b			;467c
	ld a,(hl)		;467d
	inc bc			;467e
	ld h,b			;467f
	adc a,c			;4680
	nop			;4681
	ld h,e			;4682
	ld h,(hl)		;4683
	ld l,h			;4684
	ld a,b			;4685
	ld a,h			;4686
	ld l,(hl)		;4687
	ld h,a			;4688
	nop			;4689
	ld b,060h		;468a
	adc a,e			;468c
	ld a,a			;468d
	nop			;468e
	ld h,e			;468f
	ld (hl),e		;4690
	ld a,e			;4691
	ld a,a			;4692
	ld l,a			;4693
	ld h,a			;4694
	ld h,e			;4695
	nop			;4696
	ld a,(hl)		;4697
	inc bc			;4698
	ld h,e			;4699
	add a,h			;469a
	ld a,(hl)		;469b
	ld h,b			;469c
	ld h,b			;469d
	nop			;469e
	ld b,063h		;469f
	adc a,(hl)		;46a1
	ld a,000h		;46a2
	ld h,e			;46a4
	ld h,e			;46a5
	ld l,e			;46a6
	ld l,e			;46a7
	ld a,a			;46a8
	ld (hl),a		;46a9
	ld (06600h),hl		;46aa
	ld h,(hl)		;46ad
	ld a,(hl)		;46ae
	inc a			;46af
	inc bc			;46b0
	jr $+8			;46b1
	nop			;46b3
	ld (bc),a		;46b4
	jr $-123		;46b5
	nop			;46b7
	ld a,h			;46b8
	ld h,(hl)		;46b9
	inc bc			;46ba
	ld h,e			;46bb
	add a,e			;46bc
	ld h,(hl)		;46bd
	ld a,h			;46be
	nop			;46bf
	inc b			;46c0
	jr $-115		;46c1
	nop			;46c3
	jr $+26			;46c4
	nop			;46c6
	ld a,(hl)		;46c7
	ld h,e			;46c8
	ld h,e			;46c9
	ld a,(hl)		;46ca
	ld h,e			;46cb
	ld h,e			;46cc
	ld a,(hl)		;46cd
	nop			;46ce
	ld a,00eh		;46cf
	ld (0e00ah),a		;46d1
	ld hl,03aaah		;46d4
	ld (0e00eh),hl		;46d7
	jp 04025h		;46da
	ld de,04723h		;46dd
	ld hl,06200h		;46e0
	call 043d1h		;46e3
	ld hl,00200h		;46e6
	ld bc,000d8h		;46e9
	ld a,0f0h		;46ec
	jp 043c0h		;46ee
	ld hl,(0e00eh)		;46f1
	ld de,0ffe0h		;46f4
	add hl,de		;46f7
	ld (0e00eh),hl		;46f8
	ld a,040h		;46fb
	ld b,003h		;46fd
	call 04715h		;46ff
	ld bc,00b0ch		;4702
	call 04715h		;4705
	ld b,c			;4708
	call 04715h		;4709
	xor a			;470c
	call 00056h		;470d
	ld hl,0e00ah		;4710
	dec (hl)		;4713
	ret			;4714
	push hl			;4715
	call 0004dh		;4716
	inc hl			;4719
	inc a			;471a
	djnz $-5		;471b
	pop de			;471d
	ld hl,00020h		;471e
	add hl,de		;4721
	ret			;4722
	rrca			;4723
	nop			;4724
	ld bc,00601h		;4725
	nop			;4728
	add a,d			;4729
	rst 38h			;472a
	cp 008h			;472b
	rrca			;472d
	add a,h			;472e
	jp 0cfc7h		;472f
	rst 18h			;4732
	inc bc			;4733
	rst 38h			;4734
	adc a,c			;4735
	cp 0fch			;4736
	ret m			;4738
	ret p			;4739
	ret po			;473a
	ret nz			;473b
	add a,b			;473c
	rlca			;473d
	rlca			;473e
	dec b			;473f
	nop			;4740
	add a,e			;4741
	inc bc			;4742
	rst 8			;4743
	rst 18h			;4744
	dec b			;4745
	nop			;4746
	add a,e			;4747
	pop hl			;4748
	ld sp,hl		;4749
	ld a,l			;474a
	dec b			;474b
	nop			;474c
	add a,e			;474d
	rst 28h			;474e
	rst 38h			;474f
	rst 30h			;4750
	dec b			;4751
	nop			;4752
	add a,e			;4753
	rlca			;4754
	adc a,a			;4755
	sbc a,(hl)		;4756
	dec b			;4757
	nop			;4758
	add a,e			;4759
	ret p			;475a
	ret m			;475b
	ld a,b			;475c
	dec b			;475d
	nop			;475e
	add a,e			;475f
	rst 30h			;4760
	rst 38h			;4761
	ei			;4762
	dec b			;4763
	nop			;4764
	adc a,e			;4765
	adc a,a			;4766
	rst 18h			;4767
	rst 30h			;4768
	inc c			;4769
	ld e,01eh		;476a
	inc c			;476c
	nop			;476d
	ld e,09eh		;476e
	sbc a,(hl)		;4770
	ex af,af'		;4771
	rrca			;4772
	sub b			;4773
	rst 38h			;4774
	rst 38h			;4775
	rst 18h			;4776
	rst 8			;4777
	rst 0			;4778
	jp 0c0c1h		;4779
	rlca			;477c
	add a,a			;477d
	rst 0			;477e
	rst 28h			;477f
	rst 38h			;4780
	rst 38h			;4781
	rst 38h			;4782
	call m,0de04h		;4783
	add a,h			;4786
	sbc a,(hl)		;4787
	sbc a,a			;4788
	rrca			;4789
	inc bc			;478a
	dec b			;478b
	dec a			;478c
	add a,e			;478d
	ld a,l			;478e
	ld sp,hl		;478f
	pop hl			;4790
	ex af,af'		;4791
	ex (sp),hl		;4792
	sub b			;4793
	call c,0c7c0h		;4794
	sbc a,0dch		;4797
	sbc a,0cfh		;4799
	jp 07c3ch		;479b
	call m,03c3ch		;479e
	ld a,h			;47a1
	call m,008deh		;47a2
	pop af			;47a5
	ex af,af'		;47a6
	ex (sp),hl		;47a7
	ex af,af'		;47a8
	sbc a,088h		;47a9
	jr c,$+70		;47ab
	cp d			;47ad
	xor d			;47ae
	or d			;47af
	xor d			;47b0
	ld b,h			;47b1
	jr c,$+5		;47b2
	nop			;47b4
	ld bc,004ffh		;47b5
	nop			;47b8
	nop			;47b9
	ld b,0e0h		;47ba
	call 044cdh		;47bc
	call 04386h		;47bf
	call 045b5h		;47c2
	ld hl,02300h		;47c5
	ld de,047f6h		;47c8
	call 043d1h		;47cb
	ld hl,00300h		;47ce
	ld de,048fah		;47d1
	call 043d1h		;47d4
	ld hl,038cbh		;47d7
	ld de,00020h		;47da
	ld a,060h		;47dd
	ld c,003h		;47df
	ld b,00bh		;47e1
	push hl			;47e3
	call 0004dh		;47e4
	inc hl			;47e7
	inc a			;47e8
	djnz $-5		;47e9
	pop hl			;47eb
	add hl,de		;47ec
	dec c			;47ed
	jr nz,$-13		;47ee
	ld de,04529h		;47f0
	jp 043f1h		;47f3
	ld (bc),a		;47f6
	nop			;47f7
	sub (hl)		;47f8
	ld b,00fh		;47f9
	rra			;47fb
	rra			;47fc
	ld e,00eh		;47fd
	inc e			;47ff
	ld e,00fh		;4800
	rst 38h			;4802
	rst 38h			;4803
	jr nc,$-3		;4804
	pop af			;4806
	nop			;4807
	nop			;4808
	jr c,$-2		;4809
	call m,0fc60h		;480b
	call m,00005h		;480e
	add a,e			;4811
	ld (hl),b		;4812
	ld a,b			;4813
	add hl,sp		;4814
	inc bc			;4815
	nop			;4816
	add a,l			;4817
	jr $+62			;4818
	inc e			;481a
	dec e			;481b
	cp a			;481c
	dec b			;481d
	nop			;481e
	adc a,e			;481f
	ret po			;4820
	ld (hl),b		;4821
	or c			;4822
	nop			;4823
	nop			;4824
	jr nz,$+50		;4825
	ld (hl),b		;4827
	ld (hl),c		;4828
	ex (sp),hl		;4829
	rst 20h			;482a
	dec b			;482b
	nop			;482c
	adc a,e			;482d
	add a,b			;482e
	cp 0ffh			;482f
	nop			;4831
	ld b,00eh		;4832
	rrca			;4834
	rlca			;4835
	inc bc			;4836
	ld b,0bfh		;4837
	inc bc			;4839
	nop			;483a
	adc a,a			;483b
	inc c			;483c
	sbc a,(hl)		;483d
	ld e,00fh		;483e
	rst 0			;4840
	nop			;4841
	ld (hl),b		;4842
	ld a,b			;4843
	ld a,h			;4844
	call m,0f8fch		;4845
	ret po			;4848
	rrca			;4849
	rrca			;484a
	inc bc			;484b
	ld c,002h		;484c
	ld e,0d1h		;484e
	ld a,0f9h		;4850
	or (hl)			;4852
	rrca			;4853
	ld a,a			;4854
	and 0dfh		;4855
	adc a,0ffh		;4857
	ld a,b			;4859
	ld a,h			;485a
	call pe,039f1h		;485b
	cp h			;485e
	ld a,h			;485f
	ld a,b			;4860
	ld sp,0fb3bh		;4861
	ld sp,hl		;4864
	pop af			;4865
	or c			;4866
	ld sp,0ff3dh		;4867
	rst 18h			;486a
	adc a,(hl)		;486b
	xor 0feh		;486c
	rst 38h			;486e
	rst 30h			;486f
	or a			;4870
	rst 0			;4871
	rst 8			;4872
	rrca			;4873
	rrca			;4874
	rst 28h			;4875
	defb 0edh ;next byte illegal after ed	;4876
	exx			;4877
	add a,e			;4878
	rst 0			;4879
	jp 0cfc0h		;487a
	rst 18h			;487d
	rst 8			;487e
	ex (sp),hl		;487f
	rst 28h			;4880
	rst 38h			;4881
	add a,b			;4882
	ld h,a			;4883
	rst 38h			;4884
	rst 38h			;4885
	sbc a,e			;4886
	add a,b			;4887
	inc c			;4888
	sbc a,a			;4889
	nop			;488a
	sbc a,a			;488b
	rst 8			;488c
	ret nz			;488d
	sbc a,a			;488e
	rlca			;488f
	add hl,de		;4890
	sbc a,a			;4891
	rra			;4892
	jr $-98			;4893
	add hl,sp		;4895
	cp a			;4896
	ld e,00ch		;4897
	ret m			;4899
	ld a,h			;489a
	jr c,$+58		;489b
	cp h			;489d
	call m,0c2f9h		;489e
	inc bc			;48a1
	ld a,h			;48a2
	ret nc			;48a3
	ld a,e			;48a4
	ld (hl),a		;48a5
	ld (hl),a		;48a6
	daa			;48a7
	nop			;48a8
	ld sp,hl		;48a9
	ld (hl),l		;48aa
	halt			;48ab
	xor 0eeh		;48ac
	sbc a,a			;48ae
	rra			;48af
	inc bc			;48b0
	ret p			;48b1
	cp b			;48b2
	pop hl			;48b3
	defb 0ddh,03ch,0feh ;illegal sequence	;48b4
	rst 38h			;48b7
	add a,0fbh		;48b8
	di			;48ba
	rst 20h			;48bb
	rst 20h			;48bc
	adc a,01eh		;48bd
	inc a			;48bf
	nop			;48c0
	or a			;48c1
	or a			;48c2
	rst 28h			;48c3
	defb 0edh ;next byte illegal after ed	;48c4
	exx			;48c5
	ret nc			;48c6
	nop			;48c7
	nop			;48c8
	add a,e			;48c9
	jp 0f7f7h		;48ca
	ei			;48cd
	ei			;48ce
	ld a,e			;48cf
	jr c,$-48		;48d0
	sbc a,0dfh		;48d2
	sbc a,a			;48d4
	sbc a,a			;48d5
	adc a,a			;48d6
	nop			;48d7
	nop			;48d8
	ld b,007h		;48d9
	rst 38h			;48db
	rst 38h			;48dc
	di			;48dd
	inc bc			;48de
	ld bc,01f00h		;48df
	sbc a,a			;48e2
	call z,0dfddh		;48e3
	rst 18h			;48e6
	adc a,h			;48e7
	nop			;48e8
	adc a,l			;48e9
	set 3,e			;48ea
	in a,(0bbh)		;48ec
	ld (hl),a		;48ee
	ld (hl),e		;48ef
	nop			;48f0
	add a,h			;48f1
	adc a,h			;48f2
	sbc a,(hl)		;48f3
	inc bc			;48f4
	cp 082h			;48f5
	call m,00038h		;48f7
	ld a,a			;48fa
	add a,c			;48fb
	ld a,a			;48fc
	add a,c			;48fd
	ld a,(bc)		;48fe
	add a,c			;48ff
	nop			;4900
	di			;4901
	push hl			;4902
	ld hl,0e002h		;4903
	bit 6,(hl)		;4906
	jr z,$+110		;4908
	jr $+4			;490a
	di			;490c
	push hl			;490d
	push de			;490e
	push bc			;490f
	push af			;4910
	ld c,a			;4911
	ld d,03fh		;4912
	and d			;4914
	ld b,002h		;4915
	ld hl,0e02eh		;4917
	cp 01dh			;491a
	jr c,$+15		;491c
	cp 025h			;491e
	ld hl,0e012h		;4920
	jr c,$+35		;4923
	ld hl,0e012h		;4925
	inc b			;4928
	jr $+29			;4929
	dec b			;492b
	cp 018h			;492c
	jr c,$+12		;492e
	ld hl,0e012h		;4930
	cp 01ah			;4933
	jr c,$+5		;4935
	ld hl,0e020h		;4937
	ld a,c			;493a
	or a			;493b
	jp m,0494eh		;493c
	ld a,(0e600h)		;493f
	cp 002h			;4942
	jr z,$+47		;4944
	ld a,(hl)		;4946
	and d			;4947
	ld e,a			;4948
	ld a,c			;4949
	and d			;494a
	cp e			;494b
	jr c,$+39		;494c
	and d			;494e
	add a,a			;494f
	ld de,04b36h		;4950
	call 04060h		;4953
	dec hl			;4956
	dec hl			;4957
	ld (hl),001h		;4958
	inc hl			;495a
	inc hl			;495b
	ld (hl),c		;495c
	inc hl			;495d
	ld a,(de)		;495e
	ld (hl),a		;495f
	inc hl			;4960
	inc de			;4961
	ld a,(de)		;4962
	ld (hl),a		;4963
	ld a,005h		;4964
	call 0405bh		;4966
	xor a			;4969
	ld (hl),a		;496a
	ld a,005h		;496b
	call 0405bh		;496d
	inc de			;4970
	djnz $-25		;4971
	pop af			;4973
	pop bc			;4974
	pop de			;4975
	pop hl			;4976
	ei			;4977
	ret			;4978
	inc hl			;4979
	ld a,(ix+009h)		;497a
	inc a			;497d
	cp (hl)			;497e
	jr z,$+21		;497f
	jp m,04985h		;4981
	dec a			;4984
	ld (ix+009h),a		;4985
	inc hl			;4988
	ld a,(hl)		;4989
	ld (ix+003h),a		;498a
	inc hl			;498d
	ld a,(hl)		;498e
	ld (ix+004h),a		;498f
	jr $+11			;4992
	inc hl			;4994
	inc hl			;4995
	xor a			;4996
	ld (ix+009h),a		;4997
	call 04b24h		;499a
	inc (ix+000h)		;499d
	jr $+80			;49a0
	ld a,(0e03ah)		;49a2
	ld e,a			;49a5
	ld a,c			;49a6
	cp 001h			;49a7
	jr z,$+3		;49a9
	dec a			;49ab
	rlca			;49ac
	rlca			;49ad
	rlca			;49ae
	dec d			;49af
	jr z,$+6		;49b0
	cpl			;49b2
	and e			;49b3
	jr $+3			;49b4
	or e			;49b6
	ld (0e03ah),a		;49b7
	ld e,a			;49ba
	ld a,007h		;49bb
	jp 00093h		;49bd
	ld a,(0e03ah)		;49c0
	call 049b7h		;49c3
	ld c,001h		;49c6
	ld ix,0e010h		;49c8
	exx			;49cc
	ld b,003h		;49cd
	ld de,0000eh		;49cf
	exx			;49d2
	ld a,(ix+002h)		;49d3
	or a			;49d6
	jr nz,$+7		;49d7
	call 04a59h		;49d9
	jr $+5			;49dc
	call 049e9h		;49de
	inc c			;49e1
	inc c			;49e2
	exx			;49e3
	add ix,de		;49e4
	djnz $-20		;49e6
	ret			;49e8
	bit 6,a			;49e9
	ld d,001h		;49eb
	call z,049a2h		;49ed
	ld a,(ix+002h)		;49f0
	or a			;49f3
	jp m,04a68h		;49f4
	dec (ix+000h)		;49f7
	ret nz			;49fa
	ld l,(ix+003h)		;49fb
	ld h,(ix+004h)		;49fe
	ld a,(hl)		;4a01
	cp 0feh			;4a02
	jp z,04979h		;4a04
	jp nc,04a59h		;4a07
	bit 7,(ix+002h)		;4a0a
	jp nz,04a96h		;4a0e
	and 0f0h		;4a11
	cp 020h			;4a13
	jr nz,$+9		;4a15
	ld a,(hl)		;4a17
	and 00fh		;4a18
	ld (ix+001h),a		;4a1a
	inc hl			;4a1d
	ld a,(hl)		;4a1e
	and 0f0h		;4a1f
	cp 010h			;4a21
	jr nz,$+18		;4a23
	ld a,(hl)		;4a25
	and 00fh		;4a26
	add a,a			;4a28
	ld e,a			;4a29
	ld a,006h		;4a2a
	call 00093h		;4a2c
	ld d,000h		;4a2f
	call 049a2h		;4a31
	inc hl			;4a34
	ld a,(hl)		;4a35
	and 0f0h		;4a36
	ld b,a			;4a38
	xor (hl)		;4a39
	ld d,a			;4a3a
	inc hl			;4a3b
	ld e,(hl)		;4a3c
	call 04b24h		;4a3d
	ex de,hl		;4a40
	call 04b12h		;4a41
	ld a,b			;4a44
	rrca			;4a45
	rrca			;4a46
	rrca			;4a47
	rrca			;4a48
	ld h,a			;4a49
	ld e,(ix+001h)		;4a4a
	ld (ix+000h),e		;4a4d
	ld a,(ix+00ch)		;4a50
	add a,e			;4a53
	ld (ix+008h),a		;4a54
	jr $+55			;4a57
	ld d,001h		;4a59
	call 049a2h		;4a5b
	xor a			;4a5e
	ld (ix+002h),a		;4a5f
	ld (ix+00bh),a		;4a62
	ld h,a			;4a65
	jr $+40			;4a66
	dec (ix+000h)		;4a68
	jp z,049fbh		;4a6b
	dec (ix+008h)		;4a6e
	ld a,(ix+008h)		;4a71
	cp (ix+000h)		;4a74
	jr nz,$+11		;4a77
	ld e,a			;4a79
	ld a,(ix+00dh)		;4a7a
	cp e			;4a7d
	ld a,e			;4a7e
	jr nc,$+6		;4a7f
	ret			;4a81
	dec (ix+008h)		;4a82
	ld a,(ix+007h)		;4a85
	dec a			;4a88
	ret m			;4a89
	ld (ix+007h),a		;4a8a
	ld h,a			;4a8d
	ld a,c			;4a8e
	rrca			;4a8f
	add a,088h		;4a90
	ld e,h			;4a92
	jp 00093h		;4a93
	ld a,(hl)		;4a96
	and 0f0h		;4a97
	cp 0d0h			;4a99
	ld a,(hl)		;4a9b
	jr nz,$+9		;4a9c
	and 00fh		;4a9e
	ld (ix+00ah),a		;4aa0
	inc hl			;4aa3
	ld a,(hl)		;4aa4
	cp 0f0h			;4aa5
	jr c,$+26		;4aa7
	and 00fh		;4aa9
	ld (ix+006h),a		;4aab
	inc hl			;4aae
	ld a,(hl)		;4aaf
	and 00fh		;4ab0
	ld (ix+00dh),a		;4ab2
	xor (hl)		;4ab5
	rrca			;4ab6
	rrca			;4ab7
	rrca			;4ab8
	rrca			;4ab9
	and 00fh		;4aba
	ld (ix+00ch),a		;4abc
	inc hl			;4abf
	ld a,(hl)		;4ac0
	cp 0e0h			;4ac1
	jr c,$+19		;4ac3
	and 00fh		;4ac5
	bit 3,a			;4ac7
	jr z,$+8		;4ac9
	ld (ix+00bh),a		;4acb
	inc hl			;4ace
	jr $-57			;4acf
	ld (ix+005h),a		;4ad1
	inc hl			;4ad4
	ld a,(hl)		;4ad5
	and 00fh		;4ad6
	ld b,a			;4ad8
	ld a,(ix+00ah)		;4ad9
	jr z,$+7		;4adc
	add a,(ix+00ah)		;4ade
	djnz $-3		;4ae1
	ld (ix+001h),a		;4ae3
	ld a,(hl)		;4ae6
	call 04b24h		;4ae7
	and 0f0h		;4aea
	rrca			;4aec
	rrca			;4aed
	rrca			;4aee
	rrca			;4aef
	ld b,a			;4af0
	sub 00ch		;4af1
	jr z,$+5		;4af3
	ld a,(ix+006h)		;4af5
	ld (ix+007h),a		;4af8
	call 04a49h		;4afb
	ld hl,04b2ch		;4afe
	ld a,b			;4b01
	call 0405bh		;4b02
	ld l,(hl)		;4b05
	ld h,000h		;4b06
	ld a,(ix+005h)		;4b08
	or a			;4b0b
	jr z,$+6		;4b0c
	ld b,a			;4b0e
	add hl,hl		;4b0f
	djnz $-1		;4b10
	ld a,(ix+00bh)		;4b12
	or a			;4b15
	jr z,$+3		;4b16
	inc hl			;4b18
	ld a,c			;4b19
	ld e,h			;4b1a
	call 00093h		;4b1b
	ld a,c			;4b1e
	dec a			;4b1f
	ld e,l			;4b20
	jp 00093h		;4b21
	inc hl			;4b24
	ld (ix+003h),l		;4b25
	ld (ix+004h),h		;4b28
	ret			;4b2b
	ld l,e			;4b2c
	ld h,l			;4b2d
	ld e,a			;4b2e
	ld e,d			;4b2f
	ld d,l			;4b30
	ld d,b			;4b31
	ld c,h			;4b32
	ld b,a			;4b33
	ld b,e			;4b34
	ld b,b			;4b35
	inc a			;4b36
	add hl,sp		;4b37
	ld de,02f4ch		;4b38
	ld c,h			;4b3b
	ld l,(hl)		;4b3c
	ld c,(hl)		;4b3d
	or d			;4b3e
	ld c,l			;4b3f
	add a,b			;4b40
	ld c,(hl)		;4b41
	sub h			;4b42
	ld c,(hl)		;4b43
	call nz,0724bh		;4b44
	ld c,l			;4b47
	ld h,c			;4b48
	ld c,a			;4b49
	rst 18h			;4b4a
	ld c,e			;4b4b
	exx			;4b4c
	ld c,l			;4b4d
	call 0644dh		;4b4e
	ld c,h			;4b51
	ld (hl),e		;4b52
	ld c,a			;4b53
	ccf			;4b54
	ld c,a			;4b55
	dec e			;4b56
	ld c,a			;4b57
	scf			;4b58
	ld c,a			;4b59
	inc bc			;4b5a
	ld c,a			;4b5b
	ld a,(bc)		;4b5c
	ld c,h			;4b5d
	jp nc,04953h		;4b5e
	ld c,a			;4b61
	xor h			;4b62
	ld c,a			;4b63
	ld c,b			;4b64
	ld c,l			;4b65
	adc a,a			;4b66
	ld c,l			;4b67
	sbc a,l			;4b68
	ld c,l			;4b69
	ld e,04eh		;4b6a
	ex af,af'		;4b6c
	ld c,(hl)		;4b6d
	jp nc,08e53h		;4b6e
	ld d,c			;4b71
	ld sp,07352h		;4b72
	ld d,b			;4b75
	in a,(050h)		;4b76
	in a,(04fh)		;4b78
	jp nc,00f53h		;4b7a
	ld d,b			;4b7d
	ld hl,0ba50h		;4b7e
	ld c,(hl)		;4b81
	ret c			;4b82
	ld c,(hl)		;4b83
	or 04eh			;4b84
	jp nc,0b653h		;4b86
	ld c,e			;4b89
	or a			;4b8a
	ld c,e			;4b8b
	adc a,b			;4b8c
	ld c,h			;4b8d
	add hl,bc		;4b8e
	ld c,l			;4b8f
	bit 1,h			;4b90
	ld e,h			;4b92
	ld d,c			;4b93
	jp nc,07553h		;4b94
	ld d,c			;4b97
	jp nc,07f53h		;4b98
	ld c,a			;4b9b
	add a,b			;4b9c
	ld c,a			;4b9d
	inc l			;4b9e
	ld d,e			;4b9f
	ld e,a			;4ba0
	ld d,e			;4ba1
	sub a			;4ba2
	ld d,e			;4ba3
	pop bc			;4ba4
	ld d,d			;4ba5
	rst 20h			;4ba6
	ld d,d			;4ba7
	inc b			;4ba8
	ld d,e			;4ba9
	ld l,l			;4baa
	ld d,d			;4bab
	add a,(hl)		;4bac
	ld d,d			;4bad
	sbc a,d			;4bae
	ld d,d			;4baf
	jp nc,0d253h		;4bb0
	ld d,e			;4bb3
	jp nc,0e853h		;4bb4
	pop de			;4bb7
	ei			;4bb8
	adc a,b			;4bb9
	pop hl			;4bba
	inc b			;4bbb
	ld (hl),h		;4bbc
	ld b,h			;4bbd
	ld (hl),h		;4bbe
	ei			;4bbf
	inc hl			;4bc0
	ret po			;4bc1
	add hl,bc		;4bc2
	rst 38h			;4bc3
	ld (0f01eh),hl		;4bc4
	ld b,b			;4bc7
	ret nc			;4bc8
	ld h,b			;4bc9
	ret po			;4bca
	ld h,b			;4bcb
	ld (0f016h),hl		;4bcc
	jr nz,$-30		;4bcf
	ld b,b			;4bd1
	ret nc			;4bd2
	jr nz,$-62		;4bd3
	ld b,b			;4bd5
	or b			;4bd6
	jr nz,$-94		;4bd7
	ld b,b			;4bd9
	sub b			;4bda
	jr nz,$-126		;4bdb
	ld b,b			;4bdd
	rst 38h			;4bde
	ld hl,078e0h		;4bdf
	ret nc			;4be2
	ld a,b			;4be3
	ret nz			;4be4
	ld a,b			;4be5
	or b			;4be6
	ld a,b			;4be7
	or b			;4be8
	ld a,c			;4be9
	and b			;4bea
	ld a,b			;4beb
	ret nc			;4bec
	ld a,c			;4bed
	ret nz			;4bee
	ld a,c			;4bef
	ret nz			;4bf0
	ld a,b			;4bf1
	or b			;4bf2
	ld a,b			;4bf3
	and b			;4bf4
	ld a,b			;4bf5
	sub b			;4bf6
	ld a,b			;4bf7
	inc hl			;4bf8
	or b			;4bf9
	ld a,b			;4bfa
	sub b			;4bfb
	ld a,c			;4bfc
	and b			;4bfd
	ld a,b			;4bfe
	add a,b			;4bff
	ld a,c			;4c00
	sub b			;4c01
	ld a,b			;4c02
	ld (hl),b		;4c03
	ld a,c			;4c04
	add a,b			;4c05
	ld a,b			;4c06
	ld h,b			;4c07
	ld a,c			;4c08
	rst 38h			;4c09
	dec h			;4c0a
	or b			;4c0b
	ld b,b			;4c0c
	ld hl,(080b0h)		;4c0d
	rst 38h			;4c10
	ld hl,0a012h		;4c11
	nop			;4c14
	ret nz			;4c15
	nop			;4c16
	sub b			;4c17
	nop			;4c18
	or b			;4c19
	nop			;4c1a
	ld d,090h		;4c1b
	nop			;4c1d
	or b			;4c1e
	nop			;4c1f
	add a,b			;4c20
	nop			;4c21
	and b			;4c22
	nop			;4c23
	ld (hl),b		;4c24
	nop			;4c25
	add a,b			;4c26
	nop			;4c27
	ld h,b			;4c28
	nop			;4c29
	cp 00ah			;4c2a
	ld de,0ff4ch		;4c2c
	ld (01cb0h),hl		;4c2f
	ld hl,019b0h		;4c32
	and b			;4c35
	inc e			;4c36
	and b			;4c37
	dec e			;4c38
	sub b			;4c39
	dec e			;4c3a
	sub b			;4c3b
	dec e			;4c3c
	ld (hl),b		;4c3d
	dec e			;4c3e
	inc hl			;4c3f
	and b			;4c40
	dec e			;4c41
	ld hl,01ea0h		;4c42
	and b			;4c45
	ld e,000h		;4c46
	nop			;4c48
	or b			;4c49
	inc e			;4c4a
	or b			;4c4b
	inc e			;4c4c
	or b			;4c4d
	add hl,de		;4c4e
	and b			;4c4f
	inc e			;4c50
	and b			;4c51
	dec e			;4c52
	sub b			;4c53
	dec e			;4c54
	sub b			;4c55
	dec e			;4c56
	ld (hl),b		;4c57
	dec e			;4c58
	inc hl			;4c59
	and b			;4c5a
	dec e			;4c5b
	ld (01ea0h),hl		;4c5c
	cp 002h			;4c5f
	cpl			;4c61
	ld c,h			;4c62
	rst 38h			;4c63
	ld (0a31fh),hl		;4c64
	ld e,c			;4c67
	ld e,0b2h		;4c68
	ld (bc),a		;4c6a
	dec e			;4c6b
	pop bc			;4c6c
	ret p			;4c6d
	ld e,0e1h		;4c6e
	ld (hl),b		;4c70
	rra			;4c71
	pop de			;4c72
	exx			;4c73
	jp nc,0e102h		;4c74
	sub b			;4c77
	jp p,0c140h		;4c78
	and b			;4c7b
	or d			;4c7c
	djnz $-92		;4c7d
	ld a,(09128h)		;4c7f
	ret nz			;4c82
	add a,d			;4c83
	ld c,d			;4c84
	ld (hl),e		;4c85
	ld a,(022ffh)		;4c86
	rra			;4c89
	or e			;4c8a
	nop			;4c8b
	or c			;4c8c
	ld d,b			;4c8d
	or c			;4c8e
	add a,b			;4c8f
	or e			;4c90
	jr nc,$-77		;4c91
	ld b,b			;4c93
	or e			;4c94
	ld (hl),b		;4c95
	and c			;4c96
	ld (010a3h),hl		;4c97
	sub c			;4c9a
	add a,b			;4c9b
	or e			;4c9c
	jr nz,$-77		;4c9d
	and b			;4c9f
	jp 0c170h		;4ca0
	djnz $-43		;4ca3
	nop			;4ca5
	pop de			;4ca6
	nop			;4ca7
	jp 0c120h		;4ca8
	ld b,b			;4cab
	or e			;4cac
	jr nc,$-77		;4cad
	ld b,l			;4caf
	or e			;4cb0
	ld h,a			;4cb1
	and c			;4cb2
	jr nz,$-59		;4cb3
	daa			;4cb5
	and c			;4cb6
	add hl,hl		;4cb7
	sub e			;4cb8
	djnz $-125		;4cb9
	add a,b			;4cbb
	add a,e			;4cbc
	ld (02071h),a		;4cbd
	ld (hl),e		;4cc0
	nop			;4cc1
	ld h,c			;4cc2
	add a,b			;4cc3
	ld h,e			;4cc4
	ld (02051h),a		;4cc5
	ld d,e			;4cc8
	nop			;4cc9
	rst 38h			;4cca
	ld (0a21fh),hl		;4ccb
	ret p			;4cce
	and c			;4ccf
	ld h,b			;4cd0
	and e			;4cd1
	djnz $-93		;4cd2
	jr nz,$-91		;4cd4
	ld d,b			;4cd6
	and c			;4cd7
	ld (bc),a		;4cd8
	or d			;4cd9
	ret p			;4cda
	pop bc			;4cdb
	ld h,b			;4cdc
	jp 0c100h		;4cdd
	add a,b			;4ce0
	out (050h),a		;4ce1
	pop de			;4ce3
	nop			;4ce4
	jp po,0e1e0h		;4ce5
	jr nc,$-43		;4ce8
	nop			;4cea
	pop de			;4ceb
	jr nz,$-59		;4cec
	djnz $-61		;4cee
	ld (020c3h),a		;4cf0
	or c			;4cf3
	djnz $-75		;4cf4
	ld d,a			;4cf6
	or c			;4cf7
	ld hl,0f0a2h		;4cf8
	sub c			;4cfb
	ld h,b			;4cfc
	add a,e			;4cfd
	ld (de),a		;4cfe
	add a,c			;4cff
	djnz $+116		;4d00
	ret nc			;4d02
	ld (hl),e		;4d03
	ld (de),a		;4d04
	ld h,c			;4d05
	djnz $+100		;4d06
	ret nc			;4d08
	ld (0911dh),hl		;4d09
	ret p			;4d0c
	sub b			;4d0d
	ld h,b			;4d0e
	sub d			;4d0f
	djnz $-93		;4d10
	jr nz,$-76		;4d12
	ld d,b			;4d14
	pop bc			;4d15
	ld (bc),a		;4d16
	sub c			;4d17
	ret p			;4d18
	and c			;4d19
	ld h,b			;4d1a
	and d			;4d1b
	nop			;4d1c
	and c			;4d1d
	add a,b			;4d1e
	or d			;4d1f
	ld d,b			;4d20
	or c			;4d21
	nop			;4d22
	pop bc			;4d23
	ret po			;4d24
	pop bc			;4d25
	jr nc,$-76		;4d26
	nop			;4d28
	or c			;4d29
	jr nz,$-92		;4d2a
	djnz $-93		;4d2c
	ld (020a2h),a		;4d2e
	sub c			;4d31
	djnz $-108		;4d32
	ld d,a			;4d34
	sub c			;4d35
	ld hl,0f081h		;4d36
	ld (hl),c		;4d39
	ld h,b			;4d3a
	ld h,d			;4d3b
	ld (de),a		;4d3c
	ld h,c			;4d3d
	djnz $+83		;4d3e
	ret nc			;4d40
	ld d,d			;4d41
	ld (de),a		;4d42
	ld d,c			;4d43
	djnz $+83		;4d44
	ret nc			;4d46
	rst 38h			;4d47
	inc hl			;4d48
	ret p			;4d49
	ret nc			;4d4a
	ret p			;4d4b
	ld d,b			;4d4c
	nop			;4d4d
	nop			;4d4e
	ret po			;4d4f
	ret nc			;4d50
	ret po			;4d51
	ld d,b			;4d52
	nop			;4d53
	nop			;4d54
	ret nc			;4d55
	ret nc			;4d56
	ret nc			;4d57
	ld d,b			;4d58
	nop			;4d59
	nop			;4d5a
	ret nz			;4d5b
	ret nc			;4d5c
	ret nz			;4d5d
	ld d,b			;4d5e
	nop			;4d5f
	nop			;4d60
	or b			;4d61
	ret nc			;4d62
	or b			;4d63
	ld d,b			;4d64
	nop			;4d65
	nop			;4d66
	and b			;4d67
	ret nc			;4d68
	and b			;4d69
	ld d,b			;4d6a
	nop			;4d6b
	nop			;4d6c
	sub b			;4d6d
	ret nc			;4d6e
	sub b			;4d6f
	ld d,b			;4d70
	rst 38h			;4d71
	ld h,0b0h		;4d72
	call nz,0c2b0h		;4d74
	and b			;4d77
	call nz,0c290h		;4d78
	add a,b			;4d7b
	call nz,0c270h		;4d7c
	ld h,b			;4d7f
	jp nz,0b024h		;4d80
	xor d			;4d83
	and b			;4d84
	xor h			;4d85
	sub b			;4d86
	xor d			;4d87
	add a,b			;4d88
	xor e			;4d89
	ld (hl),b		;4d8a
	xor c			;4d8b
	ld h,b			;4d8c
	xor c			;4d8d
	rst 38h			;4d8e
	ld hl,070d0h		;4d8f
	or b			;4d92
	ld (hl),b		;4d93
	cpl			;4d94
	nop			;4d95
	nop			;4d96
	nop			;4d97
	nop			;4d98
	cp 0ffh			;4d99
	adc a,a			;4d9b
	ld c,l			;4d9c
	ld hl,(00000h)		;4d9d
	nop			;4da0
	nop			;4da1
	ld hl,00000h		;4da2
	ret nc			;4da5
	ld (hl),b		;4da6
	or b			;4da7
	ld (hl),b		;4da8
	ld hl,(00000h)		;4da9
	nop			;4dac
	nop			;4dad
	cp 0ffh			;4dae
	and d			;4db0
	ld c,l			;4db1
	ld hl,09018h		;4db2
	nop			;4db5
	and b			;4db6
	ld hl,025b0h		;4db7
	ret nz			;4dba
	ld hl,025d0h		;4dbb
	ret nz			;4dbe
	ld hl,025b0h		;4dbf
	and b			;4dc2
	ld hl,02190h		;4dc3
	add a,b			;4dc6
	ld hl,02170h		;4dc7
	ld h,b			;4dca
	ld hl,022ffh		;4dcb
	ret nz			;4dce
	inc l			;4dcf
	and b			;4dd0
	inc l			;4dd1
	add a,b			;4dd2
	dec hl			;4dd3
	nop			;4dd4
	nop			;4dd5
	add a,b			;4dd6
	dec hl			;4dd7
	rst 38h			;4dd8
	ld hl,080f0h		;4dd9
	pop af			;4ddc
	nop			;4ddd
	jp p,0d100h		;4dde
	add a,b			;4de1
	or c			;4de2
	ld b,b			;4de3
	sub c			;4de4
	jr nz,$+38		;4de5
	jp p,0e100h		;4de7
	nop			;4dea
	call nc,0c100h		;4deb
	nop			;4dee
	or d			;4def
	nop			;4df0
	and c			;4df1
	nop			;4df2
	sub h			;4df3
	nop			;4df4
	add a,c			;4df5
	nop			;4df6
	add a,d			;4df7
	nop			;4df8
	add a,c			;4df9
	nop			;4dfa
	and c			;4dfb
	nop			;4dfc
	sub h			;4dfd
	nop			;4dfe
	add a,c			;4dff
	nop			;4e00
	add a,d			;4e01
	nop			;4e02
	add a,c			;4e03
	nop			;4e04
	add a,h			;4e05
	nop			;4e06
	rst 38h			;4e07
	ld hl,03073h		;4e08
	ld d,e			;4e0b
	ld h,b			;4e0c
	sub e			;4e0d
	ld h,b			;4e0e
	jp nz,0c320h		;4e0f
	ld h,b			;4e12
	jp nz,093d0h		;4e13
	ret nz			;4e16
	and d			;4e17
	ld h,b			;4e18
	sub e			;4e19
	ld h,b			;4e1a
	ld (hl),d		;4e1b
	ret nc			;4e1c
	rst 38h			;4e1d
	ld (0e21eh),hl		;4e1e
	ld b,b			;4e21
	jp po,0c200h		;4e22
	ld h,b			;4e25
	pop hl			;4e26
	jr nz,$+30		;4e27
	jp po,0d170h		;4e29
	nop			;4e2c
	ld e,0d2h		;4e2d
	ret nc			;4e2f
	or c			;4e30
	nop			;4e31
	jp po,0d170h		;4e32
	djnz $+30		;4e35
	pop bc			;4e37
	ld (hl),b		;4e38
	ld hl,0e21ch		;4e39
	ld b,b			;4e3c
	pop bc			;4e3d
	ret nc			;4e3e
	or d			;4e3f
	nop			;4e40
	pop hl			;4e41
	or b			;4e42
	jp nc,0d270h		;4e43
	nop			;4e46
	dec de			;4e47
	jp nz,0a1c0h		;4e48
	nop			;4e4b
	jp nc,0c100h		;4e4c
	and b			;4e4f
	ld e,0b1h		;4e50
	jr nz,$+35		;4e52
	inc e			;4e54
	jp nc,0b120h		;4e55
	and b			;4e58
	and d			;4e59
	nop			;4e5a
	pop de			;4e5b
	djnz $+32		;4e5c
	jp nz,0c170h		;4e5e
	djnz $+30		;4e61
	or d			;4e63
	ret p			;4e64
	sub c			;4e65
	nop			;4e66
	jp nz,0c100h		;4e67
	and b			;4e6a
	jp nz,0ffe0h		;4e6b
	ld hl,0a0d1h		;4e6e
	pop de			;4e71
	and b			;4e72
	ret nz			;4e73
	and b			;4e74
	or b			;4e75
	or b			;4e76
	and b			;4e77
	ret nz			;4e78
	sub b			;4e79
	ret nc			;4e7a
	add a,b			;4e7b
	ret po			;4e7c
	ld (hl),b		;4e7d
	ret p			;4e7e
	rst 38h			;4e7f
	ld hl,02061h		;4e80
	and c			;4e83
	ret nc			;4e84
	pop bc			;4e85
	jr nc,$-77		;4e86
	add a,b			;4e88
	add a,d			;4e89
	nop			;4e8a
	ld h,c			;4e8b
	or b			;4e8c
	nop			;4e8d
	nop			;4e8e
	cp 00ch			;4e8f
	add a,b			;4e91
	ld c,(hl)		;4e92
	rst 38h			;4e93
	ld hl,080e0h		;4e94
	pop hl			;4e97
	nop			;4e98
	pop de			;4e99
	add a,b			;4e9a
	jp nc,0c200h		;4e9b
	add a,b			;4e9e
	jp 0b300h		;4e9f
	nop			;4ea2
	or h			;4ea3
	nop			;4ea4
	and h			;4ea5
	add a,b			;4ea6
	and l			;4ea7
	nop			;4ea8
	sbc a,b			;4ea9
	nop			;4eaa
	sbc a,b			;4eab
	add a,b			;4eac
	xor c			;4ead
	nop			;4eae
	xor c			;4eaf
	add a,b			;4eb0
	sbc a,d			;4eb1
	nop			;4eb2
	sbc a,d			;4eb3
	add a,b			;4eb4
	adc a,e			;4eb5
	nop			;4eb6
	adc a,e			;4eb7
	add a,b			;4eb8
	rst 38h			;4eb9
	jp nc,044fch		;4eba
	pop hl			;4ebd
	nop			;4ebe
	ret nz			;4ebf
	jr nz,$-62		;4ec0
	ld b,b			;4ec2
	ret nz			;4ec3
	ld h,b			;4ec4
	ret nz			;4ec5
	add a,b			;4ec6
	ret nz			;4ec7
	and b			;4ec8
	ret nz			;4ec9
	ret po			;4eca
	nop			;4ecb
	ret nz			;4ecc
	jr nz,$-62		;4ecd
	rst 10h			;4ecf
	call m,0e122h		;4ed0
	nop			;4ed3
	ret nz			;4ed4
	nop			;4ed5
	ld h,0ffh		;4ed6
	jp nc,044fch		;4ed8
	ex (sp),hl		;4edb
	nop			;4edc
	ret nz			;4edd
	jr nz,$-62		;4ede
	ld b,b			;4ee0
	ret nz			;4ee1
	ld h,b			;4ee2
	ret nz			;4ee3
	add a,b			;4ee4
	ret nz			;4ee5
	and b			;4ee6
	ret nz			;4ee7
	jp po,0c000h		;4ee8
	jr nz,$-62		;4eeb
	rst 10h			;4eed
	ei			;4eee
	ld (0c000h),hl		;4eef
	nop			;4ef2
	ex (sp),hl		;4ef3
	or (hl)			;4ef4
	rst 38h			;4ef5
	jp nc,044fch		;4ef6
	pop hl			;4ef9
	rst 8			;4efa
	rst 10h			;4efb
	call m,07022h		;4efc
	ret nz			;4eff
	ld (hl),b		;4f00
	halt			;4f01
	rst 38h			;4f02
	inc hl			;4f03
	ret nc			;4f04
	sbc a,a			;4f05
	ret nc			;4f06
	ld e,b			;4f07
	ret nz			;4f08
	sbc a,a			;4f09
	ret nz			;4f0a
	ld e,b			;4f0b
	or b			;4f0c
	sbc a,a			;4f0d
	or b			;4f0e
	ld e,b			;4f0f
	and b			;4f10
	sbc a,a			;4f11
	and b			;4f12
	ld e,b			;4f13
	sub b			;4f14
	sbc a,a			;4f15
	sub b			;4f16
	ld e,b			;4f17
	add a,b			;4f18
	sbc a,a			;4f19
	add a,b			;4f1a
	ld e,b			;4f1b
	rst 38h			;4f1c
	ld hl,0a0f0h		;4f1d
	or b			;4f20
	and b			;4f21
	nop			;4f22
	nop			;4f23
	ret po			;4f24
	ld (hl),b		;4f25
	and b			;4f26
	ld (hl),b		;4f27
	inc hl			;4f28
	nop			;4f29
	nop			;4f2a
	ld hl,052d0h		;4f2b
	and b			;4f2e
	ld d,d			;4f2f
	nop			;4f30
	nop			;4f31
	or b			;4f32
	ld d,d			;4f33
	sub b			;4f34
	ld d,d			;4f35
	rst 38h			;4f36
	ld (040e0h),hl		;4f37
	nop			;4f3a
	nop			;4f3b
	and b			;4f3c
	ld b,c			;4f3d
	rst 38h			;4f3e
	ld (080d0h),hl		;4f3f
	ret nz			;4f42
	ld (hl),b		;4f43
	or b			;4f44
	ld b,b			;4f45
	and b			;4f46
	ld (hl),b		;4f47
	rst 38h			;4f48
	ld (090d0h),hl		;4f49
	ret po			;4f4c
	sub d			;4f4d
	ret nc			;4f4e
	sub b			;4f4f
	or b			;4f50
	sub d			;4f51
	ret nz			;4f52
	sub b			;4f53
	and b			;4f54
	sub d			;4f55
	ret nz			;4f56
	ld h,b			;4f57
	and b			;4f58
	ld h,d			;4f59
	or b			;4f5a
	ld h,b			;4f5b
	sub b			;4f5c
	ld h,d			;4f5d
	add a,b			;4f5e
	ld h,b			;4f5f
	rst 38h			;4f60
	inc h			;4f61
	ret nc			;4f62
	and b			;4f63
	ret nz			;4f64
	sbc a,a			;4f65
	or b			;4f66
	sbc a,h			;4f67
	and b			;4f68
	sub a			;4f69
	sub b			;4f6a
	sub b			;4f6b
	add a,b			;4f6c
	add a,a			;4f6d
	ld (hl),b		;4f6e
	add a,b			;4f6f
	ld (hl),b		;4f70
	ld (hl),a		;4f71
	rst 38h			;4f72
	ld hl,040d0h		;4f73
	or b			;4f76
	ld d,b			;4f77
	ret nz			;4f78
	ld d,b			;4f79
	and b			;4f7a
	ld d,b			;4f7b
	add a,b			;4f7c
	ld d,b			;4f7d
	rst 38h			;4f7e
	ret pe			;4f7f
	call nc,031fdh		;4f80
	jp po,0e190h		;4f83
	jr nc,$+114		;4f86
	sub b			;4f88
	ret po			;4f89
	jr nc,$+114		;4f8a
	jp po,0e1a0h		;4f8c
	ld d,b			;4f8f
	sub b			;4f90
	and b			;4f91
	ret po			;4f92
	ld d,b			;4f93
	sub b			;4f94
	out (0e1h),a		;4f95
	nop			;4f97
	ld (hl),b		;4f98
	or b			;4f99
	ret po			;4f9a
	nop			;4f9b
	ld (hl),b		;4f9c
	or b			;4f9d
	pop bc			;4f9e
	call nc,011fah		;4f9f
	or b			;4fa2
	pop bc			;4fa3
	rst 30h			;4fa4
	ld de,0c1b0h		;4fa5
	call p,0b011h		;4fa8
	rst 38h			;4fab
	ld (0f010h),hl		;4fac
	jr nc,$-30		;4faf
	ld l,0d0h		;4fb1
	inc l			;4fb3
	ret nz			;4fb4
	ld hl,(002feh)		;4fb5
	xor h			;4fb8
	ld c,a			;4fb9
	ret po			;4fba
	jr nc,$-46		;4fbb
	ld l,0c0h		;4fbd
	inc l			;4fbf
	or b			;4fc0
	ld hl,(002feh)		;4fc1
	cp d			;4fc4
	ld c,a			;4fc5
	ret nz			;4fc6
	jr nc,$-78		;4fc7
	ld l,0a0h		;4fc9
	inc l			;4fcb
	sub b			;4fcc
	ld hl,(002feh)		;4fcd
	add a,04fh		;4fd0
	or b			;4fd2
	jr nc,$-94		;4fd3
	ld l,090h		;4fd5
	inc l			;4fd7
	add a,b			;4fd8
	ld hl,(0d8ffh)		;4fd9
	call m,0c121h		;4fdc
	ex (sp),hl		;4fdf
	ld (hl),b		;4fe0
	ld b,b			;4fe1
	djnz $-26		;4fe2
	and b			;4fe4
	cp 004h			;4fe5
	rst 18h			;4fe7
	ld c,a			;4fe8
	ld h,b			;4fe9
	jr nc,$+2		;4fea
	call po,0fe90h		;4fec
	inc b			;4fef
	jp (hl)			;4ff0
	ld c,a			;4ff1
	call po,0e3a0h		;4ff2
	djnz $+66		;4ff5
	ld (hl),b		;4ff7
	ld b,b			;4ff8
	ld (hl),b		;4ff9
	and b			;4ffa
	ld (hl),b		;4ffb
	jr nc,$+98		;4ffc
	sub b			;4ffe
	jp po,0e300h		;4fff
	sub b			;5002
	jp po,03000h		;5003
	nop			;5006
	cp 002h			;5007
	jp p,0fe4fh		;5009
	rst 38h			;500c
	rst 18h			;500d
	ld c,a			;500e
	jp c,011fdh		;500f
	ex (sp),hl		;5012
	ret nz			;5013
	dec bc			;5014
	dec de			;5015
	dec sp			;5016
	call po,0e3bbh		;5017
	dec de			;501a
	ld c,e			;501b
	dec de			;501c
	cp 0ffh			;501d
	inc d			;501f
	ld d,b			;5020
	jp nc,011fah		;5021
	jp po,070c4h		;5024
	ret nz			;5027
	ld (hl),b		;5028
	ret nz			;5029
	ld (hl),b		;502a
	ret nz			;502b
	ld (hl),b		;502c
	ret nz			;502d
	ld (hl),b		;502e
	ret nz			;502f
	pop hl			;5030
	nop			;5031
	ret nz			;5032
	nop			;5033
	ret nz			;5034
	nop			;5035
	ret nz			;5036
	nop			;5037
	ret nz			;5038
	nop			;5039
	ret nz			;503a
	jp po,0c0b0h		;503b
	or b			;503e
	ret nz			;503f
	or b			;5040
	ret nz			;5041
	or b			;5042
	ret nz			;5043
	or b			;5044
	ret nz			;5045
	cp 00ah			;5046
	ld h,050h		;5048
	jp po,0c070h		;504a
	ld (hl),b		;504d
	ret nz			;504e
	ld (hl),b		;504f
	ret nz			;5050
	ld (hl),b		;5051
	ret nz			;5052
	ld (hl),b		;5053
	ret nz			;5054
	pop hl			;5055
	djnz $-62		;5056
	djnz $-62		;5058
	djnz $-62		;505a
	djnz $-62		;505c
	djnz $-62		;505e
	jp po,0c0a0h		;5060
	and b			;5063
	ret nz			;5064
	and b			;5065
	ret nz			;5066
	and b			;5067
	ret nz			;5068
	and b			;5069
	ret nz			;506a
	cp 004h			;506b
	ld c,d			;506d
	ld d,b			;506e
	cp 0ffh			;506f
	ld h,050h		;5071
	rst 10h			;5073
	ei			;5074
	inc hl			;5075
	pop hl			;5076
	nop			;5077
	jr nz,$+50		;5078
	ld (hl),b		;507a
	ret po			;507b
	ld bc,071e1h		;507c
	ld h,e			;507f
	pop bc			;5080
	ld h,c			;5081
	ld d,e			;5082
	pop bc			;5083
	ld sp,0c003h		;5084
	jp po,0a0b0h		;5087
	or b			;508a
	pop hl			;508b
	nop			;508c
	jr nz,$+50		;508d
	ld (hl),b		;508f
	ret po			;5090
	ld bc,071e1h		;5091
	ld h,e			;5094
	pop bc			;5095
	ld h,c			;5096
	ld d,e			;5097
	ld (hl),b		;5098
	ld d,b			;5099
	jr nc,$+18		;509a
	dec b			;509c
	pop bc			;509d
	jr nc,$+114		;509e
	cp 004h			;50a0
	sbc a,(hl)		;50a2
	ld d,b			;50a3
	ld h,b			;50a4
	sub b			;50a5
	cp 004h			;50a6
	and h			;50a8
	ld d,b			;50a9
	ld d,b			;50aa
	add a,b			;50ab
	cp 003h			;50ac
	xor d			;50ae
	ld d,b			;50af
	ret po			;50b0
	djnz $+82		;50b1
	ld sp,0e100h		;50b3
	ld (hl),d		;50b6
	pop bc			;50b7
	jr nc,$+114		;50b8
	cp 004h			;50ba
	cp b			;50bc
	ld d,b			;50bd
	ld h,b			;50be
	sub b			;50bf
	cp 004h			;50c0
	cp (hl)			;50c2
	ld d,b			;50c3
	ld d,b			;50c4
	add a,b			;50c5
	cp 003h			;50c6
	call nz,0e050h		;50c8
	djnz $+82		;50cb
	jr nc,$+2		;50cd
	pop hl			;50cf
	or b			;50d0
	add a,b			;50d1
	ld (hl),b		;50d2
	ld d,b			;50d3
	jr nc,$+34		;50d4
	cp 0ffh			;50d6
	ld (hl),e		;50d8
	ld d,b			;50d9
	rst 38h			;50da
	rst 10h			;50db
	ei			;50dc
	inc hl			;50dd
	jp po,03000h		;50de
	ex (sp),hl		;50e1
	ld (hl),b		;50e2
	jp po,0fe30h		;50e3
	ld (bc),a		;50e6
	rst 18h			;50e7
	ld d,b			;50e8
	jr nz,$+98		;50e9
	ex (sp),hl		;50eb
	sub b			;50ec
	jp po,0fe60h		;50ed
	ld (bc),a		;50f0
	jp (hl)			;50f1
	ld d,b			;50f2
	djnz $+82		;50f3
	ex (sp),hl		;50f5
	add a,b			;50f6
	jp po,0fe50h		;50f7
	ld (bc),a		;50fa
	di			;50fb
	ld d,b			;50fc
	nop			;50fd
	jr nc,$-27		;50fe
	ld (hl),b		;5100
	jp po,00030h		;5101
	ex (sp),hl		;5104
	or b			;5105
	and b			;5106
	or b			;5107
	jp po,03000h		;5108
	ex (sp),hl		;510b
	ld (hl),b		;510c
	jp po,0fe30h		;510d
	ld (bc),a		;5110
	ex af,af'		;5111
	ld d,c			;5112
	jp po,06020h		;5113
	ex (sp),hl		;5116
	sub b			;5117
	jp po,0fe60h		;5118
	ld (bc),a		;511b
	inc de			;511c
	ld d,c			;511d
	jp po,05020h		;511e
	ex (sp),hl		;5121
	add a,b			;5122
	jp po,0fe50h		;5123
	ld (bc),a		;5126
	ld e,051h		;5127
	nop			;5129
	jr nc,$-27		;512a
	ld (hl),b		;512c
	jp po,0fe30h		;512d
	inc bc			;5130
	add hl,hl		;5131
	ld d,c			;5132
	nop			;5133
	ex (sp),hl		;5134
	or b			;5135
	jp po,01000h		;5136
	jr nz,$+98		;5139
	ex (sp),hl		;513b
	sub b			;513c
	jp po,0fe60h		;513d
	ld (bc),a		;5140
	add hl,sp		;5141
	ld d,c			;5142
	djnz $+82		;5143
	ex (sp),hl		;5145
	add a,b			;5146
	jp po,0fe50h		;5147
	ld (bc),a		;514a
	ld b,e			;514b
	ld d,c			;514c
	nop			;514d
	pop hl			;514e
	nop			;514f
	jp po,080b0h		;5150
	ld (hl),b		;5153
	ld d,b			;5154
	jr nc,$+34		;5155
	cp 0ffh			;5157
	in a,(050h)		;5159
	rst 38h			;515b
	out (0fbh),a		;515c
	ld hl,071e2h		;515e
	or c			;5161
	ld d,c			;5162
	sub c			;5163
	ld b,c			;5164
	ld (hl),c		;5165
	ld hl,0fa01h		;5166
	ld de,070e3h		;5169
	ld sp,hl		;516c
	ld de,0f850h		;516d
	ld de,02040h		;5170
	ld bc,0d3ffh		;5173
	ei			;5176
	ld hl,071e3h		;5177
	or c			;517a
	ld d,c			;517b
	sub c			;517c
	ld b,c			;517d
	ld (hl),c		;517e
	ld hl,0fa01h		;517f
	ld de,070e2h		;5182
	ld sp,hl		;5185
	ld de,0f850h		;5186
	ld de,02040h		;5189
	nop			;518c
	rst 38h			;518d
	sub 0fbh		;518e
	inc sp			;5190
	pop hl			;5191
	ld sp,0c000h		;5192
	call po,00000h		;5195
	nop			;5198
	nop			;5199
	ex (sp),hl		;519a
	ld sp,03030h		;519b
	jp po,07050h		;519e
	add a,b			;51a1
	and b			;51a2
	pop hl			;51a3
	ld bc,080e2h		;51a4
	pop hl			;51a7
	nop			;51a8
	jp po,03020h		;51a9
	ld d,b			;51ac
	jr nc,$+35		;51ad
	ex (sp),hl		;51af
	and b			;51b0
	jp po,05020h		;51b1
	jr nz,$-94		;51b4
	ld d,b			;51b6
	pop hl			;51b7
	inc b			;51b8
	ret nz			;51b9
	jr nz,$+50		;51ba
	ld hl,0c002h		;51bc
	jp po,0a070h		;51bf
	pop hl			;51c2
	ld (bc),a		;51c3
	jr nz,$+50		;51c4
	ld d,b			;51c6
	ld (hl),b		;51c7
	ld d,b			;51c8
	jr nc,$+34		;51c9
	inc bc			;51cb
	jp po,0a070h		;51cc
	cp 002h			;51cf
	adc a,(hl)		;51d1
	ld d,c			;51d2
	push af			;51d3
	nop			;51d4
	pop hl			;51d5
	nop			;51d6
	or 000h			;51d7
	nop			;51d9
	rst 30h			;51da
	nop			;51db
	nop			;51dc
	ret m			;51dd
	nop			;51de
	nop			;51df
	ld sp,hl		;51e0
	nop			;51e1
	nop			;51e2
	jp m,00000h		;51e3
	ei			;51e6
	nop			;51e7
	nop			;51e8
	call m,00010h		;51e9
	pop bc			;51ec
	ld sp,hl		;51ed
	djnz $+2		;51ee
	pop bc			;51f0
	rst 30h			;51f1
	djnz $+2		;51f2
	pop bc			;51f4
	call m,03010h		;51f5
	nop			;51f8
	ret nz			;51f9
	ld sp,hl		;51fa
	jr nz,$+50		;51fb
	nop			;51fd
	ret m			;51fe
	jr nz,$+50		;51ff
	nop			;5201
	ret nz			;5202
	cp 002h			;5203
	push af			;5205
	ld d,c			;5206
	call m,07012h		;5207
	ld d,b			;520a
	jr nc,$-62		;520b
	jp m,07022h		;520d
	ld d,b			;5210
	jr nc,$+34		;5211
	call m,08012h		;5213
	ld (hl),b		;5216
	ld d,b			;5217
	ret nz			;5218
	jp m,08022h		;5219
	ld (hl),b		;521c
	ld d,b			;521d
	and b			;521e
	pop de			;521f
	jp m,0c100h		;5220
	add a,b			;5223
	sub b			;5224
	and b			;5225
	or b			;5226
	exx			;5227
	call m,0e033h		;5228
	add hl,bc		;522b
	cp 0ffh			;522c
	adc a,(hl)		;522e
	ld d,c			;522f
	rst 38h			;5230
	sub 0fdh		;5231
	inc (hl)		;5233
	ex (sp),hl		;5234
	ld bc,00000h		;5235
	ld bc,00000h		;5238
	ld bc,00000h		;523b
	ld bc,00000h		;523e
	call po,08081h		;5241
	add a,b			;5244
	add a,c			;5245
	add a,b			;5246
	add a,b			;5247
	and c			;5248
	and b			;5249
	and b			;524a
	and c			;524b
	and b			;524c
	and b			;524d
	ex (sp),hl		;524e
	ld bc,00000h		;524f
	ld bc,00000h		;5252
	ld bc,00000h		;5255
	ld bc,00000h		;5258
	ld sp,03030h		;525b
	ld sp,03030h		;525e
	call po,0a0a1h		;5261
	and b			;5264
	and c			;5265
	and b			;5266
	and b			;5267
	cp 0ffh			;5268
	ld sp,0ff52h		;526a
	exx			;526d
	call m,0e132h		;526e
	ld b,e			;5271
	nop			;5272
	ld b,b			;5273
	ld (hl),e		;5274
	ld d,b			;5275
	ld b,b			;5276
	ld d,d			;5277
	jp m,00221h		;5278
	ld (bc),a		;527b
	jp c,023fch		;527c
	jp po,050a0h		;527f
	jr nz,$-28		;5282
	ld b,a			;5284
	rst 38h			;5285
	exx			;5286
	ei			;5287
	inc h			;5288
	jp po,07073h		;5289
	ld (hl),b		;528c
	and e			;528d
	and b			;528e
	and b			;528f
	sub d			;5290
	ld d,d			;5291
	ld (050dah),a		;5292
	jr nz,$-62		;5295
	ex (sp),hl		;5297
	rlca			;5298
	rst 38h			;5299
	exx			;529a
	defb 0fdh,032h,0e3h ;illegal sequence	;529b
	nop			;529e
	nop			;529f
	nop			;52a0
	ei			;52a1
	inc h			;52a2
	jp po,0fd02h		;52a3
	ld (0a0e4h),a		;52a6
	and b			;52a9
	and b			;52aa
	ei			;52ab
	inc h			;52ac
	ex (sp),hl		;52ad
	and d			;52ae
	defb 0fdh,032h,0e4h ;illegal sequence	;52af
	sub b			;52b2
	sub b			;52b3
	sub b			;52b4
	ei			;52b5
	inc hl			;52b6
	ex (sp),hl		;52b7
	sub d			;52b8
	add a,d			;52b9
	jp c,0fba2h		;52ba
	inc (hl)		;52bd
	ex (sp),hl		;52be
	ld (hl),a		;52bf
	rst 38h			;52c0
	call nc,023fbh		;52c1
	pop hl			;52c4
	ld b,c			;52c5
	pop bc			;52c6
	jp po,0e191h		;52c7
	ld c,c			;52ca
	ld de,0e211h		;52cb
	or c			;52ce
	sub c			;52cf
	pop hl			;52d0
	ld b,c			;52d1
	ld b,c			;52d2
	jp po,0e191h		;52d3
	ld b,l			;52d6
	jp po,0b393h		;52d7
	pop hl			;52da
	inc de			;52db
	ld b,c			;52dc
	pop bc			;52dd
	ld b,c			;52de
	sub l			;52df
	ld (hl),l		;52e0
	ld hl,02121h		;52e1
	ld c,a			;52e4
	rst 38h			;52e5
	rst 38h			;52e6
	call nc,023fbh		;52e7
	jp po,0c191h		;52ea
	ld b,c			;52ed
	sbc a,c			;52ee
	ld b,c			;52ef
	ld b,l			;52f0
	sub c			;52f1
	sub c			;52f2
	ld b,c			;52f3
	sub l			;52f4
	inc de			;52f5
	ld b,e			;52f6
	sub e			;52f7
	sub c			;52f8
	pop bc			;52f9
	sub c			;52fa
	pop hl			;52fb
	ld b,l			;52fc
	dec b			;52fd
	jp po,09191h		;52fe
	sub c			;5301
	adc a,a			;5302
	rst 38h			;5303
	call nc,023fch		;5304
	call po,0e393h		;5307
	ld b,c			;530a
	sub c			;530b
	ld b,c			;530c
	sub c			;530d
	cp 002h			;530e
	rlca			;5310
	ld d,e			;5311
	call po,0e373h		;5312
	ld b,c			;5315
	sub c			;5316
	ld b,c			;5317
	sub c			;5318
	cp 002h			;5319
	ld (de),a		;531b
	ld d,e			;531c
	call po,0e353h		;531d
	ld bc,00151h		;5320
	ld d,c			;5323
	cp 002h			;5324
	dec e			;5326
	ld d,e			;5327
	call po,0c54fh		;5328
	rst 38h			;532b
	jp c,033fch		;532c
	pop hl			;532f
	jp 0e212h		;5330
	sub l			;5333
	sub b			;5334
	pop hl			;5335
	jr nz,$+18		;5336
	ld (de),a		;5338
	jp po,05093h		;5339
	ld (hl),b		;533c
	sub b			;533d
	or b			;533e
	pop hl			;533f
	jr nz,$+68		;5340
	jp po,0e170h		;5342
	nop			;5345
	ld b,b			;5346
	ld (072e2h),hl		;5347
	pop hl			;534a
	ld b,d			;534b
	ld (hl),b		;534c
	ld d,b			;534d
	ld b,b			;534e
	ld (09072h),hl		;534f
	sub b			;5352
	sub b			;5353
	sub b			;5354
	ld d,b			;5355
	sub b			;5356
	or b			;5357
	or b			;5358
	or b			;5359
	ld (hl),b		;535a
	sub b			;535b
	or b			;535c
	sbc a,d			;535d
	rst 38h			;535e
	ret pe			;535f
	jp c,033fch		;5360
	pop hl			;5363
	jp 0e212h		;5364
	sub d			;5367
	ld d,l			;5368
	sub d			;5369
	ld b,d			;536a
	ld (0b090h),hl		;536b
	pop hl			;536e
	jr nz,$+68		;536f
	jp po,0e170h		;5371
	nop			;5374
	ld b,b			;5375
	ld (072e2h),hl		;5376
	ld (bc),a		;5379
	ld b,b			;537a
	jr nz,$+2		;537b
	ex (sp),hl		;537d
	or d			;537e
	jp po,05022h		;537f
	nop			;5382
	ld d,b			;5383
	ld d,b			;5384
	nop			;5385
	ld d,b			;5386
	ld (hl),b		;5387
	jr nz,$+114		;5388
	ld sp,hl		;538a
	inc bc			;538b
	jp po,09070h		;538c
	or b			;538f
	pop hl			;5390
	djnz $-28		;5391
	sub b			;5393
	jr nz,$+25		;5394
	rst 38h			;5396
	jp c,015fch		;5397
	call po,092c3h		;539a
	sub b			;539d
	ex (sp),hl		;539e
	ld b,b			;539f
	sub b			;53a0
	call po,09092h		;53a1
	sub b			;53a4
	sub b			;53a5
	sub d			;53a6
	sub b			;53a7
	ex (sp),hl		;53a8
	ld b,b			;53a9
	sub b			;53aa
	ld d,b			;53ab
	jr nz,$+66		;53ac
	ld d,b			;53ae
	ld (hl),b		;53af
	or b			;53b0
	ld (bc),a		;53b1
	nop			;53b2
	nop			;53b3
	nop			;53b4
	call po,07072h		;53b5
	ex (sp),hl		;53b8
	jr nz,$+114		;53b9
	ld (bc),a		;53bb
	ld (bc),a		;53bc
	call po,07272h		;53bd
	ld d,b			;53c0
	ld d,b			;53c1
	ex (sp),hl		;53c2
	nop			;53c3
	ld d,d			;53c4
	call po,07070h		;53c5
	ex (sp),hl		;53c8
	jr nz,$+116		;53c9
	call po,09090h		;53cb
	ex (sp),hl		;53ce
	ld b,b			;53cf
	sub a			;53d0
	rst 38h			;53d1
	rst 38h			;53d2
	ld a,(0e092h)		;53d3
	cp 009h			;53d6
	jr z,$+6		;53d8
	xor a			;53da
	ld (0e3b0h),a		;53db
	ld a,(0e3b0h)		;53de
	or a			;53e1
	jr z,$+7		;53e2
	call 0569dh		;53e4
	jr $+5			;53e7
	call 0568ch		;53e9
	ld hl,0e609h		;53ec
	ld de,0e080h		;53ef
	ld bc,00007h		;53f2
	ldir			;53f5
	ld hl,0e600h		;53f7
	ld de,0e601h		;53fa
	ld bc,0014fh		;53fd
	ld (hl),000h		;5400
	ldir			;5402
	ld hl,0e600h		;5404
	ld de,0e4f0h		;5407
	ld bc,00080h		;540a
	ldir			;540d
	ld a,(0e062h)		;540f
	cp 005h			;5412
	jr nz,$+7		;5414
	ld a,080h		;5416
	ld (0e3f0h),a		;5418
	ld a,(0e062h)		;541b
	sub 006h		;541e
	jr nz,$+5		;5420
	ld (0e3d0h),a		;5422
	xor a			;5425
	ld (0e590h),a		;5426
	ld (0e5b0h),a		;5429
	ld (0e5d0h),a		;542c
	ld hl,0e073h		;542f
	ld a,(hl)		;5432
	or a			;5433
	jr nz,$+48		;5434
	ld (0e092h),a		;5436
	ld (0e09fh),a		;5439
	inc (hl)		;543c
	ld hl,099cdh		;543d
	ld a,(0e062h)		;5440
	add a,a			;5443
	call 04071h		;5444
	ld (0e093h),de		;5447
	inc hl			;544b
	ld e,(hl)		;544c
	inc hl			;544d
	ld d,(hl)		;544e
	ld (0e095h),de		;544f
	ld a,(0e062h)		;5453
	ld (0e065h),a		;5456
	ld hl,0e080h		;5459
	ld de,0e609h		;545c
	ld bc,00007h		;545f
	ldir			;5462
	ld ix,0e600h		;5464
	ld (ix+002h),087h	;5468
	ld (ix+004h),078h	;546c
	ld hl,0e620h		;5470
	ld bc,00400h		;5473
	ld a,080h		;5476
	or c			;5478
	ld (hl),a		;5479
	ld de,00010h		;547a
	add hl,de		;547d
	inc c			;547e
	djnz $-9		;547f
	ld hl,0e0a0h		;5481
	ld de,0e0a1h		;5484
	ld bc,00220h		;5487
	xor a			;548a
	ld (hl),a		;548b
	ldir			;548c
	ld (0e09eh),a		;548e
	ld a,(0e062h)		;5491
	ld hl,0704bh		;5494
	call 04071h		;5497
	ld hl,0e09fh		;549a
	dec (hl)		;549d
	dec (hl)		;549e
	ld a,(hl)		;549f
	cp 0feh			;54a0
	jr c,$+6		;54a2
	xor a			;54a4
	ld (hl),a		;54a5
	jr $+15			;54a6
	add a,a			;54a8
	push de			;54a9
	call 04060h		;54aa
	inc de			;54ad
	ld a,(de)		;54ae
	pop de			;54af
	and 00fh		;54b0
	jr nz,$-20		;54b2
	inc (hl)		;54b4
	call 07613h		;54b5
	call 066a3h		;54b8
	ld de,0a71eh		;54bb
	call 0440ch		;54be
	ld ix,0ee20h		;54c1
	ld hl,05615h		;54c5
	ld b,002h		;54c8
	push bc			;54ca
	ld e,(hl)		;54cb
	inc hl			;54cc
	ld d,(hl)		;54cd
	inc hl			;54ce
	push hl			;54cf
	push ix			;54d0
	pop hl			;54d2
	push hl			;54d3
	ld bc,00010h		;54d4
	add hl,bc		;54d7
	call 05638h		;54d8
	pop de			;54db
	ld hl,00020h		;54dc
	add hl,de		;54df
	ld bc,00010h		;54e0
	ldir			;54e3
	pop hl			;54e5
	ld de,00020h		;54e6
	add ix,de		;54e9
	pop bc			;54eb
	djnz $-34		;54ec
	ld a,(0e3b0h)		;54ee
	or a			;54f1
	jr z,$+6		;54f2
	call 056b2h		;54f4
	dec (hl)		;54f7
	ld a,(0e062h)		;54f8
	add a,a			;54fb
	ld hl,0563ch		;54fc
	call 04071h		;54ff
	inc hl			;5502
	push hl			;5503
	ld hl,02280h		;5504
	call 043d1h		;5507
	ld hl,02580h		;550a
	call 043e1h		;550d
	pop hl			;5510
	ld e,(hl)		;5511
	inc hl			;5512
	ld d,(hl)		;5513
	ld a,(0e062h)		;5514
	ld h,001h		;5517
	cp 003h			;5519
	jr z,$+8		;551b
	ld h,002h		;551d
	cp 007h			;551f
	jr nz,$+6		;5521
	ld a,h			;5523
	ld (0e661h),a		;5524
	ld hl,00280h		;5527
	call 043d1h		;552a
	ld hl,00580h		;552d
	call 043d1h		;5530
	xor a			;5533
	ld (0e661h),a		;5534
	ld a,(0e062h)		;5537
	cp 007h			;553a
	jr nz,$+32		;553c
	ld de,0be41h		;553e
	ld hl,02470h		;5541
	call 043d1h		;5544
	ld hl,02770h		;5547
	call 043e1h		;554a
	ld de,0beb7h		;554d
	ld hl,00470h		;5550
	call 043d1h		;5553
	ld hl,00770h		;5556
	call 043d1h		;5559
	xor a			;555c
	ld (0e090h),a		;555d
	ld (0e09ah),a		;5560
	ld a,(0e092h)		;5563
	add a,a			;5566
	ld e,a			;5567
	add a,a			;5568
	ld d,a			;5569
	add a,a			;556a
	ld b,a			;556b
	add a,a			;556c
	add a,b			;556d
	ld (0e091h),a		;556e
	ld a,d			;5571
	add a,e			;5572
	ld e,a			;5573
	ld d,000h		;5574
	ld hl,(0e095h)		;5576
	or a			;5579
	sbc hl,de		;557a
	ld (0e088h),hl		;557c
	ld a,(0e092h)		;557f
	ld hl,(0e093h)		;5582
	call 04079h		;5585
	ld (0e097h),hl		;5588
	ld (0e09ch),hl		;558b
	xor a			;558e
	push af			;558f
	call 06502h		;5590
	pop af			;5593
	inc a			;5594
	cp 007h			;5595
	jr c,$-8		;5597
	ld a,(0e3b0h)		;5599
	or a			;559c
	call nz,08d87h		;559d
	call 055edh		;55a0
	ld hl,06a98h		;55a3
	ld a,(0e062h)		;55a6
	add a,a			;55a9
	add a,a			;55aa
	ld b,a			;55ab
	add a,a			;55ac
	add a,b			;55ad
	call 04072h		;55ae
	inc hl			;55b1
	push hl			;55b2
	ld a,(0e092h)		;55b3
	call 05607h		;55b6
	ld (0e570h),hl		;55b9
	pop hl			;55bc
	ld a,(0e092h)		;55bd
	dec a			;55c0
	jp m,055eah		;55c1
	cp 008h			;55c4
	jr z,$+36		;55c6
	call 05607h		;55c8
	push hl			;55cb
	pop iy			;55cc
	sub c			;55ce
	ld b,a			;55cf
	ld ix,0e4f0h		;55d0
	call 06a1eh		;55d4
	ld a,(0e091h)		;55d7
	sub (iy-002h)		;55da
	add a,a			;55dd
	add a,a			;55de
	add a,a			;55df
	ld (ix+002h),a		;55e0
	ld de,00010h		;55e3
	add ix,de		;55e6
	djnz $-20		;55e8
	jp 064a3h		;55ea
	ld hl,(0e088h)		;55ed
	dec hl			;55f0
	ld a,(hl)		;55f1
	ld (0e088h),hl		;55f2
	ld b,008h		;55f5
	ld hl,(0e097h)		;55f7
	rla			;55fa
	jr nc,$+3		;55fb
	dec hl			;55fd
	djnz $-4		;55fe
	ld (0e097h),hl		;5600
	ld (0e09ch),hl		;5603
	ret			;5606
	call 0405bh		;5607
	ld a,(hl)		;560a
	ex af,af'		;560b
	ld l,(hl)		;560c
	ld h,000h		;560d
	ld b,h			;560f
	ld c,l			;5610
	add hl,hl		;5611
	add hl,bc		;5612
	add hl,de		;5613
	ret			;5614
	ld b,b			;5615
	and (hl)		;5616
	ld e,l			;5617
	and (hl)		;5618
	ld c,000h		;5619
	ld a,(de)		;561b
	inc de			;561c
	and a			;561d
	ret z			;561e
	ld b,a			;561f
	and 07fh		;5620
	cp b			;5622
	ld b,a			;5623
	jr z,$+11		;5624
	call 0443bh		;5626
	ld (hl),a		;5629
	inc hl			;562a
	djnz $-5		;562b
	jr $-18			;562d
	call 0443bh		;562f
	ld (hl),a		;5632
	inc hl			;5633
	djnz $-2		;5634
	jr $-27			;5636
	ld c,001h		;5638
	jr $-31			;563a
	rla			;563c
	or e			;563d
	ret nc			;563e
	or h			;563f
	ld (hl),b		;5640
	or l			;5641
	ld b,a			;5642
	or (hl)			;5643
	xor (hl)		;5644
	or (hl)			;5645
	cp 0b7h			;5646
	rla			;5648
	or e			;5649
	ret nc			;564a
	or h			;564b
	ld (hl),c		;564c
	cp b			;564d
	ld e,e			;564e
	cp d			;564f
	ei			;5650
	cp d			;5651
	ld e,l			;5652
	cp l			;5653
	ei			;5654
	cp d			;5655
	ld e,l			;5656
	cp l			;5657
	rla			;5658
	or e			;5659
	ret nc			;565a
	or h			;565b
	ld de,0b17bh		;565c
	ld hl,02138h		;565f
	call 043d1h		;5662
	ld hl,02438h		;5665
	call 043e1h		;5668
	ld de,0b285h		;566b
	ld hl,00138h		;566e
	call 043d1h		;5671
	ld hl,00438h		;5674
	call 043d1h		;5677
	ld de,0b2fbh		;567a
	ld hl,02500h		;567d
	call 043d1h		;5680
	ld de,0b314h		;5683
	ld hl,00500h		;5686
	jp 043d1h		;5689
	xor a			;568c
	ld (0e667h),a		;568d
	ld hl,056a2h		;5690
	ld a,(0e062h)		;5693
	call 0405bh		;5696
	ld a,(hl)		;5699
	jp 04901h		;569a
	ld hl,056aah		;569d
	jr $-13			;56a0
	sbc a,l			;56a2
	sbc a,a			;56a3
	sbc a,l			;56a4
	sbc a,l			;56a5
	sbc a,a			;56a6
	sbc a,l			;56a7
	sbc a,l			;56a8
	sbc a,a			;56a9
	and e			;56aa
	and c			;56ab
	and e			;56ac
	and e			;56ad
	and e			;56ae
	and c			;56af
	and e			;56b0
	and e			;56b1
	ld a,(0e065h)		;56b2
	call 0406ch		;56b5
	and 08ah		;56b8
	ld d,a			;56ba
	adc a,(hl)		;56bb
	cp a			;56bc
	sub b			;56bd
	inc h			;56be
	sub d			;56bf
	and 08ah		;56c0
	and 08ah		;56c2
	dec (hl)		;56c4
	sub h			;56c5
	ld b,l			;56c6
	sub (hl)		;56c7
	ld hl,0e061h		;56c8
	ld a,(hl)		;56cb
	sub 001h		;56cc
	daa			;56ce
	inc hl			;56cf
	ld (hl),a		;56d0
	ret			;56d1
	ld a,(0e002h)		;56d2
	bit 6,a			;56d5
	jp z,05780h		;56d7
	ld a,(0e3b0h)		;56da
	or a			;56dd
	jp nz,05780h		;56de
	ld a,(0e600h)		;56e1
	or a			;56e4
	jp nz,05780h		;56e5
	ld a,006h		;56e8
	call 00141h		;56ea
	ld hl,0e06bh		;56ed
	cpl			;56f0
	ld c,(hl)		;56f1
	ld (hl),a		;56f2
	xor c			;56f3
	and (hl)		;56f4
	ld c,a			;56f5
	dec hl			;56f6
	ld a,(hl)		;56f7
	or a			;56f8
	jr z,$+55		;56f9
	bit 5,c			;56fb
	jp z,05908h		;56fd
	ld (hl),000h		;5700
	ld a,(0e618h)		;5702
	ld (0e60ch),a		;5705
	ld a,03ch		;5708
	ld (0e06ch),a		;570a
	ld hl,01d00h		;570d
	ld de,0ee60h		;5710
	ld bc,00100h		;5713
	call 043bch		;5716
	ld hl,03b00h		;5719
	ld bc,00080h		;571c
	ld a,0c3h		;571f
	call 00056h		;5721
	ld a,0a8h		;5724
	call 04901h		;5726
	ld ix,0e600h		;5729
	jp 05dffh		;572d
	bit 5,c			;5730
	jr z,$+78		;5732
	ld a,001h		;5734
	ld (hl),a		;5736
	ld (0e667h),a		;5737
	ld a,(0e60ch)		;573a
	ld (0e618h),a		;573d
	ld hl,00258h		;5740
	ld (0e06ch),hl		;5743
	ld a,058h		;5746
	ld (0e003h),a		;5748
	ld hl,03b24h		;574b
	ld a,0c3h		;574e
	call 0004dh		;5750
	ld hl,03b28h		;5753
	ld a,0d0h		;5756
	call 0004dh		;5758
	ld hl,01d00h		;575b
	ld de,0ee60h		;575e
	ld bc,00100h		;5761
	call 00059h		;5764
	ld de,059edh		;5767
	call 0440ch		;576a
	ld hl,01d00h		;576d
	ld de,01d90h		;5770
	ld c,004h		;5773
	call 04478h		;5775
	ld a,0a8h		;5778
	call 04901h		;577a
	jp 05908h		;577d
	ld hl,03b20h		;5780
	call 043b0h		;5783
	exx			;5786
	ld hl,0e300h		;5787
	dec (hl)		;578a
	jp p,05790h		;578b
	ld (hl),00bh		;578e
	ld a,(hl)		;5790
	add a,a			;5791
	ld b,a			;5792
	add a,a			;5793
	add a,b			;5794
	ld de,059a5h		;5795
	add a,e			;5798
	ld e,a			;5799
	jr nc,$+3		;579a
	inc d			;579c
	ld b,00ch		;579d
	push bc			;579f
	ld a,b			;57a0
	rra			;57a1
	ld a,(de)		;57a2
	jr nc,$+7		;57a3
	inc de			;57a5
	rra			;57a6
	rra			;57a7
	rra			;57a8
	rra			;57a9
	and 00fh		;57aa
	add a,a			;57ac
	add a,a			;57ad
	add a,a			;57ae
	ld hl,0e320h		;57af
	add a,l			;57b2
	ld l,a			;57b3
	jr nc,$+3		;57b4
	inc h			;57b6
	ld b,008h		;57b7
	outi			;57b9
	jp nz,057b9h		;57bb
	pop bc			;57be
	djnz $-32		;57bf
	ld hl,0e06ch		;57c1
	ld a,(hl)		;57c4
	or a			;57c5
	jr z,$+4		;57c6
	dec (hl)		;57c8
	ret			;57c9
	ld a,(0e600h)		;57ca
	cp 002h			;57cd
	jr nc,$+50		;57cf
	ld hl,0e668h		;57d1
	ld a,(hl)		;57d4
	or a			;57d5
	jr z,$+9		;57d6
	ld (hl),000h		;57d8
	ld a,018h		;57da
	call 04901h		;57dc
	dec hl			;57df
	ld a,(hl)		;57e0
	or a			;57e1
	jr z,$+31		;57e2
	ld a,(0e012h)		;57e4
	or a			;57e7
	jr nz,$+25		;57e8
	ld (hl),000h		;57ea
	ld a,(0e663h)		;57ec
	or a			;57ef
	jr z,$+14		;57f0
	cp 001h			;57f2
	ld a,018h		;57f4
	jr z,$+3		;57f6
	inc a			;57f8
	call 04901h		;57f9
	jr $+5			;57fc
	call 0568ch		;57fe
	ld hl,0e090h		;5801
	inc (hl)		;5804
	ld a,(0e663h)		;5805
	or a			;5808
	jr nz,$+97		;5809
	ld a,(hl)		;580b
	and 03fh		;580c
	call z,06459h		;580e
	ld hl,0e091h		;5811
	ld a,(hl)		;5814
	cp 0d8h			;5815
	jr nc,$+11		;5817
	dec hl			;5819
	ld a,(hl)		;581a
	sub 0f2h		;581b
	cp 00dh			;581d
	call c,064ffh		;581f
	call 088e7h		;5822
	call 05d02h		;5825
	call 058d3h		;5828
	ld a,(0e600h)		;582b
	cp 003h			;582e
	ret nc			;5830
	ld a,(0e090h)		;5831
	rra			;5834
	jr nc,$+11		;5835
	call 0741dh		;5837
	call 081bah		;583a
	jp 0658dh		;583d
	ld a,(0e091h)		;5840
	cp 0d8h			;5843
	jr nc,$+20		;5845
	ld ix,0e4f0h		;5847
	ld b,008h		;584b
	push bc			;584d
	call 06862h		;584e
	ld de,00010h		;5851
	add ix,de		;5854
	pop bc			;5856
	djnz $-10		;5857
	call 062ech		;5859
	ld a,(0e090h)		;585c
	and 03fh		;585f
	ret z			;5861
	ld a,(0e3b0h)		;5862
	or a			;5865
	ret nz			;5866
	jp 078e6h		;5867
	ld a,(0e664h)		;586a
	add a,a			;586d
	add a,a			;586e
	add a,a			;586f
	add a,a			;5870
	ld hl,0e4f5h		;5871
	call 0405bh		;5874
	push hl			;5877
	call 058beh		;5878
	pop hl			;587b
	ld a,(hl)		;587c
	sub 001h		;587d
	daa			;587f
	ld (hl),a		;5880
	jr nc,$-95		;5881
	ld (hl),059h		;5883
	inc hl			;5885
	ld a,(hl)		;5886
	sub 001h		;5887
	daa			;5889
	ld (hl),a		;588a
	jr c,$+18		;588b
	cp 004h			;588d
	jr nz,$+44		;588f
	ld a,002h		;5891
	ld (0e663h),a		;5893
	ld a,019h		;5896
	call 04901h		;5898
	jr $+32			;589b
	push hl			;589d
	xor a			;589e
	ld (hl),a		;589f
	dec hl			;58a0
	ld (hl),a		;58a1
	call 058beh		;58a2
	pop hl			;58a5
	inc hl			;58a6
	ld a,(hl)		;58a7
	ld (0e090h),a		;58a8
	dec hl			;58ab
	dec hl			;58ac
	dec hl			;58ad
	xor a			;58ae
	ld (hl),a		;58af
	ld (0e663h),a		;58b0
	ld a,(0e600h)		;58b3
	cp 002h			;58b6
	call c,05690h		;58b8
	jp 05822h		;58bb
	ex de,hl		;58be
	ld hl,03838h		;58bf
	inc de			;58c2
	ld b,001h		;58c3
	call 04346h		;58c5
	ld a,0a2h		;58c8
	call 0004dh		;58ca
	inc hl			;58cd
	ld b,001h		;58ce
	jp 04346h		;58d0
	ld a,(0e600h)		;58d3
	cp 002h			;58d6
	ret nc			;58d8
	ld a,(0e660h)		;58d9
	or a			;58dc
	jr z,$+11		;58dd
	ld a,003h		;58df
	ld (0e600h),a		;58e1
	xor a			;58e4
	ld (0e60bh),a		;58e5
	ld de,0e091h		;58e8
	ld a,(de)		;58eb
	cp 0cfh			;58ec
	ret nz			;58ee
	ld hl,0e3b0h		;58ef
	ld a,(hl)		;58f2
	or a			;58f3
	jr nz,$+4		;58f4
	ld (hl),001h		;58f6
	dec de			;58f8
	ld a,(de)		;58f9
	sub 0c0h		;58fa
	cp 002h			;58fc
	ret nc			;58fe
	or a			;58ff
	ld a,03dh		;5900
	jp z,04901h		;5902
	jp 0569dh		;5905
	ld ix,0e600h		;5908
	ld hl,03b00h		;590c
	ld de,05982h		;590f
	call 00053h		;5912
	ld a,(00007h)		;5915
	ld c,a			;5918
	ld b,009h		;5919
	ld a,(de)		;591b
	add a,(ix+002h)		;591c
	out (c),a		;591f
	inc de			;5921
	ld a,(de)		;5922
	push de			;5923
	ld d,a			;5924
	ld a,(ix+004h)		;5925
	cp 008h			;5928
	jr nc,$+4		;592a
	ld a,008h		;592c
	add a,d			;592e
	pop de			;592f
	out (c),a		;5930
	inc de			;5932
	ld a,009h		;5933
	sub b			;5935
	add a,a			;5936
	add a,a			;5937
	add a,09ch		;5938
	out (c),a		;593a
	push bc			;593c
	pop bc			;593d
	ld a,(de)		;593e
	out (c),a		;593f
	inc de			;5941
	djnz $-39		;5942
	ld hl,(0e06ch)		;5944
	ld a,l			;5947
	or h			;5948
	jr nz,$+52		;5949
	ld hl,03b24h		;594b
	call 00053h		;594e
	ld a,0eeh		;5951
	add a,(ix+002h)		;5953
	out (c),a		;5956
	ld a,(ix+004h)		;5958
	cp 008h			;595b
	jr nc,$+4		;595d
	ld a,008h		;595f
	out (c),a		;5961
	ld a,(0e003h)		;5963
	rra			;5966
	rra			;5967
	rra			;5968
	rra			;5969
	and 007h		;596a
	ld de,0599dh		;596c
	call 04060h		;596f
	ld a,(de)		;5972
	out (c),a		;5973
	or a			;5975
	jr z,$+4		;5976
	ld a,00fh		;5978
	out (c),a		;597a
	ret			;597c
	dec hl			;597d
	ld (0e06ch),hl		;597e
	ret			;5981
	or 000h			;5982
	rlca			;5984
	ld b,0f8h		;5985
	ld b,016h		;5987
	ret m			;5989
	ld b,0ffh		;598a
	ret m			;598c
	rrca			;598d
	rrca			;598e
	ret m			;598f
	rrca			;5990
	ld b,008h		;5991
	ld b,016h		;5993
	ex af,af'		;5995
	ld b,0ffh		;5996
	ex af,af'		;5998
	rrca			;5999
	rrca			;599a
	ex af,af'		;599b
	rrca			;599c
	nop			;599d
	nop			;599e
	ld e,h			;599f
	sbc a,b			;59a0
	add a,h			;59a1
	add a,h			;59a2
	sbc a,b			;59a3
	ld e,h			;59a4
	ld bc,04523h		;59a5
	ld h,a			;59a8
	adc a,c			;59a9
	xor e			;59aa
	cp d			;59ab
	sbc a,b			;59ac
	halt			;59ad
	ld d,h			;59ae
	ld (01210h),a		;59af
	inc (hl)		;59b2
	ld d,b			;59b3
	ld a,b			;59b4
	sbc a,d			;59b5
	or (hl)			;59b6
	ld l,e			;59b7
	xor c			;59b8
	add a,a			;59b9
	dec b			;59ba
	ld b,e			;59bb
	ld hl,04523h		;59bc
	ld bc,0ab89h		;59bf
	ld h,a			;59c2
	halt			;59c3
	cp d			;59c4
	sbc a,b			;59c5
	djnz $+86		;59c6
	ld (05034h),a		;59c8
	ld (de),a		;59cb
	sbc a,d			;59cc
	or (hl)			;59cd
	ld a,b			;59ce
	add a,a			;59cf
	ld l,e			;59d0
	xor c			;59d1
	ld hl,04305h		;59d2
	ld b,l			;59d5
	ld bc,0ab23h		;59d6
	ld h,a			;59d9
	adc a,c			;59da
	sbc a,b			;59db
	halt			;59dc
	cp d			;59dd
	ld (05410h),a		;59de
	ld d,b			;59e1
	ld (de),a		;59e2
	inc (hl)		;59e3
	or (hl)			;59e4
	ld a,b			;59e5
	sbc a,d			;59e6
	xor c			;59e7
	add a,a			;59e8
	ld l,e			;59e9
	ld b,e			;59ea
	ld hl,0e005h		;59eb
	inc e			;59ee
	ld a,(bc)		;59ef
	nop			;59f0
	add a,e			;59f1
	rlca			;59f2
	rrca			;59f3
	dec de			;59f4
	inc bc			;59f5
	rla			;59f6
	ld a,(bc)		;59f7
	nop			;59f8
	add a,d			;59f9
	ret po			;59fa
	ret p			;59fb
	inc b			;59fc
	ret m			;59fd
	add a,l			;59fe
	nop			;59ff
	ld bc,00407h		;5a00
	inc c			;5a03
	dec bc			;5a04
	ex af,af'		;5a05
	sub b			;5a06
	ccf			;5a07
	ret po			;5a08
	nop			;5a09
	nop			;5a0a
	rrca			;5a0b
	ld a,a			;5a0c
	ei			;5a0d
	push af			;5a0e
	ei			;5a0f
	rst 18h			;5a10
	xor a			;5a11
	rst 18h			;5a12
	ei			;5a13
	push af			;5a14
	ei			;5a15
	rst 18h			;5a16
	inc bc			;5a17
	ex af,af'		;5a18
	add a,h			;5a19
	inc c			;5a1a
	inc b			;5a1b
	rlca			;5a1c
	ld bc,00009h		;5a1d
	add a,e			;5a20
	xor a			;5a21
	rst 18h			;5a22
	ld a,a			;5a23
	inc bc			;5a24
	nop			;5a25
	add a,c			;5a26
	rst 38h			;5a27
	add hl,bc		;5a28
	nop			;5a29
	add a,d			;5a2a
	ld bc,00303h		;5a2b
	ld b,00bh		;5a2e
	rlca			;5a30
	add a,a			;5a31
	cp a			;5a32
	ld e,a			;5a33
	rst 18h			;5a34
	rst 18h			;5a35
	rst 38h			;5a36
	ld a,a			;5a37
	sbc a,a			;5a38
	add hl,bc		;5a39
	rst 38h			;5a3a
	ld a,(bc)		;5a3b
	rlca			;5a3c
	ld (bc),a		;5a3d
	inc bc			;5a3e
	inc b			;5a3f
	nop			;5a40
	dec c			;5a41
	rst 38h			;5a42
	inc bc			;5a43
	nop			;5a44
	nop			;5a45
	call 0565ch		;5a46
	ld hl,0e070h		;5a49
	ld de,0e071h		;5a4c
	ld bc,006e0h		;5a4f
	ld (hl),000h		;5a52
	ldir			;5a54
	xor a			;5a56
	ld (0e061h),a		;5a57
	call 0431fh		;5a5a
	call 053d3h		;5a5d
	ld a,(0e062h)		;5a60
	inc a			;5a63
	ld (0e061h),a		;5a64
	ld hl,00800h		;5a67
	ld (0e00bh),hl		;5a6a
	ld a,001h		;5a6d
	ld (0e064h),a		;5a6f
	ret			;5a72
	ld hl,0e00ch		;5a73
	dec (hl)		;5a76
	jr nz,$+7		;5a77
	ld (hl),008h		;5a79
	dec hl			;5a7b
	inc (hl)		;5a7c
	inc hl			;5a7d
	dec hl			;5a7e
	ld a,(hl)		;5a7f
	ld hl,05a95h		;5a80
	call 0405bh		;5a83
	ld a,(hl)		;5a86
	cp 0ffh			;5a87
	jp nz,044d5h		;5a89
	xor a			;5a8c
	ld (0e064h),a		;5a8d
	ld a,03dh		;5a90
	jp 0490ch		;5a92
	ld bc,00901h		;5a95
	jr $+26			;5a98
	ld (bc),a		;5a9a
	dec b			;5a9b
	dec b			;5a9c
	inc b			;5a9d
	inc d			;5a9e
	inc b			;5a9f
	ld b,002h		;5aa0
	ld a,(bc)		;5aa2
	ex af,af'		;5aa3
	ld de,00101h		;5aa4
	ld bc,00101h		;5aa7
	ex af,af'		;5aaa
	ex af,af'		;5aab
	ex af,af'		;5aac
	dec b			;5aad
	inc d			;5aae
	ld a,(bc)		;5aaf
	ld a,(bc)		;5ab0
	ld a,(de)		;5ab1
	ex af,af'		;5ab2
	add hl,de		;5ab3
	ld de,01214h		;5ab4
	ld a,(de)		;5ab7
	ex af,af'		;5ab8
	ld de,00404h		;5ab9
	ld b,006h		;5abc
	inc d			;5abe
	inc d			;5abf
	inc b			;5ac0
	ld b,014h		;5ac1
	dec b			;5ac3
	inc b			;5ac4
	ld b,016h		;5ac5
	dec b			;5ac7
	inc b			;5ac8
	inc d			;5ac9
	inc d			;5aca
	ld de,00911h		;5acb
	add hl,bc		;5ace
	ex af,af'		;5acf
	jr $+26			;5ad0
	ld a,(bc)		;5ad2
	ld a,(de)		;5ad3
	ld a,(de)		;5ad4
	ld a,(de)		;5ad5
	djnz $+18		;5ad6
	djnz $+18		;5ad8
	djnz $+18		;5ada
	ld (de),a		;5adc
	ld d,004h		;5add
	inc b			;5adf
	inc b			;5ae0
	inc b			;5ae1
	dec d			;5ae2
	add hl,de		;5ae3
	ex af,af'		;5ae4
	jr $+26			;5ae5
	ex af,af'		;5ae7
	ld a,(bc)		;5ae8
	jr $+26			;5ae9
	add hl,bc		;5aeb
	add hl,de		;5aec
	ex af,af'		;5aed
	ex af,af'		;5aee
	add hl,de		;5aef
	add hl,bc		;5af0
	ld (de),a		;5af1
	ld (de),a		;5af2
	ld (bc),a		;5af3
	inc b			;5af4
	inc d			;5af5
	ld (de),a		;5af6
	ld (bc),a		;5af7
	add hl,de		;5af8
	inc d			;5af9
	ld a,(de)		;5afa
	ex af,af'		;5afb
	ex af,af'		;5afc
	ld a,(bc)		;5afd
	ld de,00811h		;5afe
	ex af,af'		;5b01
	ex af,af'		;5b02
	add hl,de		;5b03
	jr $+6			;5b04
	inc b			;5b06
	ld b,006h		;5b07
	ex af,af'		;5b09
	ex af,af'		;5b0a
	djnz $+42		;5b0b
	ld hl,0e004h		;5b0d
	dec (hl)		;5b10
	ret nz			;5b11
	ld hl,0e602h		;5b12
	ld (hl),097h		;5b15
	inc hl			;5b17
	inc hl			;5b18
	ld (hl),078h		;5b19
	ld hl,0e682h		;5b1b
	ld (hl),000h		;5b1e
	inc hl			;5b20
	inc hl			;5b21
	ld (hl),078h		;5b22
	ld hl,00070h		;5b24
	ld (0e676h),hl		;5b27
	call 06112h		;5b2a
	call 0431fh		;5b2d
	call 064a3h		;5b30
	jr $+98			;5b33
	djnz $+76		;5b35
	ld ix,0e600h		;5b37
	call 060e1h		;5b3b
	ld ix,0e680h		;5b3e
	call 060ebh		;5b42
	ld hl,03b30h		;5b45
	ld de,05c74h		;5b48
	call 00053h		;5b4b
	ld a,(00007h)		;5b4e
	ld c,a			;5b51
	ld b,004h		;5b52
	ld a,(de)		;5b54
	add a,(ix+002h)		;5b55
	out (c),a		;5b58
	inc de			;5b5a
	ld a,(de)		;5b5b
	add a,(ix+004h)		;5b5c
	out (c),a		;5b5f
	inc de			;5b61
	ld a,004h		;5b62
	sub b			;5b64
	add a,a			;5b65
	add a,a			;5b66
	add a,00ch		;5b67
	out (c),a		;5b69
	push bc			;5b6b
	pop bc			;5b6c
	ld a,(de)		;5b6d
	out (c),a		;5b6e
	inc de			;5b70
	djnz $-29		;5b71
	ld a,(ix+002h)		;5b73
	cp 048h			;5b76
	ret c			;5b78
	ld hl,0ff60h		;5b79
	ld (0e676h),hl		;5b7c
	jr $+22			;5b7f
	djnz $+23		;5b81
	ld ix,0e600h		;5b83
	call 060dbh		;5b87
	ld a,(ix+002h)		;5b8a
	cp 05bh			;5b8d
	ret nc			;5b8f
	ld a,078h		;5b90
	ld (0e690h),a		;5b92
	jp 04165h		;5b95
	djnz $+20		;5b98
	ld hl,0e690h		;5b9a
	dec (hl)		;5b9d
	ret nz			;5b9e
	ld hl,05c80h		;5b9f
	ld de,0e6a0h		;5ba2
	ld bc,00005h		;5ba5
	ldir			;5ba8
	jr $-21			;5baa
	djnz $+19		;5bac
	ld a,(0e003h)		;5bae
	rra			;5bb1
	ret c			;5bb2
	call 05c06h		;5bb3
	ret p			;5bb6
	ld de,05ca4h		;5bb7
	call 043f1h		;5bba
	jr $-40			;5bbd
	djnz $+21		;5bbf
	ld hl,0e690h		;5bc1
	dec (hl)		;5bc4
	ret nz			;5bc5
	ld hl,0e080h		;5bc6
	ld de,0e609h		;5bc9
	ld bc,00007h		;5bcc
	ldir			;5bcf
	jp 041fah		;5bd1
	ld a,(0e012h)		;5bd4
	or a			;5bd7
	ret nz			;5bd8
	call 04386h		;5bd9
	ld a,0b4h		;5bdc
	call 0490ch		;5bde
	ld hl,0e609h		;5be1
	ld de,0e080h		;5be4
	ld bc,00007h		;5be7
	ldir			;5bea
	xor a			;5bec
	ld (0e60ch),a		;5bed
	call 045b5h		;5bf0
	ld de,05cb9h		;5bf3
	call 0440ch		;5bf6
	ld de,05c85h		;5bf9
	call 043f1h		;5bfc
	ld a,0b4h		;5bff
	ld (0e004h),a		;5c01
	jr $-111		;5c04
	ld hl,0e6a4h		;5c06
	dec (hl)		;5c09
	ret m			;5c0a
	ld hl,(0e6a0h)		;5c0b
	ld bc,(0e6a2h)		;5c0e
	ld a,c			;5c12
	cp b			;5c13
	jr c,$+34		;5c14
	push af			;5c16
	push bc			;5c17
	call 05c67h		;5c18
	pop bc			;5c1b
	ld a,c			;5c1c
	dec a			;5c1d
	call 0405bh		;5c1e
	call 05c67h		;5c21
	ld hl,(0e6a0h)		;5c24
	inc hl			;5c27
	ld (0e6a0h),hl		;5c28
	ld a,(0e6a2h)		;5c2b
	dec a			;5c2e
	dec a			;5c2f
	ld (0e6a2h),a		;5c30
	pop af			;5c33
	jr nz,$+49		;5c34
	ld bc,(0e6a2h)		;5c36
	xor a			;5c3a
	ld b,a			;5c3b
	inc bc			;5c3c
	push bc			;5c3d
	push hl			;5c3e
	call 00056h		;5c3f
	ld hl,(0e6a3h)		;5c42
	dec l			;5c45
	xor a			;5c46
	ld h,a			;5c47
	add hl,hl		;5c48
	add hl,hl		;5c49
	add hl,hl		;5c4a
	add hl,hl		;5c4b
	add hl,hl		;5c4c
	pop de			;5c4d
	add hl,de		;5c4e
	pop bc			;5c4f
	call 00056h		;5c50
	ld hl,(0e6a0h)		;5c53
	ld de,00020h		;5c56
	add hl,de		;5c59
	ld (0e6a0h),hl		;5c5a
	ld a,(0e6a3h)		;5c5d
	dec a			;5c60
	dec a			;5c61
	ld (0e6a3h),a		;5c62
	xor a			;5c65
	ret			;5c66
	push hl			;5c67
	xor a			;5c68
	ld de,00020h		;5c69
	call 0004dh		;5c6c
	add hl,de		;5c6f
	djnz $-4		;5c70
	pop hl			;5c72
	ret			;5c73
	ei			;5c74
	inc bc			;5c75
	dec bc			;5c76
	ret m			;5c77
	nop			;5c78
	ld b,006h		;5c79
	ld bc,0090fh		;5c7b
	inc b			;5c7e
	rlca			;5c7f
	nop			;5c80
	jr c,$+34		;5c81
	ld d,00dh		;5c83
	and d			;5c85
	add hl,sp		;5c86
	ld l,022h		;5c87
	inc l			;5c89
	nop			;5c8a
	rra			;5c8b
	dec de			;5c8c
	ld h,01dh		;5c8d
	nop			;5c8f
	ld (01b1dh),a		;5c90
	dec h			;5c93
	dec e			;5c94
	ld hl,(01b00h)		;5c95
	add hl,hl		;5c98
	add hl,hl		;5c99
	nop			;5c9a
	jr nc,$+31		;5c9b
	ld hl,02a22h		;5c9d
	inc h			;5ca0
	nop			;5ca1
	ld sp,0e7ffh		;5ca2
	add hl,sp		;5ca5
	add hl,hl		;5ca6
	ld (01d26h),hl		;5ca7
	nop			;5caa
	jr nz,$+38		;5cab
	nop			;5cad
	daa			;5cae
	ld (01d23h),hl		;5caf
	ld h,01dh		;5cb2
	inc hl			;5cb4
	cpl			;5cb5
	cpl			;5cb6
	cpl			;5cb7
	rst 38h			;5cb8
	ld h,b			;5cb9
	jr $-114		;5cba
	adc a,b			;5cbc
	ld c,c			;5cbd
	ld a,a			;5cbe
	ld d,l			;5cbf
	ld a,000h		;5cc0
	djnz $+64		;5cc2
	ld l,e			;5cc4
	ld a,a			;5cc5
	ld (hl),01ch		;5cc6
	inc b			;5cc8
	nop			;5cc9
	add a,c			;5cca
	add a,b			;5ccb
	ld d,000h		;5ccc
	adc a,c			;5cce
	ex af,af'		;5ccf
	rra			;5cd0
	dec a			;5cd1
	jr c,$+52		;5cd2
	ld (hl),b		;5cd4
	ld sp,hl		;5cd5
	ret po			;5cd6
	ld b,b			;5cd7
	rlca			;5cd8
	nop			;5cd9
	sub d			;5cda
	jr nz,$-14		;5cdb
	ret m			;5cdd
	jr c,$-102		;5cde
	inc e			;5ce0
	ld a,00eh		;5ce1
	inc b			;5ce3
	jr c,$+129		;5ce4
	ccf			;5ce6
	rlca			;5ce7
	jr nc,$+127		;5ce8
	ld a,a			;5cea
	rst 38h			;5ceb
	ccf			;5cec
	rlca			;5ced
	nop			;5cee
	adc a,c			;5cef
	ret po			;5cf0
	ret p			;5cf1
	ret po			;5cf2
	nop			;5cf3
	ld h,b			;5cf4
	ret p			;5cf5
	ret p			;5cf6
	ret m			;5cf7
	ret po			;5cf8
	rlca			;5cf9
	nop			;5cfa
	add a,e			;5cfb
	add a,07ch		;5cfc
	djnz $+31		;5cfe
	nop			;5d00
	nop			;5d01
	ld ix,0e600h		;5d02
	ld a,(ix+000h)		;5d06
	call 0406ch		;5d09
	inc d			;5d0c
	ld e,l			;5d0d
	jr nc,$+95		;5d0e
	ld b,a			;5d10
	ld e,l			;5d11
	sub l			;5d12
	ld e,l			;5d13
	call 05ef1h		;5d14
	ld a,(ix+00ch)		;5d17
	cp 003h			;5d1a
	jr z,$+17		;5d1c
	ld a,(0e008h)		;5d1e
	bit 4,a			;5d21
	jr z,$+10		;5d23
	ld (ix+000h),001h	;5d25
	ld (ix+00bh),000h	;5d29
	jp 05dffh		;5d2d
	call 05ef1h		;5d30
	inc (ix+00bh)		;5d33
	ld a,(ix+00bh)		;5d36
	cp 004h			;5d39
	call z,06026h		;5d3b
	cp 006h			;5d3e
	jr c,$-19		;5d40
	ld (ix+000h),000h	;5d42
	ret			;5d46
	dec (ix+00bh)		;5d47
	ld a,(ix+00bh)		;5d4a
	jr z,$+56		;5d4d
	cp 051h			;5d4f
	jr c,$+16		;5d51
	bit 2,a			;5d53
	ld a,007h		;5d55
	jr z,$+4		;5d57
	ld a,00fh		;5d59
	ld hl,03b07h		;5d5b
	jp 0004dh		;5d5e
	ld b,000h		;5d61
	cp 049h			;5d63
	jr nc,$+36		;5d65
	inc b			;5d67
	cp 041h			;5d68
	jr nc,$+31		;5d6a
	inc b			;5d6c
	cp 039h			;5d6d
	jr nc,$+26		;5d6f
	inc b			;5d71
	cp 031h			;5d72
	jr nc,$+21		;5d74
	ld hl,03b00h		;5d76
	cp 029h			;5d79
	jr nc,$+5		;5d7b
	ld hl,03b04h		;5d7d
	ld a,0c3h		;5d80
	jp 0004dh		;5d82
	ld (0e064h),a		;5d85
	ret			;5d88
	ld (ix+006h),b		;5d89
	ld de,0a60bh		;5d8c
	ld (ix+00ch),004h	;5d8f
	jr $+103		;5d93
	ld b,(ix+00bh)		;5d95
	djnz $+37		;5d98
	call 060dbh		;5d9a
	cp 020h			;5d9d
	jr c,$+14		;5d9f
	ld a,(0e675h)		;5da1
	and 07fh		;5da4
	ret nz			;5da6
	ld a,(ix+004h)		;5da7
	cp 078h			;5daa
	ret nz			;5dac
	inc (ix+00bh)		;5dad
	ld hl,00000h		;5db0
	ld (0e678h),hl		;5db3
	ld hl,0ff50h		;5db6
	ld (0e676h),hl		;5db9
	ret			;5dbc
	djnz $+14		;5dbd
	call 060dbh		;5dbf
	cp 005h			;5dc2
	ret nc			;5dc4
	ld a,001h		;5dc5
	ld (0e00dh),a		;5dc7
	ret			;5dca
	inc (ix+00bh)		;5dcb
	call 06112h		;5dce
	call 06226h		;5dd1
	ld (0e675h),a		;5dd4
	call 083e1h		;5dd7
	ld a,(0e675h)		;5dda
	and 07fh		;5ddd
	cp 005h			;5ddf
	jr c,$+6		;5de1
	cp 07bh			;5de3
	jr c,$+8		;5de5
	xor a			;5de7
	ld (0e675h),a		;5de8
	ld b,a			;5deb
	ld c,a			;5dec
	ld (0e676h),bc		;5ded
	ld (0e678h),de		;5df1
	ld a,0b7h		;5df5
	jp 0490ch		;5df7
	ld hl,03b00h		;5dfa
	jr $+39			;5dfd
	ld hl,03b00h		;5dff
	ld de,0a5c2h		;5e02
	ld a,(ix+00ch)		;5e05
	cp 002h			;5e08
	jr nz,$+26		;5e0a
	ld de,0a5efh		;5e0c
	ld a,(ix+00eh)		;5e0f
	cp 012h			;5e12
	jr nc,$+16		;5e14
	ld a,(0e003h)		;5e16
	bit 3,a			;5e19
	jr z,$+9		;5e1b
	ld de,0a5c2h		;5e1d
	ld (ix+00ch),080h	;5e20
	call 00053h		;5e24
	ld a,(00007h)		;5e27
	ld c,a			;5e2a
	ld b,003h		;5e2b
	push bc			;5e2d
	call 05ed5h		;5e2e
	ld a,003h		;5e31
	sub b			;5e33
	add a,a			;5e34
	add a,a			;5e35
	out (c),a		;5e36
	ld a,(ix+00ch)		;5e38
	cp 003h			;5e3b
	ld a,(de)		;5e3d
	jr nz,$+23		;5e3e
	cp 007h			;5e40
	jr nz,$+19		;5e42
	ld a,(ix+00eh)		;5e44
	cp 012h			;5e47
	jr nc,$+10		;5e49
	ld a,(0e003h)		;5e4b
	bit 2,a			;5e4e
	ld a,(de)		;5e50
	jr nz,$+4		;5e51
	ld a,006h		;5e53
	out (c),a		;5e55
	inc de			;5e57
	pop bc			;5e58
	djnz $-44		;5e59
	ld a,(ix+00ch)		;5e5b
	dec a			;5e5e
	jr nz,$+31		;5e5f
	ld de,0a5dah		;5e61
	call 05ed5h		;5e64
	ld a,(de)		;5e67
	out (c),a		;5e68
	ld b,007h		;5e6a
	ld a,(ix+00fh)		;5e6c
	cp 00ah			;5e6f
	jr nc,$+9		;5e71
	ld b,00ah		;5e73
	cp 005h			;5e75
	jr nc,$+3		;5e77
	dec b			;5e79
	out (c),b		;5e7a
	jr $+6			;5e7c
	ld a,0c3h		;5e7e
	out (c),a		;5e80
	ld hl,0a5b4h		;5e82
	ld a,(ix+00ch)		;5e85
	and 00fh		;5e88
	call 04079h		;5e8a
	ld a,(ix+006h)		;5e8d
	call 04071h		;5e90
	bit 7,(ix+00ch)		;5e93
	jr z,$+6		;5e97
	ld (ix+00ch),002h	;5e99
	ld hl,01800h		;5e9d
	call 00053h		;5ea0
	ex de,hl		;5ea3
	ld a,(hl)		;5ea4
	and a			;5ea5
	ret z			;5ea6
	inc hl			;5ea7
	ld e,(hl)		;5ea8
	inc hl			;5ea9
	ld d,(hl)		;5eaa
	inc hl			;5eab
	inc a			;5eac
	jr nz,$+30		;5ead
	ld a,(de)		;5eaf
	and a			;5eb0
	jr z,$-13		;5eb1
	inc de			;5eb3
	ld b,a			;5eb4
	and 07fh		;5eb5
	cp b			;5eb7
	ld b,a			;5eb8
	jr z,$+10		;5eb9
	ld a,(de)		;5ebb
	inc de			;5ebc
	out (c),a		;5ebd
	djnz $-4		;5ebf
	jr $-18			;5ec1
	ld a,(de)		;5ec3
	inc de			;5ec4
	out (c),a		;5ec5
	djnz $-2		;5ec7
	jr $-26			;5ec9
	ld b,020h		;5ecb
	ld a,(de)		;5ecd
	inc de			;5ece
	out (c),a		;5ecf
	djnz $-4		;5ed1
	jr $-47			;5ed3
	ld a,(ix+008h)		;5ed5
	and 00ch		;5ed8
	cp 00bh			;5eda
	jr z,$+7		;5edc
	cp 00ch			;5ede
	ld a,(de)		;5ee0
	jr nz,$+4		;5ee1
	ld a,(de)		;5ee3
	dec a			;5ee4
	add a,(ix+002h)		;5ee5
	out (c),a		;5ee8
	inc de			;5eea
	ld a,(ix+004h)		;5eeb
	out (c),a		;5eee
	ret			;5ef0
	ld a,(0e008h)		;5ef1
	bit 5,a			;5ef4
	jr z,$+27		;5ef6
	ld hl,0e069h		;5ef8
	ld a,(hl)		;5efb
	and 01fh		;5efc
	jr z,$+19		;5efe
	bit 4,a			;5f00
	jr nz,$+10		;5f02
	inc (hl)		;5f04
	ld a,(hl)		;5f05
	cp 004h			;5f06
	jr c,$+4		;5f08
	ld (hl),000h		;5f0a
	ld hl,0e60ch		;5f0c
	ld (hl),002h		;5f0f
	ld hl,062e2h		;5f11
	ld a,(ix+00ch)		;5f14
	cp 003h			;5f17
	ld a,(ix+00ah)		;5f19
	jr nz,$+4		;5f1c
	ld a,004h		;5f1e
	add a,a			;5f20
	call 0405bh		;5f21
	ld b,(hl)		;5f24
	inc hl			;5f25
	ld c,(hl)		;5f26
	ld a,(0e009h)		;5f27
	and 00fh		;5f2a
	call z,06141h		;5f2c
	and 003h		;5f2f
	jr z,$+42		;5f31
	ld e,(ix+001h)		;5f33
	ld d,(ix+002h)		;5f36
	ld (0e074h),de		;5f39
	ld l,b			;5f3d
	call 06003h		;5f3e
	ld (ix+001h),l		;5f41
	ld a,020h		;5f44
	cp h			;5f46
	jr c,$+3		;5f47
	ld h,a			;5f49
	ld a,09fh		;5f4a
	cp h			;5f4c
	jr nc,$+3		;5f4d
	ld h,a			;5f4f
	ld (ix+002h),h		;5f50
	ld a,(0e009h)		;5f53
	and 00ch		;5f56
	call z,06155h		;5f58
	ld a,(0e009h)		;5f5b
	and 00ch		;5f5e
	jr z,$+44		;5f60
	ld e,(ix+003h)		;5f62
	ld d,(ix+004h)		;5f65
	ld (0e076h),de		;5f68
	ld l,c			;5f6c
	rra			;5f6d
	rra			;5f6e
	call 06003h		;5f6f
	ld (ix+003h),l		;5f72
	ld a,003h		;5f75
	cp h			;5f77
	jr c,$+3		;5f78
	ld h,a			;5f7a
	ld a,0efh		;5f7b
	cp h			;5f7d
	jr nc,$+3		;5f7e
	ld h,a			;5f80
	ld (ix+004h),h		;5f81
	ld a,(0e009h)		;5f84
	and 00ch		;5f87
	call nz,06155h		;5f89
	call 06014h		;5f8c
	call 06163h		;5f8f
	ld a,(0e3b0h)		;5f92
	or a			;5f95
	jr z,$+26		;5f96
	ld a,(0e3c0h)		;5f98
	or a			;5f9b
	jr nz,$+20		;5f9c
	ld a,(0e062h)		;5f9e
	cp 006h			;5fa1
	jr nz,$+8		;5fa3
	ld a,(0e3d0h)		;5fa5
	or a			;5fa8
	jr z,$+7		;5fa9
	call 0875eh		;5fab
	jr nc,$+13		;5fae
	ld a,(ix+002h)		;5fb0
	cp 0a0h			;5fb3
	jr c,$+10		;5fb5
	ld (ix+002h),09fh	;5fb7
	pop hl			;5fbb
	jp 08338h		;5fbc
	ld a,(ix+00ch)		;5fbf
	cp 002h			;5fc2
	ret c			;5fc4
	call 05ff8h		;5fc5
	dec (ix+00dh)		;5fc8
	ret nz			;5fcb
	ld (ix+00dh),014h	;5fcc
	ld a,(ix+00eh)		;5fd0
	or a			;5fd3
	jr z,$+9		;5fd4
	cp 012h			;5fd6
	ld a,013h		;5fd8
	call c,04901h		;5fda
	ld a,(ix+00eh)		;5fdd
	sub 001h		;5fe0
	daa			;5fe2
	ld (ix+00eh),a		;5fe3
	ret nz			;5fe6
	ld a,(ix+00fh)		;5fe7
	or a			;5fea
	ld c,000h		;5feb
	jr z,$+3		;5fed
	inc c			;5fef
	ld (ix+00ch),c		;5ff0
	ld a,014h		;5ff3
	call 04901h		;5ff5
	ld hl,03824h		;5ff8
	ld de,0e60eh		;5ffb
	ld b,001h		;5ffe
	jp 04346h		;6000
	ld h,000h		;6003
	add hl,hl		;6005
	add hl,hl		;6006
	add hl,hl		;6007
	add hl,hl		;6008
	ex de,hl		;6009
	rra			;600a
	jr nc,$+5		;600b
	or a			;600d
	sbc hl,de		;600e
	rra			;6010
	ret nc			;6011
	add hl,de		;6012
	ret			;6013
	ld a,(ix+008h)		;6014
	rra			;6017
	rra			;6018
	rra			;6019
	and 001h		;601a
	ld b,(ix+006h)		;601c
	ld (ix+005h),b		;601f
	ld (ix+006h),a		;6022
	ret			;6025
	ld a,(ix+009h)		;6026
	ld c,a			;6029
	ld hl,060bdh		;602a
	add a,a			;602d
	call 0405bh		;602e
	ld b,(hl)		;6031
	inc hl			;6032
	ld d,(hl)		;6033
	ld hl,0e620h		;6034
	bit 7,(hl)		;6037
	jr z,$+21		;6039
	ld a,c			;603b
	srl a			;603c
	cp 004h			;603e
	jr nz,$+22		;6040
	push hl			;6042
	pop iy			;6043
	ld a,(iy+010h)		;6045
	or (iy+020h)		;6048
	rla			;604b
	jr c,$+10		;604c
	ld a,010h		;604e
	call 0405bh		;6050
	djnz $-28		;6053
	ret			;6055
	res 7,(hl)		;6056
	res 4,(hl)		;6058
	inc hl			;605a
	inc hl			;605b
	ld a,(ix+002h)		;605c
	sub 008h		;605f
	ld (hl),a		;6061
	inc hl			;6062
	inc hl			;6063
	ld a,(ix+004h)		;6064
	add a,d			;6067
	ld (hl),a		;6068
	inc hl			;6069
	ld (hl),c		;606a
	inc hl			;606b
	xor a			;606c
	ld (hl),a		;606d
	inc hl			;606e
	ld (hl),a		;606f
	inc hl			;6070
	ld de,06442h		;6071
	ld (hl),e		;6074
	inc hl			;6075
	ld (hl),d		;6076
	ld a,c			;6077
	srl a			;6078
	ld c,a			;607a
	ld hl,060d5h		;607b
	call 0405bh		;607e
	ld a,(hl)		;6081
	call 04901h		;6082
	ld a,c			;6085
	cp 004h			;6086
	ret nz			;6088
	ld hl,0e621h		;6089
	ld de,0e631h		;608c
	ld bc,0000fh		;608f
	ldir			;6092
	res 7,(hl)		;6094
	inc hl			;6096
	inc de			;6097
	ld c,00fh		;6098
	ldir			;609a
	res 7,(hl)		;609c
	ld a,(ix+009h)		;609e
	cp 009h			;60a1
	ret nz			;60a3
	ld a,(iy+002h)		;60a4
	add a,010h		;60a7
	ld (iy+012h),a		;60a9
	ld (iy+022h),a		;60ac
	ld a,(iy+004h)		;60af
	sub 010h		;60b2
	ld (iy+014h),a		;60b4
	add a,020h		;60b7
	ld (iy+024h),a		;60b9
	ret			;60bc
	ld (bc),a		;60bd
	ld b,002h		;60be
	ld b,002h		;60c0
	ld (bc),a		;60c2
	inc bc			;60c3
	ld (bc),a		;60c4
	inc bc			;60c5
	dec b			;60c6
	inc bc			;60c7
	ld (bc),a		;60c8
	ld (bc),a		;60c9
	inc bc			;60ca
	inc bc			;60cb
	inc bc			;60cc
	ld bc,00106h		;60cd
	ld b,002h		;60d0
	inc b			;60d2
	inc bc			;60d3
	inc b			;60d4
	inc bc			;60d5
	inc bc			;60d6
	ld b,h			;60d7
	dec b			;60d8
	ld b,006h		;60d9
	call 060ebh		;60db
	call 06017h		;60de
	ld hl,03b20h		;60e1
	call 05e02h		;60e4
	ld a,(ix+002h)		;60e7
	ret			;60ea
	ld l,(ix+003h)		;60eb
	ld h,(ix+004h)		;60ee
	ld de,(0e678h)		;60f1
	add hl,de		;60f5
	ld (ix+003h),l		;60f6
	ld (ix+004h),h		;60f9
	ld l,(ix+001h)		;60fc
	ld h,(ix+002h)		;60ff
	ld de,(0e676h)		;6102
	add hl,de		;6106
	ld (ix+001h),l		;6107
	ld (ix+002h),h		;610a
	ld a,(0e003h)		;610d
	rra			;6110
	ret			;6111
	ld hl,03b00h		;6112
	ld bc,00020h		;6115
	xor a			;6118
	call 00056h		;6119
	ld hl,03b00h		;611c
	ld b,008h		;611f
	ld a,b			;6121
	cp 005h			;6122
	ld a,005h		;6124
	jr c,$+4		;6126
	ld a,0fch		;6128
	call 0004dh		;612a
	inc hl			;612d
	inc hl			;612e
	inc hl			;612f
	inc hl			;6130
	djnz $-16		;6131
	ld hl,0e330h		;6133
	ld de,0e331h		;6136
	ld bc,0004fh		;6139
	ld (hl),0c3h		;613c
	ldir			;613e
	ret			;6140
	push af			;6141
	xor a			;6142
	ld (ix+001h),a		;6143
	ld (ix+003h),a		;6146
	ld l,b			;6149
	ld h,000h		;614a
	add hl,hl		;614c
	add hl,hl		;614d
	add hl,hl		;614e
	ex de,hl		;614f
	call 06155h		;6150
	pop af			;6153
	ret			;6154
	ld l,(ix+007h)		;6155
	ld h,(ix+008h)		;6158
	add hl,de		;615b
	ld (ix+007h),l		;615c
	ld (ix+008h),h		;615f
	ret			;6162
	ld hl,06216h		;6163
	ld iy,0e610h		;6166
	ld b,008h		;616a
	ld a,(ix+002h)		;616c
	add a,(hl)		;616f
	inc hl			;6170
	ld e,a			;6171
	ld a,(ix+004h)		;6172
	add a,(hl)		;6175
	inc hl			;6176
	ld d,a			;6177
	ex de,hl		;6178
	call 04372h		;6179
	call 0004ah		;617c
	ld (iy+000h),a		;617f
	ex de,hl		;6182
	inc iy			;6183
	djnz $-25		;6185
	ld iy,0e610h		;6187
	ld hl,(0e074h)		;618b
	ld a,(0e009h)		;618e
	rra			;6191
	push af			;6192
	jr nc,$+24		;6193
	ld a,(iy+000h)		;6195
	call 0620ch		;6198
	jr nc,$+16		;619b
	ld a,(iy+001h)		;619d
	call 0620ch		;61a0
	jr nc,$+8		;61a3
	ld (ix+001h),l		;61a5
	ld (ix+002h),h		;61a8
	pop af			;61ab
	rra			;61ac
	push af			;61ad
	jr nc,$+24		;61ae
	ld a,(iy+004h)		;61b0
	call 0620ch		;61b3
	jr nc,$+16		;61b6
	ld a,(iy+005h)		;61b8
	call 0620ch		;61bb
	jr nc,$+8		;61be
	ld (ix+001h),l		;61c0
	ld (ix+002h),h		;61c3
	pop af			;61c6
	ld hl,(0e076h)		;61c7
	rra			;61ca
	push af			;61cb
	jr nc,$+32		;61cc
	ld a,(iy+002h)		;61ce
	call 0620ch		;61d1
	jr c,$+18		;61d4
	ld a,(iy+000h)		;61d6
	call 0620ch		;61d9
	jr nc,$+16		;61dc
	ld a,(iy+004h)		;61de
	call 0620ch		;61e1
	jr nc,$+8		;61e4
	ld (ix+003h),l		;61e6
	ld (ix+004h),h		;61e9
	pop af			;61ec
	rra			;61ed
	ret nc			;61ee
	ld a,(iy+003h)		;61ef
	call 0620ch		;61f2
	jr c,$+16		;61f5
	ld a,(iy+001h)		;61f7
	call 0620ch		;61fa
	ret nc			;61fd
	ld a,(iy+005h)		;61fe
	call 0620ch		;6201
	ret nc			;6204
	ld (ix+003h),l		;6205
	ld (ix+004h),h		;6208
	ret			;620b
	sub 043h		;620c
	cp 03dh			;620e
	ret c			;6210
	sub 060h		;6211
	cp 03dh			;6213
	ret			;6215
	ld bc,00104h		;6216
	dec bc			;6219
	ex af,af'		;621a
	ld (bc),a		;621b
	ex af,af'		;621c
	dec c			;621d
	ld c,004h		;621e
	ld c,00bh		;6220
	ld sp,hl		;6222
	inc b			;6223
	ld sp,hl		;6224
	dec bc			;6225
	ld a,(ix+002h)		;6226
	sub 020h		;6229
	ld l,000h		;622b
	jr z,$+3		;622d
	ld l,a			;622f
	ld a,078h		;6230
	sub (ix+004h)		;6232
	ld d,000h		;6235
	ld b,d			;6237
	jr z,$+8		;6238
	jr nc,$+5		;623a
	inc d			;623c
	neg			;623d
	ld b,a			;623f
	push de			;6240
	ld h,000h		;6241
	call 08569h		;6243
	ld hl,06262h		;6246
	ld b,040h		;6249
	ld a,(hl)		;624b
	inc hl			;624c
	push hl			;624d
	ld h,(hl)		;624e
	ld l,a			;624f
	and a			;6250
	sbc hl,de		;6251
	pop hl			;6253
	jr c,$+6		;6254
	inc hl			;6256
	dec b			;6257
	jr nz,$-13		;6258
	pop de			;625a
	dec d			;625b
	ld a,b			;625c
	ret nz			;625d
	ld a,080h		;625e
	sub b			;6260
	ret			;6261
	or l			;6262
	jr z,$+91		;6263
	inc d			;6265
	adc a,l			;6266
	dec c			;6267
	ld h,00ah		;6268
	dec de			;626a
	ex af,af'		;626b
	cp l			;626c
	ld b,0c3h		;626d
	dec b			;626f
	ld b,005h		;6270
	ld (hl),e		;6272
	inc b			;6273
	defb 0fdh,003h,09dh ;illegal sequence	;6274
	inc bc			;6277
	ld c,e			;6278
	inc bc			;6279
	ld b,003h		;627a
	rlc d			;627c
	sub a			;627e
	ld (bc),a		;627f
	ld l,d			;6280
	ld (bc),a		;6281
	ld b,c			;6282
	ld (bc),a		;6283
	dec e			;6284
	ld (bc),a		;6285
	call m,0de01h		;6286
	ld bc,001c3h		;6289
	xor e			;628c
	ld bc,00194h		;628d
	ld a,a			;6290
	ld bc,0016bh		;6291
	ld e,c			;6294
	ld bc,00148h		;6295
	scf			;6298
	ld bc,00128h		;6299
	ld a,(de)		;629c
	ld bc,0010ch		;629d
	rst 38h			;62a0
	nop			;62a1
	di			;62a2
	nop			;62a3
	ret pe			;62a4
	nop			;62a5
	call c,0d200h		;62a6
	nop			;62a9
	rst 0			;62aa
	nop			;62ab
	cp l			;62ac
	nop			;62ad
	or h			;62ae
	nop			;62af
	xor e			;62b0
	nop			;62b1
	and d			;62b2
	nop			;62b3
	sbc a,c			;62b4
	nop			;62b5
	sub c			;62b6
	nop			;62b7
	adc a,b			;62b8
	nop			;62b9
	add a,b			;62ba
	nop			;62bb
	ld a,c			;62bc
	nop			;62bd
	ld (hl),c		;62be
	nop			;62bf
	ld l,d			;62c0
	nop			;62c1
	ld h,d			;62c2
	nop			;62c3
	ld e,e			;62c4
	nop			;62c5
	ld d,h			;62c6
	nop			;62c7
	ld c,l			;62c8
	nop			;62c9
	ld b,(hl)		;62ca
	nop			;62cb
	ld b,b			;62cc
	nop			;62cd
	add hl,sp		;62ce
	nop			;62cf
	ld (02c00h),a		;62d0
	nop			;62d3
	dec h			;62d4
	nop			;62d5
	rra			;62d6
	nop			;62d7
	add hl,de		;62d8
	nop			;62d9
	ld (de),a		;62da
	nop			;62db
	inc c			;62dc
	nop			;62dd
	ld b,000h		;62de
	nop			;62e0
	nop			;62e1
	ld c,010h		;62e2
	inc de			;62e4
	dec d			;62e5
	rla			;62e6
	ld a,(de)		;62e7
	inc e			;62e8
	ld e,020h		;62e9
	inc h			;62eb
	ld ix,0e620h		;62ec
	ld b,003h		;62f0
	push bc			;62f2
	bit 7,(ix+000h)		;62f3
	jr nz,$+74		;62f7
	ld a,(ix+005h)		;62f9
	cp 008h			;62fc
	jr z,$+7		;62fe
	call 0634dh		;6300
	jr $+62			;6303
	ld a,(ix+000h)		;6305
	and 00fh		;6308
	jr z,$-10		;630a
	dec a			;630c
	ld de,0fd00h		;630d
	jr z,$+5		;6310
	ld de,00300h		;6312
	ld l,(ix+003h)		;6315
	ld h,(ix+004h)		;6318
	add hl,de		;631b
	ld (ix+003h),l		;631c
	ld (ix+004h),h		;631f
	ld a,h			;6322
	add a,009h		;6323
	cp 009h			;6325
	jr nc,$+6		;6327
	set 7,(ix+000h)		;6329
	ld de,0f8a7h		;632d
	call 063a3h		;6330
	ld a,h			;6333
	sub 0e5h		;6334
	cp 00ah			;6336
	jr nc,$+6		;6338
	set 7,(ix+000h)		;633a
	call 067a0h		;633e
	call 063b1h		;6341
	ld de,00010h		;6344
	add ix,de		;6347
	pop bc			;6349
	djnz $-88		;634a
	ret			;634c
	ld a,(ix+005h)		;634d
	srl a			;6350
	cp 003h			;6352
	push af			;6354
	jr z,$+24		;6355
	ld a,(ix+005h)		;6357
	ld de,0f680h		;635a
	cp 002h			;635d
	jr z,$+36		;635f
	ld de,0f700h		;6361
	cp 004h			;6364
	jr z,$+29		;6366
	ld de,0f800h		;6368
	jr $+24			;636b
	inc (ix+007h)		;636d
	ld a,(ix+007h)		;6370
	rra			;6373
	rra			;6374
	and 003h		;6375
	ld (ix+006h),a		;6377
	ld a,(0e604h)		;637a
	ld (ix+004h),a		;637d
	call 06409h		;6380
	call 063a3h		;6383
	pop af			;6386
	jr z,$+11		;6387
	ld a,h			;6389
	sub 0e5h		;638a
	cp 00ah			;638c
	jr c,$+14		;638e
	jr $+16			;6390
	ld a,(0e602h)		;6392
	add a,008h		;6395
	sub h			;6397
	cp 00ah			;6398
	jr nc,$+6		;639a
	set 7,(ix+000h)		;639c
	jp 067a0h		;63a0
	ld l,(ix+001h)		;63a3
	ld h,(ix+002h)		;63a6
	add hl,de		;63a9
	ld (ix+001h),l		;63aa
	ld (ix+002h),h		;63ad
	ret			;63b0
	ld a,(ix+000h)		;63b1
	and 00fh		;63b4
	add a,a			;63b6
	add a,a			;63b7
	ld hl,03b10h		;63b8
	call 0405bh		;63bb
	call 00053h		;63be
	ld a,(00007h)		;63c1
	ld c,a			;63c4
	ld a,(ix+002h)		;63c5
	bit 7,(ix+000h)		;63c8
	jr nz,$+6		;63cc
	cp 0d0h			;63ce
	jr nz,$+4		;63d0
	ld a,0c3h		;63d2
	out (c),a		;63d4
	ld a,(ix+004h)		;63d6
	out (c),a		;63d9
	ld a,(ix+005h)		;63db
	cp 005h			;63de
	jr nz,$+4		;63e0
	ld a,00ch		;63e2
	and 00eh		;63e4
	ld l,a			;63e6
	ld h,000h		;63e7
	ld de,063fbh		;63e9
	add hl,de		;63ec
	ld d,(hl)		;63ed
	ld a,(ix+006h)		;63ee
	add a,a			;63f1
	add a,a			;63f2
	add a,d			;63f3
	out (c),a		;63f4
	inc hl			;63f6
	ld a,(hl)		;63f7
	out (c),a		;63f8
	ret			;63fa
	inc c			;63fb
	ld bc,00110h		;63fc
	jr $+17			;63ff
	inc e			;6401
	ld bc,00a2ch		;6402
	inc d			;6405
	rrca			;6406
	ld b,b			;6407
	rrca			;6408
	ld l,(ix+008h)		;6409
	ld h,(ix+009h)		;640c
	ld a,(hl)		;640f
	bit 4,(ix+000h)		;6410
	jr nz,$+15		;6414
	inc hl			;6416
	cpl			;6417
	ld d,a			;6418
	ld a,0ffh		;6419
	scf			;641b
	rr d			;641c
	rra			;641e
	ld e,a			;641f
	inc de			;6420
	jr $+9			;6421
	dec hl			;6423
	ld d,a			;6424
	xor a			;6425
	srl d			;6426
	rra			;6428
	ld e,a			;6429
	ld a,(hl)		;642a
	inc a			;642b
	jr nz,$+15		;642c
	dec hl			;642e
	dec hl			;642f
	set 4,(ix+000h)		;6430
	ld (ix+008h),l		;6434
	ld (ix+009h),h		;6437
	ret			;643a
	inc a			;643b
	jr nz,$-8		;643c
	inc hl			;643e
	jr $-11			;643f
	cp 00ch			;6441
	inc c			;6443
	dec bc			;6444
	dec bc			;6445
	ld a,(bc)		;6446
	ld a,(bc)		;6447
	add hl,bc		;6448
	add hl,bc		;6449
	add hl,bc		;644a
	add hl,bc		;644b
	ex af,af'		;644c
	ex af,af'		;644d
	ex af,af'		;644e
	rlca			;644f
	rlca			;6450
	ld b,006h		;6451
	dec b			;6453
	inc b			;6454
	inc bc			;6455
	ld (bc),a		;6456
	ld bc,03affh		;6457
	nop			;645a
	and 0feh		;645b
	ld (bc),a		;645d
	ret nc			;645e
	ld hl,0e091h		;645f
	ld a,(hl)		;6462
	cp 0d8h			;6463
	ret nc			;6465
	inc (hl)		;6466
	ld hl,0e09ah		;6467
	inc (hl)		;646a
	ld a,(hl)		;646b
	cp 003h			;646c
	jr c,$+19		;646e
	ex af,af'		;6470
	ld a,001h		;6471
	ld (0e09eh),a		;6473
	ex af,af'		;6476
	cp 018h			;6477
	jr c,$+8		;6479
	ld (hl),000h		;647b
	ld hl,0e092h		;647d
	inc (hl)		;6480
	ld a,(0e090h)		;6481
	or a			;6484
	call z,055edh		;6485
	ld ix,0e4f0h		;6488
	ld b,008h		;648c
	bit 4,(ix+000h)		;648e
	jr z,$+10		;6492
	ld a,(ix+002h)		;6494
	add a,008h		;6497
	ld (ix+002h),a		;6499
	ld de,00010h		;649c
	add ix,de		;649f
	djnz $-19		;64a1
	ld hl,03800h		;64a3
	call 00053h		;64a6
	ld a,(00007h)		;64a9
	ld c,a			;64ac
	ld a,(0e091h)		;64ad
	and 003h		;64b0
	ld l,a			;64b2
	ld h,000h		;64b3
	add hl,hl		;64b5
	add hl,hl		;64b6
	add hl,hl		;64b7
	add hl,hl		;64b8
	add hl,hl		;64b9
	ld de,0e8a0h		;64ba
	ex de,hl		;64bd
	or a			;64be
	sbc hl,de		;64bf
	ld b,000h		;64c1
	call 064f9h		;64c3
	call 064f9h		;64c6
	ld b,0c0h		;64c9
	call 064f9h		;64cb
	ld ix,0e600h		;64ce
	ld a,(ix+010h)		;64d2
	call 0620ch		;64d5
	jr nc,$+10		;64d8
	ld a,(ix+011h)		;64da
	call 0620ch		;64dd
	jr c,$+16		;64e0
	ld a,(ix+016h)		;64e2
	call 0620ch		;64e5
	ret nc			;64e8
	ld a,(ix+017h)		;64e9
	call 0620ch		;64ec
	ret nc			;64ef
	ld a,(ix+002h)		;64f0
	add a,008h		;64f3
	ld (ix+002h),a		;64f5
	ret			;64f8
	outi			;64f9
	jp nz,064f9h		;64fb
	ret			;64fe
	srl a			;64ff
	ret c			;6501
	push af			;6502
	ld hl,(0e088h)		;6503
	call 0405bh		;6506
	ld a,(hl)		;6509
	ld iy,0e08ah		;650a
	ld (iy+000h),a		;650e
	pop af			;6511
	ld hl,00000h		;6512
	ld de,00080h		;6515
	or a			;6518
	ld b,a			;6519
	jr z,$+5		;651a
	add hl,de		;651c
	djnz $-1		;651d
	ld de,0e820h		;651f
	add hl,de		;6522
	ld ix,(0e09ch)		;6523
	ld c,008h		;6527
	push hl			;6529
	ld a,(ix+000h)		;652a
	and 07fh		;652d
	ld l,a			;652f
	ld h,000h		;6530
	add hl,hl		;6532
	ld de,099edh		;6533
	add hl,de		;6536
	ld e,(hl)		;6537
	inc hl			;6538
	ld d,(hl)		;6539
	pop hl			;653a
	push hl			;653b
	ld b,004h		;653c
	push bc			;653e
	push hl			;653f
	call 06561h		;6540
	pop hl			;6543
	ld bc,00020h		;6544
	add hl,bc		;6547
	pop bc			;6548
	djnz $-11		;6549
	pop hl			;654b
	ld a,004h		;654c
	call 0405bh		;654e
	rl (iy+000h)		;6551
	jr nc,$+4		;6555
	inc ix			;6557
	dec c			;6559
	jr nz,$-49		;655a
	ld (0e09ch),ix		;655c
	ret			;6560
	ld b,004h		;6561
	bit 7,(ix+000h)		;6563
	jr z,$+31		;6567
	ld a,003h		;6569
	call 0405bh		;656b
	call 06576h		;656e
	ld (hl),a		;6571
	dec hl			;6572
	djnz $-5		;6573
	ret			;6575
	ld a,(de)		;6576
	and 0f0h		;6577
	ld a,(de)		;6579
	inc de			;657a
	ret z			;657b
	cp 0a0h			;657c
	jr nc,$+5		;657e
	add a,060h		;6580
	ret			;6582
	sub 060h		;6583
	ret			;6585
	ld a,(de)		;6586
	inc de			;6587
	ld (hl),a		;6588
	inc hl			;6589
	djnz $-4		;658a
	ret			;658c
	call 066bfh		;658d
	ld hl,0e290h		;6590
	ld a,(hl)		;6593
	or a			;6594
	jp nz,06652h		;6595
	inc l			;6598
	inc l			;6599
	inc l			;659a
	ld (hl),0e0h		;659b
	ld a,(0e3b0h)		;659d
	or a			;65a0
	ret nz			;65a1
	ld a,(0e663h)		;65a2
	and a			;65a5
	ret nz			;65a6
	ld a,(0e062h)		;65a7
	ld hl,065e6h		;65aa
	call 04079h		;65ad
	ld a,(0e091h)		;65b0
	srl a			;65b3
	ld b,a			;65b5
	ld a,(hl)		;65b6
	inc a			;65b7
	ret z			;65b8
	dec a			;65b9
	and 07fh		;65ba
	cp b			;65bc
	jr z,$+5		;65bd
	inc hl			;65bf
	jr $-10			;65c0
	push hl			;65c2
	call 066a3h		;65c3
	pop hl			;65c6
	ld a,(hl)		;65c7
	ld hl,0e290h		;65c8
	ld (hl),001h		;65cb
	inc l			;65cd
	rlc a			;65ce
	and 001h		;65d0
	ld (hl),a		;65d2
	ld a,(0e604h)		;65d3
	ld b,028h		;65d6
	cp b			;65d8
	jr c,$+8		;65d9
	ld b,0d0h		;65db
	cp b			;65dd
	jr nc,$+3		;65de
	ld b,a			;65e0
	ld a,b			;65e1
	ld (0e29ah),a		;65e2
	ret			;65e5
	or 065h			;65e6
	nop			;65e8
	ld h,(hl)		;65e9
	ld a,(bc)		;65ea
	ld h,(hl)		;65eb
	inc d			;65ec
	ld h,(hl)		;65ed
	ld e,066h		;65ee
	jr z,$+104		;65f0
	ld (hl),066h		;65f2
	ld b,h			;65f4
	ld h,(hl)		;65f5
	adc a,h			;65f6
	sbc a,b			;65f7
	inc h			;65f8
	jr nc,$-72		;65f9
	inc a			;65fb
	ret z			;65fc
	call nc,0ff60h		;65fd
	adc a,h			;6600
	sbc a,b			;6601
	inc h			;6602
	jr nc,$-72		;6603
	inc a			;6605
	ret z			;6606
	call nc,0ff60h		;6607
	adc a,h			;660a
	sbc a,b			;660b
	inc h			;660c
	jr nc,$-72		;660d
	inc a			;660f
	ret z			;6610
	call nc,0ff60h		;6611
	adc a,h			;6614
	sbc a,b			;6615
	inc h			;6616
	jr nc,$-72		;6617
	inc a			;6619
	ret z			;661a
	call nc,0ff60h		;661b
	adc a,h			;661e
	sbc a,b			;661f
	inc h			;6620
	jr nc,$-72		;6621
	inc a			;6623
	ret z			;6624
	call nc,0ff60h		;6625
	adc a,h			;6628
	sub d			;6629
	jr $-90			;662a
	ld hl,(036b0h)		;662c
	jp nz,0ce48h		;662f
	ld d,h			;6632
	jp c,0ff60h		;6633
	adc a,h			;6636
	sub d			;6637
	jr $-90			;6638
	ld hl,(036b0h)		;663a
	jp nz,0ce48h		;663d
	ld d,h			;6640
	jp c,0ff60h		;6641
	adc a,h			;6644
	sub d			;6645
	jr $-90			;6646
	ld hl,(036b0h)		;6648
	jp nz,0ce48h		;664b
	ld d,h			;664e
	jp c,0ff60h		;664f
	ld a,(0e600h)		;6652
	cp 002h			;6655
	jr nc,$+8		;6657
	call 06783h		;6659
	jp nc,067cbh		;665c
	ld hl,0e290h		;665f
	ld a,(hl)		;6662
	cp 002h			;6663
	jr nz,$+34		;6665
	inc l			;6667
	ld a,(hl)		;6668
	and a			;6669
	ld bc,00803h		;666a
	jr z,$+5		;666d
	ld bc,00701h		;666f
	ld l,09dh		;6672
	inc (hl)		;6674
	ld a,(hl)		;6675
	cp b			;6676
	jr c,$+4		;6677
	xor a			;6679
	ld (hl),a		;667a
	ld d,a			;667b
	dec l			;667c
	ld a,(hl)		;667d
	cp c			;667e
	jr nc,$+8		;667f
	ld a,d			;6681
	srl a			;6682
	srl a			;6684
	ld (hl),a		;6686
	ld hl,0e290h		;6687
	ld (hl),001h		;668a
	call 06848h		;668c
	ld hl,(0e292h)		;668f
	ld bc,(0e296h)		;6692
	add hl,bc		;6696
	ld (0e292h),hl		;6697
	ld a,(0e293h)		;669a
	cp 0a8h			;669d
	ret c			;669f
	cp 0d8h			;66a0
	ret nc			;66a2
	ld hl,066afh		;66a3
	ld de,0e290h		;66a6
	ld bc,00010h		;66a9
	ldir			;66ac
	ret			;66ae
	nop			;66af
	nop			;66b0
	nop			;66b1
	ret po			;66b2
	nop			;66b3
	nop			;66b4
	sbc a,a			;66b5
	nop			;66b6
	nop			;66b7
	nop			;66b8
	nop			;66b9
	ld b,b			;66ba
	nop			;66bb
	nop			;66bc
	nop			;66bd
	ld bc,09021h		;66be
	jp po,0a77eh		;66c1
	ld de,0e37ch		;66c4
	jr nz,$+9		;66c7
	ld a,0e0h		;66c9
	ld (de),a		;66cb
	ld (0e378h),a		;66cc
	ret			;66cf
	ld hl,0e291h		;66d0
	ld a,(hl)		;66d3
	and a			;66d4
	push af			;66d5
	inc l			;66d6
	inc l			;66d7
	ldi			;66d8
	inc l			;66da
	ldi			;66db
	ex de,hl		;66dd
	ld (hl),094h		;66de
	inc l			;66e0
	ld (hl),001h		;66e1
	pop af			;66e3
	jr z,$+13		;66e4
	ld de,0674fh		;66e6
	ld a,(0e29dh)		;66e9
	call 04060h		;66ec
	ld a,(de)		;66ef
	ld (hl),a		;66f0
	ld de,0e378h		;66f1
	ld hl,0e291h		;66f4
	ld a,(hl)		;66f7
	inc l			;66f8
	inc l			;66f9
	and a			;66fa
	jr nz,$+48		;66fb
	ld b,(hl)		;66fd
	inc l			;66fe
	inc l			;66ff
	ld c,(hl)		;6700
	ld a,(0e29dh)		;6701
	ld hl,06839h		;6704
	call 0405bh		;6707
	ld a,(0e609h)		;670a
	and 0feh		;670d
	cp (hl)			;670f
	ld a,(hl)		;6710
	jr nz,$+3		;6711
	inc a			;6713
	ld hl,06756h		;6714
	push de			;6717
	call 04079h		;6718
	pop de			;671b
	ld a,(hl)		;671c
	add a,b			;671d
	ld (de),a		;671e
	inc hl			;671f
	inc e			;6720
	ld a,(hl)		;6721
	add a,c			;6722
	ld (de),a		;6723
	inc hl			;6724
	inc e			;6725
	ldi			;6726
	ex de,hl		;6728
	jr $+18			;6729
	ld a,(hl)		;672b
	add a,003h		;672c
	ld (de),a		;672e
	inc l			;672f
	inc l			;6730
	inc e			;6731
	ld a,(hl)		;6732
	add a,005h		;6733
	ld (de),a		;6735
	inc e			;6736
	ex de,hl		;6737
	ld (hl),038h		;6738
	inc l			;673a
	ld a,(0e003h)		;673b
	rra			;673e
	rra			;673f
	and 003h		;6740
	ld de,0674bh		;6742
	call 04060h		;6745
	ld a,(de)		;6748
	ld (hl),a		;6749
	ret			;674a
	rrca			;674b
	ld bc,0040fh		;674c
	ld bc,00101h		;674f
	dec b			;6752
	rlca			;6753
	rrca			;6754
	ld b,06eh		;6755
	ld h,a			;6757
	ld l,(hl)		;6758
	ld h,a			;6759
	ld (hl),c		;675a
	ld h,a			;675b
	ld (hl),c		;675c
	ld h,a			;675d
	ld (hl),h		;675e
	ld h,a			;675f
	ld (hl),a		;6760
	ld h,a			;6761
	ld a,d			;6762
	ld h,a			;6763
	ld a,d			;6764
	ld h,a			;6765
	ld a,l			;6766
	ld h,a			;6767
	ld a,l			;6768
	ld h,a			;6769
	add a,b			;676a
	ld h,a			;676b
	add a,b			;676c
	ld h,a			;676d
	nop			;676e
	nop			;676f
	sub h			;6770
	ld bc,01002h		;6771
	nop			;6774
	dec b			;6775
	jr $+3			;6776
	ld bc,00340h		;6778
	ld b,01ch		;677b
	nop			;677d
	nop			;677e
	inc (hl)		;677f
	ld bc,01404h		;6780
	ld hl,0e293h		;6783
	ld a,(hl)		;6786
	inc l			;6787
	inc l			;6788
	ld h,(hl)		;6789
	ld l,a			;678a
	ld bc,01010h		;678b
	ld a,(0e602h)		;678e
	ld (0e0d0h),a		;6791
	ld a,(0e604h)		;6794
	ld (0e0d1h),a		;6797
	ld de,00e0eh		;679a
	jp 088d3h		;679d
	ld a,(0e290h)		;67a0
	dec a			;67a3
	ret nz			;67a4
	push ix			;67a5
	pop hl			;67a7
	inc l			;67a8
	inc l			;67a9
	call 088a4h		;67aa
	ld hl,0e293h		;67ad
	ld a,(hl)		;67b0
	inc l			;67b1
	inc l			;67b2
	ld h,(hl)		;67b3
	ld l,a			;67b4
	ld bc,01010h		;67b5
	call 088d3h		;67b8
	ret c			;67bb
	ld a,00eh		;67bc
	call 0490ch		;67be
	set 7,(ix+000h)		;67c1
	ld a,002h		;67c5
	ld (0e290h),a		;67c7
	ret			;67ca
	ld hl,066a3h		;67cb
	push hl			;67ce
	ld hl,0e291h		;67cf
	ld a,(hl)		;67d2
	and a			;67d3
	ld hl,06839h		;67d4
	jr z,$+5		;67d7
	ld hl,06841h		;67d9
	ld a,(0e29dh)		;67dc
	call 0405bh		;67df
	ld a,(hl)		;67e2
	and a			;67e3
	push af			;67e4
	ld de,00200h		;67e5
	jr nz,$+5		;67e8
	ld de,01000h		;67ea
	call 042adh		;67ed
	pop af			;67f0
	ld b,a			;67f1
	jr z,$+66		;67f2
	ld a,0a5h		;67f4
	call 04901h		;67f6
	ld a,001h		;67f9
	ld (0e667h),a		;67fb
	ld a,(0e291h)		;67fe
	or a			;6801
	jr nz,$+14		;6802
	ld hl,0e609h		;6804
	ld a,(hl)		;6807
	and 0feh		;6808
	cp b			;680a
	jr nz,$+3		;680b
	inc b			;680d
	ld (hl),b		;680e
	ret			;680f
	ld a,b			;6810
	dec a			;6811
	jr z,$+23		;6812
	ld (0e60ch),a		;6814
	dec a			;6817
	jr z,$+11		;6818
	dec hl			;681a
	ld bc,04514h		;681b
	ld (0e60dh),bc		;681e
	ret			;6822
	ld a,01eh		;6823
	ld (0e60fh),a		;6825
	ret			;6828
	ld hl,0e60ah		;6829
	inc (hl)		;682c
	ld a,(hl)		;682d
	cp 005h			;682e
	ret c			;6830
	ld (hl),004h		;6831
	ret			;6833
	ld a,012h		;6834
	jp 0490ch		;6836
	nop			;6839
	nop			;683a
	nop			;683b
	ld (bc),a		;683c
	ex af,af'		;683d
	ld b,004h		;683e
	ld a,(bc)		;6840
	nop			;6841
	nop			;6842
	nop			;6843
	ld bc,00302h		;6844
	inc b			;6847
	ld hl,0e29ch		;6848
	ld a,(hl)		;684b
	dec l			;684c
	add a,(hl)		;684d
	ld (hl),a		;684e
	call 083e1h		;684f
	ld h,d			;6852
	ld l,e			;6853
	add hl,hl		;6854
	add hl,hl		;6855
	add hl,hl		;6856
	add hl,hl		;6857
	add hl,hl		;6858
	ld a,(0e29ah)		;6859
	add a,h			;685c
	ld h,a			;685d
	ld (0e294h),hl		;685e
	ret			;6861
	ld a,b			;6862
	ld (0e665h),a		;6863
	ld a,(ix+000h)		;6866
	bit 7,a			;6869
	jr nz,$+107		;686b
	or a			;686d
	jr nz,$+21		;686e
	ld iy,(0e570h)		;6870
	ld a,(0e091h)		;6874
	cp (iy+001h)		;6877
	ret nz			;687a
	call 06a1eh		;687b
	ld (0e570h),iy		;687e
	ret			;6882
	ld a,(ix+001h)		;6883
	or a			;6886
	ld de,06f40h		;6887
	call nz,06a04h		;688a
	ld a,(ix+002h)		;688d
	cp 0b0h			;6890
	jp nc,06a16h		;6892
	ld hl,0e620h		;6895
	ld b,003h		;6898
	bit 7,(hl)		;689a
	jr nz,$+25		;689c
	push hl			;689e
	push bc			;689f
	inc l			;68a0
	inc l			;68a1
	call 088a4h		;68a2
	ld l,(ix+002h)		;68a5
	ld h,(ix+003h)		;68a8
	ld bc,00808h		;68ab
	call 088d3h		;68ae
	pop bc			;68b1
	pop hl			;68b2
	jr nc,$+9		;68b3
	ld de,00010h		;68b5
	add hl,de		;68b8
	djnz $-31		;68b9
	ret			;68bb
	set 7,(hl)		;68bc
	ld a,00fh		;68be
	call 0490ch		;68c0
	inc (ix+001h)		;68c3
	ld a,(ix+001h)		;68c6
	cp (ix+008h)		;68c9
	ret c			;68cc
	set 7,(ix+000h)		;68cd
	ld a,010h		;68d1
	jp 0490ch		;68d3
	ld h,a			;68d6
	and 007h		;68d7
	cp 004h			;68d9
	jr nc,$+34		;68db
	ld de,06f24h		;68dd
	add a,a			;68e0
	add a,a			;68e1
	call 04060h		;68e2
	bit 6,h			;68e5
	jr z,$+5		;68e7
	ld de,06f3ch		;68e9
	call 06a04h		;68ec
	bit 6,(ix+000h)		;68ef
	ret nz			;68f3
	call 06a67h		;68f4
	ret c			;68f7
	ld a,012h		;68f8
	call 0490ch		;68fa
	set 6,(ix+000h)		;68fd
	ld a,(ix+000h)		;6901
	and 007h		;6904
	call 0406ch		;6906
	dec b			;6909
	ld b,e			;690a
	add hl,de		;690b
	ld l,c			;690c
	rra			;690d
	ld l,c			;690e
	ld c,(hl)		;690f
	ld l,c			;6910
	add a,e			;6911
	ld l,c			;6912
	adc a,d			;6913
	ld l,c			;6914
	cp h			;6915
	ld l,c			;6916
	push de			;6917
	ld l,c			;6918
	ld de,00500h		;6919
	jp 042adh		;691c
	ld a,056h		;691f
	call 04901h		;6921
	push ix			;6924
	ld ix,0e100h		;6926
	ld b,007h		;692a
	push bc			;692c
	ld a,(ix+001h)		;692d
	and 00fh		;6930
	ld hl,075aah		;6932
	call 0405bh		;6935
	ld a,(ix+000h)		;6938
	and a			;693b
	jr z,$+6		;693c
	cp (hl)			;693e
	call c,07579h		;693f
	pop bc			;6942
	ld de,00020h		;6943
	add ix,de		;6946
	djnz $-28		;6948
	pop ix			;694a
	jr $+40			;694c
	ld a,03dh		;694e
	call 04901h		;6950
	ld hl,0e665h		;6953
	ld a,008h		;6956
	sub (hl)		;6958
	dec hl			;6959
	ld (hl),a		;695a
	dec hl			;695b
	ld a,001h		;695c
	ld (0e668h),a		;695e
	ld (ix+004h),a		;6961
	ld (hl),a		;6964
	ld hl,01000h		;6965
	ld (ix+005h),l		;6968
	ld (ix+006h),h		;696b
	ld a,(0e090h)		;696e
	ld (ix+007h),a		;6971
	ld hl,0e200h		;6974
	ld b,008h		;6977
	ld (hl),000h		;6979
	ld a,010h		;697b
	call 0405bh		;697d
	djnz $-7		;6980
	ret			;6982
	ld de,06f34h		;6983
	call 06a04h		;6986
	ret			;6989
	ld de,06f38h		;698a
	call 06a04h		;698d
	call 06a67h		;6990
	ret c			;6993
	ld hl,06a8ch		;6994
	ld b,006h		;6997
	ld a,(ix+009h)		;6999
	cp (hl)			;699c
	inc hl			;699d
	jr z,$+6		;699e
	inc hl			;69a0
	djnz $-8		;69a1
	ret			;69a3
	ld b,(hl)		;69a4
	ld hl,0e061h		;69a5
	ld a,(hl)		;69a8
	add a,b			;69a9
	daa			;69aa
	ld (hl),a		;69ab
	inc hl			;69ac
	ld a,(hl)		;69ad
	add a,b			;69ae
	ld (hl),a		;69af
	ld a,001h		;69b0
	ld (0e00dh),a		;69b2
	ld a,0b1h		;69b5
	call 04901h		;69b7
	jr $+92			;69ba
	ld l,(ix+002h)		;69bc
	ld a,l			;69bf
	add a,010h		;69c0
	cp 0d0h			;69c2
	jr nc,$-10		;69c4
	ld h,(ix+003h)		;69c6
	ld de,0f7f0h		;69c9
	add hl,de		;69cc
	ld de,09a9ch		;69cd
	ld bc,00404h		;69d0
	jr $+63			;69d3
	ld a,(ix+002h)		;69d5
	cp 0b0h			;69d8
	jr nc,$+60		;69da
	ld a,(ix+008h)		;69dc
	and 0f0h		;69df
	add a,a			;69e1
	ld b,a			;69e2
	ld c,008h		;69e3
	call 06a71h		;69e5
	ret c			;69e8
	ld a,(0e009h)		;69e9
	bit 0,(ix+008h)		;69ec
	jr z,$+7		;69f0
	bit 3,a			;69f2
	ret z			;69f4
	jr $+5			;69f5
	bit 2,a			;69f7
	ret z			;69f9
	ld hl,0e604h		;69fa
	ld a,(hl)		;69fd
	neg			;69fe
	sub 010h		;6a00
	ld (hl),a		;6a02
	ret			;6a03
	ld l,(ix+002h)		;6a04
	ld h,(ix+003h)		;6a07
	ld bc,00202h		;6a0a
	ld a,l			;6a0d
	cp 0b0h			;6a0e
	jr nc,$+5		;6a10
	jp 08df1h		;6a12
	pop hl			;6a15
	xor a			;6a16
	ld (ix+000h),a		;6a17
	ld (ix+001h),a		;6a1a
	ret			;6a1d
	ld a,(iy+000h)		;6a1e
	ld c,a			;6a21
	cp 015h			;6a22
	jr nz,$+11		;6a24
	ld a,(0e006h)		;6a26
	ld hl,0e061h		;6a29
	cp (hl)			;6a2c
	jr c,$+52		;6a2d
	ld a,c			;6a2f
	and 01fh		;6a30
	cp 017h			;6a32
	jr c,$+4		;6a34
	ld a,097h		;6a36
	ld (ix+000h),a		;6a38
	ld (ix+002h),000h	;6a3b
	ld a,(iy+002h)		;6a3f
	ld (ix+003h),a		;6a42
	ld a,c			;6a45
	and 00fh		;6a46
	ld hl,06a7fh		;6a48
	call 0405bh		;6a4b
	ld a,(hl)		;6a4e
	bit 5,c			;6a4f
	jr z,$+7		;6a51
	ld (ix+001h),001h	;6a53
	inc a			;6a57
	ld (ix+008h),a		;6a58
	ld a,(iy+001h)		;6a5b
	ld (ix+009h),a		;6a5e
	ld de,00003h		;6a61
	add iy,de		;6a64
	ret			;6a66
	ld a,(0e600h)		;6a67
	cp 002h			;6a6a
	jr nc,$+17		;6a6c
	ld bc,00808h		;6a6e
	call 0888fh		;6a71
	ld l,(ix+002h)		;6a74
	ld h,(ix+003h)		;6a77
	jp 088d3h		;6a7a
	scf			;6a7d
	ret			;6a7e
	rrca			;6a7f
	dec b			;6a80
	ld a,(bc)		;6a81
	ld a,(bc)		;6a82
	inc b			;6a83
	ld e,005h		;6a84
	djnz $+19		;6a86
	jr nz,$+35		;6a88
	jr nc,$+51		;6a8a
	ld d,b			;6a8c
	nop			;6a8d
	adc a,b			;6a8e
	ld bc,00070h		;6a8f
	cp h			;6a92
	ld bc,00186h		;6a93
	ld a,001h		;6a96
	ret m			;6a98
	ld l,d			;6a99
	nop			;6a9a
	inc bc			;6a9b
	add hl,bc		;6a9c
	djnz $+21		;6a9d
	ld d,01bh		;6a9f
	ld hl,00024h		;6aa1
	ld h,h			;6aa4
	ld l,e			;6aa5
	nop			;6aa6
	inc b			;6aa7
	ld a,(bc)		;6aa8
	rrca			;6aa9
	inc d			;6aaa
	jr $+30			;6aab
	inc hl			;6aad
	ld hl,(0e200h)		;6aae
	ld l,e			;6ab1
	nop			;6ab2
	inc bc			;6ab3
	rlca			;6ab4
	ld c,014h		;6ab5
	dec de			;6ab7
	ld (02a27h),hl		;6ab8
	nop			;6abb
	ld h,b			;6abc
	ld l,h			;6abd
	nop			;6abe
	inc b			;6abf
	ld a,(bc)		;6ac0
	djnz $+24		;6ac1
	dec e			;6ac3
	ld hl,02e27h		;6ac4
	nop			;6ac7
	jp pe,0006ch		;6ac8
	ld b,00ch		;6acb
	ld (de),a		;6acd
	ld a,(de)		;6ace
	rra			;6acf
	dec h			;6ad0
	dec l			;6ad1
	inc (hl)		;6ad2
	nop			;6ad3
	add a,(hl)		;6ad4
	ld l,l			;6ad5
	nop			;6ad6
	ld b,00ch		;6ad7
	ld (de),a		;6ad9
	ld a,(de)		;6ada
	jr nz,$+41		;6adb
	inc l			;6add
	jr nc,$+52		;6ade
	inc e			;6ae0
	ld l,(hl)		;6ae1
	nop			;6ae2
	dec b			;6ae3
	dec bc			;6ae4
	ld de,01c18h		;6ae5
	ld (02c26h),hl		;6ae8
	dec l			;6aeb
	and e			;6aec
	ld l,(hl)		;6aed
	nop			;6aee
	inc bc			;6aef
	add hl,bc		;6af0
	djnz $+25		;6af1
	inc e			;6af3
	jr nz,$+40		;6af4
	dec hl			;6af6
	nop			;6af7
	ld sp,04404h		;6af8
	ld sp,0940eh		;6afb
	ld sp,09410h		;6afe
	ld (de),a		;6b01
	jr $-26			;6b02
	ld (07420h),a		;6b04
	ld de,0c420h		;6b07
	ld de,0c424h		;6b0a
	ld sp,03428h		;6b0d
	ld de,0c428h		;6b10
	sbc a,e			;6b13
	jr nc,$+3		;6b14
	sbc a,h			;6b16
	jr nc,$-6		;6b17
	ld sp,05438h		;6b19
	ld sp,0543ch		;6b1c
	ld de,05440h		;6b1f
	inc sp			;6b22
	ld b,d			;6b23
	or h			;6b24
	ld de,05444h		;6b25
	dec d			;6b28
	ld d,b			;6b29
	inc d			;6b2a
	ld sp,0d456h		;6b2b
	inc de			;6b2e
	ld e,(hl)		;6b2f
	ld h,h			;6b30
	djnz $+110		;6b31
	call po,07231h		;6b33
	ld d,h			;6b36
	ld sp,0b472h		;6b37
	ld sp,03486h		;6b3a
	sub a			;6b3d
	adc a,b			;6b3e
	ld bc,08898h		;6b3f
	ret m			;6b42
	dec d			;6b43
	adc a,b			;6b44
	call po,08a32h		;6b45
	ld h,h			;6b48
	sub a			;6b49
	sub b			;6b4a
	ld bc,09098h		;6b4b
	ret m			;6b4e
	ld de,08498h		;6b4f
	ld de,0849eh		;6b52
	inc de			;6b55
	sbc a,(hl)		;6b56
	call nc,0a431h		;6b57
	add a,h			;6b5a
	ld (de),a		;6b5b
	xor h			;6b5c
	inc (hl)		;6b5d
	sbc a,e			;6b5e
	cp h			;6b5f
	ld bc,0bc9ch		;6b60
	ret m			;6b63
	ld de,0a408h		;6b64
	ld (de),a		;6b67
	ld a,(bc)		;6b68
	inc (hl)		;6b69
	ld de,0a40eh		;6b6a
	ld de,0a414h		;6b6d
	inc (hl)		;6b70
	jr nz,$+118		;6b71
	inc (hl)		;6b73
	jr nz,$-122		;6b74
	inc (hl)		;6b76
	jr nz,$-106		;6b77
	inc (hl)		;6b79
	jr nz,$-90		;6b7a
	sub a			;6b7c
	jr z,$+3		;6b7d
	sbc a,b			;6b7f
	jr z,$-6		;6b80
	ld sp,0a438h		;6b82
	ld de,0943ah		;6b85
	ld sp,0843ch		;6b88
	ld de,0743eh		;6b8b
	inc de			;6b8e
	ld b,h			;6b8f
	or h			;6b90
	ld sp,0544eh		;6b91
	ld sp,07450h		;6b94
	ld sp,09452h		;6b97
	ld sp,0b454h		;6b9a
	ld (de),a		;6b9d
	ld e,d			;6b9e
	ld b,h			;6b9f
	ld de,0646ah		;6ba0
	ld de,06470h		;6ba3
	dec d			;6ba6
	ld (hl),b		;6ba7
	call po,07611h		;6ba8
	ld h,h			;6bab
	inc d			;6bac
	ld a,d			;6bad
	sub h			;6bae
	ld sp,04484h		;6baf
	inc sp			;6bb2
	adc a,b			;6bb3
	call nz,08c11h		;6bb4
	sub h			;6bb7
	ld (de),a		;6bb8
	sub d			;6bb9
	inc (hl)		;6bba
	sub a			;6bbb
	sub h			;6bbc
	ld bc,09498h		;6bbd
	ret m			;6bc0
	ld de,0549ch		;6bc1
	ld sp,0849ch		;6bc4
	ld de,0b49ch		;6bc7
	inc d			;6bca
	and (hl)		;6bcb
	ld h,h			;6bcc
	inc d			;6bcd
	xor b			;6bce
	ld h,h			;6bcf
	ld sp,044b2h		;6bd0
	ld sp,0b4b2h		;6bd3
	ld sp,074b6h		;6bd6
	ld sp,094b6h		;6bd9
	dec d			;6bdc
	cp h			;6bdd
	inc d			;6bde
	inc d			;6bdf
	cp (hl)			;6be0
	ld b,h			;6be1
	ld sp,03406h		;6be2
	ld sp,0540ah		;6be5
	ld sp,0740eh		;6be8
	ld (de),a		;6beb
	inc h			;6bec
	or h			;6bed
	ld (hl),026h		;6bee
	ld l,h			;6bf0
	inc sp			;6bf1
	ld hl,(03144h)		;6bf2
	ld hl,(09bd4h)		;6bf5
	inc (hl)		;6bf8
	ld bc,0349ch		;6bf9
	ret m			;6bfc
	ld sp,0a438h		;6bfd
	ld sp,0843ch		;6c00
	ld de,06440h		;6c03
	djnz $+68		;6c06
	call nc,04431h		;6c08
	ld b,h			;6c0b
	ld sp,04452h		;6c0c
	ld sp,0b452h		;6c0f
	ld de,06454h		;6c12
	ld de,09454h		;6c15
	inc d			;6c18
	ld e,d			;6c19
	ld b,h			;6c1a
	inc d			;6c1b
	ld e,d			;6c1c
	or h			;6c1d
	ld d,062h		;6c1e
	ld c,h			;6c20
	ld de,0446ah		;6c21
	ld de,0c46ah		;6c24
	ld sp,05472h		;6c27
	ld sp,0a472h		;6c2a
	ld sp,07474h		;6c2d
	ld sp,08474h		;6c30
	sbc a,c			;6c33
	add a,b			;6c34
	ld bc,0809ah		;6c35
	ret m			;6c38
	dec d			;6c39
	add a,(hl)		;6c3a
	inc d			;6c3b
	ld de,0b488h		;6c3c
	ld sp,0448ah		;6c3f
	ld sp,0448eh		;6c42
	inc de			;6c45
	adc a,(hl)		;6c46
	call p,09c10h		;6c47
	inc d			;6c4a
	ld (de),a		;6c4b
	sbc a,h			;6c4c
	call po,0a49bh		;6c4d
	ld bc,0a49ch		;6c50
	ret m			;6c53
	ld d,0a6h		;6c54
	call z,0aa34h		;6c56
	ld d,h			;6c59
	ld de,044b6h		;6c5a
	ld de,064b6h		;6c5d
	ld sp,05406h		;6c60
	ld sp,0d40ah		;6c63
	ld sp,0840ch		;6c66
	ld sp,07416h		;6c69
	ld de,08420h		;6c6c
	ld de,07422h		;6c6f
	ld de,08424h		;6c72
	sub a			;6c75
	jr z,$+3		;6c76
	sbc a,b			;6c78
	jr z,$-6		;6c79
	ld (de),a		;6c7b
	ld l,0c4h		;6c7c
	ld (01430h),a		;6c7e
	ld sp,04436h		;6c81
	inc (hl)		;6c84
	jr c,$-58		;6c85
	ld d,03ah		;6c87
	xor h			;6c89
	inc de			;6c8a
	ld a,034h		;6c8b
	dec d			;6c8d
	ld a,0e4h		;6c8e
	inc d			;6c90
	ld d,h			;6c91
	ld b,h			;6c92
	inc d			;6c93
	ld d,h			;6c94
	ld d,h			;6c95
	inc d			;6c96
	ld d,h			;6c97
	ld h,h			;6c98
	inc d			;6c99
	ld d,h			;6c9a
	sub h			;6c9b
	inc d			;6c9c
	ld d,h			;6c9d
	and h			;6c9e
	inc d			;6c9f
	ld d,h			;6ca0
	or h			;6ca1
	ld de,0746ah		;6ca2
	ld de,0846ah		;6ca5
	ld de,0746eh		;6ca8
	ld de,0846eh		;6cab
	ld d,072h		;6cae
	ld c,h			;6cb0
	ld de,07476h		;6cb1
	ld de,08476h		;6cb4
	inc (hl)		;6cb7
	add a,d			;6cb8
	call nz,08410h		;6cb9
	inc d			;6cbc
	ld d,086h		;6cbd
	call z,08a34h		;6cbf
	ld d,h			;6cc2
	ld sp,0c490h		;6cc3
	ld d,092h		;6cc6
	ld c,h			;6cc8
	ld sp,07496h		;6cc9
	inc de			;6ccc
	sub (hl)		;6ccd
	call nc,09e31h		;6cce
	ld b,h			;6cd1
	ld (de),a		;6cd2
	and d			;6cd3
	add a,h			;6cd4
	sbc a,c			;6cd5
	or b			;6cd6
	ld bc,0b09ah		;6cd7
	ret m			;6cda
	ld d,0b2h		;6cdb
	ld c,h			;6cdd
	ld sp,024b6h		;6cde
	ld sp,0b4b6h		;6ce1
	ld sp,0c4b8h		;6ce4
	ld d,0bah		;6ce7
	call z,00234h		;6ce9
	ld h,h			;6cec
	ld sp,0d40ch		;6ced
	inc de			;6cf0
	ld c,044h		;6cf1
	ld sp,02412h		;6cf3
	ld sp,09412h		;6cf6
	ld (de),a		;6cf9
	ld (de),a		;6cfa
	call po,01831h		;6cfb
	call nc,01e31h		;6cfe
	ld h,h			;6d01
	ld sp,06422h		;6d02
	ld sp,08426h		;6d05
	ld sp,0842ah		;6d08
	inc de			;6d0b
	ld l,0b4h		;6d0c
	ld sp,0643ah		;6d0e
	ld de,0943ah		;6d11
	ld sp,07440h		;6d14
	ld de,08440h		;6d17
	sbc a,e			;6d1a
	ld b,b			;6d1b
	ld bc,0409ch		;6d1c
	ret m			;6d1f
	ld (de),a		;6d20
	ld c,b			;6d21
	ld (hl),h		;6d22
	ld sp,08448h		;6d23
	ld de,02454h		;6d26
	ld de,0c456h		;6d29
	ld de,02458h		;6d2c
	inc (hl)		;6d2f
	ld e,d			;6d30
	ld (hl),h		;6d31
	ld de,0c45ah		;6d32
	inc (hl)		;6d35
	ld e,h			;6d36
	add a,h			;6d37
	ld sp,0846ah		;6d38
	sbc a,e			;6d3b
	ld (hl),b		;6d3c
	ld bc,0709ch		;6d3d
	ret m			;6d40
	ld de,0d472h		;6d41
	ld de,02476h		;6d44
	ld (de),a		;6d47
	ld a,b			;6d48
	inc d			;6d49
	inc (hl)		;6d4a
	ld a,(hl)		;6d4b
	ld d,h			;6d4c
	inc (hl)		;6d4d
	add a,d			;6d4e
	ld (hl),h		;6d4f
	inc (hl)		;6d50
	adc a,b			;6d51
	add a,h			;6d52
	inc de			;6d53
	adc a,d			;6d54
	call nc,08e10h		;6d55
	inc d			;6d58
	ld (de),a		;6d59
	sub (hl)		;6d5a
	inc d			;6d5b
	sbc a,c			;6d5c
	sbc a,b			;6d5d
	ld bc,0989ah		;6d5e
	ret m			;6d61
	ld sp,0a49ch		;6d62
	ld sp,0a49eh		;6d65
	ld sp,0a4a0h		;6d68
	inc d			;6d6b
	and (hl)		;6d6c
	ld (hl),h		;6d6d
	inc d			;6d6e
	and (hl)		;6d6f
	add a,h			;6d70
	inc de			;6d71
	xor (hl)		;6d72
	call po,0ae12h		;6d73
	call p,0b631h		;6d76
	ld b,h			;6d79
	sbc a,e			;6d7a
	cp h			;6d7b
	ld bc,0bc9ch		;6d7c
	ret m			;6d7f
	inc (hl)		;6d80
	cp h			;6d81
	ld (hl),h		;6d82
	ld sp,084beh		;6d83
	ld de,08404h		;6d86
	inc d			;6d89
	ex af,af'		;6d8a
	ld (hl),h		;6d8b
	ld d,00ah		;6d8c
	ld c,h			;6d8e
	ld d,00ah		;6d8f
	xor h			;6d91
	ld de,03410h		;6d92
	ld de,0c412h		;6d95
	sub a			;6d98
	jr $+3			;6d99
	sbc a,b			;6d9b
	jr $-6			;6d9c
	ld (de),a		;6d9e
	inc e			;6d9f
	and h			;6da0
	ld de,04422h		;6da1
	ld de,03426h		;6da4
	ld de,03428h		;6da7
	ld de,05432h		;6daa
	inc de			;6dad
	inc (hl)		;6dae
	ld h,h			;6daf
	ld de,07436h		;6db0
	ld de,08438h		;6db3
	inc d			;6db6
	ld a,(01694h)		;6db7
	ld b,d			;6dba
	ld c,h			;6dbb
	ld (de),a		;6dbc
	ld c,b			;6dbd
	call po,05014h		;6dbe
	ld h,h			;6dc1
	inc d			;6dc2
	ld d,b			;6dc3
	ld (hl),h		;6dc4
	inc d			;6dc5
	ld d,b			;6dc6
	add a,h			;6dc7
	inc d			;6dc8
	ld d,b			;6dc9
	sub h			;6dca
	inc de			;6dcb
	ld d,h			;6dcc
	inc h			;6dcd
	ld de,0745ch		;6dce
	ld de,0d45ch		;6dd1
	ld d,062h		;6dd4
	call z,06811h		;6dd6
	inc (hl)		;6dd9
	ld de,07468h		;6dda
	ld (de),a		;6ddd
	ld l,d			;6dde
	sub h			;6ddf
	ld d,06eh		;6de0
	ld l,h			;6de2
	djnz $+116		;6de3
	call p,07e11h		;6de5
	add a,h			;6de8
	ld de,07482h		;6de9
	ld de,0c484h		;6dec
	ld de,08486h		;6def
	ld de,0c488h		;6df2
	ld (de),a		;6df5
	adc a,d			;6df6
	ld (hl),h		;6df7
	inc d			;6df8
	adc a,(hl)		;6df9
	add a,h			;6dfa
	ld d,096h		;6dfb
	xor h			;6dfd
	inc de			;6dfe
	sbc a,d			;6dff
	inc d			;6e00
	sub a			;6e01
	sbc a,h			;6e02
	ld bc,09c98h		;6e03
	ret m			;6e06
	ld d,09eh		;6e07
	ld c,h			;6e09
	inc d			;6e0a
	or b			;6e0b
	inc h			;6e0c
	inc d			;6e0d
	or b			;6e0e
	inc (hl)		;6e0f
	ld d,0b6h		;6e10
	call z,0be14h		;6e12
	call nz,0c011h		;6e15
	inc (hl)		;6e18
	ld de,094c0h		;6e19
	ld de,08408h		;6e1c
	ld d,00eh		;6e1f
	ld c,h			;6e21
	sub a			;6e22
	inc d			;6e23
	ld bc,01498h		;6e24
	ret m			;6e27
	ld d,016h		;6e28
	adc a,h			;6e2a
	ld (de),a		;6e2b
	ld a,(de)		;6e2c
	inc h			;6e2d
	ld de,0341ch		;6e2e
	ld (de),a		;6e31
	inc h			;6e32
	call po,02616h		;6e33
	xor h			;6e36
	ld d,02ah		;6e37
	xor h			;6e39
	inc d			;6e3a
	ld l,034h		;6e3b
	ld de,08434h		;6e3d
	inc de			;6e40
	ld (hl),024h		;6e41
	ld de,08436h		;6e43
	ld d,03eh		;6e46
	call z,04210h		;6e48
	inc h			;6e4b
	ld d,046h		;6e4c
	inc l			;6e4e
	ld de,09450h		;6e4f
	inc d			;6e52
	ld d,d			;6e53
	sub h			;6e54
	sbc a,e			;6e55
	ld d,h			;6e56
	ld bc,0549ch		;6e57
	ret m			;6e5a
	ld d,056h		;6e5b
	call z,05a16h		;6e5d
	call z,05e16h		;6e60
	call z,06631h		;6e63
	and h			;6e66
	inc de			;6e67
	ld l,b			;6e68
	or h			;6e69
	ld d,072h		;6e6a
	ld c,h			;6e6c
	ld d,076h		;6e6d
	ld c,h			;6e6f
	sbc a,e			;6e70
	add a,h			;6e71
	ld bc,0849ch		;6e72
	ret m			;6e75
	ld d,086h		;6e76
	ld c,h			;6e78
	ld d,086h		;6e79
	xor h			;6e7b
	ld d,08eh		;6e7c
	ld l,h			;6e7e
	ld d,08eh		;6e7f
	adc a,h			;6e81
	ld de,0c496h		;6e82
	ld (de),a		;6e85
	sbc a,b			;6e86
	ld b,h			;6e87
	ld d,09eh		;6e88
	adc a,h			;6e8a
	ld d,0a6h		;6e8b
	ld l,h			;6e8d
	ld d,0aah		;6e8e
	ld l,h			;6e90
	ld de,0c4b0h		;6e91
	sub a			;6e94
	or b			;6e95
	ld bc,0b098h		;6e96
	ret m			;6e99
	ld d,0b2h		;6e9a
	xor h			;6e9c
	djnz $-72		;6e9d
	ld h,h			;6e9f
	ld sp,044c0h		;6ea0
	ld de,0b408h		;6ea3
	ld de,0440eh		;6ea6
	ld de,0940eh		;6ea9
	inc de			;6eac
	jr $+70			;6ead
	ld (de),a		;6eaf
	jr $-42			;6eb0
	inc d			;6eb2
	jr nz,$-74		;6eb3
	inc d			;6eb5
	inc h			;6eb6
	ld d,h			;6eb7
	ld de,0842ch		;6eb8
	inc d			;6ebb
	ld l,084h		;6ebc
	ld de,0a436h		;6ebe
	ld de,05438h		;6ec1
	ld de,0a43eh		;6ec4
	ld (de),a		;6ec7
	ld a,0c4h		;6ec8
	ld de,05440h		;6eca
	ld de,0a442h		;6ecd
	ld de,05444h		;6ed0
	ld (de),a		;6ed3
	ld d,b			;6ed4
	call po,05414h		;6ed5
	add a,h			;6ed8
	ld de,0145ah		;6ed9
	inc de			;6edc
	ld e,h			;6edd
	inc d			;6ede
	ld de,0545ch		;6edf
	inc d			;6ee2
	ld e,h			;6ee3
	and h			;6ee4
	ld de,0a45eh		;6ee5
	inc d			;6ee8
	ld l,(hl)		;6ee9
	ld b,h			;6eea
	ld de,06470h		;6eeb
	ld de,0c470h		;6eee
	inc d			;6ef1
	ld (hl),d		;6ef2
	ld (hl),h		;6ef3
	ld (de),a		;6ef4
	ld (hl),h		;6ef5
	ld (hl),h		;6ef6
	ld de,07480h		;6ef7
	ld (de),a		;6efa
	add a,d			;6efb
	inc h			;6efc
	ld de,07482h		;6efd
	inc de			;6f00
	add a,(hl)		;6f01
	call nz,09012h		;6f02
	inc d			;6f05
	inc d			;6f06
	sbc a,b			;6f07
	ld d,h			;6f08
	ld de,08498h		;6f09
	inc d			;6f0c
	sbc a,h			;6f0d
	ld d,h			;6f0e
	ld de,054a0h		;6f0f
	inc d			;6f12
	and h			;6f13
	and h			;6f14
	inc d			;6f15
	xor (hl)		;6f16
	sub h			;6f17
	inc d			;6f18
	xor (hl)		;6f19
	and h			;6f1a
	ld de,044b4h		;6f1b
	ld de,0a4b8h		;6f1e
	inc d			;6f21
	cp h			;6f22
	ld h,h			;6f23
	jr nc,$+48		;6f24
	ld sp,0342fh		;6f26
	ld (03335h),a		;6f29
	jr c,$+56		;6f2c
	add hl,sp		;6f2e
	scf			;6f2f
	inc a			;6f30
	ld a,(03b3dh)		;6f31
	ld c,a			;6f34
	ld c,h			;6f35
	ld c,l			;6f36
	ld c,(hl)		;6f37
	and b			;6f38
	and c			;6f39
	ld bc,02801h		;6f3a
	ld a,029h		;6f3d
	daa			;6f3f
	dec l			;6f40
	inc l			;6f41
	dec hl			;6f42
	ld hl,(0093ah)		;6f43
	ret po			;6f46
	and 03fh		;6f47
	cp 02ch			;6f49
	ret nz			;6f4b
	ld a,003h		;6f4c
	call 00141h		;6f4e
	cp 0bfh			;6f51
	ld a,001h		;6f53
	call z,06f6bh		;6f55
	ld a,004h		;6f58
	call 00141h		;6f5a
	cp 0f7h			;6f5d
	jr z,$+16		;6f5f
	ld a,005h		;6f61
	call 00141h		;6f63
	cp 0bfh			;6f66
	ret nz			;6f68
	ld a,010h		;6f69
	ld (0e069h),a		;6f6b
	ret			;6f6e
	ld a,026h		;6f6f
	ld (0e060h),a		;6f71
	ret			;6f74
	ld a,(0e09eh)		;6f75
	and a			;6f78
	jr nz,$+6		;6f79
	ld (0e1e1h),a		;6f7b
	ret			;6f7e
	ld a,(0e003h)		;6f7f
	and 01eh		;6f82
	ret nz			;6f84
	ld hl,0e1e1h		;6f85
	ld a,(hl)		;6f88
	and 07fh		;6f89
	jr z,$+4		;6f8b
	dec (hl)		;6f8d
	ret			;6f8e
	ld a,(hl)		;6f8f
	rla			;6f90
	jr c,$+27		;6f91
	ld a,(0e0a0h)		;6f93
	and a			;6f96
	ret nz			;6f97
	ld a,(0e0b0h)		;6f98
	and a			;6f9b
	ret nz			;6f9c
	ld hl,0e100h		;6f9d
	ld b,007h		;6fa0
	ld a,(hl)		;6fa2
	and a			;6fa3
	ret nz			;6fa4
	ld a,020h		;6fa5
	call 0405bh		;6fa7
	djnz $-8		;6faa
	ld ix,0e0a0h		;6fac
	ld a,(ix+000h)		;6fb0
	and a			;6fb3
	jr z,$+11		;6fb4
	ld ix,0e0b0h		;6fb6
	ld a,(ix+000h)		;6fba
	and a			;6fbd
	ret nz			;6fbe
	push ix			;6fbf
	pop hl			;6fc1
	xor a			;6fc2
	ld b,008h		;6fc3
	ld (hl),a		;6fc5
	inc hl			;6fc6
	djnz $-2		;6fc7
	ld a,(0e062h)		;6fc9
	ld hl,0704bh		;6fcc
	call 04071h		;6fcf
	ld hl,0e09fh		;6fd2
	ld a,(hl)		;6fd5
	add a,a			;6fd6
	call 04060h		;6fd7
	ld a,(de)		;6fda
	ld c,a			;6fdb
	ld (ix+000h),a		;6fdc
	inc de			;6fdf
	ld a,(de)		;6fe0
	rra			;6fe1
	rra			;6fe2
	rra			;6fe3
	rra			;6fe4
	and 00fh		;6fe5
	ld b,a			;6fe7
	ld a,(0e068h)		;6fe8
	and a			;6feb
	jr z,$+8		;6fec
	ld a,b			;6fee
	dec a			;6fef
	jr z,$+4		;6ff0
	inc b			;6ff2
	inc b			;6ff3
	ld (ix+006h),b		;6ff4
	ld a,(de)		;6ff7
	and 00fh		;6ff8
	add a,a			;6ffa
	bit 5,c			;6ffb
	jr z,$+4		;6ffd
	set 7,a			;6fff
	ld (0e1e1h),a		;7001
	ld a,(ix+000h)		;7004
	and a			;7007
	jr z,$+6		;7008
	ld (ix+008h),001h	;700a
	ld a,(0e062h)		;700e
	ld de,07043h		;7011
	call 04060h		;7014
	ld a,(de)		;7017
	ld c,a			;7018
	inc (hl)		;7019
	ld a,(hl)		;701a
	cp c			;701b
	jr c,$+4		;701c
	ld (hl),000h		;701e
	ld a,(ix+000h)		;7020
	bit 6,a			;7023
	ret z			;7025
	ld hl,07033h		;7026
	and 00fh		;7029
	call 0405bh		;702b
	ld a,(hl)		;702e
	ld (ix+003h),a		;702f
	ret			;7032
	ld bc,00505h		;7033
	dec b			;7036
	dec b			;7037
	dec b			;7038
	ld bc,00601h		;7039
	inc b			;703c
	inc b			;703d
	ld bc,00101h		;703e
	ld bc,02201h		;7041
	add hl,hl		;7044
	add hl,hl		;7045
	ld h,024h		;7046
	ld hl,0231eh		;7048
	ld e,e			;704b
	ld (hl),b		;704c
	sbc a,a			;704d
	ld (hl),b		;704e
	pop af			;704f
	ld (hl),b		;7050
	ld b,e			;7051
	ld (hl),c		;7052
	adc a,a			;7053
	ld (hl),c		;7054
	rst 10h			;7055
	ld (hl),c		;7056
	add hl,de		;7057
	ld (hl),d		;7058
	ld d,l			;7059
	ld (hl),d		;705a
	ld c,060h		;705b
	ld l,044h		;705d
	ld b,c			;705f
	djnz $+67		;7060
	djnz $+67		;7062
	djnz $+16		;7064
	ld b,b			;7066
	ld (bc),a		;7067
	ld b,b			;7068
	ld (bc),a		;7069
	ld b,b			;706a
	ld l,024h		;706b
	ld bc,00120h		;706d
	ld b,b			;7070
	ld bc,00040h		;7071
	inc de			;7074
	add hl,bc		;7075
	ld b,b			;7076
	adc a,c			;7077
	ld b,b			;7078
	xor (hl)		;7079
	ld h,h			;707a
	add a,c			;707b
	ld h,b			;707c
	ld b,c			;707d
	djnz $-61		;707e
	djnz $-61		;7080
	djnz $-80		;7082
	inc hl			;7084
	jp nz,0c210h		;7085
	djnz $-60		;7088
	djnz $-112		;708a
	add a,b			;708c
	nop			;708d
	inc de			;708e
	xor c			;708f
	ld b,d			;7090
	add a,c			;7091
	ld b,b			;7092
	add a,c			;7093
	ld b,b			;7094
	xor (hl)		;7095
	ld b,e			;7096
	add a,c			;7097
	ld h,b			;7098
	and c			;7099
	ld h,c			;709a
	adc a,c			;709b
	ld b,b			;709c
	add a,c			;709d
	and b			;709e
	ld l,052h		;709f
	add a,d			;70a1
	ld h,b			;70a2
	add a,d			;70a3
	ld h,b			;70a4
	inc b			;70a5
	ld b,b			;70a6
	add a,h			;70a7
	ld b,b			;70a8
	jp (hl)			;70a9
	inc de			;70aa
	add a,h			;70ab
	ld b,b			;70ac
	xor (hl)		;70ad
	ld b,e			;70ae
	ret			;70af
	djnz $-53		;70b0
	djnz $+2		;70b2
	inc de			;70b4
	inc c			;70b5
	jr nz,$+46		;70b6
	ld b,e			;70b8
	add a,d			;70b9
	and b			;70ba
	rlca			;70bb
	jr nc,$-80		;70bc
	ld b,h			;70be
	pop bc			;70bf
	djnz $-61		;70c0
	djnz $-61		;70c2
	djnz $-87		;70c4
	inc (hl)		;70c6
	pop bc			;70c7
	djnz $+2		;70c8
	ld (de),a		;70ca
	dec bc			;70cb
	jr nz,$-29		;70cc
	ld de,0200bh		;70ce
	pop hl			;70d1
	inc de			;70d2
	dec bc			;70d3
	jr nc,$-80		;70d4
	add a,d			;70d6
	dec bc			;70d7
	jr nc,$-94		;70d8
	ld (0300bh),hl		;70da
	and b			;70dd
	ld sp,0400bh		;70de
	and b			;70e1
	ld b,c			;70e2
	dec bc			;70e3
	ld h,b			;70e4
	and c			;70e5
	and c			;70e6
	inc bc			;70e7
	add a,b			;70e8
	and d			;70e9
	and c			;70ea
	inc bc			;70eb
	add a,b			;70ec
	and e			;70ed
	add a,c			;70ee
	dec bc			;70ef
	ld h,b			;70f0
	ld c,d			;70f1
	djnz $+76		;70f2
	djnz $+76		;70f4
	djnz $+76		;70f6
	djnz $+13		;70f8
	ld h,b			;70fa
	xor (hl)		;70fb
	ld b,d			;70fc
	inc bc			;70fd
	ld h,b			;70fe
	add a,e			;70ff
	ld b,b			;7100
	pop hl			;7101
	ld (de),a		;7102
	dec bc			;7103
	ld b,b			;7104
	pop hl			;7105
	ld de,0400bh		;7106
	pop hl			;7109
	ld de,0600bh		;710a
	pop hl			;710d
	ld de,0600bh		;710e
	inc l			;7111
	ld b,h			;7112
	add a,h			;7113
	ld b,b			;7114
	call nz,0c410h		;7115
	djnz $-58		;7118
	djnz $-80		;711a
	ld (042a0h),hl		;711c
	adc a,(hl)		;711f
	jr nc,$-87		;7120
	ld b,d			;7122
	adc a,d			;7123
	and b			;7124
	call po,0ca12h		;7125
	djnz $-26		;7128
	ld (de),a		;712a
	dec bc			;712b
	ld b,b			;712c
	adc a,e			;712d
	ld b,b			;712e
	xor (hl)		;712f
	ld b,d			;7130
	adc a,d			;7131
	add a,b			;7132
	and a			;7133
	ld h,c			;7134
	adc a,e			;7135
	and b			;7136
	inc l			;7137
	ld b,c			;7138
	add a,c			;7139
	and b			;713a
	and d			;713b
	and c			;713c
	adc a,d			;713d
	and b			;713e
	xor e			;713f
	and c			;7140
	add a,a			;7141
	ld b,b			;7142
	xor (hl)		;7143
	ld b,d			;7144
	add a,c			;7145
	ld b,b			;7146
	pop hl			;7147
	ld de,04084h		;7148
	pop bc			;714b
	djnz $-29		;714c
	ld de,06084h		;714e
	xor (hl)		;7151
	add a,e			;7152
	add a,b			;7153
	ld h,b			;7154
	inc l			;7155
	ld b,d			;7156
	adc a,d			;7157
	and b			;7158
	jp po,0ca11h		;7159
	djnz $+2		;715c
	inc d			;715e
	xor (hl)		;715f
	ld b,d			;7160
	dec bc			;7161
	ld h,b			;7162
	pop bc			;7163
	djnz $-61		;7164
	djnz $-29		;7166
	ld de,0608bh		;7168
	and c			;716b
	add a,c			;716c
	adc a,e			;716d
	add a,b			;716e
	inc l			;716f
	ld d,d			;7170
	add a,b			;7171
	add a,b			;7172
	ex (sp),hl		;7173
	ld de,06080h		;7174
	ex (sp),hl		;7177
	ld de,08080h		;7178
	call po,08111h		;717b
	ld h,b			;717e
	call po,08211h		;717f
	ld h,b			;7182
	xor c			;7183
	ld b,c			;7184
	jp z,0ea10h		;7185
	ld de,010c3h		;7188
	jp pe,0c311h		;718b
	djnz $+74		;718e
	djnz $+74		;7190
	djnz $-80		;7192
	ld b,c			;7194
	ld c,b			;7195
	djnz $-80		;7196
	ld h,d			;7198
	adc a,c			;7199
	ld b,b			;719a
	adc a,c			;719b
	ld b,c			;719c
	adc a,b			;719d
	and b			;719e
	adc a,b			;719f
	ld b,b			;71a0
	nop			;71a1
	ld (de),a		;71a2
	xor (hl)		;71a3
	ld b,c			;71a4
	dec h			;71a5
	ld h,b			;71a6
	ld b,l			;71a7
	djnz $+71		;71a8
	djnz $+46		;71aa
	ld b,c			;71ac
	add a,a			;71ad
	ld b,b			;71ae
	inc l			;71af
	ld b,c			;71b0
	add a,l			;71b1
	add a,b			;71b2
	add a,l			;71b3
	ld h,b			;71b4
	inc l			;71b5
	ld hl,010c5h		;71b6
	inc l			;71b9
	ld hl,010c5h		;71ba
	and a			;71bd
	ld b,c			;71be
	adc a,c			;71bf
	ld b,b			;71c0
	ret z			;71c1
	djnz $-54		;71c2
	djnz $-22		;71c4
	ld de,010c5h		;71c6
	xor b			;71c9
	and c			;71ca
	push bc			;71cb
	djnz $+46		;71cc
	ld b,c			;71ce
	add a,l			;71cf
	ld h,b			;71d0
	and l			;71d1
	ld b,c			;71d2
	inc c			;71d3
	ld b,c			;71d4
	adc a,b			;71d5
	add a,b			;71d6
	adc a,c			;71d7
	add a,b			;71d8
	xor b			;71d9
	add a,c			;71da
	add a,d			;71db
	add a,b			;71dc
	jp nz,0c210h		;71dd
	djnz $-28		;71e0
	ld de,04089h		;71e2
	and (hl)		;71e5
	ld c,b			;71e6
	add a,c			;71e7
	ld h,b			;71e8
	and (hl)		;71e9
	ld (de),a		;71ea
	pop bc			;71eb
	djnz $-61		;71ec
	djnz $-79		;71ee
	or d			;71f0
	add a,l			;71f1
	ret p			;71f2
	push hl			;71f3
	ld de,06089h		;71f4
	xor a			;71f7
	ld h,d			;71f8
	add a,d			;71f9
	ret nc			;71fa
	push bc			;71fb
	djnz $-57		;71fc
	djnz $-121		;71fe
	add a,c			;7200
	add a,c			;7201
	and b			;7202
	pop bc			;7203
	djnz $-79		;7204
	ld h,c			;7206
	add a,l			;7207
	and b			;7208
	and d			;7209
	and c			;720a
	add a,l			;720b
	and b			;720c
	and l			;720d
	ld b,c			;720e
	add a,d			;720f
	ld h,b			;7210
	and d			;7211
	and c			;7212
	add a,l			;7213
	and b			;7214
	and e			;7215
	and c			;7216
	add a,l			;7217
	and b			;7218
	dec c			;7219
	add a,b			;721a
	ret z			;721b
	djnz $-54		;721c
	djnz $-94		;721e
	add a,c			;7220
	adc a,e			;7221
	add a,b			;7222
	adc a,l			;7223
	ld h,b			;7224
	ret pe			;7225
	ld de,0808bh		;7226
	ret z			;7229
	djnz $-54		;722a
	djnz $+46		;722c
	ld b,d			;722e
	add a,b			;722f
	ld h,b			;7230
	xor l			;7231
	and d			;7232
	adc a,e			;7233
	ret nz			;7234
	adc a,l			;7235
	ld b,b			;7236
	inc l			;7237
	ld b,c			;7238
	adc a,b			;7239
	ld b,b			;723a
	adc a,b			;723b
	ld h,b			;723c
	and b			;723d
	add a,c			;723e
	add a,h			;723f
	add a,b			;7240
	xor b			;7241
	and c			;7242
	adc a,l			;7243
	and b			;7244
	and h			;7245
	add a,c			;7246
	adc a,l			;7247
	ret nz			;7248
	xor b			;7249
	and c			;724a
	adc a,e			;724b
	and c			;724c
	adc a,l			;724d
	add a,b			;724e
	and b			;724f
	and c			;7250
	adc a,e			;7251
	and c			;7252
	adc a,l			;7253
	add a,b			;7254
	xor e			;7255
	jp 08081h		;7256
	and c			;7259
	add a,d			;725a
	xor c			;725b
	ld h,d			;725c
	adc a,e			;725d
	ld b,b			;725e
	xor b			;725f
	and d			;7260
	adc a,e			;7261
	add a,b			;7262
	and l			;7263
	ld b,d			;7264
	add a,c			;7265
	ld b,b			;7266
	and c			;7267
	add a,c			;7268
	add a,b			;7269
	add a,b			;726a
	xor b			;726b
	add a,c			;726c
	adc a,e			;726d
	add a,b			;726e
	nop			;726f
	ld (de),a		;7270
	inc l			;7271
	ld b,c			;7272
	and b			;7273
	ld h,c			;7274
	adc a,e			;7275
	ld h,b			;7276
	and c			;7277
	add a,c			;7278
	and d			;7279
	add a,c			;727a
	add a,e			;727b
	add a,b			;727c
	xor e			;727d
	and c			;727e
	inc l			;727f
	ld b,c			;7280
	xor l			;7281
	ld h,d			;7282
	add a,c			;7283
	ld b,b			;7284
	and l			;7285
	ld h,c			;7286
	adc a,d			;7287
	ld h,b			;7288
	xor b			;7289
	and c			;728a
	add a,l			;728b
	add a,b			;728c
	nop			;728d
	ld de,0822ch		;728e
	and b			;7291
	ld b,c			;7292
	adc a,e			;7293
	add a,b			;7294
	xor e			;7295
	add a,c			;7296
	and l			;7297
	ld h,c			;7298
	adc a,c			;7299
	ld d,b			;729a
	ld a,(0e091h)		;729b
	cp 0c8h			;729e
	ret nc			;72a0
	ld iy,0e0a0h		;72a1
	ld b,002h		;72a5
	push bc			;72a7
	call 072b4h		;72a8
	pop bc			;72ab
	ld de,00010h		;72ac
	add iy,de		;72af
	djnz $-10		;72b1
	ret			;72b3
	ld a,(iy+000h)		;72b4
	and a			;72b7
	ret z			;72b8
	ld a,(iy+008h)		;72b9
	and a			;72bc
	ret nz			;72bd
	ld a,(iy+005h)		;72be
	and a			;72c1
	jr nz,$+12		;72c2
	ld a,(iy+001h)		;72c4
	and a			;72c7
	jr z,$+36		;72c8
	dec (iy+001h)		;72ca
	ret			;72cd
	ld a,(iy+004h)		;72ce
	and a			;72d1
	jr z,$+6		;72d2
	dec (iy+004h)		;72d4
	ret			;72d7
	ld hl,073ceh		;72d8
	ld a,(iy+000h)		;72db
	and 00fh		;72de
	call 0405bh		;72e0
	ld a,(hl)		;72e3
	ld (iy+004h),a		;72e4
	dec (iy+005h)		;72e7
	jr $+16			;72ea
	ld a,(iy+000h)		;72ec
	bit 6,a			;72ef
	jr z,$+9		;72f1
	ld a,(iy+003h)		;72f3
	ld (iy+005h),a		;72f6
	ret			;72f9
	call 073deh		;72fa
	ret nz			;72fd
	ld (ix+000h),001h	;72fe
	ld (ix+011h),0ffh	;7302
	ld a,(iy+007h)		;7306
	ld (ix+016h),a		;7309
	ld a,(iy+000h)		;730c
	ld (ix+001h),a		;730f
	bit 6,a			;7312
	jr z,$+59		;7314
	ld hl,0e1e2h		;7316
	ld a,(hl)		;7319
	push af			;731a
	ld c,a			;731b
	add a,a			;731c
	add a,c			;731d
	inc hl			;731e
	call 0405bh		;731f
	pop af			;7322
	rla			;7323
	rla			;7324
	rla			;7325
	rla			;7326
	and 0f0h		;7327
	ld c,a			;7329
	ld a,(hl)		;732a
	ld b,a			;732b
	or c			;732c
	ld (ix+011h),a		;732d
	inc (hl)		;7330
	inc hl			;7331
	ld a,(ix+001h)		;7332
	and 00fh		;7335
	ld de,07033h		;7337
	call 04060h		;733a
	ld a,(de)		;733d
	cp 001h			;733e
	jr nz,$+4		;7340
	ld a,0ffh		;7342
	ld (hl),a		;7344
	ld a,b			;7345
	and a			;7346
	jr nz,$+8		;7347
	ld a,(0e604h)		;7349
	ld (0e1f2h),a		;734c
	ld a,(iy+000h)		;734f
	and 00fh		;7352
	ld hl,073f5h		;7354
	call 0405bh		;7357
	ld a,(hl)		;735a
	ld (ix+003h),a		;735b
	ld hl,07405h		;735e
	ld a,(iy+002h)		;7361
	ld c,a			;7364
	and 007h		;7365
	call 0405bh		;7367
	ld a,c			;736a
	and a			;736b
	ld c,(hl)		;736c
	jr nz,$+23		;736d
	ld a,(ix+001h)		;736f
	bit 6,a			;7372
	ld a,(0e1f2h)		;7374
	jr nz,$+5		;7377
	ld a,(0e604h)		;7379
	cp 087h			;737c
	ld c,050h		;737e
	jr nc,$+4		;7380
	ld c,0b0h		;7382
	ld (ix+005h),c		;7384
	ld hl,0740dh		;7387
	ld a,(ix+001h)		;738a
	and 00fh		;738d
	call 0405bh		;738f
	ld a,(hl)		;7392
	ld (iy+001h),a		;7393
	ld a,(iy+005h)		;7396
	and a			;7399
	ret nz			;739a
	ld a,(iy+000h)		;739b
	bit 6,a			;739e
	jr z,$+25		;73a0
	ld hl,0e1e2h		;73a2
	inc (hl)		;73a5
	ld a,(hl)		;73a6
	and 003h		;73a7
	ld (hl),a		;73a9
	ld hl,0e1e3h		;73aa
	ld c,a			;73ad
	add a,a			;73ae
	add a,c			;73af
	call 0405bh		;73b0
	xor a			;73b3
	ld (hl),a		;73b4
	inc hl			;73b5
	ld (hl),a		;73b6
	inc hl			;73b7
	ld (hl),a		;73b8
	inc (iy+002h)		;73b9
	ld a,(iy+002h)		;73bc
	cp (iy+006h)		;73bf
	ret c			;73c2
	xor a			;73c3
	ld (iy+000h),a		;73c4
	ld (iy+001h),a		;73c7
	ld (iy+002h),a		;73ca
	ret			;73cd
	ld bc,00505h		;73ce
	dec b			;73d1
	rlca			;73d2
	rlca			;73d3
	ld bc,00801h		;73d4
	djnz $+8		;73d7
	ld bc,00101h		;73d9
	ld bc,02101h		;73dc
	nop			;73df
	pop hl			;73e0
	ld b,007h		;73e1
	ld a,(hl)		;73e3
	and a			;73e4
	jr z,$+12		;73e5
	ld a,020h		;73e7
	call 0405bh		;73e9
	djnz $-9		;73ec
	or 001h			;73ee
	ret			;73f0
	push hl			;73f1
	pop ix			;73f2
	ret			;73f4
	ret p			;73f5
	ret p			;73f6
	ret p			;73f7
	adc a,b			;73f8
	ret p			;73f9
	ret p			;73fa
	ret p			;73fb
	ret p			;73fc
	ret p			;73fd
	ret p			;73fe
	djnz $+3		;73ff
	djnz $+3		;7401
	ret p			;7403
	ld bc,02850h		;7404
	or b			;7407
	add a,b			;7408
	ret c			;7409
	ld a,a			;740a
	or b			;740b
	jr z,$+42		;740c
	djnz $+18		;740e
	djnz $+18		;7410
	djnz $+114		;7412
	ld d,b			;7414
	djnz $+26		;7415
	jr nz,$+18		;7417
	jr nc,$+42		;7419
	ld b,b			;741b
	jr nc,$+60		;741c
	or b			;741e
	ex (sp),hl		;741f
	and a			;7420
	ret nz			;7421
	ld a,(0e091h)		;7422
	cp 0cah			;7425
	call nc,06924h		;7427
	call 0772ah		;742a
	ld a,(0e663h)		;742d
	and a			;7430
	jr nz,$+8		;7431
	call 06f75h		;7433
	call 0729bh		;7436
	ld ix,0e100h		;7439
	ld b,007h		;743d
	push bc			;743f
	call 075dah		;7440
	call 0749ah		;7443
	call 07452h		;7446
	pop bc			;7449
	ld de,00020h		;744a
	add ix,de		;744d
	djnz $-16		;744f
	ret			;7451
	call 0748ah		;7452
	ret z			;7455
	cp (hl)			;7456
	ret nc			;7457
	ld a,(ix+001h)		;7458
	and 00fh		;745b
	cp 007h			;745d
	jr nz,$+8		;745f
	ld a,(ix+000h)		;7461
	cp 004h			;7464
	ret nc			;7466
	ld iy,0e600h		;7467
	call 08755h		;746b
	ret c			;746e
	ld iy,0e600h		;746f
	ld a,(iy+000h)		;7473
	cp 002h			;7476
	ret nc			;7478
	ld a,(iy+00ch)		;7479
	cp 002h			;747c
	jr c,$+6		;747e
	ret z			;7480
	jp 07571h		;7481
	call 08338h		;7484
	jp 07592h		;7487
	ld a,(ix+001h)		;748a
	and 00fh		;748d
	ld hl,075aah		;748f
	call 0405bh		;7492
	ld a,(ix+000h)		;7495
	and a			;7498
	ret			;7499
	call 0748ah		;749a
	ret z			;749d
	cp (hl)			;749e
	ret nc			;749f
	ld a,(ix+001h)		;74a0
	and 00fh		;74a3
	jr nz,$+19		;74a5
	ld a,(0e663h)		;74a7
	and a			;74aa
	jr nz,$+57		;74ab
	ld a,(ix+000h)		;74ad
	cp 003h			;74b0
	ret c			;74b2
	cp 005h			;74b3
	ret nc			;74b5
	jr $+46			;74b6
	cp 00fh			;74b8
	jr nz,$+14		;74ba
	ld a,(ix+000h)		;74bc
	cp 003h			;74bf
	jr c,$+7		;74c1
	cp 005h			;74c3
	ret nz			;74c5
	jr $+30			;74c6
	cp 007h			;74c8
	jr nz,$+10		;74ca
	ld a,(ix+000h)		;74cc
	cp 004h			;74cf
	ret nc			;74d1
	jr $+18			;74d2
	cp 00ch			;74d4
	jr nz,$+14		;74d6
	ld a,(0e663h)		;74d8
	and a			;74db
	jr nz,$+8		;74dc
	ld a,(ix+000h)		;74de
	cp 003h			;74e1
	ret nc			;74e3
	ld hl,0e620h		;74e4
	ld a,(hl)		;74e7
	rla			;74e8
	jr c,$+10		;74e9
	call 08767h		;74eb
	ld hl,0e625h		;74ee
	jr nc,$+30		;74f1
	ld hl,0e630h		;74f3
	ld a,(hl)		;74f6
	rla			;74f7
	jr c,$+10		;74f8
	call 08767h		;74fa
	ld hl,0e635h		;74fd
	jr nc,$+15		;7500
	ld hl,0e640h		;7502
	ld a,(hl)		;7505
	rla			;7506
	ret c			;7507
	call 08767h		;7508
	ld hl,0e645h		;750b
	ret c			;750e
	ld a,(hl)		;750f
	srl a			;7510
	ld b,a			;7512
	cp 003h			;7513
	jr nc,$+9		;7515
	dec l			;7517
	dec l			;7518
	dec l			;7519
	dec l			;751a
	dec l			;751b
	set 7,(hl)		;751c
	ld a,(ix+001h)		;751e
	and 00fh		;7521
	cp 00fh			;7523
	jr nz,$+24		;7525
	ld a,(ix+000h)		;7527
	cp 003h			;752a
	jr nc,$+17		;752c
	ld a,(0e663h)		;752e
	and a			;7531
	jr nz,$+11		;7532
	ld (ix+000h),003h	;7534
	ld a,00ah		;7538
	jp 0490ch		;753a
	cp 007h			;753d
	jr nz,$+22		;753f
	dec (ix+014h)		;7541
	jr z,$+17		;7544
	ld a,(0e663h)		;7546
	and a			;7549
	jr nz,$+11		;754a
	ld (ix+000h),004h	;754c
	ld a,00ah		;7550
	jp 0490ch		;7552
	cp 00ch			;7555
	jr nz,$+17		;7557
	ld a,(0e663h)		;7559
	and a			;755c
	jr nz,$+11		;755d
	ld (ix+000h),003h	;755f
	ld a,04dh		;7563
	jp 04901h		;7565
	ld a,b			;7568
	cp 003h			;7569
	jr nc,$+6		;756b
	dec (ix+00bh)		;756d
	ret nz			;7570
	ld c,000h		;7571
	ld a,(0e663h)		;7573
	and a			;7576
	jr z,$+4		;7577
	ld c,010h		;7579
	ld hl,075bah		;757b
	ld a,(ix+001h)		;757e
	and 00fh		;7581
	add a,c			;7583
	call 0405bh		;7584
	ld l,(hl)		;7587
	ld h,000h		;7588
	add hl,hl		;758a
	add hl,hl		;758b
	add hl,hl		;758c
	add hl,hl		;758d
	ex de,hl		;758e
	call 042adh		;758f
	ld a,(ix+001h)		;7592
	and 00fh		;7595
	ld hl,075aah		;7597
	call 0405bh		;759a
	ld a,(hl)		;759d
	ld (ix+000h),a		;759e
	ld (ix+00eh),006h	;75a1
	ld a,04dh		;75a5
	jp 04901h		;75a7
	ld b,003h		;75aa
	inc bc			;75ac
	inc b			;75ad
	inc b			;75ae
	rlca			;75af
	inc bc			;75b0
	ex af,af'		;75b1
	inc b			;75b2
	inc b			;75b3
	dec b			;75b4
	inc bc			;75b5
	dec b			;75b6
	inc b			;75b7
	inc bc			;75b8
	ld b,010h		;75b9
	dec b			;75bb
	dec b			;75bc
	dec b			;75bd
	dec b			;75be
	jr nz,$+7		;75bf
	jr nz,$+18		;75c1
	djnz $+18		;75c3
	jr nc,$+2		;75c5
	jr nz,$+3		;75c7
	djnz $+34		;75c9
	djnz $+18		;75cb
	djnz $+18		;75cd
	ld b,b			;75cf
	djnz $+66		;75d0
	jr nz,$+34		;75d2
	jr nz,$+82		;75d4
	jr nz,$+66		;75d6
	dec b			;75d8
	jr nz,$+60		;75d9
	ld h,e			;75db
	and 0a7h		;75dc
	jr z,$+7		;75de
	call 0748ah		;75e0
	cp (hl)			;75e3
	ret c			;75e4
	ld a,(ix+001h)		;75e5
	and 00fh		;75e8
	ld hl,075f3h		;75ea
	call 04079h		;75ed
	jp 04065h		;75f0
	or l			;75f3
	ld a,e			;75f4
	ld d,e			;75f5
	ld a,c			;75f6
	ld (hl),l		;75f7
	ld a,d			;75f8
	call nz,0257ah		;75f9
	ld a,h			;75fc
	push af			;75fd
	ld a,h			;75fe
	adc a,l			;75ff
	ld a,l			;7600
	xor a			;7601
	ld a,l			;7602
	jr z,$+125		;7603
	xor e			;7605
	ld a,(hl)		;7606
	dec e			;7607
	ld a,a			;7608
	exx			;7609
	ld a,a			;760a
	inc b			;760b
	add a,b			;760c
	sbc a,h			;760d
	add a,b			;760e
	ex af,af'		;760f
	add a,c			;7610
	daa			;7611
	add a,c			;7612
	ld hl,0e103h		;7613
	ld b,007h		;7616
	ld (hl),0e0h		;7618
	ld a,020h		;761a
	call 0405bh		;761c
	djnz $-7		;761f
	ret			;7621
	ld b,004h		;7622
	ld hl,0e620h		;7624
	ld a,(hl)		;7627
	rla			;7628
	ret nc			;7629
	ld a,010h		;762a
	call 0405bh		;762c
	djnz $-8		;762f
	scf			;7631
	ret			;7632
	ld a,(ix+003h)		;7633
	cp 0c0h			;7636
	ret nc			;7638
	ld a,(ix+001h)		;7639
	and 00fh		;763c
	ld c,a			;763e
	ld hl,076edh		;763f
	call 0405bh		;7642
	ld b,(hl)		;7645
	ld a,(0e061h)		;7646
	dec a			;7649
	and 00fh		;764a
	cp 003h			;764c
	jr nc,$+3		;764e
	dec b			;7650
	ld a,c			;7651
	ld hl,076cdh		;7652
	call 04079h		;7655
	ld a,(0e061h)		;7658
	dec a			;765b
	and 00fh		;765c
	cp 003h			;765e
	ld a,(ix+00fh)		;7660
	jr nc,$+5		;7663
	cp 0ffh			;7665
	ret z			;7667
	inc a			;7668
	ld (ix+00fh),a		;7669
	cp (hl)			;766c
	jr z,$+6		;766d
	inc hl			;766f
	djnz $-4		;7670
	ret			;7672
	ld a,(0e602h)		;7673
	add a,008h		;7676
	sub (ix+003h)		;7678
	jr nc,$+4		;767b
	neg			;767d
	cp 018h			;767f
	ret c			;7681
	ld a,(0e604h)		;7682
	add a,008h		;7685
	sub (ix+005h)		;7687
	jr nc,$+4		;768a
	neg			;768c
	cp 018h			;768e
	ret c			;7690
	ld b,(ix+001h)		;7691
	ld a,(0e068h)		;7694
	and a			;7697
	jr nz,$+22		;7698
	ld a,(0e062h)		;769a
	cp 004h			;769d
	jr nc,$+15		;769f
	ld a,b			;76a1
	rla			;76a2
	ret nc			;76a3
	ld a,(ix+011h)		;76a4
	cp 0ffh			;76a7
	jr z,$+5		;76a9
	and 001h		;76ab
	ret nz			;76ad
	ld a,b			;76ae
	and 00fh		;76af
	ld hl,076bdh		;76b1
	call 0405bh		;76b4
	ld c,004h		;76b7
	ld b,(hl)		;76b9
	jp 0857fh		;76ba
	dec b			;76bd
	ld (bc),a		;76be
	ld (bc),a		;76bf
	ld (bc),a		;76c0
	inc bc			;76c1
	inc b			;76c2
	rlca			;76c3
	ld b,003h		;76c4
	ld bc,00303h		;76c6
	ld bc,00304h		;76c9
	inc bc			;76cc
	defb 0fdh,076h,0fdh ;illegal sequence	;76cd
	halt			;76d0
	nop			;76d1
	ld (hl),a		;76d2
	inc bc			;76d3
	ld (hl),a		;76d4
	ld b,077h		;76d5
	add hl,bc		;76d7
	ld (hl),a		;76d8
	inc c			;76d9
	ld (hl),a		;76da
	rrca			;76db
	ld (hl),a		;76dc
	ld (de),a		;76dd
	ld (hl),a		;76de
	dec d			;76df
	ld (hl),a		;76e0
	jr $+121		;76e1
	dec de			;76e3
	ld (hl),a		;76e4
	defb 0fdh,076h,01eh ;illegal sequence	;76e5
	ld (hl),a		;76e8
	ld hl,02677h		;76e9
	ld (hl),a		;76ec
	inc bc			;76ed
	inc bc			;76ee
	inc bc			;76ef
	inc bc			;76f0
	inc bc			;76f1
	inc bc			;76f2
	inc bc			;76f3
	inc bc			;76f4
	inc bc			;76f5
	inc bc			;76f6
	inc bc			;76f7
	inc bc			;76f8
	inc bc			;76f9
	inc bc			;76fa
	dec b			;76fb
	inc b			;76fc
	djnz $+82		;76fd
	sub b			;76ff
	djnz $+42		;7700
	ld c,b			;7702
	jr nc,$+10		;7703
	ld d,b			;7705
	dec bc			;7706
	jr z,$+74		;7707
	djnz $+98		;7709
	or b			;770b
	ld d,b			;770c
	and b			;770d
	ret p			;770e
	jr $+114		;770f
	ret nz			;7711
	djnz $+58		;7712
	sub b			;7714
	jr $+98			;7715
	xor b			;7717
	jr nz,$+82		;7718
	add a,b			;771a
	ld (bc),a		;771b
	inc c			;771c
	rla			;771d
	djnz $+82		;771e
	sub b			;7720
	djnz $+50		;7721
	ld d,b			;7723
	ld (hl),b		;7724
	sub b			;7725
	djnz $+50		;7726
	ld d,b			;7728
	ld (hl),b		;7729
	ld ix,0e100h		;772a
	ld hl,0e320h		;772e
	ld b,007h		;7731
	push bc			;7733
	ld a,(ix+00ah)		;7734
	ld b,h			;7737
	ld c,l			;7738
	add a,a			;7739
	ld hl,07772h		;773a
	call 0405bh		;773d
	ld e,(hl)		;7740
	inc hl			;7741
	ld d,(hl)		;7742
	ld h,b			;7743
	ld l,c			;7744
	ld b,002h		;7745
	ld a,(de)		;7747
	add a,(ix+003h)		;7748
	ld (hl),a		;774b
	inc l			;774c
	inc de			;774d
	ld a,(de)		;774e
	add a,(ix+005h)		;774f
	ld (hl),a		;7752
	inc de			;7753
	inc l			;7754
	ld a,(ix+00ah)		;7755
	cp 005h			;7758
	ld a,(de)		;775a
	jr c,$+5		;775b
	add a,(ix+016h)		;775d
	ld (hl),a		;7760
	inc de			;7761
	inc l			;7762
	ld a,(de)		;7763
	ld (hl),a		;7764
	inc de			;7765
	inc l			;7766
	djnz $-32		;7767
	pop bc			;7769
	ld de,00020h		;776a
	add ix,de		;776d
	djnz $-60		;776f
	ret			;7771
	jp nc,0be77h		;7772
	ld (hl),a		;7775
	add a,077h		;7776
	adc a,077h		;7778
	sub 077h		;777a
	sbc a,077h		;777c
	and 077h		;777e
	xor 077h		;7780
	or 077h			;7782
	cp 077h			;7784
	ld b,078h		;7786
	ld c,078h		;7788
	ld d,078h		;778a
	ld e,078h		;778c
	ld h,078h		;778e
	ld l,078h		;7790
	ld (hl),078h		;7792
	ld a,078h		;7794
	ld b,(hl)		;7796
	ld a,b			;7797
	ld c,(hl)		;7798
	ld a,b			;7799
	ld d,(hl)		;779a
	ld a,b			;779b
	ld e,(hl)		;779c
	ld a,b			;779d
	ld h,(hl)		;779e
	ld a,b			;779f
	ld l,(hl)		;77a0
	ld a,b			;77a1
	halt			;77a2
	ld a,b			;77a3
	ld a,(hl)		;77a4
	ld a,b			;77a5
	add a,(hl)		;77a6
	ld a,b			;77a7
	adc a,(hl)		;77a8
	ld a,b			;77a9
	sub (hl)		;77aa
	ld a,b			;77ab
	sbc a,(hl)		;77ac
	ld a,b			;77ad
	and (hl)		;77ae
	ld a,b			;77af
	xor (hl)		;77b0
	ld a,b			;77b1
	or (hl)			;77b2
	ld a,b			;77b3
	cp (hl)			;77b4
	ld a,b			;77b5
	add a,078h		;77b6
	adc a,078h		;77b8
	sub 078h		;77ba
	sbc a,078h		;77bc
	defb 0fdh,0fch,044h ;illegal sequence	;77be
	ld a,(bc)		;77c1
	ret m			;77c2
	ret m			;77c3
	ld c,b			;77c4
	ld b,000h		;77c5
	call m,00a4ch		;77c7
	ret m			;77ca
	jp m,00650h		;77cb
	ret m			;77ce
	call m,00654h		;77cf
	nop			;77d2
	nop			;77d3
	nop			;77d4
	nop			;77d5
	nop			;77d6
	nop			;77d7
	nop			;77d8
	nop			;77d9
	ret m			;77da
	ret m			;77db
	inc a			;77dc
	rrca			;77dd
	ret m			;77de
	ret m			;77df
	nop			;77e0
	ld a,(bc)		;77e1
	ld a,(bc)		;77e2
	ret m			;77e3
	inc b			;77e4
	ld bc,0f8f8h		;77e5
	ex af,af'		;77e8
	rrca			;77e9
	add hl,bc		;77ea
	ret m			;77eb
	inc c			;77ec
	ld bc,0f8f8h		;77ed
	nop			;77f0
	ld bc,0fcfbh		;77f1
	inc b			;77f4
	rrca			;77f5
	ret m			;77f6
	ret m			;77f7
	djnz $+3		;77f8
	ei			;77fa
	call p,00f14h		;77fb
	ret m			;77fe
	ret m			;77ff
	nop			;7800
	ld bc,0f80ch		;7801
	ex af,af'		;7804
	ld bc,0f8f8h		;7805
	inc b			;7808
	ld bc,0f80ch		;7809
	ex af,af'		;780c
	ld bc,0f8f8h		;780d
	nop			;7810
	rlca			;7811
	ld c,0f8h		;7812
	ex af,af'		;7814
	ld bc,0f8f8h		;7815
	inc b			;7818
	rlca			;7819
	ld c,0f8h		;781a
	ex af,af'		;781c
	ld bc,0f8f8h		;781d
	nop			;7820
	ld bc,0fcfah		;7821
	inc b			;7824
	dec bc			;7825
	ret m			;7826
	ret m			;7827
	djnz $+3		;7828
	jp m,014f4h		;782a
	dec bc			;782d
	ret m			;782e
	ret m			;782f
	nop			;7830
	ld bc,0fcfeh		;7831
	inc b			;7834
	rrca			;7835
	ld sp,hl		;7836
	ret m			;7837
	djnz $+3		;7838
	rst 38h			;783a
	call p,00f14h		;783b
	ret m			;783e
	ret m			;783f
	nop			;7840
	rrca			;7841
	ret m			;7842
	ret m			;7843
	inc b			;7844
	ld bc,0f8f9h		;7845
	djnz $+17		;7848
	ld sp,hl		;784a
	ret m			;784b
	inc d			;784c
	ld bc,0f0f0h		;784d
	ex af,af'		;7850
	rrca			;7851
	ret p			;7852
	nop			;7853
	inc c			;7854
	rrca			;7855
	ret p			;7856
	ret pe			;7857
	ex af,af'		;7858
	rrca			;7859
	ret p			;785a
	ex af,af'		;785b
	inc c			;785c
	rrca			;785d
	ret m			;785e
	ret po			;785f
	ex af,af'		;7860
	rrca			;7861
	ret m			;7862
	djnz $+14		;7863
	rrca			;7865
	ret m			;7866
	ret m			;7867
	nop			;7868
	rrca			;7869
	ld c,0f8h		;786a
	inc b			;786c
	ld bc,0f8f8h		;786d
	djnz $+17		;7870
	ld c,0f8h		;7872
	inc d			;7874
	ld bc,0f8f8h		;7875
	nop			;7878
	dec b			;7879
	ret m			;787a
	ret m			;787b
	inc b			;787c
	ld bc,0f8f9h		;787d
	djnz $+7		;7880
	ld sp,hl		;7882
	ret m			;7883
	inc d			;7884
	ld bc,0f8f8h		;7885
	nop			;7888
	ld b,00ch		;7889
	ret m			;788b
	ex af,af'		;788c
	ld bc,0f8f8h		;788d
	inc b			;7890
	ld b,00ch		;7891
	ret m			;7893
	ex af,af'		;7894
	ld bc,0f8f8h		;7895
	nop			;7898
	rrca			;7899
	add hl,bc		;789a
	ret m			;789b
	ex af,af'		;789c
	ld bc,0f8f8h		;789d
	inc b			;78a0
	rrca			;78a1
	add hl,bc		;78a2
	ret m			;78a3
	ex af,af'		;78a4
	ld bc,0f8f8h		;78a5
	nop			;78a8
	ld bc,0fcfah		;78a9
	inc b			;78ac
	ex af,af'		;78ad
	ret m			;78ae
	ret m			;78af
	djnz $+3		;78b0
	jp m,014f4h		;78b2
	ex af,af'		;78b5
	ret m			;78b6
	ret m			;78b7
	nop			;78b8
	ld bc,0fbfch		;78b9
	ex af,af'		;78bc
	rrca			;78bd
	ret m			;78be
	ret m			;78bf
	inc b			;78c0
	ld bc,0fcfbh		;78c1
	ex af,af'		;78c4
	rrca			;78c5
	ret m			;78c6
	ret m			;78c7
	nop			;78c8
	ld b,0f8h		;78c9
	ret m			;78cb
	inc b			;78cc
	ld bc,0f8f9h		;78cd
	djnz $+8		;78d0
	ld sp,hl		;78d2
	ret m			;78d3
	inc d			;78d4
	ld bc,0f8f8h		;78d5
	ex af,af'		;78d8
	ld b,0f8h		;78d9
	ret m			;78db
	inc c			;78dc
	ld bc,0f8f9h		;78dd
	jr $+8			;78e0
	ld sp,hl		;78e2
	ret m			;78e3
	inc e			;78e4
	ld bc,021fdh		;78e5
	and b			;78e8
	ret po			;78e9
	ld b,002h		;78ea
	push bc			;78ec
	call 078f9h		;78ed
	pop bc			;78f0
	ld de,00010h		;78f1
	add iy,de		;78f4
	djnz $-10		;78f6
	ret			;78f8
	ld a,(iy+008h)		;78f9
	and a			;78fc
	ret z			;78fd
	ld (iy+008h),000h	;78fe
	ld a,(0e1f1h)		;7902
	ld hl,07950h		;7905
	call 0405bh		;7908
	ld a,(hl)		;790b
	ld (iy+007h),a		;790c
	ld a,(iy+000h)		;790f
	and 00fh		;7912
	ld hl,0a993h		;7914
	call 04071h		;7917
	push de			;791a
	ld hl,07944h		;791b
	ld a,(0e1f1h)		;791e
	call 04079h		;7921
	pop de			;7924
	push hl			;7925
	call 04412h		;7926
	ld hl,0794ah		;7929
	ld a,(0e1f1h)		;792c
	call 04071h		;792f
	pop hl			;7932
	ld c,004h		;7933
	call 04478h		;7935
	ld hl,0e1f1h		;7938
	ld a,(hl)		;793b
	inc a			;793c
	cp 003h			;793d
	jr c,$+3		;793f
	xor a			;7941
	ld (hl),a		;7942
	ret			;7943
	nop			;7944
	dec e			;7945
	nop			;7946
	ld e,000h		;7947
	rra			;7949
	sub b			;794a
	dec e			;794b
	sub b			;794c
	ld e,090h		;794d
	rra			;794f
	and b			;7950
	ret nz			;7951
	ret po			;7952
	ld e,a			;7953
	ld a,c			;7954
	sbc a,l			;7955
	ld a,c			;7956
	ld (hl),h		;7957
	ld a,h			;7958
	adc a,d			;7959
	ld a,h			;795a
	and b			;795b
	ld a,h			;795c
	rst 28h			;795d
	ld a,h			;795e
	call 07a5eh		;795f
	ld (ix+006h),030h	;7962
	ld (ix+007h),001h	;7966
	ld (ix+00ah),009h	;796a
	ld (ix+00dh),080h	;796e
	ld b,006h		;7972
	ld hl,07991h		;7974
	ld a,(ix+005h)		;7977
	cp (hl)			;797a
	jr z,$+6		;797b
	inc hl			;797d
	djnz $-4		;797e
	ret			;7980
	ld a,006h		;7981
	sub b			;7983
	ld hl,07997h		;7984
	call 0405bh		;7987
	ld a,(hl)		;798a
	ld (ix+009h),a		;798b
	jp 07afeh		;798e
	jr z,$+82		;7991
	ld a,a			;7993
	add a,b			;7994
	or b			;7995
	ret c			;7996
	nop			;7997
	dec b			;7998
	jp m,0fb06h		;7999
	rst 38h			;799c
	ld c,000h		;799d
	call 07a0ch		;799f
	call 079dch		;79a2
	call 07633h		;79a5
	push ix			;79a8
	pop hl			;79aa
	inc l			;79ab
	inc l			;79ac
	ld d,h			;79ad
	ld e,l			;79ae
	inc e			;79af
	inc e			;79b0
	inc e			;79b1
	inc e			;79b2
	ld a,(de)		;79b3
	add a,(hl)		;79b4
	ld (hl),a		;79b5
	inc l			;79b6
	inc e			;79b7
	ld a,(de)		;79b8
	adc a,(hl)		;79b9
	ld (hl),a		;79ba
	cp 0a8h			;79bb
	jr c,$+6		;79bd
	cp 0e8h			;79bf
	jr c,$+19		;79c1
	inc l			;79c3
	inc e			;79c4
	ld a,(de)		;79c5
	add a,(hl)		;79c6
	ld (hl),a		;79c7
	inc l			;79c8
	inc e			;79c9
	ld a,(de)		;79ca
	adc a,(hl)		;79cb
	ld (hl),a		;79cc
	sub 008h		;79cd
	cp 0f0h			;79cf
	ret c			;79d1
	dec l			;79d2
	dec l			;79d3
	ld (hl),0e0h		;79d4
	dec l			;79d6
	dec l			;79d7
	dec l			;79d8
	ld (hl),000h		;79d9
	ret			;79db
	ld a,(0e02eh)		;79dc
	and a			;79df
	jr nz,$+24		;79e0
	ld a,(ix+010h)		;79e2
	bit 0,a			;79e5
	ld a,041h		;79e7
	jr z,$+4		;79e9
	ld a,002h		;79eb
	call 0490ch		;79ed
	ld a,(ix+010h)		;79f0
	xor 001h		;79f3
	ld (ix+010h),a		;79f5
	ld b,009h		;79f8
	ld a,(0e003h)		;79fa
	bit 3,a			;79fd
	jr z,$+3		;79ff
	inc b			;7a01
	ld (ix+00ah),b		;7a02
	ret			;7a05
	ld c,000h		;7a06
	jr $+4			;7a08
	ld c,001h		;7a0a
	ld a,(ix+005h)		;7a0c
	sub (ix+00dh)		;7a0f
	ld e,a			;7a12
	ld d,000h		;7a13
	add a,a			;7a15
	jr nc,$+3		;7a16
	dec d			;7a18
	ld a,c			;7a19
	and a			;7a1a
	jr z,$+7		;7a1b
	sra e			;7a1d
	dec a			;7a1f
	jr nz,$-3		;7a20
	ld l,(ix+008h)		;7a22
	ld h,(ix+009h)		;7a25
	and a			;7a28
	sbc hl,de		;7a29
	ld (ix+008h),l		;7a2b
	ld (ix+009h),h		;7a2e
	ret			;7a31
	ld c,000h		;7a32
	jr $+4			;7a34
	ld c,001h		;7a36
	ld a,(ix+003h)		;7a38
	sub (ix+00ch)		;7a3b
	ld e,a			;7a3e
	ld d,000h		;7a3f
	add a,a			;7a41
	jr nc,$+3		;7a42
	dec d			;7a44
	ld a,c			;7a45
	and a			;7a46
	jr z,$+7		;7a47
	sra e			;7a49
	dec a			;7a4b
	jr nz,$-3		;7a4c
	ld l,(ix+006h)		;7a4e
	ld h,(ix+007h)		;7a51
	and a			;7a54
	sbc hl,de		;7a55
	ld (ix+006h),l		;7a57
	ld (ix+007h),h		;7a5a
	ret			;7a5d
	push ix			;7a5e
	pop hl			;7a60
	ld a,006h		;7a61
	call 0405bh		;7a63
	ld d,h			;7a66
	ld e,l			;7a67
	inc de			;7a68
	ld bc,00009h		;7a69
	ld (hl),000h		;7a6c
	ldir			;7a6e
	ld (ix+00bh),001h	;7a70
	ret			;7a74
	add a,c			;7a75
	ld a,d			;7a76
	cp a			;7a77
	ld a,d			;7a78
	ld (hl),h		;7a79
	ld a,h			;7a7a
	adc a,d			;7a7b
	ld a,h			;7a7c
	and b			;7a7d
	ld a,h			;7a7e
	rst 28h			;7a7f
	ld a,h			;7a80
	call 07a5eh		;7a81
	ld (ix+007h),002h	;7a84
	ld (ix+00ah),009h	;7a88
	ld a,(0e604h)		;7a8c
	ld c,a			;7a8f
	ld a,(ix+011h)		;7a90
	cp 0ffh			;7a93
	jr z,$+11		;7a95
	and 00fh		;7a97
	ld hl,0e1f0h		;7a99
	jr nz,$+3		;7a9c
	ld (hl),c		;7a9e
	ld c,(hl)		;7a9f
	ld a,c			;7aa0
	cp 080h			;7aa1
	ld bc,00380h		;7aa3
	ld de,02010h		;7aa6
	jr nc,$+8		;7aa9
	ld bc,0fc80h		;7aab
	ld de,0e0f0h		;7aae
	ld (ix+008h),c		;7ab1
	ld (ix+009h),b		;7ab4
	ld (ix+00dh),d		;7ab7
	ld (ix+005h),e		;7aba
	jr $+65			;7abd
	ld c,001h		;7abf
	jp 0799fh		;7ac1
	jp nc,0077ah		;7ac4
	ld a,e			;7ac7
	jr nz,$+125		;7ac8
	ld (hl),h		;7aca
	ld a,h			;7acb
	adc a,d			;7acc
	ld a,h			;7acd
	and b			;7ace
	ld a,h			;7acf
	rst 28h			;7ad0
	ld a,h			;7ad1
	call 07a5eh		;7ad2
	ld (ix+006h),0c0h	;7ad5
	ld (ix+007h),0ffh	;7ad9
	ld (ix+00ah),009h	;7add
	ld (ix+00ch),030h	;7ae1
	ld (ix+00dh),080h	;7ae5
	ld a,(ix+005h)		;7ae9
	cp 080h			;7aec
	ld b,003h		;7aee
	ld c,010h		;7af0
	jr c,$+6		;7af2
	ld b,0fdh		;7af4
	ld c,0f0h		;7af6
	ld (ix+009h),b		;7af8
	ld (ix+005h),c		;7afb
	ld a,(ix+000h)		;7afe
	and a			;7b01
	ret z			;7b02
	inc (ix+000h)		;7b03
	ret			;7b06
	call 079a2h		;7b07
	ld a,(ix+005h)		;7b0a
	sub 080h		;7b0d
	jr nc,$+4		;7b0f
	neg			;7b11
	cp 005h			;7b13
	ret nc			;7b15
	ld (ix+006h),000h	;7b16
	ld (ix+007h),000h	;7b1a
	jr $-32			;7b1e
	call 07a36h		;7b20
	ld c,001h		;7b23
	jp 0799fh		;7b25
	ld (hl),07bh		;7b28
	ld h,l			;7b2a
	ld a,e			;7b2b
	add a,c			;7b2c
	ld a,e			;7b2d
	ld (hl),h		;7b2e
	ld a,h			;7b2f
	adc a,d			;7b30
	ld a,h			;7b31
	and b			;7b32
	ld a,h			;7b33
	rst 28h			;7b34
	ld a,h			;7b35
	call 07a5eh		;7b36
	ld (ix+006h),030h	;7b39
	ld (ix+007h),001h	;7b3d
	ld (ix+00ah),016h	;7b41
	ld a,(ix+005h)		;7b45
	cp 080h			;7b48
	ld b,018h		;7b4a
	ld c,003h		;7b4c
	ld d,006h		;7b4e
	jr c,$+8		;7b50
	ld b,0e8h		;7b52
	ld c,002h		;7b54
	ld d,0fah		;7b56
	ld (ix+00dh),b		;7b58
	ld (ix+005h),b		;7b5b
	ld (ix+000h),c		;7b5e
	ld (ix+009h),d		;7b61
	ret			;7b64
	call 07ba3h		;7b65
	ld a,(ix+005h)		;7b68
	cp 0e9h			;7b6b
	ret c			;7b6d
	ld (ix+008h),000h	;7b6e
	ld (ix+009h),006h	;7b72
	ld a,018h		;7b76
	ld (ix+005h),a		;7b78
	ld (ix+00dh),a		;7b7b
	jp 07afeh		;7b7e
	call 07ba3h		;7b81
	ld a,(ix+005h)		;7b84
	cp 017h			;7b87
	ret nc			;7b89
	ld (ix+008h),000h	;7b8a
	ld (ix+009h),0fah	;7b8e
	ld a,0e8h		;7b92
	ld (ix+005h),a		;7b94
	ld (ix+00dh),a		;7b97
	ld a,(ix+000h)		;7b9a
	and a			;7b9d
	ret z			;7b9e
	dec (ix+000h)		;7b9f
	ret			;7ba2
	call 07a06h		;7ba3
	ld a,(ix+009h)		;7ba6
	rla			;7ba9
	ld a,016h		;7baa
	jr nc,$+3		;7bac
	inc a			;7bae
	ld (ix+00ah),a		;7baf
	jp 079a5h		;7bb2
	rst 0			;7bb5
	ld a,e			;7bb6
	jp po,0ff7bh		;7bb7
	ld a,e			;7bba
	ld a,(bc)		;7bbb
	ld a,h			;7bbc
	xor b			;7bbd
	ld a,c			;7bbe
	ld (hl),h		;7bbf
	ld a,h			;7bc0
	adc a,d			;7bc1
	ld a,h			;7bc2
	and b			;7bc3
	ld a,h			;7bc4
	rst 28h			;7bc5
	ld a,h			;7bc6
	call 07a5eh		;7bc7
	ld a,(ix+005h)		;7bca
	cp 080h			;7bcd
	ld c,002h		;7bcf
	jr c,$+4		;7bd1
	ld c,0feh		;7bd3
	ld (ix+009h),c		;7bd5
	ld (ix+007h),006h	;7bd8
	ld (ix+00ah),006h	;7bdc
	jr $+28			;7be0
	call 079a8h		;7be2
	ld a,(ix+003h)		;7be5
	cp 008h			;7be8
	ret c			;7bea
	cp 0c0h			;7beb
	ret nc			;7bed
	ld a,(0e602h)		;7bee
	sub (ix+003h)		;7bf1
	cp 050h			;7bf4
	ret nc			;7bf6
	ld a,020h		;7bf7
	ld (ix+00eh),a		;7bf9
	jp 07afeh		;7bfc
	call 07c1ch		;7bff
	ret nz			;7c02
	call 07673h		;7c03
	ld a,008h		;7c06
	jr $-15			;7c08
	call 07c1ch		;7c0a
	ret nz			;7c0d
	ld (ix+006h),000h	;7c0e
	ld (ix+007h),0fah	;7c12
	ld (ix+00ah),006h	;7c16
	jr $-30			;7c1a
	ld b,007h		;7c1c
	call 079fah		;7c1e
	dec (ix+00eh)		;7c21
	ret			;7c24
	inc sp			;7c25
	ld a,h			;7c26
	ld b,h			;7c27
	ld a,h			;7c28
	ld l,a			;7c29
	ld a,h			;7c2a
	ld (hl),h		;7c2b
	ld a,h			;7c2c
	adc a,d			;7c2d
	ld a,h			;7c2e
	and b			;7c2f
	ld a,h			;7c30
	rst 28h			;7c31
	ld a,h			;7c32
	call 07a5eh		;7c33
	ld (ix+006h),050h	;7c36
	ld (ix+007h),002h	;7c3a
	ld (ix+00ah),00bh	;7c3e
	jr $-70			;7c42
	call 07c6fh		;7c44
	ld a,(ix+003h)		;7c47
	cp 008h			;7c4a
	ret c			;7c4c
	cp 0c0h			;7c4d
	ret nc			;7c4f
	ld a,(0e602h)		;7c50
	sub (ix+003h)		;7c53
	cp 050h			;7c56
	ret nc			;7c58
	ld a,(0e604h)		;7c59
	cp (ix+005h)		;7c5c
	ld bc,0027fh		;7c5f
	jr nc,$+5		;7c62
	ld bc,0fd81h		;7c64
	ld (ix+008h),c		;7c67
	ld (ix+009h),b		;7c6a
	jr $-43			;7c6d
	ld b,00bh		;7c6f
	jp 07d87h		;7c71
	ld a,(0e003h)		;7c74
	bit 1,a			;7c77
	ld a,001h		;7c79
	jr z,$+3		;7c7b
	inc a			;7c7d
	ld (ix+00ah),a		;7c7e
	dec (ix+00eh)		;7c81
	ret nz			;7c84
	ld a,006h		;7c85
	jp 07bf9h		;7c87
	ld a,(0e003h)		;7c8a
	bit 1,a			;7c8d
	ld a,002h		;7c8f
	jr z,$+3		;7c91
	inc a			;7c93
	ld (ix+00ah),a		;7c94
	dec (ix+00eh)		;7c97
	ret nz			;7c9a
	ld a,006h		;7c9b
	jp 07bf9h		;7c9d
	ld a,(0e003h)		;7ca0
	bit 1,a			;7ca3
	ld a,003h		;7ca5
	jr z,$+3		;7ca7
	xor a			;7ca9
	ld (ix+00ah),a		;7caa
	dec (ix+00eh)		;7cad
	ret nz			;7cb0
	ld a,(0e600h)		;7cb1
	cp 002h			;7cb4
	jr z,$+48		;7cb6
	ld a,(ix+001h)		;7cb8
	bit 6,a			;7cbb
	jr z,$+41		;7cbd
	ld a,(ix+011h)		;7cbf
	rra			;7cc2
	rra			;7cc3
	rra			;7cc4
	rra			;7cc5
	and 00fh		;7cc6
	ld hl,0e1e4h		;7cc8
	ld c,a			;7ccb
	add a,a			;7ccc
	add a,c			;7ccd
	call 0405bh		;7cce
	ld a,(hl)		;7cd1
	inc hl			;7cd2
	inc (hl)		;7cd3
	cp (hl)			;7cd4
	jr nz,$+17		;7cd5
	ld de,01000h		;7cd7
	call 042adh		;7cda
	ld a,008h		;7cdd
	ld (ix+00ah),004h	;7cdf
	jp 07bf9h		;7ce3
	ld (ix+000h),000h	;7ce6
	ld (ix+003h),0e0h	;7cea
	ret			;7cee
	dec (ix+00eh)		;7cef
	ret nz			;7cf2
	jr $-13			;7cf3
	add hl,bc		;7cf5
	ld a,l			;7cf6
	inc h			;7cf7
	ld a,l			;7cf8
	ld b,l			;7cf9
	ld a,l			;7cfa
	ld e,e			;7cfb
	ld a,l			;7cfc
	ld (hl),h		;7cfd
	ld a,l			;7cfe
	add a,l			;7cff
	ld a,l			;7d00
	ld (hl),h		;7d01
	ld a,h			;7d02
	adc a,d			;7d03
	ld a,h			;7d04
	and b			;7d05
	ld a,h			;7d06
	rst 28h			;7d07
	ld a,h			;7d08
	call 07a5eh		;7d09
	ld (ix+007h),003h	;7d0c
	ld (ix+00ah),00dh	;7d10
	ld a,(ix+005h)		;7d14
	cp 080h			;7d17
	ld a,020h		;7d19
	jr c,$+4		;7d1b
	ld a,0e0h		;7d1d
	ld (ix+005h),a		;7d1f
	jr $+32			;7d22
	call 07d85h		;7d24
	ld a,(ix+003h)		;7d27
	cp 0e0h			;7d2a
	ret nc			;7d2c
	cp 050h			;7d2d
	ret c			;7d2f
	ld (ix+00ch),050h	;7d30
	ld a,(ix+005h)		;7d34
	cp 080h			;7d37
	ld a,090h		;7d39
	jr nc,$+4		;7d3b
	ld a,070h		;7d3d
	ld (ix+00dh),a		;7d3f
	jp 07bfch		;7d42
	call 07d7fh		;7d45
	ld a,(ix+003h)		;7d48
	cp 04fh			;7d4b
	ret nc			;7d4d
	ld (ix+00dh),080h	;7d4e
	xor a			;7d52
	ld (ix+008h),a		;7d53
	ld (ix+009h),a		;7d56
	jr $-23			;7d59
	call 07d7fh		;7d5b
	ld a,(ix+003h)		;7d5e
	cp 050h			;7d61
	ret c			;7d63
	ld a,(ix+005h)		;7d64
	cp 080h			;7d67
	ld a,070h		;7d69
	jr nc,$+4		;7d6b
	ld a,090h		;7d6d
	ld (ix+00dh),a		;7d6f
	jr $-32			;7d72
	call 07d7fh		;7d74
	ld a,(ix+003h)		;7d77
	cp 04fh			;7d7a
	ret nc			;7d7c
	jr $-43			;7d7d
	call 07a0ah		;7d7f
	call 07a36h		;7d82
	ld b,00dh		;7d85
	call 079fah		;7d87
	jp 079a5h		;7d8a
	sbc a,c			;7d8d
	ld a,l			;7d8e
	xor e			;7d8f
	ld a,l			;7d90
	ld (hl),h		;7d91
	ld a,h			;7d92
	adc a,d			;7d93
	ld a,h			;7d94
	and b			;7d95
	ld a,h			;7d96
	rst 28h			;7d97
	ld a,h			;7d98
	call 07a5eh		;7d99
	ld (ix+006h),0a0h	;7d9c
	ld (ix+00ah),00fh	;7da0
	ld (ix+00bh),005h	;7da4
	jp 07bfch		;7da8
	ld b,00fh		;7dab
	jr $-38			;7dad
	push bc			;7daf
	ld a,l			;7db0
	ex de,hl		;7db1
	ld a,l			;7db2
	dec hl			;7db3
	ld a,(hl)		;7db4
	ld c,h			;7db5
	ld a,(hl)		;7db6
	ld h,d			;7db7
	ld a,(hl)		;7db8
	ld (hl),l		;7db9
	ld a,(hl)		;7dba
	adc a,d			;7dbb
	ld a,(hl)		;7dbc
	ld (hl),h		;7dbd
	ld a,h			;7dbe
	adc a,d			;7dbf
	ld a,h			;7dc0
	and b			;7dc1
	ld a,h			;7dc2
	rst 28h			;7dc3
	ld a,h			;7dc4
	call 07a5eh		;7dc5
	ld (ix+00ah),011h	;7dc8
	ld (ix+014h),004h	;7dcc
	ld (ix+015h),000h	;7dd0
	ld a,(ix+005h)		;7dd4
	cp 080h			;7dd7
	ld a,020h		;7dd9
	ld b,000h		;7ddb
	jr c,$+5		;7ddd
	ld a,0e0h		;7ddf
	inc b			;7de1
	ld (ix+005h),a		;7de2
	ld (ix+010h),b		;7de5
	jp 07bfch		;7de8
	ld a,(ix+010h)		;7deb
	and a			;7dee
	ld hl,07e13h		;7def
	jr z,$+5		;7df2
	ld hl,07e1bh		;7df4
	ld a,(ix+015h)		;7df7
	push af			;7dfa
	call 04071h		;7dfb
	ld (ix+008h),e		;7dfe
	ld (ix+009h),d		;7e01
	pop af			;7e04
	ld hl,07e23h		;7e05
	call 04071h		;7e08
	ld (ix+006h),e		;7e0b
	ld (ix+007h),d		;7e0e
	jr $+78			;7e11
	add a,b			;7e13
	ld bc,00200h		;7e14
	add a,b			;7e17
	ld (bc),a		;7e18
	nop			;7e19
	inc bc			;7e1a
	add a,b			;7e1b
	cp 000h			;7e1c
	cp 080h			;7e1e
	defb 0fdh,000h,0fdh ;illegal sequence	;7e20
	ld h,b			;7e23
	nop			;7e24
	sub b			;7e25
	nop			;7e26
	ret nz			;7e27
	nop			;7e28
	nop			;7e29
	ld bc,01106h		;7e2a
	call 07d87h		;7e2d
	ld a,(ix+010h)		;7e30
	and a			;7e33
	ld a,(ix+005h)		;7e34
	jr nz,$+7		;7e37
	cp 0e0h			;7e39
	ret c			;7e3b
	jr $+5			;7e3c
	cp 021h			;7e3e
	ret nc			;7e40
	ld a,(ix+010h)		;7e41
	xor 001h		;7e44
	ld (ix+010h),a		;7e46
	jp 07b9ah		;7e49
	ld de,00100h		;7e4c
	call 042adh		;7e4f
	ld (ix+00ah),013h	;7e52
	ld (ix+012h),002h	;7e56
	ld a,006h		;7e5a
	ld (ix+00eh),a		;7e5c
	jp 07bfch		;7e5f
	dec (ix+00eh)		;7e62
	ret nz			;7e65
	inc (ix+00ah)		;7e66
	ld (ix+00eh),006h	;7e69
	dec (ix+012h)		;7e6d
	ret nz			;7e70
	ld a,020h		;7e71
	jr $-23			;7e73
	dec (ix+00eh)		;7e75
	ret nz			;7e78
	ld (ix+00ah),015h	;7e79
	ld (ix+012h),002h	;7e7d
	ld a,009h		;7e81
	call 0490ch		;7e83
	ld a,006h		;7e86
	jr $-44			;7e88
	dec (ix+00eh)		;7e8a
	ret nz			;7e8d
	dec (ix+00ah)		;7e8e
	ld (ix+00eh),006h	;7e91
	dec (ix+012h)		;7e95
	ret nz			;7e98
	ld a,(ix+015h)		;7e99
	inc a			;7e9c
	cp 004h			;7e9d
	jr c,$+4		;7e9f
	ld a,004h		;7ea1
	ld (ix+015h),a		;7ea3
	ld (ix+000h),002h	;7ea6
	ret			;7eaa
	cp c			;7eab
	ld a,(hl)		;7eac
	jp z,0fe7eh		;7ead
	ld a,(hl)		;7eb0
	ld (hl),h		;7eb1
	ld a,h			;7eb2
	adc a,d			;7eb3
	ld a,h			;7eb4
	and b			;7eb5
	ld a,h			;7eb6
	rst 28h			;7eb7
	ld a,h			;7eb8
	call 07a5eh		;7eb9
	ld (ix+007h),001h	;7ebc
	ld (ix+00ah),018h	;7ec0
	ld (ix+00bh),003h	;7ec4
	jr $+51			;7ec8
	call 07f15h		;7eca
	ld a,(ix+003h)		;7ecd
	cp 0c0h			;7ed0
	ret nc			;7ed2
	ld a,(0e602h)		;7ed3
	sub (ix+003h)		;7ed6
	cp 040h			;7ed9
	ret nc			;7edb
	ld a,(ix+005h)		;7edc
	cp 080h			;7edf
	ld bc,00120h		;7ee1
	jr c,$+5		;7ee4
	ld bc,0fee0h		;7ee6
	ld (ix+008h),c		;7ee9
	ld (ix+009h),b		;7eec
	xor a			;7eef
	ld (ix+006h),a		;7ef0
	ld (ix+007h),a		;7ef3
	ld a,030h		;7ef6
	ld (ix+00eh),a		;7ef8
	jp 07afeh		;7efb
	call 07f15h		;7efe
	dec (ix+00eh)		;7f01
	ret nz			;7f04
	xor a			;7f05
	ld (ix+008h),a		;7f06
	ld (ix+009h),a		;7f09
	ld (ix+006h),080h	;7f0c
	ld (ix+007h),001h	;7f10
	ret			;7f14
	call 07633h		;7f15
	ld b,018h		;7f18
	jp 08096h		;7f1a
	dec l			;7f1d
	ld a,a			;7f1e
	ld h,h			;7f1f
	ld a,a			;7f20
	sub a			;7f21
	ld a,a			;7f22
	pop de			;7f23
	ld a,a			;7f24
	ld (hl),h		;7f25
	ld a,h			;7f26
	adc a,d			;7f27
	ld a,h			;7f28
	and b			;7f29
	ld a,h			;7f2a
	rst 28h			;7f2b
	ld a,h			;7f2c
	call 07a5eh		;7f2d
	ld (ix+006h),000h	;7f30
	ld (ix+007h),002h	;7f34
	ld (ix+00ah),01ah	;7f38
	ld (ix+00ch),050h	;7f3c
	ld a,(ix+005h)		;7f40
	cp 080h			;7f43
	ld bc,0fa80h		;7f45
	ld d,0b0h		;7f48
	ld e,0f0h		;7f4a
	jr c,$+9		;7f4c
	ld bc,00580h		;7f4e
	ld d,050h		;7f51
	ld e,010h		;7f53
	ld (ix+005h),e		;7f55
	ld (ix+008h),c		;7f58
	ld (ix+009h),b		;7f5b
	ld (ix+00dh),d		;7f5e
	jp 07efbh		;7f61
	call 07a06h		;7f64
	ld b,01ah		;7f67
	call 07d87h		;7f69
	ld a,(ix+003h)		;7f6c
	cp 038h			;7f6f
	ret c			;7f71
	ld (ix+00ch),068h	;7f72
	ld (ix+00dh),080h	;7f76
	ld a,(ix+005h)		;7f7a
	cp 080h			;7f7d
	ld bc,00480h		;7f7f
	jr nc,$+5		;7f82
	ld bc,0fb80h		;7f84
	ld (ix+006h),000h	;7f87
	ld (ix+007h),001h	;7f8b
	ld (ix+008h),c		;7f8f
	ld (ix+009h),b		;7f92
	jr $-52			;7f95
	call 07a06h		;7f97
	call 07a32h		;7f9a
	ld b,01ah		;7f9d
	call 07d87h		;7f9f
	ld a,(ix+003h)		;7fa2
	cp 038h			;7fa5
	ret nc			;7fa7
	ld a,(ix+005h)		;7fa8
	cp 080h			;7fab
	ld a,050h		;7fad
	ld bc,0fb20h		;7faf
	jr nc,$+7		;7fb2
	ld a,0b0h		;7fb4
	ld bc,004e0h		;7fb6
	ld (ix+00dh),a		;7fb9
	ld (ix+00ch),050h	;7fbc
	ld (ix+006h),000h	;7fc0
	ld (ix+007h),0feh	;7fc4
	ld (ix+008h),c		;7fc8
	ld (ix+009h),b		;7fcb
	jp 07efbh		;7fce
	call 07a06h		;7fd1
	ld b,01ah		;7fd4
	jp 07d87h		;7fd6
	push hl			;7fd9
	ld a,a			;7fda
	and l			;7fdb
	ld a,c			;7fdc
	ld (hl),h		;7fdd
	ld a,h			;7fde
	adc a,d			;7fdf
	ld a,h			;7fe0
	and b			;7fe1
	ld a,h			;7fe2
	rst 28h			;7fe3
	ld a,h			;7fe4
	call 07a5eh		;7fe5
	ld (ix+00ah),005h	;7fe8
	ld a,(0e003h)		;7fec
	rra			;7fef
	rra			;7ff0
	and 003h		;7ff1
	ld hl,08000h		;7ff3
	call 0405bh		;7ff6
	ld l,(hl)		;7ff9
	call 084e6h		;7ffa
	jp 08079h		;7ffd
	or b			;8000
	sub b			;8001
	ld (hl),b		;8002
	ld d,b			;8003
	inc d			;8004
	add a,b			;8005
	ld b,h			;8006
	add a,b			;8007
	halt			;8008
	add a,b			;8009
	sub h			;800a
	add a,b			;800b
	ld (hl),h		;800c
	ld a,h			;800d
	adc a,d			;800e
	ld a,h			;800f
	and b			;8010
	ld a,h			;8011
	rst 28h			;8012
	ld a,h			;8013
	call 07a5eh		;8014
	ld (ix+006h),080h	;8017
	ld (ix+00ah),01ch	;801b
	ld (ix+00ch),010h	;801f
	ld (ix+012h),000h	;8023
	ld a,(ix+005h)		;8027
	cp 080h			;802a
	ld a,010h		;802c
	ld bc,00100h		;802e
	jr c,$+7		;8031
	ld a,0f0h		;8033
	ld bc,0ff00h		;8035
	ld (ix+005h),a		;8038
	ld (ix+008h),c		;803b
	ld (ix+009h),b		;803e
	jp 07efbh		;8041
	call 07a32h		;8044
	call 08094h		;8047
	ld a,(ix+012h)		;804a
	add a,020h		;804d
	ld (ix+012h),a		;804f
	jr nc,$+5		;8052
	inc (ix+00ch)		;8054
	ld a,(ix+003h)		;8057
	cp 060h			;805a
	ret nc			;805c
	ld a,(ix+005h)		;805d
	cp 018h			;8060
	jr nc,$+7		;8062
	ld bc,00100h		;8064
	jr $+8			;8067
	cp 0e8h			;8069
	ret c			;806b
	ld bc,0ff00h		;806c
	ld (ix+008h),c		;806f
	ld (ix+009h),b		;8072
	ret			;8075
	call 084e0h		;8076
	call 083e1h		;8079
	ld h,b			;807c
	ld l,c			;807d
	add hl,hl		;807e
	add hl,hl		;807f
	add hl,hl		;8080
	ld (ix+006h),l		;8081
	ld (ix+007h),h		;8084
	ld h,d			;8087
	ld l,e			;8088
	add hl,hl		;8089
	add hl,hl		;808a
	add hl,de		;808b
	ld (ix+008h),l		;808c
	ld (ix+009h),h		;808f
	jr $-81			;8092
	ld b,01ch		;8094
	call 079fah		;8096
	jp 079a8h		;8099
	xor d			;809c
	add a,b			;809d
	cp b			;809e
	add a,b			;809f
	ex (sp),hl		;80a0
	add a,b			;80a1
	ld (hl),h		;80a2
	ld a,h			;80a3
	adc a,d			;80a4
	ld a,h			;80a5
	and b			;80a6
	ld a,h			;80a7
	rst 28h			;80a8
	ld a,h			;80a9
	call 07a5eh		;80aa
	ld (ix+00ah),01eh	;80ad
	ld (ix+010h),001h	;80b1
	jp 08140h		;80b5
	call 080f8h		;80b8
	ld a,(ix+010h)		;80bb
	rra			;80be
	jr c,$+6		;80bf
	ld (ix+00ah),000h	;80c1
	call 07622h		;80c5
	ld b,000h		;80c8
	jr nc,$+3		;80ca
	inc b			;80cc
	ld a,(ix+010h)		;80cd
	and 001h		;80d0
	xor b			;80d2
	ret z			;80d3
	ld a,(ix+010h)		;80d4
	xor 001h		;80d7
	ld (ix+010h),a		;80d9
	ld (ix+00eh),008h	;80dc
	jp 07efbh		;80e0
	call 080f8h		;80e3
	ld a,(ix+00eh)		;80e6
	bit 0,a			;80e9
	jr z,$+6		;80eb
	ld (ix+00ah),000h	;80ed
	dec (ix+00eh)		;80f1
	ret nz			;80f4
	jp 07b9ah		;80f5
	ld b,01eh		;80f8
	call 07d87h		;80fa
	ld a,(0e003h)		;80fd
	and 03eh		;8100
	ret nz			;8102
	ld a,008h		;8103
	jp 0490ch		;8105
	inc d			;8108
	add a,c			;8109
	ld (07481h),hl		;810a
	ld a,h			;810d
	adc a,d			;810e
	ld a,h			;810f
	and b			;8110
	ld a,h			;8111
	rst 28h			;8112
	ld a,h			;8113
	call 07a5eh		;8114
	ld (ix+006h),080h	;8117
	ld (ix+00ah),020h	;811b
	jp 07efbh		;811f
	ld b,020h		;8122
	jp 07d87h		;8124
	add hl,sp		;8127
	add a,c			;8128
	ld d,l			;8129
	add a,c			;812a
	ld e,d			;812b
	add a,c			;812c
	add a,c			;812d
	add a,c			;812e
	or l			;812f
	add a,c			;8130
	ld (hl),h		;8131
	ld a,h			;8132
	adc a,d			;8133
	ld a,h			;8134
	and b			;8135
	ld a,h			;8136
	rst 28h			;8137
	ld a,h			;8138
	call 07a5eh		;8139
	ld (ix+00ah),022h	;813c
	call 084e0h		;8140
	call 083e1h		;8143
	ld (ix+006h),c		;8146
	ld (ix+007h),b		;8149
	ld (ix+008h),e		;814c
	ld (ix+009h),d		;814f
	jp 07efbh		;8152
	ld b,022h		;8155
	jp 07d87h		;8157
	call 07a5eh		;815a
	ld (ix+009h),0f9h	;815d
	ld (ix+00eh),004h	;8161
	call 08152h		;8165
	push ix			;8168
	push ix			;816a
	call 073deh		;816c
	pop hl			;816f
	jr nz,$+14		;8170
	push ix			;8172
	pop de			;8174
	ld bc,00020h		;8175
	ldir			;8178
	ld (ix+009h),007h	;817a
	pop ix			;817e
	ret			;8180
	call 081b5h		;8181
	ld a,(ix+005h)		;8184
	ld b,a			;8187
	cp 018h			;8188
	jr nc,$+4		;818a
	ld b,018h		;818c
	cp 0e8h			;818e
	jr c,$+4		;8190
	ld b,0e7h		;8192
	ld (ix+005h),b		;8194
	dec (ix+00eh)		;8197
	ret nz			;819a
	call 084e0h		;819b
	call 083e1h		;819e
	ld h,b			;81a1
	ld l,c			;81a2
	add hl,hl		;81a3
	ld (ix+006h),l		;81a4
	ld (ix+007h),h		;81a7
	ld h,d			;81aa
	ld l,e			;81ab
	add hl,hl		;81ac
	ld (ix+008h),l		;81ad
	ld (ix+009h),h		;81b0
	jr $-97			;81b3
	ld b,024h		;81b5
	jp 07d87h		;81b7
	ld a,(0e3b0h)		;81ba
	or a			;81bd
	jr z,$+11		;81be
	ld a,(0e065h)		;81c0
	cp 001h			;81c3
	ret z			;81c5
	cp 003h			;81c6
	ret z			;81c8
	xor a			;81c9
	ld (0e0c1h),a		;81ca
	ld iy,0e200h		;81cd
	ld hl,081e7h		;81d1
	push hl			;81d4
	ld a,(iy+000h)		;81d5
	dec a			;81d8
	jp z,08207h		;81d9
	dec a			;81dc
	jp z,0830fh		;81dd
	dec a			;81e0
	jp z,08212h		;81e1
	jp 081f6h		;81e4
	ld de,00010h		;81e7
	add iy,de		;81ea
	ld hl,0e0c1h		;81ec
	inc (hl)		;81ef
	ld a,(hl)		;81f0
	cp 008h			;81f1
	ret nc			;81f3
	jr $-35			;81f4
	ld (iy+002h),0e0h	;81f6
	ld a,(0e0c1h)		;81fa
	add a,a			;81fd
	add a,a			;81fe
	ld hl,0e358h		;81ff
	add a,l			;8202
	ld l,a			;8203
	ld (hl),0e0h		;8204
	ret			;8206
	call 08278h		;8207
	call 0830fh		;820a
	push iy			;820d
	jp 079aah		;820f
	dec (iy+00dh)		;8212
	jp m,0824bh		;8215
	ld b,(iy+00dh)		;8218
	ld a,(0e0c1h)		;821b
	add a,a			;821e
	add a,a			;821f
	ld hl,0e358h		;8220
	add a,l			;8223
	ld l,a			;8224
	ld a,(iy+003h)		;8225
	ld (hl),a		;8228
	inc l			;8229
	ld a,(iy+005h)		;822a
	ld (hl),a		;822d
	inc l			;822e
	ld a,b			;822f
	add a,a			;8230
	ld de,08250h		;8231
	add a,e			;8234
	ld e,a			;8235
	jr nc,$+3		;8236
	inc d			;8238
	ex de,hl		;8239
	ldi			;823a
	ldi			;823c
	dec e			;823e
	dec e			;823f
	ld a,(de)		;8240
	dec e			;8241
	dec e			;8242
	cp 044h			;8243
	ret nz			;8245
	ld a,(de)		;8246
	add a,005h		;8247
	ld (de),a		;8249
	ret			;824a
	ld (iy+000h),000h	;824b
	ret			;824f
	ld d,h			;8250
	ex af,af'		;8251
	ld d,h			;8252
	nop			;8253
	ld d,h			;8254
	ex af,af'		;8255
	ld d,b			;8256
	ex af,af'		;8257
	ld b,h			;8258
	ld a,(bc)		;8259
	ld d,b			;825a
	ex af,af'		;825b
	ld b,h			;825c
	ld a,(bc)		;825d
	ld a,(0e0c3h)		;825e
	ld d,a			;8261
	ld hl,0e200h		;8262
	ld bc,00800h		;8265
	ld a,(hl)		;8268
	or a			;8269
	jr nz,$+7		;826a
	inc c			;826c
	ld a,c			;826d
	cp d			;826e
	ccf			;826f
	ret c			;8270
	ld a,010h		;8271
	add a,l			;8273
	ld l,a			;8274
	djnz $-13		;8275
	ret			;8277
	ld a,(0e0c1h)		;8278
	add a,a			;827b
	add a,a			;827c
	ld de,0e358h		;827d
	add a,e			;8280
	ld e,a			;8281
	push iy			;8282
	pop hl			;8284
	inc l			;8285
	inc l			;8286
	inc l			;8287
	ldi			;8288
	inc hl			;828a
	ldi			;828b
	ld a,(iy+00ah)		;828d
	ld (de),a		;8290
	inc de			;8291
	ld a,00fh		;8292
	ld (de),a		;8294
	ld a,(iy+001h)		;8295
	cp 006h			;8298
	jr z,$+5		;829a
	cp 00ch			;829c
	ret nz			;829e
	and 002h		;829f
	add a,a			;82a1
	ld b,a			;82a2
	inc (iy+00dh)		;82a3
	ld a,(iy+001h)		;82a6
	cp 006h			;82a9
	ld a,(iy+00dh)		;82ab
	jr z,$+3		;82ae
	rra			;82b0
	and 003h		;82b1
	add a,b			;82b3
	ld hl,082c0h		;82b4
	add a,l			;82b7
	ld l,a			;82b8
	jr nc,$+3		;82b9
	inc h			;82bb
	dec de			;82bc
	ldi			;82bd
	ret			;82bf
	xor b			;82c0
	or h			;82c1
	or b			;82c2
	xor h			;82c3
	ld h,h			;82c4
	ld l,b			;82c5
	ld l,h			;82c6
	ld (hl),b		;82c7
	inc (iy+000h)		;82c8
	push iy			;82cb
	pop hl			;82cd
	inc l			;82ce
	ld a,(0e0c6h)		;82cf
	ld (hl),a		;82d2
	inc l			;82d3
	inc l			;82d4
	ld e,(ix+003h)		;82d5
	ld (hl),e		;82d8
	inc l			;82d9
	inc l			;82da
	ld d,(ix+005h)		;82db
	ld (hl),d		;82de
	push iy			;82df
	pop de			;82e1
	ld a,00ah		;82e2
	add a,e			;82e4
	ld e,a			;82e5
	ld a,(iy+001h)		;82e6
	dec a			;82e9
	ld hl,08301h		;82ea
	add a,l			;82ed
	ld l,a			;82ee
	jr nc,$+3		;82ef
	inc h			;82f1
	ldi			;82f2
	ld a,00fh		;82f4
	ld (de),a		;82f6
	ld a,(iy+001h)		;82f7
	cp 00bh			;82fa
	ret nz			;82fc
	ld a,008h		;82fd
	ld (de),a		;82ff
	ret			;8300
	ld (hl),h		;8301
	ld e,b			;8302
	ld e,b			;8303
	ld h,b			;8304
	ld h,b			;8305
	ld h,h			;8306
	ld e,b			;8307
	ld h,b			;8308
	nop			;8309
	add a,h			;830a
	add a,h			;830b
	sub b			;830c
	sbc a,b			;830d
	sbc a,b			;830e
	ld a,(0e600h)		;830f
	cp 002h			;8312
	ret nc			;8314
	push iy			;8315
	pop ix			;8317
	ld a,(0e60ch)		;8319
	and a			;831c
	jr z,$+8		;831d
	dec a			;831f
	jr z,$+42		;8320
	dec a			;8322
	jr z,$+101		;8323
	call 0877fh		;8325
	jr c,$+96		;8328
	ld (iy+000h),000h	;832a
	ld (iy+003h),0e0h	;832e
	ld a,(0e60ch)		;8332
	cp 003h			;8335
	ret z			;8337
	ld hl,0e600h		;8338
	ld a,002h		;833b
	cp (hl)			;833d
	ret z			;833e
	ld (hl),a		;833f
	ld a,090h		;8340
	ld (0e60bh),a		;8342
	ld a,0aeh		;8345
	jp 0490ch		;8347
	call 08858h		;834a
	ld a,(0e602h)		;834d
	sub 009h		;8350
	ld (0e0d0h),a		;8352
	ld a,(0e604h)		;8355
	ld (0e0d1h),a		;8358
	ld de,00810h		;835b
	call 088d3h		;835e
	jr c,$-60		;8361
	ld a,011h		;8363
	call 0490ch		;8365
	xor a			;8368
	ld (ix+000h),a		;8369
	ld (ix+003h),0e0h	;836c
	ld a,(iy+001h)		;8370
	cp 007h			;8373
	ld hl,0e60fh		;8375
	ld a,(hl)		;8378
	ld b,001h		;8379
	jr c,$+4		;837b
	ld b,004h		;837d
	sub b			;837f
	ld (hl),a		;8380
	ret p			;8381
	xor a			;8382
	ld (hl),a		;8383
	ld (0e60ch),a		;8384
	ret			;8387
	ld a,(0e3b0h)		;8388
	cp 004h			;838b
	ret nc			;838d
	ld a,(iy+001h)		;838e
	cp 006h			;8391
	ret nz			;8393
	ld hl,0e620h		;8394
	ld a,(hl)		;8397
	rla			;8398
	jr c,$+10		;8399
	call 08788h		;839b
	ld hl,0e625h		;839e
	jr nc,$+32		;83a1
	ld hl,0e630h		;83a3
	ld a,(hl)		;83a6
	rla			;83a7
	jr c,$+10		;83a8
	call 08788h		;83aa
	ld hl,0e635h		;83ad
	jr nc,$+17		;83b0
	ld hl,0e640h		;83b2
	ld a,(hl)		;83b5
	rla			;83b6
	jr c,$+37		;83b7
	call 08788h		;83b9
	ld hl,0e645h		;83bc
	jr c,$+29		;83bf
	ld a,(hl)		;83c1
	srl a			;83c2
	cp 003h			;83c4
	jr nc,$+9		;83c6
	dec l			;83c8
	dec l			;83c9
	dec l			;83ca
	dec l			;83cb
	dec l			;83cc
	set 7,(hl)		;83cd
	ld a,04dh		;83cf
	call 04901h		;83d1
	ld (ix+000h),003h	;83d4
	ld (ix+00dh),007h	;83d8
	push ix			;83dc
	pop iy			;83de
	ret			;83e0
	ld b,a			;83e1
	ld c,000h		;83e2
	cp 041h			;83e4
	jr c,$+24		;83e6
	inc c			;83e8
	cp 080h			;83e9
	jr nc,$+7		;83eb
	ld a,080h		;83ed
	sub b			;83ef
	jr $+14			;83f0
	inc c			;83f2
	cp 0c0h			;83f3
	jr nc,$+6		;83f5
	sub 080h		;83f7
	jr $+5			;83f9
	inc c			;83fb
	neg			;83fc
	ld b,a			;83fe
	ex af,af'		;83ff
	ld a,b			;8400
	ex af,af'		;8401
	ld hl,0844eh		;8402
	add a,l			;8405
	ld l,a			;8406
	jr nc,$+3		;8407
	inc h			;8409
	ld d,000h		;840a
	ld e,(hl)		;840c
	ld a,c			;840d
	sub 001h		;840e
	cp 002h			;8410
	ld a,e			;8412
	jr nc,$+5		;8413
	dec d			;8415
	neg			;8416
	ld e,a			;8418
	ld hl,0844eh		;8419
	ld a,040h		;841c
	sub b			;841e
	add a,l			;841f
	ld l,a			;8420
	jr nc,$+3		;8421
	inc h			;8423
	ld b,000h		;8424
	ld a,c			;8426
	cp 002h			;8427
	ld a,(hl)		;8429
	jr nc,$+5		;842a
	dec b			;842c
	neg			;842d
	ld c,a			;842f
	exx			;8430
	ex af,af'		;8431
	ld b,a			;8432
	ld hl,0848fh		;8433
	add a,l			;8436
	ld l,a			;8437
	jr nc,$+3		;8438
	inc h			;843a
	ld d,(hl)		;843b
	ld hl,0848fh		;843c
	ld a,040h		;843f
	sub b			;8441
	add a,l			;8442
	ld l,a			;8443
	jr nc,$+3		;8444
	inc h			;8446
	ld e,(hl)		;8447
	ld (0e0cfh),de		;8448
	exx			;844c
	ret			;844d
	rst 38h			;844e
	rst 38h			;844f
	rst 38h			;8450
	rst 38h			;8451
	cp 0feh			;8452
	defb 0fdh,0fch,0fbh ;illegal sequence	;8454
	ld sp,hl		;8457
	ret m			;8458
	or 0f4h			;8459
	di			;845b
	pop af			;845c
	xor 0ech		;845d
	jp pe,0e4e7h		;845f
	pop hl			;8462
	sbc a,0dch		;8463
	exx			;8465
	call nc,0cdd1h		;8466
	ret			;8469
	push bc			;846a
	pop bc			;846b
	cp l			;846c
	cp c			;846d
	or l			;846e
	or b			;846f
	xor e			;8470
	and a			;8471
	and d			;8472
	sbc a,l			;8473
	sbc a,b			;8474
	sub e			;8475
	adc a,(hl)		;8476
	adc a,b			;8477
	add a,e			;8478
	ld a,(hl)		;8479
	ld a,b			;847a
	ld (hl),e		;847b
	ld l,c			;847c
	ld h,a			;847d
	ld h,c			;847e
	ld e,h			;847f
	ld d,(hl)		;8480
	ld d,b			;8481
	ld c,d			;8482
	ld b,h			;8483
	ld a,038h		;8484
	ld l,02bh		;8486
	cpl			;8488
	rra			;8489
	add hl,de		;848a
	ld (de),a		;848b
	inc c			;848c
	ld b,001h		;848d
	add a,b			;848f
	ld a,a			;8490
	ld a,a			;8491
	ld a,a			;8492
	ld a,a			;8493
	ld a,a			;8494
	ld a,(hl)		;8495
	ld a,(hl)		;8496
	ld a,l			;8497
	ld a,h			;8498
	ld a,h			;8499
	ld a,e			;849a
	ld (hl),h		;849b
	ld a,c			;849c
	ld a,b			;849d
	ld (hl),a		;849e
	ld (hl),l		;849f
	ld (hl),h		;84a0
	ld (hl),e		;84a1
	ld (hl),c		;84a2
	ld (hl),b		;84a3
	ld l,(hl)		;84a4
	ld l,l			;84a5
	ld l,e			;84a6
	ld l,c			;84a7
	ld h,a			;84a8
	ld h,(hl)		;84a9
	ld h,h			;84aa
	ld h,d			;84ab
	ld e,a			;84ac
	ld e,l			;84ad
	ld e,e			;84ae
	ld e,c			;84af
	ld d,a			;84b0
	ld d,h			;84b1
	ld d,d			;84b2
	ld c,a			;84b3
	ld c,l			;84b4
	ld c,d			;84b5
	ld c,b			;84b6
	ld b,l			;84b7
	ld b,d			;84b8
	ld b,b			;84b9
	dec a			;84ba
	ld a,(03437h)		;84bb
	ld sp,02b2eh		;84be
	jr z,$+39		;84c1
	ld (01c1fh),hl		;84c3
	add hl,de		;84c6
	ld d,013h		;84c7
	rrca			;84c9
	inc c			;84ca
	add hl,bc		;84cb
	ld b,003h		;84cc
	ld bc,0f600h		;84ce
	inc b			;84d1
	ld h,(hl)		;84d2
	ld (bc),a		;84d3
	ld a,l			;84d4
	ld bc,000ffh		;84d5
	xor d			;84d8
	nop			;84d9
	ld l,c			;84da
	nop			;84db
	ld (00000h),a		;84dc
	nop			;84df
	ld a,(0e602h)		;84e0
	add a,008h		;84e3
	ld l,a			;84e5
	ld a,(0e604h)		;84e6
	add a,008h		;84e9
	ld h,a			;84eb
	ld d,001h		;84ec
	ld a,l			;84ee
	add a,008h		;84ef
	sub (ix+003h)		;84f1
	ld b,000h		;84f4
	jr z,$+9		;84f6
	ld b,a			;84f8
	jr nc,$+6		;84f9
	dec d			;84fb
	neg			;84fc
	ld b,a			;84fe
	ld a,h			;84ff
	add a,008h		;8500
	sub (ix+005h)		;8502
	ld e,000h		;8505
	ld c,000h		;8507
	jr z,$+9		;8509
	ld c,a			;850b
	jr nc,$+6		;850c
	inc e			;850e
	neg			;850f
	ld c,a			;8511
	ld a,d			;8512
	add a,e			;8513
	cp 001h			;8514
	jr nz,$+7		;8516
	dec d			;8518
	jr nz,$+4		;8519
	ld a,003h		;851b
	ld d,a			;851d
	ld l,b			;851e
	ld h,000h		;851f
	ld b,c			;8521
	push de			;8522
	call 08569h		;8523
	ld hl,084d0h		;8526
	ld b,040h		;8529
	ld a,(hl)		;852b
	inc hl			;852c
	push hl			;852d
	ld h,(hl)		;852e
	ld l,a			;852f
	and a			;8530
	sbc hl,de		;8531
	pop hl			;8533
	jr c,$+9		;8534
	inc hl			;8536
	ld a,b			;8537
	sub 008h		;8538
	ld b,a			;853a
	jr nz,$-16		;853b
	pop de			;853d
	dec d			;853e
	jr nz,$+8		;853f
	ld a,040h		;8541
	sub b			;8543
	add a,040h		;8544
	ret			;8546
	dec d			;8547
	jr nz,$+6		;8548
	ld a,080h		;854a
	add a,b			;854c
	ret			;854d
	ld a,b			;854e
	dec d			;854f
	ret nz			;8550
	neg			;8551
	ret			;8553
	ld c,008h		;8554
	xor a			;8556
	adc hl,hl		;8557
	ld a,h			;8559
	jr c,$+5		;855a
	cp b			;855c
	jr c,$+5		;855d
	sub b			;855f
	ld h,a			;8560
	xor a			;8561
	ccf			;8562
	dec c			;8563
	jr nz,$-13		;8564
	rl l			;8566
	ret			;8568
	ld a,b			;8569
	or a			;856a
	jr z,$+16		;856b
	ld de,00000h		;856d
	call 08554h		;8570
	ld d,l			;8573
	ld l,000h		;8574
	call 08554h		;8576
	ld e,l			;8579
	ret			;857a
	dec a			;857b
	ld d,a			;857c
	ld e,a			;857d
	ret			;857e
	ld hl,0865ch		;857f
	ld (0e0c7h),hl		;8582
	ld a,b			;8585
	ld (0e0c6h),a		;8586
	ld hl,08747h		;8589
	dec a			;858c
	add a,l			;858d
	ld l,a			;858e
	jr nc,$+3		;858f
	inc h			;8591
	ld a,(hl)		;8592
	ld (0e0c3h),a		;8593
	call 084e0h		;8596
	ld hl,0e0c2h		;8599
	ld (hl),a		;859c
	inc l			;859d
	ld b,(hl)		;859e
	inc l			;859f
	xor a			;85a0
	ld (hl),a		;85a1
	call 0825eh		;85a2
	ret nc			;85a5
	ld a,(0e0c6h)		;85a6
	cp 005h			;85a9
	jr z,$+6		;85ab
	cp 00ah			;85ad
	jr nz,$+17		;85af
	ld hl,0e0c2h		;85b1
	ld b,(hl)		;85b4
	inc l			;85b5
	ld a,(hl)		;85b6
	add a,a			;85b7
	ld c,a			;85b8
	add a,a			;85b9
	add a,c			;85ba
	sub b			;85bb
	neg			;85bc
	dec l			;85be
	ld (hl),a		;85bf
	xor a			;85c0
	ld (0e0c1h),a		;85c1
	ld iy,0e200h		;85c4
	ld a,(iy+000h)		;85c8
	or a			;85cb
	jr nz,$+52		;85cc
	ld hl,085f8h		;85ce
	push hl			;85d1
	call 082c8h		;85d2
	ld a,(0e0c6h)		;85d5
	dec a			;85d8
	call 0406ch		;85d9
	rrca			;85dc
	add a,(hl)		;85dd
	ld b,(hl)		;85de
	add a,(hl)		;85df
	ld b,(hl)		;85e0
	add a,(hl)		;85e1
	ld b,(hl)		;85e2
	add a,(hl)		;85e3
	ccf			;85e4
	add a,(hl)		;85e5
	ld b,(hl)		;85e6
	add a,(hl)		;85e7
	ld c,h			;85e8
	add a,(hl)		;85e9
	ld b,(hl)		;85ea
	add a,(hl)		;85eb
	ld b,(hl)		;85ec
	add a,(hl)		;85ed
	ld (hl),086h		;85ee
	ld b,(hl)		;85f0
	add a,(hl)		;85f1
	ld (hl),h		;85f2
	add a,(hl)		;85f3
	ld b,(hl)		;85f4
	add a,(hl)		;85f5
	ld b,(hl)		;85f6
	add a,(hl)		;85f7
	ld hl,0e0c4h		;85f8
	inc (hl)		;85fb
	ld a,(hl)		;85fc
	dec l			;85fd
	cp (hl)			;85fe
	ret z			;85ff
	ld de,00010h		;8600
	add iy,de		;8603
	ld hl,0e0c1h		;8605
	inc (hl)		;8608
	ld a,(hl)		;8609
	cp 008h			;860a
	ret z			;860c
	jr $-69			;860d
	ld a,(0e0c2h)		;860f
	rra			;8612
	rra			;8613
	rra			;8614
	rra			;8615
	and 00fh		;8616
	ld de,08626h		;8618
	add a,e			;861b
	ld e,a			;861c
	jr nc,$+3		;861d
	inc d			;861f
	ld a,(de)		;8620
	ld (iy+00ah),a		;8621
	jr $+34			;8624
	adc a,h			;8626
	adc a,b			;8627
	adc a,b			;8628
	inc c			;8629
	inc c			;862a
	add a,b			;862b
	add a,b			;862c
	ld a,h			;862d
	ld a,h			;862e
	ld a,b			;862f
	ld a,b			;8630
	ld (hl),h		;8631
	ld (hl),h		;8632
	sub b			;8633
	sub b			;8634
	adc a,h			;8635
	ld hl,0e0c2h		;8636
	ld a,(hl)		;8639
	add a,00ah		;863a
	ld (hl),a		;863c
	jr $+9			;863d
	ld hl,0e0c2h		;863f
	ld a,(hl)		;8642
	add a,010h		;8643
	ld (hl),a		;8645
	call 086b5h		;8646
	jp 0871eh		;8649
	ld hl,(0e0c7h)		;864c
	ld c,(hl)		;864f
	inc hl			;8650
	ld b,(hl)		;8651
	inc hl			;8652
	ld e,(hl)		;8653
	inc hl			;8654
	ld d,(hl)		;8655
	inc hl			;8656
	ld (0e0c7h),hl		;8657
	jr $-17			;865a
	nop			;865c
	defb 0fdh,000h,000h ;illegal sequence	;865d
	add a,b			;8660
	cp 040h			;8661
	cp 080h			;8663
	ld bc,0fe40h		;8665
	nop			;8668
	inc bc			;8669
	nop			;866a
	nop			;866b
	add a,b			;866c
	ld bc,001c0h		;866d
	add a,b			;8670
	cp 0c0h			;8671
	ld bc,0c43ah		;8673
	ret po			;8676
	ld hl,0868ch		;8677
	call 0405bh		;867a
	ld a,(hl)		;867d
	add a,(iy+005h)		;867e
	ld (iy+005h),a		;8681
	ld bc,00300h		;8684
	ld de,00000h		;8687
	jr $-65			;868a
	ex de,hl		;868c
	dec d			;868d
	ld a,(0e0c2h)		;868e
	ld b,a			;8691
	ld a,020h		;8692
	sub b			;8694
	neg			;8695
	ld b,a			;8697
	ld a,(ix+001h)		;8698
	and 0f0h		;869b
	cp 010h			;869d
	jr z,$+15		;869f
	ld a,(0e003h)		;86a1
	rra			;86a4
	ld c,a			;86a5
	ld a,(0e105h)		;86a6
	add a,c			;86a9
	and 03fh		;86aa
	add a,b			;86ac
	ld b,a			;86ad
	ld a,b			;86ae
	ld (0e0c2h),a		;86af
	call 083e1h		;86b2
	ld a,(0e0c2h)		;86b5
	call 083e1h		;86b8
	ld a,(iy+001h)		;86bb
	dec a			;86be
	add a,a			;86bf
	ld hl,0872bh		;86c0
	add a,l			;86c3
	ld l,a			;86c4
	jr nc,$+3		;86c5
	inc h			;86c7
	ld a,(0e068h)		;86c8
	and a			;86cb
	jr nz,$+9		;86cc
	ld a,(0e062h)		;86ce
	cp 004h			;86d1
	jr c,$+3		;86d3
	inc hl			;86d5
	ld a,(hl)		;86d6
	and 00fh		;86d7
	dec a			;86d9
	dec a			;86da
	jr z,$+35		;86db
	dec a			;86dd
	jr z,$+19		;86de
	sla c			;86e0
	rl b			;86e2
	sla c			;86e4
	rl b			;86e6
	sla e			;86e8
	rl d			;86ea
	sla e			;86ec
	rl d			;86ee
	ret			;86f0
	ld h,b			;86f1
	ld l,c			;86f2
	add hl,hl		;86f3
	add hl,bc		;86f4
	ld b,h			;86f5
	ld c,l			;86f6
	ld h,d			;86f7
	ld l,e			;86f8
	add hl,hl		;86f9
	add hl,de		;86fa
	ld d,h			;86fb
	ld e,l			;86fc
	ret			;86fd
	ld a,(hl)		;86fe
	ld h,b			;86ff
	ld l,c			;8700
	add hl,hl		;8701
	ld b,h			;8702
	ld c,l			;8703
	ld h,d			;8704
	ld l,e			;8705
	add hl,hl		;8706
	ld d,h			;8707
	ld e,l			;8708
	rla			;8709
	ret nc			;870a
	ld a,(0e0ceh)		;870b
	ld l,a			;870e
	ld h,000h		;870f
	add hl,bc		;8711
	ld b,h			;8712
	ld c,l			;8713
	ld a,(0e0cfh)		;8714
	ld l,a			;8717
	ld h,000h		;8718
	add hl,de		;871a
	ld d,h			;871b
	ld e,l			;871c
	ret			;871d
	ld (iy+006h),c		;871e
	ld (iy+007h),b		;8721
	ld (iy+008h),e		;8724
	ld (iy+009h),d		;8727
	ret			;872a
	inc bc			;872b
	inc b			;872c
	add a,d			;872d
	inc bc			;872e
	ld (bc),a		;872f
	add a,d			;8730
	inc bc			;8731
	inc b			;8732
	inc bc			;8733
	inc b			;8734
	ld (bc),a		;8735
	add a,d			;8736
	inc bc			;8737
	inc b			;8738
	inc b			;8739
	inc b			;873a
	nop			;873b
	nop			;873c
	inc b			;873d
	inc b			;873e
	inc bc			;873f
	inc bc			;8740
	inc b			;8741
	inc b			;8742
	inc b			;8743
	inc b			;8744
	inc b			;8745
	inc b			;8746
	ld bc,00101h		;8747
	ld bc,00104h		;874a
	ld b,001h		;874d
	ld bc,00107h		;874f
	ld (bc),a		;8752
	ld bc,0cd01h		;8753
	and d			;8756
	add a,a			;8757
	call 0888fh		;8758
	jp 088d3h		;875b
	call 08814h		;875e
	call 0888fh		;8761
	jp 088d3h		;8764
	ld a,(ix+003h)		;8767
	cp 0d0h			;876a
	jr c,$+6		;876c
	cp 0fah			;876e
	jr c,$+13		;8770
	inc l			;8772
	inc l			;8773
	call 088a4h		;8774
	call 087a2h		;8777
	jp 088d3h		;877a
	scf			;877d
	ret			;877e
	call 0888fh		;877f
	call 08858h		;8782
	jp 088d3h		;8785
	ld a,(hl)		;8788
	rla			;8789
	jr c,$-13		;878a
	inc l			;878c
	inc l			;878d
	call 088a4h		;878e
	call 08858h		;8791
	jp 088d3h		;8794
	inc l			;8797
	inc l			;8798
	call 088a4h		;8799
	call 08804h		;879c
	jp 088d3h		;879f
	push de			;87a2
	ld a,(ix+001h)		;87a3
	and 00fh		;87a6
	add a,a			;87a8
	add a,a			;87a9
	ld hl,087c4h		;87aa
	add a,l			;87ad
	ld l,a			;87ae
	jr nc,$+3		;87af
	inc h			;87b1
	ld a,(ix+003h)		;87b2
	add a,(hl)		;87b5
	ld e,a			;87b6
	inc hl			;87b7
	ld a,(ix+005h)		;87b8
	add a,(hl)		;87bb
	ld d,a			;87bc
	inc hl			;87bd
	ld b,(hl)		;87be
	inc hl			;87bf
	ld c,(hl)		;87c0
	ex de,hl		;87c1
	pop de			;87c2
	ret			;87c3
	jp m,00cfah		;87c4
	inc c			;87c7
	call m,008fbh		;87c8
	ld a,(bc)		;87cb
	call m,008fbh		;87cc
	ld a,(bc)		;87cf
	call m,008fbh		;87d0
	ld a,(bc)		;87d3
	jp m,00cfah		;87d4
	inc c			;87d7
	ei			;87d8
	jp m,00a0ah		;87d9
	jp m,00cfah		;87dc
	inc c			;87df
	jp m,00afch		;87e0
	ex af,af'		;87e3
	cp 0fch			;87e4
	ex af,af'		;87e6
	ex af,af'		;87e7
	jp m,00cfah		;87e8
	inc c			;87eb
	call m,008fch		;87ec
	ex af,af'		;87ef
	ei			;87f0
	ei			;87f1
	ld a,(bc)		;87f2
	ld a,(bc)		;87f3
	jp m,00cfah		;87f4
	inc c			;87f7
	ei			;87f8
	jp m,00a0ah		;87f9
	ei			;87fc
	ei			;87fd
	ld a,(bc)		;87fe
	ld a,(bc)		;87ff
	ei			;8800
	ei			;8801
	ld a,(bc)		;8802
	ld a,(bc)		;8803
	ld a,(ix+006h)		;8804
	add a,004h		;8807
	ld l,a			;8809
	ld a,(ix+007h)		;880a
	add a,001h		;880d
	ld h,a			;880f
	ld bc,0080eh		;8810
	ret			;8813
	ld iy,0e3d0h		;8814
	ld a,(0e065h)		;8818
	and 00fh		;881b
	ld hl,08838h		;881d
	add a,a			;8820
	add a,a			;8821
	add a,l			;8822
	ld l,a			;8823
	jr nc,$+3		;8824
	inc h			;8826
	ld c,(hl)		;8827
	inc hl			;8828
	ld b,(hl)		;8829
	inc hl			;882a
	ld a,(iy+003h)		;882b
	add a,(hl)		;882e
	ld e,a			;882f
	inc hl			;8830
	ld a,(iy+005h)		;8831
	add a,(hl)		;8834
	ld h,a			;8835
	ld l,e			;8836
	ret			;8837
	inc h			;8838
	inc h			;8839
	ld (bc),a		;883a
	ld (bc),a		;883b
	ld a,(de)		;883c
	jr nz,$-2		;883d
	ei			;883f
	ex af,af'		;8840
	ex af,af'		;8841
	djnz $+18		;8842
	ld a,(de)		;8844
	jr nz,$+5		;8845
	rst 30h			;8847
	inc h			;8848
	jr nz,$+15		;8849
	ld (bc),a		;884b
	inc h			;884c
	dec h			;884d
	ex af,af'		;884e
	ld (bc),a		;884f
	inc c			;8850
	inc c			;8851
	jp m,020fah		;8852
	jr nz,$+10		;8855
	ex af,af'		;8857
	ld a,(ix+001h)		;8858
	dec a			;885b
	and 00fh		;885c
	ld hl,08871h		;885e
	add a,a			;8861
	add a,l			;8862
	ld l,a			;8863
	jr nc,$+3		;8864
	inc h			;8866
	ld c,(hl)		;8867
	inc hl			;8868
	ld b,(hl)		;8869
	ld l,(ix+003h)		;886a
	ld h,(ix+005h)		;886d
	ret			;8870
	ex af,af'		;8871
	ex af,af'		;8872
	ld (bc),a		;8873
	inc bc			;8874
	inc b			;8875
	inc b			;8876
	ex af,af'		;8877
	ex af,af'		;8878
	ex af,af'		;8879
	ex af,af'		;887a
	ld a,(bc)		;887b
	ld a,(bc)		;887c
	inc b			;887d
	inc b			;887e
	ex af,af'		;887f
	ex af,af'		;8880
	ld c,00eh		;8881
	ex af,af'		;8883
	ex af,af'		;8884
	ex af,af'		;8885
	ex af,af'		;8886
	inc c			;8887
	inc c			;8888
	ex af,af'		;8889
	ex af,af'		;888a
	ex af,af'		;888b
	ex af,af'		;888c
	inc c			;888d
	djnz $+19		;888e
	ld (bc),a		;8890
	and 01ah		;8891
	add a,003h		;8893
	ld (0e0d0h),a		;8895
	inc e			;8898
	inc e			;8899
	ld a,(de)		;889a
	add a,003h		;889b
	ld (0e0d1h),a		;889d
	ld de,00a0ah		;88a0
	ret			;88a3
	ld e,(hl)		;88a4
	inc l			;88a5
	inc l			;88a6
	ld d,(hl)		;88a7
	ld (0e0d0h),de		;88a8
	inc l			;88ac
	ld a,(hl)		;88ad
	ld hl,088bbh		;88ae
	add a,a			;88b1
	add a,l			;88b2
	ld l,a			;88b3
	jr nc,$+3		;88b4
	inc h			;88b6
	ld e,(hl)		;88b7
	inc hl			;88b8
	ld d,(hl)		;88b9
	ret			;88ba
	inc b			;88bb
	ex af,af'		;88bc
	inc b			;88bd
	ex af,af'		;88be
	dec c			;88bf
	ex af,af'		;88c0
	dec c			;88c1
	ex af,af'		;88c2
	inc b			;88c3
	ex af,af'		;88c4
	dec c			;88c5
	ex af,af'		;88c6
	ld a,(bc)		;88c7
	ex af,af'		;88c8
	ld a,(bc)		;88c9
	ex af,af'		;88ca
	dec b			;88cb
	dec b			;88cc
	dec b			;88cd
	dec b			;88ce
	dec b			;88cf
	ex af,af'		;88d0
	dec b			;88d1
	ex af,af'		;88d2
	ld a,(0e0d0h)		;88d3
	add a,d			;88d6
	sub l			;88d7
	ld l,a			;88d8
	ld a,b			;88d9
	add a,d			;88da
	cp l			;88db
	ret c			;88dc
	ld a,(0e0d1h)		;88dd
	add a,e			;88e0
	sub h			;88e1
	ld h,a			;88e2
	ld a,c			;88e3
	add a,e			;88e4
	cp h			;88e5
	ret			;88e6
	ld a,(0e3b0h)		;88e7
	and a			;88ea
	ret z			;88eb
	ld a,(0e065h)		;88ec
	call 0406ch		;88ef
	sub l			;88f2
	adc a,d			;88f3
	inc (hl)		;88f4
	adc a,(hl)		;88f5
	sub b			;88f6
	sub b			;88f7
	ld bc,09592h		;88f8
	adc a,d			;88fb
	sub l			;88fc
	adc a,d			;88fd
	dec e			;88fe
	sub h			;88ff
	call po,03e95h		;8900
	dec b			;8903
	ld (0e3b0h),a		;8904
	ld (0e3c0h),a		;8907
	ld b,00ah		;890a
	ld hl,0e200h		;890c
	ld de,0000dh		;890f
	ld (hl),000h		;8912
	inc hl			;8914
	inc hl			;8915
	inc hl			;8916
	ld (hl),0e0h		;8917
	add hl,de		;8919
	djnz $-8		;891a
	call 08a2ah		;891c
	ld a,040h		;891f
	ld (0e3b1h),a		;8921
	ld a,017h		;8924
	jp 04901h		;8926
	call 098dbh		;8929
	ld a,(0e3bfh)		;892c
	and a			;892f
	ret			;8930
	ld bc,0440ah		;8931
	ld de,00405h		;8934
	exx			;8937
	ld bc,04806h		;8938
	ld de,00000h		;893b
	exx			;893e
	ld a,00ah		;893f
	ld (0e3bah),a		;8941
	ld hl,0e320h		;8944
	exx			;8947
	ld hl,0e320h		;8948
	exx			;894b
	ld ix,08999h		;894c
	ld a,(0e3d3h)		;8950
	add a,(ix+000h)		;8953
	add a,e			;8956
	ld (hl),a		;8957
	inc hl			;8958
	ld a,(0e3d5h)		;8959
	add a,(ix+001h)		;895c
	add a,d			;895f
	ld (hl),a		;8960
	inc hl			;8961
	ld (hl),b		;8962
	inc hl			;8963
	ld (hl),c		;8964
	inc hl			;8965
	exx			;8966
	inc hl			;8967
	inc hl			;8968
	inc hl			;8969
	inc hl			;896a
	inc ix			;896b
	inc ix			;896d
	ld a,(0e3bah)		;896f
	dec a			;8972
	ld (0e3bah),a		;8973
	jr nz,$-38		;8976
	ret			;8978
	ld bc,04c0ah		;8979
	ld de,00208h		;897c
	exx			;897f
	ld bc,05006h		;8980
	ld de,00000h		;8983
	exx			;8986
	jr $-72			;8987
	ld bc,05406h		;8989
	ld de,00000h		;898c
	exx			;898f
	ld bc,0ff00h		;8990
	ld de,00000h		;8993
	exx			;8996
	jr $-88			;8997
	nop			;8999
	nop			;899a
	nop			;899b
	nop			;899c
	ex af,af'		;899d
	ret p			;899e
	ex af,af'		;899f
	ret p			;89a0
	ld (de),a		;89a1
	djnz $+20		;89a2
	djnz $+28		;89a4
	inc d			;89a6
	ld a,(de)		;89a7
	inc d			;89a8
	rra			;89a9
	jp m,0fa1fh		;89aa
	ld ix,0e3d0h		;89ad
	ld de,0e320h		;89b1
	ld a,(ix+003h)		;89b4
	add a,(hl)		;89b7
	ld (de),a		;89b8
	inc hl			;89b9
	inc de			;89ba
	ld a,(ix+005h)		;89bb
	add a,(hl)		;89be
	ld (de),a		;89bf
	inc hl			;89c0
	inc de			;89c1
	ld a,(hl)		;89c2
	ld (de),a		;89c3
	inc hl			;89c4
	inc de			;89c5
	ld a,(hl)		;89c6
	ld (de),a		;89c7
	inc hl			;89c8
	inc de			;89c9
	djnz $-22		;89ca
	ret			;89cc
	ld hl,(0e3b7h)		;89cd
	ld a,(0e3d3h)		;89d0
	sub l			;89d3
	neg			;89d4
	ld (0e3b6h),a		;89d6
	ld h,a			;89d9
	ld a,(0e3b3h)		;89da
	ld e,a			;89dd
	call 08a16h		;89de
	ld de,(0e3d6h)		;89e1
	add hl,de		;89e5
	ld (0e3d6h),hl		;89e6
	ld de,(0e3d2h)		;89e9
	add hl,de		;89ed
	ld (0e3d2h),hl		;89ee
	ld hl,(0e3b7h)		;89f1
	ld a,(0e3d5h)		;89f4
	sub h			;89f7
	neg			;89f8
	ld (0e3b5h),a		;89fa
	ld h,a			;89fd
	ld a,(0e3b4h)		;89fe
	ld e,a			;8a01
	call 08a16h		;8a02
	ld de,(0e3d8h)		;8a05
	add hl,de		;8a09
	ld (0e3d8h),hl		;8a0a
	ld de,(0e3d4h)		;8a0d
	add hl,de		;8a11
	ld (0e3d4h),hl		;8a12
	ret			;8a15
	bit 7,h			;8a16
	jp z,08a73h		;8a18
	ld a,h			;8a1b
	neg			;8a1c
	ld h,a			;8a1e
	call 08a73h		;8a1f
	ld a,l			;8a22
	cpl			;8a23
	ld l,a			;8a24
	ld a,h			;8a25
	cpl			;8a26
	ld h,a			;8a27
	inc hl			;8a28
	ret			;8a29
	ld de,0e358h		;8a2a
	ld hl,0e200h		;8a2d
	exx			;8a30
	ld b,00ah		;8a31
	exx			;8a33
	ld a,(hl)		;8a34
	and a			;8a35
	jr nz,$+13		;8a36
	ld a,0e0h		;8a38
	ld (de),a		;8a3a
	inc e			;8a3b
	inc e			;8a3c
	inc e			;8a3d
	inc e			;8a3e
	ld a,010h		;8a3f
	jr $+20			;8a41
	inc l			;8a43
	inc l			;8a44
	inc l			;8a45
	ldi			;8a46
	inc l			;8a48
	ldi			;8a49
	inc l			;8a4b
	inc l			;8a4c
	inc l			;8a4d
	inc l			;8a4e
	ldi			;8a4f
	ldi			;8a51
	ld a,004h		;8a53
	call 0405bh		;8a55
	exx			;8a58
	djnz $-38		;8a59
	ret			;8a5b
	ld ix,0e200h		;8a5c
	ld b,00ah		;8a60
	push bc			;8a62
	ld a,(ix+000h)		;8a63
	dec a			;8a66
	call z,079a8h		;8a67
	pop bc			;8a6a
	ld de,00010h		;8a6b
	add ix,de		;8a6e
	djnz $-14		;8a70
	ret			;8a72
	ld l,000h		;8a73
	ld d,l			;8a75
	ld b,008h		;8a76
	add hl,hl		;8a78
	jr nc,$+3		;8a79
	add hl,de		;8a7b
	djnz $-4		;8a7c
	sra h			;8a7e
	rr l			;8a80
	sra h			;8a82
	rr l			;8a84
	sra h			;8a86
	rr l			;8a88
	ret			;8a8a
	ld hl,(0e3b1h)		;8a8b
	dec hl			;8a8e
	ld (0e3b1h),hl		;8a8f
	ld a,l			;8a92
	or h			;8a93
	ret			;8a94
	ld a,(0e3b0h)		;8a95
	dec a			;8a98
	ret m			;8a99
	cp 002h			;8a9a
	jr nz,$+7		;8a9c
	push af			;8a9e
	call 08dc6h		;8a9f
	pop af			;8aa2
	call 0406ch		;8aa3
	or h			;8aa6
	adc a,d			;8aa7
	jp m,01b8ah		;8aa8
	adc a,e			;8aab
	or b			;8aac
	adc a,e			;8aad
	xor h			;8aae
	sub d			;8aaf
	jp 0d292h		;8ab0
	sub d			;8ab3
	ld hl,0e3d0h		;8ab4
	ld de,0e3d1h		;8ab7
	ld bc,0003fh		;8aba
	ld (hl),000h		;8abd
	ldir			;8abf
	ld a,0d8h		;8ac1
	ld (0e3d3h),a		;8ac3
	ld a,070h		;8ac6
	ld (0e3d5h),a		;8ac8
	ld a,(0e065h)		;8acb
	ld hl,08c14h		;8ace
	call 0405bh		;8ad1
	ld a,(hl)		;8ad4
	ld (0e3e0h),a		;8ad5
	ld hl,08c1ch		;8ad8
	call 04079h		;8adb
	ld (0e3b1h),hl		;8ade
	ld a,080h		;8ae1
	ld (0e3f0h),a		;8ae3
	ld de,0af73h		;8ae6
	ld hl,01cc0h		;8ae9
	call 04412h		;8aec
	ld de,0ad17h		;8aef
	ld hl,01e00h		;8af2
	call 04412h		;8af5
	jr $+27			;8af8
	ld a,(0e090h)		;8afa
	and 03fh		;8afd
	cp 001h			;8aff
	ret nz			;8b01
	ld hl,0e3d3h		;8b02
	ld a,(hl)		;8b05
	add a,008h		;8b06
	ld (hl),a		;8b08
	ret m			;8b09
	cp 020h			;8b0a
	ret c			;8b0c
	call 08d87h		;8b0d
	call 08bd7h		;8b10
	jp 09233h		;8b13
	ld a,004h		;8b16
	jp 08904h		;8b18
	call 08a8bh		;8b1b
	jr z,$-8		;8b1e
	ld a,(0e090h)		;8b20
	bit 4,a			;8b23
	ld a,000h		;8b25
	jr z,$+3		;8b27
	inc a			;8b29
	ld (0e3e1h),a		;8b2a
	call 08cf3h		;8b2d
	call 08cc2h		;8b30
	call 08c2eh		;8b33
	call 08929h		;8b36
	jr nz,$-35		;8b39
	ld a,(0e3d3h)		;8b3b
	add a,00ch		;8b3e
	ld (0e583h),a		;8b40
	ld a,(0e3d5h)		;8b43
	add a,00ah		;8b46
	ld (0e585h),a		;8b48
	ld a,(0e003h)		;8b4b
	and 01fh		;8b4e
	jr nz,$+19		;8b50
	ld a,(0e3e0h)		;8b52
	ld hl,08c22h		;8b55
	call 0405bh		;8b58
	ld b,(hl)		;8b5b
	ld ix,0e580h		;8b5c
	call 0857fh		;8b60
	ld hl,0e3dbh		;8b63
	ld a,(hl)		;8b66
	or a			;8b67
	jr nz,$+68		;8b68
	ld hl,(0e3d4h)		;8b6a
	ld a,h			;8b6d
	and 0fch		;8b6e
	add a,00ch		;8b70
	ld c,a			;8b72
	ld a,(0e3dah)		;8b73
	cp c			;8b76
	jr z,$+47		;8b77
	ld de,(0e3d8h)		;8b79
	add hl,de		;8b7d
	ld (0e3d4h),hl		;8b7e
	ld a,h			;8b81
	cp 020h			;8b82
	ld h,020h		;8b84
	ld e,050h		;8b86
	jr c,$+9		;8b88
	cp 0bfh			;8b8a
	ld h,0bfh		;8b8c
	ld e,088h		;8b8e
	ret c			;8b90
	ld (0e3d4h),hl		;8b91
	ld a,(0e065h)		;8b94
	cp 000h			;8b97
	jr z,$+13		;8b99
	ld a,d			;8b9b
	neg			;8b9c
	ld (0e3d9h),a		;8b9e
	ld a,e			;8ba1
	ld (0e3dah),a		;8ba2
	ret			;8ba5
	ld a,050h		;8ba6
	ld (0e3dbh),a		;8ba8
	ret			;8bab
	dec (hl)		;8bac
	ret nz			;8bad
	jr $+41			;8bae
	ld a,(0e065h)		;8bb0
	cp 005h			;8bb3
	jr nz,$+10		;8bb5
	ld hl,0e3f0h		;8bb7
	bit 7,(hl)		;8bba
	call z,08d00h		;8bbc
	call 09401h		;8bbf
	ld hl,0e3b1h		;8bc2
	dec (hl)		;8bc5
	ret nz			;8bc6
	ld (hl),030h		;8bc7
	call 08db7h		;8bc9
	ld a,(0e3d5h)		;8bcc
	add a,012h		;8bcf
	ld (0e3d5h),a		;8bd1
	jp 09299h		;8bd4
	ld a,(0e604h)		;8bd7
	and 0fch		;8bda
	ld b,a			;8bdc
	ld a,(0e3d5h)		;8bdd
	and 0fch		;8be0
	add a,00ch		;8be2
	cp b			;8be4
	ld hl,00000h		;8be5
	jr z,$+8		;8be8
	ld h,001h		;8bea
	jr c,$+4		;8bec
	ld h,0ffh		;8bee
	ld a,(0e065h)		;8bf0
	cp 000h			;8bf3
	jr z,$+8		;8bf5
	ld a,h			;8bf7
	or a			;8bf8
	jr nz,$+4		;8bf9
	ld h,001h		;8bfb
	ld (0e3d8h),hl		;8bfd
	inc h			;8c00
	ld a,(0e3e0h)		;8c01
	ld c,a			;8c04
	add a,a			;8c05
	add a,c			;8c06
	add a,h			;8c07
	ld hl,08c25h		;8c08
	call 0405bh		;8c0b
	ld a,(hl)		;8c0e
	add a,b			;8c0f
	ld (0e3dah),a		;8c10
	ret			;8c13
	nop			;8c14
	nop			;8c15
	nop			;8c16
	nop			;8c17
	ld bc,00002h		;8c18
	nop			;8c1b
	djnz $+16		;8c1c
	jr nz,$+30		;8c1e
	jr nz,$+30		;8c20
	ex af,af'		;8c22
	inc c			;8c23
	dec c			;8c24
	nop			;8c25
	nop			;8c26
	nop			;8c27
	ret po			;8c28
	djnz $+34		;8c29
	ret nc			;8c2b
	djnz $+50		;8c2c
	ld a,(0e065h)		;8c2e
	cp 000h			;8c31
	ret nz			;8c33
	ld a,(0e090h)		;8c34
	rra			;8c37
	ret c			;8c38
	ld ix,0e590h		;8c39
	ld b,003h		;8c3d
	ld hl,08cbfh		;8c3f
	ld a,b			;8c42
	call 0405bh		;8c43
	ld c,(hl)		;8c46
	inc (ix+018h)		;8c47
	ld a,(ix+018h)		;8c4a
	cp c			;8c4d
	jr nz,$+32		;8c4e
	ld a,(ix+000h)		;8c50
	or a			;8c53
	jr nz,$+26		;8c54
	ld (ix+000h),001h	;8c56
	ld (ix+001h),00ch	;8c5a
	ld (ix+003h),010h	;8c5e
	ld hl,0e666h		;8c62
	inc (hl)		;8c65
	ld a,(hl)		;8c66
	and 001h		;8c67
	add a,07fh		;8c69
	ld (ix+005h),a		;8c6b
	push bc			;8c6e
	ld a,(ix+001h)		;8c6f
	call 075eah		;8c72
	call 0749ah		;8c75
	call 07452h		;8c78
	pop bc			;8c7b
	ld a,b			;8c7c
	exx			;8c7d
	add a,a			;8c7e
	add a,a			;8c7f
	add a,a			;8c80
	ld de,0e338h		;8c81
	call 04060h		;8c84
	ld a,(ix+00ah)		;8c87
	cp 01ch			;8c8a
	ld hl,07896h		;8c8c
	jr z,$+5		;8c8f
	ld hl,0789eh		;8c91
	ld b,002h		;8c94
	ld a,(ix+000h)		;8c96
	or a			;8c99
	ld a,(ix+003h)		;8c9a
	jr nz,$+4		;8c9d
	ld a,0cah		;8c9f
	add a,(hl)		;8ca1
	ld (de),a		;8ca2
	inc hl			;8ca3
	inc de			;8ca4
	ld a,(ix+005h)		;8ca5
	add a,(hl)		;8ca8
	ld (de),a		;8ca9
	inc hl			;8caa
	inc de			;8cab
	ld a,(hl)		;8cac
	add a,0c0h		;8cad
	ld (de),a		;8caf
	inc hl			;8cb0
	inc de			;8cb1
	ldi			;8cb2
	djnz $-30		;8cb4
	exx			;8cb6
	ld de,00020h		;8cb7
	add ix,de		;8cba
	djnz $-125		;8cbc
	ret			;8cbe
	ld d,l			;8cbf
	xor d			;8cc0
	rst 38h			;8cc1
	ld a,(0e065h)		;8cc2
	cp 004h			;8cc5
	ret nz			;8cc7
	ld hl,0e3e2h		;8cc8
	ld a,(0e090h)		;8ccb
	and 07fh		;8cce
	jr nz,$+3		;8cd0
	inc (hl)		;8cd2
	bit 0,(hl)		;8cd3
	ret z			;8cd5
	or a			;8cd6
	jr nz,$+7		;8cd7
	ld a,047h		;8cd9
	call 04901h		;8cdb
	ld de,0bf4ah		;8cde
	ld bc,00303h		;8ce1
	ld a,(0e3d3h)		;8ce4
	add a,008h		;8ce7
	ld l,a			;8ce9
	ld a,(0e3d5h)		;8cea
	add a,008h		;8ced
	ld h,a			;8cef
	jp 08df1h		;8cf0
	ld a,(0e065h)		;8cf3
	cp 005h			;8cf6
	ret nz			;8cf8
	ld hl,0e3f0h		;8cf9
	bit 7,(hl)		;8cfc
	jr nz,$+39		;8cfe
	inc hl			;8d00
	inc (hl)		;8d01
	ld a,(hl)		;8d02
	inc hl			;8d03
	and 003h		;8d04
	jr nz,$+3		;8d06
	inc (hl)		;8d08
	ld a,(hl)		;8d09
	inc hl			;8d0a
	ld de,08e14h		;8d0b
	ld b,a			;8d0e
	cp 011h			;8d0f
	jr nc,$+59		;8d11
	sub 010h		;8d13
	neg			;8d15
	add a,a			;8d17
	call 04060h		;8d18
	ld c,002h		;8d1b
	ld h,(hl)		;8d1d
	ld l,050h		;8d1e
	call 08df1h		;8d20
	jr $+69			;8d23
	ld a,(0e604h)		;8d25
	ld b,a			;8d28
	ld a,(0e3d5h)		;8d29
	add a,01ah		;8d2c
	sub b			;8d2e
	cp 005h			;8d2f
	jr c,$+8		;8d31
	ld a,(0e003h)		;8d33
	and 07fh		;8d36
	ret nz			;8d38
	xor a			;8d39
	ld (hl),a		;8d3a
	inc a			;8d3b
	ld (0e3f2h),a		;8d3c
	ld a,(0e3d5h)		;8d3f
	add a,018h		;8d42
	ld (0e3f3h),a		;8d44
	ld a,05ah		;8d47
	jp 04901h		;8d49
	cp 015h			;8d4c
	jr c,$+26		;8d4e
	ld hl,0e3f0h		;8d50
	set 7,(hl)		;8d53
	ld hl,03940h		;8d55
	call 043b0h		;8d58
	exx			;8d5b
	ld hl,0e9e0h		;8d5c
	ld b,000h		;8d5f
	call 08dc3h		;8d61
	ld b,080h		;8d64
	jr $+93			;8d66
	ld a,(0e600h)		;8d68
	cp 002h			;8d6b
	ret nc			;8d6d
	ld hl,0e610h		;8d6e
	ld b,006h		;8d71
	ld a,(hl)		;8d73
	sub 06bh		;8d74
	cp 00ah			;8d76
	jr c,$+12		;8d78
	sub 060h		;8d7a
	cp 00ah			;8d7c
	jr c,$+6		;8d7e
	inc hl			;8d80
	djnz $-14		;8d81
	ret			;8d83
	jp 08338h		;8d84
	ld a,(0e065h)		;8d87
	ld hl,08dafh		;8d8a
	call 0405bh		;8d8d
	ld a,(hl)		;8d90
	inc a			;8d91
	ret z			;8d92
	push hl			;8d93
	pop ix			;8d94
	ld iy,0e08ah		;8d96
	ld (iy+000h),000h	;8d9a
	ld hl,0e92ch		;8d9e
	ld c,002h		;8da1
	call 06529h		;8da3
	ld de,00078h		;8da6
	add hl,de		;8da9
	ld c,002h		;8daa
	jp 06529h		;8dac
	nop			;8daf
	rst 38h			;8db0
	rst 38h			;8db1
	rst 38h			;8db2
	ld a,(de)		;8db3
	nop			;8db4
	rst 38h			;8db5
	djnz $+35		;8db6
	add a,b			;8db8
	jr c,$-49		;8db9
	or b			;8dbb
	ld b,e			;8dbc
	exx			;8dbd
	ld hl,0e920h		;8dbe
	ld b,0c0h		;8dc1
	jp 064f9h		;8dc3
	call 08db7h		;8dc6
	ld a,(0e3d3h)		;8dc9
	ld l,a			;8dcc
	ld a,(0e3d5h)		;8dcd
	ld h,a			;8dd0
	push hl			;8dd1
	ld a,(0e3e0h)		;8dd2
	ld hl,0becch		;8dd5
	call 04079h		;8dd8
	ld a,(0e3e1h)		;8ddb
	call 04071h		;8dde
	pop hl			;8de1
	ld bc,00605h		;8de2
	ld a,(0e065h)		;8de5
	cp 007h			;8de8
	jr nz,$+3		;8dea
	inc c			;8dec
	or a			;8ded
	jr nz,$+3		;8dee
	dec b			;8df0
	call 04372h		;8df1
	push bc			;8df4
	ld b,c			;8df5
	call 00053h		;8df6
	ld a,(00007h)		;8df9
	ld c,a			;8dfc
	ex de,hl		;8dfd
	call 08dc3h		;8dfe
	ex de,hl		;8e01
	ld a,020h		;8e02
	call 0405bh		;8e04
	push hl			;8e07
	ld bc,03ac0h		;8e08
	or a			;8e0b
	sbc hl,bc		;8e0c
	pop hl			;8e0e
	pop bc			;8e0f
	ret nc			;8e10
	djnz $-29		;8e11
	ret			;8e13
	ld l,h			;8e14
	bit 5,e			;8e15
	call z,0cb73h		;8e17
	ld l,e			;8e1a
	out (074h),a		;8e1b
	bit 5,h			;8e1d
	call z,0cb6ch		;8e1f
	ld l,e			;8e22
	call z,0cb73h		;8e23
	ld l,e			;8e26
	out (074h),a		;8e27
	bit 5,h			;8e29
	call z,0d575h		;8e2b
	sub c			;8e2e
	pop af			;8e2f
	sub d			;8e30
	jp p,09493h		;8e31
	ld a,(0e3b0h)		;8e34
	dec a			;8e37
	ret m			;8e38
	cp 004h			;8e39
	jr nc,$+6		;8e3b
	ld hl,0900ch		;8e3d
	push hl			;8e40
	call 0406ch		;8e41
	ld d,h			;8e44
	adc a,(hl)		;8e45
	jr c,$-108		;8e46
	ld l,c			;8e48
	adc a,(hl)		;8e49
	ld (hl),l		;8e4a
	adc a,(hl)		;8e4b
	adc a,a			;8e4c
	sub d			;8e4d
	xor h			;8e4e
	sub d			;8e4f
	jp 0d292h		;8e50
	sub d			;8e53
	call 0940fh		;8e54
	ld de,0ad69h		;8e57
	call 0440ch		;8e5a
	ld hl,01f80h		;8e5d
	ld de,0abdch		;8e60
	call 04412h		;8e63
	jp 09233h		;8e66
	ld hl,00140h		;8e69
	ld de,00180h		;8e6c
	ld bc,00e10h		;8e6f
	jp 09255h		;8e72
	call 08a8bh		;8e75
	jr z,$+30		;8e78
	call 089cdh		;8e7a
	call 08f43h		;8e7d
	call 08929h		;8e80
	jr nz,$+19		;8e83
	call 08ea2h		;8e85
	ld a,(0e003h)		;8e88
	and 00fh		;8e8b
	ret nz			;8e8d
	ld b,a			;8e8e
	ld ix,0e3d0h		;8e8f
	jp 08eebh		;8e93
	call 08902h		;8e96
	ld hl,0e3d3h		;8e99
	ld a,(hl)		;8e9c
	sub 010h		;8e9d
	ld (hl),a		;8e9f
	pop hl			;8ea0
	ret			;8ea1
	ld a,(0e600h)		;8ea2
	cp 002h			;8ea5
	ret z			;8ea7
	ld ix,0e200h		;8ea8
	exx			;8eac
	ld b,008h		;8ead
	exx			;8eaf
	ld a,(ix+000h)		;8eb0
	dec a			;8eb3
	jr nz,$+8		;8eb4
	call 08319h		;8eb6
	call 08ec5h		;8eb9
	exx			;8ebc
	ld de,00010h		;8ebd
	add ix,de		;8ec0
	djnz $-19		;8ec2
	ret			;8ec4
	ld hl,0e620h		;8ec5
	ld b,003h		;8ec8
	push bc			;8eca
	ld a,(hl)		;8ecb
	rla			;8ecc
	jr c,$+9		;8ecd
	push hl			;8ecf
	call 08788h		;8ed0
	pop hl			;8ed3
	jr nc,$+10		;8ed4
	pop bc			;8ed6
	ld de,00010h		;8ed7
	add hl,de		;8eda
	djnz $-17		;8edb
	ret			;8edd
	pop bc			;8ede
	pop bc			;8edf
	set 7,(hl)		;8ee0
	ld (ix+000h),000h	;8ee2
	ld (ix+003h),0e0h	;8ee6
	ret			;8eea
	ld hl,0e200h		;8eeb
	ld de,00010h		;8eee
	ld b,005h		;8ef1
	ld a,(hl)		;8ef3
	and a			;8ef4
	jr z,$+6		;8ef5
	add hl,de		;8ef7
	djnz $-5		;8ef8
	ret			;8efa
	ld (hl),001h		;8efb
	inc hl			;8efd
	ld (hl),006h		;8efe
	inc hl			;8f00
	inc hl			;8f01
	ld a,(0e3d3h)		;8f02
	add a,010h		;8f05
	ld (hl),a		;8f07
	inc hl			;8f08
	inc hl			;8f09
	ld a,(0e3d5h)		;8f0a
	add a,004h		;8f0d
	ld (hl),a		;8f0f
	push af			;8f10
	inc hl			;8f11
	ld (hl),000h		;8f12
	inc hl			;8f14
	ld (hl),000h		;8f15
	inc hl			;8f17
	ld de,00180h		;8f18
	pop af			;8f1b
	ld c,a			;8f1c
	ld a,(0e3cfh)		;8f1d
	and 002h		;8f20
	call z,08f3bh		;8f22
	ld (hl),e		;8f25
	inc hl			;8f26
	ld (hl),d		;8f27
	inc hl			;8f28
	ld (hl),07ch		;8f29
	inc hl			;8f2b
	ld (hl),00fh		;8f2c
	inc hl			;8f2e
	ld (hl),064h		;8f2f
	inc hl			;8f31
	ld (hl),c		;8f32
	inc hl			;8f33
	ld (hl),000h		;8f34
	ld hl,0e3cfh		;8f36
	inc (hl)		;8f39
	ret			;8f3a
	ld a,e			;8f3b
	cpl			;8f3c
	ld e,a			;8f3d
	ld a,d			;8f3e
	cpl			;8f3f
	ld d,a			;8f40
	inc de			;8f41
	ret			;8f42
	call 08f4fh		;8f43
	call 08a5ch		;8f46
	call 08fd2h		;8f49
	jp 08a2ah		;8f4c
	ld ix,0e200h		;8f4f
	ld b,008h		;8f53
	ld a,(ix+000h)		;8f55
	and a			;8f58
	jr z,$+100		;8f59
	ld a,(ix+00ch)		;8f5b
	sub (ix+003h)		;8f5e
	or a			;8f61
	jr nz,$+5		;8f62
	inc (ix+00eh)		;8f64
	ld e,(ix+006h)		;8f67
	ld d,(ix+007h)		;8f6a
	call 08fc5h		;8f6d
	ld (ix+006h),l		;8f70
	ld (ix+007h),h		;8f73
	xor a			;8f76
	bit 7,(ix+00eh)		;8f77
	jr nz,$+25		;8f7b
	ld a,(ix+00dh)		;8f7d
	sub (ix+005h)		;8f80
	ld c,a			;8f83
	or a			;8f84
	jr nz,$+15		;8f85
	ld a,(ix+00eh)		;8f87
	cp 002h			;8f8a
	ld a,c			;8f8c
	jr c,$+7		;8f8d
	set 7,(ix+00eh)		;8f8f
	xor a			;8f93
	ld e,(ix+008h)		;8f94
	ld d,(ix+009h)		;8f97
	call 08fc5h		;8f9a
	ld (ix+008h),l		;8f9d
	ld (ix+009h),h		;8fa0
	ld hl,0e020h		;8fa3
	ld a,01bh		;8fa6
	cp (hl)			;8fa8
	call nz,04901h		;8fa9
	ld a,(ix+000h)		;8fac
	cp 002h			;8faf
	jr z,$+12		;8fb1
	ld a,(0e003h)		;8fb3
	and 00ch		;8fb6
	add a,07ch		;8fb8
	ld (ix+00ah),a		;8fba
	ld de,00010h		;8fbd
	add ix,de		;8fc0
	djnz $-109		;8fc2
	ret			;8fc4
	sra a			;8fc5
	sra a			;8fc7
	ld l,a			;8fc9
	ld h,000h		;8fca
	add a,a			;8fcc
	jr nc,$+3		;8fcd
	dec h			;8fcf
	add hl,de		;8fd0
	ret			;8fd1
	ld ix,0e200h		;8fd2
	ld b,008h		;8fd6
	ld a,(ix+000h)		;8fd8
	and a			;8fdb
	jr z,$+40		;8fdc
	bit 7,(ix+007h)		;8fde
	jr z,$+34		;8fe2
	ld a,(0e3d3h)		;8fe4
	sub (ix+003h)		;8fe7
	add a,018h		;8fea
	cp 038h			;8fec
	jr nc,$+22		;8fee
	ld a,(0e3d5h)		;8ff0
	sub (ix+005h)		;8ff3
	add a,030h		;8ff6
	cp 050h			;8ff8
	jr nc,$+10		;8ffa
	ld (ix+000h),000h	;8ffc
	ld (ix+003h),0e0h	;9000
	ld de,00010h		;9004
	add ix,de		;9007
	djnz $-49		;9009
	ret			;900b
	ld hl,0902dh		;900c
	ld b,007h		;900f
	call 089adh		;9011
	call 09049h		;9014
	ld a,(0e3d1h)		;9017
	ld c,00fh		;901a
	cp 00ah			;901c
	jr c,$+10		;901e
	ld c,00ah		;9020
	cp 014h			;9022
	jr c,$+4		;9024
	ld c,007h		;9026
	ld a,c			;9028
	ld (0e323h),a		;9029
	ret			;902c
	nop			;902d
	nop			;902e
	ld h,b			;902f
	rrca			;9030
	ret p			;9031
	nop			;9032
	ld h,h			;9033
	inc b			;9034
	nop			;9035
	push af			;9036
	ld l,b			;9037
	inc b			;9038
	nop			;9039
	inc c			;903a
	ld l,h			;903b
	inc b			;903c
	djnz $-9		;903d
	ld (hl),b		;903f
	inc b			;9040
	djnz $+7		;9041
	ld (hl),h		;9043
	inc b			;9044
	djnz $+23		;9045
	ld a,b			;9047
	inc b			;9048
	ld hl,0e344h		;9049
	ld a,(0e3d3h)		;904c
	ld c,a			;904f
	ld a,(0e3d5h)		;9050
	sub 006h		;9053
	ld d,a			;9055
	ld b,000h		;9056
	ld a,c			;9058
	add a,028h		;9059
	ld e,a			;905b
	ld a,(0e065h)		;905c
	cp 003h			;905f
	jr nz,$+6		;9061
	ld a,e			;9063
	add a,010h		;9064
	ld e,a			;9066
	ld (hl),e		;9067
	ld a,(0e3b0h)		;9068
	cp 004h			;906b
	jr c,$+13		;906d
	ld (hl),048h		;906f
	ld a,(0e065h)		;9071
	cp 003h			;9074
	jr nz,$+4		;9076
	ld (hl),058h		;9078
	inc l			;907a
	ld a,b			;907b
	add a,a			;907c
	ld e,a			;907d
	add a,a			;907e
	add a,e			;907f
	add a,d			;9080
	ld (hl),a		;9081
	inc l			;9082
	ld (hl),0f8h		;9083
	inc l			;9085
	ld (hl),001h		;9086
	inc l			;9088
	inc b			;9089
	ld a,b			;908a
	cp 003h			;908b
	jr c,$-53		;908d
	ret			;908f
	ld a,(0e3c0h)		;9090
	or a			;9093
	jr nz,$+8		;9094
	call 09120h		;9096
	jp nc,08338h		;9099
	ld a,(0e3b0h)		;909c
	dec a			;909f
	ret m			;90a0
	cp 004h			;90a1
	jr nc,$+6		;90a3
	ld hl,09156h		;90a5
	push hl			;90a8
	call 0406ch		;90a9
	cp h			;90ac
	sub b			;90ad
	jr c,$-108		;90ae
	ld c,h			;90b0
	sub d			;90b1
	push hl			;90b2
	sub b			;90b3
	adc a,a			;90b4
	sub d			;90b5
	xor h			;90b6
	sub d			;90b7
	jp 0d292h		;90b8
	sub d			;90bb
	call 0940fh		;90bc
	ld hl,01c20h		;90bf
	ld de,0af73h		;90c2
	call 04412h		;90c5
	ld de,0b060h		;90c8
	call 0440ch		;90cb
	ld hl,01ca0h		;90ce
	ld de,01d50h		;90d1
	ld c,006h		;90d4
	call 04478h		;90d6
	ld hl,01e00h		;90d9
	ld de,0abdch		;90dc
	call 04412h		;90df
	jp 09233h		;90e2
	call 08a8bh		;90e5
	jp z,08902h		;90e8
	call 089cdh		;90eb
	call 09108h		;90ee
	jp nz,08902h		;90f1
	ld a,(0e3e1h)		;90f4
	or a			;90f7
	ret nz			;90f8
	ld a,(0e003h)		;90f9
	and 01fh		;90fc
	ret nz			;90fe
	ld b,00ah		;90ff
	ld ix,0e3d0h		;9101
	jp 0857fh		;9105
	ld a,(0e3e1h)		;9108
	or a			;910b
	jr nz,$+5		;910c
	jp 08929h		;910e
	ld hl,0911ch		;9111
	call 098e6h		;9114
	ld a,(0e3bfh)		;9117
	or a			;911a
	ret			;911b
	inc bc			;911c
	inc de			;911d
	cp 01ah			;911e
	ld a,(0e3d3h)		;9120
	add a,002h		;9123
	ld l,a			;9125
	ld a,(0e3d5h)		;9126
	sub 003h		;9129
	ld h,a			;912b
	ld a,(0e3e1h)		;912c
	or a			;912f
	jr z,$+8		;9130
	ld bc,01816h		;9132
	jp 08761h		;9135
	dec l			;9138
	ld a,h			;9139
	sub 009h		;913a
	ld h,a			;913c
	ld bc,00e28h		;913d
	call 08761h		;9140
	ret nc			;9143
	ld a,(0e3d3h)		;9144
	add a,00eh		;9147
	ld l,a			;9149
	ld a,(0e3d5h)		;914a
	sub 004h		;914d
	ld h,a			;914f
	ld bc,0100fh		;9150
	jp 08761h		;9153
	ld a,(0e3b0h)		;9156
	cp 004h			;9159
	ld de,091e9h		;915b
	jr c,$+34		;915e
	ld hl,0e3e0h		;9160
	inc (hl)		;9163
	ld a,(hl)		;9164
	and 03fh		;9165
	jr nz,$+9		;9167
	ld (hl),a		;9169
	inc hl			;916a
	ld a,001h		;916b
	xor (hl)		;916d
	ld (hl),a		;916e
	dec hl			;916f
	inc hl			;9170
	ld a,(hl)		;9171
	and a			;9172
	jr nz,$+13		;9173
	dec hl			;9175
	bit 2,(hl)		;9176
	ld de,091b9h		;9178
	jr z,$+5		;917b
	ld de,091d1h		;917d
	ex de,hl		;9180
	ld b,006h		;9181
	call 089adh		;9183
	ld hl,0e338h		;9186
	ld a,(0e3d3h)		;9189
	add a,034h		;918c
	ld (hl),a		;918e
	ld a,(0e3b0h)		;918f
	cp 004h			;9192
	jr c,$+4		;9194
	ld (hl),054h		;9196
	inc hl			;9198
	ld a,(0e3d5h)		;9199
	ld (hl),a		;919c
	inc hl			;919d
	ld (hl),0c8h		;919e
	inc hl			;91a0
	ld (hl),001h		;91a1
	ld a,(0e3d1h)		;91a3
	ld c,00fh		;91a6
	cp 00ah			;91a8
	jr c,$+10		;91aa
	ld c,00ah		;91ac
	cp 014h			;91ae
	jr c,$+4		;91b0
	ld c,005h		;91b2
	ld a,c			;91b4
	ld (0e333h),a		;91b5
	ret			;91b8
	nop			;91b9
	nop			;91ba
	sub b			;91bb
	ld bc,0f300h		;91bc
	sub h			;91bf
	ld bc,00d00h		;91c0
	xor b			;91c3
	ld bc,0f810h		;91c4
	sbc a,b			;91c7
	ld bc,00109h		;91c8
	adc a,h			;91cb
	rrca			;91cc
	djnz $+10		;91cd
	xor h			;91cf
	ld bc,00000h		;91d0
	sub b			;91d3
	ld bc,0f300h		;91d4
	sbc a,h			;91d7
	ld bc,00d00h		;91d8
	or b			;91db
	ld bc,0f810h		;91dc
	sbc a,b			;91df
	ld bc,00109h		;91e0
	adc a,h			;91e3
	rrca			;91e4
	djnz $+10		;91e5
	xor h			;91e7
	ld bc,0f803h		;91e8
	and b			;91eb
	ld bc,00803h		;91ec
	or h			;91ef
	ld bc,0f813h		;91f0
	and h			;91f3
	ld bc,00813h		;91f4
	cp b			;91f7
	ld bc,00409h		;91f8
	adc a,b			;91fb
	rrca			;91fc
	inc de			;91fd
	ex af,af'		;91fe
	cp b			;91ff
	ld bc,0b03ah		;9200
	ex (sp),hl		;9203
	dec a			;9204
	ret m			;9205
	cp 004h			;9206
	jr nc,$+6		;9208
	ld hl,09317h		;920a
	push hl			;920d
	call 0406ch		;920e
	ld hl,03892h		;9211
	sub d			;9214
	ld c,h			;9215
	sub d			;9216
	ld l,(hl)		;9217
	sub d			;9218
	adc a,a			;9219
	sub d			;921a
	xor h			;921b
	sub d			;921c
	jp 0d292h		;921d
	sub d			;9220
	call 0940fh		;9221
	ld de,0aea6h		;9224
	call 0440ch		;9227
	ld hl,01f80h		;922a
	ld de,0abdch		;922d
	call 04412h		;9230
	ld hl,0e3b0h		;9233
	inc (hl)		;9236
	ret			;9237
	ld a,(0e090h)		;9238
	and 03fh		;923b
	dec a			;923d
	ret nz			;923e
	ld hl,0e3d3h		;923f
	ld a,(hl)		;9242
	add a,008h		;9243
	ld (hl),a		;9245
	ret m			;9246
	cp 020h			;9247
	ret c			;9249
	jr $-23			;924a
	ld hl,00208h		;924c
	ld de,00280h		;924f
	ld bc,01c20h		;9252
	ld (0e3b3h),hl		;9255
	ld (0e3d8h),de		;9258
	ld (0e3b1h),bc		;925c
	ld hl,00100h		;9260
	ld (0e3d6h),hl		;9263
	ld hl,07820h		;9266
	ld (0e3b7h),hl		;9269
	jr $-57			;926c
	call 08a8bh		;926e
	jp z,08902h		;9271
	call 089cdh		;9274
	call 09304h		;9277
	call 08929h		;927a
	jp nz,08902h		;927d
	ld a,(0e003h)		;9280
	and 01fh		;9283
	ret nz			;9285
	ld b,00bh		;9286
	ld ix,0e3d0h		;9288
	jp 0857fh		;928c
	call 09401h		;928f
	ld hl,0e3b1h		;9292
	dec (hl)		;9295
	ret nz			;9296
	ld (hl),030h		;9297
	ld b,0e0h		;9299
	call 044cdh		;929b
	ld a,06bh		;929e
	call 04901h		;92a0
	ld bc,0005fh		;92a3
	call 092f9h		;92a6
	jp 09233h		;92a9
	ld a,(0e003h)		;92ac
	and 008h		;92af
	push af			;92b1
	call z,08931h		;92b2
	pop af			;92b5
	call nz,08979h		;92b6
	ld hl,0e3b1h		;92b9
	dec (hl)		;92bc
	ret nz			;92bd
	ld (hl),030h		;92be
	jp 09233h		;92c0
	ld a,(0e003h)		;92c3
	and 008h		;92c6
	push af			;92c8
	call nz,08979h		;92c9
	pop af			;92cc
	call z,08989h		;92cd
	jr $-23			;92d0
	ld a,(0e003h)		;92d2
	and 008h		;92d5
	push af			;92d7
	call z,08989h		;92d8
	pop af			;92db
	call nz,092f6h		;92dc
	ld hl,0e3b1h		;92df
	dec (hl)		;92e2
	ret nz			;92e3
	ld hl,0e3b0h		;92e4
	ld de,0e3b1h		;92e7
	ld bc,0003fh		;92ea
	ld (hl),000h		;92ed
	ldir			;92ef
	ld hl,0e660h		;92f1
	ld (hl),001h		;92f4
	ld bc,00027h		;92f6
	ld hl,0e320h		;92f9
	ld de,0e321h		;92fc
	ld (hl),0e0h		;92ff
	ldir			;9301
	ret			;9303
	ld a,(0e003h)		;9304
	rra			;9307
	call c,08a5ch		;9308
	call 0938bh		;930b
	call 0935ch		;930e
	call 093deh		;9311
	jp 08a2ah		;9314
	ld hl,09338h		;9317
	ld b,009h		;931a
	call 089adh		;931c
	call 09049h		;931f
	ld a,(0e3d1h)		;9322
	ld c,006h		;9325
	cp 00fh			;9327
	jr c,$+10		;9329
	ld c,005h		;932b
	cp 01eh			;932d
	jr c,$+4		;932f
	ld c,00eh		;9331
	ld a,c			;9333
	ld (0e323h),a		;9334
	ret			;9337
	call m,06000h		;9338
	ex af,af'		;933b
	call m,064f6h		;933c
	rrca			;933f
	call m,06806h		;9340
	rrca			;9343
	inc c			;9344
	rst 28h			;9345
	ld l,h			;9346
	rrca			;9347
	inc c			;9348
	rst 38h			;9349
	ld (hl),b		;934a
	rrca			;934b
	inc c			;934c
	rrca			;934d
	ld (hl),h		;934e
	rrca			;934f
	inc e			;9350
	pop af			;9351
	ld a,b			;9352
	rrca			;9353
	inc e			;9354
	ld bc,00f7ch		;9355
	inc e			;9358
	ld de,00f80h		;9359
	ld ix,0e200h		;935c
	ld de,00010h		;9360
	ld b,00bh		;9363
	ld a,(ix+000h)		;9365
	cp 002h			;9368
	jr nz,$+28		;936a
	bit 2,(ix+00ch)		;936c
	ld c,088h		;9370
	jr z,$+4		;9372
	ld c,08ch		;9374
	ld (ix+00ah),c		;9376
	dec (ix+00ch)		;9379
	jr nz,$+10		;937c
	ld (ix+000h),000h	;937e
	ld (ix+003h),0e0h	;9382
	add ix,de		;9386
	djnz $-35		;9388
	ret			;938a
	ld a,(0e602h)		;938b
	ld l,a			;938e
	ld a,(0e604h)		;938f
	ld h,a			;9392
	ld ix,0e200h		;9393
	ld b,00ah		;9397
	ld a,(ix+000h)		;9399
	dec a			;939c
	jr nz,$+38		;939d
	ld a,(ix+00ch)		;939f
	and a			;93a2
	jr nz,$+40		;93a3
	ld a,(ix+003h)		;93a5
	sub l			;93a8
	add a,028h		;93a9
	jp m,093c3h		;93ab
	ld a,r			;93ae
	and 00fh		;93b0
	add a,008h		;93b2
	ld c,a			;93b4
	ld a,(ix+005h)		;93b5
	sub h			;93b8
	jr nc,$+4		;93b9
	neg			;93bb
	sra a			;93bd
	add a,c			;93bf
	ld (ix+00ch),a		;93c0
	ld de,00010h		;93c3
	add ix,de		;93c6
	djnz $-47		;93c8
	ret			;93ca
	dec (ix+00ch)		;93cb
	jr nz,$-11		;93ce
	ld (ix+000h),002h	;93d0
	ld (ix+001h),00fh	;93d4
	ld (ix+00ch),018h	;93d8
	jr $-25			;93dc
	ld a,(0e600h)		;93de
	cp 002h			;93e1
	ret z			;93e3
	ld ix,0e200h		;93e4
	ld b,008h		;93e8
	exx			;93ea
	ld a,(ix+000h)		;93eb
	and a			;93ee
	jr z,$+9		;93ef
	cp 003h			;93f1
	jr nc,$+5		;93f3
	call 08319h		;93f5
	exx			;93f8
	ld de,00010h		;93f9
	add ix,de		;93fc
	djnz $-20		;93fe
	ret			;9400
	ld a,(0e003h)		;9401
	ld b,0e0h		;9404
	and 002h		;9406
	jr z,$+4		;9408
	ld b,0eeh		;940a
	jp 044cdh		;940c
	call 0964eh		;940f
	ld a,0d8h		;9412
	ld (0e3d3h),a		;9414
	ld a,078h		;9417
	ld (0e3d5h),a		;9419
	ret			;941c
	ld a,(0e3b0h)		;941d
	dec a			;9420
	call 0406ch		;9421
	ld (04b94h),a		;9424
	sub h			;9427
	ld d,h			;9428
	sub h			;9429
	adc a,a			;942a
	sub d			;942b
	xor h			;942c
	sub d			;942d
	jp 0d292h		;942e
	sub d			;9431
	call 0964eh		;9432
	ld de,0ab9dh		;9435
	ld hl,01e00h		;9438
	call 04412h		;943b
	ld hl,01e00h		;943e
	ld de,01e90h		;9441
	ld c,004h		;9444
	call 04478h		;9446
	jr $+8			;9449
	ld a,(0e091h)		;944b
	cp 0d8h			;944e
	ret nz			;9450
	jp 09233h		;9451
	ld a,(0e090h)		;9454
	rra			;9457
	jr c,$+92		;9458
	call 0772ah		;945a
	ld ix,0e3d0h		;945d
	ld a,(0e090h)		;9461
	cp 00eh			;9464
	jr nz,$+9		;9466
	ld a,(0e3d0h)		;9468
	or a			;946b
	call z,094deh		;946c
	call 0957ah		;946f
	ld de,0e348h		;9472
	call 094f1h		;9475
	ld ix,0e100h		;9478
	ld b,005h		;947c
	ld hl,094ebh		;947e
	ld a,b			;9481
	call 0405bh		;9482
	ld c,(hl)		;9485
	inc (ix+018h)		;9486
	ld a,(ix+018h)		;9489
	cp c			;948c
	jr nz,$+19		;948d
	ld a,(ix+000h)		;948f
	or a			;9492
	jr nz,$+13		;9493
	call 094deh		;9495
	ld (ix+001h),009h	;9498
	ld (ix+016h),0c0h	;949c
	push bc			;94a0
	call 09541h		;94a1
	pop bc			;94a4
	push bc			;94a5
	call 0749ah		;94a6
	call 07452h		;94a9
	ld bc,00020h		;94ac
	add ix,bc		;94af
	pop bc			;94b1
	djnz $-52		;94b2
	call 08929h		;94b4
	jr nz,$+17		;94b7
	ld a,(0e090h)		;94b9
	and 01fh		;94bc
	ret nz			;94be
	ld b,001h		;94bf
	ld ix,0e3d0h		;94c1
	jp 0857fh		;94c5
	ld a,004h		;94c8
	call 08904h		;94ca
	ld a,(0e3d3h)		;94cd
	sub 010h		;94d0
	ld (0e3d3h),a		;94d2
	ld a,(0e3d5h)		;94d5
	sub 010h		;94d8
	ld (0e3d5h),a		;94da
	ret			;94dd
	ld (ix+000h),001h	;94de
	ld (ix+003h),020h	;94e2
	ld (ix+005h),07eh	;94e6
	ret			;94ea
	nop			;94eb
	inc sp			;94ec
	ld h,(hl)		;94ed
	sbc a,c			;94ee
	call z,0ddffh		;94ef
	ld a,(hl)		;94f2
	ld a,(bc)		;94f3
	cp 018h			;94f4
	ld hl,07876h		;94f6
	jr z,$+5		;94f9
	ld hl,0787eh		;94fb
	ld b,002h		;94fe
	ld a,(ix+000h)		;9500
	or a			;9503
	ld a,(ix+003h)		;9504
	jr nz,$+4		;9507
	ld a,0cah		;9509
	add a,(hl)		;950b
	ld (de),a		;950c
	inc hl			;950d
	inc de			;950e
	ld a,(ix+005h)		;950f
	add a,(hl)		;9512
	ld (de),a		;9513
	inc hl			;9514
	inc de			;9515
	ld a,(hl)		;9516
	add a,0c0h		;9517
	ld (de),a		;9519
	inc hl			;951a
	inc de			;951b
	ld c,(hl)		;951c
	ld a,c			;951d
	cp 005h			;951e
	jr nz,$+26		;9520
	ld c,00fh		;9522
	ld a,(0e003h)		;9524
	bit 2,a			;9527
	jr nz,$+17		;9529
	ld a,(ix+001h)		;952b
	cp 014h			;952e
	jr c,$+10		;9530
	ld c,004h		;9532
	cp 028h			;9534
	jr c,$+4		;9536
	ld c,006h		;9538
	ld a,c			;953a
	ld (de),a		;953b
	inc hl			;953c
	inc de			;953d
	djnz $-62		;953e
	ret			;9540
	ld a,(ix+000h)		;9541
	dec a			;9544
	ret m			;9545
	call 0406ch		;9546
	cp c			;9549
	ld a,(hl)		;954a
	ld d,a			;954b
	sub l			;954c
	dec d			;954d
	ld a,a			;954e
	ld (hl),h		;954f
	ld a,h			;9550
	adc a,d			;9551
	ld a,h			;9552
	and b			;9553
	ld a,h			;9554
	rst 28h			;9555
	ld a,h			;9556
	call 07f15h		;9557
	ld a,(ix+003h)		;955a
	cp 038h			;955d
	ret c			;955f
	call 084e0h		;9560
	call 083e1h		;9563
	ld h,b			;9566
	ld l,c			;9567
	add hl,hl		;9568
	ld (ix+006h),l		;9569
	ld (ix+007h),h		;956c
	ld h,d			;956f
	ld l,e			;9570
	add hl,hl		;9571
	ld (ix+008h),l		;9572
	ld (ix+009h),h		;9575
	jr $+28			;9578
	ld a,(ix+000h)		;957a
	dec a			;957d
	ret m			;957e
	call 0406ch		;957f
	cp h			;9582
	ld a,(hl)		;9583
	adc a,b			;9584
	sub l			;9585
	sbc a,b			;9586
	sub l			;9587
	call 07f18h		;9588
	ld a,(0e3d3h)		;958b
	cp 038h			;958e
	ret c			;9590
	call 0959fh		;9591
	inc (ix+000h)		;9594
	ret			;9597
	call 07f18h		;9598
	dec (ix+00eh)		;959b
	ret nz			;959e
	call 084e0h		;959f
	call 083e1h		;95a2
	ld a,(0e3d1h)		;95a5
	cp 014h			;95a8
	jr c,$+45		;95aa
	cp 028h			;95ac
	jr c,$+12		;95ae
	ld h,b			;95b0
	ld l,c			;95b1
	add hl,hl		;95b2
	ld b,h			;95b3
	ld c,l			;95b4
	ex de,hl		;95b5
	add hl,hl		;95b6
	ex de,hl		;95b7
	jr $+31			;95b8
	ld h,b			;95ba
	ld l,c			;95bb
	srl b			;95bc
	rr c			;95be
	bit 6,b			;95c0
	jr z,$+4		;95c2
	set 7,b			;95c4
	add hl,bc		;95c6
	ld b,h			;95c7
	ld c,l			;95c8
	ld h,d			;95c9
	ld l,e			;95ca
	srl d			;95cb
	rr e			;95cd
	bit 6,d			;95cf
	jr z,$+4		;95d1
	set 7,d			;95d3
	add hl,de		;95d5
	ex de,hl		;95d6
	ld (0e3d6h),bc		;95d7
	ld (0e3d8h),de		;95db
	ld (ix+00eh),030h	;95df
	ret			;95e3
	call 0985ch		;95e4
	ld a,(0e3b0h)		;95e7
	dec a			;95ea
	ret m			;95eb
	cp 005h			;95ec
	jr nc,$+6		;95ee
	ld hl,096cch		;95f0
	push hl			;95f3
	call 0406ch		;95f4
	add hl,bc		;95f7
	sub (hl)		;95f8
	jr c,$-108		;95f9
	ld h,d			;95fb
	sub (hl)		;95fc
	add a,a			;95fd
	sub (hl)		;95fe
	pop bc			;95ff
	sub (hl)		;9600
	adc a,a			;9601
	sub d			;9602
	xor h			;9603
	sub d			;9604
	jp 0d292h		;9605
	sub d			;9608
	call 0964eh		;9609
	ld a,0d8h		;960c
	ld (0e3d3h),a		;960e
	ld a,068h		;9611
	ld (0e3d5h),a		;9613
	ld a,003h		;9616
	ld (0e3e0h),a		;9618
	ld ix,0e400h		;961b
	ld hl,0965ch		;961f
	ld de,00010h		;9622
	ld b,006h		;9625
	ld (ix+000h),001h	;9627
	ld a,(hl)		;962b
	inc hl			;962c
	ld (ix+004h),a		;962d
	ld (ix+003h),00fh	;9630
	ld (ix+008h),014h	;9634
	add ix,de		;9638
	djnz $-19		;963a
	xor a			;963c
	ld (0e400h),a		;963d
	ld a,040h		;9640
	ld (0e408h),a		;9642
	ld de,0b124h		;9645
	call 0440ch		;9648
	jp 08ae6h		;964b
	ld hl,0e3d0h		;964e
	ld de,0e3d1h		;9651
	ld bc,000dfh		;9654
	ld (hl),000h		;9657
	ldir			;9659
	ret			;965b
	add a,b			;965c
	jr nc,$+114		;965d
	and b			;965f
	add a,b			;9660
	ret po			;9661
	call 08d87h		;9662
	ld hl,0e604h		;9665
	ld a,(hl)		;9668
	and 0f8h		;9669
	ld (0e3dah),a		;966b
	ld b,a			;966e
	ld a,(0e3d5h)		;966f
	and 0f8h		;9672
	add a,010h		;9674
	cp b			;9676
	ld hl,00000h		;9677
	jr z,$+7		;967a
	inc h			;967c
	jr c,$+4		;967d
	ld h,0ffh		;967f
	ld (0e3d8h),hl		;9681
	jp 09233h		;9684
	ld a,(0e003h)		;9687
	bit 2,a			;968a
	ld a,001h		;968c
	jr z,$+3		;968e
	dec a			;9690
	ld (0e3e1h),a		;9691
	ld hl,(0e3d4h)		;9694
	ld a,h			;9697
	and 0f8h		;9698
	add a,010h		;969a
	ld c,a			;969c
	ld a,(0e3dah)		;969d
	cp c			;96a0
	jr z,$+25		;96a1
	ld de,(0e3d8h)		;96a3
	add hl,de		;96a7
	ld (0e3d4h),hl		;96a8
	ld a,h			;96ab
	cp 020h			;96ac
	ld h,020h		;96ae
	jr c,$+7		;96b0
	cp 0b0h			;96b2
	ld h,0b0h		;96b4
	ret c			;96b6
	ld (0e3d4h),hl		;96b7
	ld a,050h		;96ba
	ld (0e3dbh),a		;96bc
	jr $-59			;96bf
	ld hl,0e3dbh		;96c1
	dec (hl)		;96c4
	ret nz			;96c5
	ld a,003h		;96c6
	ld (0e3b0h),a		;96c8
	ret			;96cb
	ld a,(0e3b0h)		;96cc
	cp 003h			;96cf
	jr c,$+20		;96d1
	ld ix,0e400h		;96d3
	ld b,006h		;96d7
	ld de,00010h		;96d9
	exx			;96dc
	call 096e8h		;96dd
	exx			;96e0
	add ix,de		;96e1
	djnz $-7		;96e3
	jp 0987eh		;96e5
	ld a,(ix+000h)		;96e8
	dec a			;96eb
	ret m			;96ec
	call 0406ch		;96ed
	ret m			;96f0
	sub (hl)		;96f1
	xor e			;96f2
	sub a			;96f3
	sub 097h		;96f4
	ret p			;96f6
	sub a			;96f7
	ld a,(ix+002h)		;96f8
	and 0fbh		;96fb
	cp 002h			;96fd
	jr nz,$+67		;96ff
	ld iy,0e620h		;9701
	ld b,003h		;9705
	push bc			;9707
	ld a,(iy+000h)		;9708
	rla			;970b
	jr c,$+46		;970c
	push iy			;970e
	pop hl			;9710
	call 08797h		;9711
	jr c,$+38		;9714
	ld a,00bh		;9716
	call 04901h		;9718
	set 7,(iy+000h)		;971b
	ld a,(iy+005h)		;971f
	srl a			;9722
	ld hl,097a5h		;9724
	call 0405bh		;9727
	ld a,(ix+001h)		;972a
	add a,(hl)		;972d
	ld (ix+001h),a		;972e
	cp (ix+008h)		;9731
	jr c,$+6		;9734
	pop bc			;9736
	jp 097ech		;9737
	pop bc			;973a
	ld de,00010h		;973b
	add iy,de		;973e
	djnz $-57		;9740
	call 09817h		;9742
	ld a,(ix+001h)		;9745
	ld b,00fh		;9748
	cp 006h			;974a
	jr c,$+20		;974c
	ld b,007h		;974e
	cp 00bh			;9750
	jr c,$+14		;9752
	ld b,00ah		;9754
	cp 010h			;9756
	jr c,$+8		;9758
	dec b			;975a
	cp 015h			;975b
	jr c,$+3		;975d
	dec b			;975f
	ld (ix+003h),b		;9760
	ld a,(ix+004h)		;9763
	sub 008h		;9766
	ld c,a			;9768
	ld a,(ix+005h)		;9769
	and a			;976c
	jr z,$+41		;976d
	cp c			;976f
	jr nz,$+20		;9770
	ld a,(ix+002h)		;9772
	and 002h		;9775
	xor 002h		;9777
	ld (ix+002h),a		;9779
	bit 1,a			;977c
	jr nz,$+6		;977e
	ld (ix+005h),020h	;9780
	dec (ix+005h)		;9784
	ld a,(ix+005h)		;9787
	and 00fh		;978a
	ret nz			;978c
	ld a,(ix+002h)		;978d
	xor 004h		;9790
	ld (ix+002h),a		;9792
	ret			;9795
	ld a,(ix+004h)		;9796
	ld (ix+005h),a		;9799
	ld a,(ix+002h)		;979c
	xor 001h		;979f
	ld (ix+002h),a		;97a1
	ret			;97a4
	ld bc,00101h		;97a5
	ld (bc),a		;97a8
	ld (bc),a		;97a9
	ld (bc),a		;97aa
	ld hl,0e3f0h		;97ab
	inc (hl)		;97ae
	ld a,(hl)		;97af
	cp 006h			;97b0
	jr nz,$+23		;97b2
	exx			;97b4
	push bc			;97b5
	push de			;97b6
	push hl			;97b7
	ld hl,0e3d5h		;97b8
	ld a,(hl)		;97bb
	add a,018h		;97bc
	ld (hl),a		;97be
	ld a,006h		;97bf
	call 08904h		;97c1
	pop hl			;97c4
	pop de			;97c5
	pop bc			;97c6
	exx			;97c7
	ret			;97c8
	ld a,04dh		;97c9
	call 04901h		;97cb
	ld (ix+003h),009h	;97ce
	ld a,020h		;97d2
	jr $+21			;97d4
	ld a,(ix+005h)		;97d6
	bit 1,a			;97d9
	ld a,008h		;97db
	jr z,$+3		;97dd
	inc a			;97df
	ld (ix+002h),a		;97e0
	dec (ix+005h)		;97e3
	ret nz			;97e6
	ld a,020h		;97e7
	ld (ix+005h),a		;97e9
	inc (ix+000h)		;97ec
	ret			;97ef
	bit 1,(ix+005h)		;97f0
	ld a,009h		;97f4
	jr z,$+3		;97f6
	inc a			;97f8
	ld (ix+002h),a		;97f9
	dec (ix+005h)		;97fc
	ret nz			;97ff
	ld (ix+002h),00bh	;9800
	ld (ix+003h),006h	;9804
	ld (ix+000h),000h	;9808
	ld a,(0e3f0h)		;980c
	sub 005h		;980f
	ret nz			;9811
	inc a			;9812
	ld (0e400h),a		;9813
	ret			;9816
	ld a,(ix+002h)		;9817
	and 0fbh		;981a
	cp 002h			;981c
	ret nz			;981e
	ld a,(0e3f0h)		;981f
	ld c,03fh		;9822
	cp 002h			;9824
	jr c,$+10		;9826
	ld c,01fh		;9828
	cp 004h			;982a
	jr c,$+4		;982c
	ld c,00fh		;982e
	ld a,(ix+005h)		;9830
	and c			;9833
	ret nz			;9834
	ld hl,0e463h		;9835
	ld a,(ix+006h)		;9838
	add a,009h		;983b
	ld (hl),a		;983d
	inc hl			;983e
	inc hl			;983f
	ld a,(ix+007h)		;9840
	add a,006h		;9843
	ld (hl),a		;9845
	push ix			;9846
	exx			;9848
	push bc			;9849
	push de			;984a
	push hl			;984b
	ld ix,0e460h		;984c
	ld b,00eh		;9850
	call 0857fh		;9852
	pop hl			;9855
	pop de			;9856
	pop bc			;9857
	exx			;9858
	pop ix			;9859
	ret			;985b
	ld a,(0e3b0h)		;985c
	cp 003h			;985f
	ret c			;9861
	ld a,(0e3b0h)		;9862
	cp 006h			;9865
	push af			;9867
	call nz,08db7h		;9868
	pop af			;986b
	ret nc			;986c
	ld de,0e3d3h		;986d
	ld a,(de)		;9870
	ld l,a			;9871
	inc de			;9872
	inc de			;9873
	ld a,(de)		;9874
	and 0f8h		;9875
	ld h,a			;9877
	call 08dd1h		;9878
	jp 08c34h		;987b
	ld a,(0e3b0h)		;987e
	cp 006h			;9881
	ret nc			;9883
	ld de,0e320h		;9884
	ld hl,098c3h		;9887
	ld ix,0e400h		;988a
	ld b,006h		;988e
	ld a,(0e3d3h)		;9890
	add a,(hl)		;9893
	ld (de),a		;9894
	ld (ix+006h),a		;9895
	inc de			;9898
	inc hl			;9899
	ld a,(0e3d5h)		;989a
	and 0f8h		;989d
	add a,(hl)		;989f
	ld (de),a		;98a0
	ld (ix+007h),a		;98a1
	inc de			;98a4
	inc hl			;98a5
	push hl			;98a6
	ld hl,098cfh		;98a7
	ld a,(ix+002h)		;98aa
	call 0405bh		;98ad
	ld a,(hl)		;98b0
	ld (de),a		;98b1
	inc de			;98b2
	ld a,(ix+003h)		;98b3
	ld (de),a		;98b6
	ex de,hl		;98b7
	ld de,00010h		;98b8
	add ix,de		;98bb
	ex de,hl		;98bd
	pop hl			;98be
	inc de			;98bf
	djnz $-48		;98c0
	ret			;98c2
	call m,00210h		;98c3
	inc bc			;98c6
	ld (bc),a		;98c7
	dec e			;98c8
	inc c			;98c9
	djnz $+20		;98ca
	inc bc			;98cc
	ld (de),a		;98cd
	dec e			;98ce
	sub b			;98cf
	adc a,h			;98d0
	add a,h			;98d1
	adc a,h			;98d2
	sub b			;98d3
	adc a,h			;98d4
	adc a,b			;98d5
	adc a,h			;98d6
	ld c,b			;98d7
	ld d,b			;98d8
	ld d,h			;98d9
	sub h			;98da
	ld a,(0e065h)		;98db
	add a,a			;98de
	add a,a			;98df
	ld hl,09999h		;98e0
	call 0405bh		;98e3
	ld de,0e3bbh		;98e6
	ld bc,00004h		;98e9
	ldir			;98ec
	ld ix,0e620h		;98ee
	ld b,003h		;98f2
	bit 7,(ix+000h)		;98f4
	jr nz,$+55		;98f8
	ld a,(ix+005h)		;98fa
	ld hl,099b5h		;98fd
	add a,a			;9900
	call 0405bh		;9901
	ld a,(0e3bbh)		;9904
	add a,(hl)		;9907
	ld e,a			;9908
	ld a,(0e3bch)		;9909
	add a,e			;990c
	ld d,a			;990d
	ld a,(0e3d5h)		;990e
	sub (ix+004h)		;9911
	neg			;9914
	add a,e			;9916
	cp d			;9917
	jr nc,$+23		;9918
	ld a,(0e3bdh)		;991a
	ld e,a			;991d
	ld a,(0e3beh)		;991e
	ld d,a			;9921
	ld a,(0e3d3h)		;9922
	sub (ix+002h)		;9925
	neg			;9928
	add a,e			;992a
	cp d			;992b
	call c,09937h		;992c
	ld de,00010h		;992f
	add ix,de		;9932
	djnz $-64		;9934
	ret			;9936
	ld (ix+002h),0e0h	;9937
	set 7,(ix+000h)		;993b
	ld a,(0e3bfh)		;993f
	and a			;9942
	ret nz			;9943
	call 0997bh		;9944
	ld a,00ch		;9947
	jp z,04901h		;9949
	call 09986h		;994c
	ld a,00ch		;994f
	jp z,04901h		;9951
	ld a,00bh		;9954
	call 04901h		;9956
	inc hl			;9959
	ld e,(hl)		;995a
	ld a,(0e065h)		;995b
	ld hl,09992h		;995e
	call 0405bh		;9961
	ld c,(hl)		;9964
	ld hl,0e3d1h		;9965
	ld a,(hl)		;9968
	add a,e			;9969
	ld (hl),a		;996a
	cp c			;996b
	ret c			;996c
	ld a,001h		;996d
	ld (0e3bfh),a		;996f
	pop bc			;9972
	ld de,00000h		;9973
	ld c,001h		;9976
	jp 042afh		;9978
	ld a,(0e065h)		;997b
	cp 002h			;997e
	ret nz			;9980
	ld a,(0e3e1h)		;9981
	dec a			;9984
	ret			;9985
	ld a,(0e065h)		;9986
	cp 004h			;9989
	ret nz			;998b
	ld a,(0e3e2h)		;998c
	bit 0,a			;998f
	ret			;9991
	inc d			;9992
	ld e,01eh		;9993
	dec l			;9995
	dec l			;9996
	dec l			;9997
	inc a			;9998
	jp p,0f81ah		;9999
	djnz $+2		;999c
	djnz $+2		;999e
	djnz $+0		;99a0
	ld c,0fbh		;99a2
	ld de,00b01h		;99a4
	ld sp,hl		;99a7
	dec b			;99a8
	call p,0f21ch		;99a9
	inc c			;99ac
	push af			;99ad
	dec e			;99ae
	ret m			;99af
	ld (de),a		;99b0
	ld b,006h		;99b1
	ld b,00ch		;99b3
	inc b			;99b5
	ld bc,00104h		;99b6
	dec c			;99b9
	ld bc,0010dh		;99ba
	dec b			;99bd
	ld bc,0010dh		;99be
	ld a,(bc)		;99c1
	ld (bc),a		;99c2
	ld a,(bc)		;99c3
	ld (bc),a		;99c4
	dec b			;99c5
	ld (bc),a		;99c6
	dec b			;99c7
	ld (bc),a		;99c8
	dec b			;99c9
	ld (bc),a		;99ca
	dec b			;99cb
	ld (bc),a		;99cc
	dec a			;99cd
	sbc a,(hl)		;99ce
	dec h			;99cf
	sbc a,a			;99d0
	dec l			;99d1
	sbc a,a			;99d2
	ld d,a			;99d3
	and b			;99d4
	ld e,(hl)		;99d5
	and b			;99d6
	dec (hl)		;99d7
	and c			;99d8
	inc a			;99d9
	and c			;99da
	rst 38h			;99db
	and c			;99dc
	ld b,0a2h		;99dd
	jp po,0e9a2h		;99df
	and d			;99e2
	call z,0d3a3h		;99e3
	and e			;99e6
	jp 0caa4h		;99e7
	and h			;99ea
	xor l			;99eb
	and l			;99ec
	ld a,h			;99ed
	sbc a,d			;99ee
	adc a,h			;99ef
	sbc a,d			;99f0
	sbc a,h			;99f1
	sbc a,d			;99f2
	xor h			;99f3
	sbc a,d			;99f4
	ld l,l			;99f5
	sbc a,d			;99f6
	cp h			;99f7
	sbc a,d			;99f8
	call z,0dc9ah		;99f9
	sbc a,d			;99fc
	call pe,0fc9ah		;99fd
	sbc a,d			;9a00
	inc c			;9a01
	sbc a,e			;9a02
	inc e			;9a03
	sbc a,e			;9a04
	inc l			;9a05
	sbc a,e			;9a06
	inc a			;9a07
	sbc a,e			;9a08
	ld c,h			;9a09
	sbc a,e			;9a0a
	ld l,d			;9a0b
	sbc a,e			;9a0c
	ld a,d			;9a0d
	sbc a,e			;9a0e
	adc a,d			;9a0f
	sbc a,e			;9a10
	sbc a,d			;9a11
	sbc a,e			;9a12
	xor d			;9a13
	sbc a,e			;9a14
	cp d			;9a15
	sbc a,e			;9a16
	jp z,0da9bh		;9a17
	sbc a,e			;9a1a
	jp pe,0fa9bh		;9a1b
	sbc a,e			;9a1e
	ld a,(bc)		;9a1f
	sbc a,h			;9a20
	ld hl,03e9ch		;9a21
	sbc a,h			;9a24
	ld c,(hl)		;9a25
	sbc a,h			;9a26
	ld e,(hl)		;9a27
	sbc a,h			;9a28
	ld l,09ch		;9a29
	ld e,d			;9a2b
	sbc a,e			;9a2c
	ld l,(hl)		;9a2d
	sbc a,h			;9a2e
	adc a,h			;9a2f
	sbc a,h			;9a30
	sbc a,h			;9a31
	sbc a,h			;9a32
	xor h			;9a33
	sbc a,h			;9a34
	cp h			;9a35
	sbc a,h			;9a36
	call z,07c9ch		;9a37
	sbc a,h			;9a3a
	call c,0f49ch		;9a3b
	sbc a,h			;9a3e
	ret m			;9a3f
	sbc a,h			;9a40
	call pe,0089ch		;9a41
	sbc a,l			;9a44
	jr $-97			;9a45
	jr nc,$-97		;9a47
	jr nz,$-97		;9a49
	ld b,b			;9a4b
	sbc a,l			;9a4c
	ld d,b			;9a4d
	sbc a,l			;9a4e
	ld h,b			;9a4f
	sbc a,l			;9a50
	ld (hl),b		;9a51
	sbc a,l			;9a52
	add a,b			;9a53
	sbc a,l			;9a54
	sub b			;9a55
	sbc a,l			;9a56
	and b			;9a57
	sbc a,l			;9a58
	or b			;9a59
	sbc a,l			;9a5a
	ret nz			;9a5b
	sbc a,l			;9a5c
	ld a,(de)		;9a5d
	sbc a,h			;9a5e
	defb 0ddh,09dh ;sbc a,ixl	;9a5f
	defb 0edh ;next byte illegal after ed	;9a61
	sbc a,l			;9a62
	defb 0fdh,09dh ;sbc a,iyl	;9a63
	dec c			;9a65
	sbc a,(hl)		;9a66
	dec e			;9a67
	sbc a,(hl)		;9a68
	dec l			;9a69
	sbc a,(hl)		;9a6a
	call 0859dh		;9a6b
	sbc a,l			;9a6e
	add a,b			;9a6f
	add a,b			;9a70
	sub (hl)		;9a71
	adc a,b			;9a72
	add a,b			;9a73
	add a,b			;9a74
	adc a,e			;9a75
	sbc a,d			;9a76
	jp (hl)			;9a77
	add a,b			;9a78
	adc a,a			;9a79
	sub h			;9a7a
	sub c			;9a7b
	add a,b			;9a7c
	add a,b			;9a7d
	add a,c			;9a7e
	add a,b			;9a7f
	add a,d			;9a80
	add a,b			;9a81
	add a,e			;9a82
	add a,b			;9a83
	add a,e			;9a84
	add a,c			;9a85
	add a,b			;9a86
	add a,b			;9a87
	add a,b			;9a88
	add a,e			;9a89
	add a,b			;9a8a
	add a,c			;9a8b
	ld d,b			;9a8c
	ld d,c			;9a8d
	ld d,b			;9a8e
	ld d,c			;9a8f
	ld b,e			;9a90
	ld b,h			;9a91
	ld b,e			;9a92
	ld b,h			;9a93
	ld c,e			;9a94
	ld c,e			;9a95
	ld c,e			;9a96
	ld c,e			;9a97
	add a,h			;9a98
	add a,l			;9a99
	add a,h			;9a9a
	add a,l			;9a9b
	ccf			;9a9c
	ld b,b			;9a9d
	ld b,c			;9a9e
	ld b,d			;9a9f
	ccf			;9aa0
	ld b,b			;9aa1
	ld b,c			;9aa2
	ld b,d			;9aa3
	ccf			;9aa4
	ld b,b			;9aa5
	ld b,c			;9aa6
	ld b,d			;9aa7
	ccf			;9aa8
	ld b,b			;9aa9
	ld b,c			;9aaa
	ld b,d			;9aab
	ld a,a			;9aac
	ld d,h			;9aad
	ld d,l			;9aae
	halt			;9aaf
	ld e,h			;9ab0
	ld e,l			;9ab1
	ld e,(hl)		;9ab2
	ld (hl),a		;9ab3
	ld a,a			;9ab4
	ld e,e			;9ab5
	ld e,a			;9ab6
	ld (hl),h		;9ab7
	ld a,a			;9ab8
	ld d,a			;9ab9
	ld a,a			;9aba
	ld a,b			;9abb
	ld h,a			;9abc
	ld l,b			;9abd
	ld h,a			;9abe
	ld l,b			;9abf
	ld b,e			;9ac0
	ld b,h			;9ac1
	ld b,e			;9ac2
	ld b,h			;9ac3
	ld c,e			;9ac4
	ld c,e			;9ac5
	ld c,e			;9ac6
	ld c,e			;9ac7
	adc a,(hl)		;9ac8
	adc a,a			;9ac9
	adc a,(hl)		;9aca
	adc a,a			;9acb
	ld a,a			;9acc
	ld a,a			;9acd
	ld e,b			;9ace
	ld a,c			;9acf
	ld a,a			;9ad0
	ld d,a			;9ad1
	ld a,a			;9ad2
	halt			;9ad3
	ld h,e			;9ad4
	ld h,(hl)		;9ad5
	ld h,a			;9ad6
	ld a,l			;9ad7
	ld a,a			;9ad8
	ld e,b			;9ad9
	ld l,b			;9ada
	ld a,(hl)		;9adb
	add a,(hl)		;9adc
	add a,b			;9add
	add a,(hl)		;9ade
	add a,b			;9adf
	ld d,d			;9ae0
	ld d,e			;9ae1
	ld e,c			;9ae2
	add a,(hl)		;9ae3
	ld a,a			;9ae4
	ld a,a			;9ae5
	ld a,a			;9ae6
	ld a,h			;9ae7
	ld a,a			;9ae8
	ld a,a			;9ae9
	ld e,b			;9aea
	ld a,d			;9aeb
	ld h,b			;9aec
	ld h,d			;9aed
	ld h,d			;9aee
	halt			;9aef
	ld h,c			;9af0
	ld h,c			;9af1
	ld e,d			;9af2
	ld (hl),l		;9af3
	add a,a			;9af4
	adc a,b			;9af5
	adc a,c			;9af6
	add a,b			;9af7
	add a,b			;9af8
	add a,(hl)		;9af9
	add a,b			;9afa
	add a,(hl)		;9afb
	ld b,l			;9afc
	ld b,l			;9afd
	ld b,l			;9afe
	ld b,l			;9aff
	ld b,(hl)		;9b00
	ld b,(hl)		;9b01
	ld b,(hl)		;9b02
	ld b,(hl)		;9b03
	ld (hl),c		;9b04
	ld b,a			;9b05
	ld b,a			;9b06
	ld b,a			;9b07
	add a,b			;9b08
	ld (hl),d		;9b09
	ld c,b			;9b0a
	ld c,b			;9b0b
	ld b,l			;9b0c
	ld b,l			;9b0d
	ld b,l			;9b0e
	ld b,l			;9b0f
	ld b,(hl)		;9b10
	ld b,(hl)		;9b11
	ld b,(hl)		;9b12
	ld b,(hl)		;9b13
	ld b,a			;9b14
	ld b,a			;9b15
	ld b,a			;9b16
	ld b,a			;9b17
	ld c,b			;9b18
	ld c,b			;9b19
	ld c,b			;9b1a
	ld c,b			;9b1b
	add a,(hl)		;9b1c
	adc a,(hl)		;9b1d
	adc a,a			;9b1e
	sub b			;9b1f
	adc a,b			;9b20
	sbc a,e			;9b21
	sub c			;9b22
	sub d			;9b23
	add a,a			;9b24
	sbc a,h			;9b25
	sub e			;9b26
	sub h			;9b27
	adc a,c			;9b28
	sbc a,e			;9b29
	sub c			;9b2a
	sub d			;9b2b
	ld h,b			;9b2c
	add a,b			;9b2d
	add a,b			;9b2e
	add a,b			;9b2f
	ld e,h			;9b30
	ld d,l			;9b31
	ld e,c			;9b32
	ld d,(hl)		;9b33
	ld e,h			;9b34
	ld e,a			;9b35
	ld e,d			;9b36
	ld d,c			;9b37
	ld e,h			;9b38
	ld l,l			;9b39
	ld e,(hl)		;9b3a
	ld d,c			;9b3b
	ld e,h			;9b3c
	ld d,d			;9b3d
	ld d,e			;9b3e
	ld d,c			;9b3f
	ld e,h			;9b40
	ld bc,05154h		;9b41
	ld e,h			;9b44
	ld e,l			;9b45
	ld d,b			;9b46
	ld d,c			;9b47
	ld e,h			;9b48
	ld l,l			;9b49
	ld e,(hl)		;9b4a
	ld d,c			;9b4b
	ld e,h			;9b4c
	ld d,d			;9b4d
	ld d,e			;9b4e
	ld d,c			;9b4f
	ld h,c			;9b50
	ld h,(hl)		;9b51
	ld d,h			;9b52
	ld d,c			;9b53
	ld h,(hl)		;9b54
	ld h,(hl)		;9b55
	ld e,e			;9b56
	ld e,b			;9b57
	add a,h			;9b58
	add a,l			;9b59
	add a,b			;9b5a
	add a,b			;9b5b
	add a,c			;9b5c
	add a,b			;9b5d
	add a,d			;9b5e
	add a,b			;9b5f
	ld a,b			;9b60
	ld a,c			;9b61
	add a,e			;9b62
	add a,c			;9b63
	ld a,h			;9b64
	ld a,l			;9b65
	add a,b			;9b66
	add a,e			;9b67
	ld (hl),a		;9b68
	ld a,a			;9b69
	ld h,d			;9b6a
	ld h,h			;9b6b
	ld d,l			;9b6c
	ld d,(hl)		;9b6d
	ld h,e			;9b6e
	ld h,l			;9b6f
	ld e,(hl)		;9b70
	ld d,c			;9b71
	add a,b			;9b72
	ld d,d			;9b73
	ld d,e			;9b74
	ld d,c			;9b75
	add a,b			;9b76
	ld h,(hl)		;9b77
	ld d,a			;9b78
	ld e,b			;9b79
	add a,(hl)		;9b7a
	add a,a			;9b7b
	add a,(hl)		;9b7c
	add a,a			;9b7d
	adc a,b			;9b7e
	adc a,c			;9b7f
	adc a,b			;9b80
	adc a,c			;9b81
	add a,a			;9b82
	add a,(hl)		;9b83
	add a,a			;9b84
	add a,(hl)		;9b85
	adc a,c			;9b86
	adc a,b			;9b87
	adc a,c			;9b88
	adc a,b			;9b89
	ret p			;9b8a
	rst 28h			;9b8b
	xor 087h		;9b8c
	jp p,0fbf1h		;9b8e
	adc a,c			;9b91
	call p,0fcf3h		;9b92
	add a,(hl)		;9b95
	jp p,0fbf1h		;9b96
	adc a,b			;9b99
	add a,(hl)		;9b9a
	sbc a,l			;9b9b
	sub l			;9b9c
	sbc a,b			;9b9d
	adc a,b			;9b9e
	sbc a,(hl)		;9b9f
	sub (hl)		;9ba0
	sbc a,c			;9ba1
	add a,a			;9ba2
	add a,(hl)		;9ba3
	add a,a			;9ba4
	add a,(hl)		;9ba5
	adc a,c			;9ba6
	adc a,b			;9ba7
	adc a,c			;9ba8
	adc a,b			;9ba9
	ret m			;9baa
	jp m,087fdh		;9bab
	ld sp,hl		;9bae
	rst 30h			;9baf
	cp 089h			;9bb0
	add a,a			;9bb2
	add a,(hl)		;9bb3
	add a,a			;9bb4
	add a,(hl)		;9bb5
	adc a,c			;9bb6
	adc a,b			;9bb7
	adc a,c			;9bb8
	adc a,b			;9bb9
	ld b,l			;9bba
	ld b,l			;9bbb
	ld b,l			;9bbc
	ld b,l			;9bbd
	ld b,(hl)		;9bbe
	ld b,(hl)		;9bbf
	ld b,(hl)		;9bc0
	ld b,(hl)		;9bc1
	ld l,c			;9bc2
	ld b,a			;9bc3
	ld b,a			;9bc4
	ld b,a			;9bc5
	ld l,l			;9bc6
	ld l,d			;9bc7
	ld c,b			;9bc8
	ld c,b			;9bc9
	ld b,l			;9bca
	ld b,l			;9bcb
	ld b,l			;9bcc
	ld b,l			;9bcd
	ld b,(hl)		;9bce
	ld b,(hl)		;9bcf
	ld b,(hl)		;9bd0
	ld b,(hl)		;9bd1
	ld b,a			;9bd2
	ld c,c			;9bd3
	ld l,h			;9bd4
	ld l,h			;9bd5
	ld c,b			;9bd6
	ld c,d			;9bd7
	ld l,l			;9bd8
	ld l,l			;9bd9
	ld e,h			;9bda
	ld d,d			;9bdb
	ld d,e			;9bdc
	ld d,c			;9bdd
	ld h,c			;9bde
	ld h,(hl)		;9bdf
	ld d,h			;9be0
	ld d,c			;9be1
	ld h,(hl)		;9be2
	ld h,(hl)		;9be3
	ld e,e			;9be4
	ld e,b			;9be5
	adc a,h			;9be6
	adc a,l			;9be7
	ret pe			;9be8
	adc a,b			;9be9
	or c			;9bea
	or e			;9beb
	or d			;9bec
	cp h			;9bed
	or c			;9bee
	or h			;9bef
	add a,0c1h		;9bf0
	cp b			;9bf2
	cp e			;9bf3
	add a,0c6h		;9bf4
	adc a,c			;9bf6
	adc a,b			;9bf7
	ex de,hl		;9bf8
	jp pe,08760h		;9bf9
	add a,(hl)		;9bfc
	add a,a			;9bfd
	ld e,h			;9bfe
	ld d,l			;9bff
	ld e,c			;9c00
	ld d,(hl)		;9c01
	ld e,h			;9c02
	ld e,a			;9c03
	ld e,d			;9c04
	ld d,c			;9c05
	ld e,h			;9c06
	ld l,l			;9c07
	ld e,(hl)		;9c08
	ld d,c			;9c09
	add a,(hl)		;9c0a
	add a,a			;9c0b
	add a,(hl)		;9c0c
	ret nz			;9c0d
	or (hl)			;9c0e
	cp c			;9c0f
	or l			;9c10
	cp h			;9c11
	or c			;9c12
	cp d			;9c13
	cp a			;9c14
	cp h			;9c15
	or c			;9c16
	cp (hl)			;9c17
	ld l,l			;9c18
	cp h			;9c19
	sbc a,h			;9c1a
	sub l			;9c1b
	adc a,d			;9c1c
	add a,b			;9c1d
	ld bc,0ec99h		;9c1e
	add a,b			;9c21
	add a,b			;9c22
	add a,b			;9c23
	add a,b			;9c24
	add a,b			;9c25
	add a,b			;9c26
	add a,b			;9c27
	add a,b			;9c28
	add a,b			;9c29
	add a,b			;9c2a
	add a,b			;9c2b
	add a,b			;9c2c
	add a,b			;9c2d
	add a,b			;9c2e
	add a,b			;9c2f
	add a,b			;9c30
	ld l,d			;9c31
	add a,b			;9c32
	add a,b			;9c33
	ld l,e			;9c34
	or h			;9c35
	add a,b			;9c36
	ld l,h			;9c37
	cp c			;9c38
	cp b			;9c39
	ld l,l			;9c3a
	cp (hl)			;9c3b
	cp l			;9c3c
	cp h			;9c3d
	ld h,b			;9c3e
	add a,b			;9c3f
	add a,b			;9c40
	add a,b			;9c41
	ld d,h			;9c42
	ld h,c			;9c43
	add a,b			;9c44
	add a,b			;9c45
	ld e,b			;9c46
	ld e,c			;9c47
	ld h,d			;9c48
	add a,b			;9c49
	ld e,h			;9c4a
	ld e,l			;9c4b
	ld e,(hl)		;9c4c
	ld h,e			;9c4d
	ld d,b			;9c4e
	ld d,c			;9c4f
	ld d,d			;9c50
	ld d,e			;9c51
	ld d,h			;9c52
	ld d,l			;9c53
	ld d,(hl)		;9c54
	ld d,a			;9c55
	ld e,b			;9c56
	ld e,c			;9c57
	ld e,d			;9c58
	ld e,e			;9c59
	ld e,h			;9c5a
	ld e,l			;9c5b
	ld e,(hl)		;9c5c
	ld e,a			;9c5d
	ld h,h			;9c5e
	ld d,c			;9c5f
	ld d,d			;9c60
	ld d,e			;9c61
	ld h,l			;9c62
	ld h,a			;9c63
	ld d,(hl)		;9c64
	ld d,a			;9c65
	ld h,(hl)		;9c66
	ld l,b			;9c67
	ld l,c			;9c68
	ld e,e			;9c69
	add a,c			;9c6a
	add a,d			;9c6b
	add a,e			;9c6c
	add a,h			;9c6d
	ld b,l			;9c6e
	ld b,l			;9c6f
	ld b,l			;9c70
	ld b,l			;9c71
	ld b,(hl)		;9c72
	ld b,(hl)		;9c73
	ld b,(hl)		;9c74
	ld b,(hl)		;9c75
	ld b,a			;9c76
	ld c,c			;9c77
	ld (hl),b		;9c78
	ld (hl),b		;9c79
	ld c,b			;9c7a
	ld c,d			;9c7b
	add a,b			;9c7c
	add a,b			;9c7d
	sbc a,b			;9c7e
	sbc a,c			;9c7f
	add a,d			;9c80
	add a,b			;9c81
	sbc a,l			;9c82
	sbc a,h			;9c83
	add a,e			;9c84
	add a,c			;9c85
	add a,b			;9c86
	add a,b			;9c87
	add a,b			;9c88
	add a,e			;9c89
	add a,b			;9c8a
	add a,c			;9c8b
	sbc a,a			;9c8c
	add a,b			;9c8d
	add a,c			;9c8e
	add a,b			;9c8f
	ld a,d			;9c90
	ld a,e			;9c91
	halt			;9c92
	add a,b			;9c93
	ld l,(hl)		;9c94
	ld a,(ix-080h)		;9c95
	sub l			;9c98
	sub (hl)		;9c99
	sub a			;9c9a
	add a,c			;9c9b
	ld h,h			;9c9c
	add a,b			;9c9d
	add a,c			;9c9e
	add a,b			;9c9f
	ld e,d			;9ca0
	ld h,l			;9ca1
	adc a,b			;9ca2
	add a,b			;9ca3
	ld e,(hl)		;9ca4
	ld e,a			;9ca5
	ld h,(hl)		;9ca6
	adc a,b			;9ca7
	ld h,c			;9ca8
	ld h,d			;9ca9
	ld h,e			;9caa
	ld h,a			;9cab
	ld d,(hl)		;9cac
	ld d,a			;9cad
	ld e,b			;9cae
	ld e,c			;9caf
	ld e,d			;9cb0
	ld e,e			;9cb1
	ld e,h			;9cb2
	ld e,l			;9cb3
	ld e,(hl)		;9cb4
	ld e,a			;9cb5
	ld h,b			;9cb6
	ld d,h			;9cb7
	ld h,c			;9cb8
	ld h,d			;9cb9
	ld h,e			;9cba
	ld h,a			;9cbb
	ld d,b			;9cbc
	ld d,a			;9cbd
	ld e,b			;9cbe
	ld e,c			;9cbf
	ld d,c			;9cc0
	ld d,d			;9cc1
	ld d,e			;9cc2
	ld e,l			;9cc3
	ld bc,08401h		;9cc4
	add a,l			;9cc7
	ld bc,08786h		;9cc8
	add a,b			;9ccb
	ld l,b			;9ccc
	ld l,c			;9ccd
	ld l,b			;9cce
	ld l,c			;9ccf
	ld b,e			;9cd0
	ld b,h			;9cd1
	ld b,e			;9cd2
	ld b,h			;9cd3
	ld c,e			;9cd4
	ld c,e			;9cd5
	ld c,e			;9cd6
	ld c,e			;9cd7
	adc a,d			;9cd8
	adc a,c			;9cd9
	adc a,d			;9cda
	adc a,c			;9cdb
	sbc a,d			;9cdc
	ld sp,hl		;9cdd
	ret m			;9cde
	add a,b			;9cdf
	ld bc,09e9bh		;9ce0
	add a,b			;9ce3
	add a,e			;9ce4
	add a,c			;9ce5
	add a,b			;9ce6
	add a,b			;9ce7
	add a,b			;9ce8
	add a,e			;9ce9
	add a,b			;9cea
	add a,c			;9ceb
	ld l,b			;9cec
	ld l,c			;9ced
	ld l,b			;9cee
	ld l,c			;9cef
	ld b,e			;9cf0
	ld b,h			;9cf1
	ld b,e			;9cf2
	ld b,h			;9cf3
	ld c,e			;9cf4
	ld c,e			;9cf5
	ld c,e			;9cf6
	ld c,e			;9cf7
	ld c,e			;9cf8
	ld c,e			;9cf9
	ld c,e			;9cfa
	ld c,e			;9cfb
	ld c,e			;9cfc
	ld c,e			;9cfd
	ld c,e			;9cfe
	ld c,e			;9cff
	ld c,e			;9d00
	ld c,e			;9d01
	ld c,e			;9d02
	ld c,e			;9d03
	adc a,a			;9d04
	sub b			;9d05
	adc a,a			;9d06
	sub b			;9d07
	ld l,b			;9d08
	ld l,c			;9d09
	ld l,b			;9d0a
	ld l,c			;9d0b
	ld b,e			;9d0c
	ld b,h			;9d0d
	ld b,e			;9d0e
	ld b,h			;9d0f
	ld c,e			;9d10
	ld c,e			;9d11
	ld c,e			;9d12
	ld c,e			;9d13
	adc a,a			;9d14
	sub b			;9d15
	adc a,a			;9d16
	sub b			;9d17
	ld l,a			;9d18
	ld l,l			;9d19
	ld l,a			;9d1a
	ld l,l			;9d1b
	ld b,e			;9d1c
	ld b,h			;9d1d
	ld b,e			;9d1e
	ld b,h			;9d1f
	ld c,e			;9d20
	ld c,e			;9d21
	ld c,e			;9d22
	ld c,e			;9d23
	ld c,e			;9d24
	ld c,e			;9d25
	ld c,e			;9d26
	ld c,e			;9d27
	ld c,e			;9d28
	ld c,e			;9d29
	ld c,e			;9d2a
	ld c,e			;9d2b
	adc a,d			;9d2c
	adc a,c			;9d2d
	adc a,d			;9d2e
	adc a,c			;9d2f
	ld l,a			;9d30
	ld l,l			;9d31
	ld l,a			;9d32
	ld l,l			;9d33
	ld b,e			;9d34
	ld b,h			;9d35
	ld b,e			;9d36
	ld b,h			;9d37
	ld c,e			;9d38
	ld c,e			;9d39
	ld c,e			;9d3a
	ld c,e			;9d3b
	adc a,a			;9d3c
	sub b			;9d3d
	adc a,a			;9d3e
	sub b			;9d3f
	ld l,a			;9d40
	ld l,l			;9d41
	ld l,a			;9d42
	ld l,l			;9d43
	ld b,e			;9d44
	ld b,h			;9d45
	ld b,e			;9d46
	ld b,h			;9d47
	ld c,e			;9d48
	ld c,e			;9d49
	ld c,e			;9d4a
	ld c,e			;9d4b
	adc a,d			;9d4c
	adc a,c			;9d4d
	adc a,d			;9d4e
	adc a,c			;9d4f
	adc a,e			;9d50
	adc a,e			;9d51
	adc a,e			;9d52
	adc a,e			;9d53
	adc a,h			;9d54
	adc a,h			;9d55
	adc a,h			;9d56
	adc a,h			;9d57
	adc a,l			;9d58
	adc a,l			;9d59
	adc a,l			;9d5a
	adc a,l			;9d5b
	adc a,(hl)		;9d5c
	adc a,(hl)		;9d5d
	adc a,(hl)		;9d5e
	adc a,(hl)		;9d5f
	add a,h			;9d60
	add a,b			;9d61
	add a,c			;9d62
	add a,b			;9d63
	ld bc,08385h		;9d64
	add a,b			;9d67
	ld bc,08086h		;9d68
	add a,b			;9d6b
	ld bc,08087h		;9d6c
	add a,c			;9d6f
	adc a,b			;9d70
	add a,b			;9d71
	add a,c			;9d72
	add a,b			;9d73
	ld bc,08385h		;9d74
	add a,b			;9d77
	ld bc,08086h		;9d78
	add a,b			;9d7b
	ld bc,08087h		;9d7c
	add a,c			;9d7f
	ld d,b			;9d80
	ld d,c			;9d81
	ld d,d			;9d82
	ld d,e			;9d83
	ld d,c			;9d84
	ld d,b			;9d85
	ld d,c			;9d86
	ld d,h			;9d87
	ld d,b			;9d88
	ld d,c			;9d89
	ld d,b			;9d8a
	ld d,l			;9d8b
	ld d,c			;9d8c
	ld d,b			;9d8d
	ld d,c			;9d8e
	ld d,(hl)		;9d8f
	add a,b			;9d90
	add a,b			;9d91
	add a,c			;9d92
	add a,b			;9d93
	add a,d			;9d94
	add a,b			;9d95
	add a,e			;9d96
	add a,b			;9d97
	ld e,d			;9d98
	ld e,e			;9d99
	add a,b			;9d9a
	add a,b			;9d9b
	ld d,c			;9d9c
	ld d,b			;9d9d
	ld e,e			;9d9e
	adc a,h			;9d9f
	ld d,b			;9da0
	ld d,c			;9da1
	ld d,a			;9da2
	ld e,c			;9da3
	ld e,b			;9da4
	ld e,b			;9da5
	ld e,c			;9da6
	ld e,c			;9da7
	ld bc,08a01h		;9da8
	adc a,c			;9dab
	adc a,e			;9dac
	adc a,e			;9dad
	add a,b			;9dae
	add a,c			;9daf
	add a,h			;9db0
	add a,b			;9db1
	add a,c			;9db2
	add a,b			;9db3
	add a,a			;9db4
	add a,b			;9db5
	add a,e			;9db6
	add a,b			;9db7
	add a,e			;9db8
	add a,c			;9db9
	add a,b			;9dba
	add a,b			;9dbb
	add a,b			;9dbc
	add a,e			;9dbd
	add a,b			;9dbe
	add a,c			;9dbf
	add a,b			;9dc0
	add a,b			;9dc1
	sub d			;9dc2
	push af			;9dc3
	add a,b			;9dc4
	add a,b			;9dc5
	adc a,h			;9dc6
	sbc a,b			;9dc7
	add a,b			;9dc8
	add a,b			;9dc9
	add a,b			;9dca
	add a,b			;9dcb
	add a,b			;9dcc
	add a,b			;9dcd
	add a,b			;9dce
	add a,b			;9dcf
	defb 0fdh,080h,080h ;illegal sequence	;9dd0
	add a,b			;9dd3
	ret pe			;9dd4
	add a,b			;9dd5
	add a,b			;9dd6
	adc a,c			;9dd7
	jp m,08080h		;9dd8
	adc a,l			;9ddb
	call p,06d6fh		;9ddc
	ld l,l			;9ddf
	rst 8			;9de0
	ld b,e			;9de1
	ld b,h			;9de2
	ld b,e			;9de3
	ld b,h			;9de4
	ld c,e			;9de5
	ld c,e			;9de6
	ld c,e			;9de7
	ld c,e			;9de8
	adc a,a			;9de9
	sub b			;9dea
	adc a,a			;9deb
	sub b			;9dec
	ld l,a			;9ded
	ld l,l			;9dee
	ld l,l			;9def
	rst 8			;9df0
	ld b,e			;9df1
	ld b,h			;9df2
	ld b,e			;9df3
	ld b,h			;9df4
	ld c,e			;9df5
	ld c,e			;9df6
	ld c,e			;9df7
	ld c,e			;9df8
	adc a,d			;9df9
	adc a,c			;9dfa
	adc a,d			;9dfb
	adc a,c			;9dfc
	add a,b			;9dfd
	add a,b			;9dfe
	ld l,e			;9dff
	ld (hl),e		;9e00
	add a,d			;9e01
	add a,b			;9e02
	sub e			;9e03
	sub a			;9e04
	add a,e			;9e05
	add a,c			;9e06
	sbc a,b			;9e07
	sbc a,c			;9e08
	add a,b			;9e09
	add a,e			;9e0a
	sub l			;9e0b
	sbc a,e			;9e0c
	sub b			;9e0d
	sub c			;9e0e
	sub d			;9e0f
	add a,b			;9e10
	ld l,a			;9e11
	rst 30h			;9e12
	sub h			;9e13
	add a,b			;9e14
	sbc a,d			;9e15
	ld sp,hl		;9e16
	ret m			;9e17
	add a,b			;9e18
	sbc a,h			;9e19
	ei			;9e1a
	sub (hl)		;9e1b
	add a,c			;9e1c
	add a,b			;9e1d
	add a,b			;9e1e
	sbc a,a			;9e1f
	sbc a,l			;9e20
	add a,d			;9e21
	add a,b			;9e22
	add a,e			;9e23
	add a,b			;9e24
	add a,e			;9e25
	add a,c			;9e26
	add a,b			;9e27
	add a,b			;9e28
	add a,b			;9e29
	add a,e			;9e2a
	add a,b			;9e2b
	add a,c			;9e2c
	sbc a,(hl)		;9e2d
	defb 0fdh,0ffh,080h ;illegal sequence	;9e2e
	add a,d			;9e31
	add a,b			;9e32
	add a,e			;9e33
	add a,b			;9e34
	add a,e			;9e35
	add a,c			;9e36
	add a,b			;9e37
	add a,b			;9e38
	add a,b			;9e39
	add a,e			;9e3a
	add a,b			;9e3b
	add a,c			;9e3c
	pop hl			;9e3d
	sbc a,(hl)		;9e3e
	pop de			;9e3f
	sbc a,(hl)		;9e40
	push bc			;9e41
	sbc a,(hl)		;9e42
	or l			;9e43
	sbc a,(hl)		;9e44
	and e			;9e45
	sbc a,(hl)		;9e46
	sub h			;9e47
	sbc a,(hl)		;9e48
	adc a,c			;9e49
	sbc a,(hl)		;9e4a
	ld a,c			;9e4b
	sbc a,(hl)		;9e4c
	ld l,h			;9e4d
	sbc a,(hl)		;9e4e
	ld d,c			;9e4f
	sbc a,(hl)		;9e50
	nop			;9e51
	dec c			;9e52
	add hl,bc		;9e53
	ld a,(bc)		;9e54
	jr nz,$-94		;9e55
	ld a,(bc)		;9e57
	adc a,c			;9e58
	adc a,l			;9e59
	dec c			;9e5a
	nop			;9e5b
	dec sp			;9e5c
	inc a			;9e5d
	nop			;9e5e
	adc a,l			;9e5f
	dec c			;9e60
	nop			;9e61
	dec a			;9e62
	ld a,000h		;9e63
	adc a,l			;9e65
	dec c			;9e66
	nop			;9e67
	adc a,l			;9e68
	dec c			;9e69
	nop			;9e6a
	adc a,l			;9e6b
	dec c			;9e6c
	nop			;9e6d
	adc a,l			;9e6e
	ld c,000h		;9e6f
	adc a,(hl)		;9e71
	nop			;9e72
	dec b			;9e73
	ld (bc),a		;9e74
	add a,l			;9e75
	nop			;9e76
	rrca			;9e77
	nop			;9e78
	nop			;9e79
	dec b			;9e7a
	ld (bc),a		;9e7b
	add a,l			;9e7c
	ld (bc),a		;9e7d
	add a,l			;9e7e
	nop			;9e7f
	rrca			;9e80
	nop			;9e81
	adc a,a			;9e82
	rrca			;9e83
	nop			;9e84
	adc a,a			;9e85
	rrca			;9e86
	nop			;9e87
	adc a,a			;9e88
	rrca			;9e89
	nop			;9e8a
	adc a,a			;9e8b
	nop			;9e8c
	nop			;9e8d
	adc a,a			;9e8e
	nop			;9e8f
	dec b			;9e90
	ld (bc),a		;9e91
	add a,l			;9e92
	nop			;9e93
	inc c			;9e94
	nop			;9e95
	adc a,a			;9e96
	dec c			;9e97
	nop			;9e98
	adc a,a			;9e99
	dec c			;9e9a
	nop			;9e9b
	dec c			;9e9c
	nop			;9e9d
	dec c			;9e9e
	nop			;9e9f
	dec c			;9ea0
	nop			;9ea1
	adc a,h			;9ea2
	dec c			;9ea3
	nop			;9ea4
	adc a,l			;9ea5
	dec c			;9ea6
	nop			;9ea7
	adc a,l			;9ea8
	dec c			;9ea9
	nop			;9eaa
	adc a,l			;9eab
	ld c,000h		;9eac
	adc a,(hl)		;9eae
	dec b			;9eaf
	ld (bc),a		;9eb0
	dec b			;9eb1
	ld (bc),a		;9eb2
	add a,l			;9eb3
	nop			;9eb4
	rrca			;9eb5
	nop			;9eb6
	rrca			;9eb7
	nop			;9eb8
	adc a,h			;9eb9
	rrca			;9eba
	nop			;9ebb
	adc a,l			;9ebc
	nop			;9ebd
	adc a,l			;9ebe
	rrca			;9ebf
	nop			;9ec0
	adc a,l			;9ec1
	rrca			;9ec2
	nop			;9ec3
	adc a,(hl)		;9ec4
	rrca			;9ec5
	nop			;9ec6
	nop			;9ec7
	dec b			;9ec8
	ld (bc),a		;9ec9
	add a,l			;9eca
	nop			;9ecb
	inc c			;9ecc
	nop			;9ecd
	dec c			;9ece
	nop			;9ecf
	adc a,a			;9ed0
	dec c			;9ed1
	nop			;9ed2
	adc a,a			;9ed3
	dec c			;9ed4
	nop			;9ed5
	dec c			;9ed6
	nop			;9ed7
	dec c			;9ed8
	nop			;9ed9
	adc a,h			;9eda
	dec c			;9edb
	nop			;9edc
	adc a,l			;9edd
	dec c			;9ede
	nop			;9edf
	adc a,l			;9ee0
	dec c			;9ee1
	nop			;9ee2
	adc a,l			;9ee3
	dec c			;9ee4
	nop			;9ee5
	adc a,l			;9ee6
	ld c,000h		;9ee7
	adc a,(hl)		;9ee9
	nop			;9eea
	nop			;9eeb
	nop			;9eec
	nop			;9eed
	nop			;9eee
	ld bc,0bbffh		;9eef
	cp e			;9ef2
	add a,e			;9ef3
	add a,e			;9ef4
	add a,e			;9ef5
	add a,e			;9ef6
	ld bc,00161h		;9ef7
	add a,c			;9efa
	ld bc,0013dh		;9efb
	add a,e			;9efe
	add a,e			;9eff
	add a,e			;9f00
	add a,e			;9f01
	ld bc,00103h		;9f02
	add hl,de		;9f05
	ld bc,08383h		;9f06
	add a,c			;9f09
	add a,c			;9f0a
	add a,c			;9f0b
	add a,e			;9f0c
	add a,e			;9f0d
	add a,e			;9f0e
	add a,e			;9f0f
	add a,e			;9f10
	ld a,c			;9f11
	ld bc,08381h		;9f12
	add a,e			;9f15
	inc bc			;9f16
	add a,e			;9f17
	add a,e			;9f18
	add a,c			;9f19
	ld bc,00129h		;9f1a
	add a,c			;9f1d
	add a,e			;9f1e
	add a,e			;9f1f
	add a,c			;9f20
	add a,c			;9f21
	add a,e			;9f22
	add a,e			;9f23
	add a,e			;9f24
	add a,e			;9f25
	add a,e			;9f26
	add a,e			;9f27
	ld bc,00101h		;9f28
	ld bc,00a01h		;9f2b
	and b			;9f2e
	di			;9f2f
	sbc a,a			;9f30
	pop hl			;9f31
	sbc a,a			;9f32
	ret z			;9f33
	sbc a,a			;9f34
	or l			;9f35
	sbc a,a			;9f36
	sbc a,(hl)		;9f37
	sbc a,a			;9f38
	adc a,e			;9f39
	sbc a,a			;9f3a
	ld (hl),d		;9f3b
	sbc a,a			;9f3c
	ld e,(hl)		;9f3d
	sbc a,a			;9f3e
	ld b,c			;9f3f
	sbc a,a			;9f40
	nop			;9f41
	inc (hl)		;9f42
	add hl,bc		;9f43
	ld a,(bc)		;9f44
	jr nz,$-94		;9f45
	ld a,(bc)		;9f47
	adc a,c			;9f48
	or h			;9f49
	inc sp			;9f4a
	ld (0b200h),a		;9f4b
	or e			;9f4e
	inc sp			;9f4f
	ld sp,0b100h		;9f50
	or e			;9f53
	inc sp			;9f54
	ld sp,0b100h		;9f55
	or e			;9f58
	inc sp			;9f59
	ld sp,0b100h		;9f5a
	or e			;9f5d
	dec (hl)		;9f5e
	ld (hl),000h		;9f5f
	or c			;9f61
	or e			;9f62
	nop			;9f63
	or (hl)			;9f64
	or l			;9f65
	nop			;9f66
	inc (hl)		;9f67
	nop			;9f68
	inc sp			;9f69
	ld (0b400h),a		;9f6a
	inc sp			;9f6d
	ld sp,0b200h		;9f6e
	or e			;9f71
	inc sp			;9f72
	ld sp,0b100h		;9f73
	or e			;9f76
	dec (hl)		;9f77
	ld (hl),000h		;9f78
	or c			;9f7a
	or e			;9f7b
	nop			;9f7c
	or c			;9f7d
	or e			;9f7e
	inc (hl)		;9f7f
	nop			;9f80
	or c			;9f81
	or e			;9f82
	inc sp			;9f83
	ld (0b600h),a		;9f84
	or l			;9f87
	dec (hl)		;9f88
	ld (hl),000h		;9f89
	nop			;9f8b
	nop			;9f8c
	or h			;9f8d
	inc (hl)		;9f8e
	nop			;9f8f
	or d			;9f90
	or e			;9f91
	inc sp			;9f92
	ld (0b600h),a		;9f93
	or l			;9f96
	inc sp			;9f97
	ld sp,03300h		;9f98
	ld sp,0b400h		;9f9b
	inc sp			;9f9e
	ld sp,0b200h		;9f9f
	or e			;9fa2
	inc sp			;9fa3
	ld sp,0b600h		;9fa4
	or l			;9fa7
	inc sp			;9fa8
	ld sp,03300h		;9fa9
	ld sp,03500h		;9fac
	ld (hl),000h		;9faf
	or h			;9fb1
	nop			;9fb2
	or d			;9fb3
	or e			;9fb4
	nop			;9fb5
	or c			;9fb6
	or e			;9fb7
	nop			;9fb8
	or c			;9fb9
	or e			;9fba
	nop			;9fbb
	or c			;9fbc
	or e			;9fbd
	nop			;9fbe
	or c			;9fbf
	or e			;9fc0
	nop			;9fc1
	or c			;9fc2
	or e			;9fc3
	inc (hl)		;9fc4
	nop			;9fc5
	or c			;9fc6
	or e			;9fc7
	inc sp			;9fc8
	ld (0b600h),a		;9fc9
	or l			;9fcc
	inc sp			;9fcd
	ld sp,03300h		;9fce
	ld sp,03300h		;9fd1
	ld sp,0b400h		;9fd4
	inc sp			;9fd7
	ld sp,0b200h		;9fd8
	or e			;9fdb
	inc sp			;9fdc
	ld sp,0b100h		;9fdd
	or e			;9fe0
	inc sp			;9fe1
	ld sp,0b600h		;9fe2
	or l			;9fe5
	inc sp			;9fe6
	ld sp,03500h		;9fe7
	ld (hl),000h		;9fea
	nop			;9fec
	nop			;9fed
	or h			;9fee
	inc (hl)		;9fef
	nop			;9ff0
	or d			;9ff1
	or e			;9ff2
	inc sp			;9ff3
	ld (0b100h),a		;9ff4
	or e			;9ff7
	dec (hl)		;9ff8
	ld (hl),000h		;9ff9
	or c			;9ffb
	or e			;9ffc
	nop			;9ffd
	or c			;9ffe
	or e			;9fff
	nop			;a000
	or c			;a001
	or e			;a002
	nop			;a003
	or c			;a004
	or e			;a005
	inc (hl)		;a006
	nop			;a007
	or c			;a008
	or e			;a009
	inc sp			;a00a
	ld (0b100h),a		;a00b
	or e			;a00e
	inc sp			;a00f
	ld sp,0b100h		;a010
	or e			;a013
	inc sp			;a014
	ld sp,0b600h		;a015
	or l			;a018
	inc sp			;a019
	ld sp,03500h		;a01a
	ld (hl),000h		;a01d
	nop			;a01f
	nop			;a020
	ld bc,0c7ffh		;a021
	rst 0			;a024
	rst 0			;a025
	rst 0			;a026
	rst 0			;a027
	rlca			;a028
	ld bc,0c381h		;a029
	rst 0			;a02c
	rst 0			;a02d
	rst 0			;a02e
	rlca			;a02f
	add a,a			;a030
	rst 0			;a031
	pop bc			;a032
	ld bc,08703h		;a033
	rst 0			;a036
	pop bc			;a037
	jp 0c7c7h		;a038
	pop bc			;a03b
	pop bc			;a03c
	jp 00707h		;a03d
	rlca			;a040
	rlca			;a041
	rlca			;a042
	rlca			;a043
	add a,a			;a044
	rst 0			;a045
	pop bc			;a046
	pop bc			;a047
	jp 0c7c7h		;a048
	rst 0			;a04b
	pop bc			;a04c
	pop bc			;a04d
	ld bc,08703h		;a04e
	rst 0			;a051
	rst 0			;a052
	rlca			;a053
	rlca			;a054
	rlca			;a055
	add a,a			;a056
	rst 0			;a057
	rst 0			;a058
	rst 0			;a059
	pop bc			;a05a
	pop bc			;a05b
	ld bc,0f101h		;a05c
	and b			;a05f
	jp po,0d8a0h		;a060
	and b			;a063
	ret			;a064
	and b			;a065
	cp e			;a066
	and b			;a067
	xor h			;a068
	and b			;a069
	and c			;a06a
	and b			;a06b
	sub a			;a06c
	and b			;a06d
	add a,a			;a06e
	and b			;a06f
	ld (hl),d		;a070
	and b			;a071
	nop			;a072
	inc bc			;a073
	add hl,bc		;a074
	ld a,(bc)		;a075
	jr nz,$-94		;a076
	ld a,(bc)		;a078
	adc a,c			;a079
	add a,(hl)		;a07a
	inc bc			;a07b
	nop			;a07c
	add a,e			;a07d
	ld b,000h		;a07e
	add a,e			;a080
	inc bc			;a081
	nop			;a082
	add a,(hl)		;a083
	ld b,000h		;a084
	add a,(hl)		;a086
	ld b,000h		;a087
	add a,e			;a089
	inc bc			;a08a
	nop			;a08b
	adc a,b			;a08c
	ld b,000h		;a08d
	inc bc			;a08f
	nop			;a090
	add a,a			;a091
	ex af,af'		;a092
	nop			;a093
	add a,e			;a094
	nop			;a095
	adc a,b			;a096
	nop			;a097
	ld bc,00081h		;a098
	ld bc,08102h		;a09b
	nop			;a09e
	rlca			;a09f
	nop			;a0a0
	ld b,000h		;a0a1
	inc bc			;a0a3
	nop			;a0a4
	ex af,af'		;a0a5
	nop			;a0a6
	nop			;a0a7
	ld bc,08102h		;a0a8
	nop			;a0ab
	nop			;a0ac
	rlca			;a0ad
	nop			;a0ae
	add a,a			;a0af
	inc bc			;a0b0
	nop			;a0b1
	add a,(hl)		;a0b2
	ld b,000h		;a0b3
	add a,e			;a0b5
	ex af,af'		;a0b6
	nop			;a0b7
	add a,e			;a0b8
	nop			;a0b9
	adc a,b			;a0ba
	ld bc,00081h		;a0bb
	nop			;a0be
	add a,a			;a0bf
	rlca			;a0c0
	nop			;a0c1
	add a,e			;a0c2
	inc bc			;a0c3
	nop			;a0c4
	add a,(hl)		;a0c5
	ld b,000h		;a0c6
	add a,(hl)		;a0c8
	ld b,000h		;a0c9
	add a,e			;a0cb
	inc bc			;a0cc
	nop			;a0cd
	add a,(hl)		;a0ce
	ld b,000h		;a0cf
	adc a,b			;a0d1
	inc bc			;a0d2
	nop			;a0d3
	inc bc			;a0d4
	nop			;a0d5
	ex af,af'		;a0d6
	nop			;a0d7
	nop			;a0d8
	nop			;a0d9
	nop			;a0da
	ld bc,00281h		;a0db
	add a,c			;a0de
	nop			;a0df
	nop			;a0e0
	add a,a			;a0e1
	nop			;a0e2
	add a,(hl)		;a0e3
	nop			;a0e4
	adc a,b			;a0e5
	ld bc,08102h		;a0e6
	nop			;a0e9
	add a,a			;a0ea
	rlca			;a0eb
	nop			;a0ec
	add a,(hl)		;a0ed
	ld b,000h		;a0ee
	add a,(hl)		;a0f0
	inc bc			;a0f1
	nop			;a0f2
	add a,e			;a0f3
	ld b,000h		;a0f4
	adc a,b			;a0f6
	ld b,000h		;a0f7
	inc bc			;a0f9
	nop			;a0fa
	ex af,af'		;a0fb
	nop			;a0fc
	nop			;a0fd
	nop			;a0fe
	ld bc,083ffh		;a0ff
	add a,e			;a102
	add a,e			;a103
	add a,e			;a104
	add a,e			;a105
	add a,e			;a106
	add a,c			;a107
	add a,e			;a108
	add a,e			;a109
	inc bc			;a10a
	ld bc,00111h		;a10b
	add hl,de		;a10e
	ld bc,08181h		;a10f
	add a,c			;a112
	add a,c			;a113
	ld bc,00131h		;a114
	ld bc,08383h		;a117
	add a,e			;a11a
	add a,e			;a11b
	inc bc			;a11c
	ld de,00301h		;a11d
	add a,e			;a120
	add a,e			;a121
	add a,e			;a122
	add a,e			;a123
	add a,e			;a124
	add a,e			;a125
	add a,c			;a126
	add a,c			;a127
	add a,c			;a128
	ld bc,00101h		;a129
	rla			;a12c
	ld bc,00303h		;a12d
	inc bc			;a130
	add hl,de		;a131
	inc bc			;a132
	add a,e			;a133
	add a,e			;a134
	add a,e			;a135
	add a,e			;a136
	add a,c			;a137
	add a,c			;a138
	add a,c			;a139
	ld bc,0bd01h		;a13a
	and c			;a13d
	or b			;a13e
	and c			;a13f
	and l			;a140
	and c			;a141
	sbc a,d			;a142
	and c			;a143
	sub c			;a144
	and c			;a145
	adc a,b			;a146
	and c			;a147
	ld a,(hl)		;a148
	and c			;a149
	ld (hl),b		;a14a
	and c			;a14b
	ld h,l			;a14c
	and c			;a14d
	ld d,b			;a14e
	and c			;a14f
	nop			;a150
	rrca			;a151
	add hl,bc		;a152
	ld a,(bc)		;a153
	jr nz,$-94		;a154
	ld a,(bc)		;a156
	adc a,c			;a157
	adc a,a			;a158
	rrca			;a159
	nop			;a15a
	adc a,a			;a15b
	rrca			;a15c
	nop			;a15d
	adc a,a			;a15e
	rrca			;a15f
	nop			;a160
	adc a,a			;a161
	rrca			;a162
	nop			;a163
	adc a,a			;a164
	rrca			;a165
	nop			;a166
	adc a,a			;a167
	nop			;a168
	dec b			;a169
	add a,l			;a16a
	nop			;a16b
	dec b			;a16c
	ld (bc),a		;a16d
	add a,l			;a16e
	nop			;a16f
	nop			;a170
	rrca			;a171
	nop			;a172
	adc a,a			;a173
	rrca			;a174
	nop			;a175
	adc a,a			;a176
	rrca			;a177
	nop			;a178
	adc a,a			;a179
	rrca			;a17a
	nop			;a17b
	adc a,a			;a17c
	nop			;a17d
	dec b			;a17e
	add a,l			;a17f
	nop			;a180
	nop			;a181
	dec b			;a182
	add a,l			;a183
	nop			;a184
	rrca			;a185
	nop			;a186
	adc a,a			;a187
	nop			;a188
	adc a,a			;a189
	nop			;a18a
	dec b			;a18b
	add a,l			;a18c
	nop			;a18d
	rrca			;a18e
	nop			;a18f
	nop			;a190
	nop			;a191
	nop			;a192
	adc a,a			;a193
	nop			;a194
	nop			;a195
	rrca			;a196
	nop			;a197
	rrca			;a198
	nop			;a199
	rrca			;a19a
	nop			;a19b
	nop			;a19c
	nop			;a19d
	adc a,a			;a19e
	rrca			;a19f
	nop			;a1a0
	dec b			;a1a1
	ld (bc),a		;a1a2
	add a,l			;a1a3
	nop			;a1a4
	nop			;a1a5
	nop			;a1a6
	rrca			;a1a7
	nop			;a1a8
	adc a,a			;a1a9
	nop			;a1aa
	nop			;a1ab
	adc a,a			;a1ac
	rrca			;a1ad
	nop			;a1ae
	adc a,a			;a1af
	rrca			;a1b0
	nop			;a1b1
	adc a,a			;a1b2
	nop			;a1b3
	dec b			;a1b4
	ld (bc),a		;a1b5
	add a,l			;a1b6
	nop			;a1b7
	rrca			;a1b8
	nop			;a1b9
	adc a,a			;a1ba
	rrca			;a1bb
	nop			;a1bc
	rrca			;a1bd
	nop			;a1be
	adc a,a			;a1bf
	nop			;a1c0
	adc a,a			;a1c1
	nop			;a1c2
	rrca			;a1c3
	nop			;a1c4
	nop			;a1c5
	adc a,a			;a1c6
	nop			;a1c7
	nop			;a1c8
	ld bc,083ffh		;a1c9
	add a,e			;a1cc
	add a,e			;a1cd
	add a,e			;a1ce
	add a,e			;a1cf
	ld bc,00111h		;a1d0
	add hl,de		;a1d3
	ld bc,08301h		;a1d4
	add a,e			;a1d7
	add a,e			;a1d8
	add a,e			;a1d9
	ld bc,00111h		;a1da
	ld bc,00111h		;a1dd
	add a,e			;a1e0
	inc bc			;a1e1
	ld bc,00111h		;a1e2
	add a,c			;a1e5
	ld bc,00301h		;a1e6
	ld bc,08101h		;a1e9
	add a,c			;a1ec
	add a,c			;a1ed
	ld bc,08103h		;a1ee
	ld sp,00101h		;a1f1
	ld bc,00183h		;a1f4
	inc bc			;a1f7
	add a,e			;a1f8
	add a,e			;a1f9
	ld bc,00131h		;a1fa
	add a,e			;a1fd
	add a,c			;a1fe
	add a,e			;a1ff
	inc bc			;a200
	ld bc,00381h		;a201
	ld bc,09b01h		;a204
	and d			;a207
	adc a,l			;a208
	and d			;a209
	add a,c			;a20a
	and d			;a20b
	ld (hl),l		;a20c
	and d			;a20d
	ld h,e			;a20e
	and d			;a20f
	ld e,c			;a210
	and d			;a211
	ld c,e			;a212
	and d			;a213
	ld b,b			;a214
	and d			;a215
	dec (hl)		;a216
	and d			;a217
	ld a,(de)		;a218
	and d			;a219
	ld a,(de)		;a21a
	inc e			;a21b
	add hl,bc		;a21c
	ld a,(bc)		;a21d
	jr nz,$-94		;a21e
	ld a,(bc)		;a220
	adc a,c			;a221
	sbc a,h			;a222
	inc e			;a223
	ld a,(de)		;a224
	ccf			;a225
	inc b			;a226
	ld a,(de)		;a227
	sbc a,h			;a228
	inc e			;a229
	ld a,(de)		;a22a
	scf			;a22b
	jr c,$+28		;a22c
	sbc a,h			;a22e
	inc e			;a22f
	ld a,(de)		;a230
	sbc a,h			;a231
	inc e			;a232
	ld a,(de)		;a233
	sbc a,h			;a234
	inc e			;a235
	ld a,(de)		;a236
	sbc a,h			;a237
	dec e			;a238
	ld a,(de)		;a239
	sbc a,l			;a23a
	ld a,(de)		;a23b
	ld a,(de)		;a23c
	ld a,(de)		;a23d
	dec de			;a23e
	ld a,(de)		;a23f
	inc e			;a240
	ld a,(de)		;a241
	inc e			;a242
	ld a,(de)		;a243
	inc e			;a244
	ld a,(de)		;a245
	inc e			;a246
	ld a,(de)		;a247
	dec e			;a248
	ld a,(de)		;a249
	ld a,(de)		;a24a
	ld a,(de)		;a24b
	ld a,(de)		;a24c
	ld e,01ah		;a24d
	sbc a,h			;a24f
	dec de			;a250
	ld a,(de)		;a251
	sbc a,h			;a252
	inc e			;a253
	ld a,(de)		;a254
	sbc a,h			;a255
	inc e			;a256
	ld a,(de)		;a257
	sbc a,h			;a258
	dec e			;a259
	ld a,(de)		;a25a
	sbc a,h			;a25b
	ld a,(de)		;a25c
	sbc a,h			;a25d
	ld a,(de)		;a25e
	sbc a,l			;a25f
	ld a,(de)		;a260
	ld a,(de)		;a261
	ld a,(de)		;a262
	dec de			;a263
	ld a,(de)		;a264
	ld e,01ch		;a265
	ld a,(de)		;a267
	sbc a,h			;a268
	inc e			;a269
	ld a,(de)		;a26a
	sbc a,h			;a26b
	inc e			;a26c
	ld a,(de)		;a26d
	sbc a,h			;a26e
	inc e			;a26f
	ld a,(de)		;a270
	sbc a,h			;a271
	inc e			;a272
	ld a,(de)		;a273
	sbc a,h			;a274
	inc e			;a275
	ld a,(de)		;a276
	sbc a,h			;a277
	inc e			;a278
	ld a,(de)		;a279
	sbc a,h			;a27a
	dec e			;a27b
	ld a,(de)		;a27c
	sbc a,l			;a27d
	ld a,(de)		;a27e
	ld a,(de)		;a27f
	ld a,(de)		;a280
	ld a,(de)		;a281
	ld e,01ah		;a282
	sbc a,h			;a284
	ld a,(de)		;a285
	sbc a,h			;a286
	ld a,(de)		;a287
	sbc a,h			;a288
	ld a,(de)		;a289
	sbc a,l			;a28a
	dec de			;a28b
	ld a,(de)		;a28c
	inc e			;a28d
	ld a,(de)		;a28e
	inc e			;a28f
	ld a,(de)		;a290
	inc e			;a291
	ld a,(de)		;a292
	inc e			;a293
	ld a,(de)		;a294
	inc e			;a295
	ld a,(de)		;a296
	ld e,01ch		;a297
	ld a,(de)		;a299
	sbc a,h			;a29a
	inc e			;a29b
	ld a,(de)		;a29c
	sbc a,h			;a29d
	inc e			;a29e
	ld a,(de)		;a29f
	sbc a,h			;a2a0
	dec e			;a2a1
	ld a,(de)		;a2a2
	sbc a,h			;a2a3
	ld a,(de)		;a2a4
	sbc a,h			;a2a5
	ld a,(de)		;a2a6
	sbc a,h			;a2a7
	ld a,(de)		;a2a8
	sbc a,h			;a2a9
	ld a,(de)		;a2aa
	sbc a,h			;a2ab
	ld bc,0bbffh		;a2ac
	cp e			;a2af
	add a,e			;a2b0
	add a,e			;a2b1
	add a,e			;a2b2
	add a,e			;a2b3
	ld bc,00101h		;a2b4
	add a,c			;a2b7
	add a,c			;a2b8
	add a,c			;a2b9
	add a,c			;a2ba
	add a,c			;a2bb
	add a,c			;a2bc
	ld bc,00301h		;a2bd
	inc bc			;a2c0
	add a,e			;a2c1
	add a,e			;a2c2
	add a,e			;a2c3
	add a,e			;a2c4
	inc bc			;a2c5
	inc bc			;a2c6
	ld bc,00101h		;a2c7
	add a,e			;a2ca
	add a,e			;a2cb
	add a,e			;a2cc
	add a,e			;a2cd
	add a,e			;a2ce
	add a,e			;a2cf
	add a,e			;a2d0
	add a,e			;a2d1
	add a,e			;a2d2
	ld bc,00101h		;a2d3
	inc bc			;a2d6
	inc bc			;a2d7
	inc bc			;a2d8
	inc bc			;a2d9
	inc bc			;a2da
	add a,c			;a2db
	add a,c			;a2dc
	add a,c			;a2dd
	add a,c			;a2de
	add a,c			;a2df
	add a,e			;a2e0
	add a,e			;a2e1
	add a,e			;a2e2
	add a,e			;a2e3
	add a,e			;a2e4
	inc bc			;a2e5
	inc bc			;a2e6
	inc bc			;a2e7
	inc bc			;a2e8
	add a,(hl)		;a2e9
	and e			;a2ea
	ld a,b			;a2eb
	and e			;a2ec
	ld l,b			;a2ed
	and e			;a2ee
	ld e,h			;a2ef
	and e			;a2f0
	ld c,h			;a2f1
	and e			;a2f2
	ccf			;a2f3
	and e			;a2f4
	inc sp			;a2f5
	and e			;a2f6
	dec h			;a2f7
	and e			;a2f8
	jr $-91			;a2f9
	defb 0fdh,0a2h,000h ;illegal sequence	;a2fb
	inc hl			;a2fe
	add hl,bc		;a2ff
	ld a,(bc)		;a300
	jr nz,$-94		;a301
	ld a,(bc)		;a303
	adc a,c			;a304
	and d			;a305
	inc hl			;a306
	nop			;a307
	rra			;a308
	ld hl,0a300h		;a309
	inc hl			;a30c
	nop			;a30d
	ld h,027h		;a30e
	nop			;a310
	and e			;a311
	inc hl			;a312
	nop			;a313
	and e			;a314
	inc hl			;a315
	nop			;a316
	and e			;a317
	inc hl			;a318
	nop			;a319
	and e			;a31a
	inc h			;a31b
	nop			;a31c
	and e			;a31d
	nop			;a31e
	and h			;a31f
	dec h			;a320
	and l			;a321
	nop			;a322
	ld (02300h),hl		;a323
	nop			;a326
	inc hl			;a327
	nop			;a328
	and d			;a329
	inc h			;a32a
	nop			;a32b
	and h			;a32c
	dec h			;a32d
	and l			;a32e
	nop			;a32f
	dec h			;a330
	ld (bc),a		;a331
	and l			;a332
	nop			;a333
	ld (02400h),hl		;a334
	nop			;a337
	nop			;a338
	and d			;a339
	nop			;a33a
	and e			;a33b
	ld (0a300h),hl		;a33c
	inc hl			;a33f
	nop			;a340
	and h			;a341
	inc hl			;a342
	nop			;a343
	inc h			;a344
	nop			;a345
	dec h			;a346
	and l			;a347
	ld (02400h),hl		;a348
	nop			;a34b
	dec h			;a34c
	ld (bc),a		;a34d
	and l			;a34e
	nop			;a34f
	and d			;a350
	ld (0a300h),hl		;a351
	inc hl			;a354
	nop			;a355
	and e			;a356
	inc h			;a357
	nop			;a358
	and e			;a359
	nop			;a35a
	and e			;a35b
	nop			;a35c
	and h			;a35d
	nop			;a35e
	dec h			;a35f
	and l			;a360
	nop			;a361
	and d			;a362
	nop			;a363
	and e			;a364
	ld (0a300h),hl		;a365
	inc hl			;a368
	nop			;a369
	and e			;a36a
	inc hl			;a36b
	nop			;a36c
	and h			;a36d
	inc h			;a36e
	nop			;a36f
	dec h			;a370
	ld (bc),a		;a371
	and l			;a372
	nop			;a373
	and d			;a374
	ld (0a400h),hl		;a375
	inc h			;a378
	nop			;a379
	nop			;a37a
	ld (0a200h),hl		;a37b
	inc h			;a37e
	nop			;a37f
	and h			;a380
	dec h			;a381
	ld (bc),a		;a382
	and l			;a383
	ld (02300h),hl		;a384
	nop			;a387
	inc hl			;a388
	nop			;a389
	and d			;a38a
	inc hl			;a38b
	nop			;a38c
	and e			;a38d
	inc hl			;a38e
	nop			;a38f
	and h			;a390
	inc hl			;a391
	nop			;a392
	inc h			;a393
	nop			;a394
	nop			;a395
	ld bc,0bbffh		;a396
	cp e			;a399
	add a,e			;a39a
	add a,e			;a39b
	add a,e			;a39c
	add a,e			;a39d
	inc bc			;a39e
	ld de,08101h		;a39f
	add a,c			;a3a2
	add a,e			;a3a3
	add a,e			;a3a4
	ld de,02901h		;a3a5
	ld bc,08181h		;a3a8
	inc bc			;a3ab
	inc bc			;a3ac
	add a,e			;a3ad
	add a,e			;a3ae
	add a,c			;a3af
	add a,c			;a3b0
	ld de,08181h		;a3b1
	pop bc			;a3b4
	inc bc			;a3b5
	add a,e			;a3b6
	add a,e			;a3b7
	add a,e			;a3b8
	inc bc			;a3b9
	inc bc			;a3ba
	ld bc,00311h		;a3bb
	inc bc			;a3be
	add a,e			;a3bf
	add a,e			;a3c0
	add a,e			;a3c1
	add a,c			;a3c2
	dec c			;a3c3
	inc bc			;a3c4
	add a,e			;a3c5
	add a,c			;a3c6
	ld bc,08383h		;a3c7
	ld sp,08181h		;a3ca
	add a,e			;a3cd
	add a,e			;a3ce
	add a,e			;a3cf
	add a,c			;a3d0
	add a,c			;a3d1
	ld bc,0a47eh		;a3d2
	halt			;a3d5
	and h			;a3d6
	ld l,b			;a3d7
	and h			;a3d8
	ld e,d			;a3d9
	and h			;a3da
	ld c,b			;a3db
	and h			;a3dc
	dec (hl)		;a3dd
	and h			;a3de
	add hl,hl		;a3df
	and h			;a3e0
	ld de,0fca4h		;a3e1
	and e			;a3e4
	rst 20h			;a3e5
	and e			;a3e6
	nop			;a3e7
	ld (00a09h),hl		;a3e8
	jr nz,$-94		;a3eb
	ld a,(bc)		;a3ed
	adc a,c			;a3ee
	and e			;a3ef
	inc hl			;a3f0
	nop			;a3f1
	and e			;a3f2
	inc hl			;a3f3
	nop			;a3f4
	and e			;a3f5
	inc hl			;a3f6
	nop			;a3f7
	and e			;a3f8
	inc hl			;a3f9
	nop			;a3fa
	and e			;a3fb
	inc h			;a3fc
	nop			;a3fd
	and e			;a3fe
	nop			;a3ff
	and h			;a400
	ld hl,(0aa02h)		;a401
	ld (bc),a		;a404
	xor d			;a405
	jr z,$+4		;a406
	xor b			;a408
	ld (bc),a		;a409
	xor b			;a40a
	add hl,hl		;a40b
	add hl,sp		;a40c
	xor c			;a40d
	add hl,sp		;a40e
	xor c			;a40f
	jr nc,$+46		;a410
	ld (bc),a		;a412
	inc l			;a413
	xor h			;a414
	ld (bc),a		;a415
	xor h			;a416
	jr z,$+59		;a417
	add hl,hl		;a419
	add hl,sp		;a41a
	jr z,$+42		;a41b
	jr nc,$+42		;a41d
	jr z,$+47		;a41f
	xor l			;a421
	jr z,$+42		;a422
	jr nc,$+42		;a424
	jr z,$+50		;a426
	jr z,$+42		;a428
	jr nc,$+42		;a42a
	add hl,hl		;a42c
	dec l			;a42d
	xor l			;a42e
	add hl,hl		;a42f
	jr nc,$+47		;a430
	xor l			;a432
	jr nc,$+50		;a433
	jr nc,$+46		;a435
	ld (bc),a		;a437
	xor h			;a438
	ld (bc),a		;a439
	xor h			;a43a
	ld l,03ah		;a43b
	ld l,03ah		;a43d
	ld l,022h		;a43f
	nop			;a441
	inc hl			;a442
	nop			;a443
	and d			;a444
	inc h			;a445
	nop			;a446
	and h			;a447
	nop			;a448
	ld hl,(02a02h)		;a449
	dec hl			;a44c
	xor d			;a44d
	jr z,$+4		;a44e
	jr z,$+4		;a450
	jr z,$+43		;a452
	add hl,sp		;a454
	add hl,hl		;a455
	ld (bc),a		;a456
	add hl,hl		;a457
	jr nc,$+50		;a458
	jr nc,$+46		;a45a
	dec l			;a45c
	xor l			;a45d
	xor h			;a45e
	jr z,$+50		;a45f
	jr z,$+43		;a461
	dec l			;a463
	xor l			;a464
	add hl,hl		;a465
	jr nc,$+50		;a466
	jr nc,$+50		;a468
	inc l			;a46a
	ld (bc),a		;a46b
	inc l			;a46c
	ld (bc),a		;a46d
	xor h			;a46e
	add hl,hl		;a46f
	add hl,sp		;a470
	add hl,hl		;a471
	add hl,sp		;a472
	add hl,hl		;a473
	jr nc,$+50		;a474
	jr nc,$+47		;a476
	xor l			;a478
	jr nc,$+47		;a479
	xor l			;a47b
	jr nc,$+50		;a47c
	jr nc,$+50		;a47e
	cpl			;a480
	ld (bc),a		;a481
	xor a			;a482
	nop			;a483
	and d			;a484
	ld (0a300h),hl		;a485
	inc hl			;a488
	nop			;a489
	and h			;a48a
	inc hl			;a48b
	nop			;a48c
	ld bc,083ffh		;a48d
	add a,e			;a490
	add a,e			;a491
	add a,e			;a492
	add a,e			;a493
	inc bc			;a494
	dec a			;a495
	dec a			;a496
	dec a			;a497
	ld bc,0c7d7h		;a498
	add a,e			;a49b
	sub e			;a49c
	add a,e			;a49d
	add a,e			;a49e
	add a,e			;a49f
	sub e			;a4a0
	ld bc,00111h		;a4a1
	ld bc,01f01h		;a4a4
	rra			;a4a7
	add a,c			;a4a8
	add a,e			;a4a9
	add a,e			;a4aa
	ld bc,07979h		;a4ab
	ld a,c			;a4ae
	ld bc,00101h		;a4af
	sub e			;a4b2
	add a,e			;a4b3
	sub e			;a4b4
	ld bc,00101h		;a4b5
	ld bc,0f1f1h		;a4b8
	ld bc,00101h		;a4bb
	ld de,01101h		;a4be
	ld bc,00101h		;a4c1
	ld bc,00329h		;a4c4
	add a,e			;a4c7
	add a,e			;a4c8
	add a,c			;a4c9
	ld l,(hl)		;a4ca
	and l			;a4cb
	ld e,(hl)		;a4cc
	and l			;a4cd
	ld c,a			;a4ce
	and l			;a4cf
	dec a			;a4d0
	and l			;a4d1
	dec (hl)		;a4d2
	and l			;a4d3
	dec h			;a4d4
	and l			;a4d5
	dec d			;a4d6
	and l			;a4d7
	ex af,af'		;a4d8
	and l			;a4d9
	ld sp,hl		;a4da
	and h			;a4db
	sbc a,0a4h		;a4dc
	djnz $+15		;a4de
	inc d			;a4e0
	ld a,(bc)		;a4e1
	dec d			;a4e2
	sub l			;a4e3
	ld a,(bc)		;a4e4
	sub h			;a4e5
	adc a,l			;a4e6
	dec c			;a4e7
	djnz $+13		;a4e8
	ld de,08d10h		;a4ea
	dec c			;a4ed
	djnz $+20		;a4ee
	inc de			;a4f0
	djnz $-113		;a4f1
	dec c			;a4f3
	djnz $-113		;a4f4
	dec c			;a4f6
	djnz $-113		;a4f7
	dec c			;a4f9
	djnz $-113		;a4fa
	dec c			;a4fc
	djnz $+25		;a4fd
	dec c			;a4ff
	djnz $+15		;a500
	djnz $+15		;a502
	djnz $+15		;a504
	djnz $+27		;a506
	dec c			;a508
	djnz $-113		;a509
	ld d,010h		;a50b
	adc a,l			;a50d
	djnz $+25		;a50e
	djnz $+18		;a510
	jr $+18			;a512
	add hl,de		;a514
	ld d,010h		;a515
	adc a,l			;a517
	djnz $-113		;a518
	djnz $-113		;a51a
	jr $+18			;a51c
	adc a,l			;a51e
	dec c			;a51f
	djnz $-113		;a520
	dec c			;a522
	djnz $-113		;a523
	dec c			;a525
	djnz $-113		;a526
	dec c			;a528
	djnz $-113		;a529
	dec c			;a52b
	djnz $-113		;a52c
	ld d,010h		;a52e
	adc a,l			;a530
	djnz $-113		;a531
	djnz $-113		;a533
	djnz $-113		;a535
	djnz $+25		;a537
	djnz $+18		;a539
	djnz $+18		;a53b
	jr $+18			;a53d
	add hl,de		;a53f
	dec c			;a540
	djnz $-113		;a541
	dec c			;a543
	djnz $-113		;a544
	dec c			;a546
	djnz $-113		;a547
	dec c			;a549
	djnz $-113		;a54a
	dec c			;a54c
	djnz $-113		;a54d
	dec c			;a54f
	djnz $-113		;a550
	dec c			;a552
	djnz $+25		;a553
	dec c			;a555
	djnz $+15		;a556
	djnz $+15		;a558
	djnz $+24		;a55a
	djnz $+27		;a55c
	djnz $-113		;a55e
	djnz $-113		;a560
	jr $+18			;a562
	adc a,l			;a564
	dec c			;a565
	djnz $-113		;a566
	dec c			;a568
	djnz $-113		;a569
	dec c			;a56b
	djnz $+25		;a56c
	dec c			;a56e
	djnz $+24		;a56f
	djnz $+18		;a571
	djnz $+18		;a573
	djnz $+18		;a575
	ld bc,0bbffh		;a577
	cp e			;a57a
	add a,e			;a57b
	add a,e			;a57c
	add a,e			;a57d
	add a,e			;a57e
	add a,c			;a57f
	add a,c			;a580
	add a,c			;a581
	add a,e			;a582
	add a,e			;a583
	add a,e			;a584
	inc bc			;a585
	ld bc,08301h		;a586
	add a,e			;a589
	inc bc			;a58a
	inc bc			;a58b
	add a,e			;a58c
	add a,e			;a58d
	add a,e			;a58e
	add a,e			;a58f
	add a,e			;a590
	add a,e			;a591
	add a,e			;a592
	inc bc			;a593
	inc bc			;a594
	inc bc			;a595
	inc bc			;a596
	ld bc,00101h		;a597
	ld bc,08383h		;a59a
	add a,e			;a59d
	add a,e			;a59e
	add a,e			;a59f
	add a,e			;a5a0
	add a,e			;a5a1
	add a,e			;a5a2
	add a,c			;a5a3
	add a,c			;a5a4
	add a,c			;a5a5
	add a,e			;a5a6
	inc bc			;a5a7
	inc bc			;a5a8
	add a,e			;a5a9
	add a,e			;a5aa
	add a,e			;a5ab
	add a,e			;a5ac
	add a,c			;a5ad
	add a,c			;a5ae
	ld bc,00101h		;a5af
	ld bc,0be01h		;a5b2
	and l			;a5b5
	sub 0a5h		;a5b6
	ex de,hl		;a5b8
	and l			;a5b9
	cp (hl)			;a5ba
	and l			;a5bb
	inc bc			;a5bc
	and (hl)		;a5bd
	ret z			;a5be
	and l			;a5bf
	rst 8			;a5c0
	and l			;a5c1
	or 00fh			;a5c2
	nop			;a5c4
	rlca			;a5c5
	rlca			;a5c6
	ld bc,02dffh		;a5c7
	and (hl)		;a5ca
	rst 38h			;a5cb
	ld b,b			;a5cc
	and (hl)		;a5cd
	nop			;a5ce
	rst 38h			;a5cf
	dec l			;a5d0
	and (hl)		;a5d1
	cp 020h			;a5d2
	xor 000h		;a5d4
	defb 0ddh,0a5h ;and ixl	;a5d6
	call po,0eea5h		;a5d8
	jr nc,$+9		;a5db
	rst 38h			;a5dd
	ld a,e			;a5de
	and (hl)		;a5df
	rst 38h			;a5e0
	ld b,b			;a5e1
	and (hl)		;a5e2
	nop			;a5e3
	rst 38h			;a5e4
	ld a,e			;a5e5
	and (hl)		;a5e6
	cp 020h			;a5e7
	xor 000h		;a5e9
	push af			;a5eb
	and l			;a5ec
	call m,0f6a5h		;a5ed
	rrca			;a5f0
	nop			;a5f1
	ld bc,00007h		;a5f2
	rst 38h			;a5f5
	dec l			;a5f6
	and (hl)		;a5f7
	rst 38h			;a5f8
	ld e,l			;a5f9
	and (hl)		;a5fa
	nop			;a5fb
	rst 38h			;a5fc
	dec l			;a5fd
	and (hl)		;a5fe
	cp 040h			;a5ff
	xor 000h		;a601
	ld de,018a6h		;a603
	and (hl)		;a606
	rra			;a607
	and (hl)		;a608
	ld h,0a6h		;a609
	nop			;a60b
	rrca			;a60c
	nop			;a60d
	ld bc,00010h		;a60e
	rst 38h			;a611
	sbc a,l			;a612
	and (hl)		;a613
	rst 38h			;a614
	dec bc			;a615
	and a			;a616
	nop			;a617
	rst 38h			;a618
	cp (hl)			;a619
	and (hl)		;a61a
	rst 38h			;a61b
	dec bc			;a61c
	and a			;a61d
	nop			;a61e
	rst 38h			;a61f
	ret po			;a620
	and (hl)		;a621
	rst 38h			;a622
	dec bc			;a623
	and a			;a624
	nop			;a625
	rst 38h			;a626
	ei			;a627
	and (hl)		;a628
	rst 38h			;a629
	dec bc			;a62a
	and a			;a62b
	nop			;a62c
	ld a,(bc)		;a62d
	nop			;a62e
	add a,(hl)		;a62f
	ld b,b			;a630
	ret nz			;a631
	call nz,068e8h		;a632
	ex af,af'		;a635
	ld a,(bc)		;a636
	nop			;a637
	add a,(hl)		;a638
	ld (bc),a		;a639
	inc bc			;a63a
	inc bc			;a63b
	rlca			;a63c
	ld b,000h		;a63d
	nop			;a63f
	add a,d			;a640
	rlca			;a641
	rrca			;a642
	dec b			;a643
	rra			;a644
	adc a,e			;a645
	cpl			;a646
	ld (hl),b		;a647
	ld (hl),a		;a648
	cpl			;a649
	nop			;a64a
	rrca			;a64b
	rrca			;a64c
	add hl,bc		;a64d
	ld b,0e0h		;a64e
	ret p			;a650
	dec b			;a651
	ret m			;a652
	add a,(hl)		;a653
	call p,0ee0eh		;a654
	or 006h			;a657
	ret p			;a659
	inc bc			;a65a
	nop			;a65b
	nop			;a65c
	add a,d			;a65d
	rlca			;a65e
	ex af,af'		;a65f
	dec b			;a660
	djnz $-115		;a661
	jr nc,$+81		;a663
	ld c,b			;a665
	jr nc,$+17		;a666
	djnz $+50		;a668
	ld (hl),009h		;a66a
	ret po			;a66c
	djnz $+7		;a66d
	ex af,af'		;a66f
	adc a,c			;a670
	inc c			;a671
	jp p,00a12h		;a672
	or 008h			;a675
	call m,0f0fch		;a677
	nop			;a67a
	and b			;a67b
	nop			;a67c
	rrca			;a67d
	ccf			;a67e
	ld (hl),b		;a67f
	ld b,b			;a680
	ld bc,00001h		;a681
	nop			;a684
	nop			;a685
	ld b,b			;a686
	ret nz			;a687
	call nz,068e8h		;a688
	ex af,af'		;a68b
	nop			;a68c
	ret p			;a68d
	call m,0020eh		;a68e
	add a,b			;a691
	add a,b			;a692
	nop			;a693
	nop			;a694
	nop			;a695
	ld (bc),a		;a696
	inc bc			;a697
	inc bc			;a698
	rlca			;a699
	ld b,000h		;a69a
	nop			;a69c
	sbc a,l			;a69d
	ld b,h			;a69e
	adc a,e			;a69f
	ld d,(hl)		;a6a0
	adc a,l			;a6a1
	ld l,d			;a6a2
	dec d			;a6a3
	ld a,(bc)		;a6a4
	dec h			;a6a5
	ld d,b			;a6a6
	dec h			;a6a7
	ld a,(bc)		;a6a8
	nop			;a6a9
	dec b			;a6aa
	ld a,(bc)		;a6ab
	ld bc,0a204h		;a6ac
	ld d,c			;a6af
	xor d			;a6b0
	ld d,l			;a6b1
	xor d			;a6b2
	ld d,b			;a6b3
	xor b			;a6b4
	ld d,h			;a6b5
	ld a,(bc)		;a6b6
	ld d,h			;a6b7
	and d			;a6b8
	inc b			;a6b9
	ld d,b			;a6ba
	inc bc			;a6bb
	nop			;a6bc
	nop			;a6bd
	and b			;a6be
	nop			;a6bf
	ld (bc),a		;a6c0
	nop			;a6c1
	ex af,af'		;a6c2
	nop			;a6c3
	ld (bc),a		;a6c4
	nop			;a6c5
	ld a,(bc)		;a6c6
	dec b			;a6c7
	ld de,00e0ah		;a6c8
	dec b			;a6cb
	ld a,(de)		;a6cc
	rlca			;a6cd
	nop			;a6ce
	nop			;a6cf
	nop			;a6d0
	jr nz,$-126		;a6d1
	nop			;a6d3
	and b			;a6d4
	ld d,b			;a6d5
	add a,b			;a6d6
	jr z,$+66		;a6d7
	sub b			;a6d9
	ld b,h			;a6da
	ld (hl),b		;a6db
	ret p			;a6dc
	ret po			;a6dd
	nop			;a6de
	nop			;a6df
	inc b			;a6e0
	nop			;a6e1
	adc a,e			;a6e2
	ld bc,00000h		;a6e3
	nop			;a6e6
	ld (bc),a		;a6e7
	ld bc,0050ah		;a6e8
	ld a,(bc)		;a6eb
	rrca			;a6ec
	rlca			;a6ed
	ex af,af'		;a6ee
	nop			;a6ef
	adc a,c			;a6f0
	add a,b			;a6f1
	nop			;a6f2
	nop			;a6f3
	ret nz			;a6f4
	ld b,b			;a6f5
	ret p			;a6f6
	ret p			;a6f7
	ret po			;a6f8
	nop			;a6f9
	nop			;a6fa
	dec bc			;a6fb
	nop			;a6fc
	add a,e			;a6fd
	inc bc			;a6fe
	rlca			;a6ff
	inc bc			;a700
	inc c			;a701
	nop			;a702
	add a,(hl)		;a703
	add a,b			;a704
	ret nz			;a705
	ret po			;a706
	ret nz			;a707
	nop			;a708
	nop			;a709
	nop			;a70a
	ld a,(bc)		;a70b
	nop			;a70c
	add a,(hl)		;a70d
	rlca			;a70e
	rra			;a70f
	ccf			;a710
	ccf			;a711
	rra			;a712
	rlca			;a713
	ld a,(bc)		;a714
	nop			;a715
	add a,(hl)		;a716
	ret po			;a717
	ret m			;a718
	call m,0f8fch		;a719
	ret po			;a71c
	nop			;a71d
	ld b,b			;a71e
	jr $-117		;a71f
	djnz $+17		;a721
	ex af,af'		;a723
	djnz $+17		;a724
	rra			;a726
	ccf			;a727
	ccf			;a728
	rrca			;a729
	rlca			;a72a
	nop			;a72b
	adc a,c			;a72c
	ex af,af'		;a72d
	ret p			;a72e
	djnz $+10		;a72f
	ret p			;a731
	ret m			;a732
	call m,0f0fch		;a733
	rlca			;a736
	nop			;a737
	ld (bc),a		;a738
	jr nz,$-125		;a739
	ld (hl),b		;a73b
	inc b			;a73c
	jr nz,$-120		;a73d
	ld (hl),b		;a73f
	xor b			;a740
	ld (hl),b		;a741
	xor b			;a742
	ld d,b			;a743
	adc a,b			;a744
	inc de			;a745
	nop			;a746
	ld (bc),a		;a747
	jr nz,$-125		;a748
	ld (hl),b		;a74a
	inc b			;a74b
	jr nz,$-120		;a74c
	ld (hl),b		;a74e
	xor c			;a74f
	ld (hl),b		;a750
	xor c			;a751
	ld d,b			;a752
	adc a,c			;a753
	inc bc			;a754
	nop			;a755
	ld (bc),a		;a756
	ld b,b			;a757
	add a,c			;a758
	ret po			;a759
	inc b			;a75a
	ld b,b			;a75b
	add a,(hl)		;a75c
	ret po			;a75d
	ld d,b			;a75e
	ret po			;a75f
	ld d,b			;a760
	and b			;a761
	djnz $+5		;a762
	nop			;a764
	adc a,(hl)		;a765
	djnz $+58		;a766
	ld a,(03478h)		;a768
	ld d,h			;a76b
	djnz $-109		;a76c
	jr c,$+86		;a76e
	jr c,$+86		;a770
	jr z,$+70		;a772
	ld (de),a		;a774
	nop			;a775
	ld (bc),a		;a776
	djnz $+10		;a777
	jr nc,$-124		;a779
	call m,00310h		;a77b
	jr nc,$-125		;a77e
	jr nz,$+18		;a780
	nop			;a782
	adc a,d			;a783
	ld b,b			;a784
	ld h,b			;a785
	jr nc,$+26		;a786
	jr c,$+58		;a788
	ld (hl),b		;a78a
	ld h,b			;a78b
	ret nz			;a78c
	add a,b			;a78d
	ld d,000h		;a78e
	add a,h			;a790
	inc e			;a791
	ld a,06fh		;a792
	jp 0000fh		;a794
	add a,d			;a797
	add a,b			;a798
	ret nz			;a799
	dec bc			;a79a
	nop			;a79b
	adc a,d			;a79c
	ex af,af'		;a79d
	jr $+50			;a79e
	ld (hl),b		;a7a0
	ret po			;a7a1
	ret po			;a7a2
	ret nz			;a7a3
	ld h,b			;a7a4
	jr nc,$+18		;a7a5
	ld d,000h		;a7a7
	add a,l			;a7a9
	ret nz			;a7aa
	ld (hl),b		;a7ab
	dec a			;a7ac
	rra			;a7ad
	ld c,00ch		;a7ae
	nop			;a7b0
	add a,d			;a7b1
	ret nz			;a7b2
	add a,b			;a7b3
	dec c			;a7b4
	nop			;a7b5
	add a,c			;a7b6
	ld h,b			;a7b7
	inc bc			;a7b8
	ret p			;a7b9
	add a,(hl)		;a7ba
	and b			;a7bb
	ld d,b			;a7bc
	add a,b			;a7bd
	jr nz,$+2		;a7be
	ld b,b			;a7c0
	ld hl,00400h		;a7c1
	ld a,a			;a7c4
	add a,c			;a7c5
	rra			;a7c6
	dec bc			;a7c7
	nop			;a7c8
	inc b			;a7c9
	cp 08fh			;a7ca
	ret m			;a7cc
	nop			;a7cd
	nop			;a7ce
	ld bc,03303h		;a7cf
	ld a,e			;a7d2
	ld a,d			;a7d3
	ld a,c			;a7d4
	ld d,d			;a7d5
	jr z,$+66		;a7d6
	ld de,02000h		;a7d8
	inc b			;a7db
	nop			;a7dc
	sub b			;a7dd
	add a,b			;a7de
	ret nz			;a7df
	call z,09edeh		;a7e0
	ld e,(hl)		;a7e3
	inc d			;a7e4
	adc a,d			;a7e5
	djnz $+6		;a7e6
	nop			;a7e8
	ex af,af'		;a7e9
	nop			;a7ea
	nop			;a7eb
	call m,003feh		;a7ec
	add a,082h		;a7ef
	cp 0fch			;a7f1
	inc bc			;a7f3
	ret nz			;a7f4
	ld d,000h		;a7f5
	add a,d			;a7f7
	ld c,(hl)		;a7f8
	jp z,04a04h		;a7f9
	add a,c			;a7fc
	xor 009h		;a7fd
	nop			;a7ff
	add a,c			;a800
	xor 005h		;a801
	xor d			;a803
	add a,c			;a804
	xor 009h		;a805
	nop			;a807
	ld (bc),a		;a808
	djnz $+10		;a809
	jr nc,$-124		;a80b
	defb 0fdh,010h,003h ;illegal sequence	;a80d
	jr nc,$+5		;a810
	jr nz,$+10		;a812
	ld h,b			;a814
	add a,d			;a815
	ret m			;a816
	jr nz,$+5		;a817
	ld h,b			;a819
	adc a,e			;a81a
	ld b,b			;a81b
	djnz $+18		;a81c
	inc h			;a81e
	ld d,b			;a81f
	ld d,h			;a820
	jp m,0fefeh		;a821
	ld a,h			;a824
	jr c,$+24		;a825
	nop			;a827
	adc a,c			;a828
	ld (bc),a		;a829
	nop			;a82a
	ld bc,01607h		;a82b
	dec c			;a82e
	rra			;a82f
	rra			;a830
	ccf			;a831
	inc bc			;a832
	ld a,a			;a833
	ld (bc),a		;a834
	ccf			;a835
	adc a,e			;a836
	rra			;a837
	rlca			;a838
	ld b,b			;a839
	add a,b			;a83a
	sub b			;a83b
	ld d,b			;a83c
	ret nz			;a83d
	ld b,b			;a83e
	ret nc			;a83f
	ret pe			;a840
	ret m			;a841
	inc b			;a842
	call m,0f886h		;a843
	ret p			;a846
	ret nz			;a847
	ld b,b			;a848
	ld h,b			;a849
	ld h,b			;a84a
	inc bc			;a84b
	ret p			;a84c
	add a,c			;a84d
	ld h,b			;a84e
	add hl,de		;a84f
	nop			;a850
	adc a,d			;a851
	inc b			;a852
	ld (de),a		;a853
	ex af,af'		;a854
	ld (de),a		;a855
	ld e,d			;a856
	ld c,b			;a857
	inc h			;a858
	ld e,h			;a859
	ld e,(hl)		;a85a
	ld a,(hl)		;a85b
	inc b			;a85c
	rst 38h			;a85d
	add a,d			;a85e
	ld a,(hl)		;a85f
	inc a			;a860
	ld b,000h		;a861
	ld (bc),a		;a863
	add a,b			;a864
	ex af,af'		;a865
	nop			;a866
	adc a,e			;a867
	jr nz,$+2		;a868
	ex af,af'		;a86a
	jr nz,$+2		;a86b
	sub b			;a86d
	jr nz,$+18		;a86e
	jr c,$+122		;a870
	jr nc,$+23		;a872
	nop			;a874
	add a,h			;a875
	ld h,b			;a876
	ret p			;a877
	ret p			;a878
	ld h,b			;a879
	daa			;a87a
	nop			;a87b
	add a,l			;a87c
	djnz $+58		;a87d
	jr c,$+50		;a87f
	djnz $+18		;a881
	nop			;a883
	adc a,c			;a884
	djnz $+34		;a885
	add hl,sp		;a887
	rrca			;a888
	dec l			;a889
	ld c,h			;a88a
	or l			;a88b
	rlca			;a88c
	dec b			;a88d
	ld a,(bc)		;a88e
	nop			;a88f
	add a,d			;a890
	ld b,b			;a891
	add a,b			;a892
	inc b			;a893
	nop			;a894
	add a,c			;a895
	add a,b			;a896
	ex af,af'		;a897
	nop			;a898
	add a,e			;a899
	inc bc			;a89a
	rlca			;a89b
	inc bc			;a89c
	ld b,001h		;a89d
	add a,e			;a89f
	inc bc			;a8a0
	rlca			;a8a1
	inc bc			;a8a2
	inc b			;a8a3
	nop			;a8a4
	add a,e			;a8a5
	ld b,b			;a8a6
	ret po			;a8a7
	ret nz			;a8a8
	ld b,080h		;a8a9
	add a,e			;a8ab
	ret nz			;a8ac
	ret po			;a8ad
	ld b,b			;a8ae
	add hl,bc		;a8af
	nop			;a8b0
	add a,(hl)		;a8b1
	ld bc,01f03h		;a8b2
	ld e,006h		;a8b5
	ld b,005h		;a8b7
	nop			;a8b9
	ld (bc),a		;a8ba
	jr nc,$-121		;a8bb
	inc a			;a8bd
	ld a,h			;a8be
	ret po			;a8bf
	ret nz			;a8c0
	add a,b			;a8c1
	inc c			;a8c2
	nop			;a8c3
	add a,(hl)		;a8c4
	djnz $+58		;a8c5
	ccf			;a8c7
	rra			;a8c8
	jr c,$+18		;a8c9
	ld a,(bc)		;a8cb
	nop			;a8cc
	add a,(hl)		;a8cd
	ex af,af'		;a8ce
	inc e			;a8cf
	call m,01cf8h		;a8d0
	ex af,af'		;a8d3
	rlca			;a8d4
	nop			;a8d5
	ld (bc),a		;a8d6
	inc c			;a8d7
	add a,l			;a8d8
	inc a			;a8d9
	ld a,007h		;a8da
	inc bc			;a8dc
	ld bc,0000eh		;a8dd
	add a,(hl)		;a8e0
	add a,b			;a8e1
	ret nz			;a8e2
	ret m			;a8e3
	ld a,b			;a8e4
	ld h,b			;a8e5
	ld h,b			;a8e6
	inc bc			;a8e7
	nop			;a8e8
	add a,(hl)		;a8e9
	adc a,b			;a8ea
	ld d,b			;a8eb
	xor b			;a8ec
	ld (hl),b		;a8ed
	xor b			;a8ee
	ld (hl),b		;a8ef
	inc b			;a8f0
	jr nz,$-123		;a8f1
	ld (hl),b		;a8f3
	jr nz,$+34		;a8f4
	dec d			;a8f6
	nop			;a8f7
	adc a,c			;a8f8
	ld (bc),a		;a8f9
	inc bc			;a8fa
	dec bc			;a8fb
	inc c			;a8fc
	ld c,010h		;a8fd
	ld h,b			;a8ff
	ld h,b			;a900
	add a,b			;a901
	dec b			;a902
	nop			;a903
	ld (bc),a		;a904
	add a,b			;a905
	add a,e			;a906
	ret po			;a907
	nop			;a908
	add a,b			;a909
	inc c			;a90a
	nop			;a90b
	add a,e			;a90c
	ld hl,021ffh		;a90d
	inc c			;a910
	nop			;a911
	add a,l			;a912
	xor b			;a913
	ld d,b			;a914
	ret po			;a915
	ld d,b			;a916
	xor b			;a917
	dec bc			;a918
	nop			;a919
	adc a,c			;a91a
	add a,b			;a91b
	ld h,b			;a91c
	ld h,b			;a91d
	djnz $+16		;a91e
	inc c			;a920
	dec bc			;a921
	inc bc			;a922
	ld (bc),a		;a923
	dec c			;a924
	nop			;a925
	add a,l			;a926
	add a,b			;a927
	nop			;a928
	ret po			;a929
	add a,b			;a92a
	add a,b			;a92b
	dec bc			;a92c
	nop			;a92d
	adc a,d			;a92e
	jr c,$+126		;a92f
	sbc a,0beh		;a931
	cp (hl)			;a933
	cp 07ch			;a934
	ld a,b			;a936
	jr nc,$+18		;a937
	inc de			;a939
	nop			;a93a
	adc a,b			;a93b
	ld bc,0060eh		;a93c
	ld a,(0e818h)		;a93f
	jr nz,$+34		;a942
	dec b			;a944
	nop			;a945
	add a,e			;a946
	jr nz,$-62		;a947
	ret nz			;a949
	dec c			;a94a
	nop			;a94b
	add a,l			;a94c
	xor b			;a94d
	ld d,h			;a94e
	ccf			;a94f
	ld d,h			;a950
	xor b			;a951
	inc c			;a952
	nop			;a953
	add a,e			;a954
	jr nz,$-6		;a955
	jr nz,$+14		;a957
	nop			;a959
	ld (bc),a		;a95a
	jr nz,$-120		;a95b
	ret pe			;a95d
	jr $+60			;a95e
	ld b,00eh		;a960
	ld bc,00010h		;a962
	ld (bc),a		;a965
	ret nz			;a966
	add a,c			;a967
	jr nz,$+7		;a968
	nop			;a96a
	add a,l			;a96b
	rlca			;a96c
	rra			;a96d
	ccf			;a96e
	ld a,a			;a96f
	ld a,a			;a970
	ld b,0ffh		;a971
	ld (bc),a		;a973
	ld a,a			;a974
	adc a,b			;a975
	ccf			;a976
	rra			;a977
	rlca			;a978
	ret po			;a979
	ret m			;a97a
	call m,0fefeh		;a97b
	ld b,0ffh		;a97e
	ld (bc),a		;a980
	cp 083h			;a981
	call m,0e0f8h		;a983
	add hl,bc		;a986
	nop			;a987
	add a,a			;a988
	jr c,$+94		;a989
	ld e,h			;a98b
	ld a,h			;a98c
	ld a,b			;a98d
	jr nc,$+18		;a98e
	djnz $+2		;a990
	nop			;a992
	or e			;a993
	xor c			;a994
	ld a,(bc)		;a995
	xor d			;a996
	ld a,(bc)		;a997
	xor d			;a998
	ld a,(bc)		;a999
	xor d			;a99a
	ld d,b			;a99b
	xor d			;a99c
	and e			;a99d
	xor d			;a99e
	ret			;a99f
	xor d			;a9a0
	rst 28h			;a9a1
	xor d			;a9a2
	ld l,d			;a9a3
	xor e			;a9a4
	sbc a,l			;a9a5
	xor e			;a9a6
	call c,02cabh		;a9a7
	xor h			;a9aa
	rla			;a9ab
	xor l			;a9ac
	and e			;a9ad
	xor d			;a9ae
	ld e,a			;a9af
	xor h			;a9b0
	sbc a,a			;a9b1
	xor h			;a9b2
	and b			;a9b3
	nop			;a9b4
	ld a,e			;a9b5
	ld e,a			;a9b6
	adc a,e			;a9b7
	dec a			;a9b8
	ld (hl),a		;a9b9
	ei			;a9ba
	ei			;a9bb
	adc a,(ix-021h)		;a9bc
	cp 03bh			;a9bf
	ld a,a			;a9c1
	ld a,a			;a9c2
	rra			;a9c3
	nop			;a9c4
	call c,0d5fah		;a9c5
	cp (hl)			;a9c8
	xor 0dfh		;a9c9
	rst 18h			;a9cb
	cp e			;a9cc
	ld (hl),a		;a9cd
	jp m,0dc7ch		;a9ce
	cp 0feh			;a9d1
	ret m			;a9d3
	ex af,af'		;a9d4
	rst 38h			;a9d5
	add hl,de		;a9d6
	nop			;a9d7
	sub c			;a9d8
	inc c			;a9d9
	ld a,03fh		;a9da
	ld a,b			;a9dc
	ld (hl),a		;a9dd
	scf			;a9de
	scf			;a9df
	dec de			;a9e0
	ld h,a			;a9e1
	ld a,a			;a9e2
	ld a,a			;a9e3
	ld a,l			;a9e4
	dec sp			;a9e5
	ld bc,00000h		;a9e6
	ld (hl),b		;a9e9
	inc bc			;a9ea
	ret m			;a9eb
	sub c			;a9ec
	call m,0faf6h		;a9ed
	jp m,0ecf4h		;a9f0
	call m,0f0f0h		;a9f3
	ret po			;a9f6
	nop			;a9f7
	rlca			;a9f8
	rra			;a9f9
	ccf			;a9fa
	ccf			;a9fb
	rra			;a9fc
	rlca			;a9fd
	ld a,(bc)		;a9fe
	nop			;a9ff
	add a,(hl)		;aa00
	ret po			;aa01
	ret m			;aa02
	call m,0f8fch		;aa03
	ret po			;aa06
	ld a,(bc)		;aa07
	nop			;aa08
	nop			;aa09
	adc a,d			;aa0a
	ld h,b			;aa0b
	cp b			;aa0c
	inc a			;aa0d
	ld a,07ch		;aa0e
	cp d			;aa10
	dec de			;aa11
	dec e			;aa12
	inc de			;aa13
	ld bc,00006h		;aa14
	adc a,d			;aa17
	ld b,01dh		;aa18
	inc a			;aa1a
	ld a,h			;aa1b
	ld a,05dh		;aa1c
	ret c			;aa1e
	cp b			;aa1f
	ret z			;aa20
	add a,b			;aa21
	dec bc			;aa22
	nop			;aa23
	adc a,e			;aa24
	ld (bc),a		;aa25
	inc de			;aa26
	dec e			;aa27
	dec sp			;aa28
	dec a			;aa29
	ld a,b			;aa2a
	ld (hl),h		;aa2b
	ld h,b			;aa2c
	ld d,b			;aa2d
	jr nz,$+18		;aa2e
	dec b			;aa30
	nop			;aa31
	sub c			;aa32
	ld b,b			;aa33
	ret z			;aa34
	cp b			;aa35
	call c,01ebch		;aa36
	ld l,006h		;aa39
	ld a,(bc)		;aa3b
	inc b			;aa3c
	ex af,af'		;aa3d
	rlca			;aa3e
	rra			;aa3f
	ccf			;aa40
	ccf			;aa41
	rra			;aa42
	rlca			;aa43
	ld a,(bc)		;aa44
	nop			;aa45
	add a,(hl)		;aa46
	ret po			;aa47
	ret m			;aa48
	call m,0f8fch		;aa49
	ret po			;aa4c
	ld a,(bc)		;aa4d
	nop			;aa4e
	nop			;aa4f
	add a,088h		;aa50
	push hl			;aa52
	rst 30h			;aa53
	ld l,a			;aa54
	ld c,e			;aa55
	add hl,hl		;aa56
	ld l,a			;aa57
	push af			;aa58
	jp c,0ce8dh		;aa59
	rla			;aa5c
	dec de			;aa5d
	inc e			;aa5e
	inc c			;aa5f
	jr c,$+19		;aa60
	and a			;aa62
	rst 28h			;aa63
	or 0d2h			;aa64
	sub h			;aa66
	or 0afh			;aa67
	ld e,e			;aa69
	or c			;aa6a
	ld (hl),e		;aa6b
	ret pe			;aa6c
	ret c			;aa6d
	jr c,$+50		;aa6e
	inc e			;aa70
	nop			;aa71
	ex af,af'		;aa72
	dec b			;aa73
	rlca			;aa74
	rrca			;aa75
	dec hl			;aa76
	add hl,hl		;aa77
	ld l,a			;aa78
	ld (hl),l		;aa79
	ld l,d			;aa7a
	call 01b16h		;aa7b
	inc c			;aa7e
	ld (bc),a		;aa7f
	ld c,000h		;aa80
	djnz $-94		;aa82
	ret po			;aa84
	ret p			;aa85
	call nc,0f694h		;aa86
	xor (hl)		;aa89
	ld d,(hl)		;aa8a
	or e			;aa8b
	ld l,b			;aa8c
	ret c			;aa8d
	jr nc,$+66		;aa8e
	ld (hl),b		;aa90
	rlca			;aa91
	rra			;aa92
	ccf			;aa93
	ccf			;aa94
	rra			;aa95
	rlca			;aa96
	ld a,(bc)		;aa97
	nop			;aa98
	add a,(hl)		;aa99
	ret po			;aa9a
	ret m			;aa9b
	call m,0f8fch		;aa9c
	ret po			;aa9f
	ld a,(bc)		;aaa0
	nop			;aaa1
	nop			;aaa2
	and b			;aaa3
	inc bc			;aaa4
	rlca			;aaa5
	ld c,01ch		;aaa6
	jr $+22			;aaa8
	ld (de),a		;aaaa
	jr nc,$+124		;aaab
	ld a,c			;aaad
	call m,07ffeh		;aaae
	ccf			;aab1
	rra			;aab2
	rlca			;aab3
	ret nz			;aab4
	ret po			;aab5
	ld (hl),b		;aab6
	jr c,$+26		;aab7
	jr z,$+74		;aab9
	ex af,af'		;aabb
	ld e,h			;aabc
	sbc a,(hl)		;aabd
	ld a,07eh		;aabe
	call m,0f8fch		;aac0
	ret po			;aac3
	ld a,(bc)		;aac4
	rst 38h			;aac5
	ld d,000h		;aac6
	nop			;aac8
	and b			;aac9
	ld bc,08703h		;aaca
	rst 8			;aacd
	rst 28h			;aace
	rst 38h			;aacf
	ei			;aad0
	defb 0fdh,07fh,07fh ;illegal sequence	;aad1
	ccf			;aad4
	ccf			;aad5
	ld a,a			;aad6
	ld a,a			;aad7
	ccf			;aad8
	rrca			;aad9
	add a,b			;aada
	ret nz			;aadb
	call po,0f7f6h		;aadc
	rst 38h			;aadf
	rst 18h			;aae0
	cp a			;aae1
	cp 0feh			;aae2
	call m,0fefch		;aae4
	cp 0cch			;aae7
	sub b			;aae9
	ld a,(bc)		;aaea
	rst 38h			;aaeb
	ld d,000h		;aaec
	nop			;aaee
	and (hl)		;aaef
	ld b,00dh		;aaf0
	rra			;aaf2
	rra			;aaf3
	dec de			;aaf4
	add hl,de		;aaf5
	ld e,(hl)		;aaf6
	rst 28h			;aaf7
	jp 01b90h		;aaf8
	dec c			;aafb
	nop			;aafc
	ld c,006h		;aafd
	inc e			;aaff
	ret po			;ab00
	ld (hl),b		;ab01
	ld a,b			;ab02
	ret m			;ab03
	ret c			;ab04
	sbc a,b			;ab05
	ret m			;ab06
	or 0c7h			;ab07
	ld c,e			;ab09
	exx			;ab0a
	or e			;ab0b
	ex af,af'		;ab0c
	jr nc,$+2		;ab0d
	nop			;ab0f
	add hl,bc		;ab10
	ld (de),a		;ab11
	jr nz,$+34		;ab12
	inc h			;ab14
	ld h,(hl)		;ab15
	inc b			;ab16
	rst 38h			;ab17
	adc a,l			;ab18
	and h			;ab19
	ld (0717fh),a		;ab1a
	add hl,sp		;ab1d
	inc bc			;ab1e
	djnz $-118		;ab1f
	add a,h			;ab21
	inc b			;ab22
	inc h			;ab23
	ld h,h			;ab24
	ld b,006h		;ab25
	rst 38h			;ab27
	add a,e			;ab28
	adc a,0fch		;ab29
	ret p			;ab2b
	inc bc			;ab2c
	nop			;ab2d
	adc a,l			;ab2e
	ld bc,03e19h		;ab2f
	ld l,c			;ab32
	call 089c7h		;ab33
	ld c,l			;ab36
	rlca			;ab37
	dec e			;ab38
	ret c			;ab39
	ld (hl),b		;ab3a
	jr nc,$+5		;ab3b
	nop			;ab3d
	sbc a,c			;ab3e
	add a,b			;ab3f
	sbc a,b			;ab40
	ld a,h			;ab41
	sub (hl)		;ab42
	or e			;ab43
	ex (sp),hl		;ab44
	sub c			;ab45
	or d			;ab46
	ret po			;ab47
	cp b			;ab48
	dec de			;ab49
	ld c,00ch		;ab4a
	ld b,00dh		;ab4c
	rra			;ab4e
	rra			;ab4f
	dec e			;ab50
	jr $+31			;ab51
	ld c,003h		;ab53
	inc bc			;ab55
	ld (bc),a		;ab56
	ld bc,00004h		;ab57
	adc a,h			;ab5a
	ret po			;ab5b
	ld (hl),b		;ab5c
	ld a,b			;ab5d
	ret m			;ab5e
	cp b			;ab5f
	jr $-70			;ab60
	ret p			;ab62
	ret nz			;ab63
	ret nz			;ab64
	ld b,b			;ab65
	add a,b			;ab66
	inc b			;ab67
	nop			;ab68
	nop			;ab69
	and (hl)		;ab6a
	nop			;ab6b
	ld bc,00f23h		;ab6c
	inc b			;ab6f
	dec e			;ab70
	dec c			;ab71
	cp h			;ab72
	ld a,a			;ab73
	cp a			;ab74
	ld l,(hl)		;ab75
	ld l,a			;ab76
	ld (hl),079h		;ab77
	ccf			;ab79
	ld b,0e0h		;ab7a
	ret p			;ab7c
	ret m			;ab7d
	call m,00a72h		;ab7e
	ret c			;ab81
	ret c			;ab82
	inc b			;ab83
	ei			;ab84
	ld a,a			;ab85
	cp d			;ab86
	ld a,b			;ab87
	ret p			;ab88
	ret nz			;ab89
	nop			;ab8a
	rlca			;ab8b
	rra			;ab8c
	ccf			;ab8d
	ccf			;ab8e
	rra			;ab8f
	rlca			;ab90
	ld a,(bc)		;ab91
	nop			;ab92
	add a,(hl)		;ab93
	ret po			;ab94
	ret m			;ab95
	call m,0f8fch		;ab96
	ret po			;ab99
	ld a,(bc)		;ab9a
	nop			;ab9b
	nop			;ab9c
	add a,h			;ab9d
	nop			;ab9e
	rlca			;ab9f
	ex af,af'		;aba0
	rlca			;aba1
	inc bc			;aba2
	dec c			;aba3
	add a,(hl)		;aba4
	scf			;aba5
	ld a,b			;aba6
	ld (hl),a		;aba7
	ld c,a			;aba8
	nop			;aba9
	rrca			;abaa
	inc b			;abab
	nop			;abac
	add a,e			;abad
	ret po			;abae
	djnz $-30		;abaf
	inc bc			;abb1
	ld d,b			;abb2
	sub c			;abb3
	call pe,0ec1ch		;abb4
	ret p			;abb7
	nop			;abb8
	ret p			;abb9
	ret p			;abba
	ld h,b			;abbb
	nop			;abbc
	ld b,a			;abbd
	ret z			;abbe
	rst 30h			;abbf
	ret m			;abc0
	ld (hl),d		;abc1
	ld (de),a		;abc2
	ld (00448h),a		;abc3
	rst 38h			;abc6
	adc a,e			;abc7
	jr nc,$+129		;abc8
	ld a,a			;abca
	ccf			;abcb
	jp po,0ef13h		;abcc
	rra			;abcf
	xor (hl)		;abd0
	xor b			;abd1
	xor h			;abd2
	inc b			;abd3
	cp 085h			;abd4
	call m,00e0ch		;abd6
	sbc a,(hl)		;abd9
	call m,08e00h		;abda
	nop			;abdd
	inc b			;abde
	add hl,bc		;abdf
	ld c,a			;abe0
	ld h,a			;abe1
	ccf			;abe2
	ccf			;abe3
	rra			;abe4
	ld e,a			;abe5
	ld l,a			;abe6
	ccf			;abe7
	rra			;abe8
	inc bc			;abe9
	ld c,003h		;abea
	nop			;abec
	adc a,(hl)		;abed
	ex de,hl		;abee
	ret nz			;abef
	ret m			;abf0
	call m,0fafeh		;abf1
	defb 0fdh,0fdh,0feh ;illegal sequence	;abf4
	cp 0f2h			;abf7
	call p,0c020h		;abf9
	inc bc			;abfc
	nop			;abfd
	adc a,d			;abfe
	inc b			;abff
	add hl,bc		;ac00
	cpl			;ac01
	daa			;ac02
	scf			;ac03
	dec de			;ac04
	rra			;ac05
	daa			;ac06
	rra			;ac07
	ld c,006h		;ac08
	nop			;ac0a
	adc a,e			;ac0b
	ret po			;ac0c
	sub b			;ac0d
	ret nz			;ac0e
	ret m			;ac0f
	call m,0f0f4h		;ac10
	call nc,060d0h		;ac13
	ret nz			;ac16
	inc bc			;ac17
	nop			;ac18
	add a,(hl)		;ac19
	rlca			;ac1a
	rra			;ac1b
	ccf			;ac1c
	ccf			;ac1d
	rra			;ac1e
	rlca			;ac1f
	ld a,(bc)		;ac20
	nop			;ac21
	add a,(hl)		;ac22
	ret po			;ac23
	ret m			;ac24
	call m,0f8fch		;ac25
	ret po			;ac28
	ld a,(bc)		;ac29
	nop			;ac2a
	nop			;ac2b
	adc a,(hl)		;ac2c
	nop			;ac2d
	ld (bc),a		;ac2e
	ld bc,00709h		;ac2f
	ld (bc),a		;ac32
	cpl			;ac33
	rra			;ac34
	rlca			;ac35
	dec bc			;ac36
	dec d			;ac37
	ld (bc),a		;ac38
	inc b			;ac39
	ex af,af'		;ac3a
	inc bc			;ac3b
	nop			;ac3c
	sub l			;ac3d
	jr nz,$+6		;ac3e
	ret c			;ac40
	jr nc,$-38		;ac41
	xor 0f8h		;ac43
	ret c			;ac45
	cp b			;ac46
	call p,0a066h		;ac47
	djnz $+2		;ac4a
	nop			;ac4c
	rlca			;ac4d
	rra			;ac4e
	ccf			;ac4f
	ccf			;ac50
	rra			;ac51
	rlca			;ac52
	ld a,(bc)		;ac53
	nop			;ac54
	add a,(hl)		;ac55
	ret po			;ac56
	ret m			;ac57
	call m,0f8fch		;ac58
	ret po			;ac5b
	ld a,(bc)		;ac5c
	nop			;ac5d
	nop			;ac5e
	ld (bc),a		;ac5f
	nop			;ac60
	add a,h			;ac61
	rlca			;ac62
	rra			;ac63
	add hl,sp		;ac64
	ccf			;ac65
	inc bc			;ac66
	ld l,a			;ac67
	add a,h			;ac68
	scf			;ac69
	ccf			;ac6a
	rra			;ac6b
	rlca			;ac6c
	dec b			;ac6d
	nop			;ac6e
	add a,h			;ac6f
	ret po			;ac70
	ret m			;ac71
	call m,003fch		;ac72
	cp 002h			;ac75
	call m,0f882h		;ac77
	ret po			;ac7a
	inc b			;ac7b
	nop			;ac7c
	add a,l			;ac7d
	ld bc,00d07h		;ac7e
	rrca			;ac81
	dec de			;ac82
	inc bc			;ac83
	rla			;ac84
	ld (bc),a		;ac85
	rra			;ac86
	ld (bc),a		;ac87
	rrca			;ac88
	adc a,b			;ac89
	rlca			;ac8a
	ld bc,00000h		;ac8b
	ret nz			;ac8e
	ret p			;ac8f
	ret m			;ac90
	ret m			;ac91
	ld b,0fch		;ac92
	ld (bc),a		;ac94
	ret m			;ac95
	add a,e			;ac96
	ret p			;ac97
	ret nz			;ac98
	nop			;ac99
	ex af,af'		;ac9a
	rst 38h			;ac9b
	jr $+2			;ac9c
	nop			;ac9e
	adc a,l			;ac9f
	nop			;aca0
	rlca			;aca1
	rrca			;aca2
	dec bc			;aca3
	inc l			;aca4
	ld l,a			;aca5
	ld (hl),e		;aca6
	ld a,d			;aca7
	ld l,e			;aca8
	ld l,h			;aca9
	ld h,a			;acaa
	ld (hl),b		;acab
	ld (hl),004h		;acac
	nop			;acae
	sub h			;acaf
	ret po			;acb0
	ret nc			;acb1
	ret nc			;acb2
	or h			;acb3
	or 036h			;acb4
	sub 0eah		;acb6
	ld (de),a		;acb8
	and 014h		;acb9
	ld (hl),b		;acbb
	ld h,b			;acbc
	ld (hl),b		;acbd
	inc e			;acbe
	rlca			;acbf
	ex af,af'		;acc0
	djnz $+54		;acc1
	ld d,e			;acc3
	rlca			;acc4
	rst 38h			;acc5
	adc a,c			;acc6
	ld c,c			;acc7
	ld a,a			;acc8
	ccf			;acc9
	rrca			;acca
	ret po			;accb
	djnz $+42		;accc
	inc l			;acce
	ld c,d			;accf
	ld b,0ffh		;acd0
	add a,l			;acd2
	jp pe,09e8eh		;acd3
	adc a,h			;acd6
	ret po			;acd7
	inc bc			;acd8
	nop			;acd9
	adc a,l			;acda
	inc bc			;acdb
	ld (bc),a		;acdc
	ld b,017h		;acdd
	dec de			;acdf
	dec a			;ace0
	dec l			;ace1
	ld h,037h		;ace2
	inc de			;ace4
	ld b,003h		;ace5
	ld c,003h		;ace7
	nop			;ace9
	adc a,h			;acea
	ret p			;aceb
	ret pe			;acec
	ret pe			;aced
	ld e,b			;acee
	call p,0dadah		;acef
	ld (hl),d		;acf2
	add a,(hl)		;acf3
	call p,01820h		;acf4
	inc bc			;acf7
	nop			;acf8
	add a,(hl)		;acf9
	inc bc			;acfa
	inc b			;acfb
	dec b			;acfc
	add hl,de		;acfd
	jr z,$+38		;acfe
	inc b			;ad00
	rst 38h			;ad01
	adc a,h			;ad02
	inc l			;ad03
	add hl,sp		;ad04
	inc a			;ad05
	ld de,00000h		;ad06
	ret p			;ad09
	ex af,af'		;ad0a
	inc d			;ad0b
	inc d			;ad0c
	and h			;ad0d
	ld a,(bc)		;ad0e
	inc b			;ad0f
	rst 38h			;ad10
	add a,h			;ad11
	ld a,(bc)		;ad12
	call c,0f8e4h		;ad13
	nop			;ad16
	ld (bc),a		;ad17
	nop			;ad18
	adc a,h			;ad19
	inc bc			;ad1a
	rlca			;ad1b
	rrca			;ad1c
	rrca			;ad1d
	scf			;ad1e
	ccf			;ad1f
	ld (hl),a		;ad20
	ld l,a			;ad21
	ld l,a			;ad22
	scf			;ad23
	jr $+5			;ad24
	inc b			;ad26
	nop			;ad27
	and b			;ad28
	or b			;ad29
	ret nz			;ad2a
	ret nc			;ad2b
	jr $-34			;ad2c
	call pe,0d8ech		;ad2e
	ret p			;ad31
	ret pe			;ad32
	ret m			;ad33
	ret p			;ad34
	ret nz			;ad35
	nop			;ad36
	nop			;ad37
	inc c			;ad38
	ld a,03fh		;ad39
	ld a,b			;ad3b
	ld (hl),a		;ad3c
	scf			;ad3d
	scf			;ad3e
	dec de			;ad3f
	ld h,a			;ad40
	ld a,a			;ad41
	ld a,a			;ad42
	ld a,l			;ad43
	dec sp			;ad44
	ld bc,00000h		;ad45
	ld (hl),b		;ad48
	inc bc			;ad49
	ret m			;ad4a
	sub c			;ad4b
	call m,0faf6h		;ad4c
	jp m,0ecf4h		;ad4f
	call m,0f0f0h		;ad52
	ret po			;ad55
	nop			;ad56
	rlca			;ad57
	rra			;ad58
	ccf			;ad59
	ccf			;ad5a
	rra			;ad5b
	rlca			;ad5c
	ld a,(bc)		;ad5d
	nop			;ad5e
	add a,(hl)		;ad5f
	ret po			;ad60
	ret m			;ad61
	call m,0f8fch		;ad62
	ret po			;ad65
	ld a,(bc)		;ad66
	nop			;ad67
	nop			;ad68
	nop			;ad69
	dec de			;ad6a
	and b			;ad6b
	inc bc			;ad6c
	rlca			;ad6d
	rrca			;ad6e
	rra			;ad6f
	ld sp,06321h		;ad70
	rst 38h			;ad73
	defb 0fdh,07fh,01fh ;illegal sequence	;ad74
	rrca			;ad77
	dec c			;ad78
	ld (bc),a		;ad79
	rlca			;ad7a
	inc bc			;ad7b
	ret nz			;ad7c
	ret po			;ad7d
	ret p			;ad7e
	ret m			;ad7f
	adc a,h			;ad80
	add a,h			;ad81
	add a,0ffh		;ad82
	ld a,a			;ad84
	cp 0f8h			;ad85
	ret p			;ad87
	ld d,b			;ad88
	and b			;ad89
	ret po			;ad8a
	ret nz			;ad8b
	ld b,000h		;ad8c
	adc a,d			;ad8e
	ld bc,00703h		;ad8f
	rrca			;ad92
	rra			;ad93
	ld a,07eh		;ad94
	ld a,(hl)		;ad96
	call m,006f8h		;ad97
	nop			;ad9a
	adc a,d			;ad9b
	ld b,b			;ad9c
	ld h,b			;ad9d
	ld (hl),b		;ad9e
	ld a,b			;ad9f
	ld a,h			;ada0
	cp 0ffh			;ada1
	rst 38h			;ada3
	ld a,a			;ada4
	rra			;ada5
	inc b			;ada6
	nop			;ada7
	sub d			;ada8
	ld (bc),a		;ada9
	ld b,007h		;adaa
	rrca			;adac
	rrca			;adad
	rra			;adae
	ccf			;adaf
	ld a,a			;adb0
	rst 38h			;adb1
	rst 30h			;adb2
	rst 28h			;adb3
	ld e,a			;adb4
	ld a,03ch		;adb5
	jr c,$+50		;adb7
	jr nc,$+98		;adb9
	inc bc			;adbb
	ld b,b			;adbc
	adc a,(hl)		;adbd
	jr nz,$-126		;adbe
	ret nz			;adc0
	ret po			;adc1
	ret p			;adc2
	ret po			;adc3
	sbc a,(hl)		;adc4
	ret m			;adc5
	ld a,b			;adc6
	ld a,(01d1bh)		;adc7
	dec c			;adca
	dec b			;adcb
	inc bc			;adcc
	rlca			;adcd
	add a,(hl)		;adce
	rrca			;adcf
	rra			;add0
	rra			;add1
	ccf			;add2
	ccf			;add3
	rrca			;add4
	inc b			;add5
	nop			;add6
	add a,d			;add7
	add a,b			;add8
	ret nz			;add9
	inc bc			;adda
	ret po			;addb
	sbc a,e			;addc
	ret p			;addd
	ret m			;adde
	call m,0bebch		;addf
	sbc a,0deh		;ade2
	ccf			;ade4
	ld a,(hl)		;ade5
	ld sp,hl		;ade6
	rst 38h			;ade7
	rst 38h			;ade8
	ld a,a			;ade9
	ccf			;adea
	ccf			;adeb
	rra			;adec
	rrca			;aded
	dec b			;adee
	ex af,af'		;adef
	nop			;adf0
	nop			;adf1
	ld bc,07f00h		;adf2
	cp 0fdh			;adf5
	ei			;adf7
	inc bc			;adf8
	rst 30h			;adf9
	ld (bc),a		;adfa
	rst 28h			;adfb
	inc b			;adfc
	rst 38h			;adfd
	add a,(hl)		;adfe
	cp a			;adff
	inc sp			;ae00
	ld h,a			;ae01
	ld bc,0eecdh		;ae02
	inc b			;ae05
	rst 28h			;ae06
	ld b,0cfh		;ae07
	ld (bc),a		;ae09
	add a,a			;ae0a
	sub e			;ae0b
	inc bc			;ae0c
	rst 20h			;ae0d
	ei			;ae0e
	rst 38h			;ae0f
	ld a,a			;ae10
	ld a,a			;ae11
	cp a			;ae12
	cp a			;ae13
	rst 18h			;ae14
	rst 38h			;ae15
	rst 38h			;ae16
	call m,0fafeh		;ae17
	pop af			;ae1a
	jr nc,$-102		;ae1b
	ret c			;ae1d
	ret po			;ae1e
	inc bc			;ae1f
	ret p			;ae20
	add a,e			;ae21
	ret po			;ae22
	ret nz			;ae23
	ret nz			;ae24
	inc bc			;ae25
	add a,b			;ae26
	add a,c			;ae27
	ld b,b			;ae28
	inc d			;ae29
	nop			;ae2a
	adc a,(hl)		;ae2b
	inc bc			;ae2c
	ld bc,00100h		;ae2d
	rlca			;ae30
	rrca			;ae31
	rra			;ae32
	ld a,039h		;ae33
	halt			;ae35
	ld l,b			;ae36
	ld d,b			;ae37
	jr nz,$+34		;ae38
	inc b			;ae3a
	nop			;ae3b
	add a,(hl)		;ae3c
	jr nc,$-14		;ae3d
	ret m			;ae3f
	ret m			;ae40
	ret nz			;ae41
	jr $+5			;ae42
	ld h,b			;ae44
	ld (bc),a		;ae45
	jr nc,$-123		;ae46
	jr c,$+2		;ae48
	jr $+5			;ae4a
	nop			;ae4c
	adc a,h			;ae4d
	ld b,03eh		;ae4e
	ld a,01eh		;ae50
	ld e,a			;ae52
	rst 18h			;ae53
	rrca			;ae54
	rla			;ae55
	rla			;ae56
	sub b			;ae57
	ld b,001h		;ae58
	dec b			;ae5a
	nop			;ae5b
	sbc a,e			;ae5c
	inc bc			;ae5d
	rra			;ae5e
	call m,00060h		;ae5f
	nop			;ae62
	add a,b			;ae63
	ret nz			;ae64
	ret p			;ae65
	nop			;ae66
	ret p			;ae67
	nop			;ae68
	jr nz,$+114		;ae69
	jr c,$+26		;ae6b
	inc e			;ae6d
	ld c,006h		;ae6e
	nop			;ae70
	inc bc			;ae71
	rra			;ae72
	rra			;ae73
	cpl			;ae74
	ld d,009h		;ae75
	ld b,004h		;ae77
	nop			;ae79
	ld (bc),a		;ae7a
	inc b			;ae7b
	adc a,d			;ae7c
	inc c			;ae7d
	inc a			;ae7e
	call m,0f4f8h		;ae7f
	ret pe			;ae82
	sub b			;ae83
	ld h,b			;ae84
	ld (hl),b		;ae85
	jr nc,$+5		;ae86
	nop			;ae88
	add a,h			;ae89
	rrca			;ae8a
	inc bc			;ae8b
	dec c			;ae8c
	ld (bc),a		;ae8d
	inc bc			;ae8e
	nop			;ae8f
	add a,h			;ae90
	inc bc			;ae91
	rra			;ae92
	call m,006e0h		;ae93
	nop			;ae96
	add a,(hl)		;ae97
	ret nz			;ae98
	ret po			;ae99
	ret po			;ae9a
	di			;ae9b
	rst 30h			;ae9c
	ld a,d			;ae9d
	inc bc			;ae9e
	ld a,b			;ae9f
	add a,h			;aea0
	ld h,b			;aea1
	jr $+98			;aea2
	nop			;aea4
	nop			;aea5
	nop			;aea6
	dec de			;aea7
	inc c			;aea8
	nop			;aea9
	add a,h			;aeaa
	ld a,063h		;aeab
	ex (sp),hl		;aead
	ld a,00eh		;aeae
	nop			;aeb0
	add a,c			;aeb1
	add a,b			;aeb2
	inc b			;aeb3
	nop			;aeb4
	xor l			;aeb5
	ld bc,00303h		;aeb6
	dec d			;aeb9
	dec bc			;aeba
	inc bc			;aebb
	rla			;aebc
	dec bc			;aebd
	rlca			;aebe
	ld c,02fh		;aebf
	ld l,e			;aec1
	jp 01202h		;aec2
	ld h,a			;aec5
	or a			;aec6
	rst 30h			;aec7
	jp m,0fffdh		;aec8
	rst 38h			;aecb
	ret p			;aecc
	rst 28h			;aecd
	ret nc			;aece
	ret po			;aecf
	ld bc,0c080h		;aed0
	nop			;aed3
	add a,b			;aed4
	ld (hl),b		;aed5
	inc a			;aed6
	ld a,(hl)		;aed7
	jp m,0fdfbh		;aed8
	cp 07fh			;aedb
	cp l			;aedd
	ld e,(hl)		;aede
	ld a,(00f07h)		;aedf
	rra			;aee2
	ld a,(bc)		;aee3
	nop			;aee4
	xor b			;aee5
	ld b,b			;aee6
	add a,b			;aee7
	nop			;aee8
	ld b,b			;aee9
	ld (hl),b		;aeea
	or b			;aeeb
	inc bc			;aeec
	ld (bc),a		;aeed
	rlca			;aeee
	rlca			;aeef
	rrca			;aef0
	rrca			;aef1
	rra			;aef2
	dec sp			;aef3
	ld a,e			;aef4
	rst 30h			;aef5
	rst 30h			;aef6
	rst 20h			;aef7
	ld c,a			;aef8
	cpl			;aef9
	rra			;aefa
	ccf			;aefb
	ld c,a			;aefc
	rst 28h			;aefd
	rst 28h			;aefe
	rst 30h			;aeff
	ex de,hl		;af00
	rst 8			;af01
	rst 8			;af02
	add a,a			;af03
	sub (hl)		;af04
	cp d			;af05
	sbc a,l			;af06
	sbc a,(hl)		;af07
	rst 18h			;af08
	in a,(0cbh)		;af09
	in h,(c)		;af0b
	push de			;af0d
	rlca			;af0e
	rst 38h			;af0f
	adc a,d			;af10
	ld l,a			;af11
	cpl			;af12
	scf			;af13
	sub l			;af14
	and l			;af15
	set 6,d			;af16
	rst 18h			;af18
	ld a,l			;af19
	defb 0fdh,003h,0feh ;illegal sequence	;af1a
	sbc a,d			;af1d
	jp m,0dbf9h		;af1e
	rst 10h			;af21
	or a			;af22
	xor a			;af23
	xor a			;af24
	ld e,a			;af25
	ld a,a			;af26
	rst 38h			;af27
	ld (hl),b		;af28
	ld (hl),b		;af29
	ld a,b			;af2a
	ld a,b			;af2b
	call m,0fffeh		;af2c
	rst 30h			;af2f
	rst 30h			;af30
	ei			;af31
	ei			;af32
	ld sp,hl		;af33
	defb 0edh ;next byte illegal after ed	;af34
	call pe,0f7eeh		;af35
	ex af,af'		;af38
	nop			;af39
	ld b,080h		;af3a
	ld (bc),a		;af3c
	nop			;af3d
	inc bc			;af3e
	rst 38h			;af3f
	add a,l			;af40
	ld a,a			;af41
	ccf			;af42
	ccf			;af43
	rrca			;af44
	inc bc			;af45
	ex af,af'		;af46
	nop			;af47
	adc a,d			;af48
	or a			;af49
	in a,(0dch)		;af4a
	rst 18h			;af4c
	rst 28h			;af4d
	di			;af4e
	call m,00fffh		;af4f
	inc bc			;af52
	ld b,000h		;af53
	add a,l			;af55
	rst 20h			;af56
	rst 38h			;af57
	rst 38h			;af58
	ld a,0c1h		;af59
	dec b			;af5b
	rst 38h			;af5c
	add a,c			;af5d
	ld a,(hl)		;af5e
	dec b			;af5f
	nop			;af60
	rlca			;af61
	rst 38h			;af62
	add a,e			;af63
	cp 0e0h			;af64
	add a,b			;af66
	ld b,000h		;af67
	ld (bc),a		;af69
	call c,0ec85h		;af6a
	ret pe			;af6d
	ret po			;af6e
	ret po			;af6f
	add a,b			;af70
	add hl,de		;af71
	nop			;af72
	adc a,c			;af73
	ld c,c			;af74
	ld a,03fh		;af75
	ld a,a			;af77
	cp a			;af78
	ld a,a			;af79
	ld a,04dh		;af7a
	djnz $+11		;af7c
	nop			;af7e
	add a,l			;af7f
	add a,b			;af80
	nop			;af81
	add a,b			;af82
	nop			;af83
	add a,b			;af84
	add hl,bc		;af85
	nop			;af86
	ret nz			;af87
	ld bc,00802h		;af88
	inc c			;af8b
	inc b			;af8c
	ld hl,0090ch		;af8d
	ld sp,0d88ch		;af90
	defb 0fdh,07dh ;ld a,iyl	;af93
	ld a,a			;af95
	ccf			;af96
	rrca			;af97
	nop			;af98
	djnz $-94		;af99
	jr nz,$+54		;af9b
	sub b			;af9d
	ret nz			;af9e
	sbc a,h			;af9f
	ld b,h			;afa0
	ld d,(hl)		;afa1
	in a,(0ffh)		;afa2
	xor 0feh		;afa4
	call m,000f0h		;afa6
	nop			;afa9
	inc b			;afaa
	nop			;afab
	nop			;afac
	add hl,bc		;afad
	inc bc			;afae
	add hl,de		;afaf
	ld (de),a		;afb0
	ld hl,(07f5bh)		;afb1
	ld (hl),a		;afb4
	ld a,a			;afb5
	ccf			;afb6
	rrca			;afb7
	add a,b			;afb8
	nop			;afb9
	jr nz,$+66		;afba
	ld b,b			;afbc
	inc b			;afbd
	jr nz,$+2		;afbe
	add a,b			;afc0
	jr nc,$+28		;afc1
	cp (hl)			;afc3
	cp (hl)			;afc4
	cp 0fch			;afc5
	ret p			;afc7
	dec b			;afc8
	nop			;afc9
	adc a,(hl)		;afca
	ld (bc),a		;afcb
	nop			;afcc
	ld bc,00001h		;afcd
	ex af,af'		;afd0
	ld sp,01225h		;afd1
	dec de			;afd4
	rlca			;afd5
	nop			;afd6
	nop			;afd7
	add a,b			;afd8
	inc bc			;afd9
	nop			;afda
	sbc a,b			;afdb
	ld b,b			;afdc
	nop			;afdd
	ld b,b			;afde
	ld d,b			;afdf
	sub b			;afe0
	adc a,h			;afe1
	call nc,068e8h		;afe2
	ret po			;afe5
	nop			;afe6
	nop			;afe7
	ld bc,01d19h		;afe8
	dec bc			;afeb
	rlca			;afec
	ccf			;afed
	ccf			;afee
	ld a,03dh		;afef
	dec de			;aff1
	ld a,(bc)		;aff2
	ld (bc),a		;aff3
	inc b			;aff4
	nop			;aff5
	adc a,h			;aff6
	ret po			;aff7
	ret p			;aff8
	ret m			;aff9
	ret po			;affa
	call c,040b0h		;affb
	ret po			;affe
	ld (hl),b		;afff
	jr c,$+22		;b000
	inc c			;b002
	inc bc			;b003
	nop			;b004
	add a,d			;b005
	rlca			;b006
	rra			;b007
	inc bc			;b008
	ccf			;b009
	add a,(hl)		;b00a
	rlca			;b00b
	add hl,sp		;b00c
	ld b,00eh		;b00d
	dec d			;b00f
	jr $+7			;b010
	nop			;b012
	add a,(hl)		;b013
	ex af,af'		;b014
	inc e			;b015
	cp b			;b016
	or b			;b017
	ret nz			;b018
	ret p			;b019
	inc bc			;b01a
	call m,07a84h		;b01b
	ld (hl),h		;b01e
	ex af,af'		;b01f
	ld (hl),b		;b020
	inc bc			;b021
	nop			;b022
	add a,(hl)		;b023
	djnz $+58		;b024
	dec e			;b026
	dec c			;b027
	inc bc			;b028
	rrca			;b029
	inc bc			;b02a
	ccf			;b02b
	add a,h			;b02c
	ld e,(hl)		;b02d
	ld l,010h		;b02e
	ld c,003h		;b030
	nop			;b032
	add a,d			;b033
	ret po			;b034
	ret m			;b035
	inc bc			;b036
	call m,0e086h		;b037
	sbc a,h			;b03a
	ld h,b			;b03b
	ld (hl),b		;b03c
	xor b			;b03d
	jr $+8			;b03e
	nop			;b040
	adc a,h			;b041
	rlca			;b042
	rrca			;b043
	rra			;b044
	rlca			;b045
	dec sp			;b046
	dec c			;b047
	ld (bc),a		;b048
	rlca			;b049
	ld c,01ch		;b04a
	jr z,$+50		;b04c
	inc b			;b04e
	nop			;b04f
	adc a,(hl)		;b050
	add a,b			;b051
	sbc a,b			;b052
	cp b			;b053
	ret nc			;b054
	ret po			;b055
	call m,07cfch		;b056
	cp h			;b059
	ret c			;b05a
	ld d,b			;b05b
	ld b,b			;b05c
	nop			;b05d
	nop			;b05e
	nop			;b05f
	ld b,b			;b060
	inc e			;b061
	add a,e			;b062
	add a,c			;b063
	ld b,d			;b064
	inc h			;b065
	dec e			;b066
	nop			;b067
	adc a,e			;b068
	sub b			;b069
	adc a,b			;b06a
	add a,h			;b06b
	ld b,b			;b06c
	jr nc,$+18		;b06d
	ex af,af'		;b06f
	inc c			;b070
	rrca			;b071
	rlca			;b072
	inc bc			;b073
	dec b			;b074
	nop			;b075
	adc a,d			;b076
	inc h			;b077
	ld b,h			;b078
	add a,h			;b079
	ex af,af'		;b07a
	jr nc,$+34		;b07b
	ld b,b			;b07d
	ret nz			;b07e
	ret nz			;b07f
	add a,b			;b080
	add hl,bc		;b081
	nop			;b082
	adc a,l			;b083
	jr $+46			;b084
	dec c			;b086
	rrca			;b087
	rra			;b088
	ccf			;b089
	scf			;b08a
	dec sp			;b08b
	dec a			;b08c
	rra			;b08d
	rlca			;b08e
	rla			;b08f
	dec de			;b090
	inc bc			;b091
	nop			;b092
	sbc a,a			;b093
	jr $+54			;b094
	or b			;b096
	ret p			;b097
	ret m			;b098
	call m,0dcech		;b099
	cp h			;b09c
	ret m			;b09d
	ret po			;b09e
	ret pe			;b09f
	ret c			;b0a0
	nop			;b0a1
	nop			;b0a2
	inc bc			;b0a3
	rrca			;b0a4
	rra			;b0a5
	ccf			;b0a6
	ccf			;b0a7
	ld a,a			;b0a8
	ld a,a			;b0a9
	rst 38h			;b0aa
	or 0e2h			;b0ab
	ret nz			;b0ad
	add a,b			;b0ae
	add a,d			;b0af
	inc bc			;b0b0
	rrca			;b0b1
	ld a,(hl)		;b0b2
	inc bc			;b0b3
	call m,0fe88h		;b0b4
	rst 38h			;b0b7
	cp 0f0h			;b0b8
	inc h			;b0ba
	inc e			;b0bb
	inc a			;b0bc
	ld a,(hl)		;b0bd
	inc bc			;b0be
	rst 38h			;b0bf
	adc a,d			;b0c0
	ld a,03ch		;b0c1
	inc a			;b0c3
	inc e			;b0c4
	dec de			;b0c5
	ld e,00eh		;b0c6
	inc c			;b0c8
	inc c			;b0c9
	ld b,006h		;b0ca
	nop			;b0cc
	sub b			;b0cd
	ld sp,hl		;b0ce
	ret m			;b0cf
	ld a,h			;b0d0
	ld a,07fh		;b0d1
	rst 38h			;b0d3
	rst 38h			;b0d4
	call m,078f8h		;b0d5
	inc a			;b0d8
	inc e			;b0d9
	ld c,01eh		;b0da
	jr nc,$+34		;b0dc
	rlca			;b0de
	nop			;b0df
	adc a,c			;b0e0
	ld bc,00f07h		;b0e1
	rra			;b0e4
	rra			;b0e5
	inc a			;b0e6
	jr nc,$+100		;b0e7
	add a,e			;b0e9
	ld b,000h		;b0ea
	add a,a			;b0ec
	ccf			;b0ed
	call m,0e4f8h		;b0ee
	call c,07e3ch		;b0f1
	inc bc			;b0f4
	rst 38h			;b0f5
	ld b,000h		;b0f6
	add a,h			;b0f8
	inc bc			;b0f9
	rlca			;b0fa
	rrca			;b0fb
	rrca			;b0fc
	dec b			;b0fd
	rra			;b0fe
	adc a,d			;b0ff
	rrca			;b100
	jr $+46			;b101
	dec c			;b103
	rrca			;b104
	rra			;b105
	ccf			;b106
	or a			;b107
	ei			;b108
	defb 0fdh,007h,0ffh ;illegal sequence	;b109
	inc bc			;b10c
	rrca			;b10d
	ld (bc),a		;b10e
	rlca			;b10f
	ld (bc),a		;b110
	inc bc			;b111
	add a,c			;b112
	ld bc,00008h		;b113
	inc b			;b116
	rst 38h			;b117
	add a,d			;b118
	cp 0fch			;b119
	inc bc			;b11b
	ret m			;b11c
	add a,e			;b11d
	ld a,h			;b11e
	inc e			;b11f
	ld b,004h		;b120
	nop			;b122
	nop			;b123
	jr nz,$+30		;b124
	rlca			;b126
	nop			;b127
	adc a,b			;b128
	rlca			;b129
	rra			;b12a
	jr c,$+114		;b12b
	ld (hl),b		;b12d
	inc (hl)		;b12e
	jr $+9			;b12f
	ex af,af'		;b131
	nop			;b132
	adc a,b			;b133
	ret po			;b134
	ret m			;b135
	ld a,h			;b136
	ld a,03eh		;b137
	inc a			;b139
	ld a,b			;b13a
	ret po			;b13b
	ex af,af'		;b13c
	nop			;b13d
	adc a,b			;b13e
	rlca			;b13f
	rra			;b140
	ld a,07ch		;b141
	ld a,h			;b143
	inc a			;b144
	ld e,007h		;b145
	ex af,af'		;b147
	nop			;b148
	adc a,b			;b149
	ret po			;b14a
	ret m			;b14b
	inc e			;b14c
	ld c,00eh		;b14d
	inc l			;b14f
	jr $-30			;b150
	inc c			;b152
	nop			;b153
	add a,h			;b154
	djnz $+54		;b155
	jr $+9			;b157
	inc c			;b159
	nop			;b15a
	add a,h			;b15b
	jr nc,$+62		;b15c
	ld a,b			;b15e
	ret po			;b15f
	daa			;b160
	nop			;b161
	adc a,d			;b162
	rlca			;b163
	rra			;b164
	dec a			;b165
	halt			;b166
	ld a,b			;b167
	ld (hl),h		;b168
	ld a,b			;b169
	dec (hl)		;b16a
	ld e,007h		;b16b
	ld b,000h		;b16d
	adc a,d			;b16f
	ret po			;b170
	ret m			;b171
	cp h			;b172
	ld e,(hl)		;b173
	ld a,00eh		;b174
	ld e,(hl)		;b176
	inc l			;b177
	ret m			;b178
	ret po			;b179
	nop			;b17a
	rlca			;b17b
	inc bc			;b17c
	add a,d			;b17d
	ld bc,00d7fh		;b17e
	ccf			;b181
	ld (bc),a		;b182
	nop			;b183
	sub b			;b184
	rlca			;b185
	ccf			;b186
	ccf			;b187
	rst 38h			;b188
	ccf			;b189
	rst 38h			;b18a
	nop			;b18b
	nop			;b18c
	ccf			;b18d
	ld a,03eh		;b18e
	ccf			;b190
	ld a,03fh		;b191
	nop			;b193
	nop			;b194
	inc bc			;b195
	rst 38h			;b196
	add a,d			;b197
	rlca			;b198
	inc bc			;b199
	inc bc			;b19a
	ex (sp),hl		;b19b
	add a,l			;b19c
	ld a,a			;b19d
	ccf			;b19e
	ccf			;b19f
	jr c,$+50		;b1a0
	inc bc			;b1a2
	ld sp,0ff02h		;b1a3
	add a,e			;b1a6
	inc bc			;b1a7
	add a,e			;b1a8
	out (003h),a		;b1a9
	xor e			;b1ab
	adc a,l			;b1ac
	ld d,e			;b1ad
	out (023h),a		;b1ae
	di			;b1b0
	inc de			;b1b1
	inc bc			;b1b2
	inc bc			;b1b3
	ld bc,03f7fh		;b1b4
	ret nz			;b1b7
	pop bc			;b1b8
	jp z,0d503h		;b1b9
	add a,(hl)		;b1bc
	jp z,0c7c8h		;b1bd
	ret z			;b1c0
	rst 8			;b1c1
	ret nz			;b1c2
	inc b			;b1c3
	rst 38h			;b1c4
	sbc a,h			;b1c5
	inc bc			;b1c6
	sub e			;b1c7
	di			;b1c8
	inc hl			;b1c9
	di			;b1ca
	inc de			;b1cb
	inc hl			;b1cc
	di			;b1cd
	dec bc			;b1ce
	di			;b1cf
	dec bc			;b1d0
	inc bc			;b1d1
	inc bc			;b1d2
	ld bc,03f7fh		;b1d3
	ret nz			;b1d6
	ret			;b1d7
	ret z			;b1d8
	rst 0			;b1d9
	ret z			;b1da
	rst 8			;b1db
	call nz,0cfc4h		;b1dc
	ret nc			;b1df
	rst 8			;b1e0
	ret nz			;b1e1
	inc b			;b1e2
	rst 38h			;b1e3
	add a,e			;b1e4
	inc bc			;b1e5
	jp 00323h		;b1e6
	inc de			;b1e9
	ld (bc),a		;b1ea
	inc hl			;b1eb
	sub h			;b1ec
	inc de			;b1ed
	ex (sp),hl		;b1ee
	inc de			;b1ef
	inc bc			;b1f0
	inc bc			;b1f1
	ld bc,03f7fh		;b1f2
	ret nz			;b1f5
	add a,0c8h		;b1f6
	call nz,0d1c8h		;b1f8
	sub 0cch		;b1fb
	rst 0			;b1fd
	ret z			;b1fe
	rst 8			;b1ff
	ret nz			;b200
	inc b			;b201
	rst 38h			;b202
	sbc a,h			;b203
	inc bc			;b204
	sbc a,e			;b205
	adc a,e			;b206
	inc bc			;b207
	sbc a,e			;b208
	xor e			;b209
	ld c,e			;b20a
	di			;b20b
	dec bc			;b20c
	di			;b20d
	dec bc			;b20e
	inc bc			;b20f
	inc bc			;b210
	ld bc,03f7fh		;b211
	ret nz			;b214
	ret nc			;b215
	exx			;b216
	ret nz			;b217
	exx			;b218
	push de			;b219
	jp nc,0cfd0h		;b21a
	ret nc			;b21d
	rst 18h			;b21e
	ret nz			;b21f
	inc b			;b220
	rst 38h			;b221
	ld b,003h		;b222
	or c			;b224
	add a,b			;b225
	push bc			;b226
	nop			;b227
	nop			;b228
	pop af			;b229
	ret nz			;b22a
	rst 38h			;b22b
	ld a,a			;b22c
	nop			;b22d
	add a,b			;b22e
	nop			;b22f
	nop			;b230
	ret c			;b231
	nop			;b232
	rst 38h			;b233
	rst 38h			;b234
	nop			;b235
	ld bc,00000h		;b236
	ld c,000h		;b239
	rst 38h			;b23b
	rst 38h			;b23c
	rlca			;b23d
	ld l,a			;b23e
	inc bc			;b23f
	inc bc			;b240
	ld e,a			;b241
	rlca			;b242
	rst 38h			;b243
	cp 048h			;b244
	and d			;b246
	nop			;b247
	jr nz,$+3		;b248
	nop			;b24a
	nop			;b24b
	add a,b			;b24c
	djnz $+70		;b24d
	ld bc,00008h		;b24f
	nop			;b252
	ex af,af'		;b253
	nop			;b254
	rst 38h			;b255
	inc b			;b256
	djnz $-125		;b257
	rst 38h			;b259
	inc b			;b25a
	ld bc,0ff81h		;b25b
	inc b			;b25e
	djnz $+25		;b25f
	rst 38h			;b261
	ld (bc),a		;b262
	ret po			;b263
	add a,a			;b264
	rra			;b265
	rst 38h			;b266
	rrca			;b267
	rrca			;b268
	rst 38h			;b269
	rlca			;b26a
	rlca			;b26b
	dec bc			;b26c
	rst 38h			;b26d
	adc a,(hl)		;b26e
	inc bc			;b26f
	rst 38h			;b270
	rst 38h			;b271
	inc bc			;b272
	rst 38h			;b273
	inc bc			;b274
	ccf			;b275
	nop			;b276
	ccf			;b277
	nop			;b278
	nop			;b279
	ccf			;b27a
	nop			;b27b
	nop			;b27c
	rlca			;b27d
	inc bc			;b27e
	add a,d			;b27f
	ld bc,0077fh		;b280
	ccf			;b283
	nop			;b284
	ld b,0feh		;b285
	inc b			;b287
	pop af			;b288
	ld e,0e1h		;b289
	ld (bc),a		;b28b
	rst 38h			;b28c
	ld b,0e1h		;b28d
	ld (bc),a		;b28f
	pop af			;b290
	ld b,0e1h		;b291
	ld c,0fah		;b293
	inc b			;b295
	pop af			;b296
	ld c,01ah		;b297
	ld c,0f7h		;b299
	inc b			;b29b
	pop af			;b29c
	ld c,017h		;b29d
	ld c,0f5h		;b29f
	inc b			;b2a1
	pop af			;b2a2
	ld c,015h		;b2a3
	ld c,0f6h		;b2a5
	inc b			;b2a7
	pop af			;b2a8
	ld c,016h		;b2a9
	ex af,af'		;b2ab
	cp 007h			;b2ac
	ld a,(de)		;b2ae
	add a,c			;b2af
	inc d			;b2b0
	rla			;b2b1
	ld a,(de)		;b2b2
	add a,c			;b2b3
	inc d			;b2b4
	djnz $+86		;b2b5
	inc b			;b2b7
	ld d,081h		;b2b8
	jr $+6			;b2ba
	ld d,081h		;b2bc
	jr $+6			;b2be
	ld d,002h		;b2c0
	jr $-94			;b2c2
	adc a,b			;b2c4
	ld de,06688h		;b2c5
	ld h,(hl)		;b2c8
	ld de,06688h		;b2c9
	ld h,(hl)		;b2cc
	ld de,06688h		;b2cd
	ld de,06688h		;b2d0
	ld de,01188h		;b2d3
	adc a,b			;b2d6
	ld h,(hl)		;b2d7
	ld h,(hl)		;b2d8
	ld de,06181h		;b2d9
	ld d,016h		;b2dc
	jr $+24			;b2de
	ld d,018h		;b2e0
	ld d,016h		;b2e2
	ex af,af'		;b2e4
	ld b,h			;b2e5
	ex af,af'		;b2e6
	cp 008h			;b2e7
	pop hl			;b2e9
	add a,(hl)		;b2ea
	cp 0f1h			;b2eb
	cp 0f1h			;b2ed
	pop af			;b2ef
	cp 004h			;b2f0
	pop af			;b2f2
	add a,(hl)		;b2f3
	pop hl			;b2f4
	pop af			;b2f5
	pop af			;b2f6
	pop hl			;b2f7
	pop af			;b2f8
	pop hl			;b2f9
	nop			;b2fa
	adc a,(hl)		;b2fb
	nop			;b2fc
	ld l,b			;b2fd
	ld b,l			;b2fe
	ld h,d			;b2ff
	ld b,l			;b300
	ld l,b			;b301
	nop			;b302
	nop			;b303
	nop			;b304
	xor (hl)		;b305
	inc h			;b306
	inc h			;b307
	inc h			;b308
	and h			;b309
	inc b			;b30a
	nop			;b30b
	add a,(hl)		;b30c
	jr $+2			;b30d
	nop			;b30f
	jr $+2			;b310
	nop			;b312
	nop			;b313
	jr $-13			;b314
	nop			;b316
	ld (bc),a		;b317
	ld a,a			;b318
	dec b			;b319
	rst 38h			;b31a
	add a,c			;b31b
	ld a,a			;b31c
	ex af,af'		;b31d
	jp c,0ff99h		;b31e
	ld a,a			;b321
	rra			;b322
	rlca			;b323
	add hl,bc		;b324
	ld b,001h		;b325
	nop			;b327
	jp m,0f6fah		;b328
	or 0cdh			;b32b
	add hl,sp		;b32d
	di			;b32e
	inc bc			;b32f
	rlca			;b330
	rlca			;b331
	rrca			;b332
	rrca			;b333
	rra			;b334
	rra			;b335
	ccf			;b336
	ccf			;b337
	nop			;b338
	ld b,0ffh		;b339
	add a,e			;b33b
	ld a,a			;b33c
	nop			;b33d
	ret c			;b33e
	ld b,0dah		;b33f
	ld (bc),a		;b341
	rlca			;b342
	ld (bc),a		;b343
	rrca			;b344
	add a,c			;b345
	rra			;b346
	inc bc			;b347
	nop			;b348
	dec b			;b349
	jp c,01a81h		;b34a
	inc bc			;b34d
	nop			;b34e
	ld c,0ffh		;b34f
	inc bc			;b351
	ld a,a			;b352
	inc bc			;b353
	rst 38h			;b354
	inc bc			;b355
	nop			;b356
	ex af,af'		;b357
	xor (hl)		;b358
	adc a,l			;b359
	add a,b			;b35a
	ret nz			;b35b
	ret po			;b35c
	ret p			;b35d
	ld sp,hl		;b35e
	defb 0fdh,0feh,0ffh ;illegal sequence	;b35f
	cp a			;b362
	rst 0			;b363
	ex de,hl		;b364
	push af			;b365
	call p,0fa03h		;b366
	adc a,d			;b369
	cp a			;b36a
	rst 18h			;b36b
	rst 28h			;b36c
	rst 30h			;b36d
	ei			;b36e
	defb 0fdh,0feh,0ffh ;illegal sequence	;b36f
	nop			;b372
	xor h			;b373
	ex af,af'		;b374
	xor (hl)		;b375
	adc a,b			;b376
	ld c,0f2h		;b377
	call m,000ffh		;b379
	nop			;b37c
	rra			;b37d
	ld a,a			;b37e
	dec bc			;b37f
	rst 38h			;b380
	adc a,d			;b381
	ld a,a			;b382
	ccf			;b383
	rlca			;b384
	add a,b			;b385
	rst 18h			;b386
	rst 28h			;b387
	rst 20h			;b388
	ex de,hl		;b389
	push af			;b38a
	or 003h			;b38b
	rst 30h			;b38d
	ld (bc),a		;b38e
	rst 28h			;b38f
	add a,d			;b390
	rst 18h			;b391
	ccf			;b392
	ld a,(bc)		;b393
	rst 38h			;b394
	xor b			;b395
	ld b,h			;b396
	inc sp			;b397
	ld l,(iy-080h)		;b398
	ld c,b			;b39b
	ld h,(hl)		;b39c
	cp a			;b39d
	and h			;b39e
	sub d			;b39f
	ld l,(iy-03ch)		;b3a0
	ld h,d			;b3a3
	dec sp			;b3a4
	rst 28h			;b3a5
	rst 38h			;b3a6
	rst 38h			;b3a7
	ret nz			;b3a8
	ret nz			;b3a9
	ret p			;b3aa
	ret p			;b3ab
	call m,0fffch		;b3ac
	rst 38h			;b3af
	ret nz			;b3b0
	ret nz			;b3b1
	ret po			;b3b2
	ret m			;b3b3
	ret m			;b3b4
	call m,03140h		;b3b5
	dec sp			;b3b8
	dec de			;b3b9
	inc sp			;b3ba
	ld sp,0133ch		;b3bb
	djnz $+1		;b3be
	sub b			;b3c0
	rst 20h			;b3c1
	jp 08100h		;b3c2
	jp 066e7h		;b3c5
	nop			;b3c8
	rst 20h			;b3c9
	jp 08100h		;b3ca
	jp 066e7h		;b3cd
	nop			;b3d0
	ld a,(bc)		;b3d1
	rst 38h			;b3d2
	ld (bc),a		;b3d3
	ccf			;b3d4
	ld (bc),a		;b3d5
	rrca			;b3d6
	ld (bc),a		;b3d7
	inc bc			;b3d8
	ld (bc),a		;b3d9
	rst 38h			;b3da
	ld (bc),a		;b3db
	ccf			;b3dc
	adc a,h			;b3dd
	rra			;b3de
	rlca			;b3df
	rlca			;b3e0
	inc bc			;b3e1
	ld (hl),h		;b3e2
	ret m			;b3e3
	ld (hl),c		;b3e4
	ld a,07fh		;b3e5
	rst 28h			;b3e7
	rst 18h			;b3e8
	rst 18h			;b3e9
	ld h,b			;b3ea
	nop			;b3eb
	sbc a,l			;b3ec
	dec b			;b3ed
	jr nz,$+18		;b3ee
	add a,d			;b3f0
	nop			;b3f1
	jr nz,$+6		;b3f2
	nop			;b3f4
	ld bc,01480h		;b3f5
	ld hl,(01e18h)		;b3f8
	ld b,b			;b3fb
	ld (de),a		;b3fc
	add a,d			;b3fd
	djnz $+39		;b3fe
	ld hl,(0801eh)		;b400
	djnz $+67		;b403
	ld d,b			;b405
	ld b,006h		;b406
	ld b,b			;b408
	add hl,bc		;b409
	inc bc			;b40a
	ld h,b			;b40b
	dec b			;b40c
	nop			;b40d
	adc a,e			;b40e
	jr nz,$+6		;b40f
	nop			;b411
	rra			;b412
	rra			;b413
	ccf			;b414
	ccf			;b415
	rst 38h			;b416
	jr nz,$+6		;b417
	nop			;b419
	ex af,af'		;b41a
	cp 082h			;b41b
	ld a,a			;b41d
	ccf			;b41e
	ld b,07fh		;b41f
	ld b,0feh		;b421
	add a,d			;b423
	call m,00700h		;b424
	ld a,a			;b427
	dec b			;b428
	nop			;b429
	ld (bc),a		;b42a
	ld a,a			;b42b
	add a,(hl)		;b42c
	ccf			;b42d
	nop			;b42e
	rra			;b42f
	rra			;b430
	ccf			;b431
	ccf			;b432
	inc bc			;b433
	rst 38h			;b434
	dec b			;b435
	nop			;b436
	inc bc			;b437
	ld a,a			;b438
	adc a,b			;b439
	nop			;b43a
	ld e,01eh		;b43b
	ld a,03eh		;b43d
	cp 0feh			;b43f
	call m,00005h		;b441
	add a,h			;b444
	djnz $-124		;b445
	ex af,af'		;b447
	rst 20h			;b448
	inc bc			;b449
	nop			;b44a
	adc a,b			;b44b
	djnz $+67		;b44c
	inc b			;b44e
	jr c,$+1		;b44f
	nop			;b451
	rst 28h			;b452
	rst 30h			;b453
	dec b			;b454
	rst 38h			;b455
	call nc,08700h		;b456
	xor 0fch		;b459
	ei			;b45b
	rst 30h			;b45c
	ld sp,hl		;b45d
	ei			;b45e
	ret po			;b45f
	ret p			;b460
	ret pe			;b461
	nop			;b462
	nop			;b463
	add a,b			;b464
	add a,h			;b465
	cp b			;b466
	rlca			;b467
	ld b,(hl)		;b468
	ld (hl),036h		;b469
	sbc a,l			;b46b
	ex (sp),hl		;b46c
	rst 20h			;b46d
	ld a,038h		;b46e
	ld h,b			;b470
	or d			;b471
	rst 10h			;b472
	rst 20h			;b473
	ld (hl),d		;b474
	cp (hl)			;b475
	inc e			;b476
	rst 28h			;b477
	halt			;b478
	dec (hl)		;b479
	inc sp			;b47a
	dec de			;b47b
	dec sp			;b47c
	ld sp,0dc40h		;b47d
	cp (hl)			;b480
	ld (hl),d		;b481
	rst 20h			;b482
	rst 10h			;b483
	or d			;b484
	ld l,b			;b485
	ld (hl),b		;b486
	rst 38h			;b487
	rst 18h			;b488
	rst 28h			;b489
	call po,0f4f4h		;b48a
	call m,0cffch		;b48d
	dec hl			;b490
	jp 04003h		;b491
	and b			;b494
	ret m			;b495
	call m,086cch		;b496
	ld b,007h		;b499
	rrca			;b49b
	rra			;b49c
	ccf			;b49d
	rra			;b49e
	and c			;b49f
	sub c			;b4a0
	ld h,(hl)		;b4a1
	inc a			;b4a2
	cp l			;b4a3
	in a,(0c3h)		;b4a4
	rst 20h			;b4a6
	call p,0ccf3h		;b4a7
	add a,e			;b4aa
	inc bc			;b4ab
	nop			;b4ac
	and c			;b4ad
	sbc a,b			;b4ae
	ld b,d			;b4af
	inc h			;b4b0
	rst 38h			;b4b1
	nop			;b4b2
	rst 38h			;b4b3
	add hl,bc		;b4b4
	ld (090c4h),a		;b4b5
	ld c,h			;b4b8
	and e			;b4b9
	jr $+41			;b4ba
	call nz,0fff8h		;b4bc
	ex af,af'		;b4bf
	jr nc,$-62		;b4c0
	nop			;b4c2
	jp 0003ch		;b4c3
	add a,c			;b4c6
	inc bc			;b4c7
	rlca			;b4c8
	inc bc			;b4c9
	rlca			;b4ca
	rrca			;b4cb
	rrca			;b4cc
	rlca			;b4cd
	ld bc,07f00h		;b4ce
	pop hl			;b4d1
	ld de,010e1h		;b4d2
	call pe,0e110h		;b4d5
	ex af,af'		;b4d8
	djnz $-122		;b4d9
	sbc a,h			;b4db
	adc a,h			;b4dc
	add a,(hl)		;b4dd
	add a,(hl)		;b4de
	inc bc			;b4df
	ld d,099h		;b4e0
	inc d			;b4e2
	sbc a,h			;b4e3
	adc a,h			;b4e4
	adc a,h			;b4e5
	add a,(hl)		;b4e6
	jr $+24			;b4e7
	ld d,014h		;b4e9
	adc a,b			;b4eb
	ld de,0e6e8h		;b4ec
	and 0e1h		;b4ef
	ret pe			;b4f1
	and 066h		;b4f2
	ld de,0e6e8h		;b4f4
	pop hl			;b4f7
	ret pe			;b4f8
	and 0e1h		;b4f9
	ex af,af'		;b4fb
	inc e			;b4fc
	add a,(hl)		;b4fd
	adc a,b			;b4fe
	ld de,06688h		;b4ff
	ld h,(hl)		;b502
	ld de,0e10ah		;b503
	ld (bc),a		;b506
	dec de			;b507
	ld b,0fbh		;b508
	ex af,af'		;b50a
	dec de			;b50b
	sub a			;b50c
	adc a,b			;b50d
	ld de,06688h		;b50e
	ld h,(hl)		;b511
	ld de,0cccch		;b512
	adc a,b			;b515
	ld de,06c8ch		;b516
	ld l,h			;b519
	inc e			;b51a
	adc a,h			;b51b
	ld l,h			;b51c
	ld h,(hl)		;b51d
	ld de,06c8ch		;b51e
	inc e			;b521
	adc a,h			;b522
	ld l,h			;b523
	add hl,bc		;b524
	inc e			;b525
	ld h,b			;b526
	nop			;b527
	dec bc			;b528
	xor h			;b529
	add a,e			;b52a
	inc a			;b52b
	inc l			;b52c
	inc e			;b52d
	dec b			;b52e
	xor h			;b52f
	add a,d			;b530
	inc a			;b531
	inc e			;b532
	inc b			;b533
	xor h			;b534
	add a,a			;b535
	call pe,0ac1ch		;b536
	xor h			;b539
	call pe,01cech		;b53a
	inc b			;b53d
	pop hl			;b53e
	inc b			;b53f
	xor h			;b540
	dec b			;b541
	pop bc			;b542
	inc bc			;b543
	xor h			;b544
	add a,c			;b545
	ld d,c			;b546
	rlca			;b547
	pop hl			;b548
	add a,c			;b549
	ld d,c			;b54a
	rlca			;b54b
	push hl			;b54c
	ex af,af'		;b54d
	pop hl			;b54e
	rlca			;b54f
	push hl			;b550
	dec d			;b551
	pop hl			;b552
	inc bc			;b553
	push hl			;b554
	add hl,bc		;b555
	pop hl			;b556
	rlca			;b557
	ld d,h			;b558
	add a,c			;b559
	call nz,05406h		;b55a
	ld (bc),a		;b55d
	call nz,01c38h		;b55e
	ld (de),a		;b561
	dec de			;b562
	dec b			;b563
	ld l,e			;b564
	add a,c			;b565
	ld h,c			;b566
	ex af,af'		;b567
	ld l,e			;b568
	jr nz,$+24		;b569
	inc bc			;b56b
	ld l,h			;b56c
	dec b			;b56d
	inc e			;b56e
	nop			;b56f
	sbc a,b			;b570
	ex af,af'		;b571
	rlca			;b572
	ld (de),a		;b573
	ld c,h			;b574
	jr nc,$+74		;b575
	add hl,bc		;b577
	add a,b			;b578
	ld (bc),a		;b579
	inc b			;b57a
	djnz $+68		;b57b
	add hl,bc		;b57d
	sub b			;b57e
	add a,b			;b57f
	ld h,l			;b580
	nop			;b581
	dec b			;b582
	ld hl,01002h		;b583
	ld b,c			;b586
	ld b,001h		;b587
	inc bc			;b589
	rst 38h			;b58a
	xor c			;b58b
	rst 18h			;b58c
	sbc a,a			;b58d
	cp a			;b58e
	ld a,a			;b58f
	ld a,a			;b590
	sbc a,a			;b591
	ccf			;b592
	ld h,a			;b593
	inc de			;b594
	adc a,a			;b595
	rrca			;b596
	ld sp,02f43h		;b597
	rra			;b59a
	rlca			;b59b
	ld d,e			;b59c
	adc a,e			;b59d
	ld c,029h		;b59e
	rla			;b5a0
	ld c,e			;b5a1
	ld sp,01f0fh		;b5a2
	inc sp			;b5a5
	ld b,a			;b5a6
	ccf			;b5a7
	sbc a,a			;b5a8
	jr nz,$-120		;b5a9
	ld b,c			;b5ab
	inc b			;b5ac
	ld d,02fh		;b5ad
	ld h,e			;b5af
	rst 38h			;b5b0
	ld b,049h		;b5b1
	rst 8			;b5b3
	cp a			;b5b4
	inc c			;b5b5
	rst 38h			;b5b6
	sub b			;b5b7
	ld c,d			;b5b8
	inc h			;b5b9
	nop			;b5ba
	nop			;b5bb
	jr nc,$+74		;b5bc
	add hl,bc		;b5be
	add a,b			;b5bf
	ld l,a			;b5c0
	sub l			;b5c1
	ld b,e			;b5c2
	add hl,bc		;b5c3
	ld bc,00248h		;b5c4
	djnz $+129		;b5c7
	nop			;b5c9
	ld hl,00a00h		;b5ca
	rst 38h			;b5cd
	ld (bc),a		;b5ce
	ccf			;b5cf
	ld (bc),a		;b5d0
	rrca			;b5d1
	ld (bc),a		;b5d2
	inc bc			;b5d3
	ld (bc),a		;b5d4
	rst 38h			;b5d5
	ld (bc),a		;b5d6
	ccf			;b5d7
	add a,h			;b5d8
	rra			;b5d9
	rlca			;b5da
	rlca			;b5db
	inc bc			;b5dc
	ld l,c			;b5dd
	nop			;b5de
	sub d			;b5df
	jr nc,$+52		;b5e0
	ld (04040h),a		;b5e2
	inc b			;b5e5
	inc b			;b5e6
	jr nc,$+122		;b5e7
	ld a,b			;b5e9
	jr c,$+4		;b5ea
	ld (bc),a		;b5ec
	jr nz,$+34		;b5ed
	nop			;b5ef
	ld b,b			;b5f0
	ld b,b			;b5f1
	inc bc			;b5f2
	ld c,002h		;b5f3
	ret nz			;b5f5
	inc bc			;b5f6
	ld c,002h		;b5f7
	jr nz,$+4		;b5f9
	add a,c			;b5fb
	or c			;b5fc
	nop			;b5fd
	rst 38h			;b5fe
	jp m,0fdfeh		;b5ff
	rst 28h			;b602
	cp 0f9h			;b603
	cp 060h			;b605
	ret nz			;b607
	sbc a,b			;b608
	call pe,0f070h		;b609
	xor 0bch		;b60c
	ret p			;b60e
	ret po			;b60f
	ret m			;b610
	xor h			;b611
	ld (hl),b		;b612
	ret p			;b613
	sub 0ech		;b614
	cp h			;b616
	xor 0f0h		;b617
	ret p			;b619
	call pe,0c0b8h		;b61a
	ld h,b			;b61d
	nop			;b61e
	ld h,b			;b61f
	jp c,0fbedh		;b620
	xor 0ffh		;b623
	cp 0ffh			;b625
	or 0fbh			;b627
	xor h			;b629
	ld (hl),b		;b62a
	ret p			;b62b
	sub 0ech		;b62c
	inc bc			;b62e
	rst 38h			;b62f
	sub l			;b630
	ei			;b631
	rst 38h			;b632
	cp l			;b633
	defb 0edh ;next byte illegal after ed	;b634
	sbc a,d			;b635
	ld sp,hl		;b636
	or (hl)			;b637
	ld (04032h),a		;b638
	ld b,b			;b63b
	inc b			;b63c
	inc b			;b63d
	jr nc,$+122		;b63e
	ld a,b			;b640
	jr c,$+4		;b641
	ld l,h			;b643
	exx			;b644
	ld h,(hl)		;b645
	nop			;b646
	add a,h			;b647
	xor h			;b648
	inc a			;b649
	inc e			;b64a
	inc a			;b64b
	inc bc			;b64c
	inc e			;b64d
	add a,(hl)		;b64e
	xor h			;b64f
	inc e			;b650
	xor h			;b651
	xor h			;b652
	inc e			;b653
	inc a			;b654
	rlca			;b655
	inc e			;b656
	add a,c			;b657
	xor h			;b658
	dec sp			;b659
	inc e			;b65a
	inc b			;b65b
	adc a,h			;b65c
	inc b			;b65d
	inc e			;b65e
	inc b			;b65f
	adc a,h			;b660
	inc b			;b661
	inc e			;b662
	ld a,a			;b663
	nop			;b664
	ld hl,08600h		;b665
	adc a,b			;b668
	ld de,06688h		;b669
	ld h,(hl)		;b66c
	ld de,08803h		;b66d
	adc a,a			;b670
	ld de,06888h		;b671
	ld l,b			;b674
	jr $-118		;b675
	ld l,b			;b677
	ld h,(hl)		;b678
	ld de,06888h		;b679
	jr $-118		;b67c
	ld l,b			;b67e
	jr $+106		;b67f
	nop			;b681
	inc bc			;b682
	sbc a,b			;b683
	add a,l			;b684
	jr $-102		;b685
	jr $-102		;b687
	jr $+5			;b689
	ret z			;b68b
	sub e			;b68c
	jr $-102		;b68d
	jr $-102		;b68f
	jr $-102		;b691
	sbc a,b			;b693
	jr $-102		;b694
	sbc a,b			;b696
	jr $-102		;b697
	jr $-22			;b699
	ret pe			;b69b
	jr $-102		;b69c
	jr $-102		;b69e
	inc a			;b6a0
	jr $-120		;b6a1
	sbc a,b			;b6a3
	jr $-102		;b6a4
	jr $-102		;b6a6
	jr $+5			;b6a8
	ret z			;b6aa
	dec b			;b6ab
	jr $+2			;b6ac
	sub d			;b6ae
	ex af,af'		;b6af
	ld b,h			;b6b0
	inc sp			;b6b1
	ld bc,04810h		;b6b2
	ld h,(hl)		;b6b5
	ld b,b			;b6b6
	ld (hl),b		;b6b7
	ld (de),a		;b6b8
	ld bc,080e7h		;b6b9
	ld h,d			;b6bc
	dec sp			;b6bd
	djnz $+0		;b6be
	inc bc			;b6c0
	rlca			;b6c1
	nop			;b6c2
	add a,d			;b6c3
	call m,00707h		;b6c4
	nop			;b6c7
	add a,(hl)		;b6c8
	ld (bc),a		;b6c9
	nop			;b6ca
	ld (bc),a		;b6cb
	inc b			;b6cc
	rrca			;b6cd
	rst 38h			;b6ce
	inc bc			;b6cf
	nop			;b6d0
	add a,l			;b6d1
	ex af,af'		;b6d2
	nop			;b6d3
	ex af,af'		;b6d4
	djnz $-30		;b6d5
	ld a,(bc)		;b6d7
	inc b			;b6d8
	add a,c			;b6d9
	nop			;b6da
	inc bc			;b6db
	inc b			;b6dc
	add a,l			;b6dd
	add hl,bc		;b6de
	ld bc,00808h		;b6df
	nop			;b6e2
	inc bc			;b6e3
	ex af,af'		;b6e4
	ld (bc),a		;b6e5
	ld (bc),a		;b6e6
	ld (bc),a		;b6e7
	nop			;b6e8
	add a,(hl)		;b6e9
	add a,b			;b6ea
	ld (hl),b		;b6eb
	inc c			;b6ec
	ld (bc),a		;b6ed
	ld (bc),a		;b6ee
	ld bc,0ff05h		;b6ef
	add a,l			;b6f2
	call m,0f0fdh		;b6f3
	rst 38h			;b6f6
	ld h,b			;b6f7
	ld b,000h		;b6f8
	adc a,b			;b6fa
	rst 38h			;b6fb
	ret m			;b6fc
	ret nz			;b6fd
	nop			;b6fe
	nop			;b6ff
	dec c			;b700
	ret po			;b701
	ret m			;b702
	inc bc			;b703
	rst 38h			;b704
	ld (bc),a		;b705
	defb 0fdh,087h,0fbh ;illegal sequence	;b706
	exx			;b709
	ld bc,0ff03h		;b70a
	rst 38h			;b70d
	inc e			;b70e
	inc b			;b70f
	nop			;b710
	adc a,b			;b711
	ccf			;b712
	rrca			;b713
	add a,b			;b714
	ret po			;b715
	ret m			;b716
	cp 0ffh			;b717
	rst 38h			;b719
	inc bc			;b71a
	ld bc,00284h		;b71b
	rlca			;b71e
	rra			;b71f
	ret p			;b720
	dec bc			;b721
	nop			;b722
	adc a,c			;b723
	inc b			;b724
	nop			;b725
	inc b			;b726
	ret m			;b727
	rst 38h			;b728
	rrca			;b729
	rra			;b72a
	ex (sp),hl		;b72b
	call m,0ff15h		;b72c
	adc a,b			;b72f
	rlca			;b730
	rra			;b731
	ld a,e			;b732
	ld (de),a		;b733
	ret nz			;b734
	ret p			;b735
	call m,003feh		;b736
	ld a,a			;b739
	adc a,b			;b73a
	ld c,0f1h		;b73b
	rst 38h			;b73d
	ld a,a			;b73e
	ccf			;b73f
	ld e,0c0h		;b740
	ret m			;b742
	ld b,l			;b743
	rst 38h			;b744
	ld (bc),a		;b745
	nop			;b746
	ld (bc),a		;b747
	ret nz			;b748
	ld (bc),a		;b749
	ret p			;b74a
	ld (bc),a		;b74b
	call m,00002h		;b74c
	ld (bc),a		;b74f
	ret nz			;b750
	add a,h			;b751
	ret po			;b752
	ret m			;b753
	ret m			;b754
	call m,00008h		;b755
	cp b			;b758
	ret po			;b759
	jp po,080d0h		;b75a
	and h			;b75d
	add a,b			;b75e
	sub b			;b75f
	ld b,b			;b760
	ret pe			;b761
	jp po,0a0d0h		;b762
	add a,h			;b765
	ld h,b			;b766
	ld h,c			;b767
	adc a,b			;b768
	jr nc,$+26		;b769
	ld a,(de)		;b76b
	inc e			;b76c
	jr $+22			;b76d
	ld a,(de)		;b76f
	inc (hl)		;b770
	jr nc,$+18		;b771
	add hl,de		;b773
	ret nc			;b774
	ret m			;b775
	ret p			;b776
	call po,021e0h		;b777
	jr z,$+34		;b77a
	inc (hl)		;b77c
	djnz $+18		;b77d
	jr $+28			;b77f
	and b			;b781
	ld b,d			;b782
	jr z,$+18		;b783
	ld a,(de)		;b785
	jr $+54			;b786
	add hl,sp		;b788
	jr $+30			;b789
	inc e			;b78b
	ld a,(de)		;b78c
	inc e			;b78d
	add hl,de		;b78e
	inc d			;b78f
	add hl,sp		;b790
	ex af,af'		;b791
	nop			;b792
	sbc a,b			;b793
	adc a,b			;b794
	and b			;b795
	ret nc			;b796
	ld h,h			;b797
	jr nc,$+22		;b798
	jr $+59			;b79a
	jr nc,$+58		;b79c
	ld (hl),b		;b79e
	ld (hl),h		;b79f
	ret po			;b7a0
	jp p,0c8e0h		;b7a1
	ex af,af'		;b7a4
	ld hl,04090h		;b7a5
	inc h			;b7a8
	djnz $+18		;b7a9
	add hl,de		;b7ab
	ex af,af'		;b7ac
	rst 38h			;b7ad
	and b			;b7ae
	nop			;b7af
	inc b			;b7b0
	jr nz,$+20		;b7b1
	ret po			;b7b3
	inc b			;b7b4
	djnz $-124		;b7b5
	nop			;b7b7
	ld b,c			;b7b8
	inc de			;b7b9
	ld c,040h		;b7ba
	ld bc,07008h		;b7bc
	nop			;b7bf
	jr nz,$+10		;b7c0
	ex af,af'		;b7c2
	jr nc,$+3		;b7c3
	nop			;b7c5
	ld b,b			;b7c6
	jr nz,$+4		;b7c7
	ex af,af'		;b7c9
	ld b,b			;b7ca
	ld a,(bc)		;b7cb
	jr z,$+3		;b7cc
	add a,h			;b7ce
	inc b			;b7cf
	nop			;b7d0
	add a,h			;b7d1
	djnz $-124		;b7d2
	ex af,af'		;b7d4
	rst 20h			;b7d5
	inc bc			;b7d6
	nop			;b7d7
	adc a,l			;b7d8
	djnz $+67		;b7d9
	inc b			;b7db
	jr c,$+1		;b7dc
	inc b			;b7de
	add a,(hl)		;b7df
	jr nz,$+50		;b7e0
	nop			;b7e2
	ld b,b			;b7e3
	nop			;b7e4
	ld (bc),a		;b7e5
	inc bc			;b7e6
	rst 38h			;b7e7
	sub d			;b7e8
	pop af			;b7e9
	ld c,d			;b7ea
	jr nz,$+2		;b7eb
	ld de,0feffh		;b7ed
	call po,04210h		;b7f0
	nop			;b7f3
	adc a,b			;b7f4
	nop			;b7f5
	nop			;b7f6
	inc b			;b7f7
	ld b,b			;b7f8
	nop			;b7f9
	jr nz,$+13		;b7fa
	nop			;b7fc
	nop			;b7fd
	add a,e			;b7fe
	sbc a,b			;b7ff
	ld l,b			;b800
	ld l,b			;b801
	inc b			;b802
	ld d,082h		;b803
	ld b,c			;b805
	sbc a,b			;b806
	inc bc			;b807
	ld l,b			;b808
	inc bc			;b809
	ld d,081h		;b80a
	ld b,c			;b80c
	djnz $+107		;b80d
	jr nc,$-117		;b80f
	ex af,af'		;b811
	ld l,c			;b812
	ex af,af'		;b813
	add hl,de		;b814
	dec b			;b815
	add a,(hl)		;b816
	add a,h			;b817
	ld h,c			;b818
	sub c			;b819
	sub c			;b81a
	adc a,b			;b81b
	rlca			;b81c
	ld h,c			;b81d
	add a,c			;b81e
	sbc a,b			;b81f
	rlca			;b820
	add a,(hl)		;b821
	ld (bc),a		;b822
	ld h,c			;b823
	ld b,091h		;b824
	ld b,089h		;b826
	ld a,(bc)		;b828
	add a,(hl)		;b829
	rlca			;b82a
	adc a,c			;b82b
	add a,e			;b82c
	add a,(hl)		;b82d
	ld h,c			;b82e
	ld h,c			;b82f
	ld d,091h		;b830
	add a,h			;b832
	sbc a,b			;b833
	add a,(hl)		;b834
	ld h,c			;b835
	ld h,c			;b836
	rlca			;b837
	sub c			;b838
	add a,d			;b839
	sbc a,b			;b83a
	ld l,b			;b83b
	inc b			;b83c
	ld h,c			;b83d
	ccf			;b83e
	sub c			;b83f
	sbc a,b			;b840
	adc a,b			;b841
	ld de,06688h		;b842
	ld h,(hl)		;b845
	ld de,09999h		;b846
	adc a,b			;b849
	ld de,09698h		;b84a
	sub (hl)		;b84d
	sub c			;b84e
	sbc a,b			;b84f
	sbc a,b			;b850
	ld h,(hl)		;b851
	ld de,09698h		;b852
	sub c			;b855
	sbc a,b			;b856
	sub (hl)		;b857
	sub c			;b858
	ld h,b			;b859
	ld l,c			;b85a
	ex af,af'		;b85b
	sbc a,c			;b85c
	ld c,089h		;b85d
	ld (bc),a		;b85f
	ld l,c			;b860
	djnz $-117		;b861
	rlca			;b863
	ld d,h			;b864
	add a,c			;b865
	sub h			;b866
	ld b,054h		;b867
	add a,d			;b869
	sub h			;b86a
	sbc a,c			;b86b
	ex af,af'		;b86c
	adc a,c			;b86d
	jr nz,$+107		;b86e
	nop			;b870
	add a,c			;b871
	inc c			;b872
	inc bc			;b873
	ex af,af'		;b874
	add a,l			;b875
	sbc a,b			;b876
	ret m			;b877
	jr c,$+26		;b878
	jr nc,$+7		;b87a
	djnz $+4		;b87c
	jr $-124		;b87e
	ld h,(hl)		;b880
	ld b,(hl)		;b881
	inc b			;b882
	ld b,d			;b883
	adc a,e			;b884
	ld b,e			;b885
	ld h,e			;b886
	ld l,l			;b887
	dec h			;b888
	dec h			;b889
	daa			;b88a
	dec (hl)		;b88b
	dec l			;b88c
	dec h			;b88d
	push hl			;b88e
	jr $+6			;b88f
	ex af,af'		;b891
	ld (bc),a		;b892
	inc c			;b893
	add a,h			;b894
	ld c,01ch		;b895
	rra			;b897
	add hl,de		;b898
	dec b			;b899
	djnz $-121		;b89a
	ld a,d			;b89c
	adc a,0c6h		;b89d
	jp nz,00342h		;b89f
	ld b,e			;b8a2
	or h			;b8a3
	ld (hl),a		;b8a4
	dec a			;b8a5
	dec l			;b8a6
	daa			;b8a7
	dec h			;b8a8
	dec (hl)		;b8a9
	dec a			;b8aa
	rst 28h			;b8ab
	rrca			;b8ac
	dec c			;b8ad
	ex af,af'		;b8ae
	ex af,af'		;b8af
	adc a,b			;b8b0
	ret z			;b8b1
	ld a,b			;b8b2
	jr c,$+50		;b8b3
	ret p			;b8b5
	ld (hl),b		;b8b6
	jr nc,$+26		;b8b7
	jr $+30			;b8b9
	ld e,042h		;b8bb
	ld h,d			;b8bd
	ld h,(hl)		;b8be
	ld a,(hl)		;b8bf
	ld h,(hl)		;b8c0
	ld b,d			;b8c1
	ld b,e			;b8c2
	ld b,e			;b8c3
	ld h,l			;b8c4
	dec h			;b8c5
	daa			;b8c6
	dec (hl)		;b8c7
	dec l			;b8c8
	dec h			;b8c9
	daa			;b8ca
	and l			;b8cb
	jr $+26			;b8cc
	ex af,af'		;b8ce
	ex af,af'		;b8cf
	inc c			;b8d0
	inc c			;b8d1
	ld c,00fh		;b8d2
	inc de			;b8d4
	djnz $+26		;b8d5
	jr $+5			;b8d7
	djnz $-123		;b8d9
	ret m			;b8db
	jp 003c2h		;b8dc
	ld b,d			;b8df
	sbc a,h			;b8e0
	ld h,d			;b8e1
	ld h,(hl)		;b8e2
	ld a,a			;b8e3
	push hl			;b8e4
	scf			;b8e5
	dec l			;b8e6
	dec l			;b8e7
	dec h			;b8e8
	daa			;b8e9
	dec h			;b8ea
	or l			;b8eb
	rst 38h			;b8ec
	ld b,c			;b8ed
	ld hl,09f11h		;b8ee
	ret p			;b8f1
	ld a,019h		;b8f2
	rst 38h			;b8f4
	ld b,c			;b8f5
	ld hl,01f11h		;b8f6
	djnz $+32		;b8f9
	ld de,003ffh		;b8fb
	ld b,c			;b8fe
	adc a,l			;b8ff
	ld a,a			;b900
	ld h,h			;b901
	ld b,d			;b902
	ld b,e			;b903
	rst 38h			;b904
	ld b,c			;b905
	ld hl,03f21h		;b906
	inc h			;b909
	ld h,0b5h		;b90a
	inc c			;b90c
	inc b			;b90d
	ex af,af'		;b90e
	cp h			;b90f
	adc a,b			;b910
	ld l,b			;b911
	jr c,$+26		;b912
	call m,00304h		;b914
	nop			;b917
	nop			;b918
	add a,b			;b919
	rst 38h			;b91a
	nop			;b91b
	add a,b			;b91c
	ld (hl),b		;b91d
	rst 38h			;b91e
	inc bc			;b91f
	nop			;b920
	nop			;b921
	rst 38h			;b922
	inc e			;b923
	rra			;b924
	add hl,de		;b925
	djnz $-110		;b926
	ld d,b			;b928
	ld (hl),b		;b929
	ret m			;b92a
	inc b			;b92b
	ld (bc),a		;b92c
	ld bc,000ffh		;b92d
	add a,b			;b930
	ld h,b			;b931
	rst 38h			;b932
	ld b,d			;b933
	ld h,d			;b934
	and 0feh		;b935
	ld (hl),d		;b937
	ld (de),a		;b938
	dec de			;b939
	rst 38h			;b93a
	rst 38h			;b93b
	ld (bc),a		;b93c
	inc b			;b93d
	ex af,af'		;b93e
	ld sp,hl		;b93f
	rrca			;b940
	ld a,h			;b941
	sbc a,b			;b942
	rst 38h			;b943
	ld (bc),a		;b944
	inc b			;b945
	ex af,af'		;b946
	ret m			;b947
	jr $+122		;b948
	adc a,b			;b94a
	rst 38h			;b94b
	inc bc			;b94c
	ld (bc),a		;b94d
	adc a,h			;b94e
	cp 026h			;b94f
	ld b,d			;b951
	jp nz,002ffh		;b952
	inc b			;b955
	inc b			;b956
	call m,06424h		;b957
	xor l			;b95a
	djnz $+2		;b95b
	ld b,0ffh		;b95d
	ld (bc),a		;b95f
	djnz $+4		;b960
	nop			;b962
	ld (bc),a		;b963
	ret nz			;b964
	ld (bc),a		;b965
	ret p			;b966
	ld (bc),a		;b967
	call m,00002h		;b968
	ld (bc),a		;b96b
	ret nz			;b96c
	inc bc			;b96d
	ret m			;b96e
	add a,c			;b96f
	call m,00068h		;b970
	add a,c			;b973
	rst 38h			;b974
	inc bc			;b975
	ld bc,0ff81h		;b976
	inc bc			;b979
	djnz $-93		;b97a
	inc c			;b97c
	ld (bc),a		;b97d
	rst 38h			;b97e
	inc c			;b97f
	inc bc			;b980
	rst 38h			;b981
	ld b,h			;b982
	rst 38h			;b983
	inc bc			;b984
	ld bc,00cffh		;b985
	inc bc			;b988
	rst 38h			;b989
	ld b,h			;b98a
	rst 38h			;b98b
	ld bc,0ff80h		;b98c
	ex af,af'		;b98f
	ld b,0ffh		;b990
	ld b,h			;b992
	rst 38h			;b993
	dec h			;b994
	rst 30h			;b995
	defb 0edh ;next byte illegal after ed	;b996
	dec a			;b997
	dec e			;b998
	rst 38h			;b999
	ld b,l			;b99a
	rst 38h			;b99b
	rst 38h			;b99c
	inc bc			;b99d
	ld bc,0ff91h		;b99e
	djnz $+26		;b9a1
	jr $-30			;b9a3
	ex (sp),hl		;b9a5
	rst 30h			;b9a6
	push hl			;b9a7
	defb 0edh ;next byte illegal after ed	;b9a8
	ld l,l			;b9a9
	dec l			;b9aa
	rrca			;b9ab
	rst 38h			;b9ac
	pop bc			;b9ad
	add a,c			;b9ae
	ld bc,003ffh		;b9af
	djnz $-113		;b9b2
	rst 0			;b9b4
	rst 20h			;b9b5
	rst 28h			;b9b6
	rst 30h			;b9b7
	rst 30h			;b9b8
	or 0f4h			;b9b9
	nop			;b9bb
	rst 38h			;b9bc
	rlca			;b9bd
	rra			;b9be
	ccf			;b9bf
	ccf			;b9c0
	inc bc			;b9c1
	ld a,a			;b9c2
	adc a,c			;b9c3
	rst 38h			;b9c4
	inc a			;b9c5
	jr c,$+122		;b9c6
	ret m			;b9c8
	cp b			;b9c9
	ld (hl),b		;b9ca
	rst 38h			;b9cb
	rst 38h			;b9cc
	ld b,05ah		;b9cd
	add a,e			;b9cf
	in a,(0ffh)		;b9d0
	ld a,a			;b9d2
	inc b			;b9d3
	rst 38h			;b9d4
	add a,e			;b9d5
	ld a,a			;b9d6
	rra			;b9d7
	ld a,a			;b9d8
	inc b			;b9d9
	ccf			;b9da
	add a,e			;b9db
	rra			;b9dc
	rrca			;b9dd
	rrca			;b9de
	ex af,af'		;b9df
	nop			;b9e0
	add a,a			;b9e1
	ld a,(hl)		;b9e2
	add a,c			;b9e3
	rst 38h			;b9e4
	defb 0fdh,0feh,0feh ;illegal sequence	;b9e5
	rst 38h			;b9e8
	add hl,bc		;b9e9
	nop			;b9ea
	ld (bc),a		;b9eb
	cp 08bh			;b9ec
	ld a,a			;b9ee
	rst 38h			;b9ef
	rst 38h			;b9f0
	ld a,a			;b9f1
	ld a,(hl)		;b9f2
	ld a,(hl)		;b9f3
	rst 38h			;b9f4
	inc bc			;b9f5
	ld bc,0ffffh		;b9f6
	inc bc			;b9f9
	djnz $-102		;b9fa
	nop			;b9fc
	add a,c			;b9fd
	rst 38h			;b9fe
	defb 0fdh,0feh,0feh ;illegal sequence	;b9ff
	rst 38h			;ba02
	nop			;ba03
	ld a,h			;ba04
	call m,0f4f8h		;ba05
	ret pe			;ba08
	call nc,0de2eh		;ba09
	ld a,0deh		;ba0c
	ret po			;ba0e
	and 0eeh		;ba0f
	ld c,0c2h		;ba11
	inc a			;ba13
	inc b			;ba14
	rst 20h			;ba15
	sbc a,c			;ba16
	rst 38h			;ba17
	jp 0c33ch		;ba18
	inc d			;ba1b
	dec de			;ba1c
	ret z			;ba1d
	ret pe			;ba1e
	ret po			;ba1f
	ret po			;ba20
	ret pe			;ba21
	call c,03e7fh		;ba22
	ld bc,0013eh		;ba25
	ld a,03ch		;ba28
	nop			;ba2a
	cp 07ch			;ba2b
	add a,b			;ba2d
	ld a,h			;ba2e
	inc a			;ba2f
	inc bc			;ba30
	nop			;ba31
	sbc a,c			;ba32
	ret p			;ba33
	or b			;ba34
	or e			;ba35
	or a			;ba36
	or a			;ba37
	rst 20h			;ba38
	rst 10h			;ba39
	cp e			;ba3a
	ld a,(hl)		;ba3b
	add a,c			;ba3c
	ld a,(hl)		;ba3d
	nop			;ba3e
	jp 00066h		;ba3f
	nop			;ba42
	rst 38h			;ba43
	nop			;ba44
	cp l			;ba45
	cp l			;ba46
	inc a			;ba47
	cp l			;ba48
	jr $+62			;ba49
	rst 38h			;ba4b
	inc bc			;ba4c
	add a,b			;ba4d
	add a,(hl)		;ba4e
	inc b			;ba4f
	ld b,007h		;ba50
	rlca			;ba52
	rst 38h			;ba53
	in a,(004h)		;ba54
	ld e,d			;ba56
	add a,d			;ba57
	ld a,(hl)		;ba58
	rst 38h			;ba59
	nop			;ba5a
	ld a,a			;ba5b
	inc d			;ba5c
	ld (hl),c		;ba5d
	inc d			;ba5e
	djnz $+2		;ba5f
	sbc a,b			;ba61
	adc a,b			;ba62
	ld de,06688h		;ba63
	ld h,(hl)		;ba66
	ld de,01514h		;ba67
	adc a,b			;ba6a
	ld de,05648h		;ba6b
	ld d,041h		;ba6e
	ld c,b			;ba70
	ld d,(hl)		;ba71
	ld h,(hl)		;ba72
	ld de,05648h		;ba73
	ld de,04648h		;ba76
	ld d,c			;ba79
	ld l,b			;ba7a
	nop			;ba7b
	inc bc			;ba7c
	inc d			;ba7d
	add a,c			;ba7e
	dec d			;ba7f
	inc bc			;ba80
	inc d			;ba81
	add a,c			;ba82
	dec d			;ba83
	inc hl			;ba84
	inc d			;ba85
	add a,a			;ba86
	dec d			;ba87
	inc d			;ba88
	inc d			;ba89
	sub h			;ba8a
	sub l			;ba8b
	ld h,c			;ba8c
	ld h,h			;ba8d
	ld b,061h		;ba8e
	inc bc			;ba90
	inc d			;ba91
	add a,c			;ba92
	dec d			;ba93
	inc bc			;ba94
	inc d			;ba95
	add a,e			;ba96
	dec d			;ba97
	ld h,c			;ba98
	ld h,h			;ba99
	ld b,061h		;ba9a
	add a,l			;ba9c
	ld de,06494h		;ba9d
	ld h,l			;baa0
	ld h,c			;baa1
	inc bc			;baa2
	ld h,h			;baa3
	adc a,b			;baa4
	ld de,01464h		;baa5
	ld h,l			;baa8
	ld h,c			;baa9
	ld h,h			;baaa
	ld h,h			;baab
	ld d,l			;baac
	ex af,af'		;baad
	ld h,c			;baae
	rlca			;baaf
	inc d			;bab0
	adc a,c			;bab1
	dec d			;bab2
	ld h,c			;bab3
	inc d			;bab4
	sub h			;bab5
	ld h,l			;bab6
	ld h,c			;bab7
	ld h,h			;bab8
	inc d			;bab9
	dec d			;baba
	ex af,af'		;babb
	nop			;babc
	ld (bc),a		;babd
	ld h,c			;babe
	dec b			;babf
	ld l,c			;bac0
	add a,c			;bac1
	ld h,c			;bac2
	ex af,af'		;bac3
	nop			;bac4
	adc a,b			;bac5
	ld h,c			;bac6
	inc d			;bac7
	sub c			;bac8
	ld h,c			;bac9
	ld h,c			;baca
	ld h,h			;bacb
	inc d			;bacc
	dec d			;bacd
	inc bc			;bace
	inc d			;bacf
	add a,c			;bad0
	ld d,l			;bad1
	inc bc			;bad2
	inc d			;bad3
	add a,e			;bad4
	dec d			;bad5
	ld h,c			;bad6
	ld h,c			;bad7
	dec b			;bad8
	ld l,c			;bad9
	ld de,00261h		;bada
	ld l,c			;badd
	inc bc			;bade
	ld l,b			;badf
	add a,e			;bae0
	ld h,c			;bae1
	sub c			;bae2
	sub (hl)		;bae3
	jr $+99			;bae4
	add a,c			;bae6
	sub c			;bae7
	dec bc			;bae8
	ld h,c			;bae9
	inc b			;baea
	pop af			;baeb
	rlca			;baec
	ld h,c			;baed
	add a,c			;baee
	dec d			;baef
	inc bc			;baf0
	inc d			;baf1
	add a,l			;baf2
	dec d			;baf3
	ld h,c			;baf4
	ld h,h			;baf5
	ld h,h			;baf6
	ld h,l			;baf7
	ex af,af'		;baf8
	ld h,c			;baf9
	nop			;bafa
	or h			;bafb
	add a,b			;bafc
	ld h,b			;bafd
	jr nc,$+10		;bafe
	nop			;bb00
	ld bc,04081h		;bb01
	add hl,bc		;bb04
	ld b,000h		;bb05
	ld h,c			;bb07
	jr $+6			;bb08
	nop			;bb0a
	nop			;bb0b
	jr nz,$+18		;bb0c
	inc b			;bb0e
	add a,h			;bb0f
	ld h,e			;bb10
	ld bc,00e10h		;bb11
	adc a,0e7h		;bb14
	ld (hl),e		;bb16
	ld a,c			;bb17
	inc e			;bb18
	adc a,a			;bb19
	ld b,a			;bb1a
	inc hl			;bb1b
	call pe,00170h		;bb1c
	inc bc			;bb1f
	ld c,0e4h		;bb20
	pop hl			;bb22
	call p,0fcf9h		;bb23
	cp 0feh			;bb26
	rst 8			;bb28
	rst 30h			;bb29
	ei			;bb2a
	ld sp,hl		;bb2b
	ret nz			;bb2c
	ret p			;bb2d
	call m,004feh		;bb2e
	rst 38h			;bb31
	jp nz,0fffeh		;bb32
	rst 38h			;bb35
	ei			;bb36
	dec a			;bb37
	adc a,(hl)		;bb38
	rst 0			;bb39
	ret nz			;bb3a
	rst 20h			;bb3b
	ld sp,hl		;bb3c
	call m,0fdfch		;bb3d
	ld a,e			;bb40
	dec sp			;bb41
	ld d,c			;bb42
	defb 0fdh,0fch,0feh ;illegal sequence	;bb43
	ld a,(hl)		;bb46
	cp a			;bb47
	rst 18h			;bb48
	rst 28h			;bb49
	rst 38h			;bb4a
	ld a,a			;bb4b
	sbc a,a			;bb4c
	rst 20h			;bb4d
	pop af			;bb4e
	ret m			;bb4f
	cp 0ffh			;bb50
	rst 38h			;bb52
	ex (sp),hl		;bb53
	ret m			;bb54
	call m,0fefeh		;bb55
	ld a,(hl)		;bb58
	inc c			;bb59
	pop bc			;bb5a
	adc a,0e7h		;bb5b
	ld (hl),e		;bb5d
	ld a,c			;bb5e
	inc e			;bb5f
	rst 8			;bb60
	rst 30h			;bb61
	ei			;bb62
	ld a,l			;bb63
	ld a,h			;bb64
	cp (hl)			;bb65
	sbc a,0ceh		;bb66
	rla			;bb68
	scf			;bb69
	sbc a,e			;bb6a
	rst 38h			;bb6b
	rst 38h			;bb6c
	ccf			;bb6d
	rst 8			;bb6e
	ld sp,0f0cch		;bb6f
	call m,0fce0h		;bb72
	inc b			;bb75
	rst 38h			;bb76
	and a			;bb77
	ccf			;bb78
	rst 18h			;bb79
	ret m			;bb7a
	call m,0be7eh		;bb7b
	adc a,a			;bb7e
	or a			;bb7f
	set 6,e			;bb80
	ld a,00fh		;bb82
	rlca			;bb84
	ld bc,00e0ch		;bb85
	rlca			;bb88
	ld bc,01924h		;bb89
	pop bc			;bb8c
	ret m			;bb8d
	call m,0877eh		;bb8e
	ld sp,hl		;bb91
	ld sp,hl		;bb92
	cp 0ffh			;bb93
	rst 38h			;bb95
	ld a,a			;bb96
	ccf			;bb97
	sbc a,a			;bb98
	rst 18h			;bb99
	dec sp			;bb9a
	ld c,003h		;bb9b
	inc bc			;bb9d
	ld bc,00003h		;bb9e
	xor b			;bba1
	ccf			;bba2
	rlca			;bba3
	inc bc			;bba4
	ld bc,07e01h		;bba5
	inc c			;bba8
	pop bc			;bba9
	rlca			;bbaa
	inc bc			;bbab
	ld bc,08f7fh		;bbac
	or a			;bbaf
	set 6,e			;bbb0
	ld b,063h		;bbb2
	ld bc,0cf01h		;bbb4
	rst 30h			;bbb7
	ei			;bbb8
	ld sp,hl		;bbb9
	ex af,af'		;bbba
	ld b,h			;bbbb
	inc sp			;bbbc
	ld bc,04810h		;bbbd
	ld h,(hl)		;bbc0
	ld b,b			;bbc1
	ld (hl),b		;bbc2
	ld (de),a		;bbc3
	ld bc,080e7h		;bbc4
	ld h,d			;bbc7
	dec sp			;bbc8
	djnz $+10		;bbc9
	nop			;bbcb
	ld (bc),a		;bbcc
	ret z			;bbcd
	sub b			;bbce
	adc a,b			;bbcf
	sub b			;bbd0
	djnz $+18		;bbd1
	sub b			;bbd3
	sub b			;bbd4
	and b			;bbd5
	ret nz			;bbd6
	ret nz			;bbd7
	ret po			;bbd8
	ret po			;bbd9
	ret p			;bbda
	ret pe			;bbdb
	ret z			;bbdc
	rst 38h			;bbdd
	rst 38h			;bbde
	ld b,000h		;bbdf
	add a,a			;bbe1
	ld a,(hl)		;bbe2
	inc a			;bbe3
	sbc a,c			;bbe4
	jp 0423ch		;bbe5
	jr $+5			;bbe8
	rst 38h			;bbea
	ld (bc),a		;bbeb
	ret m			;bbec
	ld (bc),a		;bbed
	ld a,h			;bbee
	ld (bc),a		;bbef
	ld a,00ah		;bbf0
	rst 38h			;bbf2
	ld (bc),a		;bbf3
	ccf			;bbf4
	ld (bc),a		;bbf5
	rrca			;bbf6
	ld (bc),a		;bbf7
	inc bc			;bbf8
	ld (bc),a		;bbf9
	rst 38h			;bbfa
	ld (bc),a		;bbfb
	ccf			;bbfc
	add a,l			;bbfd
	rra			;bbfe
	rlca			;bbff
	rlca			;bc00
	inc bc			;bc01
	ret z			;bc02
	inc bc			;bc03
	xor b			;bc04
	add a,a			;bc05
	ret z			;bc06
	ret nc			;bc07
	ret po			;bc08
	ret p			;bc09
	and b			;bc0a
	ret nz			;bc0b
	ret nz			;bc0c
	inc bc			;bc0d
	and b			;bc0e
	adc a,d			;bc0f
	jr nz,$-94		;bc10
	ret z			;bc12
	ret po			;bc13
	ret p			;bc14
	ret pe			;bc15
	ret pe			;bc16
	ret z			;bc17
	ret z			;bc18
	ret po			;bc19
	inc b			;bc1a
	nop			;bc1b
	adc a,b			;bc1c
	ret nz			;bc1d
	ret p			;bc1e
	ret m			;bc1f
	call m,07a7eh		;bc20
	ld a,(hl)		;bc23
	inc a			;bc24
	inc bc			;bc25
	nop			;bc26
	sub l			;bc27
	ld bc,03f0fh		;bc28
	ld a,a			;bc2b
	ld a,a			;bc2c
	cp 0ffh			;bc2d
	rst 38h			;bc2f
	add a,e			;bc30
	nop			;bc31
	jp 0efc7h		;bc32
	rst 28h			;bc35
	ld l,a			;bc36
	ld e,l			;bc37
	ld e,e			;bc38
	jp 0fde7h		;bc39
	rst 38h			;bc3c
	inc bc			;bc3d
	cp 099h			;bc3e
	rst 38h			;bc40
	nop			;bc41
	ret nz			;bc42
	ret po			;bc43
	pop af			;bc44
	di			;bc45
	di			;bc46
	cp e			;bc47
	in a,(001h)		;bc48
	nop			;bc4a
	nop			;bc4b
	ld bc,08301h		;bc4c
	inc a			;bc4f
	ld a,(hl)		;bc50
	ret c			;bc51
	call c,0eeefh		;bc52
	adc a,0c7h		;bc55
	add a,a			;bc57
	ld bc,0fe03h		;bc58
	ld (bc),a		;bc5b
	rst 38h			;bc5c
	adc a,h			;bc5d
	ld a,a			;bc5e
	ccf			;bc5f
	rra			;bc60
	call m,0dffbh		;bc61
	rst 18h			;bc64
	ld l,a			;bc65
	inc sp			;bc66
	adc a,a			;bc67
	add a,c			;bc68
	ld a,e			;bc69
	inc bc			;bc6a
	rst 8			;bc6b
	ld (bc),a		;bc6c
	call m,0bf02h		;bc6d
	sbc a,d			;bc70
	or a			;bc71
	call m,08ffch		;bc72
	add a,a			;bc75
	rst 0			;bc76
	defb 0fdh,05fh,0c3h ;illegal sequence	;bc77
	add a,c			;bc7a
	jp 0fec3h		;bc7b
	scf			;bc7e
	scf			;bc7f
	call pe,0bcfbh		;bc80
	rst 30h			;bc83
	ld a,a			;bc84
	push hl			;bc85
	ret nz			;bc86
	pop bc			;bc87
	pop hl			;bc88
	jr $+6			;bc89
	ld b,000h		;bc8b
	adc a,b			;bc8d
	call pe,00170h		;bc8e
	inc bc			;bc91
	ld b,01bh		;bc92
	ld a,077h		;bc94
	inc bc			;bc96
	nop			;bc97
	adc a,(hl)		;bc98
	ld bc,00d07h		;bc99
	ccf			;bc9c
	rst 30h			;bc9d
	ld bc,01d07h		;bc9e
	rst 30h			;bca1
	cp 037h			;bca2
	scf			;bca4
	call pe,003deh		;bca5
	di			;bca8
	ld (bc),a		;bca9
	rst 38h			;bcaa
	add a,d			;bcab
	ld a,a			;bcac
	ccf			;bcad
	inc b			;bcae
	nop			;bcaf
	add a,h			;bcb0
	djnz $-124		;bcb1
	ex af,af'		;bcb3
	rst 20h			;bcb4
	inc bc			;bcb5
	nop			;bcb6
	sub d			;bcb7
	djnz $+67		;bcb8
	inc b			;bcba
	jr c,$+1		;bcbb
	inc bc			;bcbd
	ld (hl),b		;bcbe
	call p,0fcf4h		;bcbf
	cp h			;bcc2
	call m,0b4b4h		;bcc3
	call p,0f4fch		;bcc6
	call p,0fc07h		;bcc9
	inc bc			;bccc
	call p,0bca3h		;bccd
	call m,0b4fch		;bcd0
	cp h			;bcd3
	call p,030b4h		;bcd4
	nop			;bcd7
	add a,b			;bcd8
	nop			;bcd9
	nop			;bcda
	ld bc,00020h		;bcdb
	and d			;bcde
	ld c,b			;bcdf
	nop			;bce0
	ex af,af'		;bce1
	nop			;bce2
	nop			;bce3
	ex af,af'		;bce4
	ld bc,01044h		;bce5
	ret p			;bce8
	call m,0f2fah		;bce9
	jp po,0fcf8h		;bcec
	call m,0dae2h		;bcef
	inc bc			;bcf2
	call m,0f887h		;bcf3
	or 0feh			;bcf6
	defb 0fdh,0fdh,0fbh ;illegal sequence	;bcf8
	rst 38h			;bcfb
	inc b			;bcfc
	cp 002h			;bcfd
	ccf			;bcff
	ld (bc),a		;bd00
	ld e,a			;bd01
	add a,c			;bd02
	rst 28h			;bd03
	inc bc			;bd04
	rst 38h			;bd05
	add a,e			;bd06
	ld e,(hl)		;bd07
	jr $+1			;bd08
	inc b			;bd0a
	cp l			;bd0b
	add a,h			;bd0c
	rst 38h			;bd0d
	ld a,0ddh		;bd0e
	inc e			;bd10
	inc bc			;bd11
	ld a,085h		;bd12
	inc e			;bd14
	add a,b			;bd15
	ld a,a			;bd16
	rrca			;bd17
	inc bc			;bd18
	inc bc			;bd19
	cp 086h			;bd1a
	ret m			;bd1c
	add a,b			;bd1d
	inc bc			;bd1e
	inc bc			;bd1f
	rlca			;bd20
	rlca			;bd21
	inc b			;bd22
	rrca			;bd23
	adc a,e			;bd24
	ret nz			;bd25
	ret po			;bd26
	ret m			;bd27
	ret nz			;bd28
	ret p			;bd29
	call m,0f8fch		;bd2a
	rst 38h			;bd2d
	jp 004c3h		;bd2e
	rst 38h			;bd31
	add a,h			;bd32
	nop			;bd33
	rrca			;bd34
	rra			;bd35
	rra			;bd36
	inc bc			;bd37
	ccf			;bd38
	add a,a			;bd39
	rlca			;bd3a
	nop			;bd3b
	ret p			;bd3c
	ret z			;bd3d
	jr c,$-30		;bd3e
	add a,b			;bd40
	inc bc			;bd41
	nop			;bd42
	sbc a,b			;bd43
	rlca			;bd44
	inc bc			;bd45
	nop			;bd46
	rlca			;bd47
	rrca			;bd48
	nop			;bd49
	nop			;bd4a
	ret po			;bd4b
	ret po			;bd4c
	ret nz			;bd4d
	nop			;bd4e
	nop			;bd4f
	ret nz			;bd50
	ret p			;bd51
	ret p			;bd52
	rlca			;bd53
	rst 38h			;bd54
	cp a			;bd55
	rst 8			;bd56
	ex (sp),hl		;bd57
	jp 08387h		;bd58
	jp 02200h		;bd5b
	pop hl			;bd5e
	inc bc			;bd5f
	sub c			;bd60
	rlca			;bd61
	jp (hl)			;bd62
	ld (hl),h		;bd63
	pop hl			;bd64
	dec c			;bd65
	sbc a,(hl)		;bd66
	inc bc			;bd67
	pop hl			;bd68
	inc bc			;bd69
	sbc a,(hl)		;bd6a
	dec b			;bd6b
	pop hl			;bd6c
	inc b			;bd6d
	sbc a,(hl)		;bd6e
	inc b			;bd6f
	pop hl			;bd70
	add a,e			;bd71
	sbc a,b			;bd72
	ld l,b			;bd73
	ld l,b			;bd74
	inc b			;bd75
	ld d,082h		;bd76
	ld b,c			;bd78
	sbc a,b			;bd79
	inc bc			;bd7a
	ld l,b			;bd7b
	inc bc			;bd7c
	ld d,081h		;bd7d
	ld b,c			;bd7f
	ex af,af'		;bd80
	nop			;bd81
	djnz $-109		;bd82
	ex af,af'		;bd84
	ld h,c			;bd85
	dec b			;bd86
	or c			;bd87
	add a,e			;bd88
	pop af			;bd89
	cp l			;bd8a
	cp l			;bd8b
	ex af,af'		;bd8c
	ld h,c			;bd8d
	sbc a,b			;bd8e
	adc a,b			;bd8f
	ld de,06688h		;bd90
	ld h,(hl)		;bd93
	ld de,09999h		;bd94
	adc a,b			;bd97
	ld de,06989h		;bd98
	ld l,c			;bd9b
	add hl,de		;bd9c
	adc a,c			;bd9d
	ld l,c			;bd9e
	ld h,(hl)		;bd9f
	ld de,06989h		;bda0
	add hl,de		;bda3
	adc a,c			;bda4
	ld l,c			;bda5
	add hl,de		;bda6
	jr $-109		;bda7
	rrca			;bda9
	cp c			;bdaa
	add a,c			;bdab
	ld l,c			;bdac
	inc b			;bdad
	cp c			;bdae
	adc a,b			;bdaf
	or c			;bdb0
	cp c			;bdb1
	cp c			;bdb2
	or (hl)			;bdb3
	cp c			;bdb4
	cp c			;bdb5
	or (hl)			;bdb6
	or (hl)			;bdb7
	ld b,0b1h		;bdb8
	ld b,0bfh		;bdba
	inc bc			;bdbc
	cp c			;bdbd
	inc bc			;bdbe
	or (hl)			;bdbf
	ld (bc),a		;bdc0
	or c			;bdc1
	add a,c			;bdc2
	ld d,004h		;bdc3
	or (hl)			;bdc5
	add a,e			;bdc6
	sub (hl)		;bdc7
	cp c			;bdc8
	cp c			;bdc9
	dec b			;bdca
	or c			;bdcb
	inc bc			;bdcc
	or (hl)			;bdcd
	dec b			;bdce
	cp c			;bdcf
	inc bc			;bdd0
	or c			;bdd1
	ex af,af'		;bdd2
	ld h,c			;bdd3
	sub b			;bdd4
	sub (hl)		;bdd5
	sbc a,(hl)		;bdd6
	sbc a,(hl)		;bdd7
	sub c			;bdd8
	sbc a,(hl)		;bdd9
	sub c			;bdda
	sbc a,a			;bddb
	sub c			;bddc
	sub (hl)		;bddd
	sbc a,a			;bdde
	sub c			;bddf
	sbc a,(hl)		;bde0
	sbc a,(hl)		;bde1
	sub c			;bde2
	sub (hl)		;bde3
	sub (hl)		;bde4
	inc bc			;bde5
	sbc a,(hl)		;bde6
	add a,h			;bde7
	sub c			;bde8
	sub (hl)		;bde9
	sbc a,a			;bdea
	sub c			;bdeb
	inc bc			;bdec
	sub (hl)		;bded
	ld (bc),a		;bdee
	sbc a,b			;bdef
	ld (bc),a		;bdf0
	sub d			;bdf1
	add a,d			;bdf2
	sbc a,h			;bdf3
	sub c			;bdf4
	ld a,(bc)		;bdf5
	pop hl			;bdf6
	inc de			;bdf7
	sub c			;bdf8
	add a,a			;bdf9
	sbc a,a			;bdfa
	sub c			;bdfb
	sub (hl)		;bdfc
	sub (hl)		;bdfd
	sbc a,(hl)		;bdfe
	sbc a,(hl)		;bdff
	sub c			;be00
	inc b			;be01
	sbc a,(hl)		;be02
	ld c,054h		;be03
	ld (bc),a		;be05
	sub h			;be06
	add a,c			;be07
	ld b,c			;be08
	rra			;be09
	and c			;be0a
	djnz $+86		;be0b
	jr nz,$-109		;be0d
	ld (bc),a		;be0f
	or c			;be10
	ld (bc),a		;be11
	ld l,a			;be12
	add a,d			;be13
	ld h,c			;be14
	ld l,a			;be15
	inc b			;be16
	ld h,c			;be17
	dec b			;be18
	or (hl)			;be19
	add a,h			;be1a
	ld h,c			;be1b
	or c			;be1c
	or (hl)			;be1d
	or (hl)			;be1e
	rlca			;be1f
	ld l,c			;be20
	inc bc			;be21
	cp c			;be22
	inc bc			;be23
	or c			;be24
	inc bc			;be25
	ld h,c			;be26
	inc bc			;be27
	or (hl)			;be28
	ld (bc),a		;be29
	or c			;be2a
	add a,h			;be2b
	ld de,01e1fh		;be2c
	ld de,06104h		;be2f
	add a,e			;be32
	or c			;be33
	ld h,c			;be34
	ld h,c			;be35
	inc d			;be36
	or c			;be37
	add a,e			;be38
	sub c			;be39
	or c			;be3a
	ld h,c			;be3b
	dec b			;be3c
	or c			;be3d
	add hl,bc		;be3e
	sub c			;be3f
	nop			;be40
	inc b			;be41
	nop			;be42
	inc bc			;be43
	ld bc,00f83h		;be44
	rra			;be47
	ld a,a			;be48
	ld b,0ffh		;be49
	adc a,d			;be4b
	ret po			;be4c
	call m,0f8ffh		;be4d
	ret po			;be50
	ret nz			;be51
	add a,b			;be52
	add a,b			;be53
	rst 38h			;be54
	inc bc			;be55
	ld b,000h		;be56
	ld (bc),a		;be58
	add a,b			;be59
	add a,e			;be5a
	ret nz			;be5b
	ld h,b			;be5c
	jr c,$+5		;be5d
	ccf			;be5f
	ld (bc),a		;be60
	nop			;be61
	add a,c			;be62
	inc bc			;be63
	dec b			;be64
	rst 38h			;be65
	and c			;be66
	ld a,a			;be67
	rst 38h			;be68
	rst 38h			;be69
	ret m			;be6a
	ret po			;be6b
	ret nz			;be6c
	add a,b			;be6d
	add a,b			;be6e
	nop			;be6f
	nop			;be70
	inc bc			;be71
	rst 38h			;be72
	ld l,e			;be73
	dec b			;be74
	jr nc,$+126		;be75
	ld a,h			;be77
	ld a,01fh		;be78
	ccf			;be7a
	ld d,(hl)		;be7b
	xor h			;be7c
	xor b			;be7d
	nop			;be7e
	ld a,h			;be7f
	jr $+122		;be80
	ret nc			;be82
	or b			;be83
	and b			;be84
	jr nz,$+2		;be85
	ld a,a			;be87
	dec b			;be88
	rst 38h			;be89
	add a,h			;be8a
	ld l,a			;be8b
	dec d			;be8c
	ret nz			;be8d
	djnz $+10		;be8e
	nop			;be90
	adc a,d			;be91
	inc bc			;be92
	rst 38h			;be93
	ld l,e			;be94
	dec b			;be95
	ret nc			;be96
	call m,07f3fh		;be97
	call m,004f8h		;be9a
	ret p			;be9d
	add a,l			;be9e
	ret m			;be9f
	call m,07fffh		;bea0
	ccf			;bea3
	inc bc			;bea4
	rra			;bea5
	adc a,d			;bea6
	ret m			;bea7
	ld a,h			;bea8
	cpl			;bea9
	dec d			;beaa
	ld a,a			;beab
	ccf			;beac
	rra			;bead
	inc bc			;beae
	rra			;beaf
	ld a,a			;beb0
	inc b			;beb1
	rst 38h			;beb2
	add a,d			;beb3
	ld a,a			;beb4
	rra			;beb5
	nop			;beb6
	inc de			;beb7
	ld h,h			;beb8
	dec hl			;beb9
	ld h,c			;beba
	ld (de),a		;bebb
	sub c			;bebc
	ld d,061h		;bebd
	ld (bc),a		;bebf
	sub c			;bec0
	ld (bc),a		;bec1
	ld h,h			;bec2
	add hl,bc		;bec3
	ld h,c			;bec4
	dec b			;bec5
	ld h,h			;bec6
	inc b			;bec7
	ld h,c			;bec8
	inc c			;bec9
	inc d			;beca
	nop			;becb
	call nc,00abeh		;becc
	cp a			;becf
	ld d,e			;bed0
	cp a			;bed1
	sub e			;bed2
	cp a			;bed3
	ret c			;bed4
	cp (hl)			;bed5
	pop af			;bed6
	cp (hl)			;bed7
	ld l,e			;bed8
	ld (hl),e		;bed9
	sub b			;beda
	sub c			;bedb
	sub d			;bedc
	sub e			;bedd
	sub a			;bede
	ld l,(hl)		;bedf
	rst 30h			;bee0
	sub h			;bee1
	sbc a,b			;bee2
	sbc a,c			;bee3
	sbc a,d			;bee4
	ld sp,hl		;bee5
	ret m			;bee6
	sub l			;bee7
	sbc a,e			;bee8
	sbc a,h			;bee9
	ei			;beea
	sub (hl)		;beeb
	sbc a,a			;beec
	sbc a,l			;beed
	sbc a,(hl)		;beee
	defb 0fdh,0ffh,0f2h ;illegal sequence	;beef
	pop af			;bef2
	sub b			;bef3
	out (0cbh),a		;bef4
	call p,06f97h		;bef6
	rst 30h			;bef9
	di			;befa
	sbc a,b			;befb
	sbc a,c			;befc
	sbc a,d			;befd
	ld sp,hl		;befe
	ret m			;beff
	or 09bh			;bf00
	sbc a,h			;bf02
	ei			;bf03
	push af			;bf04
	sbc a,a			;bf05
	sbc a,l			;bf06
	sbc a,(hl)		;bf07
	defb 0fdh,0ffh,00eh ;illegal sequence	;bf08
	cp a			;bf0b
	inc l			;bf0c
	cp a			;bf0d
	add a,b			;bf0e
	defb 0fdh,085h ;add a,iyl	;bf0f
	sbc a,l			;bf11
	add a,b			;bf12
	add a,b			;bf13
	ret pe			;bf14
	sub (hl)		;bf15
	adc a,b			;bf16
	add a,b			;bf17
	adc a,c			;bf18
	jp m,09a8bh		;bf19
	jp (hl)			;bf1c
	adc a,l			;bf1d
	call p,0948fh		;bf1e
	sub c			;bf21
	sub d			;bf22
	push af			;bf23
	sbc a,h			;bf24
	sub l			;bf25
	adc a,d			;bf26
	adc a,h			;bf27
	sbc a,b			;bf28
	ld bc,0ec99h		;bf29
	add a,b			;bf2c
	defb 0fdh,085h ;add a,iyl	;bf2d
	sbc a,l			;bf2f
	add a,b			;bf30
	add a,b			;bf31
	ret pe			;bf32
	sub (hl)		;bf33
	adc a,b			;bf34
	add a,b			;bf35
	adc a,c			;bf36
	jp m,09a8bh		;bf37
	jp (hl)			;bf3a
	pop af			;bf3b
	call p,0948fh		;bf3c
	defb 0edh ;next byte illegal after ed	;bf3f
	jp pe,09cf5h		;bf40
	sub l			;bf43
	add a,a			;bf44
	adc a,h			;bf45
	ld sp,hl		;bf46
	ld bc,0ecf8h		;bf47
	add a,(hl)		;bf4a
	sbc a,(hl)		;bf4b
	and 097h		;bf4c
	sbc a,e			;bf4e
	rst 30h			;bf4f
	call p,09493h		;bf50
	ld d,a			;bf53
	cp a			;bf54
	ld (hl),l		;bf55
	cp a			;bf56
	add a,b			;bf57
	add a,c			;bf58
	sbc a,a			;bf59
	add a,b			;bf5a
	add a,c			;bf5b
	ld a,b			;bf5c
	ld a,c			;bf5d
	ld a,d			;bf5e
	ld a,e			;bf5f
	halt			;bf60
	ld a,h			;bf61
	ld a,l			;bf62
	ld l,(hl)		;bf63
	ld a,(ix+077h)		;bf64
	ld a,a			;bf67
	sub l			;bf68
	sub (hl)		;bf69
	sub a			;bf6a
	sbc a,b			;bf6b
	sbc a,c			;bf6c
	sbc a,d			;bf6d
	ld sp,hl		;bf6e
	ret m			;bf6f
	sbc a,l			;bf70
	sbc a,h			;bf71
	ld bc,09e9bh		;bf72
	add a,b			;bf75
	add a,c			;bf76
	rst 38h			;bf77
	add a,b			;bf78
	add a,c			;bf79
	sub 0dbh		;bf7a
	ld a,d			;bf7c
	exx			;bf7d
	ret c			;bf7e
	sbc a,07dh		;bf7f
	ld l,(hl)		;bf81
	defb 0ddh,0dch,0f7h ;illegal sequence	;bf82
	or 095h			;bf85
	rst 18h			;bf87
	rst 10h			;bf88
	sbc a,b			;bf89
	sbc a,c			;bf8a
	sbc a,d			;bf8b
	ld sp,hl		;bf8c
	ret m			;bf8d
	cp 0fbh			;bf8e
	ld bc,0fdfch		;bf90
	sub a			;bf93
	cp a			;bf94
	cp e			;bf95
	cp a			;bf96
	adc a,(hl)		;bf97
	adc a,a			;bf98
	sub b			;bf99
	ret p			;bf9a
	rst 28h			;bf9b
	xor 09bh		;bf9c
	sub c			;bf9e
	sub d			;bf9f
	jp p,0fbf1h		;bfa0
	sbc a,h			;bfa3
	sub e			;bfa4
	sub h			;bfa5
	call p,0fcf3h		;bfa6
	sbc a,e			;bfa9
	sub c			;bfaa
	sub d			;bfab
	jp p,0fbf1h		;bfac
	sbc a,l			;bfaf
	sub l			;bfb0
	sbc a,b			;bfb1
	ret m			;bfb2
	jp m,09efdh		;bfb3
	sub (hl)		;bfb6
	sbc a,c			;bfb7
	ld sp,hl		;bfb8
	rst 30h			;bfb9
	cp 08eh			;bfba
	adc a,a			;bfbc
	sub b			;bfbd
	ret p			;bfbe
	rst 28h			;bfbf
	xor 09bh		;bfc0
	sub c			;bfc2
	sub d			;bfc3
	jp p,0fbf1h		;bfc4
	sbc a,h			;bfc7
	sub e			;bfc8
	sub h			;bfc9
	call p,0fcf3h		;bfca
	sbc a,e			;bfcd
	sub c			;bfce
	sub d			;bfcf
	jp p,0fbf1h		;bfd0
	sbc a,l			;bfd3
	sbc a,d			;bfd4
	sbc a,b			;bfd5
	ret m			;bfd6
	push af			;bfd7
	sbc a,(iy-069h)		;bfd8
	sbc a,c			;bfdb
	ld sp,hl		;bfdc
	or 0feh			;bfdd
	rst 38h			;bfdf
	rst 38h			;bfe0
	rst 38h			;bfe1
	rst 38h			;bfe2
	rst 38h			;bfe3
	rst 38h			;bfe4
	rst 38h			;bfe5
	rst 38h			;bfe6
	rst 38h			;bfe7
	rst 38h			;bfe8
	rst 38h			;bfe9
	rst 38h			;bfea
	rst 38h			;bfeb
	rst 38h			;bfec
	rst 38h			;bfed
	rst 38h			;bfee
	rst 38h			;bfef
	rst 38h			;bff0
	rst 38h			;bff1
	rst 38h			;bff2
	sub c			;bff3
	adc a,l			;bff4
	xor h			;bff5
	or a			;bff6
	sub d			;bff7
	add a,d			;bff8
	or e			;bff9
	or a			;bffa
	adc a,e			;bffb
	sbc a,(hl)		;bffc
	ld a,(bc)		;bffd
	add hl,sp		;bffe
	xor d			;bfff
