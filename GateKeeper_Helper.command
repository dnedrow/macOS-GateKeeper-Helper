#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Define some color escape sequences.
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YLO='\033[0;93m'
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
echo -e "${GRN}Options 3: Remove an app from GateKeeper's quarantine${NC}"
echo -e "    >> GateKeeper will ignore this app when it is launched."
echo ""
echo -e "${GRN}Options 4: Self-sign the app${NC}"
echo -e "    >> If an app quits immediately after launch, try self-signing."
echo ""
PS3='Please enter your choice: '
options=("Disable GateKeeper" "Enable GateKeeper" "Remove app from GateKeeper quarantine" "Self-sign the app" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Disable GateKeeper")
            echo ""
            echo -e "${GRN}You have chosen to disable GateKeeper.${NC}"
            echo -e "    ${RED}>> Danger!${NC}"
            echo -e "       Disabling GateKeeper is a very bad idea and creates"
            echo -e "       a major security hole in macOS"
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo spctl --master-disable
            break
            ;;
        "Enable GateKeeper")
            echo ""
            echo -e "${GRN}You chosen to enable GateKeeper. Good for you!${NC}"
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo spctl --master-enable
            break
            ;;
        "Remove app from GateKeeper quarantine")
            echo ""
            echo -e "${GRN}You chosen to remove the app from GateKeeper quarantine.${NC}"
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
            echo -e "${GRN}You chosen to self-sign an app${NC}"
            echo ""
            read -e -r -p "Drag & drop the app here then press return: " FILEPATH
            echo ""
            echo -e "${YLO}Please provide your password to proceed, or press ^C to quit.${NC}"
            echo ""
            sudo codesign -f -s - --deep "$FILEPATH"
            echo ""
            echo -e "${RED}If you see - replacing existing signature - that means you are DONE!${NC}"
            echo ""
            echo -e "${RED}Otherwise there is something wrong with the app or its path.${NC}"
            echo ""
            break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "${RED}Invalid option:${NC} $REPLY" ;;
    esac
done
