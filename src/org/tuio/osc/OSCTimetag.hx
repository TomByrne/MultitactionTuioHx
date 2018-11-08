package org.tuio.osc;


/**
	 * An OSCTimetag
	 * This is a helperclass for handling OSC timetags
	 * 
	 * @author Immanuel Bauer
	 */
class OSCTimetag
{
    
    public var seconds : Int;
    public var picoseconds : Int;
    
    public function new(seconds : Int, picoseconds : Int)
    {
        this.seconds = seconds;
        this.picoseconds = picoseconds;
    }
    
    public function compareTo(otg : OSCTimetag) : Int
    {
        if (this.seconds > otg.seconds)
        {
            return 1;
        }
        else if (this.seconds < otg.seconds)
        {
            return -1;
        }
        else if (this.picoseconds > otg.picoseconds)
        {
            return 1;
        }
        else if (this.picoseconds < otg.picoseconds)
        {
            return -1;
        }
        else
        {
            return 0;
        }
        
        return 0;
    }
}

