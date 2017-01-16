defmodule Sloc.CLI do

  def main(args \\ []) do
    {opts, args, []} = OptionParser.parse(args, switches: [])
    System.cwd() |> Sloc.count() |> IO.puts()

    # System.cwd() |> Sloc.count() |> Sloc.summary() |> IO.puts()
  end

end
