package org.spanner.text
{
	/**
	 * @author	chenguangxi
	 * date		2012.2
	 * 处理数据格式工具类
	 * **/
	public class DealDataFormat
	{
		public static const TIMEFORMAT:String = "00:00:00";
		public function DealDataFormat()
		{
		}
		/**初始时间数据，返回按格式规定的字符串形式**/
		public function dealTimeNum(timeNum:Number):String
		{
			var totalTime:uint = Math.ceil(timeNum);
			var hourStr:String = dealTimeStr(Math.floor(totalTime/3600));
			var minuteStr:String = dealTimeStr(Math.floor(totalTime/60));
			var secondStr:String = dealTimeStr(totalTime%60);
			return hourStr+":"+minuteStr+":"+secondStr;
		}
		/**拼装时间数据格式**/
		private function dealTimeStr(tempNum:uint):String
		{
			var tempStr:String;
			if(tempNum<1)
			{
				tempStr = "00";
			}
			else if(tempNum>=1&&tempNum<10)
			{
				tempStr = "0"+tempNum;
			}
			else if(tempNum>=10)
			{
				tempStr = String(tempNum);
			}
			else
			{
				
			}
			return tempStr;
		}
		/**处理媒体地址返回文件名称**/
		public function dealMdeiaName(url:String):String
		{
			var tempStr:String;
			var startIndex:int;
			startIndex = url.lastIndexOf("\\");
			tempStr = url.slice(startIndex+1);
			return tempStr;
		}
	}
}