require 'rubygems'
require 'sinatra'

get '/:foo' do
  "#{params[:foo]} #{Time.now.iso8601}"
end
