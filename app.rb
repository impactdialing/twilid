require 'sinatra'
require 'puma'
require 'yajl/json_gem'
require 'uuid'

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
  @uuid            = UUID.new
  @time            = Time.now.utc.strftime('%a, %d %b %Y %H:%I:%S %z')

  pool     = (1..100).to_a
  template = :dial_success
  #if pool.sample == 1
  #  template = :dial_error
  #end
  erb template
end

get '/*' do
  '{}'
end
