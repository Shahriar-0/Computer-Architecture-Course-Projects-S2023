@echo off

del data.mem 2>nul
@REM del FindMax.asm 2>nul
del ..\..\memory\data.mem 2>nul

py data_generator.py ..\..\memory\ArrayData.txt
copy data.mem ..\
pause
