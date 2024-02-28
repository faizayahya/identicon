defmodule Identicon do
  alias Image, as: Img

  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
  end

  def draw_image(%Identicon.Image{colour: colour, pixel_map: pixel_map}) do
    image = Img.new!(250, 250)
    image = Img.Draw.flood!(image, 0, 0, color: :white)

    {red, green, blue} = colour
    {:ok, pixel_colour} = Img.Color.rgb_to_hex([red, green, blue])

    new_image = Enum.reduce(pixel_map, image, fn({{top, left}, _stop}, image) ->
      Img.Draw.rect!(image, top, left, 50, 50, color: pixel_colour)
    end)
    Image.write!(new_image, "/Users/Downloads/image.png")
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def pick_colour(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | colour: {r, g, b}}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
