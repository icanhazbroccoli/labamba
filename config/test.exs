use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :labamba, LabambaWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :labamba, Labamba.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "labamba_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
