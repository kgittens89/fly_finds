defmodule FlyFinds.Repo do
  use Ecto.Repo,
    otp_app: :fly_finds,
    adapter: Ecto.Adapters.Postgres
end
