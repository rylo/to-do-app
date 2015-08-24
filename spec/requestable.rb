require 'excon'

module Requestable
  def get(path)
    Excon.get("http://localhost:4567/#{CGI.escape(path)}")
  end

  def post(path, body)
    Excon.post(
      "http://localhost:4567/#{CGI.escape(path)}",
      headers: { 'Content-Type' => 'application/json' },
      body: JSON.generate(body)
    )
  end
end
