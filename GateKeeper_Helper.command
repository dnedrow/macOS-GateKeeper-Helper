#!/bin/bash
set -u -o pipefail
IFS=$'\n\t'

# Define some color escape sequences.
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YLO='\033[0;93m'
CYN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "GateKeeper Helper ${BLU}wynioux${NC}"
echo -e "Check my page: ${BLU}https://wynioux.github.io ${NC}"
echo ""
echo -e "${GRN}Options 1: Disable GateKeeper${NC}"
echo -e "    ${RED}>> Note that doing this introduces a major security risk in MacOS.${NC}"
echo ""
echo -e "${GRN}Options 2: Enable GateKeeper${NC}"
echo -e "    >> The best option for macOS security. Used in conjunction with option 3."
echo ""
echo -e "${GRN}Options 3: Remove GateKeeper quarantine flag from an app.${NC}"
echo -e "    >> GateKeeper will ignore this app when it is launched."
echo ""
echo -e "${GRN}Options 4: Self-sign the app${NC}"
echo -e "    >> If an app quits immediately after launch, try self-signing."
echo ""
PS3='Please enter your choice: '
options=("Disable GateKeeper" "Enable GateKeeper" "Remove GateKeeper quarantine flag from an app" "Self-sign the app" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Disable GateKeeper")
            echo ""
            echo -e "${GRN}You have chosen to disable GateKeeper.${NC}"
            echo -e "    ${RED}>> Danger!${NC}"
            echo -e "       Disabling GateKeeper is a very bad idea and creates"
            echo -e "       a major security risk in macOS."
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo spctl --master-disable
            break
            ;;
        "Enable GateKeeper")
            echo ""
            echo -e "${GRN}You have chosen to enable GateKeeper. Good for you!${NC}"
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo spctl --master-enable
            break
            ;;
        "Remove GateKeeper quarantine flag from an app")
            echo ""
            echo -e "${GRN}You have chosen to remove the GateKeeper quarantine flag from an app.${NC}"
            echo ""
            read -e -r -p "Drag & drop the app on this window and then press Return: " FILEPATH
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo xattr -rd com.apple.quarantine "$FILEPATH"
            break
            ;;
        "Self-sign the app")
            echo ""
            echo -e "${GRN}You have chosen to self-sign an app.${NC}"
            echo -e "${GRN}You will be prompted by 'sudo' to enter your password.${NC}"
            echo -e "${GRN}Press ${YLO}^c${GRN} to exit this script.${NC}"
            echo -e "${CYN}"
            read -e -r -p "Drag & drop the app here and then press return: " FILEPATH
            echo -e "${NC}"

            # Make sure sudo can do what we want.
            {
			  IFS= read -rd '' err
			  IFS= read -rd '' out
			  IFS= read -rd '' status
			} < <({ out=$(sudo -l codesign -f -s - --deep "$FILEPATH"); } 2>&1; printf '\0%s' "$out" "$?")

			if [ $status -ne 0 ]; then
				printf "${RED}'sudo' was unable to continue. Exit code %d.${NC}\n" $status
				printf "${RED}The error was %s${NC}\n" $err
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
				printf "${RED}Code signing failed. Exit code %d.${NC}\n" $status
				printf "${RED}The error was %s${NC}\n" $err
				exit $status
			fi

			printf "${GRN}Code signing succeeded.${NC}\n"
			exit $status

   #          sudo codesign -f -s - --deep "$FILEPATH" #2> /dev/null
   #          retVal=$?
			# if [ $retVal -ne 0 ]; then
			# 	printf "${RED}Code signing failed with exit code %d!${NC}\n" $retVal
			# else
			# 	printf "${GRN}Code signing succeeded!${NC}\n"
			# fi
			# exit $retVal
            break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "${RED}Invalid option:${NC} $REPLY" ;;
    esac
done
