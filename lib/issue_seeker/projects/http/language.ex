defmodule IssueSeeker.Projects.Http.Language do
  defp base_url(), do: Application.get_env(:issue_seeker, IssueSeeker.Http)[:github_v3_url]

  defp url(owner, name) do
    "#{base_url()}/repos/#{owner}/#{name}/languages"
  end

  def get(owner, name) do
    case url(owner, name) |> HTTPoison.get() do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end

  def get(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, format_response(response)}
      {:error, error} ->
        {:error, error}
    end
  end

  defp format_response(%HTTPoison.Response{body: body}) do
    body
    |> Jason.decode!()
    |> Map.keys()
  end
end
