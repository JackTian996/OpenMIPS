# open_mips
# Exception Relative Instruction Implement
## Exception in MIPS32 Arch
openmips only implement the following 6 exception:
- Reset(HW)
- Interrupt(HW/SW)
- Invalid instruction
- Overflow(add,addi,sub)
- Selftrap

Hardware reset is a particular exception. It don't need to return from exception
roution,so don't need to protect context and save return address. When reset,all
registers are cleared to zero,and fetch instruction from address 0x0.

## Precise Exception
Exception Victim: the instruction occur exception.
To support precise interrupt,the sequence of exception occurence must be same
with the sequence of instruction.
The previous exception get marked, rather than being handled immediately, and
the pipeline keep going.
For most processor,there is a special pipeline stage to handle exception.
Although the exception can occur at random time, the instruction must arrive at
same stage in order.

## Exception handle procedure
