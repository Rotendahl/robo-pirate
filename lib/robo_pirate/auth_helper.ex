defmodule RoboPirate.AuthHelper do
  @moduledoc """
    Module that helps check that messages actually come form slack. 
  """
  @sign_secret Application.get_env(:robo_pirate, :sign_secret)
  @max_age Application.get_env(:robo_pirate, :max_age)

  def from_slack?(%Plug.Conn{assigns: %{raw_body: body}, req_headers: header}) do
    from_slack?(body, Map.new(header))
  end

  def from_slack?(_) do
    false
  end

  defp from_slack?(body, %{
         "x-slack-signature" => signature,
         "x-slack-request-timestamp" => timestamp
       }) do
    age_in_seconds =
      timestamp
      |> String.to_integer()
      |> DateTime.from_unix(:second)
      |> elem(1)
      |> DateTime.diff(DateTime.utc_now())
      |> abs

    signed =
      :crypto.hmac(:sha256, @sign_secret, "v0:#{timestamp}:#{body}")
      |> Base.encode16()
      |> String.downcase()

    cond do
      # Might be replay attack
      age_in_seconds > @max_age -> false
      # valid
      "v0=#{signed}" == signature -> true
      # Default to not from slack
      true -> false
    end
  end

  defp from_slack?(_, _) do
    false
  end
end
