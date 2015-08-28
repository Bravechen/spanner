package org.spanner.geometry
{	
	import flash.display.Graphics;

	/**
	 * 基础二维向量
	 * **/
	public class Vector2D
	{
		public var x:Number;
		public var y:Number;
		
		/**向量长度**/
		public function set length(value:Number):void
		{
			var a:Number = angle;
			x = Math.cos(a)*value;
			y = Math.sin(a)*value;
		}
		
		public function get length():Number
		{
			return Math.sqrt(lengthSQ);
		}
		/**向量长度的2次方**/
		public function get lengthSQ():Number
		{
			return x*x+y*y;
		}
		/**
		 * 向量的角度
		 * <br />改变向量的角度，同时改变向量的x,y，但是保持向量长度不变
		 * **/
		public function set angle(value:Number):void
		{
			var len:Number = length;
			x = Math.cos(value)*len;
			y = Math.sin(value)*len;
		}
		public function get angle():Number
		{
			return Math.atan2(y,x);
		}
		/**
		 * 与当前向量成正交关系的向量(法向量)
		 * **/
		public function get perp():Vector2D
		{
			return new Vector2D(-y,x);
		}		
		
		//=====================public===========================
		public function Vector2D(x:Number=0,y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		/**
		 * 重置向量
		 * @param x 
		 * @param y
		 * **/
		public function reset(x:Number=0,y:Number=0):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 可视化向量
		 * <br />一般只用来debug
		 * @param graphics 绘制对象
		 * @param color 颜色值
		 * **/
		public function draw(graphics:Graphics,color:uint=0):void
		{
			graphics.lineStyle(1,color);
			graphics.moveTo(0,0);
			graphics.lineTo(x,y);
		}
		/**
		 * 深复制当前向量
		 * @return Vector2D
		 * **/
		public function clone():Vector2D
		{
			return new Vector2D(x,y);
		}
		/**
		 * 向量归零
		 * @return Vector2D 归零后的当前向量
		 * **/
		public function zero():Vector2D
		{
			x = 0;
			y = 0;
			return this;
		}
		/**
		 * 向量是否已归零
		 * @return Boolean 已归零true 未归零false
		 * **/
		public function isZero():Boolean
		{
			return x==0 && y==0;
		}
		/**
		 * 归一化向量(单位向量)<br />
		 * 将此向量长度设为1，用于方向计算，提高向量运算效率
		 * 
		 * @return Vector2D 法线化后的当前向量
		 * **/
		public function normalize():Vector2D
		{
			if(length==0){
				x=1;
				return this;
			}
			var len:Number = length;
			x /= len;
			y /= len;
			return this;
		}
		/**
		 * 确保向量的最大值
		 * <br />当向量长度超过给定的值，会自动缩减为给定的值。
		 * @param max 向量的最大值
		 * @param Vector2D 当前向量
		 * **/
		public function truncate(max:Number):Vector2D
		{
			length = Math.min(max,length);
			return this;
		}
		/**
		 * 倒转向量
		 * @param Vector2D 倒转后的当前向量
		 * **/
		public function reverse():Vector2D
		{
			x = -x;
			y = -y;
			return this;
		}
		/**
		 * 向量是否已被归一(单位向量)<br />
		 * 
		 * @return Boolean 
		 * **/
		public function isNormalized():Boolean
		{
			return length == 1;
		}
		/**
		 * 2个向量的点积
		 * @param vector2d 另一个向量
		 * @param Number 点积大小
		 * **/
		public function dotProd(v2:Vector2D):Number
		{
			return x*v2.x + y*v2.y;
		}
		/**内积**/
		public function crossProd(v2:Vector2D):Number
		{
			return x * v2.y - y * v2.x;
		}
		
		/**
		 * 计算2个向量之间的角度
		 * @param v1 向量1
		 * @param v2 向量2
		 * @param Number 角度值
		 * **/
		static public function angleBetween(v1:Vector2D,v2:Vector2D):Number
		{
			if(!v1.isNormalized())
				v1 = v1.clone().normalize();
			if(!v2.isNormalized())
				v2 = v2.clone().normalize();
			return Math.acos(v1.dotProd(v2));
		}
		/**
		 * 判定给定的向量在当前向量的左边还是右边
		 * @return int 如果再左边返回-1,反之,返回1。
		 * 
		 * **/
		public function sign(v2:Vector2D):int
		{
			return perp.dotProd(v2) < 0 ? -1 : 1;
		}
		/**
		 * 计算和另一个向量之间的距离
		 * @param v2 另一个向量
		 * @return Number 距离
		 * **/
		public function dist(v2:Vector2D):Number
		{
			return Math.sqrt(distSQ(v2));
		}
		/**
		 * 计算当前向量和另一个向量之间的距离平方
		 * @param v2 另一个向量
		 * @param 距离平方值
		 * **/
		public function distSQ(v2:Vector2D):Number
		{
			var dx:Number = v2.x - x;
			var dy:Number = v2.y - y;
			return dx*dx + dy*dy;
		}
		/**
		 * 向量相加,并返回一个新的向量
		 * @param v2 另一个向量
		 * @param cv 用于最后返回的向量，为空时返回新的向量对象，不为空时将修改此向量的属性值。
		 * 可以避免频繁创建对象。
		 * @return Vector2D
		 * **/
		public function add(v2:Vector2D,cv:Vector2D=null):Vector2D
		{
			cv ||= new Vector2D();
			cv.x = x+v2.x;
			cv.y = y+v2.y;
			return cv;
		}
		/**
		 * 向量相减,并返回一个新的向量
		 * @param v2 另一个向量
		 * @param cv 用于最后返回的向量，为空时返回新的向量对象，不为空时将修改此向量的属性值。
		 * @return Vector2D
		 * **/
		public function subtract(v2:Vector2D,cv:Vector2D=null):Vector2D
		{
			cv ||= new Vector2D();
			cv.x = x-v2.x;
			cv.y = y-v2.y;
			return cv;
		}
		/**
		 * 向量乘以一个量,并返回一个新的向量
		 * @param value 与向量相乘的数量
		 * @param cv 用于最后返回的向量，为空时返回新的向量对象，不为空时将修改此向量的属性值。
		 * @return Vector2D
		 * **/
		public function multiply(value:Number,cv:Vector2D=null):Vector2D
		{
			cv ||= new Vector2D();
			cv.x = x*value;
			cv.y = y*value;
			return cv;
		}
		/**
		 * 向量除以一个量，并返回一个新的向量
		 * @param value 要相除的量
		 * @param cv 用于最后返回的向量，为空时返回新的向量对象，不为空时将修改此向量的属性值。
		 * @return Vector2D
		 * **/
		public function divide(value:Number,cv:Vector2D=null):Vector2D
		{
			cv ||= new Vector2D();
			cv.x = x/value;
			cv.y = y/value;
			return cv;
		}
		/**
		 * 判断2个向量的数值是否相等
		 * @param v2 另一个向量
		 * @return Boolean
		 * **/
		public function equals(v2:Vector2D):Boolean
		{
			return x==v2.x && y==v2.y;
		}
		/**
		 * 向量的字符串形式
		 * @return 向量字符串描述
		 * **/
		public function toString():String
		{
			return "[Vector2D (x:"+x+",y:"+y+")]";
		}
		
	}
}