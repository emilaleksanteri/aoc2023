defmodule Day2 do
  def main() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(":", trim: true)
      |> Enum.take(-1)
      |> Enum.map(fn str ->
        String.replace(str, ";", ",")
        |> String.split(",", trim: true)
        |> Enum.map(fn colour ->
          numCol = String.split(colour, " ", trim: true)
          num = String.to_integer(Enum.at(numCol, 0))
          col = Enum.at(numCol, 1)

          case col do
            "red" ->
              %{red: num}

            "green" ->
              %{green: num}

            "blue" ->
              %{blue: num}
          end
        end)
        |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn colour, tempStore ->
          case colour do
            %{red: _} ->
              if tempStore.red < colour.red do
                %{tempStore | red: colour.red}
              else
                tempStore
              end

            %{green: _} ->
              if tempStore.green < colour.green do
                %{tempStore | green: colour.green}
              else
                tempStore
              end

            %{blue: _} ->
              if tempStore.blue < colour.blue do
                %{tempStore | blue: colour.blue}
              else
                tempStore
              end
          end
        end)
      end)
      |> Enum.map(fn colours ->
        colours.red * colours.blue * colours.green
      end)
      |> Enum.reduce(0, fn num, acc -> acc + num end)
    end)
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end
end

IO.puts(Day2.main())

