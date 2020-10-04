defmodule IssueSeekerWeb.RecommendationController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Recommendations

  def projects(conn, _params) do
    projects = Recommendations.filter_projects_for_profile(current_user_profile(conn))
    render(conn, "projects.html", projects: projects)
  end
end
