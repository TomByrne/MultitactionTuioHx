package org.tuio.osc;


/**
	 * Represents OSC Containers as described in the OSC Spec. 
	 * Basically OSC Containers are nodes in the OSC Addressspace tree.
	 * This class is used internally for OSC Message Address resolution. 
	 */
class OSCContainer
{
    public var hasChildren(get, never) : Bool;

    
    private var children : Map<String, Dynamic> = new Map<String, Dynamic>();
    public var name : String;
    public var method : IOSCListener;
    public var parent : OSCContainer;
    
    /**
		 * Creates a new OSCContainer
		 * @param	name The name of the OSC Container.
		 * @param	method The IOSCListener listening for calls to the OSC Method.
		 */
    public function new(name : String, method : IOSCListener = null)
    {
        this.name = name;
        this.method = method;
    }
    
    /**
		 * Adds a child to this OSCContainer.
		 * <p>e.g. if this OSCContainer is called "a" and the added "b", the added OSCContainer will be addressed with "/a/b"</p>
		 * @param	child The child OSCContainer
		 */
    public function addChild(child : OSCContainer) : Void
    {
        this.children.set(child.name, child);
        child.parent = this;
    }
    
    /**
		 * Trys to retreive the child with the given name.
		 * @param	name The name of the requested child.
		 * @return The child with the given name or null
		 */
    public function getChild(name : String) : OSCContainer
    {
        return this.children.get(name);
    }
    
    /**
		 * Fetches all children matching the given pattern. 
		 * The pattern syntax is explained in the OSC Specification in the segment about OSC Addresses.
		 * @param	pattern The pattern which shall be used to match against the children's names.
		 * @return An Array containing all children which names matched the given pattern.
		 */
    public function getMatchingChildren(pattern : String) : Array<Dynamic>
    {
        var out : Array<Dynamic> = new Array<Dynamic>();
        
        var firstSeperator : Int = pattern.indexOf("/");
        var part : String = pattern.substring(0, firstSeperator);
        var rest : String = pattern.substring(firstSeperator + 1, pattern.length);
        var done : Bool = (pattern.indexOf("/") == -1);
        
        for (child/* AS3HX WARNING could not determine type for var: child exp: EField(EIdent(this),children) type: null */ in this.children)
        {
            if (child.matchName(part))
            {
                if (done)
                {
                    if (child.method != null)
                    {
                        out.push(child.method);
                    }
                }
                else
                {
                    out = out.concat(child.getMatchingChildren(rest));
                }
            }
        }
        
        return out;
    }
    
    /**
		 * Removes the OSCContainer from children.
		 * @param	child The OSCContainer which shall be removed.
		 */
    public function removeChild(child : OSCContainer) : Void
    {
        if (child.hasChildren)
        {
            child.method = null;
        }
        else
        {
            this.children.set(child.name, null);
			this.children.remove(child.name);
        }
    }
    
    /**
		 * Matches the name against the given pattern.
		 * The pattern syntax is explained in the OSC Specification in the segment about OSC Addresses.
		 * @param	pattern The pattern to match against.
		 * @return <code>true</code> if the name matches against the pattern. Otherwise <code>false</code>.
		 */
    public function matchName(pattern : String) : Bool
    {
        if (pattern == this.name)
        {
            return true;
        }
        
        if (pattern == "*")
        {
            return true;
        }
        
        //convert address patter to regular expression
        var regExStr : String = "";
        for (c in 0...pattern.length)
        {
            switch (pattern.charAt(c))
            {
                case "{":regExStr += "(";
                case "}":regExStr += ")";
                case ",":regExStr += "|";
                case "*":regExStr += ".*";
                case "?":regExStr += ".+";
                default:regExStr += pattern.charAt(c);
            }
        }
        
		var regEx:EReg = new EReg(regExStr, "g");
        
        if (regEx.match(this.name) && regEx.matchedPos().pos + regEx.matchedPos().len == this.name.length)
        {
            return true;
        }
        
        return false;
    }
    
    /**
		 * Is <code>true</code> if the OSCContainer has children. Otherwise <code>false</code>.
		 */
    private function get_hasChildren() : Bool
    {
        return (Lambda.count(children) > 0);
    }
}

