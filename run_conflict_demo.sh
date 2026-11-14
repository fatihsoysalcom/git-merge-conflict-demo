#!/bin/bash

# This script demonstrates a Git merge conflict scenario.
# It creates a dummy Git repository, makes conflicting changes on two branches,
# and then attempts to merge them into the main branch, resulting in a conflict.

DEMO_DIR="git_merge_conflict_demo"

# Clean up previous demo directory if it exists
if [ -d "$DEMO_DIR" ]; then
  echo "Removing existing '$DEMO_DIR' directory..."
  rm -rf "$DEMO_DIR"
fi

echo "Creating new demo directory: '$DEMO_DIR'"
mkdir "$DEMO_DIR"
cd "$DEMO_DIR"

# Initialize a new Git repository
git init -b main

# Configure user info for commits
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "--- Initializing main branch ---"
# Create an initial file and commit it to main
echo "Hello Git!" > README.md
git add README.md
git commit -m "Initial commit: Add README.md"

echo "--- Creating feature-a branch ---"
# Create 'feature-a' branch and make a change
git checkout -b feature-a
echo "This is feature A's addition." >> README.md
git add README.md
git commit -m "Feature A: Add line about feature A"

echo "--- Switching back to main and creating feature-b branch ---"
# Switch back to main, then create 'feature-b' branch from main's state *before* feature-a was merged
git checkout main
git checkout -b feature-b
# Make a conflicting change on the same line as feature-a
echo "This is feature B's addition." >> README.md
git add README.md
git commit -m "Feature B: Add line about feature B"

echo "--- Merging feature-a into main ---"
# Switch back to main and merge feature-a (this should be a clean merge)
git checkout main
git merge feature-a --no-edit

echo "--- Attempting to merge feature-b into main (EXPECT CONFLICT) ---"
echo "Attempting to merge feature-b. This will cause a merge conflict because both branches modified the same part of README.md."

# Attempt to merge feature-b. This command is expected to fail and create a conflict.
# We use '|| true' to ensure the script continues to display the conflict state.
git merge feature-b || true

echo "\n--- Merge conflict detected! ---"
echo "Git has stopped the merge due to conflicting changes."

echo "\nCurrent Git status:"
git status

echo "\nConflicted file content (README.md):"
cat README.md

echo "\n--- How to resolve this conflict ---"
echo "1. Open 'README.md' in a text editor (e.g., 'nano README.md' or 'code README.md')."
echo "2. Manually edit the file to combine the changes as desired. Remove Git's conflict markers (<<<<<<<, =======, >>>>>>>)."
echo "   For example, you might change it to:"
echo "   Hello Git!"
echo "   This is feature A's addition and feature B's addition combined."
echo "3. After editing, stage the resolved file: 'git add README.md'"
echo "4. Commit the merge: 'git commit -m "Resolve merge conflict: combined A and B"'"

echo "\nYou are currently in the '$DEMO_DIR' directory with a merge conflict."
echo "You can now try resolving the conflict manually using the steps above."
echo "To exit this demo directory, run: 'cd ..'"
