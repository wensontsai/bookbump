defmodule Bookbump.Message do
  use Bookbump.Web, :model

  schema "messages" do
    field :text, :string
    belongs_to :room, Bookbump.Room
    belongs_to :user, Bookbump.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
