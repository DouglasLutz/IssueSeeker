defmodule IssueSeeker.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:contributors) do
      add :name, :string

      timestamps()
    end
    create unique_index(:contributors, [:name])

    create table(:projects) do
      add :name, :string
      add :owner, :string
      add :status, :string, default: "PENDING_APROVAL"
      add :stargazers_count, :integer
      add :level_id, references(:levels)

      timestamps()
    end
    create unique_index(:projects, [:name, :owner])

    create table(:projects_contributors) do
      add :project_id, references(:projects), null: false
      add :contributor_id, references(:contributors), null: false
    end

    create table(:projects_languages) do
      add :project_id, references(:projects), null: false
      add :language_id, references(:languages), null: false
    end
  end
end
