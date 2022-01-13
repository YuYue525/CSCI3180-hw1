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
}


int main(void) {
    sort_transaction("trans711.txt", "trans711_new.txt");
    return 0;
}
