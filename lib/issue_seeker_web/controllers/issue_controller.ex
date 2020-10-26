defmodule IssueSeekerWeb.IssueController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Projects

  def index(conn, %{"project_id" => project_id}) do
    issues =
      project_id
      |> Projects.get_project!()
      |> Projects.get_project_open_issues()
    render(conn, "index.html", issues: issues)
  end

  def show(conn, %{"id" => id}) do
    issue = Projects.get_issue!(id)
    render(conn, "show.html", issue: issue)
  end
end
