defmodule Day2 do
  def main() do
    total =
      File.read!("input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        lineTotal =
          line
          |> String.split(":", trim: true)
          |> Enum.take(-1)
          |> Enum.map(fn str ->
            allCommas = String.replace(str, ";", ",")
            colours = String.split(allCommas, ",", trim: true)

            coloursVals =
              Enum.map(colours, fn colour ->
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

            newColoursTable =
              Enum.reduce(coloursVals, %{red: 0, green: 0, blue: 0}, fn colour, tempStore ->
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

            newColoursTable
          end)
          |> Enum.map(fn colours ->
            colours.red * colours.blue * colours.green
          end)

        lineTotal = Enum.reduce(lineTotal, 0, fn num, acc -> acc + num end)
        lineTotal
      end)

    total = Enum.reduce(total, 0, fn num, acc -> acc + num end)

    IO.puts(total)
  end
end

IO.puts(Day2.main())

