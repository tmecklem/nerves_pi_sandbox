defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"
  Mix.shell.info([:green, """
  Env
    MIX_TARGET:   #{@target}
    MIX_ENV:      #{Mix.env}
  """, :reset])
  def project do
    [app: :fw,
     version: "0.1.0",
     elixir: "~> 1.4.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.3.0"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: application(@target)

  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke Fw.start/2 when running on a target.
  def application("host") do
    [extra_applications: [:logger, :pin_server]]
  end
  def application(_target) do
    [mod: {Fw.Application, []},
     extra_applications: [:logger, :nerves_networking, :pin_server]]
  end

  def deps do
    [{:nerves, "~> 0.5.1", runtime: false}] ++
    deps(@target)
  end

  # Specify target specific dependencies
  def deps("host"), do: []
  def deps("rpi0") do
    [{:nerves_runtime, "~> 0.1.0"},
     {:"rpi0_gadget_ethernet", github: "tmecklem/rpi0_gadget_ethernet", tag: "v0.12.0", runtime: false},
     {:nerves_networking, github: "nerves-project/nerves_networking"},
     {:pin_server, path: "../pin_server"},
     {:ui, path: "../ui"},
     {:elixir_ale, "~> 0.6.0"}]
  end

  # We do not invoke the Nerves Env when running on the Host
  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
