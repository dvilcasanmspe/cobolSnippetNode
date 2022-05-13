       IDENTIFICATION DIVISION.
       PROGRAM-ID. Practica2-2Sesion5.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
          SELECT F-RegisterKey ASSIGN TO "paramKey.dat"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS F-KeyStatus.
       DATA DIVISION.
       FILE SECTION.
       FD F-RegisterKey.
       01 F-DOC            PIC X(19)       VALUE SPACE.
       WORKING-STORAGE SECTION.
       01 F-FileStatus.
          05 F-KeyStatus   PIC X(2)       VALUE SPACE.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DBNAME           PIC X(30)      VALUE SPACE.
       01 USERNAME         PIC X(64)      VALUE SPACE.
       01 PASSWD           PIC X(10)      VALUE SPACE.
       01 D-ACTSAL         PIC Z(9)9      VALUE ZEROS.
       01 S-RECORD.
          03 S-INPUT.
             05 S-DOC      PIC X(8)       VALUE SPACE.
             05 FILLER     PIC X          VALUE SPACE.
             05 S-CUENTA   PIC X(10)      VALUE SPACE.
          03 S-ACTSAL      PIC 9(10)      VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.

       01 S-HDATE. 
          03 YYDATE        PIC X(4)       VALUE SPACE.
          03 MMDATE        PIC X(2)       VALUE SPACE.
          03 DDDATE        PIC X(2)       VALUE SPACE.
       01 C-DATE. 
          03 C-YYDATE      PIC X(4)       VALUE SPACE.
          03 FILLER        PIC X          VALUE "-".
          03 C-MMDATE      PIC X(2)       VALUE SPACE.
          03 FILLER        PIC X          VALUE "-".
          03 C-DDDATE      PIC X(2)       VALUE SPACE.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       MAIN SECTION.
       Begin.
          DISPLAY "*** SELECCION DE UN REGISTRO ***"
          MOVE "dvilca"     TO USERNAME
          MOVE "playground_dvilca"     TO DBNAME
          MOVE SPACE        TO PASSWD
          PERFORM ConnectionSQL
          PERFORM SelectOneByKey
          STOP RUN.
       ConnectionSQL.
          EXEC SQL
             CONNECT :USERNAME IDENTIFIED BY :PASSWD USING :DBNAME
          END-EXEC
          IF SQLCODE IS EQUAL TO ZERO THEN
             DISPLAY "SUCCESFUL CONNECTION WITH DATABASE " DBNAME
          ELSE
             PERFORM HandlingErrors
             STOP RUN
          END-IF.
       SelectOneByKey.
         ACCEPT S-INPUT FROM COMMAND-LINE
         DISPLAY "============================"
         DISPLAY "PROGRAMA: Practica2-2Sesion6"
         DISPLAY "OBJETIVO: CONSULTA DE DATOS"
         DISPLAY "============================"
         DISPLAY "SEARCH FOR REGISTER WITH KEY: " S-DOC SPACE S-CUENTA
         EXEC SQL
           DECLARE C1 CURSOR FOR SELECT SALDOACT
           FROM cuenta WHERE DOCCLIEN=:S-DOC AND CODCUENT=:S-CUENTA
         END-EXEC
         EXEC SQL
            OPEN C1
         END-EXEC
         EXEC SQL
            FETCH C1 INTO :S-ACTSAL
         END-EXEC
         IF ( SQLCODE = ZERO ) THEN
            ACCEPT S-HDATE FROM DATE YYYYMMDD
            MOVE YYDATE TO C-YYDATE
            MOVE MMDATE TO C-MMDATE
            MOVE DDDATE TO C-DDDATE
            MOVE S-ACTSAL TO D-ACTSAL
            DISPLAY "FECHA: " C-DATE
            DISPLAY "LLAVE: " S-DOC " (DNI)"
            DISPLAY "SALDO: " D-ACTSAL " (PUNTOS)"
            DISPLAY "============================"
         ELSE
            PERFORM HandlingErrors
         END-IF
         EXEC SQL
            CLOSE C1
         END-EXEC.
       HandlingErrors.
         DISPLAY "SQLCODE: " SQLCODE
         DISPLAY "SQLERRMC: " SQLERRMC.

