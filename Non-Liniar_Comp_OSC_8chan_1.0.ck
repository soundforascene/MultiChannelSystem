
													  							// OSC Stuff

// Creating reciever
OscIn oin; 
// Creating OSC message
OscMsg msg;
// Using port 6448
6668 => oin.port; 

// Defining OSC adresses

oin.addAddress( "/voice1/pan, f");
oin.addAddress( "/voice1/gain, f");
oin.addAddress( "/voice2/pan, f");
oin.addAddress( "/voice2/gain, f");
oin.addAddress( "/voice3/pan, f");
oin.addAddress( "/voice3/gain, f");
oin.addAddress( "/voice4/pan, f");
oin.addAddress( "/voice4/gain, f");
oin.addAddress( "/voice5/pan, f");
oin.addAddress( "/voice5/gain, f");

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

// Definfing Sample 1 
SndBuf samp1 => LPF l1 =>Pan8 p1 => dac; 
file1 => samp1.read;
0 => samp1.pos;
0.0 => samp1.gain;	

SndBuf samp2 =>  LPF l2 => Pan8 p2 => dac;
file2 => samp2.read;
0 => samp2.pos;
0.0 => samp2.gain;

SndBuf samp3 => LPF l3 => Pan8 p3 => dac;
file3 => samp3.read;
0 => samp3.pos;
0.0 => samp3.gain;

SndBuf samp4 => LPF l4 => Pan8 p4 => dac;
file4 => samp4.read;
0 => samp4.pos;
0.0 => samp4.gain;

SndBuf samp5 => LPF l5 => Pan8 p5 => dac;
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

{									  									// Start of 'main' function
	// infinite event loop
	while ( true )
	{
	    // wait for osc event to arrive
	    oin => now;

	    // grab the next message from the queue. 
	    while ( oin.recv(msg))

	    { 
	    	if(msg.address == "/voice1/pan" )
	    	{
	    		msg.getFloat(0) => pan[0];
		        // print
		        <<< "Chan1", "Pan ", pan[0]  >>>;
		        // set play pointer to beginning
		       	setVars();
 
		    }
		    else if (msg.address == "/voice2/pan" )
	    	{
		    	msg.getFloat(0) => pan[1];
		        // print
		        <<< "Chan2", "Pan ", pan[1]  >>>;
		        // set play pointer to beginning
		       	setVars();
		    }
		    else if (msg.address == "/voice3/pan" )
	    	{
		    	msg.getFloat(0)=> pan[2];
		        // print
		        <<< "Chan3", "Pan ", pan[2]  >>>;
		        // set play pointer to beginning
		       	setVars();
		    }
		    else if (msg.address == "/voice4/pan" )
	    	{
		    	msg.getFloat(0) => pan[3];
		        // print
		        <<< "Chan4", "Pan ", pan[3]  >>>;
		        // set play pointer to beginning
		       	setVars();
		    }
		    else if (msg.address == "/voice5/pan" )
	    	{
		    	msg.getFloat(0)=> pan[4];
		        // print
		        <<< "Chan5", "Pan ", pan[4]  >>>;
		        // set play pointer to beginning
		       	setVars();
		    }
			
			if(msg.address == "/voice1/gain1" )
			{
				msg.getFloat(0) => gain[0];
				// print
				<<< "Chan1: ", "Gain ", gain[0]  >>>;
				// set play pointer to beginning
				setVars();
			}
			
			if(msg.address == "/voice2/gain" )
			{
				msg.getFloat(0) => gain[1];
				// print
				<<< "Chan2: ", "Gain ", gain[1]  >>>;
				// set play pointer to beginning
				setVars();
			}
			if(msg.address == "/voice3/gain" )
			{
				msg.getFloat(0) => gain[2];
				// print
				<<< "Chan3: ", "Gain ", gain[2]  >>>;
				// set play pointer to beginning
				setVars();
			}
			if(msg.address == "/voice4/gain" )
			{
				msg.getFloat(0) => gain[3];
				// print
				<<< "Chan4: ", "Gain ", gain[3]  >>>;
				// set play pointer to beginning
				setVars();
			}
			if(msg.address == "/voice5/gain" )
			{
				msg.getFloat(0) => gain[4];
				// print
				<<< "Chan5: ", "Gain ", gain[4]  >>>;
				// set play pointer to beginning
				setVars();
			}

	    }
	}
}

// Running the main function as a seperate thread 

// Timing for the whole project
1::day => now;
