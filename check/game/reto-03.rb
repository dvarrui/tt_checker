# encoding: utf-8

task "Target 03" do

  target "Create user <"+get(:username)+">"
  run "id #{get(:username)}"
  expect result.count!.equal?(1)

  target "Member of group <"+get(:groupname)+">"
  result.restore!
  expect result.grep!(get(:groupname)).count!.equal?(1)

  home = "/home/" + get(:username)

  target "User home is <" + home + ">"
  run "cat /etc/password"
  expect result.grep!(home).grep!(get(:username)).count!.equal?(1)
end

start do
  show
  export
end

=begin
---
:global:
  :username: david
:cases:
=end
