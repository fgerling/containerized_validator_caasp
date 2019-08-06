#!/bin/bash

SCRIPT="/home/kravciak/git/validators/mkravec/openqa-modules-cleanup";
TESTS="/home/kravciak/git/openqa-tests";
cd $TESTS

# List modules that might be obsolete
# Find all modules that are not in main.pm, main_common or variables
MODULES=$(find tests -iname "*.pm")
for m in $MODULES; do
	bn=${m##*/}
	fn=${bn%.*}

	# Keep modules mentioned in main-pms
	grep -q $fn products/*/main.pm lib/main_common.pm && continue
	
	# Keep modules mentioned in openqa variables
	grep -q $fn $SCRIPT/vars-* && continue

	# Keep modules referenced in SLE-11 & YaST branches main.pm
	grep -q $fn $SCRIPT/main-* && continue
	
	# Output module name followed by it's usade in other places
	echo "#======== $m"
	grep --exclude-dir='.git' --exclude="$bn" --exclude="CLEANUP_MODULES" -rI $fn $TD
done

exit 0

# List variables that might be obsolete
# Find all check_var get_var that are not set_var or in variable defined by worker/rsync.pl/webui
VARIABLES=$(grep --exclude-dir='.git' -Ehro "(check|get)_var[\(\ ][\"\'][^\"\']*[\"\']" | tr \' \" | cut -d\" -f 2 | sort -u)
for v in $VARIABLES; do
	# Skip if variable will be expanded
	[[ "$v" =~ "\$" ]] && continue

	# Skip if variable was set in set_var
	grep --exclude-dir='.git' -Ehrq "set_var[\(\ ][\"\']$v[\"\']" && continue

	# Skip if variable is set in openqa web ui
	grep -q $v $SCRIPT/vars-* && continue

	echo $v
done
