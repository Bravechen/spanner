package org.spanner.graphics
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	public final class DashLine
	{
		public function DashLine()
		{
		}
		
		/**
		 * 画虚线，也可以画斜虚线 
		 * @param target
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param pattern
		 * 
		 */		
		protected function dashLineToPattern(canvas:DisplayObject, x1:Number, y1:Number,x2:Number, y2:Number,pattern:Array ,lineColor:uint = 0xd2d2d2):void 
		{ 
			if(!canvas&&!(canvas is Shape||canvas is Sprite)){
				return;
			}
			var drawCanvas:* = (canvas is Shape)?Shape(canvas):Sprite(canvas);
			drawCanvas["graphics"].lineStyle(1,lineColor); 
			var dx:Number = x2 - x1; 
			var dy:Number = y2 - y1; 
			var hyp:Number = Math.sqrt((dx)*(dx) + (dy)*(dy));
			var dashWH:Number = pattern[0];
			var dashGap:Number = pattern[1];
			
			var units:Number = hyp/(dashWH+dashGap); 
			var dashSpaceRatio:Number = dashWH/(dashWH+dashGap); 
			
			var dashX:Number = (dx/units)*dashSpaceRatio; 
			var spaceX:Number = (dx/units)-dashX; 
			var dashY:Number = (dy/units)*dashSpaceRatio; 
			var spaceY:Number = (dy/units)-dashY; 
			
			drawCanvas["graphics"].moveTo(x1, y1); 
			
			while (hyp > 0) 
			{ 
				x1 += dashX; 
				y1 += dashY; 
				hyp -= dashWH; 
				if (hyp < 0) 
				{ 
					x1 = x2; 
					y1 = y2; 
				} 
				
				drawCanvas["graphics"].lineTo(x1, y1); 
				
				x1 += spaceX; 
				y1 += spaceY; 
				hyp -= dashGap;
				
				if (hyp < 0) 
				{ 
					x1 = x2; 
					y1 = y2; 
				}
				drawCanvas["graphics"].moveTo(x1,y1); 
				
			} 
			drawCanvas["graphics"].moveTo(x2, y2); 
		} 
	}
}