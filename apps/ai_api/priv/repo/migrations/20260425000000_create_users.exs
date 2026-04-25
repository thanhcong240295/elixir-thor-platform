defmodule AiApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email_encrypted, :binary, null: false
      add :email_hash, :string, null: false
      add :name_encrypted, :binary
      add :hashed_password, :string, null: false
      add :role, :string, null: false, default: "user"
      add :confirmed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email_hash])
  end
end
