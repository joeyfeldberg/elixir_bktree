defmodule BkTree do
    @doc ~S"""
    BK tree that allows adding words and searching for closest word

    ## Examples:
        iex> tree = BkTree.new("hello") |> BkTree.add("bellow")
        {"hello", %{2 => {"bellow", %{}}}}
        iex> BkTree.search(tree, "mellow", 1)
        [{1, "bellow"}]
        iex> BkTree.search(tree, "mellow", 2)
        [{2, "hello"}, {1, "bellow"}]
    """

  def new(word) do
    {word, Map.new}
  end

  def add({parent_word, children}, word) when map_size(children) == 0 do
    new_distance = Distance.levenshtein(parent_word, word)
    {parent_word, %{new_distance => BkTree.new(word)}}
  end

  def add({parent_word, children}, word) do
    new_distance = Distance.levenshtein(parent_word, word)
    sub_tree = Enum.find(children, fn {k,  _} -> k == new_distance end)

    if sub_tree do
      {_, child} = sub_tree
      {parent_word, Map.merge(children, %{new_distance => add(child, word)})}
    else
      {parent_word, Map.merge(children, %{new_distance => {word, Map.new}})}
    end
  end

  def search({parent_word, children}, word, depth) do
    search_distance = Distance.levenshtein(parent_word, word)
    max_depth = search_distance + depth
    min_depth = search_distance - depth

    sub_results = children
      |> Enum.filter(fn {k, _} -> min_depth <= k && k <= max_depth end)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.flat_map(fn(node) -> BkTree.search(node, word, depth) end)

    if depth >= search_distance do
      [{search_distance, parent_word} | sub_results]
      else
      sub_results
    end
  end
end