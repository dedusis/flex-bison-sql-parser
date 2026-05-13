/* C code poy antigrafetai sto generated C file */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.tab.h"     /* token definations from bison */

extern int error_found;
%}

/* avoid linker errors */
%option noyywrap

/* enable line counting */
%option yylineno

%option caseless

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INTNUM      -?[0-9]+
FLOATNUM    -?[0-9]+"."[0-9]+
STRING      \'[^\']*\'

%%

[ \t\r\n]+ {
    printf("%s", yytext);
}

"--".*                     ;

[/][*]([^*]|[*][^/])*[*][/]      ;

"SELECT" {
    printf("%s", yytext);
    return SELECT;
}

"FROM" {
    printf("%s", yytext);
    return FROM;
}

"WHERE" {
    printf("%s", yytext);
    return WHERE;
}

"GROUP" {
    printf("%s", yytext);
    return GROUP;
}

"BY" {
    printf("%s", yytext);
    return BY;
}

"ORDER" {
    printf("%s", yytext);
    return ORDER;
}

"LIMIT" {
    printf("%s", yytext);
    return LIMIT;
}

"CREATE" {
    printf("%s", yytext);
    return CREATE;
}

"TABLE" {
    printf("%s", yytext);
    return TABLE;
}

"INT" {
    printf("%s", yytext);
    return INT_TYPE;
}

"FLOAT" {
    printf("%s", yytext);
    return FLOAT_TYPE;
}

"VARCHAR" {
    printf("%s", yytext);
    return VARCHAR;
}

"AND" {
    printf("%s", yytext);
    return AND;
}

"OR" {
    printf("%s", yytext);
    return OR;
}

"NOT" {
    printf("%s", yytext);
    return NOT;
}

"IN" {
    printf("%s", yytext);
    return IN;
}

"=" {
    printf("%s", yytext);
    return EQ;
}

"!=" {
    printf("%s", yytext);
    return NEQ;
}

">=" {
    printf("%s", yytext);
    return GTE;
}

"<=" {
    printf("%s", yytext);
    return LTE;
}

">" {
    printf("%s", yytext);
    return GT;
}

"<" {
    printf("%s", yytext);
    return LT;
}

"(" {
    printf("%s", yytext);
    return LPAREN;
}

")" {
    printf("%s", yytext);
    return RPAREN;
}

"," {
    printf("%s", yytext);
    return COMMA;
}

";" {
    printf("%s", yytext);
    return SEMICOLON;
}

"*" {
    printf("%s", yytext);
    return STAR;
}

{FLOATNUM} {
    printf("%s", yytext);
    yylval.str = strdup(yytext);
    return FLOAT_LITERAL;
}

{INTNUM} {
    printf("%s", yytext);
    yylval.str = strdup(yytext);
    return INT_LITERAL;
}

{STRING} {
    printf("%s", yytext);
    yylval.str = strdup(yytext);
    return STRING_LITERAL;
}

{ID} {
    printf("%s", yytext);
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

. {
    printf("\nLexical Error at line %d: Unknown character '%s'\n",
            yylineno,
            yytext);
    exit(1);
}

%%