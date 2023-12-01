def match_nums_map(map, slice) do
  case map[slice] do
    num -> num
    nil -> nil
  end
end

def find_num(text) do
  currNum = nil

  nums =
    text
    |> String.to_charlist()
    |> Enum.with_index(fn char, idx ->
      case Integer.parse("#{[char]}") do
        {num, ""} ->
          num

        {:error, _} ->
          numsMap = %{
            one: 1,
            two: 2,
            three: 3,
            four: 4,
            five: 5,
            six: 6,
            seven: 7,
            eight: 8,
            nine: 9
          }

          case match_nums_map(numsMap, String.slice(text, idx..(idx + 2))) do
            num -> num
            nil -> nil
          end

          case match_nums_map(numsMap, String.slice(text, idx..(idx + 2))) do
            num -> num
            nil -> nil
          end

          case match_nums_map(numsMap, String.slice(text, idx..(idx + 2))) do
            num -> num
            nil -> nil
          end

          case match_nums_map(numsMap, String.slice(text, idx..(idx + 2))) do
            num -> num
            nil -> nil
          end
      end
    end)
    |> Enum.filter(fn num -> num != nil end)

  first = Enum.at(nums, 0)
  last = Enum.at(nums, -1)

  Integer.parse("#{first}#{last}")
  |> elem(0)
end

def read_input() do
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    find_num(line)
  end)
  |> Enum.reduce(0, fn num, acc -> acc + num end)
end

IO.puts(read_input())
