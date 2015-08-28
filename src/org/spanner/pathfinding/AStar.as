package org.spanner.pathfinding
{
	public class AStar
	{
		private var _pathList:Vector.<Node>;

		public function get pathList():Vector.<Node>
		{
			return _pathList;
		}
		
		public function get visited():Vector.<Node>
		{
			return closedList.concat(openList);
		}
		
		//==================================================
		
		//private var openList:Vector.<Node>;
		private var openList:NodeBinary;
		private var closedList:Vector.<Node>;
		private var grid:Grid;
		private var endNode:Node;
		private var startNode:Node;
		
//		private var heuristic:Function = manhattan;
//		private var heuristic:Function = euclidian;
		private var heuristic:Function = diagonal;
		private var straightCost:Number = 1.0;			//平行或垂直区块的代价
		private var diagCost:Number = Math.SQRT2;		//斜角区块的代价
		
		//==================================================
		
		public function AStar()
		{
		}
		
		public function findPath(grid:Grid):Boolean
		{
			this.grid = grid;
			//openList = new Vector.<Node>();
			openList = new NodeBinary("f");
			closedList = new Vector.<Node>();
			
			startNode = this.grid.startNode;
			endNode = this.grid.endNode;
			
			startNode.g = 0;
			startNode.h = heuristic(startNode);
			startNode.f = startNode.g + startNode.h;
			
			return search();
		}
		
		private function search():Boolean
		{
			var node:Node = startNode;
			var startX:int;
			var endX:int;
			var startY:int;
			var endY:int;
			
			while(node!=endNode){
				startX = 0<=node.x-1?node.x-1:0;
				startY = 0<=node.y-1?node.y-1:0;
				
				endX = grid.numCols-1<=node.x+1?grid.numCols-1:node.x+1;
				endY = grid.numRows-1<=node.y+1?grid.numRows-1:node.y+1;
				
				for(var i:int=startX;i<=endX;i++)
				{
					for(var j:int=startY;j<=endY;j++)
					{
						var test:Node = grid.getNode(i,j);
						if(test==node){
							continue;
						}
						
						test.costMultiplier = (!test.walkable || !isDiagonalWalkable(node,test))?1000:1;
						
//						if(test==node || !test.walkable || !grid.getNode(node.x,test.y).walkable || !grid.getNode(test.x,node.y).walkable)
//							continue;
						var cost:Number = !(node.x == test.x || node.y == test.y)?diagCost:straightCost;
						var g:Number = node.g + (cost*test.costMultiplier);
						var h:Number = heuristic(test);
						var f:Number = g+h;
						var inOpen:Boolean = openList.indexOf(test)>=0;
						if(inOpen || closedList.indexOf(test)>=0){
							if(test.f>f){
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
								if(inOpen){
									openList.updateNode(test);
								}
							}
						}else{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							openList.push(test);
						}
					}
				}
				closedList.push(node);
				if(openList.length==0){
					trace("no path found1");
					return false;
				}
				node = openList.shift();				
			}
			buildPath();
			if(pathList.length==0){
				trace("no path found2");
				return false;				
			}
				
			return true;
		}
		/**构建路径**/
		private function buildPath():void
		{
			_pathList = new Vector.<Node>();
			var node:Node = endNode;
			_pathList.push(node);
			while(node.parent!=startNode){
				node = node.parent;
				_pathList.unshift(node);
			}
			//trace(_pathList);
			if(!isDiagonalWalkable(startNode,_pathList[0])){
				_pathList.length = 0;
				return;
			}
				
			for(var i:int=0,len:int=_pathList.length;i<len;i++){
				if(_pathList[i].walkable==false){
					_pathList.splice(i,len-i);
					break;
				}else if(len==1 && !isDiagonalWalkable(startNode,endNode)){
					_pathList.shift();
				}else if(i<len-1 && !isDiagonalWalkable(_pathList[i],_pathList[i+1])){
					_pathList.splice(i+1,len-i-1);
					break;
				}
			} 
		}
		
		private function isDiagonalWalkable(node1:Node,node2:Node):Boolean
		{
			var absideNode1:Node = grid.getNode(node1.x,node2.y);
			var absideNode2:Node = grid.getNode(node2.x,node1.y);
			if(absideNode1.walkable && absideNode2.walkable)
				return true;
			return false;
		}
		
		private function getNodeUnderPoint(xPox:Number,yPos:Number,exception:Array=null):Array
		{
			return null;
		}
		
		
		//===================================================
		
		/**对角算法启发函数**/
		private function diagonal(node:Node):Number
		{
			var dx:Number = node.x - endNode.x;
			dx = dx>=0?dx:-dx;
			var dy:Number = node.y - endNode.y;
			dy = dy>=0?dy:-dy;
			var diag:Number = dx<=dy?dx:dy;
			var straight:Number = dx + dy;
			return diagCost*diag+straightCost*(straight-2*diag);
		}
	}
}