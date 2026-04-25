if Mix.env() != :dev do
  IO.puts("Skipping seeds (not dev environment).")
  System.halt(0)
end

seed_files =
  __DIR__
  |> Path.join("seeds/*.exs")
  |> Path.wildcard()
  |> Enum.sort()

Enum.each(seed_files, &Code.require_file/1)

AiApi.Seeds.Users.seed_default_system_user()

IO.puts("Seeds complete.")
