<h1 align="center"> &nbsp;&nbsp;Chronix OS</h1>
<br/>

> A basic OS that is implemented in x86-asm

---

## Requirements
 - NASM/FASM (any assembly compiler will do)
 - Qemu
 - Make (not neccesary but recommended)
   
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

## NOTE: THIS CODE WAS WRITTEN ACCORDING TO NASM AND THERE MAY BE ISSUES WITH OTHER ASSEMBLERS

---

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
