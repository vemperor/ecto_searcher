defmodule EctoSearcher.Searcher.Utils.SearchQueryTest do
  use ExUnit.Case

  alias EctoSearcher.Searcher.Utils.SearchQuery

  test "builds search query from expression" do
    field = :some_field
    field_name = to_string(field)
    matcher_name = "not_eq"
    value = "some_value"
    searchable_fields = [field]
    expression = {"#{field_name}_#{matcher_name}", value}

    search_query = SearchQuery.build(expression, searchable_fields)

    assert %SearchQuery{field: field, matcher: matcher_name, value: value} == search_query
  end

  test "doesn't build search query for unknown field" do
    field_name = "some_field"
    matcher_name = "not_eq"
    value = "some_value"
    searchable_fields = [:some_other_field]
    expression = {"#{field_name}_#{matcher_name}", value}

    search_query = SearchQuery.build(expression, searchable_fields)

    assert is_nil(search_query)
  end

  test "builds search query list from search params" do
    searchable_fields = [:field_one, :field_two]

    search_params = %{
      "field_one_eq" => "some_value",
      "field_two_not_eq" => "some_other_value",
      "field_three_not_gteq" => "third_value"
    }

    expected_search_query_list = [
      %SearchQuery{field: :field_one, matcher: "eq", value: "some_value"},
      %SearchQuery{field: :field_two, matcher: "not_eq", value: "some_other_value"}
    ]

    search_query_list = SearchQuery.from_params(search_params, searchable_fields)

    assert expected_search_query_list == search_query_list
  end
end
