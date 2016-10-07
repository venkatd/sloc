defmodule Sloc do

  @path "../turtle/turtle-api/lib"

  def summary do
    files
    |> Stream.map(fn p -> {p, line_count(p)} end)
  end

  def files do
    ls_r!(@path)
    |> filter_by_extensions(["ex", "exs"])
  end

  def filter_by_extensions(files, extensions) do
    files
    |> Stream.filter(&has_ext?(&1, extensions))
  end

  def ls_r!(path \\ ".") do
    cond do
      File.regular?(path) -> [path]
      File.dir?(path) ->
        File.ls!(path)
        |> Stream.map(&Path.join(path, &1))
        |> Stream.map(&ls_r!/1)
        |> Stream.concat
      true -> []
    end
  end

  def path_ancestors(path), do: do_path_ancestors(path, [path])
  def do_path_ancestors(path, ancestors) do
    case Path.dirname(path) do
      ^path -> ancestors
      parent -> do_path_ancestors(parent, [parent | ancestors])
    end
  end

  def line_count(filepath) do
    File.stream!(filepath)
    |> Stream.reject(&Regex.match?(~r/^\s*$/, &1))
    |> Enum.count
  end

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
