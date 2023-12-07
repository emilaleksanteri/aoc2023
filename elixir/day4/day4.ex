defmodule Day4 do
  def new_card(card, currNum, parseW) do
    if parseW === true do
      put_in(card, [:winning, currNum], currNum)
    else
      put_in(card, [:nums, currNum], currNum)
    end
  end

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

  def parse_row(<<meh, rest::binary>>, nil, card, parseW) do
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
    calculate_winning(wins, card.nums, 0, 0, 0)
  end

  def calculate_winning([key | rest], nums, points, total, num_of_matches) do
    if Map.has_key?(nums, key) and key !== nil do
      if total == 0 do
        calculate_winning(rest, nums, points + 1, total + 1, num_of_matches + 1)
      else
        calculate_winning(rest, nums, points * 2, total + 1, num_of_matches + 1)
      end
    else
      calculate_winning(rest, nums, points, total, num_of_matches)
    end
  end

  def calculate_winning([], _nums, points, _total, num_of_matches) do
    {points, num_of_matches}
  end

  def update_my_copies(copies, num) do
    if Map.has_key?(copies, num) do
      Map.update!(copies, num, fn x -> x + 1 end)
    else
      Map.put(copies, num, 1)
    end
  end

  def add_winning(copies, copies_of_me, idx, winning_num, my_id) do
    if idx > winning_num do
      copies
    else
      curr_id = idx + my_id

      if Map.has_key?(copies, curr_id) do
        add_winning(
          Map.update!(copies, curr_id, fn x -> x + copies_of_me end),
          copies_of_me,
          idx + 1,
          winning_num,
          my_id
        )
      else
        add_winning(
          Map.put(copies, curr_id, copies_of_me),
          copies_of_me,
          idx + 1,
          winning_num,
          my_id
        )
      end
    end
  end

  def cal_copies(copies, winning_cards, idx) when idx > length(winning_cards) + 1 do
    copies
  end

  def cal_copies(copies, winning_cards, idx) do
    new_curr = Enum.at(winning_cards, idx)

    if new_curr == nil do
      copies
    else
      my_copies = update_my_copies(copies, new_curr.id)

      if new_curr.num_of_matches == 0 do
        cal_copies(my_copies, winning_cards, idx + 1)
      else
        new_copies =
          add_winning(
            my_copies,
            Map.get(my_copies, new_curr.id),
            1,
            new_curr.num_of_matches,
            new_curr.id
          )

        cal_copies(new_copies, winning_cards, idx + 1)
      end
    end
  end

  def main() do
    board =
      File.read!("input.txt")
      |> String.split("\n")

    cards =
      board
      |> Enum.map(fn row ->
        splitAtId = String.split(row, ":")

        id = parse_id(Enum.at(splitAtId, 0))

        card =
          parse_row(Enum.at(splitAtId, 1))

        %{id: id, card: card}
      end)
      |> Enum.map(fn card ->
        {points, num_of_matches} = calculate_winning(card.card)
        %{id: card.id, card: card.card, w: points, num_of_matches: num_of_matches}
      end)
      |> Enum.filter(fn card ->
        card.id != nil
      end)

    total_points =
      cards
      |> Enum.reduce(0, fn card, acc ->
        case card do
          %{w: num} -> acc + num
          _ -> acc
        end
      end)

    %{
      total_points: total_points,
      total_cards:
        cal_copies(%{}, cards, 0)
        |> Enum.reduce(0, fn {_, num}, acc -> acc + num end)
    }
  end
end

IO.inspect(Day4.main())
