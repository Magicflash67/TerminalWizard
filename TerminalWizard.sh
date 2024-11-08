#!/bin/bash

echo "Terminal Wizard (∩｀-´)⊃━☆ﾟ.*･"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Log file location in the script's directory
LOG_FILE="$SCRIPT_DIR/script_commands.log"
WATCHER_LOG_FILE="$SCRIPT_DIR/watcher_commands.log"

# Stack for Undo and Redo
declare -a COMMAND_HISTORY
declare -a UNDO_STACK

# Check if sudo is installed
if ! command -v sudo &> /dev/null; then
    echo "Error: 'sudo' is required but not installed. Install sudo first and rerun the script."
    exit 1
fi

# Log commands
LogCommand() {
    local command_message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $command_message" >> "$LOG_FILE"
}

# Function to run the Hardening Script
HardeningScript() {
    echo "Running System Hardening: updates, cleans, and firewall settings"
    sudo apt-get update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo ufw enable
    sudo ufw deny 80
    LogCommand "Completed system hardening"
}

# Prompt for Hardening Script at startup
PromptHardeningScript() {
    read -rp "Would you like to run the System Hardening Script? (Y/N): " HardeningChoice
    if [[ "$HardeningChoice" =~ ^[Yy]$ ]]; then
        HardeningScript
        echo "System Hardening completed."
    else
        echo "Skipping System Hardening."
    fi
}

# Main Menu
StartUp() {
    echo "========================================"
    echo "         MAIN SETUP MENU                "
    echo "========================================"
    echo "$USER"
    echo "========================================"
    echo "0. Clean Terminal"
    echo "1. Rerun Hardening Script"
    echo "2. Undo Hardening Changes"
    echo "3. User Management"
    echo "4. App Management"
    echo "5. File Management"
    echo "6. Miscellaneous"
    echo "7. Server Management"
    echo "8. Exit"
    echo "9. Self-destruct (type 'stop' to cancel file deletion)"
    echo "========================================"
    read -rp "Choice: " choice
    case $choice in
        0) clear; StartUp ;;
        1) HardeningScript ;;
        2) UndoHardening ;;
        3) UserManagement ;;  # Calling UserManagement here
        4) AppManagement ;;
        5) FileManagement ;;
        6) MiscellaneousMenu ;;
        7) ServerManagementMenu ;;
        8) echo "Goodbye, have fun, good luck :]"; exit ;;
        9) SelfDestruct ;;
        *) echo "Invalid choice, try again"; StartUp ;;
    esac
}

# User Management Function (add your logic here)
UserManagement() {
    echo "========================================"
    echo "       USER MANAGEMENT MENU             "
    echo "========================================"
    echo "0. Return to Main Menu"
    echo "1. Add User"
    echo "2. Remove User"
    echo "3. List Users"
    echo "========================================"
    read -rp "Choice: " user_choice
    case $user_choice in
        0) StartUp ;;
        1) AddUser ;;
        2) RemoveUser ;;
        3) ListUsers ;;
        *) echo "Invalid choice, try again"; UserManagement ;;
    esac
}


# Function to add user
AddUser() {
    read -rp "Enter username to add: " username
    sudo adduser "$username"
    echo "User $username added."
}

# Function to remove user
RemoveUser() {
    read -rp "Enter username to remove: " username
    sudo deluser "$username"
    echo "User $username removed."
}

# Function to list users
ListUsers() {
    echo "List of Users:"
    cut -d: -f1 /etc/passwd
}

# Miscellaneous Menu
MiscellaneousMenu() {
    echo "========================================"
    echo "         MISCELLANEOUS MENU             "
    echo "========================================"
    echo "0. Return to Main Menu"
    echo "1. Enable/Disable Sudo-Only Mode"
    echo "2. Enable/Disable Hacker Mode"
    echo "========================================"
    read -rp "Choice: " choice
    case $choice in
        0) StartUp ;;
        1) ToggleSudoOnlyMode ;;
        2) ToggleHackerMode ;;
        *) echo "Invalid choice, try again"; MiscellaneousMenu ;;
    esac
}

# Server Management Menu
ServerManagementMenu() {
    echo "========================================"
    echo "          SERVER MANAGEMENT             "
    echo "========================================"
    echo "0. Return to Main Menu"
    echo "1. Install SSH Server"
    echo "2. Start and Enable SSH Server"
    echo "3. Disable SSH Server"
    echo "4. Uninstall SSH Server"
    echo "5. Disable Root Access for SSH"
    echo "========================================"
    read -rp "Choice: " server_choice
    case $server_choice in
        0) StartUp ;;
        1) InstallSSHServer ;;
        2) StartEnableSSHServer ;;
        3) DisableSSHServer ;;
        4) UninstallSSHServer ;;
        5) DisableRootAccess ;;
        *) echo "Invalid choice, try again"; ServerManagementMenu ;;
    esac
}

# Enable/Disable Hacker Mode
ToggleHackerMode() {
    if [[ "$HACKER_MODE" == "enabled" ]]; then
        echo -e "\033[0m"  # Reset to default terminal colors
        HACKER_MODE="disabled"
        echo "Hacker Mode disabled."
    else
        echo -e "\033[40m\033[32m"  # Black background and lime green text
        HACKER_MODE="enabled"
        echo "Hacker Mode enabled."
    fi
}

# Self Destruct
# Self Destruct
SelfDestruct() {
    # Disable Hacker Mode if enabled
    if [[ "$HACKER_MODE" == "enabled" ]]; then
        ToggleHackerMode
    fi
    
    echo "Self Destruct initiated. Type 'stop' to cancel."
    
    # Define ASCII art frames for Self Destruct sequence
    local frames=(
"                                                         
                                                         c=====e
   ____________                                         _,,_H__
  (__((__((___()                                       //|     |
 (__((__((___()()_____________________________________// |ACME |
(__((__((___()()()------------------------------------'  |_____|" 
"                                                        c=====e
   ____________                                          ,,_H__
  (__((__((___()                                         |     |
 (__((__((___()()_______________________________         |ACME |
(__((__((___()()()------------------------------         |_____|
" 

"                                                        c=====e
   ____________                                          ,,_H__
  (__((__((___()                                         |     |
 (__((__((___()()__________                              |ACME |
(__((__((___()()()---------                              |_____|
" 

"                                                        c=====e
   ____________                                          ,,_H__
  (__((__((___()                                         |     |
 (__((__((___()()                                        |ACME |
(__((__((___()()()                                       |_____|
" 

)

    # Display each ASCII art frame with a 4-second interval, allowing user to type 'stop' to cancel
    for frame in "${frames[@]}"; do
        echo -e "\n$frame"
        read -t 4 -p "Type 'stop' to cancel self-destruct: " response
        if [[ "$response" == "stop" ]]; then
            echo "Self-destruct canceled. Returning to main menu."
            StartUp
            return
        fi
        clear
    done

    # Final message before script deletion
    echo "
       cat
    /\_____/\\
   /  o   o  \\
  ( ==  ^  == )
   )         (
  (           )
 ( (  )   (  ) )
(__(__)___(__)__)
    goodbye 
{what were you expecting, an explosion?}
"

    # Delay before deleting the script file to allow the process to complete
    sleep 2

    # Deleting the script file after a brief delay
    rm -f "$SCRIPT_DIR/$(basename "$0")"
    
    # Provide feedback
    echo "Self-destruct complete. Log files located at:"
    echo "$LOG_FILE"
    echo "$WATCHER_LOG_FILE"
    exit
}



# Function to toggle sudo-only mode
ToggleSudoOnlyMode() {
    if sudo grep -q '^PermitRootLogin' /etc/ssh/sshd_config; then
        echo "Sudo-only mode is currently enabled. Disabling..."
        sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
        sudo systemctl restart ssh
        LogCommand "Disabled sudo-only mode (PermitRootLogin)"
    else
        echo "Enabling sudo-only mode..."
        echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
        sudo systemctl restart ssh
        LogCommand "Enabled sudo-only mode (PermitRootLogin)"
    fi
}

# Function to undo hardening actions
UndoHardening() {
    echo "Undoing system hardening actions..."
    sudo apt-get remove --purge ufw -y
    sudo apt-get remove --purge apt -y
    LogCommand "Undid system hardening actions."
}

# Start the script
StartUp
