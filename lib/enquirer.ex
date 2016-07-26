defmodule Enquirer do
  import IO.ANSI

  @moduledoc """
  Enquirer is a simple module to make is easy to get user input in terminal applications.
  """

  @doc """
  Outputs a string to the terminal, optionaly specifying a colour.
  Valid colours are `:red`, `:green` and `:yellow`
  """
  def say(something, colour \\ nil) do
    ansi = case colour do
      :red    -> red
      :green  -> green
      :yellow -> yellow
      _       -> ""
    end
    IO.puts "#{ansi}#{something}#{default_color}"
    {:ok, nil}
  end

  @doc """
  Gets input from the user.

  ```
  get "What is your name?"
  ```
  """
  def get(question) do
    answer = "#{question} " |> do_get
    {:ok, answer}
  end

  @doc """
  Allows the user to choose between options. An optional default can be supplied.

  Without a default:
  ```
  choose "What is your favourite colour?",
    red:    "Red",
    green:  "Green",
    yellow: "Yellow"
  ```

  With a default:
  ```
  choose "What is your favourite colour?",
    red:     "Red",
    green:   "Green",
    yellow:  "Yellow",
    default: :yellow
  ```
  """
  def choose(question, opts) do
    {default, choices} = Keyword.pop(opts, :default)
    option_string =
      choices
      |> Enum.with_index
      |> Enum.map_join(fn {{key, val}, index} -> "#{index + 1}. #{val}#{if key == default, do: " (default)"}\n" end)

    user_input = "#{question}\n#{option_string}" |> do_get
    user_choice = string_to_integer_safe(user_input)

    cond do
      user_choice && (user_choice <= Enum.count(choices)) ->
        {:ok, value_from_position(choices, user_choice)}
      user_choice ->
        {:error, nil}
      (user_input == "") && default ->
        {:ok, default}
      true ->
        {:error, nil}
    end
  end

  @doc """
  Asks the user a yes/no question. A default can be supplied.
  A `true` result indicates a "yes" answer. `false` indicated "no"

  Without a default:
  ```
  ask "Do you like oranges?"
  ```

  With a default:
  ```
  ask "So you like oranges?", false
  """
  def ask(question, default \\ true) do
    user_input = "#{question} [#{if default, do: "Y/n", else: "y/N"}]" |> do_get
    cond do
      user_input =~ ~r/^y(es)?/i -> {:ok, true}
      user_input =~ ~r/^n(o)?/i  -> {:ok, false}
      user_input == ""           -> {:ok, default}
      true                       -> {:error, nil}
    end
  end

  @doc """
  Asks the user a to enter a list of items. A blank line is treated as the end of the input

  ```
  get_list "Enter your favourite colours"
  ```
  """
  def get_list(question) do
    IO.puts "#{question}"
    {:ok, do_get_list}
  end

  defp do_get_list do
    option = IO.gets("* ") |> remove_trailing
    if option != "", do: [option] ++ do_get_list, else: []
  end

  defp remove_trailing(str) do
    String.replace_trailing(str, "\n", "")
  end

  defp do_get(string), do: string |> IO.gets |> remove_trailing

  defp string_to_integer_safe(str) do
    try do
      String.to_integer str
    rescue
      ArgumentError -> nil
    end
  end

  defp value_from_position(keywords, position) do
    keywords
    |> Enum.at(position - 1)
    |> elem(0)
  end

end
