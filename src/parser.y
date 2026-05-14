%{
#include <stdio.h>
#include <stdlib.h>
#include "symtable.h"
extern int yylex();
extern int yylineno;
void yyerror(const char *s);
int error_found = 0;
%}

%union {
    char* str;
}

%token SELECT FROM WHERE GROUP ORDER BY LIMIT
%token CREATE TABLE
%token INT_TYPE FLOAT_TYPE VARCHAR
%token AND OR NOT IN
%token EQ NEQ GT LT GTE LTE
%token MINUS
%token LPAREN RPAREN
%token COMMA SEMICOLON STAR
%token <str> IDENTIFIER
%token <str> INT_LITERAL
%token <str> FLOAT_LITERAL
%token <str> STRING_LITERAL

%left OR
%left AND
%right NOT

%%

program:
    statement_list
    ;

statement_list:
      statement
    | statement_list statement
    ;

statement:
      create_stmt SEMICOLON
    | select_stmt SEMICOLON
    ;

/* ============================================================
   CREATE TABLE
   ============================================================ */
create_stmt:
    CREATE TABLE IDENTIFIER
    {
        /* Έλεγχος 2a: το όνομα πίνακα πρέπει να είναι μοναδικό */
        if (table_exists($3)) {
            printf("\n\nSemantic Error at line %d: Table '%s' already exists.\n",
                   yylineno, $3);
            exit(1);
        }
        add_table($3);  /* θέτει και τον current_table_idx */
    }
    LPAREN column_def_list RPAREN
    ;

column_def_list:
      column_def
    | column_def_list COMMA column_def
    ;

column_def:
    IDENTIFIER
    {
        /* Έλεγχος 2c: το όνομα στήλης πρέπει να είναι μοναδικό μέσα στον πίνακα */
        if (column_exists_in_current($1)) {
            printf("\n\nSemantic Error at line %d: Column '%s' already exists in table '%s'.\n",
                   yylineno, $1, tables[current_table_idx].name);
            exit(1);
        }
        add_column_to_current($1);
    }
    data_type
    ;

data_type:
      INT_TYPE
    | FLOAT_TYPE
    | VARCHAR LPAREN INT_LITERAL RPAREN
    ;

/* ============================================================
   SELECT
   ============================================================ */
select_stmt:
    SELECT select_list
    FROM IDENTIFIER
    {
        /* Έλεγχος 2b: ο πίνακας στο FROM πρέπει να έχει οριστεί με CREATE */
        if (!table_exists($4)) {
            printf("\n\nSemantic Error at line %d: Table '%s' has not been defined.\n",
                   yylineno, $4);
            exit(1);
        }
    }
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
    |
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

/* ============================================================
   Conditions
   ============================================================ */
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
      EQ | NEQ | GT | LT | GTE | LTE
    ;

in_expression:
      IDENTIFIER IN LPAREN literal_list RPAREN
    | IDENTIFIER NOT IN LPAREN literal_list RPAREN
    ;

literal_list:
      literal
    | literal_list COMMA literal
    ;

literal:
      INT_LITERAL
    | MINUS INT_LITERAL
    | FLOAT_LITERAL
    | MINUS FLOAT_LITERAL
    | STRING_LITERAL
    ;

%%

void yyerror(const char *s)
{
    error_found = 1;
    printf("\n\nSyntax Error at line %d: %s\n", yylineno, s);
    exit(1);
}

int main(int argc, char **argv)
{
    extern FILE *yyin;

    if (argc != 2) {
        fprintf(stderr, "Usage: myParser file.sql\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Cannot open file: %s\n", argv[1]);
        return 1;
    }

    if (yyparse() == 0 && !error_found) {
        printf("\n\nInput is syntactically correct.\n");
    }

    fclose(yyin);
    return 0;
}
