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

## Frequently used targets

* 1000010010 - Free proton
* 1000000010 - Free neutron
* 1000060120 - Carbon
* 1000080160 - Oxygen
* 1000180400 - Argon40
* 1000200400 - Calcium40
* 1000260560 - Iron
* 1000822080 - Lead
* 1000922380 - Uranium
