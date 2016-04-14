package db.interfaces
{
	public interface ISistemaDB
	{
		function validarTaquilla (usuario:String,clave:String,callback:Function=null):void;
		function seleccionarUsuario (usuario:String,callback:Function=null):void;
		function seleccionarTaquilla_Meta (taquillaID:int,callback:Function):void;
	}
}