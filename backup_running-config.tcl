# Backuping config gile
send "terminal length 0\r"
send "show run\r"
expect -re "\nend"
expect *
