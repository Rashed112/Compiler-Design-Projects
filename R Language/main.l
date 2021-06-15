/* C Declarations */

%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<math.h>
    #include<string.h>
    #include "main.tab.h"     /*header for token defination*/    
    extern YYSTYPE yylval;
%}

/* Token Definations */
header  "import ".*


/*REGULAR EXPRESSIONS defining the tokens for the R language */

%%
"int"   {return INT;}
"float" {return FLOAT;}
"char"  {return CHAR;}
[0-9]+  {
        yylval = atoi(yytext);
        return NUM;
        }
[a-zA-Z]   {
        yylval = *yytext - 'a';
        return VAR;
        }
[-+/*<>=,():;%^!]    {
                    yylval = yytext[0];	
                    return  *yytext;	
                    }
"IF"    {return IF;}
"ELSE"  {return ELSE;}
"SWITCH"    {return SWITCH;}
"CASE"      {return CASE;}
"DEFAULT"   {return DEFAULT;}
"{"     {return LB;}
"}"     {return RB;}
"print" {return PRINT;}
"BREAK" {return BREAK;}
"FOR"   {return FOR;}
"SIN"   {return SIN;}
"COS"   {return COS;}
"TAN"   {return TAN;}
"ARRAY" {return ARRAY;}
"OE"    {return OE;}
"ISPRIME"       {return ISPRIME;}
"FIBSERIES"     {return FIBSERIES;}
"FACTORS"       {return FACTORS;}
"WHILE"         {return WHILE;}
[#].*   {
        ECHO;printf("\n");
        }
{header}    {
            printf("\nHeader file found :\n");ECHO;printf("\n");
            }
"root"      {return ROOT;}
[\n]*       {}
[\t]*       {}
[ ]*	    {}
.           {printf("%s --> Unknown Input\n",yytext);}

%%

int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
    
	return 0;
}