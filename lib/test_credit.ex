defmodule TestCredit do
  @moduledoc """
  Documentation for TestCredit.
  """

  use HTTPoison.Base

  @base_url "http://www.lolcats.com"

  @doc """
  Prepend the base API endpoint to the requested URL
  """
  @spec process_url(String.t()) :: String.t()
  def process_url(url), do: @base_url <> url

  @doc """
  Retrieve the lolcats page based on the page number that was provided
  """
  def get_lol_page_url(0), do: "/"
  def get_lol_page_url(page_num), do: "/page-#{page_num}.html"

  @doc """
  Scrape lolcat urls from the given page number
  """
  def scrape_lolz_urls(page_num) do
    page_num
    |> get_lol_page_url()
    |> get!()
    |> Map.get(:body)
    |> Floki.find(".lolcat")
    |> Floki.attribute("src")
  end

  @doc """
  Get the file name from a given url
  """
  def url_to_filename(url) do
    url
    |> String.split("/")
    |> List.last()
  end

  @doc """
  Save the file at the given url to disk
  """
  def save_url_to_disk(url) do
    data = url |> get!() |> Map.get(:body)

    url
    |> url_to_filename()
    |> File.write!(data)
  end

  @doc """
  Save the files at the given urls to disk
  """
  def save_images_to_disk(images), do: Enum.map(images, &save_url_to_disk/1)

  def main(page_num_terminate) do
    0..page_num_terminate
    |> Enum.flat_map(&scrape_lolz_urls/1)
    |> save_images_to_disk()
  end
end
