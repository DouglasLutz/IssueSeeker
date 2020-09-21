defmodule IssueSeekerWeb.ProfileView do
  use IssueSeekerWeb, :view

  alias IssueSeeker.Profiles
  alias IssueSeeker.Profiles.{Profile, Level, Language}

  def current_user_profile(conn) do
    case current_user(conn).profile do
      %Profile{} = profile -> profile
      nil -> %Profile{
        languages: [
          %Language{name: "HTML"},
          %Language{name: "CSS"}
        ],
        level: %Level{name: "Advanced"}
      }
    end
  end

  def profile_level(%Profile{} = profile) do
    case profile.level do
      %Level{name: name} -> name
      _ -> ""
    end
  end

  def profile_languages(%Profile{} = profile) do
    case profile.languages do
      [_|_] = languages ->
        languages
      _ -> []
    end
  end

  def available_levels() do
    Profiles.list_levels()
    |> Enum.map(&(&1.name))
  end

  def available_languages() do
    Profiles.list_languages()
  end
end
