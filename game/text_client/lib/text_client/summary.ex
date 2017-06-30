defmodule TextClient.Summary do
  def display(game = %{ tally: tally}) do
    IO.puts [
      "\n", 
      "palavra:    #{Enum.join(tally.letters, " ")}",
      "\n", 
      "chances restantes:   #{tally.turns_left}"
    ]
    game  
  end
end
