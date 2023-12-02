defmodule Advent1 do
  def match_nums_map(slice) do
    number = fn
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
      _ -> nil
    end

    number.(slice)
  end

  def loop_slice(_, _, forward, num) when forward === 5 do
    {num, forward}
  end

  def loop_slice(_, _, forward, num) when num !== nil do
    {num, forward}
  end

  def loop_slice(slice, idx, forward, num) do
    if String.length(slice) - 1 >= idx + forward do
      num = match_nums_map(String.slice(slice, idx, forward + 1))
      loop_slice(slice, idx, forward + 1, num)
    else
      {num, forward}
    end
  end

  def iter_text(chars, idx) do
    char = String.at(chars, idx)

    integer = fn char, chars, idx ->
      case Integer.parse("#{[char]}") do
        {num, ""} ->
          {num, idx + 1}

        :error ->
          {char, newForward} = loop_slice(chars, idx, 2, nil)
          newIdx = idx + newForward - 2

          potentialInt = fn char, idxNew, oldIdx ->
            case char do
              nil ->
                {nil, oldIdx + 1}

              num ->
                {num, idxNew}
            end
          end

          {int, index} = potentialInt.(char, newIdx, idx)
          {int, index}
      end
    end

    {myInt, newIdx} = integer.(char, chars, idx)

    if myInt !== nil do
      {myInt, newIdx}
    else
      if String.length(chars) - 1 > newIdx do
        iter_text(chars, newIdx)
      else
        {myInt, newIdx}
      end
    end
  end

  def iterate_with_jumps(chars, idx, numsList) do
    {num, newIdx} = iter_text(chars, idx)
    newNumsList = numsList ++ [num]

    if String.length(chars) > newIdx do
      iterate_with_jumps(chars, newIdx, newNumsList)
    else
      newNumsList
    end
  end

  def find_num(text) do
    filtered =
      iterate_with_jumps(text, 0, [])
      |> Enum.filter(fn num -> num !== nil end)

    first = Enum.at(filtered, 0)
    last = Enum.at(filtered, -1)

    elem(Integer.parse("#{first}#{last}"), 0)
  end

  def read_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      find_num(line)
    end)
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end

  def testting() do
    test =
      [
        %{val: "1abc2", exp: 12},
        %{val: "pqr3stu8vwx", exp: 38},
        %{val: "a1b2c3d4e5f", exp: 15},
        %{val: "treb7uchet", exp: 77},
        %{val: "two1nine", exp: 29},
        %{val: "one2three", exp: 13},
        %{val: "four5six", exp: 46},
        %{val: "4nineeightseven2", exp: 42},
        %{val: "7pqrstsixteen", exp: 76},
        %{val: "two1nine", exp: 29},
        %{val: "eightwothree", exp: 83},
        %{val: "abcone2threexyz", exp: 13},
        %{val: "xtwone3four", exp: 24},
        %{val: "4nineeightseven2", exp: 42},
        %{val: "zoneight234", exp: 14},
        %{val: "7pqrstsixteen", exp: 76},
        %{val: "one", exp: 11},
        %{val: "838mjxsleightnine", exp: 89},
        %{val: "seven4ninefivefourhxplgzfvsevenbbdjqc", exp: 77},
        %{val: "5mnhgg", exp: 55},
        %{val: "eighthree", exp: 83},
        %{val: "eightwothree", exp: 83},
        %{val: "twone", exp: 21},
        %{val: "1", exp: 11},
        %{val: "45fourmxzqzmpsixr3", exp: 43}
      ]

    total =
      test
      |> Enum.map(fn line ->
        nums = find_num(line.val)
        IO.puts("#{line.val} => #{nums}")
        nums
      end)
      |> Enum.reduce(0, fn num, acc -> acc + num end)

    IO.puts(total)
    IO.puts(total === 1019)
  end
end

IO.puts(Advent1.read_input())
