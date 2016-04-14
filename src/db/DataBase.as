package db
{
	import flash.events.EventDispatcher;
	
	import db.interfaces.ISistemaDB;

	public class DataBase extends EventDispatcher
	{
		public var sistema:ISistemaDB;
		public var ganador:GanadorDB;
		public var tablas:TablasDB;
		public var remate:RemateDB;
		
		public function DataBase() {
			sistema = new SistemaDB;
			ganador = new GanadorDB;
			/*
			tablas = new TablasDB;
			remate = new RemateDB;*/
		}
		
		public function login (user:String,psw:String):Boolean {
			if (user=="admin" && psw=="12345")
				return true;
			return false;
		}
	}
}