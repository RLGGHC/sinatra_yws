#syws.rb
require 'sinatra'
require 'net/http'
require 'rexml/document'

APPLICATION_ID = 'XIM4jgrV34GXdnMQfjYVcfY6YIMvb4FrOoBmcxAMHrVWrPPte0QDpYgieP5jZKFuCsL9'
YAHOO_WEB_SERVICE_SEARCH_URL = 'http://search.yahooapis.com/WebSearchService/V1/webSearch'


#---
def yahoo_search(query, results_limit)
  url = "#{YAHOO_WEB_SERVICE_SEARCH_URL}?appid=#{APPLICATION_ID}&query=#{URI.encode(query)}&results=#{results_limit}"
  begin
    xml_result_set = Net::HTTP.get_response(URI.parse(url))
  rescue Exception => e
    'Connection error: ' + e.message
  end

  result_set = REXML::Document.new(xml_result_set.body)
  @titles    = Array.new
  @summaries = Array.new
  @links     = Array.new

  result_set.elements.each('ResultSet/Result/Title') do | element |
    @titles << element.text
  end
  result_set.elements.each('ResultSet/Result/Summary') do | element |
    @summaries << element.text
  end
  result_set.elements.each('ResultSet/Result/Url') do | element |
    @links << element.text
  end
end
#---

not_found do
  erb :'404'
end

error do
  erb :'500'
end

# http://vivid-flower-63.heroku.com/
get '/' do
  erb :accept
end

post '/display' do
  erb :show
end 