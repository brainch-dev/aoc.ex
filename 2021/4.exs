import Enum

data = File.stream!("input/2021/4.txt") |> to_list

all = join(data)


[nums | boards] = String.split(all, "\n\n", trim: true)

nums = nums
|> String.split(",")
|> map(&String.to_integer/1)
|> IO.inspect

boards = map(boards, fn b ->
  b = b |> String.split() |> map(&String.to_integer/1)
  rows = b |> chunk_every(5) |> map(&MapSet.new/1)
  cols = rows |> zip |> map(& &1 |> Tuple.to_list() |> MapSet.new())
  cols ++ rows
end)

boards |> hd |> IO.inspect

game = Stream.iterate({nil, nums, boards}, fn {_, [x | rest], b} ->
  new_b = map(b, fn board ->
    map(board, fn r -> MapSet.delete(r, x) end)
  end)
  {x, rest, new_b}
end)

game
|> find(fn {_, _, b} -> any?(b, fn bd -> any?(bd, fn r -> empty?(r) end) end) end)
|> then(fn {x, _, bs} ->
  winner = find(bs, fn b -> any?(b, fn r -> empty?(r) end) end)
  remaining = winner |> take(5) |> map(&to_list/1) |> List.flatten() |> sum()
  remaining * x
end)
|> IO.inspect(label: "part 1")
