       IDENTIFICATION DIVISION.
       PROGRAM-ID. Practica2-2Sesion5.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DBNAME           PIC X(30)      VALUE SPACE.
       01 USERNAME         PIC X(64)      VALUE SPACE.
       01 PASSWD           PIC X(10)      VALUE SPACE.
       01 S-RECORD.
          03 S-DOC         PIC X(8)       VALUE SPACE.
          03 FILLER        PIC X          VALUE SPACE.
          03 S-CUENTA      PIC X(10)       VALUE SPACE.
          03 FILLER        PIC X          VALUE SPACE.
          03 S-SALDO       PIC 9(10)      VALUE ZERO.
          03 FILLER        PIC X          VALUE SPACE.
          03 C-DOC         PIC X(8)       VALUE SPACE.
          03 FILLER        PIC X          VALUE SPACE.
          03 C-CUENTA      PIC X(10)       VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.
       01 C-RECORD.
          03 C-ACTSAL      PIC 9(10)      VALUE ZERO.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       MAIN SECTION.
       Begin.
          DISPLAY "*** ACTUALIZACION DE UN REGISTRO ***"
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
         ACCEPT S-RECORD FROM COMMAND-LINE 

         DISPLAY "============================"
         DISPLAY "PROGRAMA: Practica2-3Sesion6"
         DISPLAY "OBJETIVO: ACTUALIZAR DATOS"
         DISPLAY "============================"
         DISPLAY "SEARCH FOR REGISTER WITH KEY: " C-DOC SPACE C-CUENTA

         EXEC SQL
            UPDATE cuenta
            SET docclien=:S-DOC, codcuent=:S-CUENTA, saldoact=:S-SALDO
            WHERE docclien=:C-DOC AND codcuent=:C-CUENTA
         END-EXEC
         IF ( SQLCODE = ZERO ) THEN
           EXEC SQL
                    COMMIT WORK
           END-EXEC
            DISPLAY "============================"
            DISPLAY "RESULTADO: "
            DISPLAY "============================"
            DISPLAY "CONSULTANDO CUENTA"
            DISPLAY "DNI: " S-DOC
            DISPLAY "CUENTA: " S-CUENTA
            DISPLAY "SALDO: " S-SALDO
            DISPLAY "============================"
         ELSE
            PERFORM HandlingErrors
            EXEC SQL
               ROLLBACK WORK
            END-EXEC
         END-IF
         EXEC SQL
            CLOSE C1
           END-EXEC.
       HandlingErrors.
         DISPLAY "SQLCODE: " SQLCODE
         DISPLAY "SQLERRMC: " SQLERRMC.

