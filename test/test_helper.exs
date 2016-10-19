ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Chatty.Repo, :manual)

ExUnit.configure(exclude: [error_view_case: true])