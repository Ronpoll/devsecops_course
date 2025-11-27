#!/usr/bin/env bash
"Tells the operating system to run this script using the **bash** interpreter.
`env` finds `bash` even if it's in a non-standard location."

set -euo pipefail
"This line makes Bash behave more safely:
-e → exit if any command fails
-u → exit if you use an undefined variable
-o pipefail → pipelines fail if any command inside fails, not just the last one
This prevents many subtle bugs."

# 1) Check argument
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <syslog_file>"
  exit 1
fi

LOG_FILE="$1"

if [[ ! -r "$LOG_FILE" ]]; then
  echo "File '$LOG_FILE' is not readable"
  exit 1
fi

# 2) Define the keywords we care about
KEYWORDS=("ERROR" "WARNING" "FATAL" "CRITICAL")

# 3) Per-IP statistics
declare -A IP_COUNTS     # how many lines per IP
declare -A IP_KEYWORDS   # which keywords appeared per IP (as a string)



