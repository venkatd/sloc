defmodule UtilTest do
  use ExUnit.Case
  doctest Sloc

  import Sloc.Util, only: [set_in: 3, force_update_in: 3]

  describe "set_in" do
    test "creates the path" do
      assert set_in(%{}, [:a, :b], 5) == %{a: %{b: 5}}
    end

    test "replaces a value" do
      assert set_in(%{a: %{b: 5, c: 9}}, [:a, :b], 33) == %{a: %{b: 33, c: 9}}
    end
  end

  describe "force_update_in" do
    test "works with a fn" do
      assert force_update_in(%{a: %{b: 9}}, [:a, :b], fn x -> x * 2 end) == %{a: %{b: 18}}
    end
  end

end
