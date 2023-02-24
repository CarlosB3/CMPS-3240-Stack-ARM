.data
.global string1
string1:
        .ascii  "The factorial of %d is %d!\n\0"
string2:
        .ascii  "Entering fact() with n=%d\n\0"

.text
.extern printf
.global main
main:
### SET UP FRAME RECORD ###
# Save FP and LR with pre-indexing, allocated another 16 bytes for temp.
stp     x29, x30, [sp, -16]!
# Set FP
add     x29, sp, 0

### MAIN() LOGIC ###
# Call fact(6)
mov     x0, 13
bl      fact
# Respond with prompt
add     x2, x0, 0
mov     x1, 13
ldr     x0, =string1
bl      printf

### TAKE DOWN FRAME RECORD ###
ldp     x29, x30, [sp], 16
mov     w0, 0
ret

.global fact
fact:
### SET UP FRAME RECORD ###
# Save FP and LR with pre-indexing, allocated another 16 bytes for temp.
stp     x29, x30, [sp, -32]!
# Set FP
add     x29, sp, 0
# Shadow input argument
str     x0, [sp, 16]

### LOGIC FOR FACT() ###
ldr     x0, [sp, 16]
cmp     x0, 0
# If n <= 1, return 1 ... jump to block that returns 1
beq     return0

cmp     x0, 1
beq     return1
# Logic for calc. n * fact(n-1) here. At this instruction the value for x0 
# should still hold arg1 for this call. Calculate n-1, note it's set up in x0 
# which is the argument register
sub     x0, x0, 2
# This is the call to fact(n-1)
bl      fact
# At this point x0 contains the return value for fact(n-1). Refresh value for
# arg1.
str     x0, [sp,24]
ldr     x0, [sp, 16]
sub     x0, x0, 1
bl      fact
ldr     x9, [sp,24]
add     x0, x0, x9

return:
ldp     x29, x30, [sp], 32
ret

return0:
mov     x0, 0
b return
# return1 block falls through to the return code
return1:
mov     x0, 1
b return
~                                                                                                                                                 
                                                                                                                                1,1           All

