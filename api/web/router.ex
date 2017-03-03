defmodule Bookbump.Router do
  use Bookbump.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Bookbump do
    pipe_through :api
  end
end
