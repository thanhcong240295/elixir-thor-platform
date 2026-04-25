defmodule AiApi.Repo.Migrations.FixUsersIdDefault do
  use Ecto.Migration

  def up do
    execute("""
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_class
        WHERE relkind = 'S' AND relname = 'users_id_seq'
      ) THEN
        CREATE SEQUENCE users_id_seq;
      END IF;
    END
    $$;
    """)

    execute("ALTER SEQUENCE users_id_seq OWNED BY users.id")
    execute("ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq')")

    execute("""
    SELECT setval(
      'users_id_seq',
      COALESCE((SELECT MAX(id) FROM users), 0) + 1,
      false
    )
    """)
  end

  def down do
    execute("ALTER TABLE users ALTER COLUMN id DROP DEFAULT")
  end
end
