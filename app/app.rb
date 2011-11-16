require 'rubygems'
require 'sinatra'
require './app/models/image'

set :views, settings.root + '/app/views'

def match(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

match '/' do
  @files = ImageProcess.get_colors

  erb :index
end