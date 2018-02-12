# Meshi

This application is intended to support small teams find a decent lunch place that is satisfactory to a particular lunch party.

It uses google embedded maps and authentication for the web front-end and integrates with slack for querying recommended restaurants.

The technology stack is Elixir/Phoenix for the backend and Elm for the front end.

## Pre-requisites

  * Elixir ([Installing Elixir](http://elixir-lang.github.io/install.html))
  * PostgreSQL server (([Installation Guides](https://wiki.postgresql.org/wiki/Detailed_installation_guides))
  * Elm ([Installing Elm](https://guide.elm-lang.org/install.html))

## Running

To start Meshi app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check phoenix deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Phoenix Official website: http://www.phoenixframework.org/
  * Elm Official website: http://elm-lang.org/
  * Elm/Phoenix tutorial: http://codeloveandboards.com/blog/2017/02/02/phoenix-and-elm-a-real-use-case-pt-1/
  * Ueberauth: https://github.com/ueberauth

## TODO

* Add the Rating model in Phoenix.
* Add tests.
* Enrich slack dialog.
