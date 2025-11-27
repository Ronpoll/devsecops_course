#!/usr/bin/env bash
# "Tells the operating system to run this script using the **bash** interpreter.
# `env` finds `bash` even if it's in a non-standard location."

set -euo pipefail
# "This line makes Bash behave more safely:
# -e → exit if any command fails
# -u → exit if you use an undefined variable
# -o pipefail → pipelines fail if any command inside fails, not just the last one
# This prevents many subtle bugs."

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
KEYWORDS=("ERROR" "WARNING" "FATAL" "CRITICAL" "FAIL" "PANIC" "ALERT" "SEVERE")

# 3) Per-IP statistics
declare -A IP_COUNTS     # how many lines per IP
declare -A IP_KEYWORDS   # which keywords appeared per IP (as a string)


# Function: given a line, print the first IP address found (or nothing)
find_ip_in_line() {
  local line="$1"
  # This regex is "good enough" for IPv4 in logs
  local ip

  ip=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' <<< "$line" | head -n 1 || true)

  if [[ -n "$ip" ]]; then
    echo "$ip"
  fi
}

# Function: given a line, print all matching keywords (space separated)
find_keywords_in_line() {
  local line="$1"
  local found=()

  for kw in "${KEYWORDS[@]}"; do
    # Case-insensitive search: convert both to upper
    if [[ "${line^^}" == *"${kw^^}"* ]]; then
      found+=("$kw")
    fi
  done

  # Print all found keywords separated by spaces
  if [[ ${#found[@]} -gt 0 ]]; then
    echo "${found[@]}"
  fi
}

# 4) Process the log file
while IFS= read -r line; do
  # a) find IP in this line
  ip=$(find_ip_in_line "$line" || true)
  [[ -z "$ip" ]] && continue   # no IP, skip line

  # b) find keywords in this line
  kws=$(find_keywords_in_line "$line" || true)
  [[ -z "$kws" ]] && continue  # no relevant keywords, skip

  # c) update count for this IP
  current_count=${IP_COUNTS["$ip"]:-0}
  IP_COUNTS["$ip"]=$(( current_count + 1 ))

  # d) update keyword list for this IP (avoid duplicates)
  for kw in $kws; do
    # if this keyword is not yet in the string, append it
    existing="${IP_KEYWORDS[$ip]:-}"
    if [[ " $existing " != *" $kw "* ]]; then
      IP_KEYWORDS["$ip"]="$existing $kw"
    fi
  done

done < "$LOG_FILE"

# 5) Create a timestamped report file name
DATE_PART=$(date '+%d-%b-%Y_%H-%M' | tr 'A-Z' 'a-z')  # e.g. 27-nov-2025_15-35
REPORT_FILE="report-${DATE_PART}.rep"

# 6) Write the report
{
  echo "*******************************************************************************"
  echo "Report created at $(date +%H:%M)"
  echo

  for ip in "${!IP_COUNTS[@]}"; do
    count=${IP_COUNTS[$ip]}
    kws=${IP_KEYWORDS[$ip]}

        # Clean up leading/trailing spaces in keywords
    kws=$(echo "$kws" | xargs)

    # Convert space-separated keywords to "A, B, C" format
    kws=${kws// /, }

    echo "${ip} address appeared in ${count} lines."
    echo "keywords appeared: ${kws}"
    echo
  done

  echo "*******************************************************************************"
} > "$REPORT_FILE"

# 7) Show the report
echo "file name: $REPORT_FILE"
cat "$REPORT_FILE"

