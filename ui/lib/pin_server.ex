defmodule PinServer do
  use GenServer

  def start_link(%Board{pins: pins}) do
    GenServer.start_link(__MODULE__, %{pins: pins}, name: __MODULE__)
  end

  def get_status() do
    GenServer.call(__MODULE__, {:get_pin_status})
  end

  def get_status(pin_number) do
    GenServer.call(__MODULE__, {:get_pin_status, pin_number})
  end

  def release(pin_number) do
    GenServer.call(__MODULE__, {:release, pin_number})
  end

  def set_direction(pin_number, direction) do
    GenServer.call(__MODULE__, {:set_direction, pin_number, direction})
  end

  def change_level(pin_number, level) do
    GenServer.call(__MODULE__, {:change_level, pin_number, level})
  end

  def update_pin_status(pin_number, changes) do
    GenServer.call(__MODULE__, {:update_pin_status, pin_number, changes})
  end

  def handle_call({:get_pin_status}, _from, state = %{pins: pins}) do
    {:reply, {:ok, pins}, state}
  end

  def handle_call({:get_pin_status, pin_number}, _from, state) do
    {:reply, {:ok, get_pin(pin_number, state)}, state}
  end

  def handle_call({:release, pin_number}, _from, state) do
    pin = get_pin(pin_number, state)
    send(pin.pid, {:release})
    {:reply, {:ok, pin}, state}
  end

  def handle_call({:set_direction, pin_number, direction}, _from, state) do
    pin = get_pin(pin_number, state)
    updated_pin = %{pin | pid: spawn_input_adapter(pin, direction)}
    pins = List.replace_at(state.pins, pin_number - 1, updated_pin)
    {:reply, {:ok, pin}, %{state | pins: pins}}
  end

  def handle_call({:change_level, pin_number, level}, _from, state) do
    pin = get_pin(pin_number, state)
    send(pin.pid, {:change_level, level})
    {:reply, {:ok, pin}, state}
  end

  def handle_call({:update_pin_status, pin_number, changes}, _from, state) do
    updated_pin = Map.merge(get_pin(pin_number, state), changes)
    pins = List.replace_at(state.pins, pin_number - 1, updated_pin)
    broadcast_pin_change(updated_pin)
    {:reply, {:ok, updated_pin}, %{state | pins: pins}}
  end

  defp spawn_input_adapter(pin, direction) do
    spawn(InputAdapter, :start, [self(), pin, direction])
  end

  defp get_pin(pin_number, %{pins: pins}) do
    Enum.at(pins, pin_number - 1)
  end

  defp broadcast_pin_change(pin) do
    resp = %{pin: Pin.serialize_pin(pin)}
    Ui.Endpoint.broadcast!("board:#{pin.pin_number}", "pin_status_changed", resp)
  end
end
