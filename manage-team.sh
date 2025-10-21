#!/bin/bash

# Team Member Management Script
# This script helps you manage collaborators for the Startup-VC repository

REPO="Yuvaraj1Aravindan/Startup-VC"

echo "======================================"
echo "  Startup-VC Team Management"
echo "======================================"
echo ""

function show_menu() {
    echo "Choose an option:"
    echo "  1) Add a team member (read access)"
    echo "  2) Add a team member (write access)"
    echo "  3) List all collaborators"
    echo "  4) Remove a team member"
    echo "  5) View repository info"
    echo "  6) Exit"
    echo ""
    read -p "Enter your choice [1-6]: " choice
}

function add_member_read() {
    read -p "Enter GitHub username: " username
    if [ -z "$username" ]; then
        echo "❌ Username cannot be empty"
        return
    fi
    
    echo "⏳ Adding $username with READ access..."
    gh api repos/$REPO/collaborators/$username -X PUT -f permission=pull
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully added $username with READ access"
        echo "📧 They will receive an email invitation"
    else
        echo "❌ Failed to add $username"
    fi
}

function add_member_write() {
    read -p "Enter GitHub username: " username
    if [ -z "$username" ]; then
        echo "❌ Username cannot be empty"
        return
    fi
    
    echo "⏳ Adding $username with WRITE access..."
    gh api repos/$REPO/collaborators/$username -X PUT -f permission=push
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully added $username with WRITE access"
        echo "📧 They will receive an email invitation"
    else
        echo "❌ Failed to add $username"
    fi
}

function list_collaborators() {
    echo "📋 Current collaborators:"
    echo ""
    gh api repos/$REPO/collaborators --jq '.[] | "👤 \(.login) - \(.permissions | to_entries | map(select(.value == true)) | .[0].key)"'
}

function remove_member() {
    read -p "Enter GitHub username to remove: " username
    if [ -z "$username" ]; then
        echo "❌ Username cannot be empty"
        return
    fi
    
    read -p "Are you sure you want to remove $username? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "❌ Cancelled"
        return
    fi
    
    echo "⏳ Removing $username..."
    gh api repos/$REPO/collaborators/$username -X DELETE
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully removed $username"
    else
        echo "❌ Failed to remove $username"
    fi
}

function show_repo_info() {
    echo "📊 Repository Information:"
    echo ""
    gh repo view $REPO
}

# Main loop
while true; do
    show_menu
    
    case $choice in
        1)
            add_member_read
            ;;
        2)
            add_member_write
            ;;
        3)
            list_collaborators
            ;;
        4)
            remove_member
            ;;
        5)
            show_repo_info
            ;;
        6)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1-6"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done
