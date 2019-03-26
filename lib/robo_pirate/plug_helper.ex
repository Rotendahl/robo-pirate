defmodule RoboPirate.RawPlug do
  @moduledoc """
    Adds the raw body to the conn to make it easier to check the signature of
    a slack payload. 
  """
  def read_body(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end
end
