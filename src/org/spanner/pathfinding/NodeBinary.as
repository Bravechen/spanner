package org.spanner.pathfinding
{
	/**
	 * 二叉堆节点列表
	 * **/
	public final class NodeBinary
	{
		private var data:Vector.<Node>;

		private var compareString:String;
		
		public function get length():int
		{
			return (data)?data.length:0;
		}
		
		public function NodeBinary(compareString:String="")
		{			
			if(compareString){
				this.compareString = compareString;
			}
			
			data = new Vector.<Node>();
		}
		
		/**推入列表**/
		public function push(node:Node):void
		{
			data.push(node);
			var len:int = data.length;
			if(len>1){
				var index:int = len;
				var parentIndex:int = index/2-1;
				var temp:Node;
				while(compareTwoNodes(node,data[parentIndex])){
					temp = data[parentIndex];
					data[parentIndex] = node;
					data[index-1] = temp;
					index/=2;
					parentIndex = index/2-1;
				}
			}
		}
		/**从列表头删除**/
		public function shift():Node
		{
			var delNode:Node = data.shift();
			var len:int = data.length;
			if(len>1){
				var lastNode:Node = data.pop();
				data.unshift(lastNode);
				var index:int = 0;
				var childIndex:int = (index+1)*2-1;
				var compareIndex:int;
				var temp:Node;
				while(childIndex<len){					
					if(childIndex+1==len){
						compareIndex = childIndex;					
					}else{
						compareIndex = compareTwoNodes(data[childIndex],data[childIndex+1])?childIndex:childIndex+1;
					}
					if(compareTwoNodes(data[compareIndex],lastNode)){
						temp = data[compareIndex];
						data[compareIndex] = lastNode;
						data[index] = temp;
						index = compareIndex;
						childIndex = (index+1)*2-1;
					}else{
						break;
					}					
				}
			}
			return delNode;
		}
		/**修改列表中某项**/
		public function updateNode(node:Node):void
		{
			var index:int = data.indexOf(node)+1;
			if(index==0){
				throw new Error("列表中无此项");
			}else{
				var parentIndex:int = index/2-1;
				var temp:Node;
				while(compareTwoNodes(node,data[parentIndex])){
					temp = data[parentIndex];
					data[parentIndex] = node;
					data[index-1] = temp;
					index/=2;
					parentIndex = index/2-1;
				}
			}						
		}
		/**查询节点在列表中的位置，没有返回-1**/
		public function indexOf(node:Node):int
		{
			return data.indexOf(node);
		}
		
		private function compareTwoNodes(node1:Node,node2:Node):Boolean
		{
			if(compareString){
				return node1[compareString] < node2[compareString];
			}else{
				return node1 < node2;
			}
		}
	}
}