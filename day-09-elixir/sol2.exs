defmodule Solution do
  def process_line(line) do
    String.split(line) |> Enum.map(&String.to_integer/1)
  end

  def diff_once(nums) do
    Enum.zip(nums, Enum.drop(nums, 1))
    |> Enum.map(fn {a, b} -> b - a end)
  end

  def diff(nums) do
    diff(nums, [])
  end

  def diff(nums, curr) do
    if Enum.all?(nums, &(&1 == 0)) do
      [nums | curr]
    else
      diff(diff_once(nums), [nums | curr])
    end
  end

  def extrapolate(diffed) do
    Enum.reduce(diffed, 0, fn x, acc -> List.first(x) - acc end)
  end
end

sum =
  IO.stream()
  |> Stream.map(&Solution.process_line/1)
  |> Stream.map(&Solution.diff/1)
  |> Stream.map(&Solution.extrapolate/1)
  |> Enum.sum()

IO.inspect(sum)
