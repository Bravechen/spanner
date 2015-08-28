package org.spanner.pathfinding
{
	/**路径节点**/
	public class Node
	{
		/**在网格中行索引**/
		public var x:int;
		/**在网格中列索引**/
		public var y:int;
		/**起始节点到该点的代价**/
		public var g:Number;
		/**从该点到结束点的代价**/
		public var h:Number;
		/**代价总和**/
		public var f:Number;
		/**是否是可通过节点**/
		public var walkable:Boolean = true;
		/**上一个节点**/
		public var parent:Node;
		/**地形代价系数**/
		public var costMultiplier:Number = 1;
		/**
		 * @param x
		 * @param y
		 * **/
		public function Node(x:int,y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		public function toString():String
		{
			return "("+
				"x:"+this.x+
				"y:"+this.y+
				"g:"+this.g+
				"h:"+this.h+
				"f:"+this.f
				+")";
		}
	}
}