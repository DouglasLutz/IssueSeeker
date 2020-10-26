defmodule IssueSeeker.Recommendations.RecommendationIssue do
  use Ecto.Schema
  import Ecto.Changeset
  import IssueSeeker.Helpers.Changeset

  alias __MODULE__
  alias IssueSeeker.Recommendations.Recommendation
  alias IssueSeeker.Projects.Issue

  schema "recommendations_issues" do
    field :value, :integer

    belongs_to :recommendation, Recommendation
    belongs_to :issue, Issue
  end

  def changeset(recommendation_issue \\ %RecommendationIssue{}, attrs) do
    attrs = get_issue_potential_value(attrs)

    recommendation_issue
    |> cast(attrs, [:value])
    |> put_existing_assoc(:recommendation, Map.get(attrs, "recommendation"))
    |> put_existing_assoc(:issue, Map.get(attrs, "issue"))
  end

  defp get_issue_potential_value(attrs) do
    Map.merge(attrs, %{"value" => 0})
  end
end
