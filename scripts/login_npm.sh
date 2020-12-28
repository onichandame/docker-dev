#!/usr/bin/expect

set username [lindex $argv 0]
set password [lindex $argv 1]
set email [lindex $argv 2]
spawn npm adduser
expect {
  "Username:" {send "$username\r"; exp_continue}
  "Password:" {send "$password\r"; exp_continue}
  "Email: (this IS public)" {send "$email\r"; exp_continue}
}
