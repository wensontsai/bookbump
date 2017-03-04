defmodule Bookbump.Repo do
  use Ecto.Repo, otp_app: :bookbump
  use Scrivener, page_size: 25
end
