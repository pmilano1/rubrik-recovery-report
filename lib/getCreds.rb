require 'json'
require 'openssl'
require 'io/console'
require 'getCreds.rb'
require 'getCreds.rb'

def getCreds(cluster)
  begin
    if File.exists?('.creds')
      creds = JSON.parse(File.read('.creds'))
      if creds["#{cluster}"]
        return creds
      else
        puts "Credentials not found, prompting for details"
        cred_hash = addCreds(cluster, creds)
        return cred_hash
      end
    else
      puts "Credentials not found, prompting for details"
      cred_hash = addCreds(cluster, '')
      return cred_hash
    end
  rescue StandardError => e
    return e
  end
end

def addCreds(name, cred_hash)
  begin
    unless (cred_hash.class == Hash)
      cred_hash = Hash.new
    end
    cred_hash["#{name}"] = Hash.new
    print "Please enter Rubrik Node FQDNs/IPs for Cluster Name #{name} (comma delimited) : > "
    servers = gets
    cred_hash["#{name}"]["servers"] = servers.strip.split(',')
    print "Please enter Username : > "
    cred_hash["#{name}"]["username"] = encrypt(gets.strip, name)
    print "Please enter Password : > "
    cred_hash["#{name}"]["password"] = encrypt(STDIN.noecho(&:gets).strip, name)
    File.write(".creds", JSON.dump(cred_hash))
    return cred_hash
  rescue
    puts "Problem getting login information"
  end
end

def encrypt(plain_text, key)
  cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
  cipher.key = (Digest::SHA1.hexdigest key)[0..23]
  s = cipher.update(plain_text) + cipher.final
  s.unpack('H*')[0].upcase
end

def decrypt(cipher_text, key)
  cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
  cipher.key = (Digest::SHA1.hexdigest key)[0..23]
  s = [cipher_text].pack("H*").unpack("C*").pack("c*")
  cipher.update(s) + cipher.final
end

