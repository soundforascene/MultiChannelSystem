													//HID stuff


Hid hi; 
HidMsg msg; 
// hid device 
1 => int device;
// Get command line 
if( me.args() ) me.arg(0) => Std.atoi => device; 

// Open keyboard ( get number from command line) 
if( !hi.openKeyboard( device ) ) me.exit(); 
<<< "keyboard '" + hi.name() + "' ready", "" >>>; 

	
										
													  // Setting directory for samples


me.dir() + "/machine/mach1.wav" => string file1;
if (me.args() )me.arg(0) => file1;

me.dir() + "/machine/mach2.wav" => string file2;
if (me.args() )me.arg(0) => file2;

me.dir() + "/machine/mach3.wav" => string file3;
if (me.args() )me.arg(0) => file3;

me.dir() + "/machine/mach4.wav" => string file4;
if (me.args() )me.arg(0) => file4;

me.dir() + "/machine/mach5.wav" => string file5;
if (me.args() )me.arg(0) => file5;

												// Creating functions to change; gain and pan

float volume; 
float panning;
5000 => float lowpass; 

// gainAdd is a function to increase volume. This is used later dependant on HID messeges coming in

fun float gainAdd(float volume) 
{
	if ( volume >= 0.95 )
	{
		1 => volume;
	}	
	else 
	{
		0.05 +=> volume;
	}
	return volume; 
}

// Same as ginAdd but incriments a low-pass filter

fun float lpAdd(float lowpass)
{
	if ( lowpass >= 19500)
	{
		20000 => lowpass;
	}
	else 
	{
		750 +=> lowpass;
	}
	return lowpass;
}
fun float gainDown(float volume)
{
	if (volume <= 0.05)
	{
		0 => volume;
	}
	else 
	{
		0.05 -=> volume;
	}
	return volume; 
}
fun float lpDown( float lowpass)
{
	if ( lowpass <= 5025)
	{
		5000 => lowpass;
	}
	else 
	{
		750 -=> lowpass;
	}
	return lowpass; 

}
fun float panLeft(float panning)
{
 	if ( panning >= 6.75 )
		{	
			7 => panning; 
		}
		else 
		{
			0.25 +=> panning;
		}
	return panning;
}
fun float panRight(float panning)
{
	if (panning <= 0.25)
	{
		0 => panning;
	}
	else 
	{
		0.25 -=> panning; 
	} 
	return panning;
}

// Setting a variable to for the Channels 1-5 
int chanSelect;
// Setting the variables for the gain and pan floats 
float gain[5];
float pan[5];
float lp[5];
// Definfing Sample 1 
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

										  									// Start of 'main' function
fun void main()
{
	while(true)
	{
		// Checking if a HID message is coming through
		hi => now; 
		while ( hi.recv( msg ) )
		{ 
			// Check if a button is being pressed 
			if( msg.isButtonDown() ) 
			{   
				// Printing out what key is being input     
				<<< "Key-Down:", msg.which >>>;
				
				// Select which channel we are using  
				if ((msg.which==30)||(msg.which==31)||(msg.which==32)||(msg.which==33)||(msg.which==34))
				{
					msg.which => chanSelect;
					30 -=> chanSelect;
				}
				else 
				{
				} 
				
				if (msg.which == 82) 
				{
					gainAdd(gain[chanSelect]) => gain[chanSelect];
					lpAdd(lp[chanSelect]) => lp[chanSelect];
					setVars();
				}
				else if (msg.which == 81)
				{
					gainDown(gain[chanSelect]) => gain[chanSelect];
					lpDown(lp[chanSelect]) => lp[chanSelect];
					setVars();
				}					
				else if ( msg.which == 80 )
				{
					panLeft(pan[chanSelect]) => pan[chanSelect];
					setVars();
				}
				else if (msg.which == 79)
				{
					panRight(pan[chanSelect]) => pan[chanSelect];
					setVars();
				}
				else if (msg.which == 14)
				{
					0.0 => gain[chanSelect];
					5000.0 => lp[chanSelect];
					setVars();
					<<< "Killed: ",chanSelect >>>;
				}

				<<< "Channel: ", chanSelect>>>;
				<<< "Gain:    ", gain[chanSelect]>>>;
				<<< "Pan:     ", pan[chanSelect] >>>;
				<<< "Low-Pass ", lp[chanSelect] >>>;

			}		
		}
	}

	//Setting the time for the while function
	10::ms => now;
}


// Running the main function as a seperate thread 
spork ~ main();

// Timing for the whole project
1::day => now;
