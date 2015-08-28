package org.spanner.pathfinding
{
	public final class AStarTest
	{
		private var startNode:Node;
		private var endNode:Node;
		private var grid:Grid;
		private var openList:Vector.<Node>; 	//待查列表
		private var closedList:Vector.<Node>;	//已查列表
		private var pathList:Vector.<Node>;		//路径列表
		
		private var straightCost:Number = 1.0;			//平行或垂直区块的代价
		private var diagCost:Number = Math.SQRT2;		//斜角区块的代价
		
		public function AStarTest()
		{			
		}
		/**寻路启动**/
		public function findPath(grid:Grid):Boolean
		{
			this.grid = grid;					//设置网格
			openList = new Vector.<Node>();		//创建待查列表
			closedList = new Vector.<Node>();	//创建已查列表
			//初始化起始节点，分配代价，计算总代价
			startNode = grid.startNode;
			startNode.g = 0;
			startNode.h = heuristic(startNode);
			startNode.f = startNode.g + startNode.h;
			//设置结束节点
			endNode = grid.endNode;
			return search();
		}
		/**寻路实现**/
		private function search():Boolean
		{
			var node:Node = startNode;	//将起始节点作为第一个要检查的节点
			var test:Node;				//当前node节点临近的节点，需要被检查和分配计算代价的节点
			var startX:int;				//Node附近，检查节点的起始网格x坐标
			var startY:int;				//Node附近，检查节点的起始网格y坐标
			var endX:int;				//Node附近，检查节点的结束网格x坐标
			var endY:int;				//Node附近，检查节点的结束网格y坐标
			while(node!=endNode){
				//确定检查开始点的网格坐标，因为考虑边界所以用max
				startX = Math.max(0,node.x-1);
				startY = Math.max(0,node.y-1);
				//确定检查结束点的网格坐标，因为考虑边界所以用min
				endX = Math.min(grid.numCols-1,node.x+1);
				endY = Math.min(grid.numRows-1,node.y+1);
				//从列到行进行循环
				for(var i:int=startX;i<endX;i++){
					for(var j:int=startY;j<endY;j++){
						
						test = grid.getNode(i,j);
						//当检查节点时当前节点，检查节点不可通过，当前节点的附近处于角落时，跳过当前，继续下一轮循环
						/*D当前点 TFW测试点并且不可通过，TTW测试点可通过，此时TTW点不应进行计算，因为在拐角
						D   TFW
						TFW TTW
						*/
						if(test==node || !test.walkable || !grid.getNode(node.x,test.y).walkable || !grid.getNode(test.x,node.y).walkable)
							continue;
						
						var cost:Number = !(node.x == test.x || node.y == test.y)?diagCost:straightCost;	//代价基点，例如平行和垂直设置1，斜角设置1.414
						var g:Number = node.g + (cost*test.costMultiplier);	//当前点的g+测试点的代价，为当前点到测试点的代价G，考虑到地形问题，乘以个地形系数
						var h:Number = heuristic(test);		//启发函数，用于计算当前点到终点的代价
						var f:Number = g + h;				//代价总和
						if(isOpen(test) || isClose(test)){
							//如果检查点在待查列表或者已查列表中，对比一下总代价，如果有更好的，进行修改。
							//原因是因为当前节点改变，路径的选择可能出现不同。
							if(test.f>f){
								test.g = g;
								test.h = h;
								test.f = f;
								test.parent = node;
							}
						}else{
							//如果检查点不在待查列表也不再已查列表，设置他的各项代价，设置当前点为他的父节点，最后把他加入待查列表
							test.g = g;
							test.h = h;
							test.f = f;
							test.parent = node;
							openList.push(test);
						}
					}
				}
				closedList.push(node);	//将检查完毕的当前节点放入已查列表
				if(openList.length==0){
					trace('没找到路径');
					return false;		
				}
				openList.sort(sortFByNumber); 	//按照代价对待查列表进行排序
				node = openList.shift();	//取出代价最小的那个节点作为下一个要检查的节点。
			}
			buildPath();	//构建路径
			return true;
		}
		
		private function buildPath():void
		{
			
		}
		
		private function sortFByNumber(node1:Node,node2:Node):int
		{
			return (node1.f>node2.f)?1:(node1.f<node2.f)?-1:0;
		}
		
		private function isOpen(node:Node):Boolean{
			return false;
		}
		
		private function isClose(node:Node):Boolean{
			return false;
		}
		
		private function heuristic(node:Node):Number{
			return 0;
		}
	}
}