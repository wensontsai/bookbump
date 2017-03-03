defmodule Bookbump.UserView do
  use Bookbump.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Bookbump.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Bookbump.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      password_hash: user.password_hash}
  end
end
