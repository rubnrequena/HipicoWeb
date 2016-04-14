package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import db.DataBase;
	
	import net.ClientManager;
	import net.ServerManager;
	
	public class HipicoWeb extends Sprite
	{
		private var _server:ServerManager;
		private var _client:ClientManager;
		private var _db:DataBase;
		
		public function HipicoWeb()
		{
			_db = new DataBase;
			
			_server = new ServerManager;
			_client = new ClientManager;
			
			_server.clients = _client;
			_server.data = _db;
			
			_client.servers = _server;
			_client.data = _db;
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING,onExit);
			
			/*var n:Object = {nombre:"Dario",apellido:"Requena2",edad:28,nivel:0};
			var m:Match = new Match;
			
			m.filtro = ({nombre:"Dario",apellido:"Requena"});
			trace("match",m.validate(n));
			
			m.filtro = ({nombre:"Dario",apellido:"Requena1"});
			trace("match",m.validate(n,true));
			
			trace("match",Match.validate(n,{edad:22,nivel:0},{nombre:"Ruben",apellido:"Requena"}));*/
		}
		
		protected function onExit(event:Event):void {
			_server.stop();
		}
	}
}