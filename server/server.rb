# server.rb
# requires sinatra & thin gems:
# gem install sinatra
# gem install thin

# Ruby Uno Server
require 'sinatra'
require 'json'

require './polar.rb'

class HeartBeatServer
  begin
    BluetoothPolarHrm.connect('00:22:D0:01:ED:3B').each do |d|
      warn d
    end
  rescue
    p 'failed'
  end
  bpm1 = 111
  p bpm1

  def get_bpm unitnumber
    #return 0 unless connectedok
    return bpm1
  end

end

hbmon = HeartBeatServer.new 
###### Sinatra Part ###### 
 
set :port, 8080
set :environment, :production
set :public_folder, '/home/vagrant/server'

error Sinatra::NotFound do
  content_type 'text/plain'
  [404, 'Not Found']
end

get '/' do
  redirect '/html/index.html'
end
 
get '/bpm' do
  return_message = {} 
  jdata = JSON.parse(params[:data],:symbolize_names => true) 
  if jdata.has_key?(:data) #&& uno.join_game(jdata[:name]) 
    return_message[:status] = 'good'
    return_message[:bpm] = hbmon.get_bpm
  else
    return_message[:status] = 'unavailable'
  end
  return_message.to_json 
end
 
post '/connect' do
  return_message = {}
  if params.has_key?(:id) # && hbmonitor.connect(jdata[:unitid])
    return_message[:status] = 'success'
  else
    #status 404
    return_message[:status] = 'fail'
  end
  return_message.to_json
end

get '/status' do
  return_message = {}
  if params.has_key?('id')
    #cards = uno.get_cards(params['name'])
    #if cards.class == Array
    #  return_message[:status] == 'success'
    #  return_message[:cards] = cards
    #else
    #  return_message[:status] = 'sorry - it appears you are not part of the game'
    #  return_message[:cards] = []
    #end
    return_message[:id] = params['id']
    return_message.to_json
  else
    status 400
    body 'id parameter is not specified'
  end
end
