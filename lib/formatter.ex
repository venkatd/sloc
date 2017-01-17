defmodule Sloc.Formatter do

  def format(item) do
    do_format(item, 0)
  end

  def do_format(%Sloc.File{name: name, count: count}, n) do
    indent("#{name} (#{count})", n)
  end
  def do_format(%Sloc.Dir{name: name, count: count, children: children}, n) do
    lines = children
      |> Enum.sort_by(fn {_n, item} -> -item.count end)
      |> Enum.map(fn {_n, item} -> do_format(item, n + 1) end)

    lines = [indent("#{name}/ (#{count})", n) | lines]
    Enum.join(lines, "\n")
  end

  def indent(string, n) do
    String.duplicate("  ", n) <> string
  end

end
