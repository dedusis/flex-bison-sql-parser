#ifndef SYMTABLE_H
#define SYMTABLE_H
 
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
 
#define MAX_TABLES   256
#define MAX_COLUMNS  256
#define MAX_PENDING  256
 
typedef struct {
    char *name;
    char *columns[MAX_COLUMNS];
    int   col_count;
} TableEntry;
 
static TableEntry tables[MAX_TABLES];
static int        table_count = 0;

static int current_table_idx = -1;

typedef struct {
    char *name;
    int   line;
} PendingCol;
 
static PendingCol pending_cols[MAX_PENDING];
static int        pending_count = 0;
 
static int table_exists(const char *name)
{
    for (int i = 0; i < table_count; i++)
        if (strcmp(tables[i].name, name) == 0)
            return 1;
    return 0;
}
 
static int get_table_idx(const char *name)
{
    for (int i = 0; i < table_count; i++)
        if (strcmp(tables[i].name, name) == 0)
            return i;
    return -1;
}
 
static void add_table(const char *name)
{
    if (table_count >= MAX_TABLES) {
        fprintf(stderr, "Symbol table full!\n");
        exit(1);
    }
    tables[table_count].name      = strdup(name);
    tables[table_count].col_count = 0;
    current_table_idx             = table_count;
    table_count++;
}
 
static int column_exists_in_current(const char *col)
{
    if (current_table_idx < 0) return 0;
    TableEntry *t = &tables[current_table_idx];
    for (int i = 0; i < t->col_count; i++)
        if (strcmp(t->columns[i], col) == 0)
            return 1;
    return 0;
}
 
static void add_column_to_current(const char *col)
{
    if (current_table_idx < 0) return;
    TableEntry *t = &tables[current_table_idx];
    if (t->col_count >= MAX_COLUMNS) {
        fprintf(stderr, "Too many columns!\n");
        exit(1);
    }
    t->columns[t->col_count++] = strdup(col);
}
 
static int column_exists_in_table(const char *table_name, const char *col)
{
    int idx = get_table_idx(table_name);
    if (idx < 0) return 0;
    TableEntry *t = &tables[idx];
    for (int i = 0; i < t->col_count; i++)
        if (strcmp(t->columns[i], col) == 0)
            return 1;
    return 0;
}
  
static void add_pending_col(const char *name, int line)
{
    if (pending_count >= MAX_PENDING) {
        fprintf(stderr, "Too many pending columns!\n");
        exit(1);
    }
    pending_cols[pending_count].name = strdup(name);
    pending_cols[pending_count].line = line;
    pending_count++;
}
 
static void clear_pending_cols(void)
{
    for (int i = 0; i < pending_count; i++)
        free(pending_cols[i].name);
    pending_count = 0;
}
 
static void check_pending_cols(const char *table_name)
{
    for (int i = 0; i < pending_count; i++) {
        if (!column_exists_in_table(table_name, pending_cols[i].name)) {
            printf("\n\nSemantic Error at line %d: Column '%s' does not exist in table '%s'.\n",
                   pending_cols[i].line, pending_cols[i].name, table_name);
            exit(1);
        }
    }
    clear_pending_cols();
}
 
#endif 
