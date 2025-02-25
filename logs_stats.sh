#!/usr/bin/env bash
###############################################################################
##?  Logs Search Script
##?  Helper script for searching strings in log files.
##?  Usage:
##?    ./logs_stats.sh <log_directory> <search_string>
##? 
##?  Options:
##?    -h --help            Show this screen.
###############################################################################

# This script searches for a specified string in files and displays only those
# that contain that string. Output is sorted in descending order by the number
# of lines in which the string appears.
HELP=$(grep "^##?" "$0" | cut -c 5-)

if [[ "$1" == "-h" || "$1" == "--help" ]] || [ "$#" -ne 2 ]; then
  echo "${HELP}" >&2
  exit 1
fi


logdir="$1"
searchstring="$2"

if [[ ! -d "$logdir" ]]; then
  echo "Error: Directory '$logdir' does not exist"
  exit 1
fi

results=$(grep -ri -c "$searchstring" "$logdir"/* 2>/dev/null | awk -F: '$2 > 0' | sort -t: -k2,2rn)

if [ -z "$results" ]; then
  echo "No files in '$logdir' contain '$searchstring'"
  exit 0  
fi

echo "Files containing '$searchstring' (sorted by number of matches):"

while IFS= read -r file_count; do 
  file="${file_count%:*}" 
  count="${file_count#*:}" 

  file_name=$(basename "$file")
  file_size_mb=$(du -m "$file" 2>/dev/null | awk '{print $1}')
  line_count=$(wc -l < "$file" 2>/dev/null) 

  echo "$file_name - Size: ${file_size_mb:-0} MB; Lines: ${line_count:-0}; Matches: $count" 

done <<< "$results"

exit 0
