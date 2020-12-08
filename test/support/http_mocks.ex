defmodule HttpMocks do
  def get() do
    [
      {
        IssueSeeker.Http.Project,
        [],
        [
          get: fn(_url) ->
            {:ok,
             %{
              "contributors_url" => "https://api.github.com/repos/owner/name/contributors",
              "languages_url" => "https://api.github.com/repos/owner/name/languages",
              "name" => "name",
              "owner" => "owner",
              "stargazers_count" => 42
            }}
          end
        ]
      },
      {
        IssueSeeker.Http.Contributor,
        [],
        [
          get: fn(_url) ->
            {:ok, ["user"]}
          end
        ]
      },
      {
        IssueSeeker.Http.Language,
        [],
        [
          get: fn(_url) ->
            {:ok, ["Elixir"]}
          end
        ]
      },
      {
        IssueSeeker.Http.Issue,
        [],
        [
          get: fn(_url) ->
            {:ok,
             [
              %{
                "author_association" => "CONTRIBUTOR",
                "body" => "some body",
                "has_assignee" => false,
                "inserted_at" => "2020-10-27T13:25:38Z",
                "is_open" => true,
                "labels" => [],
                "number" => 42,
                "number_of_comments" => 42,
                "title" => "some title",
                "updated_at" => "2020-11-21T19:37:25Z",
                "url" => "https://github.com/owner/name/issues/42"
              }
            ]}
          end
        ]
      }
    ]
  end
end
