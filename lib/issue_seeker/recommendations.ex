defmodule IssueSeeker.Recommendations do
  import Ecto.Query
  alias IssueSeeker.Repo
  alias IssueSeeker.Profiles.Profile
  alias IssueSeeker.Projects.Project

  def filter_projects_for_profile(%Profile{} = profile) do
    profile_languages_ids = profile |> Ecto.assoc(:languages) |> Repo.all() |> Enum.map(&(&1.id))
    knowledge_level_value = profile |> Ecto.assoc(:level) |> Repo.one |> Map.get(:value)

    query =
      from project in Project,
      join: language in assoc(project, :languages),
      join: level in assoc(project, :level),
      where: language.id in ^profile_languages_ids and level.value <= ^knowledge_level_value and project.status == "ACTIVE",
      group_by: project.id,
      preload: [:languages, :level]

    Repo.all(query)
  end
end
