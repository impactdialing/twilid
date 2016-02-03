require 'tilt/erb'
require 'tilt/builder'
require 'sinatra'
require 'puma'
require 'yajl/json_gem'
require_relative 'lib/dials'

configure do
  set :server, :puma
end


post '/*' do
  @account_sid     = Dials.account_sid
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

get '/2010-04-01/Accounts/AC422d17e57a30598f8120ee67feae29cd/Calls/:sid' do
  builder do |xml|
    xml.instruct!
    xml.TwilioResponse do
      xml.Call do
        xml.Sid params[:sid]
        xml.AccountSid Dials.account_sid
        xml.To Dials.phone_for(params[:sid])
        xml.From Dials.from
        xml.PhoneNumberSid ''
        xml.Status 'completed'
        xml.Duration rand(100).to_i
      end
    end
  end
end

get '/' do
  if params[:phone]
    Dials.sid_for(params[:phone])
  else
    "{\"code\":#{Dials.data.keys.size.to_s}}"
  end
end
