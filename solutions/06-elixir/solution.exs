{:ok, contents} = File.read("input.txt")

gen_zero = contents \
            |> String.trim \
            |> String.split(",", trim: true) \
            |> Enum.map(&String.to_integer/1)
            |> Enum.reduce(%{}, fn (val, map) -> Map.update(map, val, 1, fn e_v -> e_v + 1 end) end)

defmodule Day6 do
  def produce_offspring(map, prev_gen) do
    new_borns   = Map.update(map, 8, prev_gen[0], fn _ -> prev_gen[0] end)
    reset_cycle = Map.update(new_borns, 6, prev_gen[0], fn e_v -> e_v + prev_gen[0] end)
    reset_cycle
  end

  def reduce_life(map, prev_gen, key) do
    updated_map = Map.update(map, (key - 1), prev_gen[key], fn e_v -> e_v + prev_gen[key] end)
    updated_map
  end

  def simulate_n_cycles(prev_gen, n) do
    if n == 0 do
      prev_gen
    else
      next_gen = Day6.progress_gen(prev_gen)
      simulate_n_cycles(next_gen, n - 1)
    end
  end

  def progress_gen(prev_gen) do
    next_gen = prev_gen
                |> Map.keys
                |> Enum.reduce(%{}, fn (key, map) -> cond do
                      key == 0 -> produce_offspring(map, prev_gen)
                      true -> reduce_life(map, prev_gen, key)
                    end
                 end)
    next_gen
  end
end

part_one = Day6.simulate_n_cycles(gen_zero, 80)
      |> Map.values
      |> Enum.sum

part_two = Day6.simulate_n_cycles(gen_zero, 256)
      |> Map.values
      |> Enum.sum


IO.puts("Part 1: ")
IO.inspect part_one

IO.puts("Part 2: ")
IO.inspect part_two
