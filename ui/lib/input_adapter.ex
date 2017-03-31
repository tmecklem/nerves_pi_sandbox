defmodule InputAdapter do
  def start(pin_server, %Pin{pin_number: pin_number}, direction, level \\ :low) do
    {:ok, pin} = PinServer.update_pin_status(pin_number, %{direction: direction, level: level})
    if direction == :input do
      Process.send_after(self(), {:continue}, Enum.random(1000..10000))
    end
    receive do
      {:continue} ->
        start(pin_server, pin, direction, flip_level(level))
      {:change_level, new_level} ->
        PinServer.update_pin_status(pin_number, %{level: new_level})
        start(pin_server, pin, direction, new_level)
      {:release} ->
        PinServer.update_pin_status(pin_number, %{pid: nil, direction: nil, level: nil})
    end
  end

  defp flip_level(:low), do: :high
  defp flip_level(:high), do: :low
end
