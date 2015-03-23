#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require_relative "bundle/bundler/setup"

require "alfred"
require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.omniref.com'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  query = ARGV[0]

  if query && query.length > 2
    response = Nokogiri::HTML(open(BASE_URL + "/?q=#{query}&p=0&r=5"))
    results = response.css('li.result').map {|result| [result.css('a')[0].text, result.css('a')[0]['href']]}
    results.first(10).each do |result|
      fb.add_item({
        :uid      => "",
        :title    => result.first,
        :arg      => BASE_URL + result.last,
        :valid    => "yes",
      })
    end
  end

  puts fb.to_xml unless fb.items.empty?
end



