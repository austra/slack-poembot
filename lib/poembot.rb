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
      begin
        cc = Cc.new
        cc.loadTables("./ctab.txt")
        cc.log = false # 

        s = cc.dorule("epicpoem")
        # print "\n\n-----\n\n"
        #print cc.postProcess(s)
        # print "\n\n-----\n\n"


        hp = cc.dorule('description') 
        @poem = cc.postProcess(s)
      rescue => e
        p e.message
        halt
      end

      status 200
      reply = { username: 'poembot', icon_emoji: ':alien:', text: @poem }
      return reply.to_json
    end
  end
end
