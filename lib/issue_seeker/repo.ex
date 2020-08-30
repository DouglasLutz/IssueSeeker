defmodule IssueSeeker.Repo do
  use Ecto.Repo,
    otp_app: :issue_seeker,
    adapter: Ecto.Adapters.Postgres
end
