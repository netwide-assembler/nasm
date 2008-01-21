@echo off
if "%1"=="clean" goto makeclean
if "%1"=="CLEAN" goto makeclean
if "%1"=="spotless" goto spotless
if "%1"=="SPOTLESS" goto spotless
if "%1"=="install" goto install
if "%1"=="INSTALL" goto install

cls
echo.
echo.
echo.
echo    Usage:
echo.
echo        makedocs - no parameters - makes all Docs
echo        makedocs install - installs already made docs in subdirectories
echo        makedocs clean - removes docs from current directory
echo        makedocs spotless - removes all - including default install dirs
echo.
echo.
echo.
echo.
echo        Makedocs(.bat), with no parameters will create Nasm Documentation
echo        in several formats: plain ascii text, ps, html, rtf, Windows help
echo        format, and if you've got an "info" system installed, info format.
echo.
echo.
echo                This requires Perl, and almost 4MB disk space.
echo.
echo.
choice "                     Proceed with making docs? "
if errorlevel 2 goto exit

:makeall

echo.
echo.
echo                        This takes a while. Stretch!
echo.
echo.

perl inslist.pl
perl rdsrc.pl<nasmdoc.src
echo.
echo.
choice "                       Make *info* files? "
if errorlevel 2 goto noinfo
:makeinfo
echo.
echo.
makeinfo nasmdoc.tex

:noinfo

:install

if not exist nasmdoc.txt goto nofiles
if not exist nasmdoc0.htm goto nofiles
if not exist nasmdo10.htm goto nofiles
if not exist nasmdoc.hpj goto nofiles
if not exist nasmdoc.rtf goto nofiles
if not exist nasmdoc.ps goto nofiles
if not exist nasmdoc.tex goto nofiles
goto gotfiles
:nofiles
echo.
echo.
echo.
echo.
echo                       Alert!      Files missing!
echo.
echo.
choice "               Would you like to make them now? "
if errorlevel 2 goto exit
goto makeall

:gotfiles

:: get current path

set oldprompt=%prompt%
echo @prompt set nasdoc=$p>temp1.bat
command /c temp1.bat>temp2.bat
call temp2
del temp1.bat
del temp2.bat
set prompt=%oldprompt%
set oldprompt=

echo.
echo.
echo.
echo.
echo        Current Directory is %nasdoc%
echo        Nasm Documentation will be installed under this
echo        as %nasdoc%\text\nasmdoc.txt, etc.
echo.
echo.
choice "                   Change this directory? "
if errorlevel 2 goto dirok

echo.
echo.
echo.
echo.
echo      Directory *above* the directory you name (at least) should exist.
echo      Nasm documentation will be installed *under* the directory you
echo      name. E.G. \docs\nasm\html, etc. No trailing backslash!
echo.
echo.

echo                Enter new name for base directory:
set input=
fc con nul /lb1 /n|date|find "1:">magic.bat
echo set input=%%5>enter.bat
call magic
set nasdoc=%input%
del magic.bat
del enter.bat
set input=

echo.
echo.
md %nasdoc%
echo.
echo.

choice "  Install Text docs in %nasdoc%\text ? "
if errorlevel 2 goto notext
md %nasdoc%\text
copy nasmdoc.txt %nasdoc%\text
:notext

choice "  Install Html docs in %nasdoc%\html ? "
if errorlevel 2 goto nohtml
md %nasdoc%\html
copy *.htm %nasdoc%\html
:nohtml

choice "  Install Info docs in %nasdoc%\info ? "
if errorlevel 2 goto noinfodocs
if not exist nasm.inf goto inofiles
if not exist nasm.i9 goto inofiles
goto gotifiles
:inofiles
echo.
echo.
echo                       Alert!      Files missing!
echo.
echo.
choice "               Would you like to make them now? "
if errorlevel 2 goto noinfodocs
if not exist nasmdoc.tex goto makeall
goto makeinfo

:gotifiles

md %nasdoc%\info
copy nasm.i* %nasdoc%\info
:noinfodocs

choice "  Install Winhelp docs in %nasdoc%\winhelp ? "
if errorlevel 2 goto nowinhelp
md %nasdoc%\winhelp
copy nasmdoc.rtf %nasdoc%\winhelp
copy nasmdoc.hpj %nasdoc%\winhelp
:nowinhelp

choice "  Install Postscript docs in %nasdoc%\ps ? "
if errorlevel 2 goto nops
md %nasdoc%\ps
copy nasmdoc.ps %nasdoc%\ps
:nops
goto cleanup

:dirok

choice "  Install Text docs in .\text ? "
if errorlevel 2 goto notext2
md text
copy nasmdoc.txt text
:notext2

choice "  Install Html docs in .\html ? "
if errorlevel 2 goto nohtml2
md html
copy *.htm html
:nohtml2

choice "  Install Info docs in .\info ? "
if errorlevel 2 goto nid2

if not exist nasm.inf goto inof2
if not exist nasm.i9 goto inof2
goto gifiles2
:inof2
echo.
echo.
echo                       Alert!      Files missing!
echo.
echo.
choice "               Would you like to make them now? "
if errorlevel 2 goto nid2
if not exist nasmdoc.tex goto makeall
goto makeinfo

:gifiles2

md info
copy nasm.i* info
:nid2

choice "  Install Winhelp docs in .\winhelp ? "
if errorlevel 2 goto nwhelp2
md winhelp
copy nasmdoc.rtf winhelp
copy nasmdoc.hpj winhelp
:nwhelp2

choice "  Install Postscript docs in .\ps ? "
if errorlevel 2 goto nops2
md ps
copy nasmdoc.ps ps
:nops2


:cleanup
set nasdoc=

echo.
echo.
echo.
echo.
choice "        Remove all files created, but not installed?"
if not errorlevel 2 goto makeclean

goto exit

:spotless
deltree /y text
deltree /y html
deltree /y info
deltree /y winhelp
deltree /y ps

:makeclean
del *.htm
del *.rtf
del *.hpj
del *.txt
del *.tex
del *.ps
del nasm.i*

:exit
