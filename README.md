# IssueSeeker

## Production server

The application is running [`here`](https://issue-seeker.herokuapp.com/)! 

## Project Dependencies

* PostgreSQL 8.4 or higher
* Elixir 1.7 or higher

## Running the application

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Run `cp .env.example .env` and set the required env variables
  * Export .env variables with `source .env`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### _Note_: Github OAuth

You need to set up a [GitHub Application](https://developer.github.com/) and ensure `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` are available to your application exported in `.env` file. The GitHub application needs its callback set to `http://localhost:4000/auth/github/callback` and be given read-only access to the email addresses of the user.

## Tests

To run the tests on your machine:

  * Install dependencies with `mix deps.get`
  * Run `cp .env.example .env` and set the required env variables
  * Export .env variables with `source .env`
  * Create and migrate your database with `mix ecto.setup`
  * Run the tests with `mix test`
