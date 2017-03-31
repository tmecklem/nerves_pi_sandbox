defmodule Fw.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Phoenix.PubSub.PG2, [Nerves.PubSub, [poolsize: 1]]),
      worker(Task, [fn -> start_network end], restart: :transient)
      # worker(Fw.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_network do
    {:ok, pid} = Nerves.Networking.setup :usb0, mode: "static", ip: "192.168.73.1", router:
    "192.168.73.1", mask: "24", subnet: "255.255.255.0", mode: "static",
      dns: "8.8.8.8 8.8.4.4", hostname: "rpi0"

    System.cmd("dnsmasq", ["--interface=usb0", "--bind-interfaces", "--dhcp-range=192.168.73.2,192.168.73.99,12h", "--no-resolv"])

    {:ok, pid}
  end
end
