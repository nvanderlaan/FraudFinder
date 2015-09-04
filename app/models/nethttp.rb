require "net/http"
require "openssl"
require "base64"
require "uri"
require "json"
require "cgi"


# constants because these are assigned to us as a user of the API and shouldn't ever change
UID = "6609"
APIKEY = "030a0348079fdd2aa3309e6cc79a8bcd"
# UNIX Timestamp set for some time in future-they recommend 20 min
$expires = (Time.now + 20*60).to_i

# Method for generating signature
def gen_signature
  string_to_sign = "#{UID}\n#{$expires}"
  hmac = OpenSSL::HMAC.digest('sha1', APIKEY, string_to_sign)
  encoded = Base64.strict_encode64(hmac)
  signature = CGI.escape(encoded)
end

# have to "freeze" timestamp of current signature

# why not just call gen-signature in other methods
$current_signature = gen_signature

def create_data_object(url)

  # sample pic, documentation says multiple images can be in an array
  url =
  # data to convey to json--images in array
  data = { uid: UID, expires: $expires, signature: $current_signature, images: [url] }
  # data must be in JSON format
  data = data.to_json

end




# Start http_request--POST

def first_request_and_response(url)
# request
  request = Net::HTTP::Post.new("https://incandescent.xyz/api/add/", initheader = {'Content-Type' => 'application/json'} )
  request.body = create_data_object(url)

# uri
  server_uri = URI.parse("https://incandescent.xyz/api/add/")

 # response
  http = Net::HTTP.new(server_uri.host, server_uri.port)
  http.use_ssl = true
  response = http.request(request)
  parsed_project_id = JSON.parse(response.body)["project_id"]

end
# p response


def second_request_and_response(url)

  # second post request with project_id

  second_data = { uid: UID, expires: $expires, signature: $current_signature, project_id: first_request_and_response(url)}.to_json

  # Notice POST url is now "api/get" rather than "api/add"

  second_request = Net::HTTP::Post.new("https://incandescent.xyz/api/get/", initheader = {'Content-Type' => 'application/json'} )
  second_request.body = second_data

  second_uri = URI.parse("https://incandescent.xyz/api/get/")

  sleep(75)

  second_http = Net::HTTP.new(second_uri.host, second_uri.port)
  second_http.use_ssl = true
  second_response = second_http.request(second_request)

  # final data hash
  return final_response = JSON.parse(second_response.body)

end

# p second_request_and_response("https://c2.staticflickr.com/8/7655/16835447460_0126ec60ca_b.jpg")

# below was attempt to get server to "stay open" to wait for response, rather than the "sleep" solution

# Net::HTTP.start(second_uri.host, second_uri.port) do |second_http|
#   second_request = Net::HTTP::Post.new("https://incandescent.xyz/api/get/", initheader = {'Content-Type' => 'application/json'} )
#   second_request.body = second_data

#   second_http = Net::HTTP.new(second_uri.host, second_uri.port)
#   second_http.use_ssl = true
#   second_response = second_http.request(second_request)
#   p JSON.parse(second_response.body)
# end
