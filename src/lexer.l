%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
extern int error_found;
%}

%option noyywrap
%option yylineno

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          [a-zA-Z_][a-zA-Z0-9_]*
INTNUM      [0-9]+
FLOATNUM    [0-9]+"."[0-9]+
STRING      \'[^\']*\'

%%

[ \t\r\n]+ {
    printf("%s", yytext);
}

"--"[^\n]*                          { /* single-line comment - skip */ }
"/*"([^*]|\*[^/])*"*/"             { /* multi-line comment - skip */ }

[sS][eE][lL][eE][cC][tT]           { printf("%s", yytext); return SELECT; }
[fF][rR][oO][mM]                    { printf("%s", yytext); return FROM; }
[wW][hH][eE][rR][eE]               { printf("%s", yytext); return WHERE; }
[gG][rR][oO][uU][pP]               { printf("%s", yytext); return GROUP; }
[oO][rR][dD][eE][rR]               { printf("%s", yytext); return ORDER; }
[bB][yY]                            { printf("%s", yytext); return BY; }
[lL][iI][mM][iI][tT]               { printf("%s", yytext); return LIMIT; }
[cC][rR][eE][aA][tT][eE]           { printf("%s", yytext); return CREATE; }
[tT][aA][bB][lL][eE]               { printf("%s", yytext); return TABLE; }
[iI][nN][tT]                        { printf("%s", yytext); return INT_TYPE; }
[fF][lL][oO][aA][tT]               { printf("%s", yytext); return FLOAT_TYPE; }
[vV][aA][rR][cC][hH][aA][rR]       { printf("%s", yytext); return VARCHAR; }
[aA][nN][dD]                        { printf("%s", yytext); return AND; }
[oO][rR]                            { printf("%s", yytext); return OR; }
[nN][oO][tT]                        { printf("%s", yytext); return NOT; }
[iI][nN]                            { printf("%s", yytext); return IN; }

"="     { printf("%s", yytext); return EQ; }
"!="    { printf("%s", yytext); return NEQ; }
">="    { printf("%s", yytext); return GTE; }
"<="    { printf("%s", yytext); return LTE; }
">"     { printf("%s", yytext); return GT; }
"<"     { printf("%s", yytext); return LT; }
"-"     { printf("%s", yytext); return MINUS; }

"("     { printf("%s", yytext); return LPAREN; }
")"     { printf("%s", yytext); return RPAREN; }
","     { printf("%s", yytext); return COMMA; }
";"     { printf("%s", yytext); return SEMICOLON; }
"*"     { printf("%s", yytext); return STAR; }

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
           yylineno, yytext);
    exit(1);
}

%%
