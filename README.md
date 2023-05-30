<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OPEN\_MIPS](#open_mips)
  - [ISA](#isa)
  - [Logic/Shift/nop Instruction Implement](#logicshiftnop-instruction-implement)
  - [Move Instruction Implement](#move-instruction-implement)
  - [Arithmetic instruction implement](#arithmetic-instruction-implement)
    - [simple arithmetic](#simple-arithmetic)
    - [Stall Mechanism](#stall-mechanism)
  - [Jump/Branch Insruction Implement](#jumpbranch-insruction-implement)
  - [LOAD/STORE Insruction Implement](#loadstore-insruction-implement)
    - [ll/sc](#llsc)
    - [load relative problem](#load-relative-problem)
  - [CP0 Access Insruction Implement](#cp0-access-insruction-implement)
    - [CP0 Registers](#cp0-registers)
    - [CP0 Access Instruction](#cp0-access-instruction)
  - [Exception Relative Instruction Implement](#exception-relative-instruction-implement)
    - [Exception in MIPS32 Arch](#exception-in-mips32-arch)
    - [Precise Exception](#precise-exception)
    - [Exception handle procedure](#exception-handle-procedure)
    - [Implement details](#implement-details)
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
    - [SDRAM Controller](#sdram-controller)
  - [Altera DE2-70 FPGA Test](#altera-de2-70-fpga-test)
  - [uC/OS-II Migration](#ucos-ii-migration)
    - [Feature](#feature)
    - [Concept](#concept)
      - [Task](#task)
      - [Dispatch](#dispatch)
      - [Context Switch](#context-switch)
      - [Interrupt Handler](#interrupt-handler)
      - [Clock Tick](#clock-tick)
      - [uC/OS-II initialize](#ucos-ii-initialize)
      - [uC/OS-II start](#ucos-ii-start)
    - [uC/OS-II basic function](#ucos-ii-basic-function)
      - [Communication and Synchronization](#communication-and-synchronization)
      - [Task Management](#task-management)
      - [Time Management](#time-management)
      - [Memory Management](#memory-management)
      - [Dispatch(Schedule)](#dispatchschedule)
    - [MIPS Function Call Standard](#mips-function-call-standard)
      - [Register Standard](#register-standard)
      - [Variable Transfer](#variable-transfer)
      - [Return Variable](#return-variable)
      - [Stack Placement](#stack-placement)
    - [Transplant](#transplant)

<!-- /code_chunk_output -->

# OPEN_MIPS

## ISA

Instruction format in MIPS32 Arch:

![image](/media/inst_format.png)

## Logic/Shift/nop Instruction Implement

There are 3 types relative problem

- structure relative (memory RW access conflict)
- data relative (later instruction need previous result)
- control relative (branch instruction)

Data relative : RAW, WAR, WAW
Because pipeline is in strong order, only RAW will exit.
data forward:
Register File module output new data when rd and wr conflict.
![image](/media/data_forward.png)

However we assume that register value can get in EX stage.
If previous instruction is LOAD, it is not compatible.

## Move Instruction Implement

movn, movz, mfhi, mthi, mflo, mtlo.
Need add special register :HI, LO.
HI, LO register is used to store result of multiply and divide.
For multiply, HI store higer 32 bits, LO store lower 32 bits.
For divide, HI store remainder, LO store quotient.

movn rd,rs,rt : if rt != 0 then rd <- rs
movz rd,rs,rt : if rt == 0 then rd <- rs
At ID stage, add 1 operaton: detemine whether to write rd according rs.

mfhi : rd <- hi
mflo : rd <- lo
At ID stage, wreg_o = WriteEnable, wd_o = rd
At EX stage, read HI,LO
At MEM stage, bypass
At WB stage, write rd

mthi : hi <- rs
mtlo : lo <- rs
At ID stage, wreg_o = WriteDisable
At EX stage, detemine the data needed to write HI,LO
At MEM stage, bypass
At WB stage, write HI,LO

![image](/media/hilo_forward.png)

## Arithmetic instruction implement

### simple arithmetic

add, addu, sub, subu, slt, sltu,
add rd,rs,rt : rd <- rs+rt, when overflow, dont save result
addu rd,rs,rt : same with add, but always save result, dont chcek overflow
sub rd,rs,rt : rs <- rs-rt, when overflow, dont save result
subu rd,rs,rt : same with sub, but always save result, dont chcek overflow
slt rd,rs,rt : rd <- (rs < rt) signed compare
sltu rd,rs,rt : rd <- (rs < rt) unsigned compare

addi, addiu, slti, sltiu
immediate: signed extended

clo, clz
clz rd,rs : rd <- count_leading_zeros rs
clo rd,rs : rd <- count_leading_ones rs

multu, mult, mul
mul rd,rs,rt : rd <- rs X rt signed multi, lower 32bit store to rd
mult rs,rt : {hi,lo} <- rs X rt signed multi
multu rs,rt : {hi,lo} <- rs X rt unsigned multi

### Stall Mechanism

madd, maddu, msub, msubu
Need 2 cycle to complete.
madd rs,rt : {HI,LO} <- {HI,LO} + rs X rt
maddu rs,rt : unsigned
msub rs,rt : {HI,LO} <- {HI,LO} - rs X rt
msubu rs,rt : unsigned

![image](/media/madd_design.png)

To avoid madd or msub perform repeatly when stall from other instruction:
![image](/media/madd_avoid_repeat.png)

div, divu
The implemention of OPENMIPS use 32 cycle to complete divide.
div rs,rt : {HI,LO} <- rs / rt
div rs,rt : unsigned

![image](/media/divide_design.png)
![image](/media/divide_module.png)
![image](/media/divide_state_mechine.png)

OpenMIPS takes an advanced stall mechanism.If stage n instruction need several cycle to complete.

- the PC and stage previous n keep value
- stage n clear the value to insert nop
- the instructions after stage n can go on normally.

For primary version OpenMIPS, only stage ID and EX can request stall.Other stages can complete operation in one cycle.

![image](/media/stall_ctrl.png)

ID stall req: (pre_inst_is_load == 1'b1) && (ex_wd_i == reg1_addr_o/reg2_addr_o)
EX stall req: stallreq_for_madd_msub || stallreq_for_div

## Jump/Branch Insruction Implement

Delay slot instruction is always processed.
At ID stage detemine whether to branch.

**jump instruction**
jr rs : PC <- rs
jalr rs, jalr rd,rs : PC <- rs, $31/rd <- return address
j target : PC <- [PC+4](31:28) || target || '00'
target = inst_index << 2
jal target : $31 < return address

**Branch Instruction**
![image](/media/branch_inst.png)

branch address = (signed extend)(offset || '00') + (PC + 4)

![image](/media/branch_inst_data_flow.png)
![image](/media/branch_structure.png)

There is a **is_in_delayslot_o** flag for delayslot instruction.
The function is : to record in exception cause register BD(Branch DelaySlot) field
NOTE: if exception instruction is in delayslot, the EPC register store the previous pc, which is branch instruction.

## LOAD/STORE Insruction Implement

lb, lbu, lh, lhu, ll, lw, lwl, lwr
sb, sc, sh, sw, swl, swr

load/store address = signed_extended(offset) + GPR[base]

### ll/sc

Atomic access
RMW suquence is atomic, can not insert any other opeation.
Operations in **Critical Region** is Atomic.
OS use semaphore to create Critical Region generally.

```` c
wait(semaphore);
  atomic;
signal(semaphore);
````

ll : ll rt,offset(base)

- load a word same with lw
- set llbit 1 to indicate a ll operation and store address to LLAddr(this register is implemented in multi-core processor, OpenMIPS don't implement that)

After ll, program will perform several operations, and then perform sc.The sequence is RMW.If any instruction is inserted in the sequence, the llbit will be set to 0.

- Exception or thread switch between ll and sc
- Other core write the LLAddr space in muli-core system

sc : sc rt,offset(base)

- check llbit
  - 1 atomic success : write back and set rt 1
  - 0 atomic fail : don't write back and set rt 0

![image](/media/load_store_llbit.png)
![image](/media/llbit_structure.png)

### load relative problem

![image](/media/load_relative_structure.png)

## CP0 Access Insruction Implement

CP0 function:

- Configure CPU working status (big-endian/little-endian)
- Cache control
- Exception control (exception level, interrupt enable, interrupt mask)
- Memory management (MMU/TLB)
- MISC: timer, counter, parity, clock

### CP0 Registers

![image](/media/cp0_status_reg.png)
![image](/media/cp0_cause_reg.png)
![image](/media/exccode.png)

### CP0 Access Instruction

mtc0

- ID stage read rt
- EX stage bypass
- MEM stage bypass
- WB stage write rd address of CP0

mfc0

- EX stage read CP0 register
- MEM stage bypass
- WB stage write to rt in Register File

![image](/media/cp0_data_flow.png)

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

### Implement details

At pipeline stages, collect exception information and pass to MEM stage where exception get processed.

- At ID stage, determine whether **system call, eret, invalid**
- At EX stage, determine whether **trap, overflow**
- At MEM stage, determine whether **interrupt**

![image](/media/exception_structure.png)
![image](/media/exception_type.png)

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

### SDRAM Controller

## Altera DE2-70 FPGA Test

Bootloader and SimpleOS simulate OS boot and load procedure.
Both program are saved in flash.
The following picture shows the position in flash.

![image](/media/bootloader_in_mem.png)

OpemMIPS boot procedure:

- uart, gpio, sdram initial
- read length info at 0x300
- move SimpleOS image to sdram
- jump to 0x0

SimpleOS function:

- HOST transmit data to OpenMIPS by UART
- OpenMIPS uart receive data and assert interrupt
- The interrupt handler read the data and transmit back to HOST
- HOST display the same data

Here are some screenshot of lab:
![image](/media/lab_fpga_compile.png)
![image](/media/lab_signaltap2.png)
![image](/media/lab_display.png)

## uC/OS-II Migration

### Feature

- Preemptive
  always run ready task of the higest priority
- Multi Task
  system give each task different priority, means can't suppurt time slice scheduling(Round-robin Scheduling)
- Deterministic
  Function call and service execute times are deterministic.User always know how many times the function call and service execute
- Task Stack
  each task has individual stack. There is a **stack space check function** to confirm space that the task need indeed
- System Service
  support many **system service** : semaphore, event flag, message mailbox, message queue, fixed block size memory allocate and release, time management function
- Interrupt Handle
  The running task will be suspended temporarily when interrupt assert. If a higher priority task is awakened by interrupt, the task will execute immediately after all nesting interrupt handler quit

### Concept

#### Task

Task, aka thread, a simple program. uC/OS-II is a multi-thread OS. Each task is a while(1). Task has 5 status.

- Dormant: task remain in memory, but is not scheduled by kernel
- Ready: means task is ready for running, but can't run now because of lower priority. When task is created, it's in Ready status.
- Running: task master CPU. The highest priority Ready task can get CPU and transfer to Running
- Pending: task is waiting a EVENT(device I/O, shareble resource, timely pluse). The task is put on a WAIT List of the event.
- Interrupt: Running task can be interrupted, otherwise the task disable interrupt. When task is interrupted, CPU jump to interrupt handler and the task go into Interrupt

When system is initialized, 2 task are created automatically:

- IDLE task: lowest priority, 32bit int variable +1
- Statistic task: execute per second, collect CPU utilization rate

Each task has coresponding OS_TCB that is a data structure to save status when scheduling. The first word in TCB is stack pointer.

![image](/media/struct_os_tcb.png)

#### Dispatch

#### Context Switch

#### Interrupt Handler

- save all CPU registers
- call **OSIntEnter** or variable OSIntNesting + 1 directly
- clear interrupt src
- re-enable interrupt
- execute user code to  handle interrupt
- call **OSIntExit**
- restore all CPU registers
- execute interrupt return inst

When nesting interrupts are completed, OS must determine whether higher priority task is wake up. If so, return to higher task. Otherwise, return to the task is interrupted.

#### Clock Tick

Clock Tick is a periodic interrupt. It can make kernel delay a task several cycle and provide overtime determination when a task wait for event.

Sequence: OSInit -> OSStart -> enable clock tick interrupt

#### uC/OS-II initialize

Call OSInit function to initialize all variables and data structures and create OS_TaskIdle, which is always in Ready status and has lowest priority. If allowing statistic task, the OS_TaskStat is created, which fall into Ready status and has OS_LOWEST_PRIO - 1.

#### uC/OS-II start

Before OS starts, at least 1 task is created. OSStart function find highest priority TCB in Ready list, then call OSStartHighRdy in os_cpu_a.S

### uC/OS-II basic function

#### Communication and Synchronization

Task or interrupt service program can use ECB(Event COntrol Block) pass signal to other task. The signal, aka Event, can be semaphore, mailbox, message quque and so on.

#### Task Management

- OSTaskCreate or OSTaskCreateExt
- OSTaskStkChk
- OSTaskDel
- OSTaskDelReq
- OSTaskChangePrio
- OSTaskSuspend
- OSTaskResume
- OSTaskQuery

#### Time Management

- OSTimeDly
- OSTimeDlyHMSM
- OSTimeDlyResume
- OSTimeGet
- OSTimeSet

#### Memory Management

uC/OS-II manages consecutive large size memory as sections. Each section has same size and integral memory block. However, different sections have coresponding block size.

- malloc: allocate by block
- free: return back to the section that it belones to.

And the execution time is determined.

OS use Memory Control Block data structure track every sections. Each section has 1 MCB.

- OSMemCreate
- OSMemGet
- OSMemPut
- OSMemQuery

#### Dispatch(Schedule)

### MIPS Function Call Standard

#### Register Standard

![image](/media/reg_standard.png)

#### Variable Transfer

**1.  use stack**
![image](/media/stack_var_transf.png)
**2. use register**
a0-a3

#### Return Variable

Integer or pointer type return value will be placed at v0($2).
Long long type value will also use v1($3).
When return a structure or long value, v0 and v1 can't cover it:

- caller create a memory segment and use a pointer point to it.
- caller pass the pointer as first parameter(a0) to callee
- callee complete and copy return value to that memory space, and use v0 point to it

#### Stack Placement

![image](/media/stack_place.png)
![image](/media/task_start_stack_place.png)

### Transplant

![image](/media/file_org.png)
![image](/media/file_tree.png)
