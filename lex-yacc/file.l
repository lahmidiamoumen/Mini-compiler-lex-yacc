%{

#include "file.tab.h"
#include <stdio.h>
#include <string.h>
%}

blancs [ \t]+
chiffre [0-9]
ident [a-zA-Z_][0-9a-zA-Z_]*
entier {chiffre}+
exposant [eE][+-]?{entier}
reel {entier}("."{entier}){exposant}?
or [orOR]
and [andAND]

%%

{blancs}
{entier} { yylval.var.value.ival = atoi(yytext);yylval.var.type = 1;return(INT); }
{reel}	 { yylval.var.value.fval = atof(yytext);yylval.var.type = 2;;return(FLOAT); }
"print" return(PRINT);
"=" return(EGALE); 
"<=" return(GE);
">=" return(LE);
"<" return(BG);
">" return(SM);
"==" return(EQ);
"!=" return(NE);
"if" return(IF);
"not" return(NOT);
"then" return(THEN);
"else" return(ELSE);
"and" return(AND);
"or" return(OR);
{ident} { strcpy(yylval.var.value.sval,yytext);yylval.var.type =3;return(ID);}
"+" return(PLUS);
"-" return(MOINS);
"*" return(FOIS);
"/" return(DIVISE);
"^" return(PUISSANCE);
"(" return(PARENTHESE_GAUCHE);
")" return(PARENTHESE_DROITE);
"\n" return(FIN);
. printf("syntax error\n");
%%

