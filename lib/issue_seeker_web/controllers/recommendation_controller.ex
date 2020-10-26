defmodule IssueSeekerWeb.RecommendationController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Recommendations

  def projects(conn, _params) do
    projects = Recommendations.filter_projects_for_profile(current_user_profile(conn))
    render(conn, "projects.html", projects: projects)
  end

  def index(conn, _params) do
    recommendations =
      conn
      |> current_user()
      |> Recommendations.get_user_recommendations()

      render(conn, "index.html", recommendations: recommendations)
  end

  def create(conn, _params) do
    case Recommendations.create_recommendation(current_user(conn)) do
      {:ok, recommendation} ->
        conn
        |> put_flash(:info, "Recommendation created successfully.")
        |> redirect(to: Routes.recommendation_path(conn, :show, recommendation))
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> put_flash(:error, "Error creating recommendation, please try again later.")
        |> redirect(to: "/")
    end
  end

  def show(conn, %{"id" => id}) do
    recommendations_issues =
      Recommendations.get_recommendations_issues_from_recommendation_id(id)

    render(conn, "show.html", recommendations_issues: recommendations_issues)
  end

  def show_issue(conn, %{"id" => id}) do
    recommendation_issue =
      Recommendations.get_recommendation_issue(id)
    render(conn, "show_issue.html", recommendation_issue: recommendation_issue)
  end
end
