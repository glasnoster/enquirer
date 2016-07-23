require IEx
defmodule EnquirerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Enquirer
  import IO.ANSI, only: [red: 0, green: 0, yellow: 0, default_color: 0]

  describe "say" do
    test "it outputs a string to the terminal" do
      fun = fn -> Enquirer.say("hello world") end
      assert capture_io(fun) == "hello world\e[39m\n"
    end

    test "it outputs a number to the terminal" do
      fun = fn -> Enquirer.say(123) end
      assert capture_io(fun) == "123#{default_color}\n"
    end

    test "it outputs a string in red to the terminal" do
      fun = fn -> Enquirer.say("hello world", :red) end
      assert capture_io(fun) == "#{red}hello world#{default_color}\n"
    end

    test "it outputs a string in green to the terminal" do
      fun = fn -> Enquirer.say("hello world", :green) end
      assert capture_io(fun) == "#{green}hello world#{default_color}\n"
    end

    test "it outputs a string in yellow to the terminal" do
      fun = fn -> Enquirer.say("hello world", :yellow) end
      assert capture_io(fun) == "#{yellow}hello world#{default_color}\n"
    end
  end

  describe "get" do
    test "it gets input from the user" do
      fun = fn ->
        "What is your name?"
        |> Enquirer.get
        |> elem(1)
        |> IO.write
      end
      assert capture_io([input: "John Smith", capture_prompt: false], fun) == "John Smith"
    end
  end

  describe "choose" do
    test "it asks the user to choose an option" do
      fun = fn ->
        Enquirer.choose "Please choose an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3"
      end
      expected_output = """
Please choose an option
1. Option 1
2. Option 2
3. Option 3
"""
      assert capture_io([input: "1", capture_prompt: true], fun) == expected_output
    end

    test "it returns the chosen output" do
      fun = fn ->
        result = Enquirer.choose "Please option an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3"
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "1", capture_prompt: false], fun) == "option1"
    end

    test "it returns the last chosen output" do
      fun = fn ->
        result = Enquirer.choose "Please option an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3"
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "3", capture_prompt: false], fun) == "option3"
    end

    test "it returns an error when an invalid option is chosen" do
      fun = fn ->
        result = Enquirer.choose "Please option an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3"
        result |> elem(0) |> IO.write
      end
      assert capture_io([input: "4", capture_prompt: false], fun) == "error"
    end

    test "it returns an error when an invalid string is entered" do
      fun = fn ->
        result = Enquirer.choose "Please option an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3"
        result |> elem(0) |> IO.write
      end
      assert capture_io([input: "foo", capture_prompt: false], fun) == "error"
    end

    test "it displays the default option when a default is specified" do
      fun = fn ->
        Enquirer.choose "Please choose an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3",
          default: :option1
      end
      expected_output = """
Please choose an option
1. Option 1 (default)
2. Option 2
3. Option 3
"""
      assert capture_io([input: "1", capture_prompt: true], fun) == expected_output
    end

    test "it chooses the default option if no option is chosen and a default is provided" do
      fun = fn ->
        result = Enquirer.choose "Please option an option",
          option1: "Option 1",
          option2: "Option 2",
          option3: "Option 3",
          default: :option1
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "\n", capture_prompt: false], fun) == "option1"
    end
  end

  describe "ask" do
    test "it asks a yes/no question" do
      fun = fn ->
        Enquirer.ask("Is the sky blue?")
      end
      expected_output = "Is the sky blue? [Y/n]"
      assert capture_io([input: "Y", capture_prompt: true], fun) == expected_output
    end

    test "it returns true if the user chooses Y" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "Y", capture_prompt: false], fun) == "true"
    end

    test "it returns true if the user chooses y" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "y", capture_prompt: false], fun) == "true"
    end

    test "it returns true if the user chooses yes" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "yes", capture_prompt: false], fun) == "true"
    end

    test "it returns true if the user chooses Yes" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "Yes", capture_prompt: false], fun) == "true"
    end

    test "it returns false if the user chooses N" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "N", capture_prompt: false], fun) == "false"
    end

    test "it returns false if the user chooses n" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "n", capture_prompt: false], fun) == "false"
    end

    test "it returns false if the user chooses no" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "no", capture_prompt: false], fun) == "false"
    end

    test "it returns false if the user chooses No" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?")
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "No", capture_prompt: false], fun) == "false"
    end

    test "it returns true if the user presses return and the default is true" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?", true)
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "\n", capture_prompt: false], fun) == "true"
    end

    test "it returns false if the user presses return and the default is false" do
      fun = fn ->
        result = Enquirer.ask("Is the sky blue?", false)
        result |> elem(1) |> IO.write
      end
      assert capture_io([input: "\n", capture_prompt: false], fun) == "false"
    end

    test "it shows the correct default option" do
      fun = fn ->
        Enquirer.ask("Is the sky blue?", false)
      end
      expected_output = "Is the sky blue? [y/N]"
      assert capture_io([input: "Y", capture_prompt: true], fun) == expected_output
    end
  end

  describe "get_list" do
    test "it ask the user to enter a list of items" do
      fun = fn ->
        Enquirer.get_list("Enter your favourite colours")
      end
      expected_output = "Enter your favourite colours\n* * "
      assert capture_io([input: "Blue\n\n", capture_prompt: true], fun) == expected_output
    end

    test "returns a list or the input values" do
      prompt = "Enter your favourite colours"
      fun = fn ->
        result = Enquirer.get_list(prompt)
        result |> elem(1) |> Enum.join(",") |> IO.write
      end
      expected_output = "#{prompt}\nRed,Blue"
      assert capture_io([input: "Red\nBlue\n\n", capture_prompt: false], fun) == expected_output
    end
  end
end
