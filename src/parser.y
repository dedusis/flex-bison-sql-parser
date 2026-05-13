%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();             /* dilonei oti h function yylex() yparxei sto lexer */
extern int yylineno;            /* krataei current line numbes gia errors */

void yyerror(const char *s);

int error_found = 0;
%}

%union {                        /* o parser metaferei values apo lexer se parser(metaferei kai to string px"user") */
    char* str;
}

%token SELECT FROM WHERE GROUP ORDER BY LIMIT
%token CREATE TABLE
%token INT_TYPE FLOAT_TYPE VARCHAR

%token AND OR NOT IN
%token EQ NEQ GT LT GTE LTE

%token LPAREN RPAREN
%token COMMA
%token SEMICOLON
%token STAR

%token <str> IDENTIFIER         /* to identifier exei string values */
%token <str> INT_LITERAL
%token <str> FLOAT_LITERAL
%token <str> STRING_LITERAL

%%                              /* grammar rules */

program:                        /* start symbol */
    statement_list
    ;

statement_list:                 /* epitrepei CREATE TABLE, SELECT... */
      statement
    | statement_list statement
    ;

statement:                      /* kathe statement teleiwnei me ; */
      create_stmt SEMICOLON
    | select_stmt SEMICOLON
    ;

create_stmt:
    CREATE TABLE IDENTIFIER
    LPAREN column_def_list RPAREN
    ;

column_def_list:                /* anagnorizei id int, name varchar... */
      column_def
    | column_def_list COMMA column_def
    ;

column_def:
    IDENTIFIER data_type
    ;

data_type:
      INT_TYPE
    | FLOAT_TYPE
    | VARCHAR LPAREN INT_LITERAL RPAREN
    ;

select_stmt:                    /* checks tin seira */
    SELECT select_list
    FROM IDENTIFIER
    where_clause
    group_clause
    order_clause
    limit_clause
    ;

select_list:
      STAR
    | identifier_list
    ;

identifier_list:
      IDENTIFIER
    | identifier_list COMMA IDENTIFIER
    ;

where_clause:
      WHERE condition
    |                   /* optional */
    ;

group_clause:
      GROUP BY identifier_list
    |
    ;

order_clause:
      ORDER BY identifier_list
    |
    ;

limit_clause:
      LIMIT INT_LITERAL
    |
    ;

condition:
      condition AND condition
    | condition OR condition
    | NOT condition
    | LPAREN condition RPAREN
    | comparison
    | in_expression
    ;

comparison:
    IDENTIFIER comparison_operator literal
    ;

comparison_operator:
      EQ
    | NEQ
    | GT
    | LT
    | GTE
    | LTE
    ;

in_expression:
      IDENTIFIER IN
      LPAREN literal_list RPAREN

    | IDENTIFIER NOT IN
      LPAREN literal_list RPAREN
    ;

literal_list:
      literal
    | literal_list COMMA literal
    ;

literal:
      INT_LITERAL
    | FLOAT_LITERAL
    | STRING_LITERAL
    ;

%%

void yyerror(const char *s)
{
    error_found = 1;

    printf("\n\nSyntax Error at line %d: %s\n",
           yylineno,
           s);

    exit(1);
}

int main(int argc, char **argv)
{
    extern FILE *yyin;

    if(argc != 2)
    {
        printf("Usage: myParser file.sql\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if(!yyin)
    {
        printf("Cannot open file %s\n", argv[1]);
        return 1;
    }

    if(yyparse() == 0)
    {
        printf("\n\nInput is syntactically correct.\n");
    }

    fclose(yyin);

    return 0;
}