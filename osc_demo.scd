s.boot;
// test audio
// {
// 	[SinOsc.ar(433 + MouseY.kr(0, 1000), 0, 0.2), SinOsc.ar(442, 0, 0.2)]
// }.play;

// enable detailed logging of all traffic received, for debugging purposes
OSCFunc.trace(true);
OSCFunc.trace(false);

(
SynthDef(\shortblip, {
	var env = Env([1, 0], [0.05, 0]);
	Out.ar(0, SinOsc.ar(470 + Rand(0,1000)) * EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
);
(
SynthDef(\longlow, {
	var env = Env([0, 1, 1, 0], [1, 1, 1, 0]);
	Out.ar(0, SinOsc.ar(220 + Rand(0,440)) * EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
);
(
SynthDef(\longmid, {
	var env = Env([0, 1, 1, 0], [1, 1, 1, 0]);
	Out.ar(0, SinOsc.ar(440 + Rand(0,440)) * EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
);

//Synth(\mysynth);

//SynthDef(\sine, {Out.ar(0,SinOsc.ar(Rand(440,880),0,0.1))}).add;
s = Synth(\sine);
s.free;

// this line originally borrowed from: http://doc.sccode.org/Classes/OSCFunc.html
// register a listener for messages sent to 'test', whcih prints the arguments
//OSCdef('my function', {|msg, time, addr, recvPort| [msg, time, addr, recvPort].postln}, '/test', nil); // def style
var u = OSCdef('udp', {|msg, time, addr, recvPort|
	msg.postln;
	msg[0].postln;
	Synth(\shortblip);
}, '/udp', nil); // def style
var t = OSCdef('tcp', {|msg, time, addr, recvPort|
	msg.postln;
	msg[0].postln;
	Synth(\longlow);
}, '/tcp', nil); // def style
var d = OSCdef('dns', {|msg, time, addr, recvPort|
	msg.postln;
	msg[0].postln;
	Synth(\longmid);
}, '/dns', nil); // def style
udpdef.free;
tcpdef.free;
dnsdef.free;

// send a message to test the connection
m = NetAddr("127.0.0.1", NetAddr.langPort); // loopback
m.sendMsg("/udp", "Some text to transmit, Will");
m.sendMsg("/tcp", "Some text to transmit, Will");
m.sendMsg("/dns", "Some text to transmit, Will");
