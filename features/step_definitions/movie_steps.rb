# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  p1 = /#{e1}/ =~ page.body; flunk %Q{"#{e1}" not found} if p1.nil?
  p2 = /#{e2}/ =~ page.body; flunk %Q{"#{e2}" not found} if p2.nil?
  flunk %Q{"#{e1} appears after #{e2}"} if p1 > p2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    step %Q{I #{uncheck ? "uncheck" : "check"} "ratings_#{rating.strip}"}
  end
end

Then /I should see all the movies/ do
  movies_count = Movie.count
  movies_page = page.all('table#movies tbody tr').count
  flunk "Movies in db #{movies_count} != Movies on page #{movies_page}" if movies_count != movies_page
end
