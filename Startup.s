;/*****************************************************************************/
;/* STARTUP.S: Startup file for Sharp LH754xx device series                   */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2006 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/


; *** Startup Code (executed after Reset) ***


; Standard definitions of Mode bits and Interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80            ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40            ; when F bit is set, FIQ is disabled


;// <h> Stack Configuration (Stack Sizes in Bytes)
;//   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;//   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;//   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;//   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;//   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;//   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
;// </h>

UND_Stack_Size  EQU     0x00000000
SVC_Stack_Size  EQU     0x00000008
ABT_Stack_Size  EQU     0x00000000
FIQ_Stack_Size  EQU     0x00000000
IRQ_Stack_Size  EQU     0x00000080
USR_Stack_Size  EQU     0x00000400

ISR_Stack_Size  EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size)

                AREA    STACK, NOINIT, READWRITE, ALIGN=3

Stack_Mem       SPACE   USR_Stack_Size
__initial_sp    SPACE   ISR_Stack_Size
Stack_Top


;// <h> Heap Configuration
;//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF>
;// </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


; Reset, Clock and Power Controller definitions
RCPC_BASE       EQU     0xFFFE2000      ; RCPC Base Address
SYSPRESC_OFS    EQU     0x18            ; System Clock Prescaler Offset
PCLKCTRL0_OFS   EQU     0x24            ; Periph. Clock Control 0 Offset
PCLKCTRL1_OFS   EQU     0x28            ; Periph. Clock Control 1 Offset
CLKCTRL_OFS     EQU     0x2C            ; AHB Clock Control Offset
SSPPRESC_OFS    EQU     0x40            ; SSC Prescaler Offset
LCDPRESC_OFS    EQU     0x44            ; LCD Prescaler Offset

;// <e> Clock Setup
;//   <o1.0..3>   System Clock Prescaler 
;//               <1-31>
;//               <i> System Clock = (7 * XTAL) / (2 * SysClkPrescaler)
;//   <o2.0..7>   SSP Prescaler
;//               <0x00=>   1  <0x01=>   2  <0x02=>   4  <0x04=>   8
;//               <0x08=>  16  <0x10=>  32  <0x20=>  64  <0x40=> 128
;//               <0x80=> 256
;//               <i> SSP Clock = SysClock / (SSPPrescaler)
;//   <o3.0..7>   LCD Prescaler
;//               <0x00=>   1  <0x01=>   2  <0x02=>   4  <0x04=>   8
;//               <0x08=>  16  <0x10=>  32  <0x20=>  64  <0x40=> 128
;//               <0x80=> 256
;//               <i> LCD Clock = SysClock / (LCDPrescaler)
;//   <o4.0>      DMA Clock    <0=> Enabled  <1=> Disabled
;//   <o5.0>      UART0 Clock  <0=> Enabled  <1=> Disabled
;//   <o5.1>      UART1 Clock  <0=> Enabled  <1=> Disabled
;//   <o5.2>      UART2 Clock  <0=> Enabled  <1=> Disabled
;//   <o5.9>      RTC Clock    <0=> Enabled  <1=> Disabled
;//   <o6.0>      SSP Clock    <0=> Enabled  <1=> Disabled
;//   <o6.1>      LCD Clock    <0=> Enabled  <1=> Disabled
;// </e>

CLK_SETUP       EQU     1
SYSPRESC_Val    EQU     0x0000000F
SSPPRESC_Val    EQU     0x00000000
LCDPRESC_Val    EQU     0x00000000
CLKCTRL_Val     EQU     0x00000001
PCLKCTRL0_Val   EQU     0xFFFFFFFF
PCLKCTRL1_Val   EQU     0x00000003


; I/O Configuration definitions
IOCON_BASE      EQU     0xFFFE5000      ; IOCON Base Address
EBI_MUX_OFS     EQU     0x00            ; EBI Mux Offset
PD_MUX_OFS      EQU     0x04            ; Pins PDx Mux Offset
PE_MUX_OFS      EQU     0x08            ; Pins PEx Mux Offset
TIMER_MUX_OFS   EQU     0x0C            ; Timer Mux Offset
LCD_MUX_OFS     EQU     0x10            ; LCD Mode Mux Offset
PA_R_MUX_OFS    EQU     0x14            ; Pins PAx Resistor Mux Offset
PB_R_MUX_OFS    EQU     0x18            ; Pins PBx Resistor Mux Offset
PC_R_MUX_OFS    EQU     0x1C            ; Pins PCx Resistor Mux Offset
PD_R_MUX_OFS    EQU     0x20            ; Pins PDx Resistor Mux Offset
PE_R_MUX_OFS    EQU     0x24            ; Pins PEx Resistor Mux Offset
ADC_MUX_OFS     EQU     0x28            ; Pins ANx/PJx Mux Offset

;// <e> I/O Configuration

IOCON_SETUP     EQU     0

;//   <e> Static Memory Controller Port
;//   <i> External Bus Interface Port
;//     <o1.0>      PC0/A16 Pin              <0=> PC0      <1=> A16 
;//     <o1.1>      PC1/A17 Pin              <0=> PC1      <1=> A17 
;//     <o1.2>      PC2/A18 Pin              <0=> PC2      <1=> A18 
;//     <o1.3>      PC3/A19 Pin              <0=> PC3      <1=> A19 
;//     <o1.4>      PC4/A20 Pin              <0=> PC4      <1=> A20 
;//     <o1.5>      PC5/A21 Pin              <0=> PC5      <1=> A21 
;//     <o1.6>      PC6/A22 Pin              <0=> PC6      <1=> A22 
;//     <o1.7>      PC7/A23 Pin              <0=> PC7      <1=> A23 
;//     <o1.8>      PB0/nCE1 Pin             <0=> PB0      <1=> nCE1 
;//     <o1.9>      PB1/nCE2 Pin             <0=> PB1      <1=> nCE2 
;//     <o1.10>     PB2/nCE3 Pin             <0=> PB2      <1=> nCE3
;//     <o1.11>     PB3/nBLE0 Pin            <0=> PB3      <1=> nBLE0 
;//     <o1.12>     PB4/nBLE1 Pin            <0=> PB4      <1=> nBLE1 
;//     <o1.13>     PB5/nWAIT Pin            <0=> PB5      <1=> nWAIT 
;//     <o1.14>     PA7..0/D15..8 Pins       <0=> PA7..0   <1=> D15..8 
;//   </e>

EBI_MUX_SETUP   EQU     0
EBI_MUX_Val     EQU     0x00000000

;//   <e> Port D
;//     <o1.0>      PD0/INT0 Pin             <0=> PD0      <1=> INT0 
;//     <o1.1>      PD1/INT1 Pin             <0=> PD1      <1=> INT1 
;//     <o1.2>      PD2/INT2 Pin             <0=> PD2      <1=> INT2 
;//     <o1.3..4>   PD3/INT3/UARTTX1 Pin     <0=> PD3      <1=> INT3
;//                                          <2=> UARTTX1  <3=> PD3
;//     <o1.5..6>   PD4/INT4/UARTTR1 Pin     <0=> PD4      <1=> INT4
;//                                          <2=> UARTTR1  <3=> PD4
;//     <o1.7..8>   PD5/INT5/DACK Pin        <0=> PD5      <1=> INT5
;//                                          <2=> DACK     <3=> PD5
;//     <o1.9..10>  PD6/INT6/DREQ Pin        <0=> PD6      <1=> INT6
;//                                          <2=> DREQ     <3=> PD6
;//   </e>

PD_MUX_SETUP    EQU     0
PD_MUX_Val      EQU     0x00000000

;//   <e> Port E
;//     <o1.0>      PE0/UARTRX2 Pin          <0=> PE0      <1=> UARTRX2
;//     <o1.1>      PE1/UARTTX2 Pin          <0=> PE1      <1=> UARTTX2 
;//     <o1.2..3>   PE2/CANRX/UARTRX0 Pin    <0=> PE2      <1=> CANRX
;//                                          <2=> UARTRX0  <3=> PE2
;//     <o1.4..5>   PE3/CANTX/UARTTX0 Pin    <0=> PE3      <1=> CANTX
;//                                          <2=> UARTTX0  <3=> PE3
;//     <o1.6>      PE4/SSPTX Pin            <0=> PE4      <1=> SSPTX
;//     <o1.7>      PE5/SSPRX Pin            <0=> PE5      <1=> SSPRX
;//     <o1.8>      PE6/SSPCLK Pin           <0=> PE6      <1=> SSPCLK
;//     <o1.9>      PE7/SSPFRM Pin           <0=> PE7      <1=> SSPFRM
;//   </e>

PE_MUX_SETUP    EQU     0
PE_MUX_Val      EQU     0x00000000

;//   <e> Timer Port
;//     <o1.0>      PG5/CTCLK Pin            <0=> PG5      <1=> CTCLK
;//     <o1.1..2>   PG6/CTCAP0A/CTCMP0A Pin  <0=> PG6      <1=> CTCAP0A
;//                                          <2=> CTCMP0A  <3=> PG6
;//     <o1.3..4>   PG7/CTCAP0B/CTCMP0B Pin  <0=> PG7      <1=> CTCAP0B
;//                                          <2=> CTCMP0B  <3=> PG7
;//     <o1.5>      PF0/CTCAP0C Pin          <0=> PF0      <1=> CTCAP0C
;//     <o1.6>      PF1/CTCAP0D Pin          <0=> PF1      <1=> CTCAP0D
;//     <o1.7>      PF2/CTCAP0E Pin          <0=> PF2      <1=> CTCAP0E
;//     <o1.8..9>   PF3/CTCAP1A/CTCMP1A Pin  <0=> PF3      <1=> CTCAP1A
;//                                          <2=> CTCMP1A  <3=> PF3
;//     <o1.10..11> PF4/CTCAP1B/CTCMP1B Pin  <0=> PF4      <1=> CTCAP1B
;//                                          <2=> CTCMP1B  <3=> PF4
;//     <o1.12..13> PF5/CTCAP2A/CTCMP2A Pin  <0=> PF5      <1=> CTCAP2A
;//                                          <2=> CTCMP2A  <3=> PF5
;//     <o1.14..15> PF6/CTCAP2B/CTCMP2B Pin  <0=> PF6      <1=> CTCAP2B
;//                                          <2=> CTCMP2B  <3=> PF6
;//   </e>

TIMER_MUX_SETUP EQU     0
TIMER_MUX_Val   EQU     0x00000000

;//   <e> LCD Port
;//     <o1.0..2>   Mode
;//                 <0=> No LCD
;//                 <1=> 4-bit mono STN
;//                 <2=> 4-bit mono STN Dual
;//                 <3=> 8-bit mono/color STN
;//                 <4=> TFT
;//                 <5=> No LCD  <6=> No LCD  <7=> No LCD
;//   </e>

LCD_MUX_SETUP   EQU     0
LCD_MUX_Val     EQU     0x00000000

;//   <e> ADC Port (Port J)
;//     <o1.0>      AN0/PJ0 Pin             <0=> AN0       <1=> PJ0 
;//     <o1.1>      AN1/PJ1 Pin             <0=> AN1       <1=> PJ1 
;//     <o1.2>      AN2/PJ2 Pin             <0=> AN2       <1=> PJ2 
;//     <o1.3>      AN3/PJ3 Pin             <0=> AN3       <1=> PJ3 
;//     <o1.4>      AN4/PJ4 Pin             <0=> AN4       <1=> PJ4 
;//     <o1.5>      AN5/PJ5 Pin             <0=> AN5       <1=> PJ5 
;//     <o1.6>      AN6/PJ6 Pin             <0=> AN6       <1=> PJ6 
;//     <o1.7>      AN7/PJ7 Pin             <0=> AN7       <1=> PJ7 
;//   </e>

ADC_MUX_SETUP   EQU     0
ADC_MUX_Val     EQU     0x00000000

;//   <e> Port A Resistors
;//     <o1.0..1>   PA0 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.2..3>   PA1 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.4..5>   PA2 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.6..7>   PA3 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.8..9>   PA4 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.10..11> PA5 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.12..13> PA6 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.14..15> PA7 Pin                 <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//   </e>

PA_R_MUX_SETUP  EQU     0
PA_R_MUX_Val    EQU     0x0000AAAA

;//   <e> Port B Resistors
;//     <o1.0..1>   PB0/nCS1 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.2..3>   PB1/nCS2 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.4..5>   PB2/nCS3 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.6..7>   PB3/nBLE0 Pin           <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.8..9>   PB4/nBLE1 Pin           <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.10..11> PB5/nWAIT Pin           <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//   </e>

PB_R_MUX_SETUP  EQU     0
PB_R_MUX_Val    EQU     0x00000555

;//   <e> Port C Resistors
;//     <o1.0..1>   PC0/A16 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.2..3>   PC1/A17 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.4..5>   PC2/A18 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.6..7>   PC3/A19 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.8..9>   PC4/A20 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.10..11> PC5/A21 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.12..13> PC6/A22 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.14..15> PC7/A23 Pin             <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//   </e>

PC_R_MUX_SETUP  EQU     0
PC_R_MUX_Val    EQU     0x0000095A

;//   <e> Port D Resistors
;//     <o1.0..1>   PD0/INT0 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.2..3>   PD1/INT1 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.4..5>   PD2/INT2 Pin            <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.6..7>   PD3/INT3/UARTTX1 Pin    <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.8..9>   PD4/INT4/UARTRX1 Pin    <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.10..11> PD5/INT5/DACK Pin       <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.12..13> PD6/INT6/DREQ Pin       <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//   </e>

PD_R_MUX_SETUP  EQU     0
PD_R_MUX_Val    EQU     0x0000095A

;//   <e> Port E Resistors
;//     <o1.0..1>   PE0/UARTRX2 Pin         <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.2..3>   PE1/UARTTX2 Pin         <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.4..5>   PE2/CANRX/UARTRX0 Pin   <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.6..7>   PE3/CANTX/UARTTX0 Pin   <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.8..9>   PE4/SSPTX Pin           <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.10..11> PE5/SSPRX Pin           <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.12..13> PE6/SSPCLK Pin          <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//     <o1.14..15> PE7/SSPFRM Pin          <0=> Pull-down <1=> Pull-up
;//                                         <2=> None      <3=> Pull-down 
;//   </e>

PE_R_MUX_SETUP  EQU     0
PE_R_MUX_Val    EQU     0x00004455

;// </e> End of IOCON


; Static Memory Controller (SMC) definitions
SMC_BASE        EQU     0xFFFF1000      ; SMC Base Address
BCR0_OFS        EQU     0x00            ; BCR0 Offset
BCR1_OFS        EQU     0x04            ; BCR1 Offset
BCR2_OFS        EQU     0x08            ; BCR2 Offset
BCR3_OFS        EQU     0x0C            ; BCR3 Offset

;// <e> Static Memory Controller (SMC)
;// <i> External Bus Interface (EBI)

SMC_SETUP       EQU     0

;//   <e> Bank Configuration 0 (BCR0)
;//     <o1.0..3>   IDCY: Idle Cycles <0-15>
;//     <o1.5..9>   WST1: Wait States 1 <0-31>
;//     <o1.11..15> WST2: Wait States 2 <0-31>
;//     <o1.10>     RBLE: Read Byte Lane Enable
;//     <o1.26>     WP: Write Protect
;//     <o1.27>     BM: Burst ROM
;//     <o1.28..29> MW: Memory Width  <0=>  8-bit  <1=> 16-bit
;//                                   <2=> 32-bit  <3=> Reserved
;//   </e>

BCR0_SETUP      EQU     0
BCR0_Val        EQU     0x0000FBEF

;//   <e> Bank Configuration 1 (BCR1)
;//     <o1.0..3>   IDCY: Idle Cycles <0-15>
;//     <o1.5..9>   WST1: Wait States 1 <0-31>
;//     <o1.11..15> WST2: Wait States 2 <0-31>
;//     <o1.10>     RBLE: Read Byte Lane Enable
;//     <o1.26>     WP: Write Protect
;//     <o1.27>     BM: Burst ROM
;//     <o1.28..29> MW: Memory Width  <0=>  8-bit  <1=> 16-bit
;//                                   <2=> 32-bit  <3=> Reserved
;//   </e>

BCR1_SETUP      EQU     0
BCR1_Val        EQU     0x1000FFEF

;//   <e> Bank Configuration 2 (BCR2)
;//     <o1.0..3>   IDCY: Idle Cycles <0-15>
;//     <o1.5..9>   WST1: Wait States 1 <0-31>
;//     <o1.11..15> WST2: Wait States 2 <0-31>
;//     <o1.10>     RBLE: Read Byte Lane Enable
;//     <o1.26>     WP: Write Protect
;//     <o1.27>     BM: Burst ROM
;//     <o1.28..29> MW: Memory Width  <0=>  8-bit  <1=> 16-bit
;//                                   <2=> 32-bit  <3=> Reserved
;//   </e>

BCR2_SETUP      EQU     0
BCR2_Val        EQU     0x1000FFEF

;//   <e> Bank Configuration 3 (BCR3)
;//     <o1.0..3>   IDCY: Idle Cycles <0-15>
;//     <o1.5..9>   WST1: Wait States 1 <0-31>
;//     <o1.11..15> WST2: Wait States 2 <0-31>
;//     <o1.10>     RBLE: Read Byte Lane Enable
;//     <o1.26>     WP: Write Protect
;//     <o1.27>     BM: Burst ROM
;//     <o1.28..29> MW: Memory Width  <0=>  8-bit  <1=> 16-bit
;//                                   <2=> 32-bit  <3=> Reserved
;//   </e>

BCR3_SETUP      EQU     0
BCR3_Val        EQU     0x1000FFEF

;// </e> End of SMC


                PRESERVE8
                

; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM


; Exception Vectors
;  Mapped to Address 0.
;  Absolute addressing mode must be used.
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC, Reset_Addr         
                LDR     PC, Undef_Addr
                LDR     PC, SWI_Addr
                LDR     PC, PAbt_Addr
                LDR     PC, DAbt_Addr
                NOP                            ; Reserved Vector 
;               LDR     PC, IRQ_Addr
                LDR     PC, [PC, #-0x0FF0]     ; Vector from VicVectAddr
                LDR     PC, FIQ_Addr

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      ; Reserved Address 
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
SWI_Handler     B       SWI_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     B       IRQ_Handler
FIQ_Handler     B       FIQ_Handler


; Reset Handler

                EXPORT  Reset_Handler
Reset_Handler   


; Setup Clock Controller
                IF      CLK_SETUP <> 0
                LDR     R0, =RCPC_BASE
                LDR     R1, =SYSPRESC_Val
                STR     R1, [R0, #SYSPRESC_OFS]
                LDR     R1, =SSPPRESC_Val
                STR     R1, [R0, #SSPPRESC_OFS]
                LDR     R1, =LCDPRESC_Val
                STR     R1, [R0, #LCDPRESC_OFS]
                LDR     R1, =CLKCTRL_Val
                STR     R1, [R0, #CLKCTRL_OFS]
                LDR     R1, =PCLKCTRL0_Val
                STR     R1, [R0, #PCLKCTRL0_OFS]
                LDR     R1, =PCLKCTRL1_Val
                STR     R1, [R0, #PCLKCTRL1_OFS]
                ENDIF


; Setup I/O Configuration
                IF      IOCON_SETUP <> 0
                LDR     R0, =IOCON_BASE

                IF      EBI_MUX_SETUP <> 0
                LDR     R1, =EBI_MUX_Val
                STR     R1, [R0, #EBI_MUX_OFS]
                ENDIF

                IF      PD_MUX_SETUP <> 0
                LDR     R1, =PD_MUX_Val
                STR     R1, [R0, #PD_MUX_OFS]
                ENDIF

                IF      PE_MUX_SETUP <> 0
                LDR     R1, =PE_MUX_Val
                STR     R1, [R0, #PE_MUX_OFS]
                ENDIF

                IF      TIMER_MUX_SETUP <> 0
                LDR     R1, =TIMER_MUX_Val
                STR     R1, [R0, #TIMER_MUX_OFS]
                ENDIF

                IF      LCD_MUX_SETUP <> 0
                LDR     R1, =LCD_MUX_Val
                STR     R1, [R0, #LCD_MUX_OFS]
                ENDIF

                IF      ADC_MUX_SETUP <> 0
                LDR     R1, =ADC_MUX_Val
                STR     R1, [R0, #ADC_MUX_OFS]
                ENDIF

                IF      PA_R_MUX_SETUP <> 0
                LDR     R1, =PA_R_MUX_Val
                STR     R1, [R0, #PA_R_MUX_OFS]
                ENDIF

                IF      PB_R_MUX_SETUP <> 0
                LDR     R1, =PB_R_MUX_Val
                STR     R1, [R0, #PB_R_MUX_OFS]
                ENDIF

                IF      PC_R_MUX_SETUP <> 0
                LDR     R1, =PC_R_MUX_Val
                STR     R1, [R0, #PC_R_MUX_OFS]
                ENDIF

                IF      PD_R_MUX_SETUP <> 0
                LDR     R1, =PD_R_MUX_Val
                STR     R1, [R0, #PD_R_MUX_OFS]
                ENDIF

                IF      PE_R_MUX_SETUP <> 0
                LDR     R1, =PE_R_MUX_Val
                STR     R1, [R0, #PE_R_MUX_OFS]
                ENDIF

                ENDIF   ; IOCON_SETUP


; Setup Static Memory Controller
                IF      SMC_SETUP <> 0
                LDR     R0, =SMC_BASE

                IF      BCR0_SETUP <> 0
                LDR     R1, =BCR0_Val
                STR     R1, [R0, #BCR0_OFS]
                ENDIF

                IF      BCR1_SETUP <> 0
                LDR     R1, =BCR1_Val
                STR     R1, [R0, #BCR1_OFS]
                ENDIF

                IF      BCR2_SETUP <> 0
                LDR     R1, =BCR2_Val
                STR     R1, [R0, #BCR2_OFS]
                ENDIF

                IF      BCR3_SETUP <> 0
                LDR     R1, =BCR3_Val
                STR     R1, [R0, #BCR3_OFS]
                ENDIF

                ENDIF   ; SMC_SETUP


; Setup Stack for each mode

                LDR     R0, =Stack_Top

;  Enter Undefined Instruction Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #UND_Stack_Size

;  Enter Abort Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #ABT_Stack_Size

;  Enter FIQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #FIQ_Stack_Size

;  Enter IRQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

;  Enter Supervisor Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #SVC_Stack_Size

;  Enter User Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_USR
                IF      :DEF:__MICROLIB

                EXPORT __initial_sp

                ELSE

                MOV     SP, R0
                SUB     SL, SP, #USR_Stack_Size

                ENDIF


; Enter the C code

                IMPORT  __main
                LDR     R0, =__main
                BX      R0

                IF      :DEF:__MICROLIB

                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE
; User Initial Stack & Heap
                AREA    |.text|, CODE, READONLY

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + USR_Stack_Size)
                LDR     R2, = (Heap_Mem +      Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
                ENDIF


                END
