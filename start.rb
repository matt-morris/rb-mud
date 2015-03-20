#!/usr/bin/env ruby
require 'pry'
require './server'
require './game'

Server.new(3333, "localhost", Game.new)
