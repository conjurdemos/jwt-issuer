require 'singleton'

class CertificateStore
  include Singleton

  def initialize()
    root_key = OpenSSL::PKey::RSA.new 2048
    root_ca = OpenSSL::X509::Certificate.new
    root_ca.version = 2
    root_ca.serial = 1
    root_ca.subject = OpenSSL::X509::Name.parse "/DC=org/DC=conjur/CN=Conjur"
    root_ca.issuer = root_ca.subject
    root_ca.public_key = root_key.public_key
    root_ca.not_before = Time.now
    root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = root_ca
    ef.issuer_certificate = root_ca
    root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
    root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
    root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always,issuer:always",false))
    root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)

    @certificates = {
      CertificateStore.thumbprint(root_ca) => {
        :signing_key => root_key,
        :certificate => root_ca
      }
    }
  end

  def default_pair
    @certificates.first
  end

  def certificate kid
    pair = @certificates[kid]
    pair[:certificate] if pair.present?
  end

  def signing_key **args
    if args.count.eql? 0
      signing_key = @certificates.values.first[:signing_key]
      return signing_key
    end

    kid = args.first
    pair = @certificates[kid]
    pair[:signing_key] if pair.present?
  end

  def self.thumbprint key
    key = Base64.decode64(key.to_der)
    OpenSSL::Digest::SHA1.hexdigest(key)
  end
end