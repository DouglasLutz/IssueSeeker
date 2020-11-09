defmodule IssueSeekerWeb.LabelView do
  use IssueSeekerWeb, :view

  alias IssueSeeker.Projects.Label

  def available_classifications() do
    Label.classifications()
  end
end
