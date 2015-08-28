package org.spanner.physics.collision
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	/**
	 * 碰撞检测网格<br />
	 * 提供用于网格碰撞检测的网格构建和对象查找
	 * 
	 * @author 晨光熹微
	 * date	2015.3.23
	 * **/
	public class CollisionGrid extends EventDispatcher
	{
		public var gridColor:uint = 0xcccccc;
		
		private var _checks:Vector.<DisplayObject>;
		/**
		 * 需要进行碰撞检测的列表
		 * 此列表中的元素，需要进行两两碰撞检测。
		 * 例如：0和1,2和3....
		 * 
		 * **/
		public function get checks():Vector.<DisplayObject>
		{
			return _checks;
		}
		/**网格结构**/
		private var grid:Vector.<Vector.<DisplayObject>>;
		/**单元格尺寸**/
		private var gridSize:Number;
		/**网格高度**/
		private var height:Number;
		/**网格宽度**/
		private var width:Number;
		/**单元格总数**/
		private var numCells:int;
		/**列总数**/
		private var numCols:int;
		/**行总数**/
		private var numRows:int;
		
		/**
		 * 创建一个碰撞检测网格
		 * @param width
		 * @param height
		 * @param gridSize
		 * **/
		public function CollisionGrid(width:Number,height:Number,gridSize:Number)
		{
			this.width = width;
			this.height = height;
			this.gridSize = gridSize;
			numCols = Math.ceil(this.width/this.gridSize);
			numRows = Math.ceil(this.height/this.gridSize);
			numCells = numCols*numRows;
		}
		/**
		 * 绘制网格
		 * 
		 * @param graphics
		 * **/
		public function drawGrid(graphics:Graphics):void
		{
			graphics.lineStyle(1,gridColor);
			for(var i:int=0;i<width;i+=gridSize){
				graphics.moveTo(i,0);
				graphics.lineTo(i,height);
			}
			
			for(i=0;i<height;i+=gridSize){
				graphics.moveTo(0,i);
				graphics.lineTo(width,i);
			}
		}
		/**
		 * 检测对象
		 * 将对象列表中的对象分配的相应的网格当中，然后进行网格检测。
		 * 最终生成一个含有需要进行两两检测的列表
		 * 
		 * **/
		public function check(list:Vector.<DisplayObject>):void
		{
			var sum:int = list.length;
			grid = new Vector.<Vector.<DisplayObject>>(numCells);
			_checks = new Vector.<DisplayObject>();
			var index:int;
			var obj:DisplayObject;
			for(var i:int=0;i<sum;i++){
				obj = list[i];
				index = (Math.floor(obj.y/gridSize))*numCols+(Math.floor(obj.x/gridSize));
				if(index>numCells)
					break;
				grid[index] ||= new Vector.<DisplayObject>();
				grid[index].push(obj);
			}
			checkGrid();
		}
		/**
		 * 网格检测
		 * 逐行对网格的单元格尽心检测，找出需要进行碰撞检测的对象。
		 * 
		 * **/
		private function checkGrid():void
		{
			for(var i:int=0;i<numCols;i++){
				for(var j:int=0;j<numRows;j++){
					checkOneCell(i,j);
					checkTwoCell(i,j,i+1,j);
					checkTwoCell(i,j,i-1,j+1);
					checkTwoCell(i,j,i,j+1);
					checkTwoCell(i,j,i+1,j+1);
				}
			}
		}
		/**
		 * 找出一个单元格之内需要被检测的对象
		 * @param x 在网格中的列
		 * @param y 在网格中的行
		 * **/
		private function checkOneCell(x:int,y:int):void
		{
			var cell:Vector.<DisplayObject> = grid[y*numCols+x];
			if(!cell)
				return;
			var cellLength:int = cell.length;
			for(var i:int=0;i<cellLength-1;i++){
				var objA:DisplayObject = cell[i];
				for(var j:int=i+i;j<cellLength;j++){
					var objB:DisplayObject = cell[j];
					_checks.push(objA,objB);
				}
			}
		}
		/**
		 * 找出2个单元格内需要被检测的对象
		 * @param x1 第一个单元格的列索引
		 * @param y1 第一个单元格的行索引
		 * @param x2 第二个单元格的列索引
		 * @param y2 第二个单元格的行索引
		 * **/
		private function checkTwoCell(x1:int,y1:int,x2:int,y2:int):void
		{
			if(x2>=numCols || x2<0 || y2>=numRows)
				return;
			var cellA:Vector.<DisplayObject> = grid[y1*numCols+x1];
			var cellB:Vector.<DisplayObject> = grid[y2*numCols+x2];
			if(cellA==null || cellB==null)
				return;
			var cellALength:int = cellA.length;
			var cellBLength:int = cellB.length;
			
			for(var i:int=0;i<cellALength;i++){
				var objA:DisplayObject = cellA[i];
				for(var j:int=0;j<cellBLength;j++){
					var objB:DisplayObject = cellB[j];
					_checks.push(objA,objB);				
				}				
			}
		}
	}	
}