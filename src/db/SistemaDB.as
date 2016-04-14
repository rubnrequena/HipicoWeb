package db
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import db.interfaces.ISistemaDB;

	public class SistemaDB extends DB implements ISistemaDB
	{
		private var usr_select:SQLStatementPool;		
		private var taq_login_stat:SQLStatementPool;
		private var taq_meta_stat:SQLStatementPool;
		
		public function SistemaDB()
		{
			super();			
			archivoDB = File.documentsDirectory.resolvePath("hipico").resolvePath("sistema.sqlite");			
			conectar();						
			crearSentencias();
		}
		
		protected function crearSentencias():void {
			taq_login_stat = crearSentencia("SELECT taquillaID,usuario,activa,usuario,bancaID,nombre,tipo FROM taquillas WHERE usuario = :usuario AND clave = :clave");
			taq_meta_stat = crearSentencia("SELECT meta,valor FROM taquillas_meta WHERE taquillaID = :taquillaID");
			usr_select = crearSentencia("SELECT usuarioID,usuario,permisos,activo,clave,bancaID FROM usuarios WHERE usuario = :usuario");
		}
		
		public function validarTaquilla(usuario:String, clave:String, callback:Function=null):void {
			var s:SQLStatement = taq_login_stat.getStat;
			s.parameters[":usuario"] = usuario;
			s.parameters[":clave"] = clave;
			trace("SQL",s.text,usuario,clave);
			s.execute(-1,new Responder(callback,errorHandler));
		}
		
		override protected function openHandler(event:SQLEvent):void {
			trace("BancaDB conectado...");
		}
		private function errorHandler (e:SQLError):void {
			trace(e.errorID,e.details);
		}
		public function seleccionarUsuario (usuario:String,callback:Function=null):void {
			var s:SQLStatement = usr_select.getStat;
			s.parameters[":usuario"] = usuario;	
			s.execute(-1,new Responder(callback));
		}
		
		public function seleccionarTaquilla_Meta(taquillaID:int,callback:Function):void {
			var s:SQLStatement = taq_meta_stat.getStat;
			s.parameters[":taquillaID"] = taquillaID;
			s.execute(-1,new Responder(function (result:SQLResult):void {
				var o:Object = {};
				for each (var p:Object in result.data) {
					o[p.meta] = p.valor;	
				}
				callback.call(null,o);
			}));
		}
		
	}
}