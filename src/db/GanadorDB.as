package db
{
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import db.interfaces.IGanadorDB;

	public class GanadorDB extends DB implements IGanadorDB
	{
		private var venta_insert:SQLStatement;
		
		public function GanadorDB() {
			archivoDB = File.documentsDirectory.resolvePath("hipico").resolvePath("ganador.sqlite");
			conectar();
			crearSentencias();
		}
		
		private function crearSentencias():void
		{
			
		}
		
		public function login(usuario:String, clave:String, callback:Function=null):void {
			
		}
		
	}
}