module Query::Shared::StripData
  def strip_data(data, keys)
    data.each do |row|
      keys.each { |key| row[key].strip! }
    end
  end
end
