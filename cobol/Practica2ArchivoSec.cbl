       IDENTIFICATION DIVISION.
       PROGRAM-ID. Practica2ArchivoSec.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
        SELECT ReportFile ASSIGN TO "report.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD ReportFile.
       01 ReportRecord.
          88 EOFReportRecord    VALUE HIGH-VALUES.
          05 DateRecord.
             10 YearDate        PIC X(4).
             10 FILLER          PIC X.
             10 MonthDate       PIC X(2).
             10 FILLER          PIC X.
             10 DayDate         PIC X(2).
          05 FILLER          PIC X.
          05 TimeRecord.
             10 HourDate        PIC X(2).
             10 FILLER          PIC X.
             10 MinuteDate      PIC X(2).
          05 FILLER          PIC X.
          05 PinCardRecord      PIC X(16).
          05 FILLER          PIC X.
          05 Qty             PIC 9(7).
          05 FILLER          PIC X.
          05 MoneyType       PIC X(3).
             88 IsUSD        VALUE 'USD'.
             88 IsPEN        VALUE 'PEN'.
          05 FILLER          PIC X.
          05 TxnType         PIC X(10).
          05 FILLER          PIC X.
          05 PosCod          PIC X(4).
          05 FILLER          PIC X.
          05 PosType         PIC X(4).
          05 FILLER          PIC X.
       WORKING-STORAGE SECTION.
       01 ReportTable.
          05 TableHeader.
           10 FILLER             PIC X(6) VALUES 'CAJERO'.
           10 FILLER             PIC X(3) VALUES SPACES.
           10 FILLER             PIC X(7) VALUES 'TARJETA'.
           10 FILLER             PIC X(14) VALUES SPACES.
           10 FILLER             PIC X(9) VALUES 'FECHA'.
           10 FILLER             PIC X(6) VALUES SPACES.
           10 FILLER             PIC X(9) VALUES 'OPERACION'.
           10 FILLER             PIC X(6) VALUES SPACES.
           10 FILLER             PIC X(6) VALUES 'MONEDA'.
          05 TableData.
           10 TabPosCod          PIC X(4).
           10 FILLER             PIC X(5) VALUES SPACES.
           10 TabPinCard         PIC X(16).
           10 FILLER             PIC X(5) VALUES SPACES.
           10 TabDate            PIC X(10).
           10 FILLER             PIC X(5) VALUES SPACES.
           10 TabTxnType         PIC X(10).
           10 FILLER             PIC X(5) VALUES SPACES.
           10 TabMoneyType       PIC X(3).
       01 Metrics.
          05 SunCounter         PIC 9(5) VALUE ZERO.
          05 DollarCounter      PIC 9(5) VALUE ZERO.
          05 TotalCounter       PIC 9(5) VALUE ZERO.
       01 MetricsDisplay.
          05 SunC               PIC Z(5).
          05 DollarC            PIC Z(5).
          05 TotalC             PIC Z(5).
       PROCEDURE DIVISION.
       MAIN.
        DISPLAY "=========== REPORTE DE TRANSACCIONES ==========="
        DISPLAY TableHeader SPACE

        OPEN INPUT ReportFile
        READ ReportFile
                AT END SET EOFReportRecord TO TRUE
        END-READ     

        PERFORM UNTIL EOFReportRecord
           EVALUATE TRUE
              WHEN IsPEN 
                 ADD 1 TO SunCounter 
              WHEN IsUSD 
                 ADD 1 TO DollarCounter 
           END-EVALUATE
           PERFORM MOVEBUFF
           DISPLAY TableData
           READ ReportFile
              AT END SET EOFReportRecord TO TRUE
           END-READ     
        END-PERFORM
        CLOSE ReportFile
        PERFORM CALCULATEREPORT
        DISPLAY SPACE
        DISPLAY SPACE
        DISPLAY "TRANSACCIONES SOLES   :   " SunC
        DISPLAY "TRANSACCIONES DOLARES :   " DollarC 
        DISPLAY "TOTAL TRANSACCIONES   :   " TotalC 
        STOP RUN.
       MOVEBUFF.
        MOVE PosCod TO TabPosCod
        MOVE PinCardRecord TO TabPinCard 
        MOVE DateRecord TO TabDate
        MOVE TxnType TO TabTxnType
        MOVE MoneyType TO TabMoneyType.
       CALCULATEREPORT.
        ADD SunCounter TO DollarCounter GIVING TotalCounter
        MOVE SunCounter TO SunC
        MOVE DollarCounter TO DollarC
        MOVE TotalCounter TO TotalC.

