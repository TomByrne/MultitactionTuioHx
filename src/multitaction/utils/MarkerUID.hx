package multitaction.utils;

class MarkerUID
{
	static var lastUID:UInt = 0;

	
	static public function getNextUID():String
	{
		return "t" + lastUID++;
	}
}