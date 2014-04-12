# Reset Interface

http://forums.whirlpool.net.au/forum-replies.cfm?t=1906081

<script>

Then we used IP-SLA to do a tcp-connect to a remote host (that we owned) and tracked that event. Something like:

```
ip sla 1
 tcp-connect 1.2.3.4 23 control disable
 timeout 5000
ip sla schedule 1 life forever start-time now
track 10 ip sla 1 reachability
 delay down 120 up 10
```

And finally tracking this event to trigger the interface reset via EEM:

```
event manager applet resetatm 
 event track 10 state down
 action 1.0 syslog msg "dial0 interface not responding, resetting atm0"
 action 1.1 cli command "enable"
 action 1.2 cli command "resetif atm0"
```

But, I was never 100% satisfied with this.. it's alot of work and is just a large kludge in the end. We migrated to differrent providers and don't have the issue any more anyway.
