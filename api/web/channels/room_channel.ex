defmodule Bookbump.RoomChannel do
  use Bookbump.Web, :channel

  def join("rooms:" <> room_id, _params, socket) do
    room = Repo.get!(Bookbump.Room, room_id)

    page =
      Bookbump.Message
      |> where([m], m.room_id == ^room.id)
      |> order_by([desc: :inserted_at, desc: :id])
      |> preload(:user)
      |> Bookbump.Repo.paginate()

    response = %{
      room: Phoenix.View.render_one(room, Bookbump.RoomView, "room.json"),
      messages: Phoenix.View.render_many(page.entries, Bookbump.MessageView, "message.json"),
      pagination: Bookbump.PaginationHelpers.pagination(page)
    }

    {:ok, response, assign(socket, :room, room)}
  end

  def handle_in("new_message", params, socket) do
    changeset =
      socket.assigns.room
      |> build_assoc(:messages, user_id: socket.assigns.current_user.id)
      |> Bookbump.Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, Phoenix.View.render(Bookbump.ChangesetView, "error.json", changeset: changeset)}, socket}
    end
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, Bookbump.MessageView, "message.json")
    broadcast!(socket, "message_created", rendered_message)
  end
end