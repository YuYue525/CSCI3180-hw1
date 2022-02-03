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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int timestamp = 0;
char line[100];

void checkFile(void)
{
    FILE * master;
    if((master = fopen("master.txt", "r")) == NULL)
    {
        printf("non-existing file!\n");
        exit(0);
    }
    
    FILE * trans;
    trans = fopen("trans711.txt", "w");
    fclose(trans);
    trans = fopen("trans713.txt", "w");
    fclose(trans);
}

FILE * chooseATM(void)
{
    FILE *trans = NULL;
    while(1)
    {
        printf("=> PLEASE CHOOSE THE ATM\n");
        printf("=> PRESS 1 FOR ATM 711\n");
        printf("=> PRESS 2 FOR ATM 713\n");
        
        char input_atm[100];
        scanf("%s", input_atm);
        //getchar();
        if(input_atm[0]=='1' && input_atm[1]=='\0')
        {
            if((trans = fopen("trans711.txt", "a+")) == NULL)
            {
                printf("non-existing file!\n");
                exit(0);
            }
            break;
        }
        else if(input_atm[0]=='2' && input_atm[1]=='\0')
        {
            if((trans = fopen("trans713.txt", "a+")) == NULL)
            {
                printf("non-existing file!\n");
                exit(0);
            }
            break;
        }
        else
            printf("=> INVALID INPUT\n");
    }
    return trans;
}

int checkAccount(void) // return input account
{
    while(1)
    {
        FILE * master = fopen("master.txt", "r");
        char input_account[100];
        char input_password[100];
        

        
        printf("=> ACCOUNT\n");
        scanf("%s", input_account);
        printf("=> PASSWORD\n");
        scanf("%s", input_password);
        
        //printf("%s\n", input_account);
        //printf("%s\n", input_password);

        int findOrNot = 0;
        
        while(fgets(line, 100, master)!=NULL)
        {
            int correct = 1;
            for(int i=20; i<36; i++)
            {
                if(input_account[i-20]!=line[i])
                {
                    correct = 0;
                    break;
                }
            }
            for(int i=36; i<42; i++)
            {
                if(input_password[i-36]!=line[i])
                {
                    correct = 0;
                    break;
                }
            }
            if(correct == 1)
            {
                findOrNot = 1;
                break;
            }
        }
        if(findOrNot == 1)
        {
            int allZero = 1;
            for(int i=43; i<58; i++)
                if(line[i] != '0')
                    allZero = 0;
            if(line[42] == '-' && allZero == 0)
            {
                printf("=> NEGATIVE REMAINS TRANSACTION ABORT\n");
                return 0;
            }
            else
                return 1;
        }
        else
            printf("=> INCORRECT ACCOUNT/PASSWORD\n");
    }
}

void chooseService(FILE * trans)
{
    while(1)
    {
        printf("=> PLEASE CHOOSE YOUR SERVICE\n");
        printf("=> PRESS D FOR DEPOSIT\n");
        printf("=> PRESS W FOR WITHDRAWAL\n");
        printf("=> PRESS T FOR TRANSFER\n");
        
        int endOfService = 0;
        
        char input_service[100];
        scanf("%s", input_service);
        //getchar();
        if(input_service[0]=='D' && input_service[1]=='\0')
        {
            while(1)
            {
                float input_amount;
                printf("=> AMOUNT\n");
                scanf("%f", &input_amount);
                getchar();
                if(input_amount >= 0)
                {
                    //printf("%f\n", input_amount);
                    for(int i=20; i<36; i++)
                        fprintf(trans, "%c", line[i]);
                    fprintf(trans, "D");
                    fprintf(trans, "%07d%05d\n", (int)(input_amount*100), timestamp);
                    endOfService = 1;
                    //printf("%d\n", (int)(input_amount*100));
                    //printf("%d\n", timestamp);
                    timestamp ++;
                    break;
                }
                printf("=> INVALID INPUT\n");
            }
        }
        else if(input_service[0]=='W' && input_service[1]=='\0')
        {
            while(1)
            {
                float input_amount;
                printf("=> AMOUNT\n");
                scanf("%f", &input_amount);
                getchar();
                if(input_amount >= 0)
                {
                    long long balance = 0;
                    for(int i = 43; i<58; i++)
                        balance = balance * 10 + (line[i]-'0');
                    if(balance < (int)(input_amount * 100))
                        printf("=> INSUFFICIENT BALANCE\n");
                    else
                    {
                        for(int i=20; i<36; i++)
                            fprintf(trans, "%c", line[i]);
                        fprintf(trans, "W");
                        fprintf(trans, "%07d%05d\n", (int)(input_amount*100), timestamp);
                        endOfService = 1;
                        //printf("%d\n", (int)(input_amount*100));
                        //printf("%d\n", timestamp);
                        timestamp ++;
                        break;
                    }
                }
                else
                    printf("=> INVALID INPUT\n");
            }
        }
        else if(input_service[0]=='T' && input_service[1]=='\0')
        {
            int transOrNot = 0;
            while(transOrNot == 0)
            {
                printf("=> TARGET ACCOUNT\n");
                char input_target[100];
                scanf("%s", input_target);
                FILE * master = fopen("master.txt", "r");
                
                int findOrNot = 0;
                char target_line[100];
                while(fgets(target_line, 100, master)!=NULL)
                {
                    
                    int correct = 1;
                    for(int i=20; i<36; i++)
                    {
                        if(input_target[i-20]!=target_line[i])
                        {
                            correct = 0;
                            break;
                        }
                    }
                    if(correct == 1)
                    {
                        findOrNot = 1;
                        break;
                    }
                }
                int isSender = 1;
                if(findOrNot == 1)
                {
                    for(int i = 20; i<36; i++)
                        if(input_target[i-20] != line[i])
                            isSender = 0;
                    if(isSender == 1)
                        printf("=> YOU CANNOT TRANSFER TO YOURSELF\n");
                    else
                    {
                        while(1)
                        {
                            float input_amount;
                            printf("=> AMOUNT\n");
                            scanf("%f", &input_amount);
                            getchar();
                            if(input_amount >= 0)
                            {
                                long long balance = 0;
                                for(int i = 43; i<58; i++)
                                    balance = balance * 10 + (line[i]-'0');
                                if(balance < (int)(input_amount * 100))
                                    printf("=> INSUFFICIENT BALANCE\n");
                                else
                                {
                                    for(int i=20; i<36; i++)
                                        fprintf(trans, "%c", line[i]);
                                    fprintf(trans, "W");
                                    fprintf(trans, "%07d%05d\n", (int)(input_amount*100), timestamp);
                                    timestamp ++;
                                    
                                    for(int i=0; i<16; i++)
                                        fprintf(trans, "%c", input_target[i]);
                                    fprintf(trans, "D");
                                    fprintf(trans, "%07d%05d\n", (int)(input_amount*100), timestamp);
                                    
                                    endOfService = 1;
                                    transOrNot = 1;
                                    //printf("%d\n", (int)(input_amount*100));
                                    //printf("%d\n", timestamp);
                                    timestamp ++;
                                    
                                    break;
                                }
                            }
                            else
                                printf("=> INVALID INPUT\n");
                        }
                    }
                }
                else
                    printf("=> TARGET ACCOUNT DOES NOT EXIST\n");
            }
        }
        else
            printf("=> INVALID INPUT\n");

        if(endOfService == 1)
            break;
    }

}


int main(void) {
    printf("##############################################\n");
    printf("##         Gringotts Wizarding Bank         ##\n");
    printf("##                 Welcome                  ##\n");
    printf("##############################################\n");
    
    FILE *trans = NULL;

    checkFile();

    while(1)
    {
        int exit = 0;
        
        trans = chooseATM();
        if(checkAccount()!=0)
            chooseService(trans);
        else
            continue;
        char input_continue[100];
        while(1)
        {
            printf("=> CONTINUE?\n");
            printf("=> N FOR NO\n");
            printf("=> Y FOR YES\n");
            scanf("%s", input_continue);
            if(input_continue[0] == 'N' && input_continue[1] == '\0')
            {
                exit = 1;
                break;
            }
            else if(input_continue[0] == 'Y' && input_continue[1] == '\0')
                break;
            else
                printf("=> INVALID INPUT\n");
        }
        if(exit == 1)
            break;

    }

    return 0;
}
