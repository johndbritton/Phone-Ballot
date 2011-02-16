require 'rubygems'
require 'sinatra'
require 'builder'
require 'rest_client'
require 'dm-core'
require 'dm-postgres-adapter'
require 'dm-migrations'
require 'dm-validations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Competitor
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true
  property :code, Integer, :required => true
end

class Authorization
  include DataMapper::Resource
  
  property :id, Serial
  property :phone, String
  property :pin, Integer
  property :used, Boolean, :default => false
end

class Vote
  include DataMapper::Resource
  
  property :id, Serial
end

DataMapper.auto_upgrade!

post '/call' do
  builder :call
end

post '/authorize_phone' do
  a = Authorization.first(:phone => params[:From])
  unless a.used then
    #you're all good, mark as used later
    builder :vote
  else
    #ask for a pin
    builder :authorize_pin
  end
end

post '/authorize_pin' do
  a = Authorization.first(:pin => params[:Digits])
  unless a.used then
    #you're all good, mark as used later
    builder :vote
  else
    #ask for pin
    builder :authorize_pin
  end
end

post '/collect_vote' do
  builder :collect_vote
end

post '/tally_vote' do
  c = Competitor.get(:code => params[:Digits])
  builder :confirm_vote
end