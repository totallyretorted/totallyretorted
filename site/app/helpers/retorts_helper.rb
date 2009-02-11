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
  
  def self.get_lotsa_borat_quotes(uri="http://en.wikiquote.org/w/index.php?title=Borat:_Cultural_Learnings_of_America_for_Make_Benefit_Glorious_Nation_of_Kazakhstan&oldid=893794")
    hp = Hpricot(open(uri))
    quotes = hp.search("//div[@id='bodyContent']/ul/li").collect{|el| el.inner_text}.reverse!.slice!(7..-1).reverse!
  end
end
