package org.spanner.pathfinding
{
	/**2D节点网格**/
	public class Grid
	{
		private var _startNode:Node;
		/**起始节点**/
		public function get startNode():Node
		{
			return _startNode;
		}
		
		private var _endNode:Node;
		/**结束节点**/
		public function get endNode():Node
		{
			return _endNode;
		}
		/**列数**/
		public var numCols:int;
		/**行数**/
		public var numRows:int;
		
		//==============================================

		private var nodes:Vector.<Vector.<Node>>; //二维数组，一维是列，二维是行
		
		//==============================================
		
		public function Grid(numCols:int,numRows:int)
		{
			this.numCols = numCols;
			this.numRows = numRows;
			this.nodes = new Vector.<Vector.<Node>>(numCols);
			
			for(var i:int=0;i<numCols;i++){
				nodes[i] = new Vector.<Node>(numRows);
				for(var j:int=0;j<numRows;j++){
					nodes[i][j] = new Node(i,j);
				}
			}
		}
		/**返回节点**/
		public function getNode(x:int,y:int):Node
		{
			return nodes[x][y];
		}
		/**设置结束节点**/
		public function setEndNode(x:int,y:int):void
		{
			_endNode = nodes[x][y];
		}
		/**设置开始节点**/
		public function setStartNode(x:int,y:int):void
		{
			_startNode = nodes[x][y];
		}
		/**设置某一节点是否可通过**/
		public function setWalkable(x:int,y:int,value:Boolean):void
		{
			nodes[x][y].walkable = value;
		}		
	}
}