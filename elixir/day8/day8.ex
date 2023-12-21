# TODO 
# fix string concat on parse_input, from <> to #{}#{}
# finish rest of parse_input, check of edge cases fr

defmodule Day8 do
  def parse_input(input) do
    parse_input(input, nil, 0, %{steps: nil, routes: %{}})
  end

  # get dem steps
  def parse_input(<<"\n", rest::binary>>, steps, 0, acc) do
    parse_input(rest, nil, 1, Map.put(acc, :steps, steps), nil)
  end

  def parse_input(<<curr, rest::binary>>, nil, 0, acc) when <<curr>> == "L" or <<curr>> == "R" do
    parse_input(rest, <<curr>>, 0, acc)
  end

  def parse_input(<<curr, rest::binary>>, steps, 0, acc)
      when <<curr>> == "L" or <<curr>> == "R" do
    parse_input(rest, "#{steps}#{<<curr>>}", 0, acc)
  end

  # move to start new line: key
  def parse_input(<<"\n", rest::binary>>, nil, row, acc, nil) when row != 0 do
    parse_input(rest, nil, row + 1, acc, nil)
  end

  # key done
  def parse_input(<<"(", rest::binary>>, nil, row, acc, key) do
    parse_input(rest, nil, row, acc, key, true)
  end

  def parse_input(<<curr, rest::binary>>, nil, row, acc, key) when curr not in ?A..?Z do
    parse_input(rest, nil, row, acc, key)
  end

  def parse_input(<<curr, rest::binary>>, nil, row, acc, nil) when curr in ?A..?Z do
    parse_input(rest, nil, row, acc, <<curr>>)
  end

  def parse_input(<<curr, rest::binary>>, nil, row, acc, key) when curr in ?A..?Z do
    parse_input(rest, nil, row, acc, "#{key}#{<<curr>>}")
  end

  # done w everything
  def parse_input(<<>>, _, _, acc, _) do
    acc
  end

  # get L and R
  def parse_input(<<",", rest::binary>>, code, row, acc, key, true) do
    new_acc = put_in(acc, [:routes, key], %{:L => code})
    parse_input(rest, nil, row, new_acc, key, true)
  end

  # L and R done
  def parse_input(<<")", rest::binary>>, code, row, acc, key, true) do
    new_acc = put_in(acc, [:routes, key], Map.put(acc.routes[key], :R, code))
    parse_input(rest, nil, row, new_acc, nil)
  end

  def parse_input(<<curr, rest::binary>>, nil, row, acc, key, true) when curr not in ?A..?Z do
    parse_input(rest, nil, row, acc, key, true)
  end

  def parse_input(<<curr, rest::binary>>, code, row, acc, key, true) when curr in ?A..?Z do
    parse_input(rest, "#{code}#{<<curr>>}", row, acc, key, true)
  end

  def parse_input(<<curr, rest::binary>>, nil, row, acc, key, true) when curr in ?A..?Z do
    parse_input(rest, <<curr>>, row, acc, key, true)
  end

  def main() do
    rows =
      File.read!("test.txt")

    IO.puts(rows)
    parsed = parse_input(rows)
    IO.puts("parsed: #{inspect(parsed)}")
  end
end

Day8.main()
