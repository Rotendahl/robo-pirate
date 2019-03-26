defmodule RoboPirate.ActionHandler do
  @moduledoc """
    Module that handles all actions by calling other functions.
    They should all return {:ok, msg} or {:error, reasons}
  """
  alias RoboPirate.Actions.InviteHandler

  def handle_action(action = %{"actions" => [%{"value" => "invite"} | _]}) do
    InviteHandler.invite(action)
  end

  def handle_action(_) do
    {:error, "Unhandled action"}
  end
end
