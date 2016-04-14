package db.interfaces
{
	public interface IGanadorDB
	{
		function login (usuario:String,clave:String,callback:Function=null):void;
	}
}