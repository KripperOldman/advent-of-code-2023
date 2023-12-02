$sed 's/^Game \([0-9]*\): /\1; /g' input.txt | \
	awk -F';' ' \
  { \
    for (i = 2; i <= NF; ++i) { \
      print $1 "," $i \
    } \
  }' | \
	awk -F',' ' \
    { \
      for (i = 2; i <= NF; ++i) { \
        print $1 "," $i \
      } \
    }' | \
	awk -F',' ' \
	 BEGIN {MAX_RED=12; MAX_GREEN=13; MAX_BLUE=14;} \
	 /red/ { \
	   gsub(/[^0-9]/, "", $2); \
	   if (int($2) > MAX_RED) { \
	     print $1, $2, MAX_RED, "red" \
	   } \
	 } \
	 /green/ { \
	   gsub(/[^0-9]/, "", $2); \
	   if (int($2) > MAX_GREEN) { \
	     print $1, $2, MAX_GREEN, "green" \
	   } \
	 } \
	 /blue/ { \
	   gsub(/[^0-9]/, "", $2); \
	   if (int($2) > MAX_BLUE) { \
	     print $1, $2, MAX_BLUE, "blue" \
	   } \
	 } \
	 ' | \
  tee /dev/stderr | \
	cut -d' ' -f1 | \
	sort -u | \
  sed 's/.*/Game \0:/' | \
  grep -v -f - input.txt | \
  sed 's/^Game \([0-9]*\):.*$/\1/' | \
  tee /dev/stderr | \
  awk '{sum += $1} END {print sum}'
