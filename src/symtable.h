#ifndef SYMTABLE_H
#define SYMTABLE_H
 
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
 
#define MAX_TABLES 256
 
static char *table_names[MAX_TABLES];
static int  table_count = 0;
 
static int table_exists(const char *name)
{
    for (int i = 0; i < table_count; i++) {
        if (strcmp(table_names[i], name) == 0)
            return 1;
    }
    return 0;
}
 
static void add_table(const char *name)
{
    if (table_count >= MAX_TABLES) {
        fprintf(stderr, "Symbol table full!\n");
        exit(1);
    }
    table_names[table_count++] = strdup(name);
}
 
#endif 
