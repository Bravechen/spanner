package org.spanner.isometric
{
	import flash.geom.Point;
	
	import org.spanner.geometry.Point3D;
	/**
	 * 等角投影工具
	 * 
	 * @author 晨光熹微<br />
	 * date		2015.4.7 
	 * **/
	public final class IsoUtils
	{
		/*
		iso==>2d
		sx = x -z;
		sy = y*1.2247 + (x + z)*0.5;
		
		2d==>iso
		x = sy+sx/2;
		y = 0;
		z = sy-sx/2;			
		*/
		/**系数常量1.2247**/
		static public const Y_CORRECT:Number = Math.cos(-Math.PI/6)*Math.SQRT2;
		/**
		 * 等角投影世界坐标转为屏幕坐标
		 * 
		 * **/
		static public function isoToScreen(pos:Point3D):Point
		{
						
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y*Y_CORRECT + (pos.x+pos.z)*0.5;
			return new Point(screenX,screenY);
		}
		/**
		 * 屏幕坐标转为等角投影世界坐标
		 * 
		 * **/
		static public function screenToIso(point:Point):Point3D
		{
			var xpos:Number = point.y + point.x*0.5;
			var ypos:Number = 0;
			var zpos:Number = point.y - point.x*0.5;			
			return new Point3D(xpos,ypos,zpos);
		}		
	}
}