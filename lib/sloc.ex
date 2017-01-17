defmodule Sloc.File do
  defstruct [:path, :name, :ext, count: :not_loaded]
end

defmodule Sloc.Dir do
  defstruct [:path, :name, count: :not_loaded, children: :not_loaded]
end

defmodule Sloc do

  def calculate(path) when is_binary(path) do
    path |> get_tree() |> calculate()
  end
  def calculate(%Sloc.File{path: path}=file) do
    %Sloc.File{file | count: line_count(path)}
  end
  def calculate(%Sloc.Dir{children: children}=dir) do
    calculated_children = for {name, item} <- children, into: %{}, do: {name, calculate(item)}
    count = calculated_children |> Enum.map(fn {_, item} -> item.count end) |> Enum.sum()
    %Sloc.Dir{dir | children: calculated_children, count: count}
  end

  def get_tree(path, opts \\ []) when is_binary(path) do
    cond do
      File.regular?(path) ->
        %Sloc.File{path: path, name: Path.basename(path), ext: get_ext(path)}
      File.dir?(path) ->
        children = for item <- get_children(path, opts), into: %{}, do: {item.name, item}
        %Sloc.Dir{path: path, name: Path.basename(path), children: children}
    end
  end

  def get_children(path, opts) do
    path
    |> File.ls!()
    |> Enum.map(&Path.join(path, &1))
    |> Enum.map(&get_tree/1)
    |> Enum.reject(&blacklisted?(&1, opts))
  end

  def blacklisted?(%Sloc.Dir{name: name}, _opts) when name in ~w(.git _build deps), do: true
  def blacklisted?(%Sloc.File{ext: ext}, _opts) when ext in ~w(png jpg jpeg), do: true
  def blacklisted?(_, _opts), do: false

  def line_count(filepath) do
    File.stream!(filepath)
    |> Stream.reject(&whitespace?/1)
    |> Enum.count()
  end

  defp whitespace?(string), do: Regex.match?(~r/^(\n|\s*)$/, string)

  defp get_ext(path) do
    case Path.extname(path) do
      "." <> ext -> ext
      "" -> ""
    end
  end

end
