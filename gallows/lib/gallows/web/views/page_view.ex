defmodule Gallows.Web.PageView do
  use Gallows.Web, :view

  def plural_of(word, 1), do: word

  def plural_of(word, _), do: word <> "s"
  
end
