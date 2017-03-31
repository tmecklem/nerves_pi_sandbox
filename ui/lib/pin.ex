defmodule Pin do
  defstruct pin_number: nil, gpio: nil, description: nil, characteristics: [], pid: nil, direction: nil, level: nil

  def configurable?(pin) do
    pin.characteristics -- [:ground, :power_5v, :power_3v3, :id_sd, :id_sc]
  end

  def serialize_pin(pin) do
    Map.split(pin, [:pin_number, :gpio, :description, :characteristics, :direction, :level]) |> elem(0)
  end
end
