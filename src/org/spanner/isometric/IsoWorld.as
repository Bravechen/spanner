package org.spanner.isometric
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.spanner.core.sp_internal;
	import org.spanner.geometry.Point3D;
	
	use namespace sp_internal;
	/**
	 * 等角投影世界
	 * **/
	public class IsoWorld extends Sprite
	{
		private var _column:int = 0;

		public function get column():int
		{
			return _column;
		}

		private var _row:int = 0;

		public function get row():int
		{
			return _row;
		}

		private var _cellSize:Number = 0;

		public function get cellSize():Number
		{
			return _cellSize;
		}
		
		private var floor:Sprite;
		private var objectList:Array;
		private var world:Sprite;		
		
		public function IsoWorld(column:int=0,row:int=0,cellSize:Number=0)
		{
			_column = column;
			_row = row;
			_cellSize = cellSize;
			
			floor = new Sprite();
			addChild(floor);
			
			world = new Sprite();
			addChild(world);
			
			objectList = [];
			renderList = new Vector.<IIsoObject>();
		}
		/**
		 * 添加区块到世界容器中
		 * **/
		public function addChildToWorld(child:IIsoObject):void
		{					
			if(child is DisplayObject){
				if(checkBound(child.position)){
					return;
				}
				var display:DisplayObject = DisplayObject(child);
				world.addChild(display);
				objectList.push(child);
				if(child is IsoObject){
					IsoObject(child).belongWorld = this;
				}
				sort();
			}else{
				// throw error
			}
		}
		/**添加区块到地面容器中**/
		public function addChildToFloor(child:IIsoObject):void
		{
			if(child is DisplayObject){
				floor.addChild(DisplayObject(child));
				if(child is IsoObject){
					IsoObject(child).belongWorld = this;
				}
			}
		}
		/**深度排序**/
		public function sort():void
		{
			objectList.sortOn("depth",Array.NUMERIC);
			for(var i:int=0,len:int=objectList.length;i<len;i++){
				world.setChildIndex(objectList[i],i);
			}
		}
		/**
		 * 能否按速度移动到某一位置<br />
		 * 在速度累加到位置之前进行检查
		 * 
		 * **/
		public function canMove(obj:IIsoObject):Boolean
		{
			var rect:Rectangle = obj.rect;
			rect.offset(obj.vx,obj.vz);			
			for(var i:int=0,len:int=objectList.length;i<len;i++){
				var objB:IIsoObject = IIsoObject(objectList[i]);
				if(obj!=objB && !objB.walkable && rect.intersects(objB.rect)){
					return false;
				}
			}
			return true;
		}
		/**检查位置是否超出网格范围**/
		public function checkBound(postion:Point3D):Boolean
		{
			return postion.x<0 || postion.x>(_column-1)*cellSize || postion.z<0 || postion.z>(_row-1)*cellSize;
		}
		/**此位置是否没有放置对象**/
		public function isEmptyPosition(position:Point3D):Boolean
		{
			var obj:IIsoObject;
			for(var i:int=0,len:int=objectList.length;i<len;i++){
				obj = IIsoObject(objectList[i]);
				if(obj.position.equal(position)){
					return false;
				}
			}			
			return true;
		}
		
		//=================================================================
		
		
		
		
		//=======================handle Render=============================		
		
		private var renderList:Vector.<IIsoObject>;
		private var waiteFrame:Boolean = false;
		/**添加渲染对象到渲染队列**/
		sp_internal function addRender(obj:IIsoObject):void
		{
			if(renderList.indexOf(obj)==-1){
				renderList.push(obj);
				if(waiteFrame==false){					
					waiteFrame = true;
					if(stage){
						stage.addEventListener(Event.ENTER_FRAME,onUpdateRender);
					}						
				}
			}
		}
		/**是否在渲染队列中**/
		sp_internal function inRenderList(obj:IIsoObject):Boolean
		{
			return renderList.indexOf(obj)>=0;
		}
		/**更新渲染队列中的对象**/
		private function onUpdateRender(e:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME,onUpdateRender);
			var len:int = renderList.length;
			while(len--){
				var isoObject:IIsoObject = renderList.pop();
				isoObject.validateUpdate();
			}
			waiteFrame = false;
		}		
	}
}
/*
边界：0 cellSize*(column-1) ===>x
	0 cellSize*(row-1) ===>z
居中:
	x = cellSize*Math.round(column*0.5);
	z = cellSize*Math.round(row*0.5);


*/