package db
{
	import flash.data.SQLConnection;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class DB extends EventDispatcher
	{
		protected var conexion:SQLConnection;
		protected var archivoDB:File;
		
		private var _conected:Boolean;
		public function get conected():Boolean { return _conected; }
		
		public function DB() {
			conexion = new SQLConnection;	
			conexion.addEventListener(SQLEvent.OPEN,openHandler);	
		}
		
		protected function openHandler(event:SQLEvent):void {
			_conected = true;
		}
		protected function crearSentencia (texto:String,clase:Class=null):SQLStatementPool {
			var s:SQLStatementPool = new SQLStatementPool(texto,conexion);
			return s;
		}
		protected function conectar():void {
			if (archivoDB.exists) {
				conexion.openAsync(archivoDB);
			} else {
				copiarEstructura();
				conectar();
				//dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Archivo no existe: '"+archivoDB.nativePath+"'",1));
			}
		}
		protected function copiarEstructura():void {
			var estructura:File = File.applicationDirectory.resolvePath("archivos").resolvePath("db").resolvePath(archivoDB.name);			
			estructura.copyTo(archivoDB);
		}
	}
}