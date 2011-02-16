xml.Response do
  xml.Dial(@winner.number, :hangupOnStar => 'true')
  xml.Gather(:numDigits => '1') do
    xml.Say('Hangup now to stop selecting winners.')
    xml.Say('Press 1 to select from the voters who picked the first place winner.')
    xml.Say('Press 2 to select from the voters who picked the second place winner.')
    xml.Say('Press 3 to select from the voters who picked the third place winner.')
    xml.Say('Press 9 to select from the voters who picked one of the top three winners.')
    xml.Say('Press 0 to select from all voters.')
    xml.Pause()
  end
  xml.Redirect('/winner')
end