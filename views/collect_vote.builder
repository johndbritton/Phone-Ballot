xml.Response do
  xml.Response(:action => '/tally_vote', :finishOnKey => '#') do
    xml.Say('Please enter the number of the competitor you are voting for.')
  end
end