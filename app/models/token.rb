require 'jwt'
require 'openssl'
require 'certificate_store'

class Token
  def initialize payload_params
    thumbprint, pair = CertificateStore.instance.default_pair
    url = ENV['SERVICE_URL'] || ''
    exp = Time.now.to_i + 180

    payload = {
      :exp => exp,
      :iat => Time.now.to_i
    }

    payload_params.each do |k, v|
      payload[k] = v
    end

    header = {
      :typ => 'JWT',
      :kid => thumbprint,
      :x5u => "#{url}/jwk/#{thumbprint}"
    }

    @jwt = JWT.encode payload, pair[:signing_key], algorithm='RS256', header_fields=header
  end

  def jwt
    @jwt
  end
end