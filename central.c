/*
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
*
* I declare that the assignment here submitted is original except for source
* material explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such polic
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Assignment 1
* Name : YU Yue
* Student ID : 1155124490
* Email Addr : 1155124490@link.cuhk.edu.hk
*/
#include "sort.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


void checkFile(void)
{
    FILE * master;
    if((master = fopen("master.txt", "r")) == NULL)
    {
        printf("non-existing file!\n");
        exit(0);
    }
    
    FILE * trans711;
    if((trans711 = fopen("trans711.txt", "r")) == NULL)
    {
        printf("non-existing file!\n");
        exit(0);
    }
    
    FILE * trans713;
    if((trans713 = fopen("trans713.txt", "r")) == NULL)
    {
        printf("non-existing file!\n");
        exit(0);
    }
    
    fclose(master);
    fclose(trans711);
    fclose(trans713);
    
}

void merge(void)
{
    FILE * trans711 = fopen("trans711.txt", "r");
    FILE * trans713 = fopen("trans713.txt", "r");
    FILE * transSorted = fopen("transSorted.txt", "w");
    
    char line[100];
    
    while(fgets(line, 100, trans711)!=NULL)
    {
        for(int i = 0; i < 29; i++)
            fprintf(transSorted, "%c", line[i]);
        fprintf(transSorted, "\n");
    }

    while(fgets(line, 100, trans713)!=NULL)
    {
        for(int i = 0; i < 29; i++)
            fprintf(transSorted, "%c", line[i]);
        fprintf(transSorted, "\n");
    }
    
    fclose(trans711);
    fclose(trans713);
    fclose(transSorted);
    
}

void update(void)
{
    FILE * master = fopen("master.txt", "r");
    FILE * trans = fopen("transSorted.txt", "r");
    FILE * updatedMaster = fopen("updatedMaster.txt", "w+");
    char masterline[100];
    char transline[100];
    
    while(fgets(masterline, 100, master)!=NULL)
    {
        long long balance = 0;
        for(int i = 43; i<58; i++)
            balance = balance * 10 + (masterline[i]-'0');
        if(masterline[42] == '-')
            balance = - balance;
        fseek(trans, 0, SEEK_SET);
        while(fgets(transline, 100, trans)!=NULL)
        {
            int accountCheck = 1;
            for(int i = 0; i <16; i++)
            {
                if(masterline[i+20] != transline[i])
                {
                    accountCheck = 0;
                    break;
                }
            }
            if(accountCheck == 1)
            {
                int transAmount = 0;
                for(int i = 17; i<24; i++)
                    transAmount = transAmount * 10 + (transline[i]-'0');
                if(transline[16]=='D')
                    balance += transAmount;
                else
                    balance -= transAmount;
            }
        }
        for(int i=0; i<42; i++)
            fprintf(updatedMaster, "%c", masterline[i]);
        if(balance >= 0)
        {
            fprintf(updatedMaster, "+");
            fprintf(updatedMaster, "%015lld\n", balance);
            //printf("%015lld\n", balance);
        }
        else
        {
            fprintf(updatedMaster, "-");
            fprintf(updatedMaster, "%015lld\n", -balance);
            //printf("%015lld\n", -balance);
        }
    }
    
    sort_transaction("updatedMaster.txt", "updatedMaster.txt");
    
    FILE * negReport = fopen("negReport.txt", "w");
    fseek(updatedMaster, 0, SEEK_SET);
    while(fgets(masterline, 100, updatedMaster)!=NULL)
    {
        if(masterline[42] == '-')
        {
            int allZero = 1;
            for(int i=43; i<58; i++)
                if(masterline[i] != '0')
                    allZero = 0;
            if(allZero == 0)
            {
                fprintf(negReport, "Name: ");
                for(int i=0; i<20; i++)
                    fprintf(negReport, "%c", masterline[i]);
                fprintf(negReport, " Account Number: ");
                for(int i=20; i<36; i++)
                    fprintf(negReport, "%c", masterline[i]);
                fprintf(negReport, " Balance: ");
                for(int i=42; i<58; i++)
                    fprintf(negReport, "%c", masterline[i]);
                fprintf(negReport, "\n");
            }
        }
    }
    
    fclose(master);
    fclose(updatedMaster);
    fclose(trans);
    fclose(negReport);
}

int main(void) {
    checkFile();
    sort_transaction("trans711.txt", "transSorted711.txt");
    sort_transaction("trans713.txt", "transSorted713.txt");
    
    merge();
    sort_transaction("transSorted.txt", "transSorted.txt");
    update();
    
    
    
    return 0;
}
