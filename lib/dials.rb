require 'csv'
require 'uri'

class Dials
  def self.busy_phone
    '5551237890'
  end

  def self.busy_sid
    'CA33F5C5261BD94898A8680074701AB674'
  end
  
  def self.account_sid
    'AC422d17e57a30598f8120ee67feae29cd'
  end

  def self.from
    '5557891234'
  end

  def self.data
    return @data if defined?(@data)

    data = {}

    path = File.join(File.dirname(__FILE__), '..', 'data')
    glob = File.join path, 'dials*.csv'
    Dir.glob(glob).each do |filename|
      CSV.foreach(filename, {
        headers: true,
        return_headers: false
      }) do |row|
        # sid_for
        # 0 => campaign_id
        # 1 => phone
        # 2 => sid
        data[row[0]] ||= {}
        data[row[0]][busy_phone] ||= busy_sid
        data[row[0]][row[1]] = row[2]

        # phone_for
        data[row[2]] = row[1]
      end
    end
    @data = data
  end

  def self.extract_campaign_id(url)
    uri = URI.parse(url)
    tuples = uri.query.split('&')
    target = tuples.find{|tuple| tuple =~ /campaign_id/}
    if target
      target.split('=').last
    else
      throw "EXTRACT: No target for URL[#{url}]"
    end
  end

  def self.sid_for(url, phone)
    campaign_id = extract_campaign_id(url)
    sid = data[campaign_id][phone]
    sid.nil? ? busy_sid : sid
  end

  def self.phone_for(sid)
    target = data[campaign_id].find{|phone,_sid| _sid == sid}
    target.nil? ? busy_phone : target.first
  end
end
