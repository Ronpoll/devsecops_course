#!/bin/bash

set -euo pipefail
# -e: exit on any command failure
# -u: treat unset variables as errors
# -o pipefail: fail a pipeline if any part fails

# Validate input file
validate_input() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <syslog_file>"
    exit 1
  fi

  LOG_FILE="$1"

  if [[ ! -r "$LOG_FILE" ]]; then
    echo "File '$LOG_FILE' is not readable"
    exit 1
  fi
}

# Keyword list
error_keyword_list() {
  KEYWORDS=("ERROR" "WARNING" "FATAL" "CRITICAL" "FAIL" "PANIC" "ALERT" "SEVERE")
}

# Associative arrays for IP statistics
create_ip_variables() {
  declare -Ag IP_COUNTS     # how many lines per IP
  declare -Ag IP_KEYWORDS   # which keywords appeared per IP (as a string)
}

# Function: given a line, print the first IP address found (or nothing)
find_ip_in_line() {
  local line="$1"
  local ip

  ip=$(grep -Eo '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\b' \
        <<< "$line" | head -n 1 || true)

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

# Process the log file
process_log_file() {
  local file="$1"

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
      existing="${IP_KEYWORDS[$ip]:-}"
      if [[ " $existing " != *" $kw "* ]]; then
        IP_KEYWORDS["$ip"]="$existing $kw"
      fi
    done

  done < "$file"
}

# Generate timestamped report and print it
create_report() {
  # Create timestamped report filename
  local DATE_PART
  DATE_PART=$(date '+%d-%b-%Y_%H-%M' | tr 'A-Z' 'a-z')
  REPORT_FILE="report-${DATE_PART}.rep"

  {
    echo "*******************************************************************************"
    echo "Report created at $(date +%H:%M)"
    echo

    for ip in "${!IP_COUNTS[@]}"; do
      count=${IP_COUNTS[$ip]}
      kws=${IP_KEYWORDS[$ip]}

      # Trim whitespace
      kws=$(echo "$kws" | xargs)

      # Convert "A B C" → "A, B, C"
      kws=${kws// /, }

      echo "${ip} address appeared in ${count} lines."
      echo "keywords appeared: ${kws}"
      echo
    done

    echo "*******************************************************************************"
  } > "$REPORT_FILE"

  echo "file name: $REPORT_FILE"
  cat "$REPORT_FILE"
}

# --------- Main flow ---------
validate_input "$@"
error_keyword_list
create_ip_variables
process_log_file "$LOG_FILE"
create_report


