#!/bin/bash
#
# @author Danny Eck
# @date 2013-08-13
# @todo make ENV configurations use (or not) dispatcher. (Assume PROD in both)
# @todo integrity overview
# @example
#   Grab all problematic UPCs:
#     grep -hEo 'UPC: \d{12}' test_results.txt | cut -c 6- | sort | uniq
#   Grab all unique fitName values:
#     grep -rhEo '"fitName":"([^"]+)' mocks | cut -d: -f2 | cut -c 2- | sort | uniq
#   Replace `fitName` above with {brandName, fullName, color, (waistSize, size, length, inseam)}
#
# This script does the artifact management, logging, process invocation,
# notifications, etc. for the TryOn API Validator (https://github.searshc.com/deck0/tryOn-api-validator).
# This script will probably live in Jenkins someday...
#

# Configuration
DEV='<dev-uri>'
QA='<qa-uri>'
PROD='<production-uri>'
RESOURCE='/getProductDetails?in_upc='
UPCS_FILE='upcs.txt'
# Stop editing below here
JUNIT_DIR='reports'
LOG='process.log'
CURL_CSV='curl_results.csv'
TEST_RESULTS='test_results.txt'
MOCKS_DIR='mocks'
ENV=${PROD}
NODE=$(which node)
ZIP=$(which zip)

# Start
echo -e "START"

# Clean up (just in case)
rm -rf "$JUNIT_DIR" "$TEST_RESULTS" "$CURL_CSV" "$MOCKS_DIR"
mkdir -p "$MOCKS_DIR"

# Create UPCS List
echo -n "loading $UPCS_FILE..."
if [ -f "$UPCS_FILE" ]; then
   while read line
   do
      UPCS+=("$line")
   done < $UPCS_FILE
   echo "done!"

   # Make sure file not empty
   UPCS_LEN=${#UPCS[@]}
   if [ "${UPCS_LEN}" -eq 0 ]; then
      echo "FAIL: $UPCS_FILE is empty!"
      exit 2
   fi
else
   echo "FAIL!"
   exit 1
fi

# Cache the requests
echo -e "\nCACHE RESPONSES"
echo "upc,http_code,time_total,size_download,time_starttransfer" > "$CURL_CSV"
for (( i=0; i<${UPCS_LEN}; i++ )); do
   echo -n "getting $((i+1)) of $UPCS_LEN..."
   echo -n "\"${UPCS[$i]}\"," >> $CURL_CSV
   curl -s -w "\"%{http_code}\",%{time_total},%{size_download},%{time_starttransfer}\n" "$PROD$RESOURCE${UPCS[$i]}" -o $MOCKS_DIR/${UPCS[$i]}.json >> $CURL_CSV
   echo "done!"
done

# Run Low-Rez tests
echo -e "\nRUN JASMINE TESTS"
echo -n "running..."
node node_modules/jasmine-node/lib/jasmine-node/cli.js --noColor --noStack --junitreport --output "$JUNIT_DIR/" spec > "$TEST_RESULTS"
tail -n +3 "$TEST_RESULTS" > tmp.txt && mv tmp.txt "$TEST_RESULTS"
echo "done!"

echo -e "\nFINISHED!!!\n"
