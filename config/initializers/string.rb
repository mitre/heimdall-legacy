class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    begin
      true if Float(self)
    rescue ArgumentError
      false
    end
  end
end
