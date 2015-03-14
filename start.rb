#!/usr/bin/env ruby
require 'pry'
require './server'
require './game'

game = Game.new
Server.new(3333, "localhost", game)
