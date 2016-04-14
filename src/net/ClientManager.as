package net
{
	import flash.data.SQLResult;
	
	import be.aboutme.airserver.events.MessageReceivedEvent;

	public class ClientManager extends Manager
	{
		public var servers:ServerManager;
		
		public function ClientManager()
		{
			super(3032);
		}
		
		override protected function server_message(event:MessageReceivedEvent):void {
			super.server_message(event);
			switch(_msg.command) {
				case "c_login": {					
					login(_msg.data.usr,_msg.data.psw);
					break;
				}
				case "venta_gnd": {
					venta_ganador(_msg.data);
					break;
				}
			}
		}
		
		protected function login (usuario:String,psw:String):void {
			data.sistema.validarTaquilla(usuario,psw,function (result:SQLResult):void {
				_msg.command = "c_login";
				if (result.data) {
					if (result.data[0].activa) {
						_msg.data = {code:NetCode.TAQUILLA_LOGIN_OK,data:result.data[0]};
						_clientes.push(_client);
						_clientes_meta.push(result.data[0]);				
					} else {
						_msg.data = {code:NetCode.TAQUILLA_LOGIN_INACTIVO}
					}
				} else {
					_msg.data = {code:NetCode.TAQUILLA_LOGIN_NOEXISTE}
				}
				_client.sendMessage(_msg);
				servers.broadcastMessageTo(_msg,{bancaID:result.data[0].bancaID});
			});
		}
		protected function venta_ganador (data:Object):void {
			_client.sendMessage(_msg);
			
			_msg.data = {code:3,data:data};
			servers.broadcastMessageTo(_msg,{bancaID:data.bancaID});
		}
	}
}