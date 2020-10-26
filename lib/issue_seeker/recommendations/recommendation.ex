defmodule IssueSeeker.Recommendations.Recommendation do
  use Ecto.Schema
  import Ecto.Changeset
  import IssueSeeker.Helpers.Changeset

  alias __MODULE__
  alias IssueSeeker.Recommendations.RecommendationIssue

  schema "recommendations" do
    belongs_to :user, IssueSeeker.Accounts.User
    has_many :recommendations_issues, RecommendationIssue
    many_to_many :issues, IssueSeeker.Projects.Issue, join_through: RecommendationIssue

    timestamps()
  end

  def changeset(recommendation \\ %Recommendation{}, attrs) do
    recommendation
    |> cast(attrs, [])
    |> put_existing_assoc(:user, Map.get(attrs, "user"))
    |> cast_assoc(:recommendations_issues, with: &RecommendationIssue.changeset/2)
  end
end
