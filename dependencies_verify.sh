#!/bin/bash
# simple script to verify if youw system already has the needed binary for express

# color used for printing
use_color=true;
if ($use_color) ;
then
	BLDWHI=$(tput bold ; tput setaf 3)
	BLDVIO=$(tput bold ; tput setaf 5)
	BLDCYA=$(tput bold ; tput setaf 6)
	BLDRED=$(tput bold ; tput setaf 1)
	BLDGRN=$(tput bold ; tput setaf 2)
	NOCOLR=$(tput sgr0)
fi

declare -a deps_not_ok
deps_not_ok=()
# checking system dependencies
declare -a sys_dependencies 
# define your system dependencies here
sys_dependencies=("node" "npm" "curl" "foobar" "foo" "bar")
for sys_dep in ${sys_dependencies[@]} 
do
	type -P $sys_dep &>/dev/null \
		&& { 
			DEP_OK="I need $sys_dep and it is correctly installed." ; 
			OK_MSG="OK - :)"; 
			TRM_COL=$(tput cols) ; DEP_COL_OK=${#DEP_OK} ; OK_MSG_COL=${#OK_MSG} ; 
			COL_OK=$(( $TRM_COL - $DEP_COL_OK - $OK_MSG_COL )) ; 
			sys_dep="${BLDCYA}${sys_dep}${NOCOLR}"
			DEP_OK="I need $sys_dep and it is correctly installed." ; 
			printf '%s%*s%s' "$DEP_OK" $COL_OK "[${BLDGRN}${OK_MSG}${NOCOLR}]" >&2; 
			echo ;
		} \
		|| { 
			DEP_KO="I need $sys_dep and but it is missing." ; 
			KO_MSG="KO - :("; 
			TRM_COL=$(tput cols) ; DEP_COL_KO=${#DEP_KO} ; KO_MSG_COL=${#KO_MSG} ; 
			COL_KO=$(( $TRM_COL - $DEP_COL_KO - $KO_MSG_COL )) ; 
			sys_dep="${BLDCYA}${sys_dep}${NOCOLR}"
			DEP_KO="I need $sys_dep and but it is missing." ; 
			printf '%s%*s%s' "$DEP_KO" $COL_KO "[${BLDRED}${KO_MSG}${NOCOLR}]" >&2; 
			echo ;
			new_len=$(( ${#deps_not_ok[@]} + 1 ))
			deps_not_ok[$new_len]=$sys_dep
		} 
done
# checking npm dependencies
declare -a npm_modules_dependencies 
# define your npm dependencies here
npm_modules_dependencies=("express" "jade" "node" "npm" "curl")
for npm_mod in ${npm_modules_dependencies[@]} 
do
	installed=$(npm -dg ls 2>&1 | grep -E '[├│└]' | grep " $npm_mod\\@" | wc -l)
	[ $installed -gt 0 ] \
	&& {
		DEP_OK="I need $npm_mod and it is correctly installed." ; 
		OK_MSG="OK - :)"; 
		TRM_COL=$(tput cols) ; DEP_COL_OK=${#DEP_OK} ; OK_MSG_COL=${#OK_MSG} ; 
		COL_OK=$(( $TRM_COL - $DEP_COL_OK - $OK_MSG_COL )) ; 
		npm_mod="${BLDVIO}${npm_mod}${NOCOLR}"
		DEP_OK="I need $npm_mod and it is correctly installed." ; 
		printf '%s%*s%s' "$DEP_OK" $COL_OK "[${BLDGRN}${OK_MSG}${NOCOLR}]" >&2; 
		echo ;
	} \
	|| {
		DEP_KO="I need $npm_mod and but it is missing." ; 
		KO_MSG="KO - :("; 
		TRM_COL=$(tput cols) ; DEP_COL_KO=${#DEP_KO} ; KO_MSG_COL=${#KO_MSG} ; 
		COL_KO=$(( $TRM_COL - $DEP_COL_KO - $KO_MSG_COL )) ; 
		npm_mod="${BLDVIO}${npm_mod}${NOCOLR}"
		DEP_KO="I need $npm_mod and but it is missing." ; 
		printf '%s%*s%s' "$DEP_KO" $COL_KO "[${BLDRED}${KO_MSG}${NOCOLR}]" >&2; 
		echo ;
		new_len=$(( ${#deps_not_ok[@]} + 1 ))
		deps_not_ok[$new_len]=$npm_mod
	}
done
# printing missing dependencies
echo -n "Components ${BLDWHI}not found${NOCOLR}: ";
for i in "${deps_not_ok[@]}"
do 
	echo -n "$i "
done
echo ;
