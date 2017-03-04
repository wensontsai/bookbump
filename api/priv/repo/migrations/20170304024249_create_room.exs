defmodule Bookbump.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, ull: false
      add :topic, :string, default: ""

      timestamps()
    end

    create unique_index(:rooms, [:name])
  end
end
