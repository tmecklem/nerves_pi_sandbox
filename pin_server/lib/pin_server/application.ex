defmodule PinServer.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PinServer.PinServer, [PinServer.Board.board(args[:board]), pin_adapter(args[:pin_adapter])])
    ]
    opts = [strategy: :one_for_one, name: PinServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pin_adapter(:simulator), do: PinServer.SimulatorInputAdapter
  defp pin_adapter(:elixir_ale), do: PinServer.ElixirALEInputAdapter
end
