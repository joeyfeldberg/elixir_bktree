defmodule BkTreeTest do
  use ExUnit.Case
  doctest BkTree

  test "new" do
    assert BkTree.new("hello") == {"hello", %{}}
  end

  test "add" do
    node = BkTree.new("hello")
    new_node = BkTree.add(node, "help")

    assert new_node == {"hello", %{2 => {"help", %{}}}}
  end

  test "add many" do
    tree = BkTree.new("aaaa")
      |> BkTree.add("aabb")
      |> BkTree.add("ccaa")
      |> BkTree.add("atta")
      |> BkTree.add("tttt")
      |> BkTree.add("ccba")

      assert tree == {
        "aaaa", %{
          2 => {"aabb", %{
            4 => {"ccaa", %{}},
            3 => {"atta", %{}}
          }},
          4 => {"tttt", %{}},
          3 => {"ccba", %{}}
        }
      }
    end

  test "search" do
    tree = BkTree.new("aaaa")
      |> BkTree.add("aabb")
      |> BkTree.add("ccaa")
      |> BkTree.add("atta")
      |> BkTree.add("tttt")
      |> BkTree.add("ccba")

    res = BkTree.search(tree, "aa", 2)
    assert {2, "aaaa"} in res
    assert {2, "aabb"} in res
    assert {2, "ccaa"} in res
    assert {2, "atta"} in res
    assert Enum.count(res) == 4
  end
end
