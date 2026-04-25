defmodule AiApi.Seeds.Users do
  alias AiApi.Accounts.User
  alias AiApi.Repo

  def seed_default_system_user do
    system_user_attrs = %{
      email: "system@localhost",
      name: "System",
      hashed_password: disabled_password_hash(),
      role: "system",
      confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }

    system_user_email_hash = AiApi.Encryption.email_hash(system_user_attrs.email)

    case Repo.get_by(User, email_hash: system_user_email_hash) do
      nil ->
        %User{}
        |> User.changeset(system_user_attrs)
        |> Repo.insert!()

        IO.puts("Seeded default system user.")

      user ->
        user
        |> User.changeset(system_user_attrs)
        |> Repo.update!()

        IO.puts("Updated default system user.")
    end
  end

  defp disabled_password_hash do
    :crypto.hash(:sha256, "system-user-disabled")
    |> Base.encode16(case: :lower)
  end
end
