defmodule Distance do
    @doc ~S"""
    Calculate distance between words

    ## Examples:
        iex> Distance.levenshtein("ba", "ab")
        2
        iex> Distance.levenshtein("", "")
        0
    """

    def levenshtein(word1, ""), do: String.length(word1)
    def levenshtein("", word2), do: String.length(word2)
    def levenshtein(word1, word2) do
        h1 = String.first(word1)
        h2 = String.first(word2)
        rest1 = String.slice(word1, 1, String.length(word1))
        rest2 = String.slice(word2, 1, String.length(word2))
        indicator = if h1 != h2, do: 1, else: 0
        left = levenshtein(h1 <> rest1, rest2) + 1
        right = levenshtein(rest1, h2 <> rest2) + 1
        both = levenshtein(rest1, rest2) + indicator
        Enum.min([left, right, both])
    end
end