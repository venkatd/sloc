defmodule Sloc.Util do

  def set_in(map, keypath, value) do
    force_update_in map, keypath, fn _ -> value end
  end

  def force_update_in(nil, [key], updater), do: force_update_in(%{}, [key], updater)
  def force_update_in(map, [key], updater) do
    old_value = Map.get(map, key)
    new_value = updater.(old_value)
    Map.put(map, key, new_value)
  end
  def force_update_in(map, [key | rest], updater) do
    submap = Map.get(map, key)
    Map.put(map, key, force_update_in(submap, rest, updater))
  end

end
