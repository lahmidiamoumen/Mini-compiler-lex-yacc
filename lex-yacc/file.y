%{
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define SIZE 0x100
#define true 1
#define false 0

int yylex();
int yyerror();

enum{ INT_TYPE = 1,
      FLOAT_TYPE = 2,
      STRING_TYPE=3
    };

struct val{
	  union{
	    int ival;
	    float fval;
	    char sval[SIZE];
	   } value;
	  char type;
}var;

struct msrtuct{
	struct val code;
	char token[SIZE];
}table[100];

int count=0;
int count_p=0;
int print=false;
int ident=false;
struct msrtuct tab;
struct vals print_var;
struct vals exists(struct vals var1);
%}

%union{  struct vals{
	  union{
	    int ival;
	    float fval;
	    char sval[0x100];
	   } value;
	  char type;
	}var;

}
%token PLUS MOINE FOIS DIVISE PUISAANCE EGALE  THEN NOT
%token PARENTHESE_GAUCHE PARENTHESE_DROITE PRINT
%token GE LE EQ NE BG SM AND OR IF
%type <var> S G STM 
%token <var> FLOAT INT ID 

%token FIN
%nonassoc IFX
%nonassoc ELSE


%left  AND OR
%left  GE LE EQ NE BG SM
%left  PLUS MOINS
%left  FOIS DIVISE
%left  NEG

%right PUISSANCE
%start Input
%%
Input:
	|Input Ligne
	;
Ligne:
	 FIN
	|STM FIN {
	
		 if(print == true){
		              switch($1.type){
			              case 1: printf("int: %d\n", $1.value.ival);break;
			              case 2: printf("float: %f\n",$1.value.fval );break;
			       }
			       print = false;
		}
		if(ident == true){
		       ident = false;
			int inc=-1;
			int i;
			char cond = tab.token[0];
			for(i=0;i<count;i++)
			if(!strcmp(tab.token,table[i].token))
			{
				inc=i;
				break;
			}
			if(inc == -1){ inc = count; count++;}
			if ((tab.code.type == INT_TYPE && cond != 'f' && cond !='F' ) || ( cond == 'i'|| cond == 'I'))
			{
			   if((cond == 'i'||cond == 'I') && tab.code.type == FLOAT_TYPE) table[inc].code.value.ival = tab.code.value.fval;
			   else table[inc].code.value.ival = tab.code.value.ival;
			   table[inc].code.type =INT_TYPE;
			   strcpy(table[inc].token,tab.token);
			   printf("type int\n");
			}
			else
			{
			   if((cond == 'f'|| cond =='F') && tab.code.type == INT_TYPE) table[inc].code.value.fval = tab.code.value.ival;
			   else table[inc].code.value.fval = tab.code.value.fval;
			   table[inc].code.type =FLOAT_TYPE;
			   strcpy(table[inc].token,tab.token);
			   printf("type float\n");
		   	}	
		 }
	}


	|error FIN {yyerrok;}
	;
G:
	 S {$$=$1;}
	|G OR G { if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival || $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval || $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival || $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval || $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
	|G AND G {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival && $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval && $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival && $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval && $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		  
	|G EQ G {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival == $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval == $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival == $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval == $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		 
	|S GE S {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival <= $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		 else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval <= $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival <= $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval <= $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }	
		 
		 
	|S LE S {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival >= $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		 else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval >= $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival >= $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval >= $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		 
	|S NE S {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival != $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		  else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval != $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival != $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval != $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		 
	|S BG S {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival < $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		 else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval < $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival < $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval < $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		 
	|S SM S {if($1.type == INT_TYPE  && $3.type == INT_TYPE) 
			if($1.value.ival > $3.value.ival)
				$$.value.ival=true;
			else  $$.value.ival=false;
		  else if($1.type == FLOAT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.fval > $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
	          else if($1.type == INT_TYPE  && $3.type == FLOAT_TYPE)	
		          if($1.value.ival > $3.value.fval)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		   else if($1.type == FLOAT_TYPE  && $3.type == INT_TYPE)	
		          if($1.value.fval > $3.value.ival)
				       $$.value.fval=true;
			   else  $$.value.fval=false;
		 }
		 
       |NOT G %prec NEG{if($2.type == INT_TYPE ){ 
			if($2.value.ival == true)
				$$.value.ival=false;
			else  $$.value.ival=true;
		 }
		 else if ($2.type == FLOAT_TYPE)
		       if($2.value.fval == true)
				$$.value.fval=false;
			else  $$.value.fval=true;
		}
	;


STM:
       
	S {$$=$1;print = true;}
	|PRINT STM      {$$=$2;print_var=$2;print= true;}
	|ID EGALE STM   {   
	                ident = true;
	              
			  tab.code.type = $3.type;
			  switch(tab.code.type){
			       case 1: tab.code.value.ival = $3.value.ival;
			       case 2: tab.code.value.fval = $3.value.fval;
			  }
			  strcpy(tab.token,$1.value.sval);
		       }
	|IF G THEN STM %prec IFX      { if($2.value.ival == true) {
				              $$ = $4;		
			                }
			                else{if(ident) ident = false;if(print) print = false;  } 
			              }
	|IF G THEN STM ELSE STM {if ($2.value.ival == true) {
				       $$ = $4;
			             }else $$=$6;}
       ;
S:
	FLOAT {$$ = $1;}
	|ID            {$$ = exists($1);print = true;}
	|INT {$$ = $1;}
	|S PLUS S { if ($1.type == INT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = INT_TYPE;
		      $$.value.ival = $1.value.ival + $3.value.ival;
		   }
		   else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.ival + $3.value.fval;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval + $3.value.ival;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval + $3.value.fval;
		   }
	       }
	 |S MOINS S { if ($1.type == INT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = INT_TYPE;
		      $$.value.ival = $1.value.ival - $3.value.ival;
		   }
		   else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.ival - $3.value.fval;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval - $3.value.ival;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval - $3.value.fval;
		   }
	 }
	|S FOIS S { if ($1.type == INT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = INT_TYPE;
		      $$.value.ival = $1.value.ival * $3.value.ival;
		   }
		   else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.ival * $3.value.fval;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval * $3.value.ival;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE)
		   { 
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval * $3.value.fval;
		   }
	 }
	|S DIVISE S { if ($1.type == INT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = INT_TYPE;
		      $$.value.ival = $1.value.ival / $3.value.ival;
		   }
		   else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.ival / $3.value.fval;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval / $3.value.ival;
		   }
		    else if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE)
		   {
		      $$.type = FLOAT_TYPE; 
		      $$.value.fval = $1.value.fval / $3.value.fval;
		   }
	 }
	|MOINS S %prec NEG {if ($2.type == INT_TYPE)
			   {
			      $$.type = INT_TYPE;
			      $$.value.ival = -$2.value.ival;
			   }
			  else{
			      $$.type = FLOAT_TYPE;
			      $$.value.fval = -1 * $2.value.fval;
				}
		}	
	|S PUISSANCE S {if ($1.type == FLOAT_TYPE && $3.type == FLOAT_TYPE) {
			      $$.type = FLOAT_TYPE;
			      $$.value.fval = pow($1.value.fval,$3.value.fval);	
			}
			else if ($1.type == INT_TYPE && $3.type == FLOAT_TYPE) {
			      $$.type = FLOAT_TYPE;
			      $$.value.fval = pow($1.value.ival,$3.value.fval);	
			}
			else if ($1.type == FLOAT_TYPE && $3.type == INT_TYPE) {
			      $$.type = FLOAT_TYPE;
			      $$.value.fval = pow($1.value.fval,$3.value.ival);	
			}
			else {
			      $$.type = INT_TYPE;
			      $$.value.ival = pow($1.value.ival,$3.value.ival);			
			}
			}
	|PARENTHESE_GAUCHE S PARENTHESE_DROITE {if ($2.type == INT_TYPE)
			   {
			      $$.type = INT_TYPE;
			      $$.value.ival = $2.value.ival;
			   }
			  else{
			      $$.type = FLOAT_TYPE;
			      $$.value.fval = $2.value.fval;
			  }}
	;

%%

struct vals exists(struct vals var1){
	struct vals s;
	int i;
	for(i=0;i<count;i++)
	{
	  if(!strcmp(var1.value.sval,table[i].token))
	  {
	    switch(table[i].code.type)
		    {
			case INT_TYPE :{
				      	 s.value.ival=table[i].code.value.ival;
					 s.type=INT_TYPE;break;}
			case FLOAT_TYPE :{
					   s.value.fval=table[i].code.value.fval;
					   s.type=FLOAT_TYPE;break;}
		    }
	     return s;
	     
	     
	  }
	}
	s.type =-1;
	printf("%s has no type\n",var1.value.sval);
	return s;
}

int yyerror(char *s){
	printf("%s :(\n",s);
}

int main(){
	yyparse();
}
	
