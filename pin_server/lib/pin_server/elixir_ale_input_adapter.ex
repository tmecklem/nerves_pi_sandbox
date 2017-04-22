defmodule PinServer.ElixirALEInputAdapter do
  alias ElixirALE.GPIO
  alias PinServer.Pin

  def start(pin_server, %Pin{pin_number: pin_number, gpio: gpio}, direction) do
    {:ok, pid} = GPIO.start_link(gpio, direction)

    if direction == :input do
      :ok = GPIO.set_int(pid, :both)
    end

    PinServer.PinServer.update_pin_status(pin_number, %{pid: self(), direction: direction})

    loop(pid, pin_number)
  end

  def loop(pid, pin_number) do
    receive do
      {:gpio_interrupt, _, :rising} ->
        PinServer.PinServer.update_pin_status(pin_number, %{level: :high})
        loop(pid, pin_number)
      {:gpio_interrupt, _, :falling} ->
        PinServer.PinServer.update_pin_status(pin_number, %{level: :low})
        loop(pid, pin_number)
      {:change_level, :high} ->
        GPIO.write(pid, 1)
        PinServer.PinServer.update_pin_status(pin_number, %{level: :high})
        loop(pid, pin_number)
      {:change_level, :low} ->
        PinServer.PinServer.update_pin_status(pin_number, %{level: :low})
        GPIO.write(pid, 0)
        loop(pid, pin_number)
      {:release} ->
        GPIO.release(pid)
        PinServer.PinServer.update_pin_status(pin_number, %{pid: nil, direction: nil, level: nil})
    end
  end
end
