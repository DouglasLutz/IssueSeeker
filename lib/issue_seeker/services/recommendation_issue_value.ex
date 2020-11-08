defmodule IssueSeeker.Services.RecommendationIssueValue do
  alias IssueSeeker.Projects.Issue

  @initial_value 100
  # Not evaluated yet
  @labels_total_weight 0
  @comments_total_weight 10
  @author_association_total_weight 20
  # Not evaluated yet
  @creation_date_total_weight 0
  @has_assignee_total_weight 30

  def perform(
    %Issue{
      author_association: author_association,
      labels: labels,
      number_of_comments: number_of_comments,
      has_assignee: has_assignee
    } = _issue
  ) do
    @initial_value -
    get_author_association_loss(author_association) -
    get_labels_loss(labels) -
    get_comments_loss(number_of_comments) -
    get_creation_date_loss(nil) -
    get_has_assignee_loss(has_assignee)
    |> Kernel.ceil()
  end

  def get_author_association_loss(author_association) do
    author_association_loss_table = %{
      "FIRST_TIMER" => 1,
      "MANNEQUIN" => 1,
      "NONE" => 1,
      "FIRST_TIME_CONTRIBUTOR" => 0.8,
      "COLLABORATOR" => 0.2,
      "CONTRIBUTOR" => 0,
      "MEMBER" => 0,
      "OWNER" => 0
    }

    Map.get(author_association_loss_table, author_association) * @author_association_total_weight
  end

  def get_labels_loss(_labels) do
    @labels_total_weight
  end

  def get_comments_loss(number_of_comments) do
    comments_loss_table = %{
      0 => 0.4,
      1 => 0.2,
      2 => 0,
      3 => 0,
      4 => 0,
      5 => 0.2,
      6 => 0.4,
      7 => 0.6,
      8 => 0.8
    }

    if Map.has_key?(comments_loss_table, number_of_comments) do
      Map.get(comments_loss_table, number_of_comments) * @comments_total_weight
    else
      @comments_total_weight
    end
  end

  def get_creation_date_loss(_creation_date) do
    @creation_date_total_weight
  end

  def get_has_assignee_loss(true), do: @has_assignee_total_weight
  def get_has_assignee_loss(false), do: 0
end
