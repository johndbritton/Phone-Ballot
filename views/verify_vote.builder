xml.Response do
  xml.Gather(:action => '/collect_vote', :numDigits => '1') do
    xml.Say("You have selected #{@competitor.name}. If you'd like to change your vote press one, otherwise stay on the line.")
    xml.Pause()
  end
  xml.Redirect("/tally_vote?Digits=#{@competitor.code}")
end