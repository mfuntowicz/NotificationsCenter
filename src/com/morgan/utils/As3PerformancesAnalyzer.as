/*
As3 Performances Analyzer
Copyright (C) 2011 Ankama Studio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Contact : seyraud@ankama.com
Project : http://code.google.com/p/as3-performances-analyzer
*/

package  com.morgan.utils {
	import adobe.utils.CustomActions;
	import d2components.GraphicContainer;
	import d2utils.ModuleFilestream;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import ui.api.API;
	
	public class As3PerformancesAnalyzer {
		
		//://////////////////////////////////////////////////////////////////
		//:// Public variable
		//://////////////////////////////////////////////////////////////////
		
		public static var instance:As3PerformancesAnalyzer = new As3PerformancesAnalyzer();
		
		//://////////////////////////////////////////////////////////////////
		//:// Privates variables
		//://////////////////////////////////////////////////////////////////
		
		private var _stack : Stack;
		private var _output : ModuleFilestream;
		private var _buffer : ByteArray;
		private var _stringRef : Dictionary;
		private var _stringIdCount : uint = 1;
		private var _initDone : Boolean = false;
		private var _init : Boolean = false;
		private var _depth : uint;
		private var _logMemory : Boolean;
		private var _lastStartTimestamp : uint = uint.MAX_VALUE;
		private var _lastEndTimestampDelta : uint = uint.MAX_VALUE;
		private var _lastStartMem : uint = uint.MAX_VALUE;
		private var _logCustomInfo : Boolean;
		private var _timer : Timer;
		
		//://////////////////////////////////////////////////////////////////
		//:// Public functions
		//://////////////////////////////////////////////////////////////////
		
		/**
		 * Init performances analyzer
		 * @param output
		 * 	Object that will receive output
		 * @param stage
		 * 	Reference to a stage objet. Used to add EXIT_FRAME/ENTER_FRAME event.
		 * @param logMemory
		 *  Set true if you want to have memory information for each function call.
		 * 	Log memory produce bigger log data (twice more).
		 * @param logCustomInfo
		 * Set false if you want to log customInfo gathered through 2nd param of endLog function
		 */
		public static function init(output : ModuleFilestream, stage : GraphicContainer, moduleName : String, logMemory : Boolean = true, logCustomInfo : Boolean = true) : void
		{
			instance._output = output;
			instance._logMemory = logMemory;
			instance._logCustomInfo = logCustomInfo;
			instance._initDone = true;
			instance._stack = new Stack;
			instance._buffer = new ByteArray;
			instance._stringRef = new Dictionary;
			instance._stringRef[""] = 0;
			
			//stage.addEventListener(Event.ENTER_FRAME, instance.onFrameEnd);
			instance._timer = new Timer(50);
			instance._timer.addEventListener(TimerEvent.TIMER, instance.onFrameEnd);
			instance._timer.start();
			// Output header
			
			// Add application fps
			output.writeInt(50);
			
			// Add application name
			output.writeUTF(moduleName);
			
			// Add info about memory log
			output.writeBoolean(logMemory);
		}
		
		/**
		 * Start function log 
		 * @param functionId
		 * 	An unic identifier that refer to the logged function
		 * 
		 * @example
		 * 	function addText(str : String) : void
		 * 	{
		 * 		As3PerformancesAnalyzer.startLog("myPackage::MyClass.addText");
		 * 		trace(str);
		 * 		As3PerformancesAnalyzer.endLog("myPackage::MyClass.addText", "param: " + str);
		 * 	}
		 */
		public function startLog(functionId:String) : void
		{
			if(!_init) return;
			++_depth;
			_stack.push(functionId, getTimer(), _logMemory ? System.totalMemory : 0);
		}
		
	
		/**
		 * End function log 
		 * @param functionId
		 * 	An unic identifier that refer to the logged function
		 * @param customInfo
		 * 	Any data you want to be associated with this log
		 * 
		 * @example
		 * 	function addText(str : String) : void
		 * 	{
		 * 		As3PerformancesAnalyzer.profile()
		 * 		trace(str);
		 * 	}
		 */
		public function endLog(functionId:String, customInfo : String = null):void
		{
			if(!_init) return;
			
			--_depth;
			
			// End of a function
			var r : StackReccord = _stack.pop();
			
			// If an exception is throw, it can break the stack, so
			// we are looking for the right stack position
			if(r.name != functionId) endLog(functionId);
			
			// Look for string index
			var fnIndex : uint = _stringRef[functionId];
			if(!fnIndex)
			{
				// Store string into dictionary
				_stringRef[functionId] = ++_stringIdCount;
				fnIndex = _stringIdCount;
				
				// Write String index
				_output.writeInt(fnIndex);
				
				// Write String itself
				_output.writeUTF(functionId);
			}
			
			var customInfoIndex : uint = customInfo && _logCustomInfo ? _stringRef[customInfo] : 1;
			if(!customInfoIndex)
			{
				// Store string into dictionary
				_stringRef[customInfo] = ++_stringIdCount;
				customInfoIndex = _stringIdCount;
				
				// Write String index
				_output.writeInt(customInfoIndex);
				
				// Write String itself
				_output.writeUTF(customInfo);
			}
			
			// Write function string name index
			_buffer.writeInt(fnIndex);
			
			// Write start timestamp
			if(r.start != _lastStartTimestamp)
			{
				_buffer.writeBoolean(true);
				_buffer.writeUnsignedInt(r.start);
				_lastStartTimestamp = r.start;
			}
			else
				_buffer.writeBoolean(false);
			
			var t : uint = getTimer();
			
			// Write end timestamp delta
			if(r.start != t) 
			{
				_buffer.writeBoolean(true);
				if(r.start - t != _lastEndTimestampDelta)
				{
					_lastEndTimestampDelta = t;
					_buffer.writeBoolean(true);
					_buffer.writeUnsignedInt(_lastEndTimestampDelta);
				}else
					_buffer.writeBoolean(false);
			}else
				_buffer.writeBoolean(false);
			
			// Write memory info if needed
			if(_logMemory)
			{
				// Write start memory
				if(_lastStartMem != r.startMemory)
				{
					_lastStartMem = r.startMemory;
					_buffer.writeBoolean(true);
					_buffer.writeUnsignedInt(r.startMemory);
				}
				else 
					_buffer.writeBoolean(false);
						
				// Write end memory
				if(System.totalMemory != r.startMemory)
				{
					_buffer.writeBoolean(true);
					_buffer.writeUnsignedInt(System.totalMemory);
				}else
					_buffer.writeBoolean(false);
			}
			
			// Write depth 
			_buffer.writeShort(_depth);
			
			// Write custom info string index
			_buffer.writeBoolean(customInfoIndex != 1);
			if(customInfoIndex != 1)
				_buffer.writeInt(customInfoIndex);
		}
	
		//://////////////////////////////////////////////////////////////////
		//:// Events
		//://////////////////////////////////////////////////////////////////
		
		private function onFrameEnd(e:TimerEvent) : void
		{
			// Init is realy done only when a frame is ended
			// it avoid partial log
			if(_initDone && !_init)
				_init = true;
			
			// Close string declaration bock
			_output.writeUnsignedInt(0);
			
			// Write profiling info bock
			_output.writeUnsignedInt(_buffer.length);
			_output.writeBytes(_buffer);
			
			// Close profiling info bock
			_output.writeUnsignedInt(0);
			
			_buffer.clear();
		}
	}
}

//://////////////////////////////////////////////////////////////////
//:// Internal suff
//://////////////////////////////////////////////////////////////////

/**
 * Class to store stack info
 */
internal class StackReccord
{
	/** Function name */
	public var name : String;
	
	/** Start timestamp */
	public var start : uint;
	
	/** End timestamp (avaible only when reading a profile log) */
	public var end : uint;
	
	/** Memory size before executing function body */
	public var startMemory : uint;
	
	/** Memory size after executing function body */
	public var endMemory : int;
	
	/** Parent node */
	public var parent : StackReccord;
	
}

/**
 * Stack class
 */
internal class Stack
{
	private var _pool : Vector.<StackReccord> = new Vector.<StackReccord>;
	
	/** Current stack object */
	public var current : StackReccord;
	
	public function Stack()
	{
		grow(200);
	}
	
	/**
	 * Add an entry to the stack
	 */
	public function push(name : String, timestamp : uint, memory : uint) : void
	{
		if(!_pool.length) grow();
		
		var last : StackReccord = current;
		current = _pool.pop();
		current.name = name;
		current.start = timestamp;
		current.parent = last;
		current.startMemory = memory;
	}
	
	/**
	 * Unstack
	 */
	public function pop() : StackReccord
	{
		if(current)
		{
			var last : StackReccord = current;
			_pool.push(current);
			current = current.parent;
			return last;
		}
		
		return null;
	}
	
	/**
	 * Grow the pool size
	 */
	public function grow(count : uint = 100) : void
	{
		for(var i : uint = 0; i < count; ++i)
			_pool.push(new StackReccord);
	}
}