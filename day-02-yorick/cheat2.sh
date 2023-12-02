sed 's/^Game \([0-9]*\): /\1; /g' input.txt |
	awk -F';' '
  {
    for (i = 2; i <= NF; ++i) {
      print $1 "," $i
    }
  }' |
	awk -F',' '
    {
      for (i = 2; i <= NF; ++i) {
        print $1 "," $i
      }
    }' |
	awk -F',' '
	 NR == 1 {max_red = 0; max_green = 0; max_blue = 0; current_game=$1}
   $1 != current_game {
     cube_power = max_red * max_green * max_blue;
     print cube_power, current_game, max_red, max_green, max_blue;
     current_game = $1;
     max_red = 0;
     max_green = 0;
     max_blue = 0;
   }
   END {
     cube_power = max_red * max_green * max_blue;
     print cube_power, current_game, max_red, max_green, max_blue;
   }
	 /red/ {
	   gsub(/[^0-9]/, "", $2);
	   if (int($2) > max_red) {
       max_red = int($2);
	   }
	 }
	 /green/ {
	   gsub(/[^0-9]/, "", $2);
	   if (int($2) > max_green) {
       max_green = int($2);
	   }
	 }
	 /blue/ {
	   gsub(/[^0-9]/, "", $2);
	   if (int($2) > max_blue) {
       max_blue = int($2);
	   }
	 }
	 ' |
  tee /dev/stderr |
  cut -d' ' -f1 |
  awk '{sum += $1} END {print sum}'
