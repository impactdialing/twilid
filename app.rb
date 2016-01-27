require 'tilt/erb'
require 'sinatra'
require 'puma'
require 'yajl/json_gem'
require_relative 'lib/dials'

configure do
  set :server, :puma
end

post '/*' do
  @to              = params[:To]
  @from            = params[:From]
  @campaign_type   = params[:campaign_type]
  @campaign_id     = params[:campaign_id]
  @url             = params[:Url]
  @status_callback = params[:StatusCallback]
  @fallback        = params[:FallbackUrl]
  @time            = Time.now.utc.strftime('%a, %d %b %Y %H:%I:%S %z')
  @sid             = Dials.sid_for params[:To]

  pool     = (1..100).to_a
  template = :dial_success
  #if pool.sample == 1
  #  template = :dial_error
  #end
  p "SID[#{@sid}] Phone[#{@to}]"
  erb template
end

get '/*' do
  if params[:phone]
    Dials.sid_for(params[:phone])
  else
    "{\"code\":#{Dials.data.keys.size.to_s}}"
  end
end
