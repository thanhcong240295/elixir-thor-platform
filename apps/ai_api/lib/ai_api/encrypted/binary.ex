defmodule AiApi.Encrypted.Binary do
  @moduledoc false

  use Ecto.Type

  def type, do: :binary

  def cast(nil), do: {:ok, nil}
  def cast(value) when is_binary(value), do: {:ok, value}
  def cast(_value), do: :error

  def load(nil), do: {:ok, nil}

  def load(value) when is_binary(value) do
    if AiApi.Encryption.enabled?() do
      AiApi.Encryption.decrypt(value)
    else
      {:ok, value}
    end
  end

  def dump(nil), do: {:ok, nil}

  def dump(value) when is_binary(value) do
    if AiApi.Encryption.enabled?() do
      AiApi.Encryption.encrypt(value)
    else
      {:ok, value}
    end
  end

  def dump(_value), do: :error

  def embed_as(_format), do: :self
  def equal?(left, right), do: left == right
end
