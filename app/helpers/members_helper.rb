module MembersHelper
  def format_date(date)
    date.strftime("%a, %d %b")
  end

  def locked?(month)
    LockedMonth.find_by_month(month)
  end

  def show_month(month)
    month.strftime("%B %Y")
  end
  
  def previous_month(member, month)
    link_to('Previous Month', member_month_url(member, 
                                               :year => month.prev_month.year, 
                                               :month => month.prev_month.month))
  end

  def next_month(member, month)
    unless month.next_month > Date.today
      ' | ' + link_to('Next Month', member_month_url(member,
                                                     :year => month.next_month.year,
                                                     :month => month.next_month.month))
    end
  end

  def render_sleep_ins_and_standbys(member, month)
    sleep_ins_and_standbys = member.sleep_ins_and_standbys(:month => month)
    if sleep_ins_and_standbys.empty?
      content_tag 'tr', raw(
        content_tag('td', 'No sleep-ins or standbys this month', :colspan => "3"))
    else
      sleep_ins_and_standbys_helper(sleep_ins_and_standbys)
    end
  end

  private
  def sleep_ins_and_standbys_helper(list)
    ret = ""

    until list.empty? do
      o = list.shift
      ret += "<tr>\n"
      ret += "  <td>#{h format_date(o.date)}</td>\n"

      if o.is_a? Standby
        ret += "  <td>" + render(:partial => o)
        
        while (list.first and list.first.is_a?(Standby) and
               list.first.date == o.date) do
          ret += "<br/>\n" + render(:partial => list.shift)
        end
        
        ret += "</td>\n"
        
        if list.first && list.first.date == o.date
          p = list.shift
          ret += "  <td id=\"sleep_in_#{p.id}\">#{render :partial => p}</td>\n"
        else
          ret += "  <td>&nbsp;</td>"
        end
      else
        ret += "  <td>&nbsp;</td>\n"
        ret += "  <td id=\"sleep_in_#{o.id}\">#{render :partial => o}</td>\n"
      end

      ret += "</tr>\n"
    end

    ret
  end
end
