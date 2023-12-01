defmodule FindNums do
  def find_num(text) do
    nums =
      text
      |> String.to_charlist()
      |> Enum.map(fn char ->
        case Integer.parse("#{[char]}") do
          {num, ""} -> num
          _ -> nil
        end
      end)
      |> Enum.filter(fn num -> num != nil end)

    first = Enum.at(nums, 0)
    last = Enum.at(nums, -1)

    Integer.parse("#{first}#{last}")
    |> elem(0)
  end
end

defmodule ReadInput do
  def read_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      FindNums.find_num(line)
    end)
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end
end

IO.puts(ReadInput.read_input())
