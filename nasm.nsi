#!Nsis Installer Command Script

# Copyright (c) 2009, Shao Miller (shao.miller@yrdsb.edu.on.ca)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

!include "version.nsh"
!define PRODUCT_NAME "Netwide Assembler"
!define PRODUCT_SHORT_NAME "nasm"
!define PACKAGE_NAME "${PRODUCT_NAME} ${VERSION}"
!define PACKAGE_SHORT_NAME "${PRODUCT_SHORT_NAME}-${VERSION}"

Name "${PACKAGE_NAME}"
OutFile "${PACKAGE_SHORT_NAME}-installer.exe"
InstallDir "$PROGRAMFILES\NASM"
InstallDirRegKey HKLM "SOFTWARE\${PACKAGE_SHORT_NAME}" "InstallDir"
SetCompressor lzma

XPStyle on

DirText "Please select the installation folder."
Page directory

ComponentText "Select which optional components you want to install."
Page components

ShowInstDetails hide
ShowUninstDetails hide
Page instfiles

Section "${PACKAGE_NAME}"
  SectionIn RO

  SetOutPath "$INSTDIR\."
  File "LICENSE"
  File "nasm.exe"
  File "ndisasm.exe"
  File "doc/nasmdoc.pdf"
  File "rdoff/ldrdf.exe"
  File "rdoff/rdf2bin.exe"
  File "rdoff/rdf2com.exe"
  File "rdoff/rdf2ith.exe"
  File "rdoff/rdf2ihx.exe"
  File "rdoff/rdf2srec.exe"
  File "rdoff/rdfdump.exe"
  File "rdoff/rdflib.exe"
  File "rdoff/rdx.exe"
  FileOpen $0 "nasmpath.bat" w
  IfErrors skip
  FileWrite $0 "@set path=$INSTDIR;%path%$\r$\n"
  FileWrite $0 "@%comspec%"
  FileClose $0
  skip:
SectionEnd

Section "Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\${PACKAGE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PACKAGE_NAME}\Uninstall ${PACKAGE_NAME}.lnk" "$INSTDIR\Uninstall ${PACKAGE_NAME}.exe" "" "$INSTDIR\Uninstall ${PACKAGE_NAME}.exe" 0
  CreateShortCut "$SMPROGRAMS\${PACKAGE_NAME}\NASM Shell.lnk" "$INSTDIR\nasmpath.bat" "" "$INSTDIR\nasmpath.bat" 0
  CreateShortCut "$SMPROGRAMS\${PACKAGE_NAME}\NASM Manual.lnk" "$INSTDIR\nasmdoc.pdf" "" "$INSTDIR\nasmdoc.pdf" 0
SectionEnd

Section "Desktop Icons"
  CreateShortCut "$DESKTOP\NASM.lnk" "$INSTDIR\nasmpath.bat" "" "$INSTDIR\nasmpath.bat" 0
SectionEnd

Section "Uninstall"
  Delete /rebootok "$DESKTOP\NASM.lnk"
  Delete /rebootok "$SMPROGRAMS\${PACKAGE_NAME}\NASM Shell.lnk"
  Delete /rebootok "$SMPROGRAMS\${PACKAGE_NAME}\NASM Manual.lnk"
  Delete /rebootok "$SMPROGRAMS\${PACKAGE_NAME}\Uninstall ${PACKAGE_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PACKAGE_NAME}"

  Delete /rebootok "$INSTDIR\nasmpath.bat"
  Delete /rebootok "$INSTDIR\rdx.exe"
  Delete /rebootok "$INSTDIR\rdflib.exe"
  Delete /rebootok "$INSTDIR\rdfdump.exe"
  Delete /rebootok "$INSTDIR\rdf2srec.exe"
  Delete /rebootok "$INSTDIR\rdf2ihx.exe"
  Delete /rebootok "$INSTDIR\rdf2ith.exe"
  Delete /rebootok "$INSTDIR\rdf2com.exe"
  Delete /rebootok "$INSTDIR\rdf2bin.exe"
  Delete /rebootok "$INSTDIR\ndisasm.exe"
  Delete /rebootok "$INSTDIR\nasmdoc.pdf"
  Delete /rebootok "$INSTDIR\nasm.exe"
  Delete /rebootok "$INSTDIR\ldrdf.exe"
  Delete /rebootok "$INSTDIR\LICENSE"
  RMDir "$INSTDIR"
SectionEnd

Section -post
  WriteUninstaller "$INSTDIR\Uninstall ${PACKAGE_NAME}.exe"
SectionEnd

