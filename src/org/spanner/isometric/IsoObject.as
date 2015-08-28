package org.spanner.isometric
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.spanner.core.sp_internal;
	import org.spanner.geometry.Point3D;
	
	use namespace sp_internal;
	/**
	 * 等角对象基类 
	 * **/
	public class IsoObject extends Sprite implements IIsoObject
	{
		/**位置改变标识**/
		private var positionChange:Boolean = false;
		
		protected var _position:Point3D;

		public function get position():Point3D
		{
			return _position;
		}

		public function set position(value:Point3D):void
		{
			positionChange = true;
			_position = value;
			invalidateUpdate();
		}
		
		public function get depth():Number
		{
			return (_position.x + _position.z)*0.866 - _position.y*0.707;
		}

		protected var _size:Number;

		public function get size():Number
		{
			return _size;
		}

		protected var _walkable:Boolean = false;

		public function get walkable():Boolean
		{
			return _walkable;
		}

		public function set walkable(value:Boolean):void
		{
			_walkable = value;
		}
		
		private var _rect:Rectangle;
		
		public function get rect():Rectangle
		{
			_rect ||= new Rectangle();
			_rect.x = x-size*0.5;
			_rect.y = z-size*0.5;
			_rect.width = size;
			_rect.height = size;
			return _rect;
		}
		
		private var _vx:Number = 0;
		
		public function get vx():Number
		{
			return _vx;
		}
		
		public function set vx(value:Number):void
		{
			_vx = value;
		}
		
		private var _vy:Number = 0;
		
		public function get vy():Number
		{
			return _vy;
		}
		
		public function set vy(value:Number):void
		{
			_vy = value;
		}
		
		private var _vz:Number = 0;
		
		public function get vz():Number
		{
			return _vz;
		}
		
		public function set vz(value:Number):void
		{
			_vz = value;
		}
		
		sp_internal var belongWorld:IsoWorld;
		
		
		
		//==============================================================
		
		override public function set x(value:Number):void
		{
			positionChange = true;
			_position.x = value;
			invalidateUpdate();
		}
		
		override public function get x():Number
		{
			return _position.x;
		}
		
		override public function set y(value:Number):void
		{
			positionChange = true;
			_position.y = value;
			invalidateUpdate();
		}
		
		override public function get y():Number
		{
			return _position.y;
		}
		
		override public function set z(value:Number):void
		{
			positionChange = true;
			_position.z = value;
			invalidateUpdate();
		}
		
		override public function get z():Number
		{
			return _position.z;
		}
		
		//==================================================
		
		public function IsoObject(size:Number=0,position:Point3D=null)
		{
			_size = size;
			_position = (position)?position:new Point3D();
			positionChange = true;
			updateScreenPosition();
		}
		
		override public function toString():String
		{
			return "[IsoObject(x:"+_position.x+",y:"+_position.y+",z:"+_position.z+")]";
		}		
		
		public function validateUpdate():void
		{
			updateScreenPosition();
		}
		
		public function clearDone():void
		{
			
		}
		
		public function termiClear():void
		{
			if(belongWorld)
				belongWorld = null;
		}
		
		protected function invalidateUpdate():void
		{
			if(belongWorld && belongWorld.inRenderList(this)==false){
				belongWorld.addRender(this);
			}else{
				validateUpdate();
			}
		}
		
		protected function updateScreenPosition():void
		{
			if(positionChange){
				var screenPos:Point = IsoUtils.isoToScreen(_position);
				//trace(this.name,screenPos);
				super.x = screenPos.x;
				super.y = screenPos.y;
				positionChange = false;
			}			
		}		
	}
}