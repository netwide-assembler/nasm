***************
*** 29,42 ****
  #include <stdlib.h>
  #include <string.h>
  
  #include "rdoff.h"
  #include "symtab.h"
  #include "collectn.h"
  #include "rdlib.h"
  #include "segtab.h"
- #include "multboot.h"
  
- #define LDRDF_VERSION "1.01 alpha 2"
  
  #define RDF_MAXSEGS 64
  /* #define STINGY_MEMORY */
--- 29,42 ----
  #include <stdlib.h>
  #include <string.h>
  
+ #include "multboot.h"
  #include "rdoff.h"
  #include "symtab.h"
  #include "collectn.h"
  #include "rdlib.h"
  #include "segtab.h"
  
+ #define LDRDF_VERSION "1.02"
  
  #define RDF_MAXSEGS 64
  /* #define STINGY_MEMORY */
