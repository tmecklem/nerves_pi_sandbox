defmodule InputAdapter do
  alias ElixirALE.GPIO

  def start(pin_server, %Pin{pin_number: pin_number, gpio: gpio}, direction) do
    {:ok, pid} = GPIO.start_link(gpio, direction)

    if direction == :input do
      :ok = GPIO.set_int(pid, :both)
    end

    PinServer.update_pin_status(pin_number, %{pid: self(), direction: direction})

    loop(pid, pin_number)
  end

  def loop(pid, pin_number) do
    receive do
      {:gpio_interrupt, _, :rising} ->
        PinServer.update_pin_status(pin_number, %{level: :high})
        loop(pid, pin_number)
      {:gpio_interrupt, _, :falling} ->
        PinServer.update_pin_status(pin_number, %{level: :low})
        loop(pid, pin_number)
      {:change_level, :high} ->
        GPIO.write(pid, 1)
        PinServer.update_pin_status(pin_number, %{level: :high})
        loop(pid, pin_number)
      {:change_level, :low} ->
        PinServer.update_pin_status(pin_number, %{level: :low})
        GPIO.write(pid, 0)
        loop(pid, pin_number)
      {:release} ->
        GPIO.release(pid)
        PinServer.update_pin_status(pin_number, %{pid: nil, direction: nil, level: nil})
    end
  end

  # def start(pin_server, %Pin{pin_number: pin_number}, direction, level \\ :low) do
  #   {:ok, pin} = PinServer.update_pin_status(pin_number, %{direction: direction, level: level})
  #   if direction == :input do
  #     Process.send_after(self(), {:continue}, Enum.random(1000..10000))
  #   end
  #   receive do
  #     {:continue} ->
  #       start(pin_server, pin, direction, flip_level(level))
  #     {:change_level, new_level} ->
  #       PinServer.update_pin_status(pin_number, %{level: new_level})
  #       start(pin_server, pin, direction, new_level)
  #     {:release} ->
  #       PinServer.update_pin_status(pin_number, %{pid: nil, direction: nil, level: nil})
  #   end
  # end

  # defp flip_level(:low), do: :high
  # defp flip_level(:high), do: :low
end
