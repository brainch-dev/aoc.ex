data = File.stream!("input/2021/4.txt") |> Enum.to_list

all = Enum.join(data)

[nums | boards] = String.split(all, "\n\n", trim: true)

nums = nums
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> IO.inspect
