' INFO_1: Converter for INSNS.DAT to INSNSA.C and INSNSD.C
'
' INFO_2: Written by Mark Junker in 1997
'         InterNet: mjs@prg.hannover.sgh-net.de
'         FIDO:     Mark Junker@2:2437/47.21
'
' COMMENT: While I wrote this program I often asked me, if it isn't easier
'          to write an interpreter for pearl-scripts :]
'
' COMMENT: To start the program press SHIFT+F5 within the QBasic IDE
'          or start it from the command-line with QBASIC /RUN MACROS
'

DEFINT A-Z

DECLARE FUNCTION ReplaceOp$ (a$)
DECLARE FUNCTION StrTrimLeft$ (a$, b$)
DECLARE FUNCTION StrTrimRight$ (a$, b$)
DECLARE FUNCTION StrTrim$ (a$, b$)
DECLARE SUB StrSplitString (SplitString$, SplitChars$, SplitField$(), SplitCount%)
DECLARE FUNCTION Min% (a%, b%)
DECLARE FUNCTION StrInstrLeft% (SearchStart%, SearchIn$, SearchFor$)
DECLARE FUNCTION StrAscii% (a$)


CONST MaxOpCodeBase = 3
CONST MaxOpCodeType = 8

CLS
DIM LineData$(1 TO 2)
DIM StrucData$(1 TO 5)
DIM OpCodeList$(0 TO 255)
DIM OpCodeByte(1 TO MaxOpCodeType, 1 TO MaxOpCodeBase)
DIM OpCodeStat(1 TO 10)   ' don't need mode :)

Instructs$ = ""
LineOfs$ = ""

OPEN "I", 1, "insns.dat"
OPEN "B", 3, "insns.tmp"

qt$ = CHR$(34)
crlf$ = CHR$(13) + CHR$(10)


'
' preprocessing the current file
'

HexChar$ = "0123456789ABCDEF"

PRINT "Preprocessing INSNS.DAT"
OpCodes = 0
OpCodeDebug = 0
NowLineOfs& = 1
lineNr = 0
WHILE NOT EOF(1)
  lineNr = lineNr + 1
  IF (lineNr AND 15) = 0 THEN
    LOCATE , 1
    PRINT lineNr, OpCodes, OpCodeDebug;
  END IF

  LINE INPUT #1, l$
  CALL StrSplitString(l$, ";", LineData$(), SplitCount)
  IF SplitCount THEN
    LineData$(1) = StrTrim$(LineData$(1), CHR$(9) + " ")
    IF LEN(LineData$(1)) THEN
      CALL StrSplitString(LineData$(1), " ", StrucData$(), cntSplit)
      IF cntSplit <> 4 THEN
        PRINT "line"; lineNr; " does not contain four fields"
        END
      END IF

      tst$ = UCASE$(StrucData$(2))
      res$ = ""
      cnt% = 1
      isfirst = 1
      op = 1
      p = StrInstrLeft(1, tst$ + ",", "|:,")
      WHILE p
        h$ = ReplaceOp$(MID$(tst$, op, p - op))
        IF LEN(h$) THEN
          SELECT CASE MID$(tst$, p, 1)
          CASE ""
            IF isfirst THEN
              res$ = res$ + h$
            ELSE
              res$ = res$ + "|" + h$
            END IF
            isfirst = 0
          CASE ","
            IF isfirst THEN
              res$ = res$ + h$ + ","
            ELSE
              res$ = res$ + "|" + h$ + ","
            END IF
            cnt% = cnt% + 1
            isfirst = 1
          CASE "|"
            IF isfirst THEN
              res$ = res$ + h$
            ELSE
              res$ = res$ + "|" + h$
            END IF
            isfirst = 0
          CASE ":"
            res$ = res$ + h$ + "|COLON,"
            cnt% = cnt% + 1
          END SELECT
        END IF
        op = p + 1
        p = StrInstrLeft(op, tst$ + ",", "|:,")
      WEND
      FOR a = cnt% + 1 TO 3
        res$ = res$ + ",0"
      NEXT
      StrucData$(2) = res$
      IF LEFT$(res$, 2) = "0," THEN cnt% = cnt% - 1
      StrucData$(5) = LTRIM$(STR$(cnt%))

      NoDebug = 0
      res$ = ""
      tst$ = UCASE$(StrucData$(4))
      op = 1
      p = INSTR(tst$ + ",", ",")
      isfirst = 1
      WHILE p
        h$ = MID$(tst$, op, p - op)
        IF h$ = "ND" THEN
          NoDebug = 1
        ELSE
          IF isfirst THEN
            res$ = res$ + "IF_" + h$
          ELSE
            res$ = res$ + "|IF_" + h$
          END IF
          isfirst = 0
        END IF
        op = p + 1
        p = INSTR(op, tst$ + ",", ",")
      WEND
      StrucData$(4) = res$

      tst$ = UCASE$(StrucData$(3))
      SELECT CASE tst$
      CASE "IGNORE"
        GOTO skipOpCode
      CASE "\0", "\340"
        OpCodeDebug = OpCodeDebug + 1    ' don't forget to increment
        GOTO skipOpCode
      END SELECT

      AddRegs = 0
      AddCCode = 0
      NextIsOpCode = 0
      opCodeVal$ = ""
      op = 1
      p = INSTR(tst$ + "\", "\")
      DO WHILE p
        h$ = MID$(tst$, op, p - op)
        IF LEFT$(h$, 1) = "X" THEN
          opCodeVal$ = CHR$(VAL("&H" + MID$(h$, 2)))
          EXIT DO
        ELSE
          SELECT CASE h$
          CASE "1", "2", "3"
            NextIsOpCode = 1
          CASE "4"
            opCodeVal$ = CHR$(&H7) + CHR$(&H17) + CHR$(&H1F)
            EXIT DO
          CASE "5"
            opCodeVal$ = CHR$(&HA1) + CHR$(&HA9)
            EXIT DO
          CASE "6"
            opCodeVal$ = CHR$(&H6) + CHR$(&HE) + CHR$(&H16) + CHR$(&H1E)
            EXIT DO
          CASE "7"
            opCodeVal$ = CHR$(&HA0) + CHR$(&HA8)
            EXIT DO
          CASE "10", "11", "12"
            NextIsOpCode = 1
            AddRegs = VAL(h$) - 9
          CASE "330"
            NextIsOpCode = 1
            AddCCode = VAL(h$) - 329
          CASE "17"
            opCodeVal$ = CHR$(0)
            EXIT DO
          CASE ELSE
            IF NextIsOpCode THEN
              PRINT "Line:"; lineNr
              PRINT "Unknown value: " + h$
              END
            END IF
          END SELECT
        END IF
        op = p + 1
        p = INSTR(op, tst$ + "\", "\")
      LOOP
      IF (p = 0) THEN
        PRINT "No opcode found in line"; lineNr
        PRINT "Line:"
        PRINT l$
        END
      END IF

      IF NoDebug = 0 THEN
        FOR a = 1 TO LEN(opCodeVal$)
          h = ASC(MID$(opCodeVal$, a, 1))
          OpCodeStr$ = MKI$(OpCodeDebug)
          IF AddRegs THEN
            EndNr = 7
          ELSEIF AddCCode THEN
            EndNr = 15
          ELSE
            EndNr = 0
          END IF
          FOR b = 0 TO EndNr
            OpCodeList$(h + b) = OpCodeList$(h + b) + OpCodeStr$
          NEXT
        NEXT
        OpCodeDebug = OpCodeDebug + 1
      END IF

skipOpCode:
      OpCodes = OpCodes + 1
      LineOfs$ = LineOfs$ + MKL$(NowLineOfs&)
      LineLg = 1
      h$ = CHR$(NoDebug)
      PUT #3, NowLineOfs&, h$
      NowLineOfs& = NowLineOfs& + 1
      FOR a = 1 TO 5
        lg = LEN(StrucData$(a))
        h$ = CHR$(lg) + StrucData$(a)
        PUT #3, NowLineOfs&, h$
        NowLineOfs& = NowLineOfs& + lg + 1
        LineLg = LineLg + lg + 1
      NEXT
      LineOfs$ = LineOfs$ + MKI$(LineLg)
    END IF
  END IF
WEND
LOCATE , 1
PRINT lineNr, OpCodes, OpCodeDebug


'
' creating insnsa.c
'


PRINT "Creating INSNSA.C"

OPEN "O", 2, "insnsa.c"
strBegStart$ = "static struct itemplate instrux_"
strBegEnd$ = "[] = {"
strEnd$ = "    {-1}" + crlf$ + "};" + crlf$

PRINT #2, "/* This file auto-generated from insns.dat by insns.bas - don't edit it */"
PRINT #2, ""
PRINT #2, "#include <stdio.h>"
PRINT #2, "#include " + qt$ + "nasm.h" + qt$
PRINT #2, "#include " + qt$ + "insns.h" + qt$
PRINT #2, ""

oldOpCode$ = ""
pOfs = 1
FOR a = 1 TO OpCodes
  LineOfs& = CVL(MID$(LineOfs$, pOfs, 4))
  l$ = SPACE$(CVI(MID$(LineOfs$, pOfs + 4, 2)))
  pOfs = pOfs + 6
  GET #3, LineOfs&, l$

  ' split data into fields
  NoDebug = ASC(LEFT$(l$, 1))
  pLn = 2
  FOR b = 1 TO 5
    lgLn = ASC(MID$(l$, pLn, 1))
    StrucData$(b) = MID$(l$, pLn + 1, lgLn)
    pLn = pLn + lgLn + 1
  NEXT

  IF oldOpCode$ <> StrucData$(1) THEN
    Instructs$ = Instructs$ + StrucData$(1) + CHR$(0)
    IF LEN(oldOpCode$) THEN PRINT #2, strEnd$
    PRINT #2, strBegStart$ + StrucData$(1) + strBegEnd$
    oldOpCode$ = StrucData$(1)
  END IF
  SELECT CASE UCASE$(StrucData$(3))
  CASE "IGNORE"
  CASE ELSE
    PRINT #2, "    {I_" + oldOpCode$ + ", " + StrucData$(5) + ", {" + StrucData$(2) + "}, " + qt$ + StrucData$(3) + qt$ + ", " + StrucData$(4) + "},"
  END SELECT
NEXT
IF LEN(oldOpCode$) THEN PRINT #2, strEnd$

PRINT #2, "struct itemplate *nasm_instructions[] = {"
op = 1
p = INSTR(Instructs$, CHR$(0))
WHILE p
  h$ = MID$(Instructs$, op, p - op)
  PRINT #2, "    instrux_" + h$ + ","
  op = p + 1
  p = INSTR(op, Instructs$, CHR$(0))
WEND
PRINT #2, "};"

CLOSE 2



'
' creating insnsd.c
'


PRINT "Creating INSNSD.C"

OPEN "O", 2, "insnsd.c"

PRINT #2, "/* This file auto-generated from insns.dat by insns.bas - don't edit it */"
PRINT #2, ""
PRINT #2, "#include <stdio.h>"
PRINT #2, "#include " + qt$ + "nasm.h" + qt$
PRINT #2, "#include " + qt$ + "insns.h" + qt$
PRINT #2, ""


PRINT #2, "static struct itemplate instrux[] = {"
pOfs = 1
FOR a = 1 TO OpCodes
  LineOfs& = CVL(MID$(LineOfs$, pOfs, 4))
  l$ = SPACE$(CVI(MID$(LineOfs$, pOfs + 4, 2)))
  pOfs = pOfs + 6
  GET #3, LineOfs&, l$

  ' split data into fields
  NoDebug = ASC(LEFT$(l$, 1))
  pLn = 2
  FOR b = 1 TO 5
    lgLn = ASC(MID$(l$, pLn, 1))
    StrucData$(b) = MID$(l$, pLn + 1, lgLn)
    pLn = pLn + lgLn + 1
  NEXT

  IF NoDebug OR (UCASE$(StrucData$(3)) = "IGNORE") THEN
    ' ignorieren
  ELSE
    PRINT #2, "    {I_" + StrucData$(1) + ", " + StrucData$(5) + ", {" + StrucData$(2) + "}, " + qt$ + StrucData$(3) + qt$ + ", " + StrucData$(4) + "},"
  END IF
NEXT
PRINT #2, "    {-1}" + crlf$ + "};" + crlf$


OpCodeBegS$ = "static struct itemplate *itable_"
OpCodeBegE$ = "[] = {"
OpCodeEnd$ = "    NULL" + crlf$ + "};" + crlf$

FOR a = 0 TO 255
  PRINT #2, OpCodeBegS$ + RIGHT$("00" + HEX$(a), 2) + OpCodeBegE$
  h$ = OpCodeList$(a)
  FOR b = 1 TO LEN(h$) STEP 2
    OpCodePos = CVI(MID$(h$, b, 2))
    PRINT #2, "    instrux +" + STR$(OpCodePos) + ","
  NEXT
  PRINT #2, OpCodeEnd$
NEXT

PRINT #2, "struct itemplate **itable[] = {"
FOR a = 0 TO 255
  PRINT #2, "    itable_" + RIGHT$("00" + HEX$(a), 2) + ","
NEXT
PRINT #2, "};"

CLOSE 2



CLOSE 3
KILL "insns.tmp"
CLOSE 1
SYSTEM

FUNCTION ReplaceOp$ (a$)
  tst$ = UCASE$(a$)
  SELECT CASE tst$
'  CASE "ND"
'    ReplaceOp$ = ""
  CASE "VOID", ""
    ReplaceOp$ = "0"
  CASE "IMM"
    ReplaceOp$ = "IMMEDIATE"
  CASE "MEM"
    ReplaceOp$ = "MEMORY"
  CASE "MEM8", "MEM16", "MEM32", "MEM64", "MEM80"
    ReplaceOp$ = "MEMORY|BITS" + MID$(tst$, 4)
  CASE "REG8", "REG16", "REG32"
    ReplaceOp$ = tst$
  CASE "RM8", "RM16", "RM32"
    ReplaceOp$ = "REGMEM|BITS" + MID$(tst$, 3)
  CASE "IMM8", "IMM16", "IMM32"
    ReplaceOp$ = "IMMEDIATE|BITS" + MID$(tst$, 4)
  CASE ELSE
    ReplaceOp$ = tst$
  END SELECT
END FUNCTION

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