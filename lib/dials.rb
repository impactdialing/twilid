require 'csv'

class Dials
  def self.busy_phone
    '5551237890'
  end

  def self.busy_sid
    'CA33F5C5261BD94898A8680074701AB674'
  end

  def self.data
    return @data if defined?(@data)

    data = {
      busy_phone => busy_sid
    }

    path = File.join(File.dirname(__FILE__), '..', 'data')
    glob = File.join path, 'dials*.csv'
    Dir.glob(glob).each do |filename|
      CSV.foreach(filename, {
        headers: true,
        return_headers: false
      }) do |row|
        # 0 => phone
        # 1 => sid
        data[row[0]] = row[1]
      end
    end
    @data = data
  end

  def self.sid_for(phone)
    data[phone]
  end
end
