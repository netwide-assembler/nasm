' INFO_1: Converter for STANDARD.MAC to MACRO.C
'
' INFO_2: Written by Mark Junker in 1997
'         InterNet: mjs@prg.hannover.sgh-net.de
'         FIDO:     Mark Junker@2:2437/47.21
'
' COMMENT: To start the program press SHIFT+F5 within the QBasic IDE
'          or start it from the command-line with QBASIC /RUN MACROS
'

DEFINT A-Z

DECLARE FUNCTION StrTrimLeft$ (a$, b$)
DECLARE FUNCTION StrTrimRight$ (a$, b$)
DECLARE FUNCTION StrTrim$ (a$, b$)
DECLARE SUB StrSplitString (SplitString$, SplitChars$, SplitField$(), SplitCount%)
DECLARE FUNCTION Min% (a%, b%)
DECLARE FUNCTION StrInstrLeft% (SearchStart%, SearchIn$, SearchFor$)
DECLARE FUNCTION StrAscii% (a$)


CLS
DIM LineData$(1 TO 2)

OPEN "I", 1, "STANDARD.MAC"
OPEN "O", 2, "macros.c"

PRINT #2, "/* This file auto-generated from standard.mac by macros.bas - don't edit it */"
PRINT #2, ""
PRINT #2, "static char *stdmac[] = {"

WHILE NOT EOF(1)
  LINE INPUT #1, l$
  CALL StrSplitString(l$, ";", LineData$(), SplitCount)
  IF SplitCount THEN
    LineData$(1) = StrTrim$(LineData$(1), CHR$(9) + " ")
    IF LEN(LineData$(1)) THEN
      PRINT #2, "    " + CHR$(34) + LineData$(1) + CHR$(34) + ","
    END IF
  END IF
WEND
PRINT #2, "    NULL"
PRINT #2, "};"

CLOSE 2
CLOSE 1
SYSTEM

FUNCTION Min% (a%, b%)
  IF a% < b% THEN Min% = a% ELSE Min% = b%
END FUNCTION

FUNCTION StrAscii (a$)
  IF LEN(a$) = 0 THEN
    StrAscii = -1
  ELSE
    StrAscii = ASC(a$)
  END IF
END FUNCTION

' same as =INSTR(SearchStart, SearchIn, ANY SearchFor$) in PowerBASIC(tm)
'
FUNCTION StrInstrLeft (SearchStart, SearchIn$, SearchFor$)
 ValuesCount = LEN(SearchFor$)
 MaxValue = LEN(SearchIn$) + 1
 MinValue = MaxValue
 FOR Counter1 = 1 TO ValuesCount
  SearchChar$ = MID$(SearchFor$, Counter1, 1)
  hVal2 = INSTR(SearchStart, SearchIn$, SearchChar$)
  IF hVal2 > 0 THEN MinValue = Min%(hVal2, MinValue)
 NEXT
 IF MinValue = MaxValue THEN MinValue = 0
 StrInstrLeft = MinValue
END FUNCTION

'
' This is a very damn fuckin' shit version of this splitting routine.
' At this time, it's not very useful :]
'
SUB StrSplitString (SplitString$, SplitChars$, SplitField$(), SplitCount)
  StartIndex = LBOUND(SplitField$)
  LastIndex = UBOUND(SplitField$)
  ActualIndex& = StartIndex
  SplitCount = 0

  LastPos = 1
  FoundPos = StrInstrLeft(LastPos, SplitString$, SplitChars$ + CHR$(34))
  GetDirect = 0
  EndLoop = 0
  TempString$ = ""
  DO WHILE FoundPos > 0
    FoundCharVal = StrAscii(MID$(SplitString$, FoundPos, 1))
    PosDiff = (FoundPos - LastPos) + 1
    SELECT CASE FoundCharVal
    CASE 34
      TempString$ = TempString$ + MID$(SplitString$, LastPos, PosDiff - 1)
      SELECT CASE EndLoop
      CASE 0
        EndLoop = 2
      CASE 3
        EndLoop = 0
      END SELECT
    CASE ELSE
      TempString$ = TempString$ + MID$(SplitString$, LastPos, PosDiff - 1)
      SplitField$(ActualIndex&) = TempString$
      TempString$ = ""
      ActualIndex& = ActualIndex& + 1
      IF ActualIndex& > LastIndex THEN
        ActualIndex& = LastIndex
        EndLoop = 1
      END IF
    END SELECT
    SELECT CASE EndLoop
    CASE 0
      DO
        LastPos = FoundPos + 1
        FoundPos = StrInstrLeft(LastPos, SplitString$, SplitChars$)
      LOOP WHILE LastPos = FoundPos
      FoundPos = StrInstrLeft(LastPos, SplitString$, SplitChars$ + CHR$(34))
    CASE 1
      FoundPos = 0
      LastPos = LEN(SplitString$) + 1
    CASE 2
      EndLoop = 3
      LastPos = FoundPos + 1
      FoundPos = StrInstrLeft(LastPos, SplitString$, CHR$(34))
      IF FoundPos = 0 THEN
       SplitString$ = SplitString$ + CHR$(34)
       FoundPos = LEN(SplitString$)
      END IF
    END SELECT
  LOOP
  IF EndLoop = 0 THEN
    IF LEN(TempString$) > 0 THEN
      SplitField$(ActualIndex&) = TempString$
    ELSEIF LastPos <= LEN(SplitString$) THEN
      SplitField$(ActualIndex&) = MID$(SplitString$, LastPos)
    ELSE
      ActualIndex& = ActualIndex& - 1
    END IF
  END IF
  FOR a = ActualIndex& + 1 TO LastIndex
    SplitField$(a) = ""
  NEXT
  SplitCount = (ActualIndex& - StartIndex) + 1
END SUB

FUNCTION StrTrim$ (a$, b$)
        StrTrim$ = StrTrimRight$(StrTrimLeft$(a$, b$), b$)
END FUNCTION

FUNCTION StrTrimLeft$ (a$, b$) 'public
        p = 0
        l = LEN(a$)
        DO
          p = p + 1
          t$ = MID$(a$, p, 1)
        LOOP WHILE (p < l) AND (INSTR(b$, t$) > 0)
        StrTrimLeft$ = MID$(a$, p)
END FUNCTION

FUNCTION StrTrimRight$ (a$, b$) 'public
        l = LEN(a$)
        p = l + 1
        DO
          p = p - 1
          IF p > 0 THEN
            t$ = MID$(a$, p, 1)
          ELSE
            t$ = ""
          END IF
        LOOP WHILE (p > 0) AND (INSTR(b$, t$) > 0)
        StrTrimRight$ = LEFT$(a$, p)
END FUNCTION

