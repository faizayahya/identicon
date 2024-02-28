# Identicon

Produces an Github like identicon image that is saved into your Downloads, as image.png.
  
## How does it work?
  
You will need to pass a string to Identicon.main. You will get back a Vix Vips code referencing your identicon image. Example input: 
```
iex> Identicon.main("Elixir")
``
Output:
```
%Vix.Vips.Image{ref: #Reference<0.3738600810.2635726871.219300>}
``

The image will automatically save in your Downloads directory as image.png 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```
