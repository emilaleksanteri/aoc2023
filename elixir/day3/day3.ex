defmodule Day3 do
  def parse_row(row, y) do
    parse_row(row, 0, y, %{}, %{})
  end

  def parse_row(<<d, rest::binary>>, x, y, symbolStore, gears) when d in ?0..?9 do
    parse_row(rest, x + 1, y, symbolStore, gears)
  end

  def parse_row(<<".", rest::binary>>, x, y, symbolStore, gears) do
    parse_row(rest, x + 1, y, symbolStore, gears)
  end

  def parse_row(<<"*", rest::binary>>, x, y, symbolStore, gears) do
    parse_row(rest, x + 1, y, Map.put(symbolStore, {x, y}, "*"), Map.put(gears, {x, y}, "*"))
  end

  def parse_row(<<s, rest::binary>>, x, y, symbolStore, gears) do
    parse_row(rest, x + 1, y, Map.put(symbolStore, {x, y}, s), gears)
  end

  def parse_row(<<>>, _x, _y, symbolStore, gears) do
    %{symbols: symbolStore, gears: gears}
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
    if idx === length(nums) - 1 do
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
    parsed =
      board
      |> Enum.with_index()
      |> Enum.map(fn {row, y} -> parse_row(row, y) end)
      |> Enum.map(fn row -> row end)

    symbols =
      parsed
      |> Enum.map(fn row -> row[:symbols] end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

    gears =
      parsed
      |> Enum.map(fn row -> row[:gears] end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

    nums =
      board
      |> Enum.with_index()
      |> Enum.map(fn {row, y} -> parse_row_nums(row, y) end)
      |> Enum.map(fn row -> row.nums end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

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

    gear_total =
      gears
      |> Enum.map(fn {coords, _} ->
        {x, y} = coords

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
      |> Enum.filter(fn nums -> length(nums) === 2 end)
      |> Enum.reduce(0, fn row, acc ->
        {num, _} = Enum.at(row, 0)
        {num2, _} = Enum.at(row, 1)

        acc + num * num2
      end)

    total_part_num =
      parse_nums(%{}, within_symbol, 0)
      |> Map.keys()
      |> Enum.reduce(0, fn num, acc ->
        acc + num
      end)

    %{parts_total: total_part_num, geat_total: gear_total}
  end

  def main do
    board =
      File.read!("test.txt")
      |> String.split("\n")

    totals = look_up(board)
    IO.puts("parts total: #{totals[:parts_total]}")
    IO.puts("gear total: #{totals[:geat_total]}")
  end
end

IO.puts(Day3.main())
