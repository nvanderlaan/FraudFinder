require "net/http"
require "openssl"
require "base64"
require "uri"
require "json"

# UID - this is unique to you
uid = "6609"

# API Key - this is unique to you
apikey = "030a0348079fdd2aa3309e6cc79a8bcd"

# Expires - when the signature will become invalid (UNIX timestamp) - may be no more than 1200 seconds from now.
expires = "1441313473"#DateTime.now+1190

# Generate Signature
stringToSign = uid+"\n"+expires
binarySignature = OpenSSL::HMAC.digest('sha1', apikey, stringToSign)
# puts "binary sig: #{binarySignature}"
signature = URI.escape(Base64.encode64(binarySignature));
# p signature
data = {"uid"=>uid,"expires"=>expires,"signature"=>signature}
# p data
# p data.to_json

# ^^^^^^^^^^^^^^^^^ END OF SIGNATURE CODE ^^^^^^^^^^^^^

# require "net/http"
# require "uri"

post "/searches" do
  url = params[:source_img_url]
  data = { uid: uid, expires: expires, signature: signature, images: url }

  content_type :json
  jsonObj = data.to_json

  uri = URI("https://incandescent.xyz/api/add/")

  request = Net::HTTP::Post.new("https://incandescent.xyz/api/add/", initheader = {'Content-Type' => 'application/json'} )
  request.body = jsonObj

  response = Net::HTTP.get_response(uri)

  p response.code
  p response.body
  p response.message

  redirect "/"
end
