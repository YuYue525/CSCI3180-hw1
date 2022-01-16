      ******************************************************************
      * CSCI3180 Principles of Programming Languages
      *
      * --- Declaration ---
      *
      * I declare that the assignment here submitted is original except for source
      * material explicitly acknowledged. I also acknowledge that I am aware of
      * University policy and regulations on honesty in academic work, and of the
      * disciplinary guidelines and procedures applicable to breaches of such policy
      * and regulations, as contained in the website
      * http://www.cuhk.edu.hk/policy/academichonesty/
      *
      * Assignment 1
      * Name : YU Yue
      * Student ID : 1155124490
      * Email Addr : 1155124490@link.cuhk.edu.hk
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. atms.
       AUTHOR. YU Yue.
       DATE-WRITTEN. 15/1/22.
       SECURITY. PRIVATE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS711 ASSIGN TO 'trans711.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713 ASSIGN TO 'trans713.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MASTER ASSIGN TO 'master.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD TRANS711.
       01 711-RECORD.
           02 711-ID PIC 9(16).
           02 711-OP PIC A(1).
           02 711-AMOUNT PIC 9(7).
           02 711-TS PIC 9(5).

       FD TRANS713.
       01 713-RECORD.
           02 713-ID PIC 9(16).
           02 713-OP PIC A(1).
           02 713-AMOUNT PIC 9(7).
           02 713-TS PIC 9(5).

       FD MASTER.
       01 MASTER-RECORD.
           02 NAME PIC A(20).
           02 ACCOUNT-NUM PIC 9(16).
           02 PWD PIC 9(6).
           02 BALANCE-SIGN PIC X.
           02 BALANCE PIC 9(15).

       WORKING-STORAGE SECTION.
       01 INPUT-ATM PIC X(20).
       01 USER-INPUT PIC X(20).
       01 INPUT-ACCOUNT PIC X(16).
       01 INPUT-PWD PIC X(6).
       01 INPUT-AMOUNT PIC S9(10)V9(2).
       01 RECORD-NUM PIC 9(5) VALUE ZERO.
       01 INPUT-TARGET-ACCOUNT PIC X(16).
       01 CURRENT-RECORD.
           02 CURRENT-NAME PIC A(20).
           02 CURRENT-ACCOUNT-NUM PIC 9(16).
           02 CURRENT-PWD PIC 9(6).
           02 CURRENT-BALANCE-SIGN PIC X.
           02 CURRENT-BALANCE PIC 9(15).

       PROCEDURE DIVISION.
       MAIN-PARAGRAPH.
           DISPLAY "##############################################".
           DISPLAY "##         Gringotts Wizarding Bank         ##".
           DISPLAY "##                 Welcome                  ##".
           DISPLAY "##############################################".

       CHOOSE-ATM-PARAGRAPH.
           DISPLAY "=> PLEASE CHOOSE THE ATM".
           DISPLAY "=> PRESS 1 FOR ATM 711".
           DISPLAY "=> PRESS 2 FOR ATM 713".
           ACCEPT INPUT-ATM.
           IF NOT INPUT-ATM = "1" AND NOT INPUT-ATM = "2" THEN
               DISPLAY "=> INVALID INPUT"
               GO TO CHOOSE-ATM-PARAGRAPH
           END-IF.

       ACCOUNT-CHECK-PARAGRAPH.
           DISPLAY "=> ACCOUNT".
           ACCEPT INPUT-ACCOUNT.
           DISPLAY "=> PASSWORD".
           ACCEPT INPUT-PWD.
           OPEN INPUT MASTER.

       READ-MASTER.
           READ MASTER INTO MASTER-RECORD

           NOT AT END
               IF NOT ACCOUNT-NUM = INPUT-ACCOUNT OR
                   NOT PWD = INPUT-PWD THEN
                   GO TO READ-MASTER
               END-IF
               IF ACCOUNT-NUM = INPUT-ACCOUNT AND PWD = INPUT-PWD THEN
                   MOVE MASTER-RECORD TO CURRENT-RECORD
                   CLOSE MASTER
                   GO TO CHOOSE-SERVICE-PARAGRAPH
               END-IF
           AT END
               CLOSE MASTER
               DISPLAY "=> INCORRECT ACCOUNT/PASSWORD"
               GO TO ACCOUNT-CHECK-PARAGRAPH.

       CHOOSE-SERVICE-PARAGRAPH.
           DISPLAY "=> PLEASE CHOOSE YOUR SERVICE".
           DISPLAY "=> PRESS D FOR DEPOSIT".
           DISPLAY "=> PRESS W FOR WITHDRAWAL".
           DISPLAY "=> PRESS T FOR TRANSFER".
           ACCEPT USER-INPUT.
           IF NOT USER-INPUT = "D" AND NOT USER-INPUT = "W"
               AND NOT USER-INPUT = "T" THEN
               DISPLAY "=> INVALID INPUT"
               GO TO CHOOSE-SERVICE-PARAGRAPH
           END-IF.

           IF USER-INPUT = "D" THEN
               GO TO DEPOSIT-PARAGRAPH.
           IF USER-INPUT = "W" THEN
               GO TO WITHDRAWAL-PARAGRAPH.
           IF USER-INPUT = "T" THEN
               GO TO TRANSFER-PARAGRAPH.

       DEPOSIT-PARAGRAPH.
           DISPLAY "=> AMOUNT".
           ACCEPT INPUT-AMOUNT.
           IF INPUT-AMOUNT < 0 OR INPUT-AMOUNT >=100000 THEN
               DISPLAY "=> INVALID INPUT"
               GO TO DEPOSIT-PARAGRAPH
           END-IF.
           IF INPUT-AMOUNT >= 0 THEN
               MULTIPLY 100 BY INPUT-AMOUNT GIVING INPUT-AMOUNT
               IF INPUT-ATM = 1 THEN
                   OPEN EXTEND TRANS711
                   MOVE CURRENT-ACCOUNT-NUM TO 711-ID
                   MOVE "D" TO 711-OP
                   MOVE INPUT-AMOUNT TO 711-AMOUNT
                   MOVE RECORD-NUM TO 711-TS
                   ADD 1 TO RECORD-NUM GIVING RECORD-NUM
                   WRITE 711-RECORD
                   CLOSE TRANS711
               END-IF
               IF INPUT-ATM = 2 THEN
                   OPEN EXTEND TRANS713
                   MOVE CURRENT-ACCOUNT-NUM TO 713-ID
                   MOVE "D" TO 713-OP
                   MOVE INPUT-AMOUNT TO 713-AMOUNT
                   MOVE RECORD-NUM TO 713-TS
                   ADD 1 TO RECORD-NUM GIVING RECORD-NUM
                   WRITE 713-RECORD
                   CLOSE TRANS713
               END-IF
           END-IF.
           GO TO CONTINUE-PARAGRAPH.

       WITHDRAWAL-PARAGRAPH.
           DISPLAY "=> AMOUNT".
           ACCEPT INPUT-AMOUNT.
           IF INPUT-AMOUNT < 0 OR INPUT-AMOUNT > 100000 THEN
               DISPLAY "=> INVALID INPUT"
               GO TO WITHDRAWAL-PARAGRAPH
           END-IF.
           MULTIPLY 100 BY INPUT-AMOUNT GIVING INPUT-AMOUNT.
           IF INPUT-AMOUNT > CURRENT-BALANCE THEN
               DISPLAY "=> INSUFFICIENT BALANCE"
               GO TO WITHDRAWAL-PARAGRAPH
           END-IF.
           IF INPUT-ATM = 1 THEN
               OPEN EXTEND TRANS711
               MOVE CURRENT-ACCOUNT-NUM TO 711-ID
               MOVE "W" TO 711-OP
               MOVE INPUT-AMOUNT TO 711-AMOUNT
               MOVE RECORD-NUM TO 711-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 711-RECORD
               CLOSE TRANS711
           END-IF
           IF INPUT-ATM = 2 THEN
               OPEN EXTEND TRANS713
               MOVE CURRENT-ACCOUNT-NUM TO 713-ID
               MOVE "W" TO 713-OP
               MOVE INPUT-AMOUNT TO 713-AMOUNT
               MOVE RECORD-NUM TO 713-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 713-RECORD
               CLOSE TRANS713
           END-IF
           GO TO CONTINUE-PARAGRAPH.

       TRANSFER-PARAGRAPH.
           DISPLAY "=> TARGET ACCOUNT".
           ACCEPT INPUT-TARGET-ACCOUNT.
           IF INPUT-TARGET-ACCOUNT = INPUT-ACCOUNT THEN
               DISPLAY "=> YOU CANNOT TRANSFER TO YOURSELF"
               GO TO TRANSFER-PARAGRAPH
           END-IF.
           OPEN INPUT MASTER.
       CHECK-TARGET.
           READ MASTER INTO MASTER-RECORD
           NOT AT END
               IF NOT ACCOUNT-NUM = INPUT-TARGET-ACCOUNT THEN
                   GO TO CHECK-TARGET
               END-IF
               IF ACCOUNT-NUM = INPUT-TARGET-ACCOUNT THEN
                   CLOSE MASTER
                   GO TO CHECK-BALANCE
               END-IF
           AT END
               CLOSE MASTER
               DISPLAY "=> TARGET ACCOUNT DOES NOT EXIST"
               GO TO TRANSFER-PARAGRAPH.
       CHECK-BALANCE.
           DISPLAY "=> AMOUNT".
           ACCEPT INPUT-AMOUNT.
           IF INPUT-AMOUNT < 0 OR INPUT-AMOUNT > 100000 THEN
               DISPLAY "=> INVALID INPUT"
               GO TO CHECK-BALANCE
           END-IF.
           MULTIPLY 100 BY INPUT-AMOUNT GIVING INPUT-AMOUNT.
           IF INPUT-AMOUNT > CURRENT-BALANCE THEN
               DISPLAY "=> INSUFFICIENT BALANCE"
               GO TO CHECK-BALANCE
           END-IF.
           IF INPUT-ATM = 1 THEN
               OPEN EXTEND TRANS711
               MOVE CURRENT-ACCOUNT-NUM TO 711-ID
               MOVE "W" TO 711-OP
               MOVE INPUT-AMOUNT TO 711-AMOUNT
               MOVE RECORD-NUM TO 711-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 711-RECORD
               MOVE INPUT-TARGET-ACCOUNT TO 711-ID
               MOVE "D" TO 711-OP
               MOVE INPUT-AMOUNT TO 711-AMOUNT
               MOVE RECORD-NUM TO 711-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 711-RECORD
               CLOSE TRANS711
           END-IF
           IF INPUT-ATM = 2 THEN
               OPEN EXTEND TRANS713
               MOVE CURRENT-ACCOUNT-NUM TO 713-ID
               MOVE "W" TO 713-OP
               MOVE INPUT-AMOUNT TO 713-AMOUNT
               MOVE RECORD-NUM TO 713-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 713-RECORD
               MOVE INPUT-TARGET-ACCOUNT TO 713-ID
               MOVE "D" TO 713-OP
               MOVE INPUT-AMOUNT TO 713-AMOUNT
               MOVE RECORD-NUM TO 713-TS
               ADD 1 TO RECORD-NUM GIVING RECORD-NUM
               WRITE 713-RECORD
               CLOSE TRANS713
           END-IF
           GO TO CONTINUE-PARAGRAPH.

       CONTINUE-PARAGRAPH.
           DISPLAY "=> CONTINUE?"
           ACCEPT USER-INPUT.
           IF USER-INPUT = 'Y' THEN
               GO TO CHOOSE-ATM-PARAGRAPH
           END-IF.
           IF NOT USER-INPUT = 'N' THEN
               DISPLAY "=> INVALID INPUT"
               GO TO CONTINUE-PARAGRAPH
           END-IF.
           STOP RUN.
       END PROGRAM atms.
