#!/bin/bash

original_exit_code="${ret:-1}"

show_make_build_errors() {
	if grep -qr 'make\[[[:digit:]]\].*Error [[:digit:]]$' logs; then
		printf "\n====== Showing Make errors found in the log files ======";
		for file in $(grep -lr 'make\[[[:digit:]]\].*Error [[:digit:]]$' logs); do
			printf "\n====== Make errors from $file ======\n" ;
			grep -r -C10 'make\[[[:digit:]]\].*Error [[:digit:]]$' $file ;
		done
	fi
}

show_make_build_errors
exit $original_exit_code
