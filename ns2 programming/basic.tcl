# first line to start the simulation
set ns [new Simulator]

# file to view animation

set nf [open fileName.nam w]
$ns namtrace-all $nf

# to run this file we need to define a procedure

proc finish{} {
  global ns nf
  $ns flush-trace
  close $nf
  exec nam fileName.nam&
  exit 0
}

# making nodes used for constructing network topology
set nA [$ns node]
set nB [$ns node]
set nC [$ns node]
set nD [$ns node]
set nE [$ns node]

# establishing a link between two nodes
# type of link, bandwidth, delay, type of queue

#for bidirectional link -- duplex
#for unidirectional link -- simplex

# dropTail queue -- the packets that come at last, if the queue does not
# have sufficient space, it drops those packets

$ns duplex-link $nA $nB 7Mb 40ms DropTail
$ns duplex-link $nA $nC 4Mb 40ms DropTail
$ns duplex-link $nB $nC 1Mb 40ms DropTail
$ns duplex-link $nB $nD 2Mb 40ms DropTail
$ns duplex-link $nC $nE 1Mb 40ms DropTail
$ns duplex-link $nD $nE 1Mb 40ms DropTail

$ns at 1.0 "finish"
$ns run
