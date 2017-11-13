lib = File.expand_path("..", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ruboty/actions/eriones"
require "ruboty/actions/eorzea_time"
require "ruboty/actions/ff14angler"
require "ruboty/handlers/eriones"
require "ruboty/handlers/eorzea_time"
require "ruboty/handlers/ff14angler"
