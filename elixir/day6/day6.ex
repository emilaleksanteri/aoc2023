# spped is 1mm/mili-second
# btn hold increases speed by 1mm/mili-second
# we want to hold the button long enough to get over a min distance in remaining time
# for 7 mili-second race that needs to be 9mm
# hold for 2ms our speed is 2mm/ms for 5ms so we get 10mm
# best is to hold the button for 3 ms so that the boat has speed of 3mm/ms for 4 ms
# so we travel 3 * 4 = 12 mm this is the min to beat the race
# if we hold the button for 4 ms we travel 4 * 3 = 12 mm
# if we hold the button for 5 ms we travel 5 * 2 = 10 mm
# if we hold the button for 6 ms we travel 6 * 1 = 6 mm
# if we hold the button for 7 ms we travel 7 * 0 = 0 mm
# so we can beat this race in 4 different ways

# for all races, multiply all the ways to win nums together for final err score

defmodule Day6 do
  def parse_row(line) do
    parse_row(line, nil, [])
  end

  def parse_row(<<num, rest::binary>>, nil, acc) when num in ?0..?9 do
    parse_row(rest, num - ?0, acc)
  end

  def parse_row(<<num, rest::binary>>, currNum, acc) when num in ?0..?9 do
    parse_row(rest, currNum * 10 + num - ?0, acc)
  end

  def parse_row(<<char, rest::binary>>, currNum, acc)
      when char not in ?0..?9 and currNum != nil do
    parse_row(rest, nil, [currNum | acc])
  end

  def parse_row(<<char, rest::binary>>, curr, acc) when char not in ?0..?9 and curr == nil do
    parse_row(rest, nil, acc)
  end

  def parse_row(<<>>, currNum, acc) do
    [currNum | acc] |> Enum.reverse()
  end

  def till_first_win(time, hold_time, rec) do
    can_win = (time - hold_time) * hold_time > rec

    if can_win do
      hold_time
    else
      till_first_win(time, hold_time + 1, rec)
    end
  end

  def till_last_win(time, hold_time, rec) do
    can_win = (time - hold_time) * hold_time > rec

    if can_win do
      hold_time
    else
      till_last_win(time, hold_time - 1, rec)
    end
  end

  def list_nums_to_big_num(nums) do
    list_nums_to_big_num(nums, nil)
  end

  def list_nums_to_big_num([num | rest], acc) when acc == nil do
    list_nums_to_big_num(rest, Integer.to_string(num))
  end

  def list_nums_to_big_num([num | rest], acc) when acc != nil do
    list_nums_to_big_num(rest, acc <> Integer.to_string(num))
  end

  def list_nums_to_big_num([], acc) do
    String.to_integer(acc)
  end

  def solve_wins(times_to_wins) do
    times_to_wins
    |> Enum.map(fn {time, to_win} ->
      till_first = till_first_win(time, 0, to_win)
      till_last = till_last_win(time, time, to_win)
      till_last - till_first + 1
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def main() do
    rows =
      File.read!("input.txt")
      |> String.split("\n")

    times = Enum.at(rows, 0) |> String.split(":") |> Enum.at(1) |> parse_row()
    to_wins = Enum.at(rows, 1) |> String.split(":") |> Enum.at(1) |> parse_row()
    times2 = times |> list_nums_to_big_num()
    to_wins2 = to_wins |> list_nums_to_big_num()

    times_to_wins = Enum.zip(times, to_wins)
    times_to_wins2 = Enum.zip([times2], [to_wins2])

    err_margin = solve_wins(times_to_wins)
    err_margin_2 = solve_wins(times_to_wins2)

    IO.puts("Error margin: #{err_margin}, err margin 2: #{err_margin_2}")
  end
end

Day6.main()
