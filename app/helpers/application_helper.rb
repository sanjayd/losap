module ApplicationHelper
  def yield_authenticity_token
    if protect_against_forgery?
      <<JAVASCRIPT
<script type='text/javascript'>
  //<![CDATA[
    window._auth_token_name = "#{request_forgery_protection_token}";
    window._auth_token = "#{form_authenticity_token}";
  //]]>
</script>
JAVASCRIPT
    end
  end

  def options_for_months(months)
    options_for_select(months.map do |month|
      [month.strftime("%b %Y"), month]
    end)
  end
end

