## PART 1
defmodule Day7 do
  def bin_int_to_int(bin_int) do
    if bin_int != nil do
      res = Integer.parse(bin_int)

      case res do
        {int, ""} -> int
        _ -> 0
      end
    end
  end

  def get_hand_type(hand) do
    get_hand_type(hand, %{})
  end

  def get_hand_type(<<char, rest::binary>>, typecount) do
    as_string = <<char::utf8>>

    case Map.has_key?(typecount, as_string) do
      true ->
        get_hand_type(rest, Map.update!(typecount, as_string, &(&1 + 1)))

      false ->
        get_hand_type(rest, Map.put(typecount, as_string, 1))
    end
  end

  def get_hand_type(<<>>, typecount) do
    if typecount != %{} do
      typecount
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sort_by(& &1, :desc)
    else
      0
    end
  end

  def hand_type_calculated(hand_type) do
    if hand_type != 0 do
      case hand_type do
        [5] -> 1
        [4, 1] -> 2
        [3, 2] -> 3
        [3, 1, 1] -> 4
        [2, 2, 1] -> 5
        [2, 1, 1, 1] -> 6
        [1, 1, 1, 1, 1] -> 7
      end
    end
  end

  def needs_to_be_parsed_again?(groups) do
    Enum.any?(Map.values(groups), fn x -> length(x) > 1 end)
  end

  def parse_card_on_rank(pool, card_idx, acc) do
    cards = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

    new_cards =
      Enum.map(pool, fn c ->
        new_s = Enum.find_index(cards, &(&1 == String.at(c.hand, card_idx)))
        %{hand: c.hand, bid: c.bid, strength: c.strength, new_s: new_s}
      end)

    groups = Enum.group_by(new_cards, & &1.new_s)

    if needs_to_be_parsed_again?(groups) do
      groups = groups |> Enum.sort(fn {k1, _}, {k2, _} -> k1 > k2 end)

      Enum.reduce(groups, [], fn {_, v}, acc ->
        if length(v) > 1 do
          acc ++ parse_card_on_rank(v, card_idx + 1, [])
        else
          acc ++ v
        end
      end)
    else
      groups
      |> Map.values()
      |> Enum.reduce(acc, fn x, acc -> acc ++ x end)
      |> Enum.sort_by(& &1.new_s, :desc)
    end
  end

  def move_cards(cards_at_rank, card_idx, acc) do
    ranked = parse_card_on_rank(cards_at_rank, card_idx, [])
    acc ++ ranked
  end

  def parse_pool(pool, return_pool) do
    move_cards(pool, 0, return_pool)
  end

  def parse_pools(pools) do
    parse_pools(pools, [])
  end

  def parse_pools([pool | rest], acc) do
    if length(pool) == 1 do
      parse_pools(rest, acc ++ pool)
    else
      parse_pools(rest, acc ++ parse_pool(pool, []))
    end
  end

  def parse_pools([], acc) do
    acc
  end

  def find_winning_hand(hands) do
    pools =
      Enum.group_by(hands, & &1.strength)
      |> Enum.sort_by(& &1, :desc)
      |> Enum.map(fn {_, v} -> Enum.sort_by(v, & &1.bid, :desc) end)

    parse_pools(pools)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      %{hand: x.hand, bid: x.bid, strength: x.strength, multiplier: i + 1}
    end)
    |> Enum.reduce(0, fn x, acc -> acc + x.bid * x.multiplier end)
  end

  def get_hand(hand) do
    newHand =
      hand
      |> String.split(" ")
      |> Enum.at(0)

    bid =
      hand
      |> String.split(" ")
      |> Enum.at(1)
      |> bin_int_to_int()

    hand_type = get_hand_type(newHand) |> hand_type_calculated()

    %{hand: newHand, bid: bid, strength: hand_type}
  end

  def main() do
    rows =
      File.read!("input.txt")
      |> String.split("\n")

    hands =
      rows
      |> Enum.map(&get_hand/1)
      |> Enum.filter(fn x -> x.bid != nil end)

    win = find_winning_hand(hands)
    IO.puts(win)
  end
end

## PART 2
defmodule Part2 do
  def bin_int_to_int(bin_int) do
    if bin_int != nil do
      res = Integer.parse(bin_int)

      case res do
        {int, ""} -> int
        _ -> 0
      end
    end
  end

  def j_add_to_highest_amt(typecount, highest_amts, num_of_js) do
    cards = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

    highest_amts =
      Enum.sort_by(highest_amts, fn {k, _} -> Enum.find_index(cards, &(&1 == k)) end)

    typecount = Map.delete(typecount, "J")
    {k, _} = Enum.at(highest_amts, 0)
    Map.update!(typecount, k, &(&1 + num_of_js))
  end

  def return_new_typecoutn_no_j(typecount) do
    num_of_js = Map.get(typecount, "J")

    if num_of_js == 5 do
      typecount
    else
      highest_amts =
        Enum.filter(typecount, fn {k, v} ->
          v == Enum.max(Map.values(typecount)) and k !== "J"
        end)

      if length(highest_amts) == 1 do
        {k, _} = Enum.at(highest_amts, 0)
        typecount = Map.delete(typecount, "J")
        Map.update!(typecount, k, &(&1 + num_of_js))
      else
        if highest_amts == [] do
          j_add_to_highest_amt(typecount, typecount, num_of_js)
        else
          j_add_to_highest_amt(typecount, highest_amts, num_of_js)
        end
      end
    end
  end

  def get_hand_type(hand) do
    get_hand_type(hand, %{})
  end

  def get_hand_type(<<char, rest::binary>>, typecount) do
    as_string = <<char::utf8>>

    case Map.has_key?(typecount, as_string) do
      true ->
        get_hand_type(rest, Map.update!(typecount, as_string, &(&1 + 1)))

      false ->
        get_hand_type(rest, Map.put(typecount, as_string, 1))
    end
  end

  def get_hand_type(<<>>, typecount) do
    if typecount != %{} do
      if Map.has_key?(typecount, "J") do
        return_new_typecoutn_no_j(typecount)
        |> Enum.map(fn {_, v} -> v end)
        |> Enum.sort_by(& &1, :desc)
      else
        typecount
        |> Enum.map(fn {_, v} -> v end)
        |> Enum.sort_by(& &1, :desc)
      end
    else
      0
    end
  end

  def hand_type_calculated(hand_type) do
    if hand_type != 0 do
      case hand_type do
        [5] -> 1
        [4, 1] -> 2
        [3, 2] -> 3
        [3, 1, 1] -> 4
        [2, 2, 1] -> 5
        [2, 1, 1, 1] -> 6
        [1, 1, 1, 1, 1] -> 7
      end
    end
  end

  def needs_to_be_parsed_again?(groups) do
    Enum.any?(Map.values(groups), fn x -> length(x) > 1 end)
  end

  def parse_card_on_rank(pool, card_idx, acc) do
    cards = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

    new_cards =
      Enum.map(pool, fn c ->
        new_s = Enum.find_index(cards, &(&1 == String.at(c.hand, card_idx)))
        %{hand: c.hand, bid: c.bid, strength: c.strength, new_s: new_s}
      end)

    groups = Enum.group_by(new_cards, & &1.new_s)

    if needs_to_be_parsed_again?(groups) do
      groups = groups |> Enum.sort(fn {k1, _}, {k2, _} -> k1 > k2 end)

      Enum.reduce(groups, [], fn {_, v}, acc ->
        if length(v) > 1 do
          acc ++ parse_card_on_rank(v, card_idx + 1, [])
        else
          acc ++ v
        end
      end)
    else
      groups
      |> Map.values()
      |> Enum.reduce(acc, fn x, acc -> acc ++ x end)
      |> Enum.sort_by(& &1.new_s, :desc)
    end
  end

  def move_cards(cards_at_rank, card_idx, acc) do
    ranked = parse_card_on_rank(cards_at_rank, card_idx, [])
    acc ++ ranked
  end

  def parse_pool(pool, return_pool) do
    move_cards(pool, 0, return_pool)
  end

  def parse_pools(pools) do
    parse_pools(pools, [])
  end

  def parse_pools([pool | rest], acc) do
    if length(pool) == 1 do
      parse_pools(rest, acc ++ pool)
    else
      parse_pools(rest, acc ++ parse_pool(pool, []))
    end
  end

  def parse_pools([], acc) do
    acc
  end

  def find_winning_hand(hands) do
    pools =
      Enum.group_by(hands, & &1.strength)
      |> Enum.sort_by(& &1, :desc)
      |> Enum.map(fn {_, v} -> Enum.sort_by(v, & &1.bid, :desc) end)

    parse_pools(pools)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      %{hand: x.hand, bid: x.bid, strength: x.strength, multiplier: i + 1}
    end)
    |> Enum.reduce(0, fn x, acc -> acc + x.bid * x.multiplier end)
  end

  def get_hand(hand) do
    newHand =
      hand
      |> String.split(" ")
      |> Enum.at(0)

    bid =
      hand
      |> String.split(" ")
      |> Enum.at(1)
      |> bin_int_to_int()

    hand_type = get_hand_type(newHand) |> hand_type_calculated()

    %{hand: newHand, bid: bid, strength: hand_type}
  end

  def main() do
    rows =
      File.read!("input.txt")
      |> String.split("\n")

    hands =
      rows
      |> Enum.map(&get_hand/1)
      |> Enum.filter(fn x -> x.bid != nil end)

    win = find_winning_hand(hands)
    IO.puts(win)
  end
end

Day7.main()
Part2.main()
