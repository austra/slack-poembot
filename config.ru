$stdout.sync = true
$LOAD_PATH << './lib'
require 'poembot'

run PoemBot::Web
