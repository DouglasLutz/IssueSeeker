defmodule IssueSeeker.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false

  alias IssueSeeker.Repo
  alias IssueSeeker.Projects.{Project, Contributor}
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
      {:ok, _created_languages} ->
        {:ok, filter_contributors_by_name(names)}
      {:error, failed_operation, failed_value, _succeded_changes} ->
        {:error, failed_operation, failed_value}
    end
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

  def list_active_projects() do
    query = from p in Project, where: p.status == "ACTIVE", preload: [:languages, :level]
    Repo.all(query)
  end

  def list_pending_aproval_projects() do
    query = from p in Project, where: p.status == "PENDING_APROVAL", preload: [:languages, :level]
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

  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> Repo.preload([:languages, :level])
  end

  def change_project(project, attrs \\ %{}) do
    Project.update_changeset(project, attrs)
  end
end
