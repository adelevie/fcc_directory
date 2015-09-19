require 'bundler/setup'
require 'nokogiri'
require 'pry'
require 'open-uri'

module DirectoryScraper

  def self.phone_number_from_text(text)
    txt = text
    re1 = '.*?'  # Non-greedy match on filler
    re2 = '(\\(.*\\))'  # Round Braces 1
    re3 = '(\\s+)'  # White Space 1
    re4 = '(\\d+)'  # Integer Number 1
    re5 = '(-)'  # Any Single Character 1
    re6 = '(\\d+)'  # Integer Number 2

    re = (re1 + re2 + re3 + re4 + re5 + re6)
    m=Regexp.new(re,Regexp::IGNORECASE);

    result = nil
    if m.match(txt)
      rbraces1 = m.match(txt)[1];
      ws1 = m.match(txt)[2];
      int1 = m.match(txt)[3];
      c1 = m.match(txt)[4];
      int2 = m.match(txt)[5];
    
      result = "#{rbraces1}#{ws1}#{int1}#{c1}#{int2}"
    end
  
    return result
  end

  def self.parse(url='https://transition.fcc.gov/fcc-bin/findpeople.pl?person=202')
    doc = Nokogiri::HTML(open(url))
    tables = doc.search('table')
    table = tables[9].search('table').first
    rows = table.search('tr')

    return rows.reject {|r| r.text.empty?}.map do |row|
      text = row.text
      phone = phone_number_from_text(text)

      chunks = text.split(phone)
      name_and_office_raw = chunks[0]
      email_raw = chunks[1]

      office = name_and_office_raw.split(//).last(6).join.rstrip.gsub("\u00A0", "")
      name = name_and_office_raw.split(office)[0].lstrip.rstrip.gsub("\u00A0", "")
      email = email_raw.gsub(' ', '').gsub('at', '@').gsub('dot', '.').rstrip.gsub("\u00A0", "")

      {
        name: name,
        office: office,
        phone: phone,
        email: email
      }
    end
  end
end

