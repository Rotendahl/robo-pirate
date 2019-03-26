defmodule RoboPirate.ActionHandler do
  alias RoboPirate.Actions.InviteHandler

  def handle_action(action = %{"actions" => [%{"value" => "invite"} | _]}) do
    InviteHandler.invite(action)
  end

  def handle_action(_) do
    {:error, "Unhandled action"}
  end
end
