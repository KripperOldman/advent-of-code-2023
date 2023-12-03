function get_number = get_number(index, str)
  i = number_start(index, str);
  get_number = 0;

  while (i <= length(str) && is_digit(str(i)))
    get_number = get_number * 10 + str(i) - '0';
    i = i + 1;
  end
end
