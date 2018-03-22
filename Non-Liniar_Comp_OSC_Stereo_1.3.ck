
													  							// OSC Stuff

// Creating reciever
OscIn oin; 
// Creating OSC message
OscMsg msg;
// Using port 6448
6667 => oin.port; 

																			// Defining OSC adresses

oin.addAddress( "/voice/map1, f f ");
oin.addAddress( "/voice/map2, f f ");
oin.addAddress( "/voice/map3, f f ");
oin.addAddress( "/voice/map4, f f ");
oin.addAddress( "/voice/map5, f f ");

																		// Setting directory for samples

me.dir() + "/woods/wood1.wav" => string file1;
if (me.args() )me.arg(0) => file1;

me.dir() + "/woods/wood2.wav" => string file2;
if (me.args() )me.arg(0) => file2;

me.dir() + "/woods/wood3.wav" => string file3;
if (me.args() )me.arg(0) => file3;

me.dir() + "/woods/wood4.wav" => string file4;
if (me.args() )me.arg(0) => file4;

me.dir() + "/woods/wood5.wav" => string file5;
if (me.args() )me.arg(0) => file5;

																// Creating functions to change; gain and pan

// Setting a variable to for the Channels 1-5 
int chanSelect;

// Setting the variables for the gain and pan floats 

[0.5, 0.5, 0.5, 0.5, 0.5] @=> float gain[];
[1.0, 1.0, 1.0, 1.0, 1.0] @=> float pan[];
[20000, 20000, 20000, 20000, 20000] @=> int lp[];

																			// Definfing Sample DSP
SndBuf samp1 => LPF l1 =>Pan2 p1 => dac; 
file1 => samp1.read;
0 => samp1.pos;
0.0 => samp1.gain;	

SndBuf samp2 =>  LPF l2 => Pan2 p2 => dac;
file2 => samp2.read;
0 => samp2.pos;
0.0 => samp2.gain;

SndBuf samp3 => LPF l3 => Pan2 p3 => dac;
file3 => samp3.read;
0 => samp3.pos;
0.0 => samp3.gain;

SndBuf samp4 => LPF l4 => Pan2 p4 => dac;
file4 => samp4.read;
0 => samp4.pos;
0.0 => samp4.gain;

SndBuf samp5 => LPF l5 => Pan2 p5 => dac;
file5 => samp5.read;
0 => samp5.pos;
0.0 => samp5.gain;

1 => samp1.loop;
1 => samp2.loop;
1 => samp3.loop;
1 => samp4.loop;
1 => samp5.loop;

																// Function to alocate array variables into chugens. 
fun void setVars()
{
	gain[0] => samp1.gain; 
	gain[1] => samp2.gain;
	gain[2] => samp3.gain;
	gain[3] => samp4.gain; 
	gain[4] => samp5.gain;
	pan[0] => p1.pan;
	pan[1] => p2.pan; 
	pan[2] => p3.pan; 
	pan[3] => p4.pan; 
	pan[4] => p5.pan; 
	lp[0] => l1.freq;
	lp[1] => l2.freq;
	lp[2] => l3.freq;
	lp[3] => l4.freq;
	lp[4] => l5.freq; 
}

// Creating a function that recieves the OSC data for the corisponding message and insters it into the corisponding channel.
// I am usign this to not have to define it every time I get a new OSC message

fun int assign( int chanSelect )
{ 
	msg.getFloat(0) => pan[chanSelect];
	msg.getFloat(1) => gain[chanSelect];
	<<< "Channel: ", chanSelect, "Gain: ", gain[chanSelect], "Pan ", pan[chanSelect]  >>>;
	setVars();
}


{										  									// Start of 'main' function
	// infinite event loop
	while ( true )
	{
	    // wait for osc event to arrive
	    oin => now;

	    // grab the next message from the queue. 
	    while ( oin.recv(msg))

	    { 
	    	if (msg.address == "/voice/map1" )
	    	{
	    		1 => chanSelect;
	    		assign(chanSelect);
		    }
		    else if (msg.address == "/voice/map2" )
	    	{
	    		2 => chanSelect;
	    		assign(chanSelect);
		    }
		    else if (msg.address == "/voice/map3" )
	    	{
	    		3 => chanSelect;
	    		assign(chanSelect);
		    }
		    else if (msg.address == "/voice/map4" )
	    	{
	    		4 => chanSelect;
	    		assign(chanSelect);
		    }
		    else if (msg.address == "/voice/map5" )
	    	{
	    		5 => chanSelect;
	    		assign(chanSelect);
		    }
	    }
	}
}


// Running the main function as a seperate thread 

// Timing for the whole project
1::day => now;
