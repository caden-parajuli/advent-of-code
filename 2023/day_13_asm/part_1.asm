; asmsyntax=fasm
format ELF64 executable
use64
entry start

; Macros

include "utils.inc"
include "struct.inc"

debug equ false

macro breakpoint {
    if debug eq true
        int3
    end if
}

macro exit code {
    mov rdi, code
    mov rax, SYS_EXIT
    syscall
}

macro open filename {
    mov rdi, filename
    xor rsi, rsi       ; Read mode
    mov rax, SYS_OPEN
    syscall
}

macro close fd {
    mov rdi, fd
    mov rax, SYS_CLOSE
    syscall
}

macro fstat fd, buff {
    local no_err
    mov rdi, fd
    mov rsi, buff
    mov rax, SYS_FSTAT
    syscall
    cmp rax, 0
    je no_err
    close fd
    exit 1
    no_err:
}

macro mmap fd, length {
    mov rdi, 0            ; Let kernel decide where to map in virtual memory
    mov rsi, length       ; length of mapping
    mov rdx, PROT_READ    ; Read-only
    mov r10, MAP_PRIVATE  ; Don't share with other processes
    mov r8, qword fd
    mov r9, 0             ; 0 offset
    mov rax, SYS_MMAP
    syscall
}

macro print buffer, length {
    mov rdi, STDOUT
    mov rsi, buffer
    mov rdx, length
    mov rax, SYS_WRITE
    syscall
}


; rodata
segment readable
filename      db "input", 0
final_str     db "Final output: ", 0
final_str_len dq 14

; text
segment readable executable

start:
  breakpoint

  open filename
  mov [file_desc], rax

  fstat [file_desc], stat            ; Get file size

  mmap [file_desc], [stat.st_size]   ; Map file into memory
  mov [file_addr], rax
  mov [pattern_base], rax

  close [file_desc]                  ; After mmap we can close the file descriptor

  mov [total], 0

get_pattern_data:
  breakpoint
  mov r10, [pattern_base]            ; r10 = Pattern base
  ; Check if we're done with the file
  mov r11, [file_addr]
  add r11, [stat.st_size]
  dec r11
  cmp r10, r11
  jge stop

  xor r11, r11                       ; r11 = stride
get_stride_loop:
  inc r11
  mov r15b, 10
  cmp byte [r10 + r11], r15b
  jne get_stride_loop
  inc r11
  mov [stride], r11

  xor r12, r12                       ; r12 = number of rows
  xor r13, r13                       ; r13 = offset of ending '\n' from base
get_lines_loop:
  inc r12
  add r13, r11
  lea r14, [r10 + r13 + 1]
  mov r15, [file_addr]
  add r15, [stat.st_size]
  ; breakpoint
  cmp r14, r15                       ; Check if we're at EOF
  jge pre_check_ver_mirrors
  mov r15b, 10                       ; Load newline into r15
  cmp byte  [r10 + r13], r15b        ; Check for newline
  jne get_lines_loop

pre_check_ver_mirrors:
  breakpoint
  xor r14, r14                       ; r14 = current column immediately to the right of mirror
check_ver_mirrors:
  inc r14
  mov r15b, 10
  cmp byte  [r10 + r14], r15b        ; Check if done checking for vertical mirrors
  je pre_check_hor_mirrors

  lea rax, [r14 - 1]                 ; rax = Left-side reflection
  mov r8, r14                        ; r8  = Right-side reflection
  jmp check_single_ver_mirror        ; Don't increment for the first time
check_single_ver_mirror_loop:
  inc r8
  dec rax
check_single_ver_mirror:
  ; Check if we're done
  cmp rax, 0
  jl ver_success
  mov r15b, 10
  cmp byte [r10 + r8], r15b
  je ver_success

  mov rcx, rax                       ; rcx = Left-side reflected part of line
  mov r9, r8                         ; r9  = Right-side reflected part of line
check_ver_line_loop:
  ; Check if we're at the end of the vertical line
  cmp rcx, r13
  jge check_single_ver_mirror_loop
  cmp r9, r13                        ; Maybe unnecessary
  jge check_single_ver_mirror_loop

  ; Check next mirror if characters don't match
  mov r15b, byte  [r10 + rcx]        ; r15 = temporary for memory access
  cmp r15b, byte  [r10 + r9]
  jne check_ver_mirrors

  ; Keep checking
  add rcx, r11
  add r9, r11
  jmp check_ver_line_loop

ver_success:
  breakpoint
  add [total], r14
  lea r10, [r10 + r13] 
  ; mov r10, r13
  inc r10
  mov [pattern_base], r10
  jmp get_pattern_data



pre_check_hor_mirrors:
  breakpoint
  xor r14, r14                       ; r14 = current row immediately below mirror
  xor rbx, rbx                       ; rbx = offset of current row (r14 * stride)
check_hor_mirrors:
  inc r14                            ; Next row
  add rbx, r11                       ; Add stride

  cmp r14, r12                       ; Check if we're done (on the bottom row)
  jge nothing_found                  ; No horizontal (or vertical) mirrors were found

  ; Preamble
  mov rax, rbx                       ; rax = Top-side reflection row offset
  sub rax, r11                       ; subtract stride
  mov r8,  rbx                       ; r8  = Bottom-side reflection row offset
  jmp check_single_hor_mirror
check_single_hor_mirror_loop:
  sub rax, r11
  add r8, r11
check_single_hor_mirror:
  ; Check if we're done with this mirror
  cmp rax, 0
  jl hor_success
  cmp r8, r13
  jge hor_success

  mov rcx, rax                       ; rcx = Top-side reflection character offset from pattern base
  mov r9, r8                         ; r9  = Bottom-side reflection character offset from pattern base
check_hor_line_loop:
  mov r15b, 10
  cmp r15b, byte [r10 + rcx]         ; Only check the top side because checking bottom could cause buffer overflow
  je check_single_hor_mirror_loop

  ; Go to next mirror if characters don't match
  mov r15b, byte  [r10 + rcx]        ; r15 = temporary for memory access
  cmp r15b, byte  [r10 + r9]
  jne check_hor_mirrors

  ; Keep checking
  inc rcx
  inc r9
  jmp check_hor_line_loop

hor_success:
  breakpoint
  mov rdx, 0                         ; Clobber rax and rdx to multiply
  mov rax, 100                       
  mul r14                            ; rax = 100 * r14
  add [total], rax
nothing_found:
  lea r10, [r10 + r13 + 1]           ; Go to the next pattern
  mov [pattern_base], r10
  jmp get_pattern_data 
  

; Output/cleanup
stop:
  breakpoint
  ; Print the "Final output: " text
  print final_str, [final_str_len]

  ; Process the total into characters
  mov rax, [total]
  mov r9,  1                         ; r9 = least power of 10 greater than r10
  mov r8,  0                         ; r8 = log10(r9) = total number of digits
shift:
  inc r8
  lea r9, [r9 + 4 * r9]              ; r9 *= 5
  add r9, r9                         ; r9 += r9
  cmp r9, rax
  jl shift

  mov r11, 10                        ; r11 = 10
  mov r12, r8                        ; r12 = current offset
  dec r12
mask_out:
  mov rdx, 0                         ; rdx = 0 (for division)
  div r11                            ; rax = rax / 10, rdx = rax % 10
  ; Convert rdx to char and put in buffer
  add rdx, '0'
  mov byte [outstr + r12], dl
  dec r12
  mov r15, 0                         ; temp to check if non-zero
  cmp rax, r15
  jg mask_out

  ; Done converting; print
  mov byte [outstr + r8], 10          ; Write a newline
  add r8, 1
  print outstr, r8
  
  exit 0
  



; bss
segment readable writeable

file_desc      rq 1
stat           STAT
file_addr      rq 1
pattern_base   rq 1
stride         rq 1
total          rq 1
outstr         rb 21                 ; 1 + max string length of decimal 64-bit int
