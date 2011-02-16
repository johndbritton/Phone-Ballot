xml.Response do
  xml.Gather(:action => '/tally_vote', :finishOnKey => '#') do
    xml.Say('Please enter the number of the competitor you are voting for.')
  end
end