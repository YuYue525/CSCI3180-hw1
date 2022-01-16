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
       PROGRAM-ID. central.
       AUTHOR. YU Yue.
       DATE-WRITTEN. 16/1/22.
       SECURITY. PRIVATE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MASTER ASSIGN TO 'master.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711 ASSIGN TO 'trans711.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713 ASSIGN TO 'trans713.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSSORTED711 ASSIGN TO 'transSorted711.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSSORTED713 ASSIGN TO 'transSorted713.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSSORTED ASSIGN TO 'transSorted.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT UPDATEDMASTER ASSIGN TO 'updatedMaster.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT NEGREPORT ASSIGN TO 'negReport.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT WORK ASSIGN TO 'work.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD MASTER.
       01 MASTER-RECORD.
           02 NAME PIC X(20).
           02 ACCOUNT-NUM PIC 9(16).
           02 PWD PIC 9(6).
           02 BALANCE-SIGN PIC X.
           02 BALANCE PIC 9(15).

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

       FD TRANSSORTED711.
       01 SORTED711-RECORD.
           02 SORTED711-ID PIC 9(16).
           02 SORTED711-OP PIC A(1).
           02 SORTED711-AMOUNT PIC 9(7).
           02 SORTED711-TS PIC 9(5).

       FD TRANSSORTED713.
       01 SORTED713-RECORD.
           02 SORTED713-ID PIC 9(16).
           02 SORTED713-OP PIC A(1).
           02 SORTED713-AMOUNT PIC 9(7).
           02 SORTED713-TS PIC 9(5).

       FD TRANSSORTED.
       01 SORTED-RECORD.
           02 SORTED-ID PIC 9(16).
           02 SORTED-OP PIC A(1).
           02 SORTED-AMOUNT PIC 9(7).
           02 SORTED-TS PIC 9(5).

       FD UPDATEDMASTER.
       01 UPDATEDMASTER-RECORD.
           02 UPDATEDNAME PIC X(20).
           02 UPDATEDACCOUNT-NUM PIC 9(16).
           02 UPDATEDPWD PIC 9(6).
           02 UPDATEDBALANCE-SIGN PIC X.
           02 UPDATEDBALANCE PIC 9(15).

       FD NEGREPORT.
       01 NEG-RECORD.
           02 NEG-NAME-TITLE PIC X(6).
           02 NEG-NAME PIC X(20).
           02 NEG-ACCOUNT-TITLE PIC X(16).
           02 NEG-ACCOUNT-NUM PIC 9(16).
           02 NEG-BALANCE-TITLE PIC X(10).
           02 NEG-BALANCE-SIGN PIC X.
           02 NEG-BALANCE PIC 9(15).

       SD WORK.
       01 WORK-RECORD.
           02 WORK-ID PIC 9(16).
           02 WORK-OP PIC A(1).
           02 WORK-AMOUNT PIC 9(7).
           02 WORK-TS PIC 9(5).

       WORKING-STORAGE SECTION.
       01 CURRENT-BALANCE PIC S9(15).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.

           SORT WORK ON ASCENDING KEY WORK-ID
           ON ASCENDING KEY WORK-TS
           USING TRANS711 GIVING TRANSSORTED711.

           SORT WORK ON ASCENDING KEY WORK-ID
           ON ASCENDING KEY WORK-TS
           USING TRANS713 GIVING TRANSSORTED713.

           OPEN OUTPUT TRANSSORTED.
           CLOSE TRANSSORTED.

           OPEN INPUT TRANS711.
       COPY-711.
           READ TRANS711 INTO 711-RECORD
           NOT AT END
               OPEN EXTEND TRANSSORTED
               MOVE 711-RECORD TO SORTED-RECORD
               WRITE SORTED-RECORD
               CLOSE TRANSSORTED
               GO TO COPY-711
           AT END
               CLOSE TRANS711.

           OPEN INPUT TRANS713.
       COPY-713.
           READ TRANS713 INTO 713-RECORD
           NOT AT END
               OPEN EXTEND TRANSSORTED
               MOVE 713-RECORD TO SORTED-RECORD
               WRITE SORTED-RECORD
               CLOSE TRANSSORTED
               GO TO COPY-713
           AT END
               CLOSE TRANS713.

           SORT WORK ON ASCENDING KEY WORK-ID
           ON ASCENDING KEY WORK-TS
           USING TRANSSORTED GIVING TRANSSORTED.

           OPEN INPUT MASTER.
           OPEN OUTPUT UPDATEDMASTER.
       READ-MASTER.
           READ MASTER INTO MASTER-RECORD
           NOT AT END
               MOVE MASTER-RECORD TO UPDATEDMASTER-RECORD
               MOVE BALANCE TO CURRENT-BALANCE
               IF BALANCE-SIGN = '-' THEN
                   SUBTRACT BALANCE FROM 0
                       GIVING CURRENT-BALANCE
               END-IF
               IF BALANCE-SIGN = '+' THEN
                   ADD BALANCE TO 0
                       GIVING CURRENT-BALANCE
               END-IF
               OPEN INPUT TRANSSORTED
               GO TO READ-TRANS
           AT END
               CLOSE MASTER
               CLOSE UPDATEDMASTER
               GO TO REPORT-NEG.

       READ-TRANS.
           READ TRANSSORTED INTO SORTED-RECORD
           NOT AT END
               IF SORTED-ID = ACCOUNT-NUM THEN
                   IF SORTED-OP = 'D' THEN
                       ADD SORTED-AMOUNT TO CURRENT-BALANCE
                       GIVING CURRENT-BALANCE
                   END-IF
                   IF SORTED-OP = 'W' THEN
                       SUBTRACT SORTED-AMOUNT FROM CURRENT-BALANCE
                       GIVING CURRENT-BALANCE
                   END-IF
               END-IF
               GO TO READ-TRANS
           AT END
               CLOSE TRANSSORTED
               IF CURRENT-BALANCE >= 0 THEN
                   MOVE CURRENT-BALANCE TO UPDATEDBALANCE
                   MOVE '+' TO UPDATEDBALANCE-SIGN
               END-IF
               IF CURRENT-BALANCE < 0 THEN
                   SUBTRACT CURRENT-BALANCE FROM 0
                   GIVING CURRENT-BALANCE
                   MOVE CURRENT-BALANCE TO UPDATEDBALANCE
                   MOVE '-' TO UPDATEDBALANCE-SIGN
               END-IF
               WRITE UPDATEDMASTER-RECORD
               GO TO READ-MASTER.

       REPORT-NEG.
           OPEN INPUT UPDATEDMASTER.
           OPEN OUTPUT NEGREPORT.
       CHECK-NEG.
           READ UPDATEDMASTER INTO UPDATEDMASTER-RECORD
           NOT AT END
               IF UPDATEDBALANCE-SIGN = '-' AND UPDATEDBALANCE >0 THEN
                   MOVE "Name: " TO NEG-NAME-TITLE
                   MOVE "Account Number: " TO NEG-ACCOUNT-TITLE
                   MOVE " Balance: " TO NEG-BALANCE-TITLE
                   MOVE UPDATEDNAME TO NEG-NAME
                   MOVE UPDATEDACCOUNT-NUM TO NEG-ACCOUNT-NUM
                   MOVE UPDATEDBALANCE-SIGN TO NEG-BALANCE-SIGN
                   MOVE UPDATEDBALANCE TO NEG-BALANCE
                   WRITE NEG-RECORD
               END-IF
               GO TO CHECK-NEG
           AT END
               CLOSE UPDATEDMASTER
               CLOSE NEGREPORT.

           STOP RUN.
       END PROGRAM central.
