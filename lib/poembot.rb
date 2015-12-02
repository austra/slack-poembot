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
      input = params[:text].sub(params[:trigger_word],"").strip

      if input != ""
        cc = Cc.new
        cc.loadTables("./ctab.txt")
        cc.log = false # 

        poem = cc.dorule(input)
        poem = cc.postProcess(poem)

        description = cc.dorule('description')
        description = cc.postProcess(description)

        author = cc.dorule('author')
        author = cc.postProcess(author)

        title = poem.split("----=-==-====-==-=----")[0]
        poem = poem.split("----=-==-====-==-=----")[1]

        #can't get this to work as message attachment
        text = [{
          fallback: description,
          author_name: author,
          title: title,
          title_link: '',
          text: poem,
          color: '#36a64f'
        }]

        status 200
        reply = { username: 'poembot', icon_emoji: ':alien:', text: poem }
        return reply.to_json
      else
        text = "Try poem, happypoem, evilpoem, epicpoem, or sonnet (poem evilpoem)"
        status 200
        reply = { username: 'poembot', icon_emoji: ':alien:', text: text }
        return reply.to_json
      end
    end
  end
end
