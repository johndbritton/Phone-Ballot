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
  
  def self.nth_place(n)
    ranked_competitors = all.sort {|a,b| -1*a.votes.count <=> b.votes.count}
    return ranked_competitors[n-1]
  end
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
  property :eligible, Boolean, :default =>true
  
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
  if a && params[:Digits]
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

post '/verify_vote' do
  if @competitor = Competitor.first(:code => params[:Digits])
    builder :verify_vote
  else
    builder :collect_vote
  end
end

post '/tally_vote' do
  if @competitor = Competitor.first(:code => params[:Digits])
    a = Authorization.first(:phone => params[:From], :used => false)
    v = Vote.new()
    v.authorization = a
    v.competitor = @competitor
    v.save
    a.used = true
    a.save
    builder :confirm_vote
  else
    builder :collect_vote
  end
end

get %r{/nth_place/(\d+)} do |n|
  @competitor = Competitor.nth_place(n.to_i)
  haml :nth_place
end

post '/host' do
  builder :host
end

post '/winner' do
  if params[:Digits].to_i == 0
    votes = Vote.all
  elsif params[:Digits].to_i == 9
    c1 = Competitor.nth_place(1)
    c2 = Competitor.nth_place(2)
    c3 = Competitor.nth_place(3)
    votes = c1.votes + c2.votes + c3.votes
  elsif params[:Digits]
    votes = Competitor.nth_place(params[:Digits].to_i).votes
  end

  votes = votes.all(:eligible => true)
  unless votes.count < 1 then
    @winning_vote = votes[rand(votes.count)]
    @winning_vote.eligible = false
    @winning_vote.save  
    builder :winner
  else
    builder :host
  end
end

get '/votes' do
  @votes = Vote.all
  haml :votes
end