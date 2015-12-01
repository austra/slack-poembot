#ruby

require 'bundler/setup'
require 'sinatra'
require 'pry'
require 'json'
require './vig.rb'

module PoemBot
  class Web < Sinatra::Base

    before do
      #return 401 unless request["token"] == ENV['SLACK_TOKEN']
    end
    
    configure do

    end

    post "/poem" do
      input = params[:text].gsub(params[:trigger_word],"").strip

      if input != ""
        cc = Cc.new
        cc.loadTables("./ctab.txt")
        cc.log = false # 

        s = cc.dorule(input)

        text = cc.postProcess(s)
        
        #text = "{ 'attachments': [ { 'fallback': input, 'title': input,'text': poem,'color': '#764FA5' } ]}"

        
      else
        text = "Try poem, happypoem, evilpoem, epicpoem, or sonnet (poem evilpoem)"
      end

      status 200
      reply = { username: 'poembot', icon_emoji: ':alien:', text: text }
      return reply.to_json

    end
  end
end
