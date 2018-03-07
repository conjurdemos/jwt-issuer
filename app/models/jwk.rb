require 'certificate_store'

class JWK
  def initialize kid
    @certificate = CertificateStore.instance.certificate kid
    @kid = kid
  end

  def to_h
    return {} if empty?

    {
      :kty => 'RSA',
      :kid => @kid,
      :x5t => @kid,
      :x5c => [Base64.encode64(@certificate.to_der)]
    }
  end

  def empty?
    @certificate.nil?
  end
end