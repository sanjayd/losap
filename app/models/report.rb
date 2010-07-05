class Report
  attr_reader :members
  attr_reader :month
  attr_reader :year

  def initialize(date)
    if date =~ /^\d{4}$/
      @year = Date.parse("#{date}-01-01")
      @type = :annual
    else
      @month = Date.parse(date)
      @type = :monthly
    end
    
    @members = Member.all
  end
  
  def monthly?
    @type == :monthly
  end
  
  def annual?
    @type == :annual
  end
end