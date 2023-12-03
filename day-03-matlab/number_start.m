function number_start = number_start(index, str)
  number_start = index;
  while (number_start - 1 > 0 && is_digit(str(number_start - 1)))
    number_start = number_start - 1;
  end
end
