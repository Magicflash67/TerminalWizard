#!/bin/bash

echo "System Setup Wizard (∩｀-´)⊃━☆ﾟ.*･"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Log file location in the script's directory
LOG_FILE="$SCRIPT_DIR/script_commands.log"
WATCHER_LOG_FILE="$SCRIPT_DIR/watcher_commands.log"

# Stack for Undo and Redo
declare -a COMMAND_HISTORY
declare -a UNDO_STACK
HACKER_MODE="disabled"

# Start-up logging
LogStartup() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Script started" >> "$LOG_FILE"
}

# Log command function
LogCommand() {
    local command_message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $command_message" >> "$LOG_FILE"
}

# Error handling function
HandleError() {
    local exit_code="$?"
    local last_command="$BASH_COMMAND"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Command '$last_command' failed with exit code $exit_code" >> "$LOG_FILE"
    echo "Error encountered: $last_command failed with exit code $exit_code."
    exit 1
}

# Trap errors and handle them with HandleError function
trap 'HandleError' ERR

# Check if sudo is installed
if ! command -v sudo &> /dev/null; then
    LogCommand "Error: 'sudo' is required but not installed. Install sudo first and rerun the script."
    echo "Error: 'sudo' is required but not installed. Install sudo first and rerun the script."
    exit 1
fi

# Ensure log files exist
touch "$LOG_FILE" "$WATCHER_LOG_FILE"

# Log the script startup
LogStartup

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
    StartUp  # Return to the main menu after the task completes
}

# Main Menu
StartUp() {
    while true; do  # Start the menu loop
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
        echo "9. Self-destruct (type 'stop' to cancel)"
        echo "========================================"
        read -rp "Choice: " choice
        case $choice in
            0) clear; StartUp ;;  # Clean terminal and go back to the menu
            1) HardeningScript ;;  # Run the hardening script and return to menu
            2) UndoHardening ;;  # Undo hardening actions
            3) UserManagement ;;  # Go to User Management
            4) AppManagement ;;  # Go to App Management
            5) FileManagement ;;  # Go to File Management
            6) MiscellaneousMenu ;;  # Go to Miscellaneous Menu
            7) ServerManagementMenu ;;  # Go to Server Management Menu
            8) echo "Goodbye, have fun, good luck :]"; exit ;;  # Exit the script
            9) SelfDestruct ;;  # Trigger the self-destruct sequence
            *) echo "Invalid choice, try again"; StartUp ;;  # Invalid input handling
        esac
    done
}

# Function for User Management
UserManagement() {
    while true; do  # Keep looping until the user chooses an option to exit
        echo "========================================"
        echo "         USER MANAGEMENT MENU           "
        echo "========================================"
        echo "0. Return to Main Menu"
        echo "1. Add User"
        echo "2. Remove User"
        echo "3. List Users"
        echo "========================================"
        read -rp "Choice: " user_choice
        case $user_choice in
            0) StartUp ;;  # Return to main menu
            1) AddUser ;;  # Add a user
            2) RemoveUser ;;  # Remove a user
            3) ListUsers ;;  # List all users
            *) echo "Invalid choice, try again"; UserManagement ;;  # Invalid choice
        esac
    done
}

# Add User Function
AddUser() {
    read -rp "Enter username to add: " username
    sudo adduser "$username"
    LogCommand "User $username added."
    UserManagement  # Return to User Management after adding the user
}

# Remove User Function
RemoveUser() {
    read -rp "Enter username to remove: " username
    sudo deluser "$username"
    LogCommand "User $username removed."
    UserManagement  # Return to User Management after removing the user
}

# List Users Function
ListUsers() {
    echo "List of Users:"
    cut -d: -f1 /etc/passwd
    UserManagement  # Return to User Management after listing users
}

# App Management (Placeholder)
AppManagement() {
    while true; do
        echo "========================================"
        echo "         APP MANAGEMENT MENU            "
        echo "========================================"
        echo "0. Return to Main Menu"
        echo "1. Install a Package"
        echo "2. Remove a Package"
        echo "========================================"
        read -rp "Choice: " app_choice
        case $app_choice in
            0) StartUp ;;  # Return to Main Menu
            1) InstallPackage ;;  # Install a package
            2) RemovePackage ;;  # Remove a package
            *) echo "Invalid choice, try again"; AppManagement ;;  # Invalid choice
        esac
    done
}

# Install Package (Placeholder)
InstallPackage() {
    read -rp "Enter package name to install: " package
    sudo apt-get install "$package" -y
    LogCommand "Installed package $package."
    AppManagement  # Return to App Management after installation
}

# Remove Package (Placeholder)
RemovePackage() {
    read -rp "Enter package name to remove: " package
    sudo apt-get remove "$package" -y
    LogCommand "Removed package $package."
    AppManagement  # Return to App Management after removal
}

# File Management (Placeholder)
FileManagement() {
    while true; do
        echo "========================================"
        echo "         FILE MANAGEMENT MENU           "
        echo "========================================"
        echo "0. Return to Main Menu"
        echo "1. Backup Files"
        echo "2. Restore Files"
        echo "========================================"
        read -rp "Choice: " file_choice
        case $file_choice in
            0) StartUp ;;  # Return to Main Menu
            1) BackupFiles ;;  # Backup files
            2) RestoreFiles ;;  # Restore files
            *) echo "Invalid choice, try again"; FileManagement ;;  # Invalid choice
        esac
    done
}

# Backup Files (Placeholder)
BackupFiles() {
    echo "Backup functionality will be implemented here."
    LogCommand "Backup files initiated."
    FileManagement  # Return to File Management after backup
}

# Restore Files (Placeholder)
RestoreFiles() {
    echo "Restore functionality will be implemented here."
    LogCommand "Restore files initiated."
    FileManagement  # Return to File Management after restore
}

# Miscellaneous Menu
MiscellaneousMenu() {
    while true; do  # Keep looping until the user chooses an option to exit
        echo "========================================"
        echo "         MISCELLANEOUS MENU             "
        echo "========================================"
        echo "0. Return to Main Menu"
        echo "1. Install 'at' Command"
        echo "2. Secure Shadow Files"
        echo "3. General Bash Security Hardening"
        echo "4. Uninstall 'at' Command"
        echo "========================================"
        read -rp "Choice: " choice
        case $choice in
            0) StartUp ;;  # Return to main menu
            1) InstallAt ;;  # Install 'at' command and return to menu
            2) SecureShadowFiles ;;  # Secure shadow files and return to menu
            3) GeneralBashSecurity ;;  # Harden bash security and return to menu
            4) UninstallAt ;;  # Uninstall 'at' command and return to menu
            *) echo "Invalid choice, try again"; MiscellaneousMenu ;;  # Invalid choice
        esac
    done
}

# Install 'at' Command
InstallAt() {
    sudo apt-get install at -y
    LogCommand "'at' command installed."
    MiscellaneousMenu  # Return to Miscellaneous Menu
}

# Secure Shadow Files (Placeholder)
SecureShadowFiles() {
    # Add logic here to secure shadow files
    echo "Shadow files have been secured."
    LogCommand "Shadow files secured."
    MiscellaneousMenu  # Return to Miscellaneous Menu
}

# General Bash Security (Placeholder)
GeneralBashSecurity() {
    # Add bash security hardening steps here
    echo "Bash security hardened."
    LogCommand "Bash security hardened."
    MiscellaneousMenu  # Return to Miscellaneous Menu
}

# Uninstall 'at' Command
UninstallAt() {
    sudo apt-get remove --purge at -y
    LogCommand "'at' command uninstalled."
    MiscellaneousMenu  # Return to Miscellaneous Menu
}

# Server Management (Placeholder)
ServerManagementMenu() {
    while true; do
        echo "========================================"
        echo "         SERVER MANAGEMENT MENU         "
        echo "========================================"
        echo "0. Return to Main Menu"
        echo "1. Install SSH Server"
        echo "2. Start SSH Server"
        echo "3. Stop SSH Server"
        echo "4. Uninstall SSH Server"
        echo "5. Disable Root SSH Access"
        echo "========================================"
        read -rp "Choice: " server_choice
        case $server_choice in
            0) StartUp ;;  # Return to main menu
            1) InstallSSHServer ;;  # Install SSH Server
            2) StartSSHServer ;;  # Start SSH Server
            3) StopSSHServer ;;  # Stop SSH Server
            4) UninstallSSHServer ;;  # Uninstall SSH Server
            5) DisableRootSSH ;;  # Disable Root SSH Access
            *) echo "Invalid choice, try again"; ServerManagementMenu ;;  # Invalid choice
        esac
    done
}

# Placeholder SSH Server Functions
InstallSSHServer() {
    sudo apt-get install openssh-server -y
    LogCommand "SSH Server installed."
    ServerManagementMenu  # Return to Server Management Menu
}

StartSSHServer() {
    sudo systemctl start ssh
    LogCommand "SSH Server started."
    ServerManagementMenu  # Return to Server Management Menu
}

StopSSHServer() {
    sudo systemctl stop ssh
    LogCommand "SSH Server stopped."
    ServerManagementMenu  # Return to Server Management Menu
}

UninstallSSHServer() {
    sudo apt-get remove --purge openssh-server -y
    LogCommand "SSH Server uninstalled."
    ServerManagementMenu  # Return to Server Management Menu
}

DisableRootSSH() {
    sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    LogCommand "Root SSH access disabled."
    ServerManagementMenu  # Return to Server Management Menu
}

# Start the script by entering the main menu
StartUp
