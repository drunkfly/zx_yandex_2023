@echo off
sjasmplus test1_std.asm
sjasmplus test1_new.asm
::mktap -b "Tritone" 1 <loader.bas >loader.tap
::bintap "test.bin" test.tap "tritone" 32768 >nul
::copy /b loader.tap+test.tap music.tap
::del /q test.tap loader.tap test.bin