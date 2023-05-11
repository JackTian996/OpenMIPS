<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OPEN\_MIPS](#open_mips)
  - [CP0 Access Insruction Implement](#cp0-access-insruction-implement)
    - [Registers](#registers)
  - [Exception Relative Instruction Implement](#exception-relative-instruction-implement)
    - [Exception in MIPS32 Arch](#exception-in-mips32-arch)
    - [Precise Exception](#precise-exception)
    - [Exception handle procedure](#exception-handle-procedure)
  - [Pratical OpenMIPS](#pratical-openmips)
    - [Pratical OpenMIPS design target](#pratical-openmips-design-target)
    - [Wishbone interface introduction](#wishbone-interface-introduction)
      - [Wishbone signals and connection](#wishbone-signals-and-connection)
      - [Wishbone Sinagle Read Sequence](#wishbone-sinagle-read-sequence)
      - [Wishbone Sinagle Write Sequence](#wishbone-sinagle-write-sequence)
      - [Wishbone Bus Bridge](#wishbone-bus-bridge)
  - [SOPC based Pratical OpenMIPS](#sopc-based-pratical-openmips)
    - [SOPC MicroArch](#sopc-microarch)
    - [WB\_CONMAX](#wb_conmax)
    - [GPIO](#gpio)
    - [UART Controller](#uart-controller)
      - [UART Protocol](#uart-protocol)
        - [UART Data Format](#uart-data-format)
        - [UART Receiver](#uart-receiver)
        - [Flow Control](#flow-control)
        - [UART16550 IP Introduction](#uart16550-ip-introduction)
          - [Register Table](#register-table)
          - [Calculate Divisor](#calculate-divisor)
    - [Flash Controller](#flash-controller)

<!-- /code_chunk_output -->

# OPEN_MIPS

## CP0 Access Insruction Implement

### Registers

![image](/media/cp0_status_reg.png)
![image](/media/cp0_cause_reg.png)
![image](/media/exccode.png)

## Exception Relative Instruction Implement

### Exception in MIPS32 Arch

openmips only implement the following 6 exception types:

| Priority | Excepton  | Description |
|----------|-----------|-------------|
|1        | Reset |  Hardware Reset           |
|7        | Interrupt |  6 Hardware Int and 2 Software           |
| 16       | Sys       |  System Call           |
| 16       | RI        |  Invalid instruction           |
| 16       | Ov        |   Overflow(add,addi,sub)          |
| 16       | Tr        |  Self Trap           |

Hardware reset is a particular exception. It don't need to return from exception
roution,so don't need to protect context and save return address. When reset,all
registers are cleared to zero,and fetch instruction from address 0x0.

### Precise Exception

**Exception Victim**: the instruction occur exception.
**Problem**: To support precise interrupt,the sequence of exception occurence must be same with the sequence of instruction.
**Solution**: The previous exception get marked, rather than being handled immediately, and the pipeline keep going.
For most processor,there is a special pipeline stage to handle exception.
Although the exception can occur at random time, the instruction must arrive at same stage in order.

### Exception handle procedure

| Excepton  | Vector |
|----------------|-----------|
| Reset       |   0x20        |
| Interrupt   | 0x40           |
| Sys          | 0x40           |
| RI            |  0x40           |
| Ov           |   0x40         |
| Tr            |  0x40           |

***
![image](/media/exception_handle_routine.svg "exception_handle_routine")

- ERET instruction is processed as special exception
- suport exception nesting
- Do not support exception priority

## Pratical OpenMIPS

### Pratical OpenMIPS design target

![image](/media/fpga.png)

### Wishbone interface introduction

OpenMIPS support Wishbone B2

#### Wishbone signals and connection

![image](/media/wishbone_connection.png)

#### Wishbone Sinagle Read Sequence

![image](/media/wishbone_read.png)

#### Wishbone Sinagle Write Sequence

![image](/media/wishbone_read.png)!

#### Wishbone Bus Bridge

![image](/media/wishbone_bus_if.png)

***
**Note: stall_req_from_if should stall pc,if,id(stall[5:0] = 6'b000111), so that branch instruction can keep order with delayslot instruction.**

## SOPC based Pratical OpenMIPS

### SOPC MicroArch

![image](/media/sopc_microarch.png)

### WB_CONMAX

- support max 8 master
- support max 16 slave
- integrated arbiter support 1,2,4 priority
- support multiple communicate between master and slave at one time
- support Wishbone B2

![image](/media/wb_conmax.png)

WB_CONMAX use high 4 bit address to deceide slave number. So each slave can have max 256M space.

| Slave       | Start Address | Start Address |  Size |
|----------------|---------------------|--------------------|----|
| SDRAM    |  0x00000000  | 0x0FFFFFFF |  256M    |
| UART       |  0x10000000  | 0x1FFFFFFF  |   256M   |
|GPIO         |  0x20000000  | 0x2FFFFFFF  |  256M   |
| Flash        |  0x30000000 | 0x3FFFFFFF  |   256M   |

### GPIO

- support 32 pins
- no support bidirectional pons
- input pins can trigger interrupt
- no support aux input pins
- only support one clock domain
- support Wishbone B

### UART Controller

#### UART Protocol

##### UART Data Format

![image](/media/uart.png)

UART buad rate: 9600,19200,38400 etc.

##### UART Receiver

Receiver use higher sample frequency than buad rate, 16 times higher than buad rate generally. The following picture use 4 times as example.

![image](/media/uart_receiver.png)

  (a) check the start bit when received signal High to Low level
  (b) after 2 cycle, check the signal, if keep low level, it is the correct start bit, otherwise assume it's error. ignore the signal
  (c) wait 4 cycle from correct start bit, capture the LSB
  (d) capture 1 bit of data and parity every 4 cycle, so always capture data in the middle, it can be stable
  (e) check the stop bit

##### Flow Control

2 handshake interface:

- RTS(require to send)/CTS(clear to send)
- DTR(Data Terminal Ready)/DSR(Data Set Ready)
  
![image](/media/uart_fc.png)

##### UART16550 IP Introduction

- Compatible with National Semiconductor 16550A device
- Support Wishbone B
- Configurable 32/8 Wishbone data width

###### Register Table

![image](/media/uart_reg.png)
![image](/media/uart_reg2.png)

NOTE: when Line Control Register(LCR) bit7 = 1, BASE+0x0, Base+0x1 is 2 divisor registers, otherwise represent the initial registers.

###### Calculate Divisor

2 divsior register compose a 16 bit frequency division factor.

**Factor = System Clk Freq / (16 * Buad Rate)**

When programming, set the high byte Divisor Latch Byte 2 firstly, and then set the low byte Divisor Latch Byte 1.

### Flash Controller

NOR Flash interface

![image](/media/flash_if.png)

read sequence

![image](/media/flash_rd_seq.png)
