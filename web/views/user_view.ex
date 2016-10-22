defmodule Chatty.UserView do
  use Chatty.Web, :view

  def render("index.json", %{users: users}) do
  	%{data: render_many(users, Chatty.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
  	%{name: user.name, email: user.email}
  end

  def render("show.json", %{user: user}) do
  	%{data: render_one(user, Chatty.UserView, "user.json")}
  end

  def render("error.json", _assigns) do
  	%{error: "User not found"}
  end
end
