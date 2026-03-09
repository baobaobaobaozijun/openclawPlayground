#!/bin/bash
# Update-LastModified.sh
# Update last modified date for specified Markdown files

TODAY=$(date +%Y-%m-%d)

echo ""
echo "========================================"
echo "  Update Last Modified Dates"
echo "========================================"
echo ""
echo "Date: $TODAY"
echo ""

UPDATED=0
ADDED=0
ERRORS=0

# If no arguments provided, show usage
if [ $# -eq 0 ]; then
   echo "Usage: ./Update-LastModified.sh <file1.md> [file2.md] ..."
   echo ""
   echo "Examples:"
   echo "  ./Update-LastModified.sh README.md"
   echo "  ./Update-LastModified.sh README.md IDENTITY.md ROLE.md"
   echo "  ./Update-LastModified.sh *.md"
   echo ""
   exit 1
fi

# Process each file
for file in "$@"; do
    # Get filename for display
    FILENAME=$(basename "$file")
    
    # Check if file exists (try both relative and absolute paths)
   if [ ! -f "$file" ] && [ ! -f "./$file" ]; then
       echo "[SKIP] $FILENAME -File not found"
        ((ERRORS++))
        continue
    fi
    
    # Use the file path that exists
   if [ -f "$file" ]; then
        ACTUAL_FILE="$file"
    else
        ACTUAL_FILE="./$file"
    fi
    
    # Skip excluded directories
   if [[ "$ACTUAL_FILE" == *"node_modules"* ]] || \
       [[ "$ACTUAL_FILE" == *".git"* ]] || \
       [[ "$ACTUAL_FILE" == *"workinglog"* ]] || \
       [[ "$ACTUAL_FILE" == *"logs/daily_"* ]]; then
       echo "[SKIP] $FILENAME - Excluded directory"
        continue
    fi
    
    # Check if Last Modified comment exists
   if grep -q "<!-- Last Modified: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->" "$ACTUAL_FILE"; then
        # Update existing date
       sed-i "s/<!-- Last Modified: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->/<!-- Last Modified: $TODAY -->/g" "$ACTUAL_FILE"
       sed -i "s/<!-- Last Modified (CN): [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->/<!-- Last Modified (CN): $TODAY -->/g" "$ACTUAL_FILE"
       echo "[UPDATED] $FILENAME"
        ((UPDATED++))
    else
        # Add new comment
        HEADER="<!-- Last Modified: $TODAY -->
<!-- Last Modified (CN): $TODAY -->

"
        CONTENT=$(cat "$ACTUAL_FILE")
       echo -e "$HEADER$CONTENT" > "$ACTUAL_FILE"
       echo "[ADDED] $FILENAME"
        ((ADDED++))
    fi
done

echo ""
echo "========================================"
echo "  Complete!"
echo "========================================"
echo "Updated: $UPDATED files"
echo "Added: $ADDED files"
if [ $ERRORS -gt 0 ]; then
   echo "Skipped: $ERRORS files"
fi
