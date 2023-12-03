partSum = 0;
lines = {};
sym_flags = {};

i = 1;
while ((line = fgetl(stdin())) != -1)
  lines(i) = line;
  sym_flags(i) = (line != '.') & ((line < '0') | (line > '9'));

  i = i + 1;
end

disp(lines);
disp(sym_flags);

for i = 2:length(lines)-1
  disp("");
  prev_line = lines(1,i-1){1};
  line = lines(1,i){1};
  next_line = lines(1,i+1){1};
  flags = sym_flags(1,i){1};

  disp(prev_line);
  disp(line);
  disp(next_line);

  for j = 2:length(line)-1
    flag = flags(j);

    if (flag)
      printf("\n\n");
      printf("Flag at %d, %d\n", j, i);
      printf("%c %c %c\n", prev_line(j-1), prev_line(j), prev_line(j+1));
      printf("%c %c %c\n", line(j-1), line(j), line(j+1));
      printf("%c %c %c\n", next_line(j-1), next_line(j), next_line(j+1));
      printf("\n\n");

      % Check left
      if (is_digit(line(j-1)))
        part = get_number(j-1, line)
        partSum = partSum + part
      end

      % Check right
      if (is_digit(line(j+1)))
        part = get_number(j+1, line)
        partSum = partSum + part
      end

      % Check top
      top_left = is_digit(prev_line(j-1));
      top_center = is_digit(prev_line(j));
      top_right = is_digit(prev_line(j+1));

      if (top_center)
        part = get_number(j, prev_line)
        partSum = partSum + part
      else
        if (top_left)
          part = get_number(j-1, prev_line)
          partSum = partSum + part
        end

        if (top_right)
          part = get_number(j+1, prev_line)
          partSum = partSum + part
        end
      end

      % Check bottom
      bottom_left = is_digit(next_line(j-1));
      bottom_center = is_digit(next_line(j));
      bottom_right = is_digit(next_line(j+1));

      if (bottom_center)
        part = get_number(j, next_line)
        partSum = partSum + part
      else
        if (bottom_left)
          part = get_number(j-1, next_line)
          partSum = partSum + part
        end

        if (bottom_right)
          part = get_number(j+1, next_line)
          partSum = partSum + part
        end
      end
    end
  end
end

disp(partSum);
