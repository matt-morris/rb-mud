#!/usr/bin/env ruby
require 'pry'
require './server'
require './game'

class System
  attr_accessor :game, :server

  def initialize
    $game = Game.new
    $server = Server.new(3333, "localhost")
  end
end

system = System.new
