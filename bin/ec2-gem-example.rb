#!/usr/bin/env ruby1.8
#
# This file was generated by Bundler.
#
# The application 'ec2-gem-example.rb' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path("../../Gemfile",
  Pathname.new(__FILE__).realpath)

require 'rubygems'
require 'bundler/setup'

load Gem.bin_path('amazon-ec2', 'ec2-gem-example.rb')
