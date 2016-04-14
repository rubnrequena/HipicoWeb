package db
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;

	public class SQLStatementPool
	{
		private var pool:Vector.<SQLStatement>;
		private var _sentencia:String;
		private var _conexion:SQLConnection;
		
		public function get length():uint {
			return pool.length;
		}
		
		public function clear():void {
			pool.length = 0;
		}
		
		public function SQLStatementPool(sentencia:String,conexion:SQLConnection) {
			pool = new Vector.<SQLStatement>;
			_sentencia = sentencia;
			_conexion = conexion;
		}
		
		public function get getStat():SQLStatement {
			var l:int = pool.length;
			for (var i:int = 0; i < l; i++) {
				if (pool[i].executing==false) return pool[i];
			}			
			var sql:SQLStatement = new SQLStatement;
			sql.sqlConnection = _conexion;
			sql.text = _sentencia;
			pool.push(sql);
			return sql;
		}
	}
}