defmodule Enquirer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :enquirer,
      version: "0.1.0",
      elixir: "~> 1.3",
      description: "Enquirer is a simple module to make is easy to get user input in terminal applications.",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    [
      maintainers: ["Martin Pretorius"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/glasnoster/enquirer"}
    ]
  end

  defp deps do
    [{:ex_doc, "~> 0.12", only: :dev}]
  end
end
