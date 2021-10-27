
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rotateV=R5
	.DEF _rotateH=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_shift:
	.DB  0xFE,0xFD,0xFB,0xF7
_stepmove:
	.DB  0x8,0x9,0x1,0x3,0x2,0x6,0x4,0xC
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x20,0x49,0x4E,0x20,0x54,0x48,0x45,0x20
	.DB  0x4E,0x41,0x4D,0x45,0x20,0x4F,0x46,0x20
	.DB  0x47,0x4F,0x44,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x57,0x45,0x4C,0x43,0x4F,0x4D
	.DB  0x45,0x21,0x0,0x45,0x4E,0x54,0x45,0x52
	.DB  0x20,0x20,0x4D,0x4F,0x4F,0x44,0x20,0x3A
	.DB  0x0,0x31,0x2E,0x49,0x54,0x45,0x4D,0x53
	.DB  0x0,0x32,0x2E,0x4D,0x4F,0x54,0x4F,0x52
	.DB  0x20,0x26,0x20,0x44,0x49,0x4D,0x45,0x4E
	.DB  0x53,0x49,0x4F,0x4E,0x0,0x33,0x2E,0x41
	.DB  0x50,0x50,0x4C,0x59,0x20,0x21,0x0,0x34
	.DB  0x2E,0x41,0x42,0x4F,0x55,0x54,0x20,0x50
	.DB  0x52,0x4F,0x4A,0x45,0x43,0x54,0x0,0x50
	.DB  0x4C,0x45,0x41,0x53,0x45,0x20,0x53,0x45
	.DB  0x4C,0x45,0x43,0x54,0x3A,0x0,0x31,0x2E
	.DB  0x53,0x48,0x4F,0x57,0x20,0x41,0x4C,0x4C
	.DB  0x0,0x32,0x2E,0x53,0x48,0x4F,0x57,0x20
	.DB  0x49,0x54,0x45,0x4D,0x53,0x0,0x43,0x4F
	.DB  0x4E,0x54,0x52,0x4F,0x4C,0x20,0x4C,0x49
	.DB  0x53,0x45,0x52,0x20,0x43,0x55,0x54,0x54
	.DB  0x45,0x52,0x0,0x42,0x59,0x3A,0x0,0x4D
	.DB  0x4F,0x48,0x41,0x4D,0x4D,0x41,0x44,0x20
	.DB  0x4A,0x41,0x56,0x41,0x44,0x20,0x41,0x44
	.DB  0x45,0x4C,0x0,0x49,0x54,0x45,0x4D,0x20
	.DB  0x25,0x64,0x0,0x44,0x41,0x54,0x41,0x3A
	.DB  0x0,0x20,0x27,0x25,0x63,0x27,0x20,0x0
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x0,0x3C,0x20,0x50,0x52,0x45,0x0,0x4E
	.DB  0x45,0x58,0x54,0x20,0x3E,0x0,0x20,0x42
	.DB  0x61,0x63,0x4B,0x0,0x2A,0x20,0x53,0x48
	.DB  0x4F,0x57,0x0,0x2F,0x20,0x45,0x44,0x49
	.DB  0x54,0x0,0x25,0x64,0x20,0x25,0x64,0x20
	.DB  0x25,0x64,0x20,0x20,0x20,0x0,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x31,0x2E,0x53,0x45,0x54,0x20,0x53
	.DB  0x50,0x45,0x45,0x44,0x0,0x32,0x2E,0x53
	.DB  0x45,0x54,0x20,0x44,0x49,0x4D,0x45,0x4E
	.DB  0x53,0x49,0x4F,0x4E,0x53,0x0,0x33,0x2E
	.DB  0x42,0x41,0x43,0x4B,0x0,0x45,0x4E,0x54
	.DB  0x45,0x52,0x20,0x4E,0x45,0x57,0x20,0x56
	.DB  0x41,0x4C,0x55,0x45,0x28,0x6D,0x73,0x29
	.DB  0x3A,0x0,0x54,0x48,0x45,0x4E,0x20,0x50
	.DB  0x52,0x45,0x53,0x53,0x20,0x20,0x20,0x45
	.DB  0x4E,0x20,0x0,0x54,0x48,0x45,0x20,0x44
	.DB  0x45,0x46,0x41,0x55,0x54,0x20,0x49,0x53
	.DB  0x3A,0x0,0x31,0x32,0x38,0x2A,0x36,0x34
	.DB  0x0,0x54,0x48,0x49,0x53,0x20,0x49,0x53
	.DB  0x20,0x55,0x4E,0x43,0x48,0x41,0x4E,0x47
	.DB  0x45,0x41,0x42,0x4C,0x45,0x0,0x31,0x2E
	.DB  0x41,0x50,0x50,0x4C,0x59,0x20,0x41,0x4C
	.DB  0x4C,0x0,0x32,0x2E,0x41,0x50,0x50,0x4C
	.DB  0x59,0x20,0x4F,0x4E,0x45,0x20,0x49,0x54
	.DB  0x45,0x4D,0x0,0x20,0x41,0x50,0x50,0x4C
	.DB  0x59,0x49,0x4E,0x47,0x2E,0x2E,0x2E,0x20
	.DB  0x21,0x0,0x53,0x45,0x4C,0x45,0x43,0x54
	.DB  0x20,0x49,0x54,0x45,0x4D,0x3A,0x0,0x31
	.DB  0x29,0x49,0x54,0x45,0x4D,0x20,0x31,0x20
	.DB  0x20,0x32,0x29,0x49,0x54,0x45,0x4D,0x20
	.DB  0x32,0x0,0x33,0x29,0x49,0x54,0x45,0x4D
	.DB  0x20,0x33,0x20,0x20,0x34,0x29,0x49,0x54
	.DB  0x45,0x4D,0x20,0x34,0x0,0x35,0x29,0x49
	.DB  0x54,0x45,0x4D,0x20,0x35,0x0,0x53,0x45
	.DB  0x4C,0x45,0x43,0x54,0x20,0x54,0x59,0x50
	.DB  0x45,0x3A,0x0,0x31,0x2D,0x72,0x65,0x63
	.DB  0x74,0x61,0x6E,0x67,0x6C,0x65,0x20,0x20
	.DB  0x32,0x2D,0x6C,0x69,0x6E,0x65,0x0,0x33
	.DB  0x2D,0x63,0x69,0x72,0x63,0x6C,0x65,0x20
	.DB  0x20,0x20,0x20,0x34,0x2D,0x73,0x65,0x63
	.DB  0x74,0x6F,0x72,0x0,0x31,0x2D,0x72,0x65
	.DB  0x63,0x74,0x61,0x6E,0x67,0x6C,0x65,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x32,0x2D,0x6C,0x69,0x6E,0x65
	.DB  0x0,0x33,0x2D,0x63,0x69,0x72,0x63,0x6C
	.DB  0x65,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x34,0x2D,0x73,0x65,0x63,0x74
	.DB  0x6F,0x72,0x0,0x45,0x4E,0x54,0x52,0x20
	.DB  0x44,0x41,0x54,0x41,0x20,0x26,0x20,0x50
	.DB  0x52,0x45,0x53,0x53,0x20,0x45,0x4E,0x0
	.DB  0x58,0x31,0x3D,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x59,0x31,0x3D,0x20
	.DB  0x20,0x20,0x20,0x0,0x58,0x32,0x3D,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x59,0x32,0x3D,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x52,0x61,0x64,0x69,0x75,0x73,0x3D
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x3C,0x31,0x3D
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x3C,0x32,0x3D,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x43,0x4F,0x4D,0x50,0x4C,0x45
	.DB  0x54,0x45,0x44,0x20,0x3D,0x3E,0x20,0x50
	.DB  0x52,0x45,0x53,0x53,0x20,0x3E,0x0,0x53
	.DB  0x56,0x3A,0x20,0x45,0x4E,0x0,0x44,0x41
	.DB  0x54,0x41,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x41,0x56,0x45,0x44
	.DB  0x21,0x0,0x5F,0x20,0x20,0x20,0x20,0x0
	.DB  0x57,0x52,0x4F,0x4E,0x47,0x20,0x0,0x5F
	.DB  0x20,0x20,0x20,0x0,0x25,0x64,0x20,0x20
	.DB  0x0,0x41,0x70,0x70,0x6C,0x79,0x69,0x6E
	.DB  0x67,0x20,0x63,0x69,0x72,0x63,0x6C,0x65
	.DB  0x2E,0x2E,0x2E,0x0,0x49,0x74,0x27,0x73
	.DB  0x20,0x6E,0x6F,0x74,0x20,0x61,0x76,0x61
	.DB  0x69,0x6C,0x61,0x62,0x6C,0x65,0x21,0x0
	.DB  0x41,0x70,0x70,0x6C,0x79,0x69,0x6E,0x67
	.DB  0x20,0x6C,0x69,0x6E,0x65,0x2E,0x2E,0x2E
	.DB  0x20,0x20,0x20,0x0,0x41,0x70,0x70,0x6C
	.DB  0x79,0x69,0x6E,0x67,0x20,0x73,0x65,0x63
	.DB  0x74,0x6F,0x72,0x2E,0x2E,0x2E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x14
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x3+20
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _0xB
	.DW  _0x0*2+35

	.DW  0x08
	.DW  _0xB+14
	.DW  _0x0*2+49

	.DW  0x14
	.DW  _0xB+22
	.DW  _0x0*2+57

	.DW  0x0A
	.DW  _0xB+42
	.DW  _0x0*2+77

	.DW  0x10
	.DW  _0xB+52
	.DW  _0x0*2+87

	.DW  0x0F
	.DW  _0xB+68
	.DW  _0x0*2+103

	.DW  0x0B
	.DW  _0xB+83
	.DW  _0x0*2+118

	.DW  0x0D
	.DW  _0xB+94
	.DW  _0x0*2+129

	.DW  0x15
	.DW  _0x2D
	.DW  _0x0*2+142

	.DW  0x04
	.DW  _0x2D+21
	.DW  _0x0*2+163

	.DW  0x14
	.DW  _0x2D+25
	.DW  _0x0*2+167

	.DW  0x06
	.DW  _0x32
	.DW  _0x0*2+195

	.DW  0x06
	.DW  _0x32+6
	.DW  _0x0*2+217

	.DW  0x07
	.DW  _0x32+12
	.DW  _0x0*2+223

	.DW  0x06
	.DW  _0x32+19
	.DW  _0x0*2+230

	.DW  0x07
	.DW  _0x32+25
	.DW  _0x0*2+236

	.DW  0x07
	.DW  _0x32+32
	.DW  _0x0*2+243

	.DW  0x0F
	.DW  _0x3D
	.DW  _0x0*2+103

	.DW  0x0C
	.DW  _0x3D+15
	.DW  _0x0*2+273

	.DW  0x11
	.DW  _0x3D+27
	.DW  _0x0*2+285

	.DW  0x07
	.DW  _0x3D+44
	.DW  _0x0*2+302

	.DW  0x15
	.DW  _0x3D+51
	.DW  _0x0*2+309

	.DW  0x11
	.DW  _0x3D+72
	.DW  _0x0*2+330

	.DW  0x0F
	.DW  _0x3D+89
	.DW  _0x0*2+347

	.DW  0x07
	.DW  _0x3D+104
	.DW  _0x0*2+362

	.DW  0x15
	.DW  _0x3D+111
	.DW  _0x0*2+369

	.DW  0x0F
	.DW  _0x47
	.DW  _0x0*2+103

	.DW  0x0C
	.DW  _0x47+15
	.DW  _0x0*2+390

	.DW  0x11
	.DW  _0x47+27
	.DW  _0x0*2+402

	.DW  0x0F
	.DW  _0x47+44
	.DW  _0x0*2+419

	.DW  0x0D
	.DW  _0x47+59
	.DW  _0x0*2+434

	.DW  0x13
	.DW  _0x47+72
	.DW  _0x0*2+447

	.DW  0x13
	.DW  _0x47+91
	.DW  _0x0*2+466

	.DW  0x09
	.DW  _0x47+110
	.DW  _0x0*2+485

	.DW  0x0F
	.DW  _0x47+119
	.DW  _0x0*2+419

	.DW  0x06
	.DW  _0x73
	.DW  _0x0*2+230

	.DW  0x07
	.DW  _0x73+6
	.DW  _0x0*2+223

	.DW  0x0D
	.DW  _0x73+13
	.DW  _0x0*2+494

	.DW  0x14
	.DW  _0x73+26
	.DW  _0x0*2+507

	.DW  0x15
	.DW  _0x73+46
	.DW  _0x0*2+527

	.DW  0x14
	.DW  _0x73+67
	.DW  _0x0*2+548

	.DW  0x15
	.DW  _0x73+87
	.DW  _0x0*2+568

	.DW  0x14
	.DW  _0x73+108
	.DW  _0x0*2+589

	.DW  0x15
	.DW  _0x73+128
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+149
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+170
	.DW  _0x0*2+609

	.DW  0x15
	.DW  _0x73+191
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+212
	.DW  _0x0*2+630

	.DW  0x15
	.DW  _0x73+233
	.DW  _0x0*2+651

	.DW  0x14
	.DW  _0x73+254
	.DW  _0x0*2+672

	.DW  0x15
	.DW  _0x73+274
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+295
	.DW  _0x0*2+692

	.DW  0x14
	.DW  _0x73+316
	.DW  _0x0*2+713

	.DW  0x15
	.DW  _0x73+336
	.DW  _0x0*2+733

	.DW  0x14
	.DW  _0x73+357
	.DW  _0x0*2+713

	.DW  0x15
	.DW  _0x73+377
	.DW  _0x0*2+754

	.DW  0x07
	.DW  _0x73+398
	.DW  _0x0*2+775

	.DW  0x15
	.DW  _0x73+405
	.DW  _0x0*2+782

	.DW  0x15
	.DW  _0x73+426
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+447
	.DW  _0x0*2+568

	.DW  0x15
	.DW  _0x73+468
	.DW  _0x0*2+568

	.DW  0x07
	.DW  _0x73+489
	.DW  _0x0*2+803

	.DW  0x06
	.DW  _0x93
	.DW  _0x0*2+810

	.DW  0x07
	.DW  _0x93+6
	.DW  _0x0*2+816

	.DW  0x05
	.DW  _0x93+13
	.DW  _0x0*2+823

	.DW  0x07
	.DW  _0x93+18
	.DW  _0x0*2+223

	.DW  0x07
	.DW  _0x93+25
	.DW  _0x0*2+816

	.DW  0x05
	.DW  _0x93+32
	.DW  _0x0*2+823

	.DW  0x07
	.DW  _0x93+37
	.DW  _0x0*2+223

	.DW  0x13
	.DW  _0xB5
	.DW  _0x0*2+833

	.DW  0x14
	.DW  _0xB5+19
	.DW  _0x0*2+852

	.DW  0x14
	.DW  _0xB6
	.DW  _0x0*2+872

	.DW  0x14
	.DW  _0xB6+20
	.DW  _0x0*2+852

	.DW  0x13
	.DW  _0xB7
	.DW  _0x0*2+892

	.DW  0x14
	.DW  _0xB7+19
	.DW  _0x0*2+852

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http: // www.hpinfotech.com
;Project :
;Version :
;Date    :
;Author  :
;Company :
;Comments:
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;//========================================LIBRARIES==========================================//
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <glcd.h>
;#include <font5x7.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;//====================================DEFINE FUNCTIONS=======================================//
;int keypad(void);
;void mainmenu(void);
;void about(void);
;void items(void);
;void mandd(void);
;void show(int num);
;void edit(int number);
;void apply(void);
;char value(char putx,char puty);
;void sethed(char varx1,char vary1,char varx2,char vary2);
;void applyR(int j);
;void applyL();
;void applyC();
;void applyS();
;//void defaultitems(void);
;//======================================GLOBAL VALUE========================================//
;flash char shift[4]= { 0xFE , 0xFD , 0xFB , 0xF7} ;
;eeprom char  store[5][6];
;eeprom int delay;
;flash char stepmove[8]={8,9,1,3,2,6,4,12};
;char rotateV=0,rotateH=0;
;//======================================MAIN FUNCTION========================================//
;void main(void)
; 0000 0033 {

	.CSEG
_main:
; .FSTART _main
; 0000 0034 int j=0;
; 0000 0035 GLCDINIT_t glcd_init_data;
; 0000 0036 
; 0000 0037 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	j -> R16,R17
;	glcd_init_data -> Y+0
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0038 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0039 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 003A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 003B DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 003C PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	OUT  0x15,R30
; 0000 003D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 003E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 003F // Timer/Counter 0 initialization
; 0000 0040 // Clock source: System Clock
; 0000 0041 // Clock value: Timer 0 Stopped
; 0000 0042 // Mode: Normal top=0xFF
; 0000 0043 // OC0 output: Disconnected
; 0000 0044 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0045 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0046 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0047 // Timer/Counter 1 initialization
; 0000 0048 // Clock source: System Clock
; 0000 0049 // Clock value: Timer1 Stopped
; 0000 004A // Mode: Normal top=0xFFFF
; 0000 004B // OC1A output: Disconnected
; 0000 004C // OC1B output: Disconnected
; 0000 004D // Noise Canceler: Off
; 0000 004E // Input Capture on Falling Edge
; 0000 004F // Timer1 Overflow Interrupt: Off
; 0000 0050 // Input Capture Interrupt: Off
; 0000 0051 // Compare A Match Interrupt: Off
; 0000 0052 // Compare B Match Interrupt: Off
; 0000 0053 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0054 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0055 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0056 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0057 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0058 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0059 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 005A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 005B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 005C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 005D // Timer/Counter 2 initialization
; 0000 005E // Clock source: System Clock
; 0000 005F // Clock value: Timer2 Stopped
; 0000 0060 // Mode: Normal top=0xFF
; 0000 0061 // OC2 output: Disconnected
; 0000 0062 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0063 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0064 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0065 OCR2=0x00;
	OUT  0x23,R30
; 0000 0066 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0067 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0068 // External Interrupt(s) initialization
; 0000 0069 // INT0: Off
; 0000 006A // INT1: Off
; 0000 006B // INT2: Off
; 0000 006C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 006D MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 006E // USART initialization
; 0000 006F // USART disabled
; 0000 0070 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0071 // Analog Comparator initialization
; 0000 0072 // Analog Comparator: Off
; 0000 0073 // The Analog Comparator's positive input is
; 0000 0074 // connected to the AIN0 pin
; 0000 0075 // The Analog Comparator's negative input is
; 0000 0076 // connected to the AIN1 pin
; 0000 0077 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0078 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0079 // ADC initialization
; 0000 007A // ADC disabled
; 0000 007B ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 007C // SPI initialization
; 0000 007D // SPI disabled
; 0000 007E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 007F // TWI initialization
; 0000 0080 // TWI disabled
; 0000 0081 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0082 // Graphic Display Controller initialization
; 0000 0083 // The KS0108 connections are specified in the
; 0000 0084 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0085 // DB0 - PORTA Bit 0
; 0000 0086 // DB1 - PORTA Bit 1
; 0000 0087 // DB2 - PORTA Bit 2
; 0000 0088 // DB3 - PORTA Bit 3
; 0000 0089 // DB4 - PORTA Bit 4
; 0000 008A // DB5 - PORTA Bit 5
; 0000 008B // DB6 - PORTA Bit 6
; 0000 008C // DB7 - PORTA Bit 7
; 0000 008D // E - PORTB Bit 0
; 0000 008E // RD /WR - PORTB Bit 1
; 0000 008F // RS - PORTB Bit 2
; 0000 0090 // /RST - PORTB Bit 3
; 0000 0091 // CS1 - PORTB Bit 4
; 0000 0092 // CS2 - PORTB Bit 5
; 0000 0093 // Specify the current font for displaying text
; 0000 0094 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0095 // No function is used for reading
; 0000 0096 // image data from external memory
; 0000 0097 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0098 // No function is used for writing
; 0000 0099 // image data to external memory
; 0000 009A glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 009B glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 009C                                                                 //welcome
; 0000 009D glcd_clear();
	CALL SUBOPT_0x0
; 0000 009E glcd_rectround(2,2,124,60, 5);
	CALL SUBOPT_0x1
; 0000 009F glcd_outtextxy(5,15, " IN THE NAME OF GOD");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	__POINTW2MN _0x3,0
	CALL SUBOPT_0x2
; 0000 00A0 glcd_outtextxy(5,25,"      WELCOME!");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x3,20
	CALL _glcd_outtextxy
; 0000 00A1 for(j=0;j<10;j++) {
	__GETWRN 16,17,0
_0x5:
	__CPWRN 16,17,10
	BRGE _0x6
; 0000 00A2    delay_ms(10);
	LDI  R26,LOW(10)
	CALL SUBOPT_0x3
; 0000 00A3    glcd_bar(10+10*j, 40, 20+10*j, 50);
	MULS R16,R26
	MOVW R30,R0
	CALL SUBOPT_0x4
; 0000 00A4 }
	__ADDWRN 16,17,1
	RJMP _0x5
_0x6:
; 0000 00A5 glcd_clear();
	CALL _glcd_clear
; 0000 00A6 
; 0000 00A7 //defaultitems();
; 0000 00A8 while (1)
_0x7:
; 0000 00A9       {
; 0000 00AA           mainmenu();
	RCALL _mainmenu
; 0000 00AB       }
	RJMP _0x7
; 0000 00AC }
_0xA:
	RJMP _0xA
; .FEND

	.DSEG
_0x3:
	.BYTE 0x23
;//=====================================MENU FUNCTION========================================//
;void mainmenu(void){
; 0000 00AE void mainmenu(void){

	.CSEG
_mainmenu:
; .FSTART _mainmenu
; 0000 00AF int j=0;
; 0000 00B0 glcd_clear();
	CALL SUBOPT_0x5
;	j -> R16,R17
; 0000 00B1 glcd_outtextxy(4,5,"ENTER  MOOD :");
	__POINTW2MN _0xB,0
	CALL SUBOPT_0x6
; 0000 00B2 glcd_rectround(2,20,124,55, 2);
	CALL SUBOPT_0x7
; 0000 00B3 glcd_outtextxy(5,25,"1.ITEMS");
	__POINTW2MN _0xB,14
	CALL SUBOPT_0x2
; 0000 00B4 glcd_outtextxy(5,35,"2.MOTOR & DIMENSION");
	LDI  R30,LOW(35)
	ST   -Y,R30
	__POINTW2MN _0xB,22
	CALL SUBOPT_0x2
; 0000 00B5 glcd_outtextxy(5,45,"3.APPLY !");
	LDI  R30,LOW(45)
	ST   -Y,R30
	__POINTW2MN _0xB,42
	CALL SUBOPT_0x2
; 0000 00B6 glcd_outtextxy(5,55,"4.ABOUT PROJECT");
	LDI  R30,LOW(55)
	ST   -Y,R30
	__POINTW2MN _0xB,52
	CALL SUBOPT_0x8
; 0000 00B7   j=keypad();
; 0000 00B8   switch(j){
	MOVW R30,R16
; 0000 00B9     case 0:
	SBIW R30,0
	BRNE _0xF
; 0000 00BA         glcd_clear();
	CALL _glcd_clear
; 0000 00BB         glcd_outtextxy(4,5,"PLEASE SELECT:");
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0xB,68
	CALL SUBOPT_0x6
; 0000 00BC         glcd_rectround(2,20,124,45, 2);
	CALL SUBOPT_0x9
; 0000 00BD         glcd_outtextxy(5,25,"1.SHOW ALL");
	__POINTW2MN _0xB,83
	CALL SUBOPT_0x2
; 0000 00BE         glcd_outtextxy(5,35,"2.SHOW ITEMS");
	LDI  R30,LOW(35)
	ST   -Y,R30
	__POINTW2MN _0xB,94
	CALL SUBOPT_0x8
; 0000 00BF         j=keypad();
; 0000 00C0         glcd_clear();
	CALL _glcd_clear
; 0000 00C1         if(j==0){
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x10
; 0000 00C2             show(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL SUBOPT_0xA
; 0000 00C3             delay_ms(500);
; 0000 00C4         }
; 0000 00C5         else if (j==1){
	RJMP _0x11
_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x12
; 0000 00C6             items();
	RCALL _items
; 0000 00C7         }
; 0000 00C8         break;
_0x12:
_0x11:
	RJMP _0xE
; 0000 00C9     case 1:
_0xF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x13
; 0000 00CA         mandd();
	RCALL _mandd
; 0000 00CB         break;
	RJMP _0xE
; 0000 00CC     case 2:
_0x13:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14
; 0000 00CD        apply();
	RCALL _apply
; 0000 00CE         break;
	RJMP _0xE
; 0000 00CF     case 3:
_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE
; 0000 00D0         about();
	RCALL _about
; 0000 00D1   }
_0xE:
; 0000 00D2 }
	RJMP _0x2120017
; .FEND

	.DSEG
_0xB:
	.BYTE 0x6B
;//====================================KEYPAD FUNCTION=======================================//
;int keypad(void){
; 0000 00D4 int keypad(void){

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 00D5 int i=0,column=0,temp=16;
; 0000 00D6 while(1){
	CALL __SAVELOCR6
;	i -> R16,R17
;	column -> R18,R19
;	temp -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,16
_0x16:
; 0000 00D7             for  (i=0;i<4;i++){
	__GETWRN 16,17,0
_0x1A:
	__CPWRN 16,17,4
	BRGE _0x1B
; 0000 00D8             PORTC = shift[i] ;
	MOVW R30,R16
	SUBI R30,LOW(-_shift*2)
	SBCI R31,HIGH(-_shift*2)
	LPM  R0,Z
	OUT  0x15,R0
; 0000 00D9             delay_us(10);
	__DELAY_USB 27
; 0000 00DA             if(PINC.4==0){column=0;while(PINC.4==0){}return i*4 + column;}
	SBIC 0x13,4
	RJMP _0x1C
	__GETWRN 18,19,0
_0x1D:
	SBIS 0x13,4
	RJMP _0x1D
	CALL SUBOPT_0xB
	RJMP _0x2120018
; 0000 00DB             if(PINC.5==0){column=1;while(PINC.5==0){}temp=i*4 + column;if(temp==9){temp=-1;}return temp;}
_0x1C:
	SBIC 0x13,5
	RJMP _0x20
	__GETWRN 18,19,1
_0x21:
	SBIS 0x13,5
	RJMP _0x21
	CALL SUBOPT_0xB
	MOVW R20,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x24
	__GETWRN 20,21,-1
_0x24:
	MOVW R30,R20
	RJMP _0x2120018
; 0000 00DC             if(PINC.6==0){column=2;while(PINC.6==0){}return i*4 + column;}
_0x20:
	SBIC 0x13,6
	RJMP _0x25
	__GETWRN 18,19,2
_0x26:
	SBIS 0x13,6
	RJMP _0x26
	CALL SUBOPT_0xB
	RJMP _0x2120018
; 0000 00DD             if(PINC.7==0){column=3;while(PINC.7==0){}return i*4 + column;}
_0x25:
	SBIC 0x13,7
	RJMP _0x29
	__GETWRN 18,19,3
_0x2A:
	SBIS 0x13,7
	RJMP _0x2A
	CALL SUBOPT_0xB
	RJMP _0x2120018
; 0000 00DE             }
_0x29:
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1B:
; 0000 00DF         }
	RJMP _0x16
; 0000 00E0 }
_0x2120018:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;//====================================ABOUT FUNCTION========================================//
;void about(void){
; 0000 00E2 void about(void){
_about:
; .FSTART _about
; 0000 00E3 glcd_clear();
	CALL SUBOPT_0xC
; 0000 00E4 glcd_rectround(1,1,126,62, 5);
; 0000 00E5 glcd_outtextxy(5,10,"CONTROL LISER CUTTER");
	__POINTW2MN _0x2D,0
	CALL _glcd_outtextxy
; 0000 00E6 glcd_outtextxy(55,30,"BY:");
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x2D,21
	CALL _glcd_outtextxy
; 0000 00E7 glcd_outtextxy(7,40,"MOHAMMAD JAVAD ADEL");
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x2D,25
	CALL _glcd_outtextxy
; 0000 00E8 delay_ms(800);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	CALL SUBOPT_0xD
; 0000 00E9 glcd_clear();
; 0000 00EA }
	RET
; .FEND

	.DSEG
_0x2D:
	.BYTE 0x2D
;//====================================ITEMS FUNCTION=========================================//
;void items(void){
; 0000 00EC void items(void){

	.CSEG
_items:
; .FSTART _items
; 0000 00ED int j=0,adad=1;
; 0000 00EE char flag1=1,flag2=1,itm[15];
; 0000 00EF while(flag1){
	SBIW R28,15
	CALL __SAVELOCR6
;	j -> R16,R17
;	adad -> R18,R19
;	flag1 -> R21
;	flag2 -> R20
;	itm -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,1
	LDI  R21,1
	LDI  R20,1
_0x2E:
	CPI  R21,0
	BRNE PC+2
	RJMP _0x30
; 0000 00F0 if(flag2==1){
	CPI  R20,1
	BREQ PC+2
	RJMP _0x31
; 0000 00F1 glcd_clear();
	CALL SUBOPT_0xE
; 0000 00F2 glcd_rectround(0,0,42,15,2);
	CALL SUBOPT_0xF
; 0000 00F3 glcd_rectround(42,0,43,15,2);
	CALL SUBOPT_0x10
; 0000 00F4 glcd_rectround(85,0,42,15,2);
; 0000 00F5 glcd_rectround(0,16,128,33, 2);
	CALL SUBOPT_0x11
	LDI  R30,LOW(33)
	CALL SUBOPT_0x12
; 0000 00F6 glcd_rectround(0,50,42,15,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 00F7 glcd_rectround(42,50,43,15,2);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(15)
	CALL SUBOPT_0x12
; 0000 00F8 glcd_rectround(85,50,42,15,2);
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 00F9 sprintf(itm,"ITEM %d",adad);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 00FA glcd_outtextxy(43,3,itm);
; 0000 00FB glcd_outtextxy(2,20,"DATA:");
	CALL SUBOPT_0x15
	__POINTW2MN _0x32,0
	CALL SUBOPT_0x16
; 0000 00FC sprintf(itm," '%c' ",store[adad-1][0]);
	CALL SUBOPT_0x17
; 0000 00FD glcd_outtextxy(60,20,itm);
; 0000 00FE sprintf(itm,"%d %d %d",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
	__POINTW1FN _0x0,208
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 00FF glcd_outtextxy(30,30,itm);
; 0000 0100 sprintf(itm,"%d %d",store[adad-1][4],store[adad-1][5]);
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
; 0000 0101 glcd_outtextxy(35,40,itm);
; 0000 0102 glcd_outtextxy(3,3,"< PRE");
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x32,6
	CALL SUBOPT_0x1B
; 0000 0103 glcd_outtextxy(87,3,"NEXT >");
	LDI  R30,LOW(3)
	ST   -Y,R30
	__POINTW2MN _0x32,12
	CALL SUBOPT_0x1C
; 0000 0104 glcd_outtextxy(2,53," BacK");
	LDI  R30,LOW(53)
	ST   -Y,R30
	__POINTW2MN _0x32,19
	CALL _glcd_outtextxy
; 0000 0105 glcd_outtextxy(44,53,"* SHOW");
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R30,LOW(53)
	ST   -Y,R30
	__POINTW2MN _0x32,25
	CALL SUBOPT_0x1B
; 0000 0106 glcd_outtextxy(87,53,"/ EDIT");
	LDI  R30,LOW(53)
	ST   -Y,R30
	__POINTW2MN _0x32,32
	CALL _glcd_outtextxy
; 0000 0107 }
; 0000 0108 j=keypad();
_0x31:
	RCALL _keypad
	MOVW R16,R30
; 0000 0109 switch(j){
; 0000 010A     case 15:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x36
; 0000 010B         glcd_clear();
	CALL _glcd_clear
; 0000 010C         edit(adad-1);
	MOVW R26,R18
	SBIW R26,1
	RCALL _edit
; 0000 010D         flag2=1;
	LDI  R20,LOW(1)
; 0000 010E         break;
	RJMP _0x35
; 0000 010F     case 14:
_0x36:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x37
; 0000 0110         glcd_clear();
	CALL _glcd_clear
; 0000 0111         show(adad-1);
	MOVW R26,R18
	SBIW R26,1
	CALL SUBOPT_0xA
; 0000 0112         delay_ms(500);
; 0000 0113         flag2=1;
	LDI  R20,LOW(1)
; 0000 0114         break;
	RJMP _0x35
; 0000 0115     case 13:
_0x37:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x38
; 0000 0116         adad--;
	__SUBWRN 18,19,1
; 0000 0117         if(adad<1){
	__CPWRN 18,19,1
	BRGE _0x39
; 0000 0118             adad=5;
	__GETWRN 18,19,5
; 0000 0119         }
; 0000 011A         flag2=0;
_0x39:
	LDI  R20,LOW(0)
; 0000 011B         sprintf(itm,"ITEM %d",adad);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 011C         glcd_outtextxy(43,3,itm);
; 0000 011D         sprintf(itm," '%c' ",store[adad-1][0]);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x17
; 0000 011E         glcd_outtextxy(60,20,itm);
; 0000 011F         sprintf(itm,"%d %d %d   ",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 0120         glcd_outtextxy(30,30,itm);
; 0000 0121         sprintf(itm,"%d %d     ",store[adad-1][4],store[adad-1][5]);
	__POINTW1FN _0x0,262
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
; 0000 0122         glcd_outtextxy(35,40,itm);
; 0000 0123         break;
	RJMP _0x35
; 0000 0124     case 12:
_0x38:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x3A
; 0000 0125         adad++;
	__ADDWRN 18,19,1
; 0000 0126         if(adad>5){
	__CPWRN 18,19,6
	BRLT _0x3B
; 0000 0127             adad=1;
	__GETWRN 18,19,1
; 0000 0128         }
; 0000 0129         flag2=0;
_0x3B:
	LDI  R20,LOW(0)
; 0000 012A         sprintf(itm,"ITEM %d",adad);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 012B         glcd_outtextxy(43,3,itm);
; 0000 012C         sprintf(itm," '%c' ",store[adad-1][0]);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x17
; 0000 012D         glcd_outtextxy(60,20,itm);
; 0000 012E         sprintf(itm,"%d %d %d   ",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 012F         glcd_outtextxy(30,30,itm);
; 0000 0130         sprintf(itm,"%d %d     ",store[adad-1][4],store[adad-1][5]);
	__POINTW1FN _0x0,262
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
; 0000 0131         glcd_outtextxy(35,40,itm);
; 0000 0132         break;
	RJMP _0x35
; 0000 0133     case 10:
_0x3A:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x35
; 0000 0134         flag1=0;
	LDI  R21,LOW(0)
; 0000 0135         flag2=0;
	LDI  R20,LOW(0)
; 0000 0136         break;
; 0000 0137 }
_0x35:
; 0000 0138 }
	RJMP _0x2E
_0x30:
; 0000 0139 }
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.DSEG
_0x32:
	.BYTE 0x27
;//==============================SPEED & DIMENSIONS FUNCTION==================================//
;void mandd(void){
; 0000 013B void mandd(void){

	.CSEG
_mandd:
; .FSTART _mandd
; 0000 013C int j=0;
; 0000 013D glcd_clear();
	CALL SUBOPT_0x5
;	j -> R16,R17
; 0000 013E glcd_outtextxy(4,5,"PLEASE SELECT:");
	__POINTW2MN _0x3D,0
	CALL SUBOPT_0x6
; 0000 013F glcd_rectround(2,20,124,55, 2);
	CALL SUBOPT_0x7
; 0000 0140 glcd_outtextxy(5,25,"1.SET SPEED");
	__POINTW2MN _0x3D,15
	CALL SUBOPT_0x2
; 0000 0141 glcd_outtextxy(5,35,"2.SET DIMENSIONS");
	LDI  R30,LOW(35)
	ST   -Y,R30
	__POINTW2MN _0x3D,27
	CALL SUBOPT_0x2
; 0000 0142 glcd_outtextxy(5,45,"3.BACK");
	LDI  R30,LOW(45)
	ST   -Y,R30
	__POINTW2MN _0x3D,44
	CALL SUBOPT_0x8
; 0000 0143   j=keypad();
; 0000 0144   switch(j){
	MOVW R30,R16
; 0000 0145     case 0:
	SBIW R30,0
	BRNE _0x41
; 0000 0146         glcd_clear();
	CALL SUBOPT_0x0
; 0000 0147         glcd_rectround(2,2,124,63, 2);
	LDI  R30,LOW(63)
	CALL SUBOPT_0x12
; 0000 0148         glcd_outtextxy(5,10,"ENTER NEW VALUE(ms):");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2MN _0x3D,51
	CALL SUBOPT_0x2
; 0000 0149         glcd_outtextxy(5,20,"THEN PRESS   ""EN"" ");
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x3D,72
	CALL SUBOPT_0x2
; 0000 014A         delay=value(5,30);
	LDI  R26,LOW(30)
	RCALL _value
	LDI  R26,LOW(_delay)
	LDI  R27,HIGH(_delay)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 014B         break;
	RJMP _0x40
; 0000 014C     case 1:
_0x41:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x42
; 0000 014D         glcd_clear();
	CALL SUBOPT_0x0
; 0000 014E         glcd_rectround(2,2,124,63, 2);
	LDI  R30,LOW(63)
	CALL SUBOPT_0x12
; 0000 014F         glcd_outtextxy(20,10,"THE DEFAUT IS:");
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2MN _0x3D,89
	CALL _glcd_outtextxy
; 0000 0150         glcd_outtextxy(45,30,"128*64");
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x3D,104
	CALL SUBOPT_0x2
; 0000 0151         glcd_outtextxy(5,50,"THIS IS UNCHANGEABLE");
	LDI  R30,LOW(50)
	ST   -Y,R30
	__POINTW2MN _0x3D,111
	CALL _glcd_outtextxy
; 0000 0152         delay_ms(500);
	CALL SUBOPT_0x1D
; 0000 0153         break;
; 0000 0154     case 2:
_0x42:
; 0000 0155         break;
; 0000 0156   }
_0x40:
; 0000 0157 
; 0000 0158 }
_0x2120017:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x3D:
	.BYTE 0x84
;//====================================APPLY FUNCTION=========================================//
;void apply(void){
; 0000 015A void apply(void){

	.CSEG
_apply:
; .FSTART _apply
; 0000 015B int j=0;
; 0000 015C char flag=1,temp=0;
; 0000 015D glcd_clear();
	CALL __SAVELOCR4
;	j -> R16,R17
;	flag -> R19
;	temp -> R18
	__GETWRN 16,17,0
	LDI  R19,1
	LDI  R18,0
	CALL _glcd_clear
; 0000 015E while(1){
_0x44:
; 0000 015F glcd_outtextxy(4,5,"PLEASE SELECT:");
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x47,0
	CALL SUBOPT_0x6
; 0000 0160 glcd_rectround(2,20,124,45, 2);
	CALL SUBOPT_0x9
; 0000 0161 glcd_outtextxy(5,25,"1.APPLY ALL");
	__POINTW2MN _0x47,15
	CALL SUBOPT_0x2
; 0000 0162 glcd_outtextxy(5,35,"2.APPLY ONE ITEM");
	LDI  R30,LOW(35)
	ST   -Y,R30
	__POINTW2MN _0x47,27
	CALL SUBOPT_0x8
; 0000 0163 j=keypad();
; 0000 0164 if(j==0){
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x48
; 0000 0165     glcd_clear();
	CALL SUBOPT_0x0
; 0000 0166     glcd_rectround(2,2,124,60, 5);
	CALL SUBOPT_0x1
; 0000 0167     glcd_outtextxy(20,20, " APPLYING... !");
	LDI  R30,LOW(20)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x47,44
	CALL _glcd_outtextxy
; 0000 0168     for(temp=0;temp<10;temp++) {
	LDI  R18,LOW(0)
_0x4A:
	CPI  R18,10
	BRSH _0x4B
; 0000 0169         delay_ms(20);
	LDI  R26,LOW(20)
	CALL SUBOPT_0x3
; 0000 016A         glcd_bar(10+10*temp, 40, 20+10*temp, 50);
	MULS R18,R26
	MOVW R30,R0
	CALL SUBOPT_0x4
; 0000 016B         }
	SUBI R18,-1
	RJMP _0x4A
_0x4B:
; 0000 016C     glcd_clear();
	CALL _glcd_clear
; 0000 016D     for(j=0;j<5;j++){
	__GETWRN 16,17,0
_0x4D:
	__CPWRN 16,17,5
	BRGE _0x4E
; 0000 016E     temp=store[j][0];
	CALL SUBOPT_0x1E
; 0000 016F         switch(temp){
; 0000 0170             case 'R':
	BRNE _0x52
; 0000 0171                 applyR(j);
	MOVW R26,R16
	RCALL _applyR
; 0000 0172                 delay_ms(500);
	CALL SUBOPT_0x1D
; 0000 0173                 break;
	RJMP _0x51
; 0000 0174             case 'L':
_0x52:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x53
; 0000 0175                 applyL();
	RCALL _applyL
; 0000 0176                 break;
	RJMP _0x51
; 0000 0177             case 'C':
_0x53:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x54
; 0000 0178                 applyC();
	RCALL _applyC
; 0000 0179                 break;
	RJMP _0x51
; 0000 017A             case 'S':
_0x54:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x51
; 0000 017B                 applyS();
	RCALL _applyS
; 0000 017C                 break;
; 0000 017D         }
_0x51:
; 0000 017E         }
	__ADDWRN 16,17,1
	RJMP _0x4D
_0x4E:
; 0000 017F     break;
	RJMP _0x46
; 0000 0180 }
; 0000 0181 else if (j==1){
_0x48:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x57
; 0000 0182     while(flag){
_0x58:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x5A
; 0000 0183     glcd_clear();
	CALL SUBOPT_0xE
; 0000 0184     glcd_rectround(0,0,128,64, 5);
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _glcd_rectround
; 0000 0185     glcd_outtextxy(2,20,"SELECT ITEM:");
	CALL SUBOPT_0x15
	__POINTW2MN _0x47,59
	CALL SUBOPT_0x1C
; 0000 0186     glcd_outtextxy(2,30,"1)ITEM 1  2)ITEM 2");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x47,72
	CALL SUBOPT_0x1C
; 0000 0187     glcd_outtextxy(2,40,"3)ITEM 3  4)ITEM 4");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x47,91
	CALL SUBOPT_0x1C
; 0000 0188     glcd_outtextxy(2,50,"5)ITEM 5");
	LDI  R30,LOW(50)
	ST   -Y,R30
	__POINTW2MN _0x47,110
	CALL SUBOPT_0x8
; 0000 0189     j=keypad();
; 0000 018A     if(j<=4 && j>=0){
	__CPWRN 16,17,5
	BRGE _0x5C
	TST  R17
	BRPL _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
; 0000 018B         glcd_clear();
	CALL SUBOPT_0x0
; 0000 018C         glcd_rectround(2,2,124,60, 5);
	CALL SUBOPT_0x1
; 0000 018D         glcd_outtextxy(20,20, " APPLYING... !");
	LDI  R30,LOW(20)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x47,119
	CALL _glcd_outtextxy
; 0000 018E         for(temp=0;temp<10;temp++) {
	LDI  R18,LOW(0)
_0x5F:
	CPI  R18,10
	BRSH _0x60
; 0000 018F             delay_ms(20);
	LDI  R26,LOW(20)
	CALL SUBOPT_0x3
; 0000 0190             glcd_bar(10+10*temp, 40, 20+10*temp, 50);
	MULS R18,R26
	MOVW R30,R0
	CALL SUBOPT_0x4
; 0000 0191             }
	SUBI R18,-1
	RJMP _0x5F
_0x60:
; 0000 0192         }
; 0000 0193         glcd_clear();
_0x5B:
	CALL _glcd_clear
; 0000 0194         flag=0;
	LDI  R19,LOW(0)
; 0000 0195         temp=store[j][0];
	CALL SUBOPT_0x1E
; 0000 0196         switch(temp){
; 0000 0197             case 'R':
	BRNE _0x64
; 0000 0198                 applyR(j);
	MOVW R26,R16
	RCALL _applyR
; 0000 0199                 delay_ms(500);
	CALL SUBOPT_0x1D
; 0000 019A                 break;
	RJMP _0x63
; 0000 019B             case 'L':
_0x64:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x65
; 0000 019C                 applyL();
	RCALL _applyL
; 0000 019D                 break;
	RJMP _0x63
; 0000 019E             case 'C':
_0x65:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x66
; 0000 019F                 applyC();
	RCALL _applyC
; 0000 01A0                 break;
	RJMP _0x63
; 0000 01A1             case 'S':
_0x66:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x63
; 0000 01A2                 applyS();
	RCALL _applyS
; 0000 01A3                 break;
; 0000 01A4         }
_0x63:
; 0000 01A5     }
	RJMP _0x58
_0x5A:
; 0000 01A6 break;
	RJMP _0x46
; 0000 01A7 }
; 0000 01A8 }
_0x57:
	RJMP _0x44
_0x46:
; 0000 01A9 }
	JMP  _0x2120014
; .FEND

	.DSEG
_0x47:
	.BYTE 0x86
;//=================================INITIAL ITEMS FUNCTION=====================================//
;/*
;void defaultitems(void){
;store[0][0]='R';
;store[0][1]=10;x1
;store[0][2]=30;  y1
;store[0][3]=80;    x2
;store[0][4]=50;      y2
;store[0][5]=' ';
;
;store[1][0]='L';
;store[1][1]=100;
;store[1][2]=10;
;store[1][3]=10;
;store[1][4]=60;
;store[1][5]=' ';
;
;store[2][0]='C';
;store[2][1]=40;
;store[2][2]=40;
;store[2][3]=20;
;store[2][4]=' ';
;store[2][5]=' ';
;
;store[3][0]='S';
;store[3][1]=60;
;store[3][2]=30;
;store[3][3]=0;
;store[3][4]=120;
;store[3][5]=20;
;
;store[4][0]='S';
;store[4][1]=60;
;store[4][2]=30;
;store[4][3]=20;
;store[4][4]=120;
;store[4][5]=20;
;
;delay=50;
;}
;*/
;//====================================SHOW FUNCTION=========================================//
;void show(int num){
; 0000 01D4 void show(int num){

	.CSEG
_show:
; .FSTART _show
; 0000 01D5 char type,counter=0;
; 0000 01D6 type=store[num][0];
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+2
;	type -> R17
;	counter -> R16
	LDI  R16,0
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-_store)
	SBCI R31,HIGH(-_store)
	CALL SUBOPT_0x20
; 0000 01D7 switch (type){
	MOV  R30,R17
	LDI  R31,0
; 0000 01D8     case 'R':
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x6B
; 0000 01D9         glcd_rectangle(store[num][1],store[num][2],store[num][3],store[num][4]);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL _glcd_rectangle
; 0000 01DA         break;
	RJMP _0x6A
; 0000 01DB     case 'L':
_0x6B:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x6C
; 0000 01DC         glcd_line(store[num][1],store[num][2],store[num][3],store[num][4]);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL _glcd_line
; 0000 01DD         break;
	RJMP _0x6A
; 0000 01DE     case 'C':
_0x6C:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x6D
; 0000 01DF         glcd_circle(store[num][1],store[num][2],store[num][3]);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
	MOV  R26,R30
	CALL _glcd_circle
; 0000 01E0         break;
	RJMP _0x6A
; 0000 01E1     case 'S':
_0x6D:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x6A
; 0000 01E2         glcd_arc(store[num][1],store[num][2],store[num][3],store[num][4],store[num][5]);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x23
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,5
	CALL SUBOPT_0x24
	CALL _glcd_arc
; 0000 01E3         break;
; 0000 01E4 }
_0x6A:
; 0000 01E5 if(num==5){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,5
	BRNE _0x6F
; 0000 01E6 for(counter=0;counter<5;counter++){
	LDI  R16,LOW(0)
_0x71:
	CPI  R16,5
	BRSH _0x72
; 0000 01E7 show(counter);
	MOV  R26,R16
	CLR  R27
	RCALL _show
; 0000 01E8 }
	SUBI R16,-1
	RJMP _0x71
_0x72:
; 0000 01E9 }
; 0000 01EA }
_0x6F:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120013
; .FEND
;//=====================================EDIT FUNCTION=========================================//
;void edit(int number){
; 0000 01EC void edit(int number){
_edit:
; .FSTART _edit
; 0000 01ED char flag=1,itm[15],buffer[6];
; 0000 01EE int j=0;
; 0000 01EF glcd_rectround(0,0,42,15,2);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,21
	CALL __SAVELOCR4
;	number -> Y+25
;	flag -> R17
;	itm -> Y+10
;	buffer -> Y+4
;	j -> R18,R19
	LDI  R17,1
	__GETWRN 18,19,0
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 01F0 glcd_rectround(42,0,43,15,2);
	CALL SUBOPT_0x10
; 0000 01F1 glcd_rectround(85,0,42,15,2);
; 0000 01F2 glcd_outtextxy(3,3," BacK");
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x73,0
	CALL SUBOPT_0x1B
; 0000 01F3 glcd_outtextxy(87,3,"NEXT >");
	LDI  R30,LOW(3)
	ST   -Y,R30
	__POINTW2MN _0x73,6
	CALL SUBOPT_0x25
; 0000 01F4 sprintf(itm,"ITEM %d",number+1);
	__POINTW1FN _0x0,187
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ADIW R30,1
	CALL SUBOPT_0x26
; 0000 01F5 glcd_outtextxy(43,3,itm);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	CALL _glcd_outtextxy
; 0000 01F6 glcd_rectround(0,16,128,48, 2);
	CALL SUBOPT_0x11
	LDI  R30,LOW(48)
	CALL SUBOPT_0x12
; 0000 01F7 while(flag>0){
_0x74:
	CPI  R17,1
	BRSH PC+2
	RJMP _0x76
; 0000 01F8 switch(flag){
	MOV  R30,R17
	LDI  R31,0
; 0000 01F9     case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x7A
; 0000 01FA         glcd_outtextxy(2,20,"SELECT TYPE:");
	CALL SUBOPT_0x15
	__POINTW2MN _0x73,13
	CALL SUBOPT_0x1C
; 0000 01FB         glcd_outtextxy(2,30,"1-rectangle  2-line");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x73,26
	CALL SUBOPT_0x1C
; 0000 01FC         glcd_outtextxy(2,40,"3-circle    4-sector");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,46
	CALL SUBOPT_0x27
; 0000 01FD         j=keypad();
; 0000 01FE         switch(j){
	MOVW R30,R18
; 0000 01FF             case 0:
	SBIW R30,0
	BRNE _0x7E
; 0000 0200                 buffer[0]='R';
	LDI  R30,LOW(82)
	CALL SUBOPT_0x28
; 0000 0201                 glcd_outtextxy(2,30,"1-rectangle        ");
	__POINTW2MN _0x73,67
	CALL SUBOPT_0x1C
; 0000 0202                 glcd_outtextxy(2,40,"                    ");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,87
	RJMP _0xD0
; 0000 0203                 break;
; 0000 0204             case 1:
_0x7E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7F
; 0000 0205                 buffer[0]='L';
	LDI  R30,LOW(76)
	CALL SUBOPT_0x28
; 0000 0206                 glcd_outtextxy(2,30,"             2-line");
	__POINTW2MN _0x73,108
	CALL SUBOPT_0x1C
; 0000 0207                 glcd_outtextxy(2,40,"                    ");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,128
	RJMP _0xD0
; 0000 0208                 break;
; 0000 0209             case 2:
_0x7F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x80
; 0000 020A                 buffer[0]='C';
	LDI  R30,LOW(67)
	CALL SUBOPT_0x28
; 0000 020B                 glcd_outtextxy(2,30,"                    ");
	__POINTW2MN _0x73,149
	CALL SUBOPT_0x1C
; 0000 020C                 glcd_outtextxy(2,40,"3-circle            ");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,170
	RJMP _0xD0
; 0000 020D                 break;
; 0000 020E             case 3:
_0x80:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7D
; 0000 020F                 buffer[0]='S';
	LDI  R30,LOW(83)
	CALL SUBOPT_0x28
; 0000 0210                 glcd_outtextxy(2,30,"                    ");
	__POINTW2MN _0x73,191
	CALL SUBOPT_0x1C
; 0000 0211                 glcd_outtextxy(2,40,"            4-sector");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,212
_0xD0:
	CALL _glcd_outtextxy
; 0000 0212                 break;
; 0000 0213         }
_0x7D:
; 0000 0214         j=keypad();
	RCALL _keypad
	MOVW R18,R30
; 0000 0215         if(j==12){
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x82
; 0000 0216             flag++;
	SUBI R17,-1
; 0000 0217         }
; 0000 0218         break;
_0x82:
	RJMP _0x79
; 0000 0219     case  2:
_0x7A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x83
; 0000 021A         glcd_outtextxy(2,20,"ENTR DATA & PRESS EN");
	CALL SUBOPT_0x15
	__POINTW2MN _0x73,233
	CALL SUBOPT_0x1C
; 0000 021B         glcd_outtextxy(2,30,"X1=         Y1=    ");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x73,254
	CALL SUBOPT_0x1C
; 0000 021C         glcd_outtextxy(2,40,"                    ");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x73,274
	CALL SUBOPT_0x29
; 0000 021D         buffer[1]=value(25,30);
	LDI  R26,LOW(30)
	RCALL _value
	STD  Y+5,R30
; 0000 021E         buffer[2]=value(95,30);
	LDI  R30,LOW(95)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _value
	STD  Y+6,R30
; 0000 021F         if(buffer[0]=='R' || buffer[0]=='L'){
	LDD  R26,Y+4
	CPI  R26,LOW(0x52)
	BREQ _0x85
	CPI  R26,LOW(0x4C)
	BRNE _0x84
_0x85:
; 0000 0220         glcd_outtextxy(2,40,"X2=         Y2=     ");
	CALL SUBOPT_0x2A
	__POINTW2MN _0x73,295
	CALL SUBOPT_0x29
; 0000 0221         buffer[3]=value(25,40);
	LDI  R26,LOW(40)
	RCALL _value
	STD  Y+7,R30
; 0000 0222         buffer[4]=value(95,40);
	LDI  R30,LOW(95)
	ST   -Y,R30
	LDI  R26,LOW(40)
	RCALL _value
	STD  Y+8,R30
; 0000 0223         }
; 0000 0224         else if(buffer[0]=='C'){
	RJMP _0x87
_0x84:
	LDD  R26,Y+4
	CPI  R26,LOW(0x43)
	BRNE _0x88
; 0000 0225         glcd_outtextxy(2,40,"Radius=            ");
	CALL SUBOPT_0x2A
	__POINTW2MN _0x73,316
	CALL SUBOPT_0x2B
; 0000 0226         buffer[3]=value(50,50);
	STD  Y+7,R30
; 0000 0227         }
; 0000 0228         else if(buffer[0]=='S'){
	RJMP _0x89
_0x88:
	LDD  R26,Y+4
	CPI  R26,LOW(0x53)
	BRNE _0x8A
; 0000 0229         glcd_outtextxy(2,40,"<1=         <2=     ");
	CALL SUBOPT_0x2A
	__POINTW2MN _0x73,336
	CALL SUBOPT_0x29
; 0000 022A         buffer[3]=value(25,40);
	LDI  R26,LOW(40)
	RCALL _value
	STD  Y+7,R30
; 0000 022B         buffer[4]=value(97,40);
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDI  R26,LOW(40)
	RCALL _value
	STD  Y+8,R30
; 0000 022C         glcd_outtextxy(2,50,"Radius=            ");
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	__POINTW2MN _0x73,357
	CALL SUBOPT_0x2B
; 0000 022D         buffer[5]=value(50,50);
	STD  Y+9,R30
; 0000 022E         }
; 0000 022F         glcd_outtextxy(2,20,"COMPLETED => PRESS >");
_0x8A:
_0x89:
_0x87:
	CALL SUBOPT_0x15
	__POINTW2MN _0x73,377
	CALL SUBOPT_0x27
; 0000 0230         j=keypad();
; 0000 0231         if(j==12){
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x8B
; 0000 0232             flag++;
	SUBI R17,-1
; 0000 0233         }
; 0000 0234         break;
_0x8B:
	RJMP _0x79
; 0000 0235     case 3:
_0x83:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x79
; 0000 0236         glcd_outtextxy(87,3,"SV: EN");
	CALL SUBOPT_0x2C
	__POINTW2MN _0x73,398
	CALL _glcd_outtextxy
; 0000 0237         glcd_outtextxy(2,20,"DATA:               ");
	CALL SUBOPT_0x15
	__POINTW2MN _0x73,405
	CALL SUBOPT_0x25
; 0000 0238         sprintf(itm," '%c' ",buffer[0]);
	__POINTW1FN _0x0,201
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	CALL SUBOPT_0x2D
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0239         glcd_outtextxy(60,20,itm);
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	CALL SUBOPT_0x25
; 0000 023A         sprintf(itm,"%d %d %d   ",buffer[1],buffer[2],buffer[3]);
	__POINTW1FN _0x0,250
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	CALL SUBOPT_0x2D
	LDD  R30,Y+14
	CALL SUBOPT_0x2D
	LDD  R30,Y+19
	CALL SUBOPT_0x2D
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 023B         glcd_outtextxy(2,30,"                    ");
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x73,426
	CALL _glcd_outtextxy
; 0000 023C         glcd_outtextxy(30,30,itm);
	LDI  R30,LOW(30)
	ST   -Y,R30
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	CALL SUBOPT_0x25
; 0000 023D         sprintf(itm,"%d %d     ",buffer[4],buffer[5]);
	__POINTW1FN _0x0,262
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	CALL SUBOPT_0x2D
	LDD  R30,Y+17
	CALL SUBOPT_0x2D
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 023E         glcd_outtextxy(2,40,"                    ");
	CALL SUBOPT_0x2A
	__POINTW2MN _0x73,447
	CALL _glcd_outtextxy
; 0000 023F         glcd_outtextxy(35,40,itm);
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	CALL SUBOPT_0x1C
; 0000 0240         glcd_outtextxy(2,50,"                    ");
	LDI  R30,LOW(50)
	ST   -Y,R30
	__POINTW2MN _0x73,468
	CALL SUBOPT_0x27
; 0000 0241         j=keypad();
; 0000 0242         if(j==11){
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x8D
; 0000 0243             flag++;
	SUBI R17,-1
; 0000 0244             if(flag==4){
	CPI  R17,4
	BRNE _0x8E
; 0000 0245                 for(j=0;j<6;j++){
	__GETWRN 18,19,0
_0x90:
	__CPWRN 18,19,6
	BRGE _0x91
; 0000 0246                     store[number][j]=buffer[j];
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	SUBI R30,LOW(-_store)
	SBCI R31,HIGH(-_store)
	ADD  R30,R18
	ADC  R31,R19
	MOVW R0,R30
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0247                 }
	__ADDWRN 18,19,1
	RJMP _0x90
_0x91:
; 0000 0248             glcd_clear();
	CALL _glcd_clear
; 0000 0249             glcd_outtextxy(47,30,"SAVED!");
	LDI  R30,LOW(47)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0x73,489
	CALL _glcd_outtextxy
; 0000 024A             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL SUBOPT_0xD
; 0000 024B             glcd_clear();
; 0000 024C             flag=0;
	LDI  R17,LOW(0)
; 0000 024D             }
; 0000 024E         }
_0x8E:
; 0000 024F         break;
_0x8D:
; 0000 0250 }
_0x79:
; 0000 0251 if(j==10){flag=0;}
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x92
	LDI  R17,LOW(0)
; 0000 0252 }
_0x92:
	RJMP _0x74
_0x76:
; 0000 0253 }
	CALL __LOADLOCR4
	ADIW R28,27
	RET
; .FEND

	.DSEG
_0x73:
	.BYTE 0x1F0
;//==================================GET VALUE FUNCTION=======================================//
;char value(char putx,char puty){
; 0000 0255 char value(char putx,char puty){

	.CSEG
_value:
; .FSTART _value
; 0000 0256 char itm[15],number=0;
; 0000 0257 int temp2=0,num=0;
; 0000 0258 glcd_outtextxy(putx,puty,"_    ");
	ST   -Y,R26
	SBIW R28,15
	CALL __SAVELOCR6
;	putx -> Y+22
;	puty -> Y+21
;	itm -> Y+6
;	number -> R17
;	temp2 -> R18,R19
;	num -> R20,R21
	LDI  R17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x2E
	__POINTW2MN _0x93,0
	CALL _glcd_outtextxy
; 0000 0259 while(1){
_0x94:
; 0000 025A     temp2=keypad();
	RCALL _keypad
	MOVW R18,R30
; 0000 025B     if(temp2>9){
	__CPWRN 18,19,10
	BRLT _0x97
; 0000 025C         if(temp2==11 && num<256){
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x99
	__CPWRN 20,21,256
	BRLT _0x9A
_0x99:
	RJMP _0x98
_0x9A:
; 0000 025D                number=num;
	MOV  R17,R20
; 0000 025E                return number;
	MOV  R30,R17
	RJMP _0x2120016
; 0000 025F         }
; 0000 0260         else{
_0x98:
; 0000 0261         glcd_outtextxy(87,3,"WRONG ");
	CALL SUBOPT_0x2C
	__POINTW2MN _0x93,6
	CALL _glcd_outtextxy
; 0000 0262         num=0;
	CALL SUBOPT_0x2E
; 0000 0263         glcd_outtextxy(putx,puty,"_   ");
	__POINTW2MN _0x93,13
	CALL SUBOPT_0x2F
; 0000 0264         delay_ms(300);
; 0000 0265         glcd_outtextxy(87,3,"NEXT >");
	__POINTW2MN _0x93,18
	CALL _glcd_outtextxy
; 0000 0266         }
; 0000 0267     }
; 0000 0268     else{
	RJMP _0x9C
_0x97:
; 0000 0269         temp2++;
	__ADDWRN 18,19,1
; 0000 026A         num=num*10 + temp2;
	MOVW R30,R20
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R18
	ADC  R31,R19
	MOVW R20,R30
; 0000 026B         if(num<256){
	__CPWRN 20,21,256
	BRGE _0x9D
; 0000 026C         sprintf(itm,"%d  ",num);
	CALL SUBOPT_0x13
	__POINTW1FN _0x0,828
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL SUBOPT_0x26
; 0000 026D         glcd_outtextxy(putx,puty,itm);
	LDD  R30,Y+22
	ST   -Y,R30
	LDD  R30,Y+22
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RJMP _0xD1
; 0000 026E         }
; 0000 026F         else{
_0x9D:
; 0000 0270         glcd_outtextxy(87,3,"WRONG ");
	CALL SUBOPT_0x2C
	__POINTW2MN _0x93,25
	CALL _glcd_outtextxy
; 0000 0271         num=0;
	CALL SUBOPT_0x2E
; 0000 0272         glcd_outtextxy(putx,puty,"_   ");
	__POINTW2MN _0x93,32
	CALL SUBOPT_0x2F
; 0000 0273         delay_ms(300);
; 0000 0274         glcd_outtextxy(87,3,"NEXT >");
	__POINTW2MN _0x93,37
_0xD1:
	CALL _glcd_outtextxy
; 0000 0275         }
; 0000 0276     }
_0x9C:
; 0000 0277 }
	RJMP _0x94
; 0000 0278 }
_0x2120016:
	CALL __LOADLOCR6
	ADIW R28,23
	RET
; .FEND

	.DSEG
_0x93:
	.BYTE 0x2C
;//===============================APPLY RECTANGLE FUNCTION===================================//
;void applyR(int j){
; 0000 027A void applyR(int j){

	.CSEG
_applyR:
; .FSTART _applyR
; 0000 027B char i;
; 0000 027C sethed(0,0,store[j][1],store[j][2]);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	j -> Y+1
;	i -> R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL SUBOPT_0x30
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x31
	CALL SUBOPT_0x24
	RCALL _sethed
; 0000 027D DDRB.6=1;    // OUTPUT
	SBI  0x17,6
; 0000 027E PORTB.6=1;  // --> 5V
	SBI  0x18,6
; 0000 027F DDRD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0280 for(i=store[j][1]+1 ; i<=store[j][3] ; i++,rotateH++){
	CALL SUBOPT_0x32
	SUBI R30,-LOW(1)
	MOV  R17,R30
_0xA4:
	CALL SUBOPT_0x33
	CP   R30,R17
	BRLO _0xA5
; 0000 0281     glcd_setpixel(i-1,store[j][2]);
	MOV  R30,R17
	SUBI R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x1F
	__ADDW1MN _store,2
	CALL SUBOPT_0x24
	CALL SUBOPT_0x34
; 0000 0282     if(rotateH>7){rotateH=0;}
	BRSH _0xA6
	CLR  R4
; 0000 0283     PORTD=stepmove[rotateH];
_0xA6:
	CALL SUBOPT_0x35
; 0000 0284     delay_ms(delay);
; 0000 0285 }
	SUBI R17,-1
	INC  R4
	RJMP _0xA4
_0xA5:
; 0000 0286 DDRD=0xf0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0287 for(i=store[j][2]+1; i<=store[j][4] ; i++ ,rotateV++){
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x31
	MOVW R26,R30
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	MOV  R17,R30
_0xA8:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x23
	CP   R30,R17
	BRLO _0xA9
; 0000 0288     glcd_setpixel(store[j][3],i-1);
	CALL SUBOPT_0x33
	ST   -Y,R30
	MOV  R26,R17
	SUBI R26,LOW(1)
	CALL SUBOPT_0x36
; 0000 0289     if(rotateV>7){rotateV=0;}
	BRSH _0xAA
	CLR  R5
; 0000 028A     PORTD=stepmove[rotateV]<<4;
_0xAA:
	CALL SUBOPT_0x37
; 0000 028B     delay_ms(delay);
; 0000 028C }
	SUBI R17,-1
	INC  R5
	RJMP _0xA8
_0xA9:
; 0000 028D DDRD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 028E for(i=store[j][3] ; i>=store[j][1] ; i-- ,rotateH--){
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,3
	CALL SUBOPT_0x20
_0xAC:
	CALL SUBOPT_0x32
	CP   R17,R30
	BRLO _0xAD
; 0000 028F     glcd_setpixel(i,store[j][4]);
	ST   -Y,R17
	CALL SUBOPT_0x1F
	__ADDW1MN _store,4
	CALL SUBOPT_0x24
	CALL SUBOPT_0x34
; 0000 0290     if(rotateH>7){rotateH=7;}
	BRSH _0xAE
	LDI  R30,LOW(7)
	MOV  R4,R30
; 0000 0291     PORTD=stepmove[rotateH];
_0xAE:
	CALL SUBOPT_0x35
; 0000 0292     delay_ms(delay);
; 0000 0293 }
	SUBI R17,1
	DEC  R4
	RJMP _0xAC
_0xAD:
; 0000 0294 DDRD=0xf0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0295 rotateV--;
	DEC  R5
; 0000 0296 for(i=store[j][4] ; i>=store[j][2] ; i-- ,rotateV--){
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,4
	CALL SUBOPT_0x20
_0xB0:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x31
	MOVW R26,R30
	CALL __EEPROMRDB
	CP   R17,R30
	BRLO _0xB1
; 0000 0297     glcd_setpixel(store[j][1],i);
	CALL SUBOPT_0x32
	ST   -Y,R30
	MOV  R26,R17
	CALL SUBOPT_0x36
; 0000 0298     if(rotateV>7){rotateV=7;}
	BRSH _0xB2
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0299     PORTD=stepmove[rotateV]<<4;
_0xB2:
	CALL SUBOPT_0x37
; 0000 029A     delay_ms(delay);
; 0000 029B }
	SUBI R17,1
	DEC  R5
	RJMP _0xB0
_0xB1:
; 0000 029C DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 029D PORTB.6=0;
	CBI  0x18,6
; 0000 029E 
; 0000 029F sethed(store[j][1],store[j][2],0,0);
	CALL SUBOPT_0x32
	ST   -Y,R30
	CALL SUBOPT_0x1F
	__ADDW1MN _store,2
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _sethed
; 0000 02A0 rotateH=0;rotateV=0;
	CLR  R4
	CLR  R5
; 0000 02A1 }
	LDD  R17,Y+0
	JMP  _0x212000F
; .FEND
;//=================================APPLY CIRCLE FUNCTION=====================================//
;void applyC(void){
; 0000 02A3 void applyC(void){
_applyC:
; .FSTART _applyC
; 0000 02A4 glcd_clear();
	CALL SUBOPT_0xC
; 0000 02A5 glcd_rectround(1,1,126,62, 5);
; 0000 02A6 glcd_outtextxy(5,10,"Applying circle...");
	__POINTW2MN _0xB5,0
	CALL SUBOPT_0x2
; 0000 02A7 glcd_outtextxy(5,30,"It's not available!");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xB5,19
	RJMP _0x2120015
; 0000 02A8 delay_ms(500);
; 0000 02A9 glcd_clear();
; 0000 02AA }
; .FEND

	.DSEG
_0xB5:
	.BYTE 0x27
;//==================================APPLY LINE FUNCTION======================================//
;void applyL(void){
; 0000 02AC void applyL(void){

	.CSEG
_applyL:
; .FSTART _applyL
; 0000 02AD glcd_clear();
	CALL SUBOPT_0xC
; 0000 02AE glcd_rectround(1,1,126,62, 5);
; 0000 02AF glcd_outtextxy(5,10,"Applying line...   ");
	__POINTW2MN _0xB6,0
	CALL SUBOPT_0x2
; 0000 02B0 glcd_outtextxy(5,30,"It's not available!");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xB6,20
	RJMP _0x2120015
; 0000 02B1 delay_ms(500);
; 0000 02B2 glcd_clear();
; 0000 02B3 }
; .FEND

	.DSEG
_0xB6:
	.BYTE 0x28
;//================================APPLY SECTOR FUNCTION=====================================//
;void applyS(void){
; 0000 02B5 void applyS(void){

	.CSEG
_applyS:
; .FSTART _applyS
; 0000 02B6 glcd_clear();
	CALL SUBOPT_0xC
; 0000 02B7 glcd_rectround(1,1,126,62, 5);
; 0000 02B8 glcd_outtextxy(5,10,"Applying sector...");
	__POINTW2MN _0xB7,0
	CALL SUBOPT_0x2
; 0000 02B9 glcd_outtextxy(5,30,"It's not available!");
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xB7,19
_0x2120015:
	CALL _glcd_outtextxy
; 0000 02BA delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL SUBOPT_0xD
; 0000 02BB glcd_clear();
; 0000 02BC }
	RET
; .FEND

	.DSEG
_0xB7:
	.BYTE 0x27
;//==================================SET HEADER FUNCTION=====================================//
;void sethed(char varx1,char vary1,char varx2,char vary2){
; 0000 02BE void sethed(char varx1,char vary1,char varx2,char vary2){

	.CSEG
_sethed:
; .FSTART _sethed
; 0000 02BF DDRD=0x0f; // 0b 0000 1111
	ST   -Y,R26
;	varx1 -> Y+3
;	vary1 -> Y+2
;	varx2 -> Y+1
;	vary2 -> Y+0
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 02C0 if(varx1<=varx2){
	LDD  R30,Y+1
	LDD  R26,Y+3
	CP   R30,R26
	BRLO _0xB8
; 0000 02C1     for(varx1=varx1+1 ; varx1<=varx2 ; varx1++ ,rotateH++){
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	STD  Y+3,R30
_0xBA:
	LDD  R30,Y+1
	LDD  R26,Y+3
	CP   R30,R26
	BRLO _0xBB
; 0000 02C2         glcd_clrpixel(varx1-1,vary1);
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	CALL SUBOPT_0x38
; 0000 02C3         glcd_setpixel(varx1,vary1);
; 0000 02C4         if(rotateH>7){rotateH=0;}
	BRSH _0xBC
	CLR  R4
; 0000 02C5         PORTD=stepmove[rotateH];  // 0b 0000 1000
_0xBC:
	CALL SUBOPT_0x35
; 0000 02C6         delay_ms(delay);
; 0000 02C7     }
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	STD  Y+3,R30
	INC  R4
	RJMP _0xBA
_0xBB:
; 0000 02C8 }
; 0000 02C9 else{
	RJMP _0xBD
_0xB8:
; 0000 02CA     for(varx1=varx1-1 ; varx1>=varx2 && varx1!=255 ; varx1-- ,rotateH--){
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	STD  Y+3,R30
_0xBF:
	LDD  R30,Y+1
	LDD  R26,Y+3
	CP   R26,R30
	BRLO _0xC1
	CPI  R26,LOW(0xFF)
	BRNE _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
; 0000 02CB         glcd_clrpixel(varx1+1,vary1);
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x38
; 0000 02CC         glcd_setpixel(varx1,vary1);
; 0000 02CD         if(rotateH>7){rotateH=7;}
	BRSH _0xC3
	LDI  R30,LOW(7)
	MOV  R4,R30
; 0000 02CE         PORTD=stepmove[rotateH];
_0xC3:
	CALL SUBOPT_0x35
; 0000 02CF         delay_ms(delay);
; 0000 02D0     }
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	STD  Y+3,R30
	DEC  R4
	RJMP _0xBF
_0xC0:
; 0000 02D1 }
_0xBD:
; 0000 02D2 DDRD=0xf0; // 0b 1111 0000 motor Y
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 02D3 if(vary1<=vary2){
	LD   R30,Y
	LDD  R26,Y+2
	CP   R30,R26
	BRLO _0xC4
; 0000 02D4         for(vary1=vary1+1; vary1<=vary2 ; vary1++ ,rotateV++){
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
_0xC6:
	LD   R30,Y
	LDD  R26,Y+2
	CP   R30,R26
	BRLO _0xC7
; 0000 02D5         glcd_clrpixel(varx2,vary1-1);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,LOW(1)
	CALL SUBOPT_0x39
; 0000 02D6         glcd_setpixel(varx2,vary1);
; 0000 02D7         if(rotateV>7){rotateV=0;}
	BRSH _0xC8
	CLR  R5
; 0000 02D8         PORTD=stepmove[rotateV]<<4; // 0b 0000 1000 ==> 0b 1000 0000
_0xC8:
	CALL SUBOPT_0x37
; 0000 02D9         delay_ms(delay);
; 0000 02DA     }
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	INC  R5
	RJMP _0xC6
_0xC7:
; 0000 02DB }
; 0000 02DC else{
	RJMP _0xC9
_0xC4:
; 0000 02DD     for(vary1=vary1-1 ; vary1>=vary2 && vary1!=255 ; vary1--,rotateV--){
	LDD  R30,Y+2
	SUBI R30,LOW(1)
	STD  Y+2,R30
_0xCB:
	LD   R30,Y
	LDD  R26,Y+2
	CP   R26,R30
	BRLO _0xCD
	CPI  R26,LOW(0xFF)
	BRNE _0xCE
_0xCD:
	RJMP _0xCC
_0xCE:
; 0000 02DE         glcd_clrpixel(varx2,vary1+1);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x39
; 0000 02DF         glcd_setpixel(varx2,vary1);
; 0000 02E0         if(rotateV>7){rotateV=7;}
	BRSH _0xCF
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 02E1         PORTD=stepmove[rotateV]<<4;
_0xCF:
	CALL SUBOPT_0x37
; 0000 02E2         delay_ms(delay);
; 0000 02E3     }
	LDD  R30,Y+2
	SUBI R30,LOW(1)
	STD  Y+2,R30
	DEC  R5
	RJMP _0xCB
_0xCC:
; 0000 02E4 }
_0xC9:
; 0000 02E5 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 02E6 }
	RJMP _0x2120013
; .FEND
;//==========================================END=============================================//
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x18,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x18,0
	CBI  0x18,4
	CBI  0x18,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,25
	CBI  0x18,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	CBI  0x18,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x18,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x18,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x18,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x18,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	RJMP _0x212000E
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x3A
	RJMP _0x212000E
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	RJMP _0x212000E
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x18,2
	CALL SUBOPT_0x3A
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	SBI  0x18,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
	RJMP _0x212000E
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x18,3
	SBI  0x17,4
	SBI  0x17,5
	RCALL _ks0108_disable_G100
	CBI  0x18,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x212000F
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x3D
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
_0x2120014:
	CALL __LOADLOCR4
_0x2120013:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120010
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120010
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRSH _0x2000022
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x2000021
_0x2000022:
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0x2000021:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _ks0108_rdbyte_G100
	MOV  R1,R30
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2000024
	LDI  R30,LOW(1)
	RJMP _0x2000025
_0x2000024:
	LDI  R30,LOW(0)
_0x2000025:
	RJMP _0x212000E
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x3D
	LDD  R17,Y+0
	RJMP _0x212000B
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2120012
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2120012
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2120012
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x3E
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x3F
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x3E
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x3F
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x3E
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x3C
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x40
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x42
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x3D
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x43
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x44
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x45
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x40
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x42
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x43
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x46
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x44
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x45
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x40
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x42
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x43
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x46
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2120012:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x47
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000E
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x212000E
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x212000E
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x47
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000E
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x212000E
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x212000E
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	CALL SUBOPT_0x3B
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	RJMP _0x212000E
; .FEND
_glcd_clrpixel:
; .FSTART _glcd_clrpixel
	CALL SUBOPT_0x3B
	ST   -Y,R30
	__GETB2MN _glcd_state,1
	RCALL _glcd_putpixel
	RJMP _0x212000E
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x48
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
_0x202000B:
	CALL SUBOPT_0x49
	STD  Y+7,R0
	CALL SUBOPT_0x49
	STD  Y+6,R0
	CALL SUBOPT_0x49
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120011
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120011
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120011:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x4A
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x48
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	CALL __LOADLOCR6
	RJMP _0x212000C
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	CALL SUBOPT_0x4B
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x4A
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4C
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x4A
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x4C
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	CALL __LOADLOCR6
	RJMP _0x212000C
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	RJMP _0x212000C
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
_0x2120010:
	ADIW R28,5
	RET
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
_0x212000F:
	ADIW R28,3
	RET
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
_0x212000E:
	ADIW R28,2
	RET
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x212000D
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x4D
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x4D
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x4E
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x4D
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x4F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x50
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x4E
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x4F
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x50
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x4E
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x212000D:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_corners_G101:
; .FSTART _glcd_corners_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R17,Z+3
	LDD  R16,Z+1
	LDD  R19,Z+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X
	CP   R16,R17
	BRSH _0x2020066
	MOV  R21,R16
	MOV  R16,R17
	MOV  R17,R21
_0x2020066:
	CP   R18,R19
	BRSH _0x2020067
	MOV  R21,R18
	MOV  R18,R19
	MOV  R19,R21
_0x2020067:
	MOV  R30,R17
	__PUTB1SNS 6,3
	MOV  R30,R19
	__PUTB1SNS 6,2
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R18
	CALL __LOADLOCR6
	RJMP _0x212000C
; .FEND
_glcd_rectangle:
; .FSTART _glcd_rectangle
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETB1MN _glcd_state,8
	SUBI R30,LOW(1)
	MOV  R19,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL _glcd_corners_G101
	LDD  R30,Y+5
	SUB  R30,R19
	MOV  R17,R30
	LDD  R30,Y+4
	SUB  R30,R19
	MOV  R16,R30
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R30,Y+7
	ST   -Y,R30
	ST   -Y,R17
	LDD  R26,Y+9
	RCALL _glcd_line
	ST   -Y,R17
	LDD  R30,Y+7
	ST   -Y,R30
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R16
	MOV  R30,R19
	LDD  R26,Y+9
	ADD  R30,R26
	ST   -Y,R30
	MOV  R26,R16
	RCALL _glcd_line
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	MOV  R30,R19
	LDD  R26,Y+9
	ADD  R26,R30
	RCALL _glcd_line
	CALL __LOADLOCR4
_0x212000C:
	ADIW R28,8
	RET
; .FEND
_glcd_rectround:
; .FSTART _glcd_rectround
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x2020069
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x202006A
_0x2020069:
	RJMP _0x2020068
_0x202006A:
	LDD  R30,Y+8
	LDD  R26,Y+12
	ADD  R30,R26
	MOV  R17,R30
	LDD  R30,Y+8
	LDD  R26,Y+11
	ADD  R30,R26
	MOV  R18,R30
	__GETB1MN _glcd_state,8
	SUBI R30,LOW(1)
	STD  Y+7,R30
	LDD  R30,Y+10
	LDD  R26,Y+12
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R19,R26
	LDD  R26,Y+8
	MOV  R30,R19
	SUB  R30,R26
	MOV  R16,R30
	LDD  R26,Y+7
	SUB  R19,R26
	LDD  R30,Y+9
	LDD  R26,Y+11
	ADD  R26,R30
	SUBI R26,LOW(1)
	MOV  R20,R26
	LDD  R26,Y+8
	MOV  R30,R20
	SUB  R30,R26
	MOV  R21,R30
	LDD  R26,Y+7
	SUB  R20,R26
	__GETB1MN _glcd_state,9
	STD  Y+6,R30
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	ST   -Y,R17
	LDD  R30,Y+12
	ST   -Y,R30
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(129)
	RCALL _glcd_quadrant_G101
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R19
	MOV  R26,R21
	SUBI R26,LOW(1)
	RCALL _glcd_line
	ST   -Y,R16
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(136)
	RCALL _glcd_quadrant_G101
	ST   -Y,R16
	ST   -Y,R20
	ST   -Y,R17
	MOV  R26,R20
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R21
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(132)
	RCALL _glcd_quadrant_G101
	LDD  R30,Y+12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R30,Y+14
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDI  R26,LOW(130)
	RCALL _glcd_quadrant_G101
	LDD  R30,Y+6
	__PUTB1MN _glcd_state,9
	RJMP _0x202006B
_0x2020068:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+12
	RCALL _glcd_setpixel
_0x202006B:
	RJMP _0x2120007
; .FEND
_round_G101:
; .FSTART _round_G101
	CALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETD2S 2
	CALL _floor
	CALL __CFD1
	MOVW R16,R30
	__GETD2S 2
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x51
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x52
	BRLO _0x2020071
	__ADDWRN 16,17,1
_0x2020071:
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x212000B:
	ADIW R28,6
	RET
; .FEND
_glcd_toradius_G101:
; .FSTART _glcd_toradius_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3C8EFA35
	CALL SUBOPT_0x53
	LDD  R30,Y+12
	LDI  R31,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x54
	CALL _cos
	CALL SUBOPT_0x55
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDD  R30,Y+11
	LDI  R31,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x54
	CALL _sin
	CALL SUBOPT_0x55
	POP  R26
	POP  R27
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RJMP _0x2120008
; .FEND
_glcd_plot8_G101:
; .FSTART _glcd_plot8_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x4B
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x56
	LDD  R30,Y+16
	CALL SUBOPT_0x57
	BREQ _0x2020073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x58
	BRLT _0x2020077
	CALL SUBOPT_0x59
	BRGE _0x2020078
_0x2020077:
	RJMP _0x2020076
_0x2020078:
_0x2020073:
	TST  R19
	BRMI _0x2020079
	CALL SUBOPT_0x5A
_0x2020079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x202007B
	__CPWRN 18,19,2
	BRGE _0x202007C
_0x202007B:
	RJMP _0x202007A
_0x202007C:
	CALL SUBOPT_0x5B
	BRNE _0x202007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x202007D:
_0x202007A:
_0x2020076:
_0x2020075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x202007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x5C
	BRLT _0x2020083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x5D
	BRGE _0x2020084
_0x2020083:
	RJMP _0x2020082
_0x2020084:
_0x202007F:
	CALL SUBOPT_0x5E
	BRLO _0x2020085
	CALL SUBOPT_0x5F
	BRNE _0x2020086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2020086:
_0x2020085:
_0x2020082:
_0x2020081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2020087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2020089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x202008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x5C
	BRLT _0x202008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x5D
	BRGE _0x202008E
_0x202008D:
	RJMP _0x202008C
_0x202008E:
_0x2020089:
	TST  R19
	BRMI _0x202008F
	CALL SUBOPT_0x5A
_0x202008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2020091
	__CPWRN 18,19,2
	BRGE _0x2020092
_0x2020091:
	RJMP _0x2020090
_0x2020092:
	CALL SUBOPT_0x5B
	BRNE _0x2020093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2020093:
_0x2020090:
_0x202008C:
_0x202008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2020095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2020097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x58
	BRLT _0x2020099
	CALL SUBOPT_0x59
	BRGE _0x202009A
_0x2020099:
	RJMP _0x2020098
_0x202009A:
_0x2020095:
	CALL SUBOPT_0x5E
	BRLO _0x202009B
	CALL SUBOPT_0x5F
	BRNE _0x202009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x202009C:
_0x202009B:
_0x2020098:
_0x2020097:
_0x2020087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x4B
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x56
	LDD  R30,Y+15
	CALL SUBOPT_0x57
	BREQ _0x202009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20200A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20200A3
_0x20200A2:
	RJMP _0x20200A1
_0x20200A3:
_0x202009E:
	TST  R19
	BRMI _0x20200A4
	CALL SUBOPT_0x5A
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x60
	BRNE _0x20200A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200A6:
_0x20200A5:
_0x20200A4:
_0x20200A1:
_0x20200A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20200A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x58
	BRLT _0x20200AC
	CALL SUBOPT_0x59
	BRGE _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
_0x20200A8:
	CALL SUBOPT_0x5E
	BRLO _0x20200AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x61
	BRNE _0x20200AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200AF:
_0x20200AE:
_0x20200AB:
_0x20200AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20200B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20200B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x58
	BRLT _0x20200B6
	CALL SUBOPT_0x59
	BRGE _0x20200B7
_0x20200B6:
	RJMP _0x20200B5
_0x20200B7:
_0x20200B2:
	TST  R19
	BRMI _0x20200B8
	CALL SUBOPT_0x5A
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20200BA
	__CPWRN 16,17,2
	BRGE _0x20200BB
_0x20200BA:
	RJMP _0x20200B9
_0x20200BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x60
	BRNE _0x20200BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20200BC:
_0x20200B9:
_0x20200B8:
_0x20200B5:
_0x20200B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20200BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20200C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x5C
	BRLT _0x20200C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x5D
	BRGE _0x20200C3
_0x20200C2:
	RJMP _0x20200C1
_0x20200C3:
_0x20200BE:
	CALL SUBOPT_0x5E
	BRLO _0x20200C5
	__CPWRN 16,17,2
	BRGE _0x20200C6
_0x20200C5:
	RJMP _0x20200C4
_0x20200C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x61
	BRNE _0x20200C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20200C7:
_0x20200C4:
_0x20200C1:
_0x20200C0:
_0x20200B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G101:
; .FSTART _glcd_line2_G101
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_line
	CALL __LOADLOCR4
	JMP  _0x2120003
; .FEND
_glcd_quadrant_G101:
; .FSTART _glcd_quadrant_G101
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20200C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20200C8
_0x20200C9:
	CALL __LOADLOCR6
	RJMP _0x212000A
_0x20200C8:
	__GETBRMN 21,_glcd_state,8
_0x20200CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20200CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20200CE
	CALL __LOADLOCR6
	RJMP _0x212000A
_0x20200CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	CALL SUBOPT_0x62
_0x20200D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20200D2
	CALL SUBOPT_0x63
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G101
	CALL SUBOPT_0x63
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G101
	RJMP _0x20200D3
_0x20200D2:
	CALL SUBOPT_0x63
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G101
_0x20200D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20200D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x202011C
_0x20200D4:
	CALL SUBOPT_0x64
_0x202011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20200D0
	RJMP _0x20200CB
_0x20200CD:
	CALL __LOADLOCR6
	RJMP _0x212000A
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G101
	JMP  _0x2120004
; .FEND
_glcd_checkarc_G101:
; .FSTART _glcd_checkarc_G101
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+9
	CPI  R26,LOW(0x80)
	BRSH _0x20200D7
	LDD  R26,Y+8
	CPI  R26,LOW(0x40)
	BRLO _0x20200D6
_0x20200D7:
	LDI  R30,LOW(0)
	RJMP _0x2120009
_0x20200D6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R16,X+
	LD   R17,X
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R18,X+
	LD   R19,X
	MOVW R26,R16
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL __MODW21U
	MOVW R16,R30
	MOVW R26,R18
	LDI  R30,LOW(361)
	LDI  R31,HIGH(361)
	CALL __MODW21U
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X+,R16
	ST   X,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R18
	ST   X,R19
	MOVW R26,R16
	CALL __LEW12U
_0x2120009:
	CALL __LOADLOCR4
_0x212000A:
	ADIW R28,10
	RET
; .FEND
_glcd_arc:
; .FSTART _glcd_arc
	ST   -Y,R26
	CALL __SAVELOCR6
	CALL SUBOPT_0x65
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,11
	RCALL _glcd_checkarc_G101
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200D9
	LDD  R30,Y+12
	__PUTB1MN _glcd_state,10
	LDD  R30,Y+11
	__PUTB1MN _glcd_state,11
	CALL SUBOPT_0x65
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	ST   -Y,R30
	__POINTW1MN _glcd_state,12
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _glcd_state,13
	RCALL _glcd_toradius_G101
	CALL SUBOPT_0x65
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	ST   -Y,R30
	__POINTW1MN _glcd_state,14
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _glcd_state,15
	RCALL _glcd_toradius_G101
	__GETBRMN 21,_glcd_state,8
_0x20200DA:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200DC
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x2120007
	SUBI R30,LOW(1)
	STD  Y+6,R30
	CALL SUBOPT_0x62
_0x20200DF:
	CALL SUBOPT_0x65
	ST   -Y,R17
	ST   -Y,R16
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	__GETD2N 0x42652EE1
	CALL __MULF12
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	RCALL _glcd_plot8_G101
	SUBI R17,-1
	TST  R19
	BRPL _0x20200E1
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x202011D
_0x20200E1:
	CALL SUBOPT_0x64
_0x202011D:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20200DF
	RJMP _0x20200DA
_0x20200DC:
_0x20200D9:
_0x2120007:
	CALL __LOADLOCR6
_0x2120008:
	ADIW R28,13
	RET
; .FEND
_glcd_barrel:
; .FSTART _glcd_barrel
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CPI  R26,LOW(0x80)
	BRSH _0x20200ED
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRLO _0x20200EC
_0x20200ED:
	CALL __LOADLOCR4
	JMP  _0x2120003
_0x20200EC:
	LDD  R30,Y+5
	CPI  R30,0
	BREQ _0x20200F0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x20200F1
_0x20200F0:
	RJMP _0x20200EF
_0x20200F1:
	LDD  R19,Y+6
	MOV  R30,R19
	LDD  R26,Y+4
	ADD  R30,R26
	STD  Y+4,R30
	LDD  R30,Y+7
	LDD  R26,Y+5
	ADD  R30,R26
	STD  Y+5,R30
_0x20200F2:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x20200F4
	SUB  R30,R19
	MOV  R18,R30
	CPI  R18,9
	BRLO _0x20200F5
	LDI  R18,LOW(8)
_0x20200F5:
	LDD  R17,Y+7
_0x20200F6:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x20200F8
	SUB  R30,R17
	MOV  R16,R30
	CPI  R16,9
	BRLO _0x20200F9
	LDI  R16,LOW(8)
_0x20200F9:
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _glcd_block
	ADD  R17,R16
	RJMP _0x20200F6
_0x20200F8:
	ADD  R19,R18
	RJMP _0x20200F2
_0x20200F4:
_0x20200EF:
	CALL __LOADLOCR4
	JMP  _0x2120003
; .FEND
_glcd_bar:
; .FSTART _glcd_bar
	ST   -Y,R26
	MOVW R26,R28
	RCALL _glcd_corners_G101
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
	MOV  R26,R30
	RCALL _glcd_barrel
	JMP  _0x2120002
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120005
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x66
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x66
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x67
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x68
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x67
	CALL SUBOPT_0x69
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x67
	CALL SUBOPT_0x69
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6A
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6A
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x66
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x68
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x68
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x6B
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120006
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x6B
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120005:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20C0007
	CPI  R30,LOW(0xA)
	BRNE _0x20C0008
_0x20C0007:
	LDS  R17,_glcd_state
	RJMP _0x20C0009
_0x20C0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20C000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20C0009
_0x20C000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20C0005
	__GETBRMN 17,_glcd_state,16
_0x20C0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20C000E
	CPI  R17,0
	BREQ _0x20C000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120004
_0x20C000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120004
_0x20C000E:
	CPI  R17,0
	BRNE _0x20C0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120004
_0x20C0011:
_0x20C0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120004
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20C0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120004
_0x20C0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120004
_0x20C0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20C0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120004
_0x20C0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120004:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20C001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20C001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20C001B
_0x20C001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20C001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20C001B:
	JMP  _0x2120002
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0x6C
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x6D
	RJMP _0x2120002
__floor1:
    brtc __floor0
	CALL SUBOPT_0x6E
	CALL __SUBF12
	RJMP _0x2120002
; .FEND
_sin:
; .FSTART _sin
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	CALL SUBOPT_0x6F
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x70
	RCALL _floor
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x51
	CALL SUBOPT_0x70
	CALL SUBOPT_0x52
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20E0017
	CALL SUBOPT_0x71
	__GETD2N 0x3F000000
	CALL SUBOPT_0x72
	LDI  R17,LOW(1)
_0x20E0017:
	CALL SUBOPT_0x6F
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20E0018
	CALL SUBOPT_0x6F
	__GETD1N 0x3F000000
	CALL SUBOPT_0x72
_0x20E0018:
	CPI  R17,0
	BREQ _0x20E0019
	CALL SUBOPT_0x71
	CALL __ANEGF1
	__PUTD1S 5
_0x20E0019:
	CALL SUBOPT_0x71
	CALL SUBOPT_0x6F
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x51
	CALL SUBOPT_0x73
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x6F
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x73
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
_cos:
; .FSTART _cos
	CALL SUBOPT_0x6C
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x2120002
; .FEND
_xatan:
; .FSTART _xatan
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	CALL SUBOPT_0x53
	CALL SUBOPT_0x6D
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x76
	CALL SUBOPT_0x75
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x54
	CALL SUBOPT_0x76
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
_0x2120003:
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x6C
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x20E0020
	CALL SUBOPT_0x54
	RCALL _xatan
	RJMP _0x2120002
_0x20E0020:
	CALL SUBOPT_0x54
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20E0021
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x77
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x51
	RJMP _0x2120002
_0x20E0021:
	CALL SUBOPT_0x6E
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x77
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x2120002:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	CALL SUBOPT_0x74
	CALL __CPD10
	BRNE _0x20E002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x20E002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120001
_0x20E002E:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x20E002F
	__GETD1N 0x3FC90FDB
	RJMP _0x2120001
_0x20E002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x2120001
_0x20E002D:
	__GETD1S 4
	__GETD2S 8
	CALL __DIVF21
	CALL __PUTD1S0
	CALL SUBOPT_0x75
	CALL __CPD02
	BRGE _0x20E0030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x20E0031
	CALL SUBOPT_0x54
	RCALL _yatan
	RJMP _0x2120001
_0x20E0031:
	CALL SUBOPT_0x78
	CALL __ANEGF1
	RJMP _0x2120001
_0x20E0030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x20E0032
	CALL SUBOPT_0x78
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x51
	RJMP _0x2120001
_0x20E0032:
	CALL SUBOPT_0x54
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x2120001:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D

	.ESEG
_store:
	.BYTE 0x1E
_delay:
	.BYTE 0x2

	.DSEG
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	CALL _glcd_clear
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(124)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R26,LOW(5)
	JMP  _glcd_rectround

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x2:
	CALL _glcd_outtextxy
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	MOVW R26,R30
	SUBI R30,-LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R30,R26
	SUBI R30,-LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(50)
	JMP  _glcd_bar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	CALL _glcd_clear
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	CALL _glcd_outtextxy
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(124)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _glcd_rectround
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CALL _glcd_outtextxy
	CALL _keypad
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _glcd_rectround
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL _show
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	MOVW R30,R16
	CALL __LSLW2
	ADD  R30,R18
	ADC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xC:
	CALL _glcd_clear
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(126)
	ST   -Y,R30
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _glcd_rectround
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL _delay_ms
	JMP  _glcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _glcd_rectround

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _glcd_rectround
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _glcd_rectround

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x14:
	__POINTW1FN _0x0,187
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	JMP  _glcd_outtextxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	CALL _glcd_outtextxy
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x17:
	__POINTW1FN _0x0,201
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	SUBI R30,LOW(-_store)
	SBCI R31,HIGH(-_store)
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:101 WORDS
SUBOPT_0x19:
	__ADDW1MN _store,1
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	__ADDW1MN _store,2
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	__ADDW1MN _store,3
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	LDI  R30,LOW(30)
	ST   -Y,R30
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1A:
	__ADDW1MN _store,4
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12U
	__ADDW1MN _store,5
	MOVW R26,R30
	CALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	JMP  _glcd_outtextxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _glcd_outtextxy
	LDI  R30,LOW(87)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	CALL _glcd_outtextxy
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	__MULBNWRU 16,17,6
	SUBI R30,LOW(-_store)
	SBCI R31,HIGH(-_store)
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R18,R30
	LDI  R31,0
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x21:
	__ADDW1MN _store,1
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,2
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,3
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,4
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x22:
	__ADDW1MN _store,1
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,2
	MOVW R26,R30
	CALL __EEPROMRDB
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,3
	MOVW R26,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,4
	MOVW R26,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	CALL _glcd_outtextxy
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	CALL _glcd_outtextxy
	CALL _keypad
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	STD  Y+4,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL _glcd_outtextxy
	LDI  R30,LOW(25)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	CALL _glcd_outtextxy
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(50)
	JMP  _value

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(87)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2D:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	__GETWRN 20,21,0
	LDD  R30,Y+22
	ST   -Y,R30
	LDD  R30,Y+22
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	CALL _glcd_outtextxy
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,1
	MOVW R26,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _store,3
	MOVW R26,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	CALL _glcd_setpixel
	LDI  R30,LOW(7)
	CP   R30,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x35:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_stepmove*2)
	SBCI R31,HIGH(-_stepmove*2)
	LPM  R0,Z
	OUT  0x12,R0
	LDI  R26,LOW(_delay)
	LDI  R27,HIGH(_delay)
	CALL __EEPROMRDW
	MOVW R26,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	CALL _glcd_setpixel
	LDI  R30,LOW(7)
	CP   R30,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x37:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_stepmove*2)
	SBCI R31,HIGH(-_stepmove*2)
	LPM  R30,Z
	SWAP R30
	ANDI R30,0xF0
	OUT  0x12,R30
	LDI  R26,LOW(_delay)
	LDI  R27,HIGH(_delay)
	CALL __EEPROMRDW
	MOVW R26,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _glcd_clrpixel
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+3
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	CALL _glcd_clrpixel
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+3
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3A:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x40:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4A:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4D:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	__GETD1N 0x3F000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	CALL __MULF12
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x54:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x55:
	LDD  R26,Y+8
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _round_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x57:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x58:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5E:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x60:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x61:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x62:
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+12
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x66:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x67:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x69:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	CALL __PUTPARD2
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6D:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6E:
	RCALL SUBOPT_0x6D
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6F:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	__PUTD1S 5
	RJMP SUBOPT_0x6F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x74:
	CALL __PUTPARD2
	SBIW R28,4
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	RCALL SUBOPT_0x6D
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CBD2:
	MOV  R27,R26
	ADD  R27,R27
	SBC  R27,R27
	MOV  R24,R27
	MOV  R25,R27
	RET

__LEW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRSH __LEW12UT
	CLR  R30
__LEW12UT:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
