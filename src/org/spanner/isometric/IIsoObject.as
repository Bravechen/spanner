package org.spanner.isometric
{
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import org.spanner.geometry.Point3D;
	/**
	 * 等角对象接口
	 * **/
	public interface IIsoObject extends IEventDispatcher
	{
		/**位置**/
		function get position():Point3D;
		function set position(value:Point3D):void;
		/**深度**/
		function get depth():Number;
		/**
		 * 等角对象覆盖的尺寸<br />
		 * 
		 * **/
		function get size():Number;
		/**
		 * 是否可被通过
		 * **/
		function get walkable():Boolean;
		function set walkable(value:Boolean):void;
		/**
		 * 返回等角对象对应的矩形区域
		 * **/
		function get rect():Rectangle;
		
		/**
		 * 对象x轴速度
		 * **/
		function set vx(value:Number):void;
		function get vx():Number;
		/**
		 * 对象y轴速度
		 * **/
		function set vy(value:Number):void;
		function get vy():Number;
		/**
		 * 对象z轴速度
		 * **/
		function set vz(value:Number):void;
		function get vz():Number;
		
		/**
		 * 使更新生效<br />
		 * 用于延迟更新计算
		 * **/
		function validateUpdate():void;
	}
}