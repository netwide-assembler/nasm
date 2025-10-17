#!/usr/bin/python3

import subprocess
import argparse
import difflib
import filecmp
import fnmatch
import json
import sys
import re
import os

fmtr_class = argparse.ArgumentDefaultsHelpFormatter
parser = argparse.ArgumentParser(prog = 'nasm-t.py',
                                 formatter_class=fmtr_class)

parser.add_argument('-d', '--directory',
                    dest = 'dir', default = './travis/test',
                    help = 'Directory with tests')

parser.add_argument('--nasm',
                    dest = 'nasm', default = './nasm',
                    help = 'Nasm executable to use')

sp = parser.add_subparsers(dest = 'cmd')
for cmd in ['run']:
    spp = sp.add_parser(cmd, help = 'Run test cases')
    spp.add_argument('-t', '--test',
                     dest = 'test',
                     help = 'Run the selected test only',
                     required = False)
    spp.add_argument('--stop',
                     dest = 'stop', default = 'y',
                     help = 'Stop immediately on failure (default "y")',
                     required = False)

for cmd in ['new']:
    spp = sp.add_parser(cmd, help = 'Add a new test case')
    spp.add_argument('--description',
                     dest = 'description', default = "Description of a test",
                     help = 'Description of a test',
                     required = False)
    spp.add_argument('--id',
                     dest = 'id',
                     help = 'Test identifier/name',
                     required = True)
    spp.add_argument('--format',
                     dest = 'format', default = 'bin',
                     help = 'Output format',
                     required = False)
    spp.add_argument('--source',
                     dest = 'source',
                     help = 'Source file',
                     required = False)
    spp.add_argument('--option',
                     dest = 'option',
                     default = '-Ox',
                     help = 'NASM options',
                     required = False)
    spp.add_argument('--ref',
                     dest = 'ref',
                     help = 'Test reference',
                     required = False)
    spp.add_argument('--error',
                     dest = 'error',
                     help = '"y" if test is supposed to fail or "i" to ignore',
                     required = False)
    spp.add_argument('--output',
                     dest = 'output', default = 'y',
                     help = 'Output (compiled) file name (or "y")',
                     required = False)
    spp.add_argument('--stdout',
                     dest = 'stdout', default = 'y',
                     help = 'Filename of stdout file (or "y")',
                     required = False)
    spp.add_argument('--stderr',
                     dest = 'stderr', default = 'y',
                     help = 'Filename of stderr file (or "y")',
                     required = False)

for cmd in ['list']:
    spp = sp.add_parser(cmd, help = 'List test cases')

for cmd in ['update']:
    spp = sp.add_parser(cmd, help = 'Update test cases with new compiler')
    spp.add_argument('-t', '--test',
                     dest = 'test',
                     help = 'Update the selected test only',
                     required = False)

map_fmt_ext = {
        'bin':      '.bin',
        'elf':      '.o',
        'elf64':    '.o',
        'elf32':    '.o',
        'elfx32':   '.o',
        'ith':      '.ith',
        'srec':     '.srec',
        'obj':      '.obj',
        'win32':    '.obj',
        'win64':    '.obj',
        'coff':     '.obj',
        'macho':    '.o',
        'macho32':  '.o',
        'macho64':  '.o',
        'aout':     '.out',
        'aoutb':    '.out',
        'as86':     '.o',
        'rdf':      '.rdf',
}

args = parser.parse_args()

if args.cmd == None:
    parser.print_help()
    sys.exit(64)

def read_stdfile(path):
    with open(path, "rb") as f:
        data = f.read().decode("utf-8","replace")
        f.close()
        return data

#
# Check if descriptor has mandatory fields
def is_valid_desc(desc):
    if desc == None:
        return False
    if 'description' not in desc:
        return False
    if desc['description'] == "":
        return False
    return True

#
# Expand ref/id in descriptors array
def expand_templates(desc_array):
    desc_ids = { }
    for d in desc_array:
        if 'id' in d:
            desc_ids[d['id']] = d
    for i, d in enumerate(desc_array):
        if 'ref' in d and d['ref'] in desc_ids:
            ref = desc_ids[d['ref']]
            own = d.copy()
            desc_array[i] = ref.copy()
            for k, v in own.items():
                desc_array[i][k] = v
            del desc_array[i]['id']
        desc_array[i]['_seq'] = '.%d' % (i+1)
    return desc_array

def prepare_desc(desc, basedir, name, path):
    if not is_valid_desc(desc):
        return False
    #
    # Put private fields
    desc['_base-dir'] = basedir
    desc['_json-file'] = name
    desc['_json-path'] = path
    if not '_seq' in desc:
        desc['_seq'] = ''
    desc['_test-name'] = basedir + os.sep + name[:-5] + desc['_seq']

    #
    # If no target provided never update
    if 'target' not in desc:
        desc['target'] = []
        desc['update'] = 'false'
    #
    # Which code to expect when nasm finishes
    desc['_wait'] = 0
    if 'error' in desc:
        if desc['error'] == 'expected':
            desc['_wait'] = 1
    #
    # Walk over targets and generate match templates
    # if were not provided yet
    for d in desc['target']:
        if 'output' in d and not 'match' in d:
            d['match'] = d['output'] + ".t"
    return True

def read_json(path):
    desc = None
    try:
        with open(path, "rb") as f:
            try:
                desc = json.loads(f.read().decode("utf-8","replace"))
            except:
                desc = None
            finally:
                f.close()
    except:
        pass
    return desc

def read_desc(basedir, name):
    path = basedir + os.sep + name
    desc = read_json(path)
    desc_array = []
    if type(desc) == dict:
        if prepare_desc(desc, basedir, name, path) == True:
            desc_array += [desc]
    elif type(desc) == list:
        expand_templates(desc)
        for de in desc:
            if prepare_desc(de, basedir, name, path) == True:
                desc_array += [de]
    return desc_array

def collect_test_desc_from_file(path):
    if not fnmatch.fnmatch(path, '*.json'):
        path += '.json'
    basedir = os.path.dirname(path)
    filename = os.path.basename(path)
    return read_desc(basedir, filename)

def collect_test_desc_from_dir(basedir):
    desc_array = []
    if os.path.isdir(basedir):
        for filename in os.listdir(basedir):
            if os.path.isdir(basedir + os.sep + filename):
                desc_array += collect_test_desc_from_dir(basedir + os.sep + filename)
            elif fnmatch.fnmatch(filename, '*.json'):
                desc = read_desc(basedir, filename)
                if desc == None:
                    continue
                desc_array += desc
        desc_array.sort(key=lambda x: x['_test-name'])
    return desc_array

if args.cmd == 'list':
    fmt_entry = '%-32s %s'
    desc_array = collect_test_desc_from_dir(args.dir)
    print(fmt_entry % ('Name', 'Description'))
    for desc in desc_array:
        print(fmt_entry % (desc['_test-name'], desc['description']))

def test_abort(test, message):
    print("\t%s: %s" % (test, message))
    print("=== Test %s ABORT ===" % (test))
    sys.exit(2)
    return False

def test_fail(test, message):
    print("\t%s: %s" % (test, message))
    print("=== Test %s FAIL ===" % (test))
    return False

def test_skip(test, message):
    print("\t%s: %s" % (test, message))
    print("=== Test %s SKIP ===" % (test))
    return True

def test_over(test):
    print("=== Test %s ERROR OVER ===" % (test))
    return True

def test_pass(test):
    print("=== Test %s PASS ===" % (test))
    return True

def test_updated(test):
    print("=== Test %s UPDATED ===" % (test))
    return True

def hexdump(path):
    dump = ''
    addr = 0
    with open(path, 'rb') as f:
        while b := f.read(16):
            dump += "%08x  " % (addr)
            for i in range(16):
                if (i == 8):
                    dump += " -"
                if (i >= len(b)):
                    dump += "   "
                else:
                    dump += " %02x" % b[i]
            dump += "  |"
            for i in range(16):
                if (i >= len(b)):
                    c = ord(' ')
                else:
                    c = b[i]
                if (c < 32 or c > 126):
                    c = ord('.')
                dump += chr(c)
            dump += "|\n";
            addr += 16
    return dump

def show_std(stdname, data):
    print("\t--- %s" % (stdname))
    for i in data.split("\n"):
        print("\t%s" % i)
    print("\t---")

def cmp_std(from_name, from_data, match_name, match_data):
    if from_data != match_data:
        print("\t--- %s" % (from_name))
        for i in from_data.split("\n"):
            print("\t%s" % i)
        print("\t--- %s" % (match_name))
        for i in match_data.split("\n"):
            print("\t%s" % i)

        diff = difflib.unified_diff(from_data.split("\n"), match_data.split("\n"),
                                    fromfile = from_name, tofile = match_name)
        for i in diff:
            print("\t%s" % i.strip("\n"))
        print("\t---")
        return False
    return True

def show_diff(test, patha, pathb):
    try:
        sa = hexdump(patha)
        sb = hexdump(pathb)
    except OSError:
        return test_fail(test, "Can't create dumps")

    print("\t--- hexdump %s" % (patha))
    for i in sa.split("\n"):
        print("\t%s" % i)
    print("\t--- hexdump %s" % (pathb))
    for i in sb.split("\n"):
        print("\t%s" % i)

    diff = difflib.unified_diff(sa.split("\n"), sb.split("\n"),
                                fromfile = patha, tofile = pathb)
    for i in diff:
        print("\t%s" % i.strip("\n"))
    print("\t---")
    return True

def prepare_run_opts(desc):
    opts = []

    if 'format' in desc:
        opts += ['-f', desc['format']]
    if 'option' in desc:
        opts += desc['option'].split(" ")
    outfile = desc['_test-name'] + '.out'
    for t in desc['target']:
        if 'output' in t:
            outfile = desc['_base-dir'] + os.sep + t['output']
        if 'option' in t:
            opts += t['option'].split(" ")
    opts += ['-o', outfile, '-L+', '-l', outfile + '.lst']
    if 'source' in desc:
        opts += [desc['_base-dir'] + os.sep + desc['source']]

    return opts

def exec_nasm(desc):
    print("\tProcessing %s" % (desc['_test-name']))
    opts = [args.nasm] + prepare_run_opts(desc)

    nasm_env = os.environ.copy()
    nasm_env['NASMENV'] = '--reproducible'

    desc_env = desc.get('environ')
    if desc_env:
        for i in desc_env:
            v = i.split('=')
            if len(v) == 2:
                nasm_env[v[0]] = v[1]
            else:
                nasm_env[v[0]] = None

    print("\tExecuting %s" % (" ".join(opts)))
    pnasm = subprocess.Popen(opts,
                             stdout = subprocess.PIPE,
                             stderr = subprocess.PIPE,
                             close_fds = True,
                             env = nasm_env)
    if pnasm == None:
        test_fail(desc['_test-name'], "Unable to execute test")
        return None

    #
    # FIXME: For now 4M buffer is enough but
    # better provide reading in a cycle.
    stderr = pnasm.stderr.read(4194304).decode("utf-8","replace")
    stdout = pnasm.stdout.read(4194304).decode("utf-8","replace")

    pnasm.stdout.close()
    pnasm.stderr.close()

    wait_rc = pnasm.wait();

    if desc['_wait'] != wait_rc:
        if stdout != "":
            show_std("stdout", stdout)
        if stderr != "":
            show_std("stderr", stderr)
        test_fail(desc['_test-name'],
                  "Unexpected ret code: " + str(wait_rc))
        return None, None, None
    return pnasm, stdout, stderr

def test_run(desc):
    print("=== Running %s ===" % (desc['_test-name']))

    if 'disable' in desc:
        return test_skip(desc['_test-name'], desc["disable"])

    pnasm, stdout, stderr = exec_nasm(desc)
    if pnasm == None:
        return False

    for t in desc['target']:
        f = None
        if 'filter' in t:
            f = t['filter']
            f_pat = re.compile(f['match'], re.M)
            f_sub = f['subst']

        if 'output' in t:
            output = desc['_base-dir'] + os.sep + t['output']
            match = desc['_base-dir'] + os.sep + t['match']
            if desc['_wait'] == 1:
                continue
            print("\tComparing %s %s" % (output, match))
            if filecmp.cmp(match, output) == False:
                show_diff(desc['_test-name'], match, output)
                return test_fail(desc['_test-name'], match + " and " + output + " files are different")
        elif 'stdout' in t:
            print("\tComparing stdout")
            match = desc['_base-dir'] + os.sep + t['stdout']
            match_data = read_stdfile(match)
            if match_data == None:
                return test_fail(test, "Can't read " + match)
            out_data = stdout
            if f:
                out_data = f_pat.sub(f_sub, out_data, 0)
            if cmp_std(match, match_data, 'stdout', out_data) == False:
                return test_fail(desc['_test-name'], "stdout mismatch")
            else:
                stdout = ""
        elif 'stderr' in t:
            print("\tComparing stderr")
            match = desc['_base-dir'] + os.sep + t['stderr']
            match_data = read_stdfile(match)
            if match_data == None:
                return test_fail(test, "Can't read " + match)
            out_data = stderr
            if f:
                out_data = f_pat.sub(f_sub, out_data, 0)
            if cmp_std(match, match_data, 'stderr', out_data) == False:
                return test_fail(desc['_test-name'], "stderr mismatch")
            else:
                stderr = ""

    if stdout != "":
        show_std("stdout", stdout)
        return test_fail(desc['_test-name'], "stdout is not empty")

    if stderr != "":
        show_std("stderr", stderr)
        return test_fail(desc['_test-name'], "stderr is not empty")

    return test_pass(desc['_test-name'])

#
# Compile sources and generate new targets
def test_update(desc):
    print("=== Updating %s ===" % (desc['_test-name']))

    if 'update' in desc and desc['update'] == 'false':
        return test_skip(desc['_test-name'], "No output provided")
    if 'disable' in desc:
        return test_skip(desc['_test-name'], desc["disable"])

    pnasm, stdout, stderr = exec_nasm(desc)
    if pnasm == None:
        return False

    for t in desc['target']:
        if 'output' in t:
            output = desc['_base-dir'] + os.sep + t['output']
            match = desc['_base-dir'] + os.sep + t['match']
            print("\tMoving %s to %s" % (output, match))
            os.rename(output, match)
        if 'stdout' in t:
            match = desc['_base-dir'] + os.sep + t['stdout']
            print("\tMoving %s to %s" % ('stdout', match))
            with open(match, "wb") as f:
                f.write(stdout.encode("utf-8"))
                f.close()
        if 'stderr' in t:
            match = desc['_base-dir'] + os.sep + t['stderr']
            print("\tMoving %s to %s" % ('stderr', match))
            with open(match, "wb") as f:
                f.write(stderr.encode("utf-8"))
                f.close()

    return test_updated(desc['_test-name'])

#
# Create a new empty test case
if args.cmd == 'new':
    #
    # If no source provided create one
    # from (ID which is required)
    if not args.source:
        args.source = args.id + ".asm"

    #
    # Emulate "touch" on source file
    path_asm = args.dir + os.sep + args.source
    print("\tCreating %s" % (path_asm))
    open(path_asm, 'a').close()

    #
    # Fill the test descriptor
    #
    # FIXME: We should probably use Jinja
    path_json = args.dir + os.sep + args.id + ".json"
    print("\tFilling descriptor %s" % (path_json))
    with open(path_json, 'wb') as f:
        f.write("[\n\t{\n".encode("utf-8"))
        acc = []
        if args.description:
            acc.append("\t\t\"description\": \"{}\"".format(args.description))
        acc.append("\t\t\"id\": \"{}\"".format(args.id))
        if args.format:
            acc.append("\t\t\"format\": \"{}\"".format(args.format))
        acc.append("\t\t\"source\": \"{}\"".format(args.source))
        if args.option:
            acc.append("\t\t\"option\": \"{}\"".format(args.option))
        if args.ref:
            acc.append("\t\t\"ref\": \"{}\"".format(args.ref))
        if args.error == 'y':
            acc.append("\t\t\"error\": \"expected\"")
        elif args.error == 'i':
            acc.append("\t\t\"error\": \"over\"")
        f.write(",\n".join(acc).encode("utf-8"))
        if args.output or args.stdout or args.stderr:
            acc = []
            if args.output:
                if args.output == 'y':
                    if args.format in map_fmt_ext:
                        args.output = args.id + map_fmt_ext[args.format]
                acc.append("\t\t\t{{ \"output\": \"{}\" }}".format(args.output))
            if args.stdout:
                if args.stdout == 'y':
                    args.stdout = args.id + '.stdout'
                acc.append("\t\t\t{{ \"stdout\": \"{}\" }}".format(args.stdout))
            if args.stderr:
                if args.stderr == 'y':
                    args.stderr = args.id + '.stderr'
                acc.append("\t\t\t{{ \"stderr\": \"{}\" }}".format(args.stderr))
            f.write(",\n".encode("utf-8"))
            f.write("\t\t\"target\": [\n".encode("utf-8"))
            f.write(",\n".join(acc).encode("utf-8"))
            f.write("\n\t\t]".encode("utf-8"))
        f.write("\n\t}\n]\n".encode("utf-8"))
        f.close()

if args.cmd == 'run':
    errors = 0
    desc_array = []
    if args.test == None:
        desc_array = collect_test_desc_from_dir(args.dir)
    else:
        desc_array = collect_test_desc_from_file(args.test)
        if len(desc_array) == 0:
            test_abort(args.test, "Can't obtain test descriptors")

    for desc in desc_array:
        if test_run(desc) == False:
            errors = 1;
            if 'error' in desc and desc['error'] == 'over':
                test_over(desc['_test-name'])
            else:
                errors = 1
                if args.stop == 'y':
                    test_abort(desc['_test-name'], "Error detected")
    sys.exit(errors)

if args.cmd == 'update':
    desc_array = []
    if args.test == None:
        desc_array = collect_test_desc_from_dir(args.dir)
    else:
        desc_array = collect_test_desc_from_file(args.test)
        if len(desc_array) == 0:
            test_abort(args.test, "Can't obtain a test descriptors")

    for desc in desc_array:
        if test_update(desc) == False:
            if 'error' in desc and desc['error'] == 'over':
                test_over(desc['_test-name'])
            else:
                test_abort(desc['_test-name'], "Error detected")
