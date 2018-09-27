s.boot;
// test audio
// {
// 	[SinOsc.ar(433 + MouseY.kr(0, 1000), 0, 0.2), SinOsc.ar(442, 0, 0.2)]
// }.play;

// some code originally borrowed from: http://doc.sccode.org/Classes/OSCFunc.html
// start listening to the network
n = NetAddr("127.0.0.1", NetAddr.langPort); // local machine
// enable detailed logging of all traffic received, for debugging purposes
//OSCFunc.trace(true);

// register a listener for messages sent to 'test', whcih prints the arguments
OSCdef(\test, {|msg, time, addr, recvPort| [msg, time, addr, recvPort].postln}, '/test', n); // def style

// send a message to test the connection
m = NetAddr("127.0.0.1", NetAddr.langPort); // loopback
m.sendMsg("/test", "Some text to transmit");
