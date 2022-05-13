       IDENTIFICATION DIVISION.
       PROGRAM-ID. ConvertDateToDDMM IS INITIAL.
       DATA DIVISION.
       LINKAGE SECTION.
         01 DateInput.
            05 YearOfDate     PIC 9(4)    VALUES ZEROS.
            05 FILLER         PIC X       VALUES "-".
            05 MonthOfDate    PIC 9(2)    VALUES ZEROS.
            05 FILLER         PIC X       VALUES "-".
            05 DayOfDate      PIC 9(2)    VALUES ZEROS.
         COPY "ResultConvertVariable".
       PROCEDURE DIVISION USING DateInput, Result.
       Begin.
          EVALUATE MonthOfDate
            WHEN 1 MOVE "JAN" TO ResultMonth
            WHEN 2 MOVE "FEB" TO ResultMonth
            WHEN 3 MOVE "MAR" TO ResultMonth
            WHEN 4 MOVE "APR" TO ResultMonth
            WHEN 5 MOVE "MAY" TO ResultMonth
            WHEN 6 MOVE "JUN" TO ResultMonth
            WHEN 7 MOVE "JUL" TO ResultMonth
            WHEN 8 MOVE "AGO" TO ResultMonth
            WHEN 9 MOVE "SEP" TO ResultMonth
            WHEN 10 MOVE "OCT" TO ResultMonth
            WHEN 11 MOVE "NOV" TO ResultMonth
            WHEN 12 MOVE "DEC" TO ResultMonth
          END-EVALUATE
          MOVE DayOfDate TO ResultDay
          EXIT PROGRAM.

