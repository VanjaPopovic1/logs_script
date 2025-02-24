# logs_stats.sh

## Description
A Bash script that processes log files by searching for a specified string. It displays for each log file:
- File name
- File size
- Total line count
- Count of lines containing the search string

Results are sorted in descending order by the count of matches.

## Usage
```bash
./logs_stats.sh <log_directory> <search_string>

