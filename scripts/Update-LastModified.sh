#!/bin/bash
# Update-LastModified.sh
# Update last modified date for all Markdown files in agent folder

AGENT_PATH="/f/openclaw/agent"
TODAY=$(date +%Y-%m-%d)

echo ""
echo "========================================"
echo "  Update Last Modified Dates"
echo "========================================"
echo ""
echo "Target: $AGENT_PATH"
echo "Date: $TODAY"
echo ""

UPDATED=0
ADDED=0
ERRORS=0

# Find all Markdown files
find "$AGENT_PATH" -name "*.md" -type f | while read -r file; do
    # Skip excluded directories
   if [[ "$file" == *"node_modules"* ]] || \
       [[ "$file" == *".git"* ]] || \
       [[ "$file" == *"workinglog"* ]] || \
       [[ "$file" == *"logs/daily_"* ]]; then
        continue
    fi
    
    FILENAME=$(basename "$file")
    
    # Check if Last Modified comment exists
   if grep -q "<!-- Last Modified: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->" "$file"; then
        # Update existing date
       sed -i "s/<!-- Last Modified: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->/<!-- Last Modified: $TODAY -->/g" "$file"
       sed -i "s/<!-- Last Modified (CN): [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} -->/<!-- Last Modified (CN): $TODAY -->/g" "$file"
        echo "[UPDATED] $FILENAME"
        ((UPDATED++))
    else
        # Add new comment
        HEADER="<!-- Last Modified: $TODAY -->\n<!-- Last Modified (CN): $TODAY -->\n\n"
        CONTENT=$(cat "$file")
        echo -e "$HEADER$CONTENT" > "$file"
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
if [ $ERRORS-gt 0 ]; then
    echo "Failed: $ERRORS files"
fi
