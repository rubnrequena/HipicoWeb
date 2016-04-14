package net
{
	import flash.events.EventDispatcher;
	
	import be.aboutme.airserver.AIRServer;
	import be.aboutme.airserver.Client;
	import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
	import be.aboutme.airserver.endpoints.socket.handlers.SocketClientHandlerFactory;
	import be.aboutme.airserver.endpoints.socket.handlers.websocket.WebSocketClientHandlerFactory;
	import be.aboutme.airserver.events.AIRServerEvent;
	import be.aboutme.airserver.events.MessageReceivedEvent;
	import be.aboutme.airserver.messages.Message;
	import be.aboutme.airserver.messages.serialization.JSONSerializer;
	
	import db.DataBase;
	
	public class Manager extends EventDispatcher
	{		
		public var match:Match;
		
		protected var server:AIRServer;
		protected var _client:Client;
		protected var _msg:Message;
		
		protected var _clientes:Vector.<Client> = new Vector.<Client>;
		protected var _clientes_meta:Vector.<Object> = new Vector.<Object>;
		
		public var data:DataBase;
		
		public function Manager(port:int) {
			super();
			
			server = new AIRServer;
			server.addEndPoint(new SocketEndPoint(port,new WebSocketClientHandlerFactory));
			server.addEndPoint(new SocketEndPoint(port+1,new SocketClientHandlerFactory(new JSONSerializer)));
			server.addEventListener(AIRServerEvent.CLIENT_ADDED,server_added);
			server.addEventListener(AIRServerEvent.CLIENT_REMOVED,server_removed);
			server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED,server_message);
			start();
						
			_msg = new Message;
			match = new Match;
		}
		
		public function broadcastMessage (message:Message):void {
			server.sendMessageToAllClients(message);
		}
		
		protected function server_message(event:MessageReceivedEvent):void {
			trace(event.type,event.message.command,event.message.data);
			_client = server.getClientById(event.message.senderId);
			_msg = event.message;
			/*
			if (handlers.hasOwnProperty(event.message.command)) {
				var f:Function = handlers[event.message.command];
				f.call(_client,event.message.data.usr,event.message.data.psw);
			}*/
			
			//echo
			//_client.sendMessage(event.message);
		}
		
		public function broadcastMessageTo (message:Message,filter:Object,and:Boolean=false):void {
			var s:String;
			match.filtro = filter; 
			for (var i:int = 0; i < _clientes_meta.length; i++) {
				if (match.validate(_clientes_meta[i],and)) {
					_clientes[i].sendMessage(message);
				}				
			}
			
		}
		protected function server_removed(event:AIRServerEvent):void {
			trace(event.type,event.client.toString());
		}
		
		protected function server_added(event:AIRServerEvent):void {
			trace(event.type,event.client.toString());
		}
		
		public function stop():void {
			server.stop();
		}
		public function start():void {
			trace("SERVIDOR INICIADO");
			server.start();
		}
	}
}