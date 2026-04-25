defmodule AiApi.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias AiApi.Encrypted.Binary

  schema "users" do
    field(:email, Binary, source: :email_encrypted)
    field(:email_hash, :string)
    field(:name, Binary, source: :name_encrypted)
    field(:hashed_password, :string)
    field(:role, :string, default: "user")
    field(:confirmed_at, :utc_datetime)

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :hashed_password, :role, :confirmed_at])
    |> validate_required([:email, :hashed_password, :role])
    |> update_change(:email, &AiApi.Encryption.normalize_email/1)
    |> put_email_hash()
    |> unique_constraint(:email_hash)
  end

  defp put_email_hash(changeset) do
    case get_change(changeset, :email) do
      nil -> changeset
      email -> put_change(changeset, :email_hash, AiApi.Encryption.email_hash(email))
    end
  end
end
