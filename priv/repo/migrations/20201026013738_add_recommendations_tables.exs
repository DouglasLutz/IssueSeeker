defmodule IssueSeeker.Repo.Migrations.AddRecommendationsTables do
  use Ecto.Migration

  def change do
    create table(:recommendations) do
      add :user_id, references(:users), null: false
      timestamps()
    end

    create table(:recommendations_issues) do
      add :recommendation_id, references(:recommendations), null: false
      add :issue_id, references(:issues), null: false

      add :value, :integer
    end
  end
end
