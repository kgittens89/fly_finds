defmodule FlyFindsWeb.LandingPageLive do
  use FlyFindsWeb, :live_view

  def mount(_params, _session, socket) do
    
    {:ok, assign(socket, form: to_form(%{"icao_code" => nil}), data: nil)}
  end

  def handle_event("validate", params, socket) do

    {:noreply, assign(socket, form: to_form(params))}
  end

  def handle_event("search", params, socket) do
    airportdb_api_key = Application.fetch_env!(:fly_finds, :airportdb_api_key)
    icao = params["icao_code"]
    url = "https://airportdb.io/api/v1/airport/#{icao}?apiToken=#{airportdb_api_key}"

    {:ok, response} = HTTPoison.get(url)

    {:noreply, assign(socket, data: Jason.decode!(response.body))}
  end

end
