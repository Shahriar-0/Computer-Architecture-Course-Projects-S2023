@echo off

del instructions.mem 2>nul
del FindMax.asm 2>nul
del ..\..\..\memory\instructions.mem 2>nul

py main.py ..\..\..\assembly\maxarray.s
copy instructions.mem ..\..\..\memory
pause
