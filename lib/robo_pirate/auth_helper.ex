defmodule RoboPirate.AuthHelper do
  @sign_secret Application.get_env(:robo_pirate, :sign_secret)

  def from_slack?(%Plug.Conn{assigns: %{raw_body: body}, req_headers: header}) do
    from_slack?(body, Map.new(header))
  end

  def from_slack?(_) do
    false
  end

  defp from_slack?(body, %{"x-slack-signature" => signature, "x-slack-request-timestamp" => timestamp}) do
    age_in_seconds =
      timestamp
    |> String.to_integer
    |> DateTime.from_unix(:second)
    |> elem(1)
    |> DateTime.diff(DateTime.utc_now())
    |> abs

    signed = :crypto.hmac(:sha256, @sign_secret, "v0:#{timestamp}:#{body}")
    |> Base.encode16
    |> String.downcase
    cond do
      age_in_seconds > 20 -> false # Might be replay attack
      "v0=#{signed}" == signature -> true # valid
      true -> false # Default to not from slack
    end
  end

  defp from_slack?(_, _) do
    false
  end
end
