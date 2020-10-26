defmodule IssueSeeker.Http.Issue do
  defp base_url(), do: Application.get_env(:issue_seeker, IssueSeeker.Http)[:github_v3_url]

  defp url(owner, name) do
    "#{base_url()}/repos/#{owner}/#{name}/issues?state=open"
  end

  @doc """
    Todo:
      Still needs to work on getting next page issues,
      look for issues in response header with {"link", link}
  """
  def get(owner, name) do
    case url(owner, name) |> HTTPoison.get() do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end
  def get(project) do
    get(project.owner, project.name)
  end

  defp format_response(%HTTPoison.Response{body: body}) do
    body
    |> Jason.decode!()
    |> Enum.reduce([], &filter_issues/2)
  end

  defp filter_issues(%{"pull_request" => _}, acc), do: acc
  defp filter_issues(issue, acc) do

    issue_params =
      issue
      |> Map.take([
        "number",
        "title",
        "body",
        "author_association"
      ])
      |> Map.merge(%{
        "is_open" => (Map.get(issue, "state") == "open"),
        "number_of_comments" => Map.get(issue, "comments"),
        "has_assignee" => (Map.get(issue, "assignee") != nil),
        "labels" => (
          issue
          |> Map.get("labels")
          |> Enum.map(&(Map.get(&1, "name")))
        ),
        "url" => Map.get(issue, "html_url")
      })

    acc ++ [issue_params]
  end
end
