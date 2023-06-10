@echo off

@REM del ..\..\memory\data.mem 2>nul
@REM del ..\..\memory\instructions.mem 2>nul

cd assembler\customized_assembler
.\assembler.bat
cd ..\data_generator
.\data_generator.bat

copy instructions.mem + data.mem combined.txt

pause

