defmodule Day3 do
  def parse_row(row, y) do
    parse_row(row, 0, y, %{})
  end

  def parse_row(<<d, rest::binary>>, x, y, symbolStore) when d in ?0..?9 do
    parse_row(rest, x + 1, y, symbolStore)
  end

  def parse_row(<<".", rest::binary>>, x, y, symbolStore) do
    parse_row(rest, x + 1, y, symbolStore)
  end

  def parse_row(<<s, rest::binary>>, x, y, symbolStore) do
    parse_row(rest, x + 1, y, Map.put(symbolStore, {x, y}, s))
  end

  def parse_row(<<>>, _x, _y, symbolStore) do
    %{symbols: symbolStore}
  end

  def parse_row_nums(row, y) do
    parse_row_nums(row, nil, 0, y, %{}, 0)
  end

  def parse_row_nums(<<d, rest::binary>>, nil, x, y, numStore, sinceFirstNum) when d in ?0..?9 do
    parse_row_nums(rest, d - ?0, x + 1, y, numStore, sinceFirstNum + 1)
  end

  def parse_row_nums(<<d, rest::binary>>, d0, x, y, numStore, sinceFirstNum)
      when d in ?0..?9 do
    parse_row_nums(rest, d0 * 10 + d - ?0, x + 1, y, numStore, sinceFirstNum + 1)
  end

  def parse_row_nums(<<char, rest::binary>>, d0, x, y, numStore, sinceFirstNum)
      when char not in ?0..?9 and d0 !== nil do
    numStore =
      Map.put(numStore, d0, %{x: (x - sinceFirstNum)..(x - 1), y: y})

    parse_row_nums(
      rest,
      nil,
      x + 1,
      y,
      numStore,
      0
    )
  end

  def parse_row_nums(<<char, rest::binary>>, nil, x, y, numStore, sinceFirstNum)
      when char not in ?0..?9 do
    parse_row_nums(rest, nil, x + 1, y, numStore, sinceFirstNum)
  end

  def parse_row_nums(<<>>, d0, x, y, numStore, sinceFirstNum) when d0 !== nil do
    numStore =
      Map.put(numStore, d0, %{x: (x - sinceFirstNum)..(x - 1), y: y})

    %{nums: numStore}
  end

  def parse_row_nums(<<>>, nil, _x, _y, numStore, _sinceFirst) do
    %{nums: numStore}
  end

  def is_member?(range, x) do
    case Enum.member?(range, x) do
      true -> true
      false -> is_member?(range, x + 1, 1)
    end
  end

  def is_member?(range, x, addition) when addition === 1 do
    case Enum.member?(range, x) do
      true -> true
      false -> is_member?(range, x - 2, -1)
    end
  end

  def is_member?(range, x, addition) when addition === -1 do
    case Enum.member?(range, x) do
      true -> true
      false -> false
    end
  end

  def parse_nums(seen, nums, idx) do
    if idx + 1 >= length(nums) do
      seen
    else
      {num, coords} = Enum.at(nums, idx)

      if Map.get(seen, num) === nil do
        parse_nums(
          Map.put(seen, num, coords),
          nums,
          idx + 1
        )
      else
        parse_nums(seen, nums, idx + 1)
      end
    end
  end

  def look_up(board) do
    symbols =
      board
      |> Enum.with_index()
      |> Enum.map(fn {row, y} -> parse_row(row, y) end)
      |> Enum.map(fn row -> row.symbols end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

    nums =
      board
      |> Enum.with_index()
      |> Enum.map(fn {row, y} -> parse_row_nums(row, y) end)
      |> Enum.map(fn row -> row.nums end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

    # if number from nums is within 1 x or y coordinate of symbol, add to sum
    within_symbol =
      symbols
      |> Enum.map(fn {key, _} ->
        {x, y} = key

        nums
        |> Enum.map(fn {num, coords} ->
          case coords.y + 1 === y or coords.y === y or coords.y - 1 === y do
            false ->
              {nil, coords}

            true ->
              range = Enum.to_list(coords.x)

              case is_member?(range, x) do
                true ->
                  {num, coords}

                false ->
                  {nil, coords}
              end
          end
        end)
        |> Enum.filter(fn {num, _} -> num !== nil end)
      end)
      |> Enum.reduce(fn acc, row -> acc ++ row end)

    parse_nums(%{}, within_symbol, 0)
    |> Map.keys()
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end

  def main do
    board =
      File.read!("test.txt")
      |> String.split("\n")

    look_up(board)
  end

  # save coordinates of every symbol that is not . and every full num
end

IO.puts(Day3.main())
