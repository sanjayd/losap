module MembersHelper
  def format_date(date)
    date.strftime("%a, %d %b")
  end

  def show_month(month)
    month.strftime("%B %Y")
  end
  
  def previous_month(member, month)
    month = month - 1.month
    link_to('Previous Month', member_url(member, 
                                         :year => month.year, 
                                         :month => month.month))
  end

  def next_month(member, month)
    unless month + 1.month > Date.today
      month = month + 1.month
      ' | ' + link_to('Next Month', member_url(member,
                                               :year => month.year,
                                               :month => month.month))
    end
  end

  def render_sleep_ins_and_standbys(member, month)
    sleep_ins_and_standbys = member.sleep_ins_and_standbys(:month => month)
    if sleep_ins_and_standbys.empty?
      "<tr><td colspan=\"3\">No sleep-ins or standbys this month</td></tr>"
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
          ret += "  <td>#{render :partial => list.shift}</td>\n"
        else
          ret += "  <td>&nbsp;</td>"
        end
      else
        ret += "  <td>&nbsp;</td>\n"
        ret += "  <td>#{render :partial => o}</td>\n"
      end

      ret += "</tr>\n"
    end

    ret
  end
end
