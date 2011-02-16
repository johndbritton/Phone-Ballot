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
  
  has n, :votes
end

class Authorization
  include DataMapper::Resource
  
  property :id, Serial
  property :phone, String
  property :pin, Integer
  property :used, Boolean, :default => false
  
  has 1, :vote
end

class Vote
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :competitor
  belongs_to :authorization
end

DataMapper.auto_upgrade!

post '/call' do
  builder :call
end

post '/authorize_phone' do
  a = Authorization.first(:phone => params[:From], :used => false)
  if a
    builder :collect_vote
  else
    builder :authorize_pin
  end
end

post '/authorize_pin' do
  a = Authorization.first(:pin => params[:Digits], :used => false)
  if a
    a.phone = params[:From]
    a.save
    builder :collect_vote
  else
    builder :authorize_pin
  end
end

post '/collect_vote' do
  builder :collect_vote
end

post '/tally_vote' do
  if c = Competitor.first(:code => params[:Digits])
    a = Authorization.first(:phone => params[:From])
    v = Vote.new()
    v.authorization = a
    v.competitor = c
    v.save
    a.used = true
    a.save
    @name = c.name
    builder :confirm_vote
  else
    builder :collect_vote
  end
end