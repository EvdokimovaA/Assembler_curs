format PE Console 4.0
entry Start

include '%finc%\win32\win32a.inc'

section '.data' data readable writeable
  counter dd ?
  number dd ?
  array dd 5 dup (?)
  spec_scanf db '%hhu', 0
  spec_print db '%hhu ', 0
  spec_string db '%s', 0
  message db 'Please, entry 5 unsigned decimal numbers 0 to 255 inclusively: ', 0x0D, 0x0A, 0
  entered db 'Entered numbers (decimal): ', 0x0D, 0x0A, 0
  result db 'Result (decimal): ', 0x0D, 0x0A, 0
  press db 'Press any key...', 0x0D, 0x0A, 0
  endl_string db ' ', 0x0D, 0x0A, 0

section '.text' code readable executable
Start:
  cinvoke printf, spec_string, message
  mov ecx, 5
  mov ebx, 0

  cycle:
    push ecx
    cinvoke scanf, spec_scanf, number
    mov eax, [number]

    mov [array+ebx], eax
    inc ebx
    pop ecx
    loop cycle


  cinvoke printf, spec_string, endl_string
  cinvoke printf, spec_string, entered

  mov ecx, 5
  mov esi, array
  cycle_print:
    push ecx
    lodsb
    cinvoke printf, spec_print, eax
    pop ecx
    loop cycle_print

  change:
    mov esi, array
    mov edi, array
    xor edx, edx

    cycle_changing:
      cmp edx, 5
      je print_results
      lodsb
      mov ebx, 90
      xor eax, 77
      and ebx, edx
      sub eax, ebx
      stosb
      inc edx
      jmp cycle_changing

  print_results:
    mov esi, array
    mov [counter], 0
    cinvoke printf, spec_string, endl_string
    cinvoke printf, spec_string, endl_string
    cinvoke printf, spec_string, result
    cycle_of_results:
      cmp [counter], 5
      je press_key
      lodsb
      cinvoke printf, spec_print, eax
      add [counter], 1
      jmp cycle_of_results

    press_key:
    cinvoke printf, spec_string, endl_string
    cinvoke printf, spec_string, endl_string
    cinvoke printf, spec_string, press
    cinvoke getch, 0
    invoke ExitProcess, dword 0

section '.idata' import data readable writeable
  library kernel32, 'KERNEL32.DLL', msvcrt, 'MSVCRT.DLL'
  import kernel32, ExitProcess, 'ExitProcess'
  import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch'
