#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Execute NAM on the trace file
        exec nam out.nam &
        exit 0
}

#Create four nodes***
set A [$ns node]
set B [$ns node]
set C [$ns node]
set D [$ns node]
set E [$ns node]

#Create links between the nodes
$ns duplex-link $A $B 7Mb 40ms DropTail
$ns duplex-link $A $C 4Mb 40ms DropTail
$ns duplex-link $B $C 1Mb 40ms DropTail
$ns duplex-link $B $D 2Mb 40ms DropTail
$ns duplex-link $C $E 1Mb 40ms DropTail
$ns duplex-link $D $E 1Mb 40ms DropTail


#Give node position (for NAM)
$ns duplex-link-op $B $A orient right-up
$ns duplex-link-op $C $A orient left-up
#$ns duplex-link-op $B $C orient right
$ns duplex-link-op $D $B orient down
$ns duplex-link-op $E $C orient down
#$ns duplex-link-op $D $E orient right


#Setup a UDP connection
set udp [new Agent/UDP]
$udp set class_ 1
$ns attach-agent $E $udp
set null [new Agent/Null]
$ns attach-agent $B $null
$ns connect $udp $null
#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 100000
$cbr set rate_ 5mb


#Schedule events for the CBR agent
$ns at 1.1 "$cbr start"
$ns at 5.1 "$cbr stop"


#Call the finish procedure after 5 seconds of simulation time
$ns at 6.0 "finish"

#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

#Run the simulation
$ns run
