class Report
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
  end

  def members
    @members ||= Member.all
  end

  def sleep_ins
    @sleep_ins ||= build_hash(SleepIn.by_month(@month))
  end

  def sleep_in_points(member)
    traverse_hash(sleep_ins, member, :points)
  end
  
  def standbys
    @standbys ||= build_hash(Standby.by_month(@month))
  end

  def standby_points(member)
    traverse_hash(standbys, member, :points)
  end
  
  def hours(member)
    traverse_hash(sleep_ins, member, :hours) + traverse_hash(standbys, member, :hours)
  end

  def monthly?
    @type == :monthly
  end
  
  def annual?
    @type == :annual
  end

  private
  def build_hash(list)
    hash = {}
    list.each do |o|
      hash[o.member_id] ? hash[o.member_id] << o : hash[o.member_id] = [o]
    end
    hash
  end
  
  def traverse_hash(hash, member, method)
    return 0 unless hash[member.id]
    hash[member.id].inject(0) do |total, o|
      total + o.send(method)
    end
  end
end