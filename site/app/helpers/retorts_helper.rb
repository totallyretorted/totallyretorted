require 'open-uri'

module RetortsHelper
  def self.quote_borat
    borat_quotes = RetortsHelper::get_lotsa_borat_quotes
    borat_quotes[rand(borat_quotes.length)]
  end
  
  def self.get_random_borat_quote
    hp = Hpricot(open("http://www.smacie.com/randomizer/borat.html"))
    hp.search("//big/big/big/font").inner_html
  end
  
  def self.get_lotsa_borat_quotes
    hp = Hpricot(open("http://en.wikiquote.org/wiki/Borat"))
    quotes = hp.search("//div[@id='bodyContent']/ul/li").collect{|el| el.inner_text}.reverse!.slice!(7..-1).reverse!
  end
end
