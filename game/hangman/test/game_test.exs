defmodule GameTest do
  use ExUnit.Case

    alias Hangman.Game

    test "new_game returns structure" do
      game = Game.new_game()

      assert game.turns_left == 7
      assert game.game_state == :initializing
      assert length(game.letters) > 0
      assert String.match?(List.to_string(game.letters), ~r/[a-zç]/)
    end

    test "state isn't changed for :won or :lost game" do
      for state <- [ :won, :lost ] do
        game = Game.new_game() |> Map.put(:game_state, state)
        assert { ^game, _ } = Game.make_move(game, "x")
      end
    end

    test "first occurrence of letter is not already used" do
      game = Game.new_game()
      { game, _tally }  = Game.make_move(game, "x")
      assert game.game_state != :already_used
    end

    test "second occurrence of letter is already used" do
      game = Game.new_game()
      { game, _tally }  = Game.make_move(game, "x")
      assert game.game_state != :already_used
      { game, _tally }  = Game.make_move(game, "x")
      assert game.game_state == :already_used
    end

    test "a good guess is recognized" do
      game = Game.new_game("caqui")
      { game, _tally } = Game.make_move(game, "c")
      assert game.game_state == :good_guess
    end

    test "a guessed word in a won game" do
      game = Game.new_game("caqui")
      { game, _tally } = Game.make_move(game, "c")
      assert game.game_state == :good_guess
      { game, _tally } = Game.make_move(game, "a")
      assert game.game_state == :good_guess
      { game, _tally } = Game.make_move(game, "q")
      assert game.game_state == :good_guess
      { game, _tally } = Game.make_move(game, "u")
      assert game.game_state == :good_guess
      { game, _tally } = Game.make_move(game, "i")
      assert game.game_state == :won
    end

    test "bad guess is recognized" do
      game = Game.new_game("caqui")
      { game, _tally } = Game.make_move(game, "x")
      assert game.game_state == :bad_guess
      assert game.turns_left == 6
    end

    test "lost game is recognized" do
      game = Game.new_game("caqui")
      { game, _tally } = Game.make_move(game, "x")
      assert game.game_state == :bad_guess
      assert game.turns_left == 6
      { game, _tally } = Game.make_move(game, "z")
      assert game.game_state == :bad_guess
      assert game.turns_left == 5
      { game, _tally } = Game.make_move(game, "ç")
      assert game.game_state == :bad_guess
      assert game.turns_left == 4
      { game, _tally } = Game.make_move(game, "ã")
      assert game.game_state == :bad_guess
      assert game.turns_left == 3
      { game, _tally } = Game.make_move(game, "é")
      assert game.game_state == :bad_guess
      assert game.turns_left == 2
      { game, _tally } = Game.make_move(game, "p")
      assert game.game_state == :bad_guess
      assert game.turns_left == 1
      { game, _tally } = Game.make_move(game, "w")
      assert game.game_state == :lost
    end

end
