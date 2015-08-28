package org.spanner.geometry
{
	/**
	 * 3D点对象
	 * 
	 * @author 晨光熹微<br />
	 * date		2015.4.7 
	 * **/
	public class Point3D
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(x:Number=0,y:Number=0,z:Number=0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function toString():String
		{
			return "[x:"+this.x+",y:"+this.y+",z:"+this.z+"]";
		}
		
		public function equal(p:Point3D):Boolean
		{
			return x==p.x && y==p.y && z==p.z;
		}
	}
}