defmodule IssueSeeker.Helpers.Regex do
  def get_project_info_from_github_url(url) when is_binary(url) do
    Regex.named_captures(~r/^(http(s)?:\/\/)?github.com\/(?<owner>[^\/]*)\/(?<name>[^\/]*)$/, url)
  end
  def get_project_info_from_github_url(_), do: nil
end
