<h2 align="center"> &nbsp;&nbsp;x86 ASM OS</h2>
<br/>

> A basic OS that I am making in x86 Assembly

---

## Requirements
 - NASM/FASM (any assembly compiler will do)
 - Qemu
 - Make (not neccesary but reccomended)
   
## Instructions

#### Directions to Install
```sh
$ git clone https://github.com/AngadBasandrai/x86-asm-os.git
```
#### Directions to Run
```sh
> make
```

<hr/>

## NASM installation
- <a href="https://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D"> NASM </a>
> Install the latest version

> Make sure to add it to PATH

## Qemu installation
- <a href="https://www.qemu.org/download/"> Qemu </a>
> Make sure to add it to PATH

## Make installation
> There are many different ways to install make but I reccomend installing it through chocolatey
- First open powershell as admin
```sh
> Get-ExecutionPolicy
```
- If it returns Restricted then run the next command otherwise skip that step
```sh
> Set-ExecutionPolicy AllSigned
```
- Now run the following command
```sh
> Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
- Wait a few seconds and if you see no errors then run
```sh
> choco install make
```


# Explanation

## <a href="https://github.com/AngadBasandrai/x86-asm-os/blob/main/src/asm/boot.asm">boot.asm</a>
```asm
[org 0x7c00]
```
This defines the starting location or origin of code, so that the assembler can correctly calculate offsets

```asm
times 510-($-$$) db 0
dw 0xAA55
```
The first line pads out the first 510 bytes with 0's 
The second line defines whether to use big endian or little endian, which defines in which order of significance bytes are read

## <a href="https://github.com/AngadBasandrai/x86-asm-os/blob/main/src/utility/disk_load.asm">disk_load.asm</a>

This function uses ```ah = 0x02, int 0x13``` to read sectors from disk

```asm
mov ah, 0x02

mov al, 0x04
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
mov dl, 0x80 
```
```mov ah, 0x02``` just defines the operation

al =: no. of sectors to read

ch =: cylinder no.

cl =: starting sector (1 based not 0 based)

dh =: head no.

dl =: drive no.

The drive is set 0x80 as that is conventionally the first hard drive
> al and cl are set according to how the files and compiled and concatenated

> Read more about <a href="https://en.wikipedia.org/wiki/Cylinder-head-sector">Cylinder-Head-Sector</a> memory addressing

```asm
mov bx, 0x2000
mov es, bx
mov bx, 0x0000 

int 0x13   
```
[ES:BX] is the location where sectors are read to by ```int 0x13```


```asm
mov ax, 0x2000
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
```
This code resets all segment registers to point to the newly loaded memory location

```asm
jmp 0x2000:0x0000
```
This code jumps to the newly loaded location

## <a href="https://github.com/AngadBasandrai/x86-asm-os/blob/main/src/functions/print_string.asm">print_string.asm</a>

This function uses ```ah = 0x0e, int 0x10``` to print the value inside at memory location in 'si'

The instructions ```pusha``` and ```popa``` are used to store and retrieve registers to and from the stack respectively

In each iteration:
- it moves the value at si into al
- checks if it is the end of the string i.e. is the value = 0, since we terminate strings with 0 or null terminate them so that we can find their end
	- if it is then, returns back
	- if not then ```int 0x10``` prints the character and it goes through the loop again while also incrementing the pointer location/si i.e. going to the next character

```asm
cmp al, 0
```
This compares al with 0
```asm
je _printString
```
```je``` instruction jumps only if the two arguments of the previous compare (cmp) instruction were equal
∴ this above code only jumps to '_printString' if al = 0

```mov al, [si]``` is used over ```mov al, si``` because si acts as a memory location to the string and not the string itself

## <a href="https://github.com/AngadBasandrai/x86-asm-os/blob/main/src/functions/print_hex.asm">print_hex.asm</a>

This function prints the hexadecimal value inside 'dx'

```asm
xor cx, cx
```
This just sets our counter 'cx' to 0 ```A ^ A = 0```

```asm
mov ax, dx
and ax, 0x000F
```

This code essentially keeps only the last digit of the hexadecimal value and saves it in ax

``` 
if dx = 0x1A5B (any hexadecimal value)
then mov ax, dx sets ax = 0x1A5B
and ax, 0x000F set ax to 0x000B
since
ax     =        0001 1010 0101 1011
and it with     0000 0000 0000 1111
the result clears the first 3 nibbles or 1.5 bytes and keeps the 4th nibble the same
```

The ASCII range of numbers 0-9 is 0x30 to 0x39 and of letters A-F is 0x41 to 0x46

This is why we add 0x30 to 'al' to get it into the ASCII range of letters and numbers since the compare instruction will take its value to be ASCII and if we print those it will try to print unprintable characters
> Learn <a href="https://www.ascii-code.com/">more</a> about ASCII codes


```asm
jle movTobx
```
```jle``` only jumps if the first argument in cmp instruction is less than or equal to the second argument

This means it jumps to 'movTobx' if al contains a number

If not then we add 0x7 to bring it into 0x41 to 0x46

```asm
mov bx, hexString+5
```

This moves the last character of hexString into bx

```asm
sub bx, cx
```

This moves the pointer back by cx characters

```asm
ror dx, 4
```
This rotates dx towards the right by 4 bits

```
say dx = 0x1A5B
	dx = 0001 1010 0101 1011

ror dx, 1 would result in
	dx = 1000 1101 0010 1101

similarly ror dx, 4 results in
	dx = 1011 0001 1010 0101 1011
	dx = 0xB1A5
```

In the end it moves hexString into 'si' and calls printString

## Contributors
<table align="center">
	<tr align="center" style="font-weight:bold">
		<td>
		Angad Basandrai
		<p align="center">
			<img src = "https://avatars.githubusercontent.com/u/112087272?v=4" width="150" height="150" alt="Angad Basandrai">
		</p>
			<p align="center">
				<a href = "https://github.com/AngadBasandrai">
					<img src = "http://www.iconninja.com/files/241/825/211/round-collaboration-social-github-code-circle-network-icon.svg" width="36" height = "36" alt="GitHub"/>
				</a>
			</p>
		</td>
	</tr>
</table>

## License
[![License](http://img.shields.io/:license-gpl3-blue.svg?style=flat-square)]([http://badges.mit-license.org](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text))

<p align="center">
	Made with :heart: by <a href="https://github.com/AngadBasandrai" target="_blank">Angad Basandrai</a>
</p>
