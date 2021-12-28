#! /usr/bin/env elixir
defmodule Aoc.SevenSegmentSearch do
  def parse(text) do
    text
    |> String.split(~r"[^a-g]+", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.chunk_every(14)
    |> Enum.map(&Enum.split(&1, 10))
  end

  def part_1(data) do
    data
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.count(&(length(&1) in [2, 3, 4, 7]))
  end

  def part_2(data) do
    digits = ~w[ abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg ]c
    freqs = digits |> List.flatten() |> Enum.frequencies()
    original = for digit <- digits, do: digit |> Enum.map(&Map.get(freqs, &1)) |> Enum.sort()

    data
    |> Enum.map(fn {digits, input} ->
      local_frequencies = digits |> List.flatten() |> Enum.frequencies()

      input
      |> Enum.map(fn digit ->
        print = digit |> Enum.map(&Map.get(local_frequencies, &1)) |> Enum.sort()
        Enum.find_index(original, &match?(^print, &1))
      end)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end
end
