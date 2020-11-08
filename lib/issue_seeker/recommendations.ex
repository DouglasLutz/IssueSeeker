defmodule IssueSeeker.Recommendations do
  import Ecto.Query
  alias IssueSeeker.{Repo, Projects}
  alias IssueSeeker.Accounts.User
  alias IssueSeeker.Profiles.Profile
  alias IssueSeeker.Projects.Project
  alias IssueSeeker.Recommendations.{Recommendation, RecommendationIssue}

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

  def create_recommendation(%User{profile: profile} = user) do
    issues =
      profile
      |> filter_projects_for_profile()
      |> Enum.flat_map(fn project ->
        project
        |> Projects.get_project_open_issues()
        |> Enum.map(fn issue ->
          %{"issue" => issue}
        end)
      end)

    IO.puts(inspect issues)

    attrs = %{
      "recommendations_issues" => issues
    }

    %Recommendation{user: user}
    |> Recommendation.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_recommendations(%User{id: id}) do
    query = from r in Recommendation, join: u in assoc(r, :user), where: u.id == ^id
    Repo.all(query)
  end

  def get_recommendations_issues_from_recommendation_id(id) do
    query =
      from ri in RecommendationIssue,
      join: r in assoc(ri, :recommendation),
      where: r.id == ^id,
      order_by: [desc: ri.value],
      preload: [issue: [:labels], recommendation: []]

    Repo.all(query)
  end

  def get_recommendation_issue(id) do
    RecommendationIssue
    |> Repo.get(id)
    |> Repo.preload([issue: [:labels], recommendation: []])
  end
end
