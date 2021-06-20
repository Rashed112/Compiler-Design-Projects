%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    int data[100];


%}

/* bison declarations */

%token ROOT INT FLOAT CHAR NUM VAR IF ELSE SWITCH CASE DEFAULT LB RB PRINT BREAK FOR SIN COS TAN ARRAY OE ISPRIME FIBSERIES FACTORS WHILE
%nonassoc IFX
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left '>' '<'
%left '+' '-'
%left '/' '*'

/*bison grammers */
%%

program: ROOT ':' LB statements RB  {printf("Main Function Ends\n");}
        ;

statements: /*NULL*/
        |statements statement
        ;

statement: ';'
        | declaration ';'       {printf("DECLARATION\n");}
        | expression ';'        {printf("value of expression: %d\n",$1); $$=$1;                        
                        }
        | VAR '=' expression ';'        {
                                        data[$1] = $3; 
					printf("Value of the variable: %d\t\n",$3);
					$$=$3;
                                        }
        | NUM '+''+'';'         {
                                printf("\nvalue before Increment : %d",$1 );
                                printf("\nvalue after Increment : %d\n",$1+1 );
                                $$=$1+1;
                        }
        | NUM '-''-'';'         {
                                printf("\nvalue before Decrement : %d",$1 );
                                printf("\nvalue after Decrement : %d\n\n",$1-1 );
                                $$=$1-1;
                        }
        | FOR '(' NUM '<' NUM ')' LB statement RB       {
                                                        int i;
                                                        printf("\n***FOR Loop starts...\n");
	                                                for(i=$3 ; i<$5 ; i++) {printf("%dth Loop's expression value: %d\n", i,$8);}
                                                        }
        | WHILE '(' NUM '<' NUM ')' LB statement RB {
	                                                int i;
	                                                printf("\n***WHILE Loop starts...\n");
	                                                for(i=$3 ; i<$5 ; i++) 
                                                        {
                                                                printf("%dth Loop's expression value: %d\n", i,$8);
                                                        }
	                                                printf("\n.........................................\n");									
				        }
        | SWITCH '(' VAR ')' LB CS RB           
        | IF '(' expression ')' LB expression ';' RB %prec IFX {
								if($3){
									printf("\nvalue of expression in IF: %d\n",$6);
								}
								else{
									printf("condition value zero in IF block\n");
								}
							}
        | IF '(' expression ')' LB expression ';' RB ELSE LB expression ';' RB {
                                                                                if($3){
									        printf("value of expression in IF: %d\n",$6);
								                }
								                else{
									        printf("value of expression in ELSE: %d\n\n",$11);
								                }
                                                                        }
        | ARRAY TYPE VAR '(' NUM ')' '=' NUM ';'        {
		                                printf("ARRAY Declaration\n");
		                                printf("ArraySize : %d\n",$5);
                                                int i=0;
                                                while(i<$5) {
                                                        printf("ARRAY's index = %d, intializing value = %d\n",i,$8);
                                                        i++;
                                                }
	                                }
        | OE '(' NUM ')' ';'    {
		                printf("***Odd Even Number checking... \n");
		                if($3 %2 ==0){
			                printf("%d is an Even Number\n\n",$3);
		                }
		                else{
			                printf("%d is an Odd Number\n\n",$3);
		                }
                        }
        | ISPRIME '(' NUM ')' ';'       {
                                        printf("\n***Prime Number checking....\n");
                                        int i, flag = 0;
                                        for (i = 2; i <= $3 / 2; ++i) {
                                                if ($3 % i == 0) {
                                                flag = 1;
                                                break;
                                                }
                                        }
                                        if ($3 == 1) {
                                        printf("1 is neither prime nor composite.\n");
                                        } 
                                        else {
                                                if (flag == 0)
                                                        printf("%d is a prime number.\n", $3);
                                                else
                                                        printf("%d is not a prime number.\n", $3);
                                        }
                                }
        | FIBSERIES '(' NUM ')' ';'     {
                                        int i, t1 = 0, t2 = 1;
                                        int nextTerm = t1 + t2;
                                        printf("\n***Fibonacci Series upto %d terms...\n",$3);
                                        printf("Fibonacci Series: %d  %d  ", t1, t2);

                                        for (i = 1; i <= $3; ++i) {
                                                printf("%d  ", nextTerm);
                                                t1 = t2;
                                                t2 = nextTerm;
                                                nextTerm = t1 + t2;
                                        }
                                        printf("\n\n");
                                }
        | FACTORS '(' NUM ')' ';'       {
                                        int i;
                                        printf("\n***Finding the FACTORS of number %d...\n",$3);
                                        printf("Factors of %d are: ",$3);
                                        for (i = 1; i <= $3; ++i) {
                                                if ($3 % i == 0) {
                                                printf("%d  ", i);
                                                }
                                        }
                                        printf("\n\n");
                                }

        | PRINT '(' expression ')' ';'          {printf("Printing the result : %d\n\n",$3);}                  
        ; 

CS: C
        | C D
        ;
C: C '+' C 
        | CASE NUM ':' expression ';' BREAK ';'         {}
        ;
D: DEFAULT ':' expression ';' BREAK ';'           {}
        ;

declaration: TYPE ID1
        ;
TYPE: INT
        |FLOAT
        |CHAR
        ;
ID1: ID1 ',' VAR 
        |VAR 
        ;
expression: NUM				{ printf("\nNumber :  %d\n",$1 ); $$ = $1;  }

	| VAR				{ $$ = data[$1]; }
	
	| expression '+' expression	{printf("\nAdding Two Numbers : %d+%d = %d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\nSubtracting Two Numbers : %d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\nMultiplication of Two Numbers : %d*%d \n ",$1,$3,$1*$3); $$ = $1 * $3;}

	| expression '/' expression	{ if($3){
				     		printf("\nDivision :%d/%d \n ",$1,$3,$1/$3);
				     		$$ = $1 / $3;
				     					
				  	}
				  	else{
						$$ = 0;
						printf("\nDivision by zero\n\t");
				  	} 	
				}
	| expression '%' expression	{ if($3){
				     		printf("\nMod :%d % %d \n",$1,$3,$1 % $3);
				     		$$ = $1 % $3;
				     					
				  	}
				  	else{
						$$ = 0;
						printf("\nMOD by zero\n");
				  	} 	
				}
	| expression '^' expression	{printf("\nPower  :%d ^ %d \n",$1,$3,$1 ^ $3);  $$ = pow($1 , $3);}
	| expression '<' expression	{printf("\nLess-Than functionality :%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{printf("\nGreater-Than functionality :%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
        | expression '=''=' expression  {
                                        
                                        printf("\nEqual functionality: %d == %d\n",$1,$4);
                                        $$ = $1 == $4;                                        
                                }
        | expression '!''=' expression  {
                                        
                                        printf("\nInequal functionality: %d == %d\n",$1,$4);
                                        $$ = $1 != $4;                                        
                                }

	| '(' expression ')'		{$$ = $2; }
	| SIN expression 		{
                                        printf("\n***Trigonometric Function...\n");
                                        printf("\nValue of Sin(%d) is : %lf\n",$2,sin($2*3.1416/180)); 
                                        $$=sin($2*3.1416/180);
                                        }

        | COS expression 		{
                                        printf("\n***Trigonometric Function...\n");
                                        printf("\nValue of Cos(%d) is : %lf\n",$2,cos($2*3.1416/180)); 
                                        $$=cos($2*3.1416/180);
                                        }

        | TAN expression 		{
                                        printf("\n***Trigonometric Function...\n");
                                        printf("\nValue of Tan(%d) is : %lf\n\n",$2,tan($2*3.1416/180)); 
                                        $$=tan($2*3.1416/180);
                                        }

        ;           	

%%

/*Additional C code*/

yyerror(char *s){    //called by yyparse on error
	printf( "%s\n", s);
}


