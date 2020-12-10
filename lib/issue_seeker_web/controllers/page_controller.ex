defmodule IssueSeekerWeb.PageController do
  use IssueSeekerWeb, :controller

  def index(conn, _params) do
    last_open_issues = IssueSeeker.Projects.get_last_open_issues()
    number_of_active_projects = IssueSeeker.Projects.count_active_projects()
    render(conn, "index.html", issues: last_open_issues, number_of_active_projects: number_of_active_projects)
  end
end
