       IDENTIFICATION DIVISION.
       PROGRAM-ID. Practica2Sesion5.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT OpenClientFile ASSIGN TO 'OPECLIEN.DAT' 
            ORGANIZATION IS LINE SEQUENTIAL
            FILE STATUS IS InputFileStatus.
         SELECT OutputFile ASSIGN TO "REPRETIROSCLIEN.DAT"
            ORGANIZATION IS LINE SEQUENTIAL
            FILE STATUS IS OutputFileStatus.
       DATA DIVISION.
       FILE SECTION.
       FD OpenClientFile.
       01 OpenClientBuffer    PIC X(45)   VALUES SPACES.
          88 EOFOpenClien     VALUES      HIGH-VALUES.
       FD OutputFile. 
       01 OutputFileBuffer    PIC X(65)   VALUES SPACES.
       WORKING-STORAGE SECTION.
       01 InputFileStatus     PIC X(2)    VALUES SPACES.
          88 RecordFound      VALUE "00".
          88 FileNotFound     VALUE "35".
       01 InputMessage        PIC X(64)   VALUES SPACES.
       01 OutputFileStatus    PIC X(2)    VALUES SPACES.
          88 BoundaryErr      VALUE "34".
          88 RecordFoundOut   VALUE "00".
       01 OutputMessage       PIC X(64)   VALUES SPACES.
       01 Accum.
          05 DolarAccum          PIC 9(5)V9(2) VALUES ZEROS.
          05 SolAccum            PIC 9(5)V9(2) VALUES ZEROS.
       01 DisplayDolarAccum.
          05 FILLER           PIC X(20)   VALUES
           "TOTAL DOLAR       : ".
          05 DolarAccumD      PIC 9(4)9.9(2).
       01 DisplaySolAccum.
          05 FILLER           PIC X(20)   VALUES
           "TOTAL SOLES       : ".
          05 SolAccumD        PIC 9(4)9.9(2).
       01 DisplayTxnCounter.
          05 FILLER           PIC X(20)     VALUES
           "TOTAL OPERACIONES : ". 
          05 TxnCounter       PIC 9(5)    VALUES ZEROS.
       01 OpenClientRecord.
          05 DNI              PIC X(8)    VALUES SPACES.
          05 Card             PIC X(16)   VALUES SPACES.
          05 Amount           PIC 9(5)V9(2)  VALUES ZEROS.
          05 Money            PIC X(3)    VALUES SPACES.
          05 RecordDate.
             10 RecordAge     PIC X(4)    VALUES SPACES.
             10 FILLER        PIC X       VALUES "-".
             10 RecordMonth   PIC X(2)    VALUES SPACES.
             10 FILLER        PIC X       VALUES "-".
             10 RecordDay     PIC X(2)    VALUES SPACES.
       01 OutputFileRecord.
          05 OutputCard       PIC X(16)   VALUES SPACES.
          05 FILLER           PIC X       VALUES SPACE.
          05 OutputAmount     PIC 9(5).9(2)  VALUES ZEROS.
          05 FILLER           PIC X       VALUES SPACE.
          05 OutputMoney      PIC X(3)    VALUES SPACES.
          05 FILLER           PIC X       VALUES SPACE.
          05 OutputDate       PIC X(6)    VALUES SPACES.
       01 DisplayValues.
          05 Header.
             10 FILLER        PIC X(5)    VALUES ALL "=".
             10 FILLER        PIC X(30)   VALUES
                " RETIROS EN ATM POR CLIENTE ".
             10 FILLER        PIC X(5)    VALUES ALL "=".
          05 DisplayDNI.
             10 FILLER        PIC X(6)    VALUES "DNI : ".
             10 DNIValue      PIC X(8).
       COPY "DisplayTableCode".
       COPY "ResultConvertVariable".
       PROCEDURE DIVISION.
       MAIN SECTION.
         Begin. 
            DISPLAY "Abriendo el archivo de entrada..." 
            PERFORM OpenInputFile   
            DISPLAY SPACE 
            DISPLAY "Abriendo o sobreescribiendo " WITH NO ADVANCING
            DISPLAY "el archivo de salida..."
            PERFORM OpenOutputFile
            DISPLAY SPACE 
            PERFORM CheckRecords
            PERFORM DisplayBegin
            DISPLAY SPACE
            PERFORM DisplayEachRecord
            DISPLAY SPACE
            PERFORM DisplaySummaryResult
            CLOSE OutputFile
            CLOSE OpenClientFile
         STOP RUN.
       METHODS SECTION.
         PrintAndWrite.
           DISPLAY OutputFileBuffer
           WRITE OutputFileBuffer. 
         OpenInputFile.
            OPEN INPUT OpenClientFile
            EVALUATE TRUE
               WHEN FileNotFound 
                  MOVE "ERROR: ARCHIVO NO ENCONTRADO" TO InputMessage
               WHEN RecordFound 
                  MOVE "LOG: ARCHIVO ABIERTO CON EXITO" TO  InputMessage
            END-EVALUATE
            DISPLAY InputMessage
            IF NOT RecordFound THEN STOP RUN END-IF.
         CheckRecords.
            READ OpenClientFile INTO OpenClientRecord
               AT END SET EOFOpenClien TO TRUE
               NOT AT END ADD 1 TO TxnCounter
            END-READ
            IF EOFOpenClien THEN 
               DISPLAY "ERROR: NO HAY REGISTROS DISPONIBLES"
               STOP RUN
            END-IF.
         OpenOutputFile.
            OPEN OUTPUT OutputFile
            EVALUATE TRUE
               WHEN BoundaryErr 
                  MOVE "ERROR: LIMITES ALCANZADOS" TO OutputMessage
               WHEN RecordFoundOut 
                  MOVE "LOG: ARCHIVO ABIERTO CON EXITO"
                     TO OutputMessage
            END-EVALUATE
            DISPLAY OutputMessage
            IF NOT RecordFoundOut THEN STOP RUN END-IF.
         DisplayBegin.
            MOVE Header TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE SPACES TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE DNI TO DNIValue 
            MOVE DisplayDNI TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE SPACES TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE "OPERACIONES" TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE DisplayHeader TO OutputFileBuffer
            PERFORM PrintAndWrite.
         DisplayEachRecord.
            PERFORM UNTIL EOFOpenClien
               EVALUATE Money
                  WHEN "PEN" ADD Amount TO SolAccum
                  WHEN "USD" ADD Amount TO DolarAccum
               END-EVALUATE
               
               CALL "ConvertDateToDDMM"
                  USING BY CONTENT RecordDate
                        BY REFERENCE Result

               DISPLAY Card SPACE Amount SPACE Money SPACE Result 

               MOVE Card TO OutputCard
               MOVE Amount TO OutputAmount
               MOVE Money TO OutputMoney
               MOVE Result TO OutputDate
               WRITE OutputFileBuffer FROM OutputFileRecord 

               READ OpenClientFile INTO OpenClientRecord
                  AT END SET EOFOpenClien TO TRUE
                  NOT AT END ADD 1 TO TxnCounter
               END-READ
            END-PERFORM.
        DisplaySummaryResult.
            MOVE SPACES TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE "TOTALES" TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE DisplayTxnCounter TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE SolAccum TO SolAccumD
            MOVE DisplaySolAccum TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE DolarAccum TO DolarAccumD
            MOVE DisplayDolarAccum TO OutputFileBuffer
            PERFORM PrintAndWrite
            MOVE Header TO OutputFileBuffer
            PERFORM PrintAndWrite.
