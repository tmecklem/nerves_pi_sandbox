defmodule Ui.BoardChannel do
  use Ui.Web, :channel

  def join("board", _params, socket) do
    {:ok, pins} = PinServer.get_status()
    pins_status = Enum.map(pins, fn (pin) -> Pin.serialize_pin(pin) end)
    {:ok, %{pins: pins_status}, socket}
  end

  def join("board:" <> pin_number, _params, socket) do
    pin_number = String.to_integer(pin_number)
    socket = assign(socket, :pin_number, pin_number)
    {:ok, pin} = PinServer.get_status(pin_number)
    {:ok, %{pin: Pin.serialize_pin(pin)}, socket}
  end

  def handle_in("release", _, socket) do
    PinServer.release(socket.assigns[:pin_number])
    {:reply, :ok, socket}
  end

  def handle_in("set_direction", %{"direction" => direction}, socket) do
    PinServer.set_direction(socket.assigns[:pin_number], String.to_atom(direction))
    {:reply, :ok, socket}
  end

  def handle_in("change_level", %{"level" => level}, socket) do
    PinServer.change_level(socket.assigns[:pin_number], String.to_atom(level))
    {:reply, :ok, socket}
  end
end
