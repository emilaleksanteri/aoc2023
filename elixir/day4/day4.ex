defmodule Day4 do
  def parse_row(row) do
    # row, currNum, card 
    # %{ cardId: int, nums: %{int,int}, winning: %{int, int}}
    parse_row(row, nil, %{nums: %{}, winning: %{}}, false)
  end

  def parse_row(<<num, rest::binary>>, nil, card, parseW) when num in ?0..?9 do
    parse_row(rest, num - ?0, card, parseW)
  end

  def parse_row(<<num, rest::binary>>, currNum, card, parseW) when num in ?0..?9 do
    parse_row(rest, currNum * 10 + num - ?0, card, parseW)
  end

  def new_card(card, currNum, parseW) do
    if parseW === true do
      put_in(card, [:winning, currNum], currNum)
    else
      put_in(card, [:nums, currNum], currNum)
    end
  end

  def parse_row(<<meh, rest::binary>>, nil, card, parseW) when meh not in ?0..9 do
    if meh == 124 do
      parse_row(rest, nil, card, true)
    else
      parse_row(rest, nil, card, parseW)
    end
  end

  def parse_row(<<meh, rest::binary>>, currNum, card, parseW) when meh not in ?0..?9 do
    newCard = new_card(card, currNum, parseW)

    if meh == 124 do
      parse_row(rest, nil, newCard, true)
    else
      parse_row(rest, nil, newCard, parseW)
    end
  end

  def parse_row(<<"">>, currNum, card, p) do
    new_card(card, currNum, p)
  end

  def parse_row(nil, nil, card, _p) do
    card
  end

  def parse_id(line) do
    parse_id(line, nil)
  end

  def parse_id(<<char, rest::binary>>, nil) when char not in ?0..?9 do
    parse_id(rest, nil)
  end

  def parse_id(<<int, rest::binary>>, nil) when int in ?0..?9 do
    parse_id(rest, int - ?0)
  end

  def parse_id(<<int, rest::binary>>, id) when int in ?0..?9 do
    parse_id(rest, id * 10 + int - ?0)
  end

  def parse_id(<<>>, id) do
    id
  end

  def calculate_winning(card) do
    wins = card.winning |> Map.keys()
    calculate_winning(wins, card.nums, 0, 0)
  end

  def calculate_winning([key | rest], nums, points, total) do
    if Map.has_key?(nums, key) and key !== nil do
      if total == 0 do
        calculate_winning(rest, nums, points + 1, total + 1)
      else
        calculate_winning(rest, nums, points * 2, total + 1)
      end
    else
      calculate_winning(rest, nums, points, total)
    end
  end

  def calculate_winning([], _nums, points, _total) do
    points
  end

  def main() do
    board =
      File.read!("input.txt")
      |> String.split("\n")

    board
    |> Enum.map(fn row ->
      splitAtId = String.split(row, ":")

      id = parse_id(Enum.at(splitAtId, 0))

      card =
        parse_row(Enum.at(splitAtId, 1))

      %{id: id, card: card}
    end)
    |> Enum.map(fn card ->
      %{id: card.id, card: card.card, w: calculate_winning(card.card)}
    end)
    |> Enum.reduce(0, fn card, acc ->
      case card do
        %{w: num} -> acc + num
        _ -> acc
      end
    end)
  end
end

IO.inspect(Day4.main())
