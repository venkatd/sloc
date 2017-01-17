defmodule Sloc.CLI do

  def main(_args \\ []) do
    # {opts, args, []} = OptionParser.parse(args, switches: [])
    System.cwd()
    |> Sloc.calculate()
    |> Sloc.Formatter.format()
    |> IO.puts()
  end

end
