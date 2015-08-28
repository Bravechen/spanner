package org.spanner.math
{
	import flash.geom.Point;

	public final class Calculated
	{
		public function Calculated()
		{
		}
		/**
		 * 保留小数位数
		 * 
		 * @param num 原数字
		 * @param digit 要保留多少位
		 * @return Number
		 * **/
		static public function leaveDigits(num:Number,digit:int=0):Number
		{
			var d:int = Math.pow(10,digit);
			return ((num*d)>>0)/d;
		}
		/**
		 * 根据两点确定2点连线的二元一次方程
		 * @param point1 第一个点
		 * @param point2 第二个点
		 * @param type 指定返回函数形式。0：由x值得到y值(返回方法的参数是x)，1：由y值得到x值(返回的方法参数是y)，默认是0
		 * @return Function 一个可由传入参数获得经二元一次方程计算得出后的对应值的函数。
		 * **/
		static public function lineFun(point1:Point,point2:Point,type:int=0):Function
		{
			//var resultFn:Function;
			if(point1.x == point2.x){
				if(type==0){
					throw new Error("由于直线垂直于x轴，不能根据x值得到y值");
				}else if(type==1){
					return function(y:Number):Number
					{
						return point1.x;	
					}					
				}
			}else if(point1.y == point2.y){
				if(type==0){
					return function(x:Number):Number
					{
						return point1.y;
					}
				}else if(type==1){
					throw new Error("由于直线垂直于y轴，不能根据y值得到x值");
				}
			}	
			
			var a:Number;
			var b:Number;
			/*
			 根据y = ax +b ==>
			y1 = ax1 + b
			y2 = ax2 + b ==>两式相减消去b
			a = (y1 - y2)/(x1 - x2)
			
			*/
			a = (point1.y - point2.y)/(point1.x - point2.x);
			b = point1.y - a*point1.x;	//将a代入公式
			
			if(type==0){
				return function(x:Number):Number
				{
					return a*x + b;
				}
			}else if(type==1){
				return function(y:Number):Number
				{
					return (y-b)/a;
				}				
			}
			
			return null;
		}
	}
}