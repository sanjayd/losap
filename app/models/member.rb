class Member < ActiveRecord::Base
  validates_presence_of :firstname, :lastname, :badgeno
  validates_format_of :badgeno, :with => /^((\d{1,6})|([A-Za-z]{4}\d{1,2}))$/, :message => "is invalid"
  validates_uniqueness_of :badgeno

  has_many :sleep_ins, :order => 'date ASC', :dependent => :destroy
  has_many :standbys, :order => 'start_time ASC', :dependent => :destroy

  cattr_reader :per_page
  @@per_page = 15

  def self.all_like(str)
    str.split.inject([]) do |arr, s|
      str_with_wildcards = "%#{s}%"
      arr + self.find(:all,
                      :select => 'id, firstname, lastname, badgeno',
                      :conditions => ["firstname like ? or lastname like ? or badgeno like ?",
                                      str_with_wildcards,
                                      str_with_wildcards,
                                      str_with_wildcards],
                      :order => 'lastname ASC, firstname ASC',
                      :limit => 10)
    end.uniq
  end

  def sleep_ins_and_standbys(params={})
    sleep_ins = standbys = nil
    if params[:month]
      sleep_ins = self.sleep_ins.find_by_month(params[:month])
      standbys = self.standbys.find_by_month(params[:month])
    elsif params[:year]
      sleep_ins = self.sleep_ins.find_by_year(params[:year])
      standbys = self.standbys.find_by_year(params[:year])
    else
      return nil
    end

    ret = []
    until sleep_ins.empty? and standbys.empty? do
      if sleep_ins.empty?
        ret << standbys.shift
      elsif standbys.empty?
        ret << sleep_ins.shift
      elsif sleep_ins.first.date < standbys.first.date
        ret << sleep_ins.shift
      else
        ret << standbys.shift
      end
    end

    ret
  end
  
  def hours(params={})
    sleep_ins = standbys = nil
    if params[:month]
      sleep_ins = self.sleep_ins.find_by_month(params[:month])
      standbys = self.standbys.find_by_month(params[:month])
    elsif params[:year]
      sleep_ins = self.sleep_ins.find_by_year(params[:year])
      standbys = self.standbys.find_by_year(params[:year])
    else
      return nil
    end

    (sleep_ins + standbys).inject(0) do |total, s|
      total + s.hours
    end
  end

  def sleep_in_points(params={})
    sleep_ins = nil
    sleep_ins = self.sleep_ins.find_by_month(params[:month]) if params[:month]
    sleep_ins = self.sleep_ins.find_by_year(params[:year]) if params[:year]
    return nil if sleep_ins.nil?

    sleep_ins.inject(0) do |total, s|
      total + s.points
    end
  end

  def standby_points(params={})
    standbys = nil
    standbys = self.standbys.find_by_month(params[:month]) if params[:month]
    standbys = self.standbys.find_by_year(params[:year]) if params[:year]
    return nil if standbys.nil?

    standbys.inject(0) do |total, s|
      total + s.points
    end
  end
end
