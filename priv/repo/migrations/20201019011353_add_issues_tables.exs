defmodule IssueSeeker.Repo.Migrations.AddIssuesTables do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :text
      add :number, :integer
      add :body, :text
      add :author_association, :string
      add :number_of_comments, :integer
      add :has_assignee, :boolean
      add :is_open, :boolean
      add :url, :string

      add :project_id, references(:projects), null: false

      timestamps()
    end
    create unique_index(:issues, [:number, :project_id])

    create table(:labels) do
      add :name, :string
    end
    create unique_index(:labels, [:name])

    create table(:issues_labels) do
      add :issue_id, references(:issues), null: false
      add :label_id, references(:labels), null: false
    end

    alter table(:projects) do
      add :last_issues_request, :naive_datetime
    end
  end
end
