s.boot;
// test audio
// {
// 	[SinOsc.ar(433 + MouseY.kr(0, 1000), 0, 0.2), SinOsc.ar(442, 0, 0.2)]
// }.play;

// enable detailed logging of all traffic received, for debugging purposes
//OSCFunc.trace(true);
//OSCFunc.trace(false);

// this line originally borrowed from: http://doc.sccode.org/Classes/OSCFunc.html
// register a listener for messages sent to 'test', whcih prints the arguments
//OSCdef('my function', {|msg, time, addr, recvPort| [msg, time, addr, recvPort].postln}, '/test', nil); // def style
var o = OSCdef('my function', {|msg, time, addr, recvPort|
{
	var env = Env([1, 0], [0.40, 0]);
	SinOsc.ar(470+1000.rand) * EnvGen.kr(env, doneAction: Done.freeSelf);
}.play;
}, '/test', nil); // def style
o.free;

// send a message to test the connection
m = NetAddr("127.0.0.1", NetAddr.langPort); // loopback
m.sendMsg("/test", "Some text to transmit, Will");


