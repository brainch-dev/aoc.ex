#! /usr/bin/env elixir

defmodule B do
  import Enum

  def wins?(b), do: any?(b, fn r -> empty?(r) end)
  def score(b), do: b |> reduce(&MapSet.union/2) |> sum()

  def run do
    [nums | boards] = "input/2021/4.txt" |> File.read!() |> String.split("\n\n", trim: true)

    nums =
      nums
      |> String.split(",")
      |> map(&String.to_integer/1)

    boards =
      map(boards, fn b ->
        b = b |> String.split() |> map(&String.to_integer/1)
        rows = chunk_every(b, 5)
        cols = zip_with(rows, & &1)
        map(cols ++ rows, &MapSet.new/1)
      end)

    game =
      Stream.iterate({nil, nums, boards}, fn {_, [x | rest], b} ->
        new_b =
          map(b, fn board ->
            map(board, fn r -> MapSet.delete(r, x) end)
          end)

        {x, rest, new_b}
      end)

    game
    |> find(fn {_, _, b} -> any?(b, &wins?/1) end)
    |> then(fn {x, _, bs} -> bs |> find(&wins?/1) |> score() |> then(&(&1 * x)) end)
    |> IO.inspect(label: "part 1")

    [running, finished] = Stream.chunk_by(game, fn {_, _, b} -> all?(b, &wins?/1) end) |> take(2)

    loser_index =
      running
      |> to_list()
      |> List.last()
      |> elem(2)
      |> find_index(fn bd -> !wins?(bd) end)

    {nxt, _, boards} = at(finished, 0)

    boards
    |> at(loser_index)
    |> score()
    |> then(&(&1 * nxt))
    |> IO.inspect(label: "part 2")
  end
end

B.run()
