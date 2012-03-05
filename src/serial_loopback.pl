#!/usr/bin/perl
# modified from: http://www.windmeadow.com/node/38

use strict;
use warnings;
use Time::HiRes;

# Sample Perl script to transmit number
# to Arduino then listen for the Arduino
# to echo it back

use Device::SerialPort;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port;
if (-e "/dev/ttyACM0") {
    $port = Device::SerialPort->new("/dev/ttyACM0");
} else {
    $port = Device::SerialPort->new("/dev/ttyUSB0");
}
$port->databits(8);
$port->baudrate(230400);
$port->parity("none");
$port->stopbits(1);

my $count = 0;
while (1) {

    # Poll to see if any data is coming in
    my $received = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($received) {
        print "Received '$received'\n";
    }
    else {
        Time::HiRes::usleep(2000);
        $count++;
        my $send = "$count\n";
        my $count_out = $port->write($send);
        #print "Sent '$send'\n";
    }
}
