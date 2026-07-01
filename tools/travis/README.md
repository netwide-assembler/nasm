Testing NASM
============
We use [Travis CI](https://travis-ci.org/) service to execute NASM tests,
which basically prepares the environment and runs our `nasm-t.py` script.

The script scans a testing directory for `*.json` test descriptor files
and runs test by descriptor content.

Test engine
-----------
`nasm-t.py` script is a simple test engine written by Python3 language
which allows either execute a single test or run them all in a sequence.

A typical test case processed by the following steps:

 - a test descriptor get parsed to figure out which arguments
   are to be provided into the NASM command line;
 - invoke the NASM with arguments;
 - compare generated files with precompiled templates.

`nasm-t.py` supports the following commands:

 - `list`: to list all test cases
 - `run`: to run test cases
 - `update`: to update precompiled templates

Use `nasm-t.py -h` command to get the detailed description of every option.

### Test unit structure
Each test consists at least of three files:

 - a test descriptor in with `*.json` extension;
 - a source file to compile;
 - a target file to compare result with, it is assumed to have
   the same name as output generated during the pass file but with `*.t`
   extension; thus if a test generates `*.bin` file the appropriate target
   should have `*.bin.t` name.

Running tests
-------------
To run all currently available tests simply type the following

```console
python3 tools/travis/nasm-t.py run
```

By default the `nasm-t.py` scans the `travis` directory (relative to the
current working directory, which must be the top of the NASM source tree)
recursively for `*.json` files and considers each as a test descriptor.
Every test case lives in its own subdirectory of `travis/` alongside its
source file(s) and precompiled reference/target files; the harness itself
(`nasm-t.py`, this file, and the `t.json` template) lives in `tools/travis/`
so it doesn't add another level of nesting under `travis/`. Then every test
is executed sequentially. If the descriptor can not be parsed it is
silently ignored.

To run a particular test provide the test name, for example

```console
python3 tools/travis/nasm-t.py list
...
./travis/utf/utf                Test __utf__ helpers
./travis/utf/utf                Test errors in __utf__ helpers
...
python3 tools/travis/nasm-t.py run -t ./travis/utf/utf
```

Test name duplicates in the listing above means that the descriptor
carries several tests with same name but different options.

Test descriptor file
--------------------
A descriptor file should provide enough information how to run the NASM
itself and which output files or streams to compare with predefined ones.
We use *JSON* format with the following fields:

 - `description`: a short description of a test which is shown to
   a user when tests are being listed;
 - `id`: descriptor internal name to use with `ref` field;
 - `ref`: a reference to `id` from where settings should be
   copied, it is convenient when say only `option` is different
   while the rest of the fields are the same;
 - `format`: NASM output format to use (`bin`,`elf` and etc);
 - `source`: is a source file name to compile, this file must
   be shipped together with descriptor file itself;
 - `option`: an additional option passed to the command line;
 - `update`: a trigger to skip updating targets when running
   an update procedure;
 - `target`: an array of targets which the test engine should
   check once compilation finished:
    - `stderr`: a file containing *stderr* stream output to check;
    - `stdout`: a file containing *stdout* stream output to check;
    - `output`: a file containing compiled result to check, in other
      words it is a name passed as `-o` option to the compiler;
 - `error`: an error handler, can be either *over* to ignore any
   error happened, or *expected* to make sure the test is failing.

### Examples
A simple test where no additional options are used, simply compile
`absolute.asm` file with `bin` format for output, then compare
produced `absolute.bin` file with precompiled `absolute.bin.t`.

```json
{
	"description": "Check absolute addressing",
	"format": "bin",
	"source": "absolute.asm",
	"target": [
		{ "output": "absolute.bin" }
	]
}
```

Note the `output` target is named as *absolute.bin* where *absolute.bin.t*
should be already precompiled (we will talk about it in `update` action)
and present on disk.

A slightly complex example: compile one source file with different optimization
options and all results must be the same. To not write three descriptors
we assign `id` to the first one and use `ref` term to copy settings.
Also, it is expected that `stderr` stream will not be empty but carry some
warnings to compare.

```json
[
	{
		"description": "Check 64-bit addressing (-Ox)",
		"id": "addr64x",
		"format": "bin",
		"source": "addr64x.asm",
		"option": "-Ox",
		"target": [
			{ "output": "addr64x.bin" },
			{ "stderr": "addr64x.stderr" }
		]
	},
	{
		"description": "Check 64-bit addressing (-O1)",
		"ref": "addr64x",
		"option": "-O1",
		"update": "false"
	},
	{
		"description": "Check 64-bit addressing (-O0)",
		"ref": "addr64x",
		"option": "-O0",
		"update": "false"
	}
]
```

Updating tests
--------------
If during development some of the targets are expected to change
the tests will start to fail so the should be updated. Thus new
precompiled results will be treated as templates to compare with.

To update all tests in one pass run

```console
python3 tools/travis/nasm-t.py update
...
=== Updating ./travis/xcrypt/xcrypt ===
	Processing ./travis/xcrypt/xcrypt
	Executing ./nasm -f bin -o ./travis/xcrypt/xcrypt.bin ./travis/xcrypt/xcrypt.asm
	Moving ./travis/xcrypt/xcrypt.bin to ./travis/xcrypt/xcrypt.bin.t
=== Test ./travis/xcrypt/xcrypt UPDATED ===
...
```

and commit the results. To update a particular test provide its name
with `-t` option.

Large golden/reference files
-----------------------------
Some tests produce very large `output`/`match` files (e.g. object files
with thousands of sections). Committing those in full is unreasonable,
so a reference file may instead be stored `.xz`-compressed: if
`<match>.xz` exists (and `<match>` itself doesn't), `nasm-t.py`
transparently decompresses it for comparison, and `update` will
recompress the regenerated data back into `<match>.xz` instead of
writing a plaintext copy.

For files with a highly regular, fixed-stride internal structure (e.g.
repeated fixed-size section-header records), xz's delta filter can
shrink the result far more than a plain preset -- but only if tuned to
the right byte distance for that file's record size; guessing wrong
(or always using the same fixed distance) can produce a compressed
file several times larger than optimal. To make this reproducible,
record the tuned distance in the target's `.json` entry:

```json
{
	"output": "mostsecs.o",
	"match": "mostsecs.o.t",
	"compress": { "delta": 192 }
}
```

`update` will then always use exactly that filter (fast, deterministic)
instead of re-guessing. If `compress` is omitted, `update` falls back to
trying a plain preset vs. a `dist=256` delta guess and keeps whichever
is smaller -- adequate for a first pass, but you should measure a few
candidate distances by hand (e.g. with a short Python script calling
`lzma.compress` with `FILTER_DELTA` at various `dist` values, 1-256) and
add the best one to the `.json` once a new oversized golden is added.
