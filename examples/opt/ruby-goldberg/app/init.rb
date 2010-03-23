require 'rubygems'
require 'sinatra'

get '/knock' do
  "Who's there?"
end

get '/:foo' do
  "#{params[:foo]} #{Time.now.iso8601}"
end
