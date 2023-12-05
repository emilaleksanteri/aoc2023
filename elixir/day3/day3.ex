# board:
# 467..114.....*
# ...*..........
# ..35..633.....
# ..*...#..1....
# 617*..........
# .....+.58.....
# .*592.........
# ......755.....
# ...$.*...1....
# .664.598......
# 721*206.990.97
# ...........*..
# ..........5...
# ..*4*.........

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

  def parse_row(<<>> = rest, x, y, symbolStore) do
    %{symbols: symbolStore}
  end

  def look_up_symbol(board) do
    look_up_symbol(board, 0, 0, %{symbols: %{}}, [], 0)
  end

  def nums_adjacent_to_symbol(board, x, y) do
    nums_adjacent_to_symbol(board, x, y, 0)
  end

  def nums_adjacent_to_symbol(board, x, y, sum) do
    # check if a number is within 3 x 3 of each symbol
    # if so, add to sum
    # if not, continue
  end

  def look_up_symbol(board, x, y, symbolStore, numsInGrid, sum) do
    symbols =
      board
      |> Enum.with_index()
      |> Enum.map(fn {row, y} -> parse_row(row, y) end)
      |> Enum.map(fn row -> row.symbols end)
      |> Enum.reduce(fn acc, row -> Map.merge(acc, row) end)

    # check if a number is within 3 x 3 of each symbol
    # if so, add to sum
    # if not, continue
    symbols |> Enum.each(fn {x, y} -> nums_adjacent_to_symbol(board, x, y) end)
  end

  def main do
    board =
      File.read!("test.txt")
      |> String.split("\n")

    look_up_symbol(board)
  end

  # save coordinates of every symbol that is not . and every full num
end

IO.puts(Day3.main())
