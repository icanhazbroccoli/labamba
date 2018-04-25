defmodule LabambaWeb.API.BandAPIView do

  use LabambaWeb, :view

  def render("index.json", %{bands: bands}) do
    %{
      bands: Enum.map(bands, &band_json/1)
    }
  end

  defp band_json(band) do
    %{
      id: band.id,
      name: band.name,
      pic_url: band.pic_url,
      band_website: band.band_website,
      description: band.description,
      youtube: band.youtube,
    }
  end

end
