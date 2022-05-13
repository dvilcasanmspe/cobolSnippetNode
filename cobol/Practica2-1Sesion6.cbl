       IDENTIFICATION DIVISION.
       PROGRAM-ID. Practica2-1Sesion6.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DBNAME           PIC X(30)      VALUE SPACE.
       01 USERNAME         PIC X(64)      VALUE SPACE.
       01 PASSWD           PIC X(10)      VALUE SPACE.
       01 I-RECORD.
          05 I-DOC         PIC X(8).
          05 FILLER        PIC X.
          05 I-COD         PIC X(10).
          05 FILLER        PIC X.
          05 I-STATE       PIC X.
          05 FILLER        PIC X.
          05 I-ACTSAL      PIC 9(10).
          05 FILLER        PIC X.
          05 I-TEXSAL      PIC 9(10).
          05 FILLER        PIC X.
          05 I-HDATE       PIC X(10).
          05 FILLER        PIC X.
          05 I-CDATA       PIC X(26).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       MAIN SECTION.
       Begin.
          DISPLAY "===== INSERCION A LA TABLA CUENTA ===="
          MOVE "dvilca" TO USERNAME
          MOVE "playground_dvilca" TO DBNAME
          MOVE SPACE TO PASSWD
          
          PERFORM ConnectionSQL
          IF SQLCODE IS NOT EQUAL TO ZERO THEN
             DISPLAY "ERROR: NO CONNECTION WITH DATABASE"
             STOP RUN
          END-IF
          PERFORM InsertRegister 

          DISPLAY "DISCONNECT FROM DATABASE...."
          EXEC SQL DISCONNECT ALL END-EXEC
          STOP RUN.
       HandlingErrors.
          DISPLAY "SQLCODE: " SQLCODE
          DISPLAY "SQLERRMC: " SQLERRMC.
       ConnectionSQL.
          EXEC SQL
             CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
          END-EXEC
          IF SQLCODE IS EQUAL TO ZERO THEN
             DISPLAY "MESSAGE: SUCCESSFUL CONNECTION"
          ELSE
             PERFORM HandlingErrors
             STOP RUN
          END-IF.
       InsertRegister.
          DISPLAY "========================================="
          ACCEPT I-RECORD FROM COMMAND-LINE

          DISPLAY 
             I-DOC SPACE
             I-COD SPACE
             I-STATE SPACE
             I-ACTSAL SPACE
             I-TEXSAL SPACE
             I-HDATE SPACE
             I-CDATA


          EXEC SQL
             INSERT INTO cuenta VALUES
             (:I-DOC, :I-COD, :I-STATE, :I-ACTSAL, :I-TEXSAL,
                :I-HDATE,:I-CDATA)
          END-EXEC

          IF SQLCODE IS EQUAL TO ZERO THEN
             DISPLAY "MESSAGE: INSERCION EXITOSA"
             DISPLAY "========================================="
             PERFORM CommitTxn
             DISPLAY "========================================="
          ELSE
             PERFORM HandlingErrors   
          END-IF.
       CommitTxn.
          EXEC SQL COMMIT WORK END-EXEC

          IF SQLCODE IS EQUAL TO ZERO THEN
             DISPLAY "MESSAGE: CONFIRMACION EXITOSA"
          ELSE
             PERFORM HandlingErrors   
          END-IF.
          
