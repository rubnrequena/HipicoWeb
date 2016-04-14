package net
{
	import flash.data.SQLResult;
	
	import be.aboutme.airserver.events.MessageReceivedEvent;
	import be.aboutme.airserver.messages.Message;
	

	public class ServerManager extends Manager
	{		
		private var msg_filter:Object;
		public var clients:ClientManager;
		
		public function ServerManager() {
			super(3030);
			
			msg_filter = {};
			match = new Match;
		}
		
		override protected function server_message(event:MessageReceivedEvent):void {
			super.server_message(event);
			
			switch(event.message.command)
			{
				case "s_login": {
					login(_msg.data.usr,_msg.data.psw);
					break;
				}
					
			}
		}
		
		protected function login(user:String, psw:String):void {
			data.sistema.seleccionarUsuario(user,function (result:SQLResult):void {
				_msg.command = "s_login";
				if (result.data) {
					if (result.data[0].clave==psw) {
						_clientes.push(_client);
						_clientes_meta.push(result.data[0]);
						_msg.data = {code:NetCode.USUARIO_LOGIN_OK,data:result.data[0]};
					} else {
						_msg.data = {code:NetCode.USUARIO_LOGIN_NOEXISTE};
					}
				} else {
					_msg.data = {code:NetCode.USUARIO_LOGIN_NOEXISTE};
				}			
				broadcastMessage(_msg);
			});			
		}
		
		
	}
}