/**
 * @author	晨光熹微
 * @date	2012.8
 * */
package org.spanner.color
{
	import flash.geom.ColorTransform;

	/***
	 * 转换颜色使用的工具类<br />
	 * 可以将一个复色值分解成三个通道色值，
	 * 也可以经过计算后产生带有颜色偏移的ColorTransform对象，
	 * 还可以返回纯色ColorTransform对象，
	 * 还能合成三个通道的颜色。
	 * **/
	public final class AlterColor
	{
		private static const COLORNUM:uint=0xff;															//标准参照色值
		
		public function AlterColor()
		{			
		}
		/**
		 * 分步计算颜色的偏移量
		 * @param	colorValue 颜色值
		 * @param	alphaValue 透明度值
		 * @return	ColorTransform 对象
		 * **/
		public static function changeColor(colorValue:uint,alphaValue:Number=1):ColorTransform
		{
			var redArea:uint=colorValue>>16;																//用位运算取出红色域
			var greenArea:uint=colorValue>>8 & 0xFF;														//用位运算取出绿色域
			var blueArea:uint=colorValue & 0xFF;															//用位运算取出蓝色域
			var colorPercentAry:Vector.<uint> =countPercent(redArea,greenArea,blueArea);
			return new ColorTransform(colorPercentAry[0],colorPercentAry[1],colorPercentAry[2],alphaValue,0,0,0,0);
		}
		/**
		 * 计算各个通道的色彩百分比
		 * @param	redValue 红色通道色值
		 * @param	greenValue 绿色通道色值
		 * @param	blueValue 蓝色通道色值
		 * @return	RGB三通道色值组成的Vector数组
		 * **/
		private static function countPercent(redValue:uint,greenValue:uint,blueValue:uint):Vector.<uint>
		{			
			var redPercent:Number=redValue/0xff;
			var greenPercent:Number=greenValue/0xff;
			var bluePercent:Number=blueValue/0xff;
			var soonVec:Vector.<uint> = new Vector.<uint>([redPercent,greenPercent,bluePercent]);
			return soonVec;
		}
		/**
		 * 生成纯色
		 * @param	pureColor 纯色值
		 * @return	ColorTransform对象
		 * **/
		public static function changePureColor(pureColor:uint=0):ColorTransform
		{
			var pureColorTrans:ColorTransform = new ColorTransform();
			pureColorTrans.color=pureColor;
			return pureColorTrans;
		}
		/**
		 * 复位颜色
		 * @return 新的ColorTransform对象
		 * **/
		public static function reSetColor():ColorTransform
		{
			return new ColorTransform();
		}
		/**
		 * 返回单通道颜色数组
		 * @param	颜色值
		 * @return	保存RGB三个通道色值的Vector数组
		 * **/
		public static function analyseColor(colorValue:uint=0):Vector.<uint>
		{
			var redArea:uint=colorValue>>16;																//用位运算取出红色域
			var greenArea:uint=colorValue>>8 & 0xFF;														//用位运算取出绿色域
			var blueArea:uint=colorValue & 0xFF;															//用位运算取出蓝色域
			var vector:Vector.<uint> =new Vector.<uint>([redArea,greenArea,blueArea]);						//rgb
			return vector;
		}
		/**
		 * 将rgb通道的单色合成为复色
		 * @param	red 红色通道值
		 * @param	green 绿色通道值
		 * @param	blue 蓝色通道值
		 * @return	合成的复色颜色值
		 * **/
		public static function composeColor(red:uint=0,green:uint=0,blue:uint=0):uint
		{
			return red<<16|green<<8|blue;
		}
	}
}