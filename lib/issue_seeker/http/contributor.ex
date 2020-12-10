defmodule IssueSeeker.Http.Contributor do
  defp base_url(), do: Application.get_env(:issue_seeker, IssueSeeker.Http)[:github_v3_url]

  defp url(owner, name) do
    "#{base_url()}/repos/#{owner}/#{name}/contributors"
  end

  defp headers(token) do
    [Authorization: token]
  end

  def get(owner, name, token) do
    case url(owner, name) |> HTTPoison.get(headers(token)) do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end

  def get(url, token) do
    case HTTPoison.get(url, headers(token)) do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end

  defp format_response(%HTTPoison.Response{body: body}) do
    body
    |> Jason.decode!()
    |> Enum.map(fn contributor ->
      Map.get(contributor, "login")
    end)
  end
end
