defmodule Shopify.GraphQL.Response do
  alias Shopify.GraphQL.{ Config, Http }

  defstruct [:body, :headers, :status_code]

  @type t ::
          %__MODULE__{
            body: term,
            headers: Shopify.GraphQL.http_headers_t(),
            status_code: Shopify.GraphQL.http_status_code_t()
          }

  @spec new(Http.response_t(), Config.t()) :: t
  def new(response, config) do
    body =
      response
      |> Map.get(:body)
      |> decode_body(config)

    %__MODULE__{}
    |> Map.put(:body, body)
    |> Map.put(:headers, Map.get(response, :headers))
    |> Map.put(:status_code, Map.get(response, :status_code))
  end

  defp decode_body(body, _) when is_map(body), do: body

  defp decode_body(body, config) do
    config.json_codec.decode!(body)
  end
end
