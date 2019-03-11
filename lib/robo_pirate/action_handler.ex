defmodule RoboPirate.ActionHandler do
  @vote_interval 120 #seconds
  @votes_needed 5

  def handle_action(action=%{"callback_id" => "forslag"}) do
    IO.inspect action
    %{
      "actions" => [%{"value" => decision } | _],
      "original_message" => msg,
      "user" => %{"id" => user}
    } = action

    cond do
      has_voted(user,  msg["attachments"]) ->
        if seconds_between_msg_vote(action) > @vote_interval do
          {:ok, resp} = %{
            "response_type" => "ephemeral",
            "replace_original" => false,
            "text" => "Din stemme er låst fast, da der er gået over " <>
            "#{Float.round(@vote_interval/60, 2)} minutter"
          } |>Poison.encode()
          resp
        else
          final_attachments =
          remove_vote(msg["attachments"], user)
          |> cast_vote(user, decision)

          {:ok, resp} = %{
            "text"=> add_decision(final_attachments, msg["text"]),
            "attachments" => final_attachments
          } |> Poison.encode()
          resp
        end
      true ->
        final_attachments = cast_vote(msg["attachments"], user, decision)
        {:ok, resp} = %{
          "text"=> add_decision(final_attachments, msg["text"]),
          "attachments" => final_attachments
        } |> Poison.encode()
        resp
    end
  end

  def handle_action(action) do
    IO.inspect("unhandled action")
    IO.inspect(action)
  end

  defp cast_vote(attachments, user, decision) do
    decision_record = Enum.filter(attachments,
      fn attach -> attach["text"] =~ decision end
    ) |> hd
    val = decision_record["text"] <> " <@#{user}>"
    Enum.map(attachments,
      fn attach -> if attach["id"] == decision_record["id"] do
        Map.put(decision_record, "text", val)
      else
        attach
      end
    end)
  end

  defp add_decision(attachments, text) do
    nr_votes = Enum.filter(attachments,
      fn attach -> attach["text"] =~ "Stemmer for" end
    )
    |> hd
    |> Map.get("text")
    |> String.split("<@")
    |> length
    |>  Kernel.-(1)

    status = "\*Forslag godkendt!\*\n"
    if nr_votes >= @votes_needed and not(text =~ status) do
      status <> text
    else
      String.replace(text, status, "")
    end
  end

  defp remove_vote(attachments, user) do
    votes = Enum.map(attachments, fn attach ->
      if attach["text"] =~ user do
        val = attach["text"]
        |> String.split(" ")
        |> Enum.filter(fn votes -> not (votes =~ user) end)
        |> Enum.join(" ")
        Map.put(attach, "text", val)
      else
        attach
      end
    end)
    votes
  end

  defp has_voted(user, attachmens) do
    Enum.reduce(attachmens, false, fn attach, acc ->
      attach["text"] =~ user or acc
    end)
  end

  defp seconds_between_msg_vote(%{"message_ts" => msg, "action_ts" => act}) do
    msg_time = msg
    |> String.split(".")
    |> hd
    |> String.to_integer()

    act_time = act
    |> String.split(".")
    |> hd
    |> String.to_integer()

    act_time - msg_time
  end
end