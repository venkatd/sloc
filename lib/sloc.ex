defmodule Sloc do

  def summary(n, _) when is_number(n), do: ""
  def summary(tree, indention \\ 0) do
    pairs = tree
    |> Enum.map(fn {name, subtree} -> {name, subtree, total(subtree)} end)
    |> Enum.sort_by(fn {_, subtree, tot} -> -tot end)
    |> Enum.map_join("\n", fn {name, subtree, tot} ->
      result = String.duplicate("  ", indention) <> "#{name} (#{tot})"
      subresult = summary(subtree, indention + 1)
      case whitespace?(subresult) do
        true -> result
        false -> result <> "\n" <> subresult
      end
    end)
  end

  def count(path, opts \\ []) do
    cond do
      File.regular?(path) ->
        line_count(path)
      File.dir?(path) ->
        for el <- File.ls!(path), into: %{} do
          {el, count(Path.join(path, el))}
        end
    end
  end

  def total(tree) when is_map(tree) do
    tree
    |> Enum.map(fn {_, t} -> total(t) end)
    |> Enum.sum()
  end
  def total(n) when is_number(n), do: n

  def line_count(filepath) do
    File.stream!(filepath)
    |> Stream.reject(&whitespace?/1)
    |> Enum.count()
  end

  defp whitespace?(string), do: Regex.match?(~r/^(\n|\s*)$/, string)

  defp has_ext?(path, extensions) do
    Enum.member?(extensions, get_ext(path))
  end

  defp get_ext(path) do
    case Path.extname(path) do
      "." <> ext -> ext
      "" -> ""
    end
  end

end
