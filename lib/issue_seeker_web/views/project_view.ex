defmodule IssueSeekerWeb.ProjectView do
  use IssueSeekerWeb, :view

  alias IssueSeeker.Profiles
  alias IssueSeeker.Projects.Project

  def project_level(%Project{} = project) do
    case project.level do
      %IssueSeeker.Profiles.Level{name: name} -> name
      _ -> ""
    end
  end

  def available_levels() do
    Profiles.list_levels()
    |> Enum.map(&(&1.name))
  end

  def get_project_url(project) do
    "https://github.com/#{project.owner}/#{project.name}"
  end
end
