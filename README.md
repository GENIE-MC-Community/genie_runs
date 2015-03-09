# GENIE Runs

This is a set of convenience scripts and `gdb` and `valgrind` configuration files
meant to make running GENIE more pleasant. There are also some "notes to self"
files containing frequently used commands, etc.

The main scripts are:

* `do_a_run.sh`: Run `gevgen` with a variety of flags and arguments (including
`--gdb`).
* `do_ghep_conversion.sh`: Convert GHEP record files to GSTs (and optionally to
ROOTracker format also).
* `do_make_spline.sh`: Run `gmkspl` with a variety of flags and arguments
(including `--gdb`).

Run any script with no arguments to get a help menu. `do_a_run.sh` and
`do_make_spline.sh` also support explicit help flags (`-h` or `--help`).
