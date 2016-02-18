#!/usr/bin/ruby
# encoding: utf-8

require_relative '../../lib/tool'

=begin
  Test if exist user <obiwan> into localhost
  * desc: Describe the target
  * goto: Move to localhost, and execute the command
  * expect: Check if the results are equal to expected value
  
  Teacher host (localhost) must have GNU/Linux OS.
=end

check :exist_user_obiwan do

  desc "Checking user <obiwan>"
  goto :localhost, :execute => "id obiwan| wc -l"
  expect result.equal?(1)

end

start do
  show
  export
end
