#ifndef NASM_QUOTE_H
#define NASM_QUOTE_H

#include "compiler.h"

char *nasm_quote(char *str, size_t len);
size_t nasm_unquote(char *str, char **endptr);
char *nasm_skip_string(char *str);

#endif /* NASM_QUOTE_H */

