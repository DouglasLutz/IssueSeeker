defmodule IssueSeeker.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false

  alias IssueSeeker.Repo
  alias IssueSeeker.Projects.{Project, Contributor, Label, Issue}
  alias Ecto.Multi

  def filter_contributors_by_name(names) do
    query = from c in Contributor, where: c.name in ^names
    Repo.all(query)
  end

  def ensure_contributors_created(names) when is_list(names) do
    nonexistent_contributors =
      Enum.reject(names, fn name ->
        query = from c in Contributor, where: c.name == ^name
        Repo.exists?(query)
      end)

    case create_contributors(nonexistent_contributors) do
      {:ok, _created_contributors} ->
        {:ok, filter_contributors_by_name(names)}
      {:error, failed_operation, failed_value, _succeded_changes} ->
        {:error, failed_operation, failed_value}
    end
  end

  def count_active_projects() do
    Repo.one(from p in Project, where: p.status == "ACTIVE", select: count(p.id))
  end

  def create_contributors(names) when is_list(names) do
    Enum.reduce(names, Multi.new(), fn name, multi ->
      Multi.insert(
        multi,
        {:contributor, name},
        Contributor.changeset(%{name: name})
      )
    end)
    |> Repo.transaction()
  end

  def filter_labels_by_name(names) do
    query = from l in Label, where: l.name in ^names
    Repo.all(query)
  end

  def ensure_labels_created(names) when is_list(names) do
    nonexistent_labels =
      Enum.reject(names, fn name ->
        query = from l in Label, where: l.name == ^name
        Repo.exists?(query)
      end)

    case create_labels(nonexistent_labels) do
      {:ok, _created_labels} ->
        {:ok, filter_labels_by_name(names)}
      {:error, failed_operation, failed_value, _succeded_changes} ->
        {:error, failed_operation, failed_value}
    end
  end
  def ensure_labels_created(_), do: {:ok, nil}

  def create_labels(names) when is_list(names) do
    Enum.reduce(names, Multi.new(), fn name, multi ->
      Multi.insert(
        multi,
        {:label, name},
        Label.create_changeset(%{name: name})
      )
    end)
    |> Repo.transaction()
  end

  def get_last_open_issues() do
    query =
      from i in Issue,
      where: i.is_open == true,
      order_by: [desc: i.inserted_at],
      limit: 10,
      preload: [:project]

    Repo.all(query)
  end

  def get_project_issues(%Project{id: id}) do
    query = from i in Issue, join: p in assoc(i, :project), where: p.id == ^id
    Repo.all(query)
  end

  def get_project_open_issues(%Project{id: id} = project, token) do
    verify_issues_update(project, token)
    query = from i in Issue, join: p in assoc(i, :project), where: p.id == ^id and i.is_open == true, preload: [:labels, :project]
    Repo.all(query)
  end
  def get_project_open_issues(_, _), do: []

  def get_issue_from_project_and_number(%Project{id: id}, number) do
    query = from i in Issue, join: p in assoc(i, :project), where: p.id == ^id and i.number == ^number
    Repo.one(query)
  end

  def set_issues_closed(issues) do
    Enum.reduce(issues, Multi.new(), fn issue, multi ->
      Multi.update(
        multi,
        {:issue, issue.id},
        Issue.update_changeset(issue, %{is_open: false})
      )
    end)
    |> Repo.transaction()
  end

  def create_or_update_issues(project, issues_params) do
    Enum.reduce(issues_params, Multi.new(), fn %{"number" => number} = issue_params, multi ->
      case get_issue_from_project_and_number(project, number) do
        %Issue{} = issue ->
          Multi.update(
            multi,
            {:issue, number},
            Issue.update_changeset(issue, issue_params)
          )
        nil ->
          Multi.insert(
            multi,
            {:issue, number},
            Issue.create_changeset(%Issue{project: project}, issue_params)
          )
      end
    end)
    |> Repo.transaction()
  end

  def list_active_projects() do
    query = from p in Project, where: p.status == "ACTIVE", preload: [:languages, :level, :contributors]
    Repo.all(query)
  end

  def list_pending_aproval_projects() do
    query = from p in Project, where: p.status == "PENDING_APROVAL", preload: [:languages, :contributors]
    Repo.all(query)
  end

  def create_project(project_params) do
    project_params
    |> Project.create_changeset()
    |> Repo.insert()
  end

  def update_project(project, project_params) do
    project
    |> Project.update_changeset(project_params)
    |> Repo.update()
  end

  def verify_issues_update(project, token) do
    case project.last_issues_request do
      %NaiveDateTime{} = last_time ->
        if(NaiveDateTime.diff(NaiveDateTime.utc_now, last_time) > 3600) do
          update_project_issues_from_github(project, token)
        end
      nil ->
        update_project_issues_from_github(project, token)
    end
  end

  def update_last_issue_request(project) do
    project
    |> Project.issue_request_changeset()
    |> Repo.update!()
  end

  def update_project_issues_from_github(project, token) do
    current_issues = get_project_issues(project)
    set_issues_closed(current_issues)

    with {:ok, issues_params} <- IssueSeeker.Http.Issue.get(project, token),
      {:ok, updated_issues} <- create_or_update_issues(project, issues_params) do
        update_last_issue_request(project)
        {:ok, updated_issues}
      else
        error -> error
    end
  end

  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> Repo.preload([:languages, :level])
  end

  def get_issue!(id) do
    Issue
    |> Repo.get!(id)
    |> Repo.preload([:labels, :project])
  end

  def change_project(project, attrs \\ %{}) do
    Project.update_changeset(project, attrs)
  end

  def get_project_attrs_from_url(url, token) do
    with {:ok, %{"languages_url" => languages_url, "contributors_url" => _contributors_url} = project_attrs} <- IssueSeeker.Http.Project.get(url, token),
      # Not used yet
      # {:ok, contributors} <- IssueSeeker.Http.Contributor.get(contributors_url),
      {:ok, languages} <- IssueSeeker.Http.Language.get(languages_url, token) do
        result =
          project_attrs
          |> Map.merge(%{
            "languages" => languages,
            "contributors" => []
          })

        {:ok, result}
      else
        error ->
          error
    end
  end

  def list_labels() do
    Label
    |> Repo.all()
  end

  def get_label!(id) do
    Label
    |> Repo.get!(id)
  end

  def change_label(label, attrs \\ %{}) do
    Label.update_changeset(label, attrs)
  end


  def update_label(%Label{} = label, label_params) do
    label
    |> Label.update_changeset(label_params)
    |> Repo.update()
  end

  def issues_with_label(%Label{} = label) do
    query =
      label
      |> Ecto.assoc(:issues)

    query = from i in query, where: i.is_open == true

    Repo.all(query)
  end
end
