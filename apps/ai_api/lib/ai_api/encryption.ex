defmodule AiApi.Encryption do
  @moduledoc false

  @aad "ai_api.db"
  @ciphertext_version 1
  @iv_length 12
  @tag_length 16

  def enabled? do
    is_binary(Application.get_env(:ai_api, :db_encryption_key))
  end

  def encrypt(plaintext) when is_binary(plaintext) do
    iv = :crypto.strong_rand_bytes(@iv_length)

    {ciphertext, tag} =
      :crypto.crypto_one_time_aead(:aes_256_gcm, key!(), iv, plaintext, @aad, @tag_length, true)

    {:ok, <<@ciphertext_version, iv::binary, tag::binary, ciphertext::binary>>}
  end

  def decrypt(
        <<@ciphertext_version, iv::binary-size(@iv_length), tag::binary-size(@tag_length),
          ciphertext::binary>>
      ) do
    case :crypto.crypto_one_time_aead(:aes_256_gcm, key!(), iv, ciphertext, @aad, tag, false) do
      :error -> {:error, :invalid_ciphertext}
      plaintext -> {:ok, plaintext}
    end
  end

  def decrypt(_ciphertext), do: {:error, :invalid_ciphertext}

  def normalize_email(email) when is_binary(email) do
    email
    |> String.trim()
    |> String.downcase()
  end

  def email_hash(email) when is_binary(email) do
    email
    |> normalize_email()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp key! do
    key = Application.get_env(:ai_api, :db_encryption_key)

    if is_binary(key) and byte_size(key) == 32 do
      key
    else
      raise "ai_api :db_encryption_key must be a 32-byte binary"
    end
  end
end
