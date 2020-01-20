#!/bin/bash
set -u -o pipefail
IFS=$'\n\t'

# Define some color escape sequences.
# General Foreground Colors
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
GREY='\033[90m'

# General Background Colors
BG_BLACK='\033[30;40m'
BG_RED='\033[31;41m'
BG_GREEN='\033[32;42m'
BG_YELLOW='\033[33;43m'
BG_BLUE='\033[34;44m'
BG_PURPLE='\033[35;45m'
BG_CYAN='\033[36;46m'
BG_WHITE='\033[37;47m'
BG_GREY='\033[100m'

# BOLD
BOLD_BLACK='\033[30;1m'
BOLD_RED='\033[31;1m'
BOLD_GREEN='\033[32;1m'
BOLD_YELLOW='\033[33;1m'
BOLD_BLUE='\033[34;1m'
BOLD_PURPLE='\033[35;1m'
BOLD_CYAN='\033[36;1m'
BOLD_WHITE='\033[37;1m'
BOLD_GREY='\033[1;90m'

# UNDERLINE
UL_BLACK='\033[30;4m'
UL_RED='\033[31;4m'
UL_GREEN='\033[32;4m'
UL_YELLOW='\033[33;4m'
UL_BLUE='\033[34;4m'
UL_PURPLE='\033[35;4m'
UL_CYAN='\033[36;4m'
UL_WHITE='\033[37;4m'
UL_GREY='\033[4;90m'

# BLINK
BLK_BLACK='\033[30;5m'
BLK_RED='\033[31;5m'
BLK_GREEN='\033[32;5m'
BLK_YELLOW='\033[33;5m'
BLK_BLUE='\033[34;5m'
BLK_PURPLE='\033[35;5m'
BLK_CYAN='\033[36;5m'
BLK_WHITE='\033[37;5m'
BLK_GREY='\033[5;90m'

# REVERSE
REV_BLACK='\033[30;7m'
REV_RED='\033[31;7m'
REV_GREEN='\033[32;7m'
REV_YELLOW='\033[33;7m'
REV_BLUE='\033[34;7m'
REV_PURPLE='\033[35;7m'
REV_CYAN='\033[36;7m'
REV_WHITE='\033[37;7m'
REV_GREY='\033[7;90m'

# BRIGHT
BRI_BLACK='\033[90m'
BRI_RED='\033[91m'
BRI_GREEN='\033[92m'
BRI_YELLOW='\033[93m'
BRI_BLUE='\033[94m'
BRI_PURPLE='\033[95m'
BRI_CYAN='\033[96m'
BRI_WHITE='\033[97m'

# BRIGHT & BOLD
BRI_BOLD_BLACK='\033[90;1m'
BRI_BOLD_RED='\033[91;1m'
BRI_BOLD_GREEN='\033[92;1m'
BRI_BOLD_YELLOW='\033[93;1m'
BRI_BOLD_BLUE='\033[94;1m'
BRI_BOLD_PURPLE='\033[95;1m'
BRI_BOLD_CYAN='\033[96;1m'
BRI_BOLD_WHITE='\033[97;1m'

# RESET
RESET_FG='\033[39m'
RESET_BG='\033[49m'
RESET_ALL='\033[0m'

DOC_REQUEST=70

# The selectWithDefault function was posted by mklement0 (https://github.com/mklement0)
# on StackOverflow in this answer: https://stackoverflow.com/a/42790579/1227012
selectWithDefault() {

  local item i=0 numItems=$#

  # Print numbered menu items, based on the arguments passed.
  for item; do         # Short for: for item in "$@"; do
    printf '%s\n' "$((++i))) $item"
  done >&2 # Print to stderr, as `select` does.

  # Prompt the user for the index of the desired item.
  while :; do
    printf %s "${PS3-#? }" >&2 # Print the prompt string to stderr, as `select` does.
    read -r index
    # Make sure that the input is either empty or that a valid index was entered.
    [[ -z $index ]] && break  # empty input
    (( index >= 1 && index <= numItems )) 2>/dev/null || { echo "Invalid selection. Please try again." >&2; continue; }
    break
  done

  # Output the selected item, if any.
  [[ -n $index ]] && printf %s "${@: index:1}"

}

if [ "${1-}" = "-h"  -o "${1-}" = "--help" ]     # Request help.
then
  echo; echo -e "Usage: $0 [-h] [path]"; echo -e
  sed --silent -e '/DOCUMENTATIONXX$/,/^DOCUMENTATIONXX$/p' "$0" |
  sed -e '/DOCUMENTATIONXX$/d'; exit $DOC_REQUEST; fi


: <<DOCUMENTATIONXX
Gatekeeper Helper ${BLUE}wynioux${RESET_ALL}
Check my page: ${BLUE}https://wynioux.github.io ${RESET_ALL}

${GREEN}Options 1: Disable Gatekeeper${RESET_ALL}
    ${RED}>> Note that doing this introduces a major security risk in MacOS.${RESET_ALL}

${GREEN}Options 2: Enable Gatekeeper${RESET_ALL}"
    >> The best option for macOS security. Used in conjunction with option 3.

${GREEN}Options 3: Remove Gatekeeper quarantine flag from an app.${RESET_ALL}
    >> Gatekeeper will ignore this app when it is launched.

${GREEN}Options 4: Self-sign the app${RESET_ALL}
    >> If an app quits immediately after launch, try self-signing.
DOCUMENTATIONXX

#exit

echo -e "Gatekeeper Helper ${BLUE}wynioux${RESET_ALL} ( ${BLUE}https://wynioux.github.io ${RESET_ALL})"

echo ""
PS3='Please enter your choice: '
choices=("Disable Gatekeeper" "Enable Gatekeeper" "Remove Gatekeeper quarantine flag [default]" "Self-sign the app" "Quit")
opt=$(selectWithDefault "${choices[@]}")

case $opt in
    'Disable Gatekeeper')
        echo ""
        echo -e "${GREEN}You have chosen to disable Gatekeeper.${RESET_ALL}"
        echo -e "    ${RED}>> Danger!${RESET_ALL}"
        echo -e "       Disabling Gatekeeper is a very bad idea and creates"
        echo -e "       a major security risk in macOS."
        echo ""
        echo -e "${YELLOW}Please provide your password to proceed, or press ^C to quit.${RESET_ALL}"
        echo ""
        sudo spctl --master-disable
        ;;
    'Enable Gatekeeper')
        echo ""
        echo -e "${GREEN}You have chosen to enable Gatekeeper. Good for you!${RESET_ALL}"
        echo ""
        echo -e "${YELLOW}Please provide your password to proceed, or press ^C to quit.${RESET_ALL}"
        echo ""
        sudo spctl --master-enable
        ;;
    ''|'Remove Gatekeeper quarantine flag [default]')
        echo ""
        echo -e "${GREEN}You have chosen to remove the Gatekeeper quarantine flag from an app.${RESET_ALL}"
        echo ""
        read -e -r -p "Drag & drop the app on this window and then press Return: " FILEPATH
        echo ""
        echo -e "${YELLOW}Please provide your password to proceed, or press ^C to quit.${RESET_ALL}"
        echo ""
        sudo xattr -rd com.apple.quarantine "$FILEPATH"
        ;;
    'Self-sign the app')
        echo ""
        echo -e "${GREEN}You have chosen to self-sign an app.${RESET_ALL}"
        echo -e "${GREEN}You will be prompted by 'sudo' to enter your password.${RESET_ALL}"
        echo -e "${GREEN}Press ${YELLOW}^c${GREEN} to exit this script.${RESET_ALL}"
        echo -e "${CYAN}"
        read -e -r -p "Drag & drop the app here and then press return: " FILEPATH
        echo -e "${RESET_ALL}"

        # Make sure sudo can do what we want.
        {
		  IFS= read -rd '' err
		  IFS= read -rd '' out
		  IFS= read -rd '' status
		} < <({ out=$(sudo -l codesign -f -s - --deep "$FILEPATH"); } 2>&1; printf '\0%s' "$out" "$?")

		if [ $status -ne 0 ]; then
			printf "${RED}'sudo' was unable to continue. Exit code %d.${RESET_ALL}\n" $status
			printf "${RED}The error was %s${RESET_ALL}\n" $err
			exit $status
		fi

        {
		  IFS= read -rd '' err
		  IFS= read -rd '' out
		  IFS= read -rd '' status
		} < <({ out=$(sudo codesign -f -s - --deep "$FILEPATH"); } 2>&1; printf '\0%s' "$out" "$?")

		# if [ -n "${err-}" ]; then
		# 	echo $err
		# 	echo $status
		# fi

		if [ $status -ne 0 ]; then
			printf "${RED}Code signing failed. Exit code %d.${RESET_ALL}\n" $status
			printf "${RED}The error was %s${RESET_ALL}\n" $err
			exit $status
		fi

		printf "${GREEN}Code signing succeeded.${RESET_ALL}\n"
		exit $status

#          sudo codesign -f -s - --deep "$FILEPATH" #2> /dev/null
#          retVal=$?
		# if [ $retVal -ne 0 ]; then
		# 	printf "${RED}Code signing failed with exit code %d!${RESET_ALL}\n" $retVal
		# else
		# 	printf "${GREEN}Code signing succeeded!${RESET_ALL}\n"
		# fi
		# exit $retVal
        ;;
    'Quit')
        ;;
    '')
		echo Default
		;;
esac
exit
