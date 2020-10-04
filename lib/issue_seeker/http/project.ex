defmodule IssueSeeker.Http.Project do
  alias IssueSeeker.Helpers.Regex

  defp base_url(), do: Application.get_env(:issue_seeker, IssueSeeker.Http)[:github_v3_url]

  defp api_url(owner, name) do
    "#{base_url()}/repos/#{owner}/#{name}"
  end

  def get(owner, name) do
    case api_url(owner, name) |> HTTPoison.get() do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end

  def get(project_url) do
    case Regex.get_project_info_from_github_url(project_url) do
      %{"owner" => owner, "name" => name} ->
        get(owner, name)
      _ ->
        {:error, :invalid_project_url}
    end
  end

  defp format_response(%HTTPoison.Response{body: body}) do
    response_body =
      body
      |> Jason.decode!()

    %{
      "name" => Map.get(response_body, "name"),
      "owner" => response_body |> Map.get("owner") |> Map.get("login"),
      "stargazers_count" => Map.get(response_body, "stargazers_count"),
      "contributors_url" => Map.get(response_body, "contributors_url"),
      "languages_url" => Map.get(response_body, "languages_url")
    }
  end
end
