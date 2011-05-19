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
    @sleep_ins ||= build_hash(monthly? ? SleepIn.by_month(@month) : SleepIn.by_year(@year))
  end
  
  def sleep_ins_for_member(member)
    sleep_ins[member.id] ? sleep_ins[member.id] : []
  end

  def sleep_in_points(member)
    traverse_hash(sleep_ins, member, :points)
  end
  
  def standbys
    @standbys ||= build_hash(monthly? ? Standby.by_month(@month) : Standby.by_year(@year))
  end

  def standbys_for_member(member)
    standbys[member.id] ? standbys[member.id] : []
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