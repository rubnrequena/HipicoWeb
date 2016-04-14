package
{
	public class Match
	{		
		public var filtro:Object;		
		private var c:String;
		
		public function Match() {
			filtro = {};
		}
		/*private static var _prop:String;
		public static function validate (match:Object,or:Object=null,and:Object=null):Boolean {
			var b:Boolean=true;
			if (or) {
				b = false;
				for (_prop in or) {
					if (match.hasOwnProperty(_prop) && or[_prop]==match[_prop]) return true;
				}
			}
			if (and) {
				for (_prop in and) {
					if (match.hasOwnProperty(_prop) && and[_prop] != match[_prop]) {
						b = false; break;
					}
				}
				return b;
			}
			return true;
		}*/
				
		public function validate (obj:Object,and:Boolean=false):Boolean {
			var prop:String;
			if (and) {
				var b:Boolean=true;
				for (prop in filtro) {
					if (obj.hasOwnProperty(prop) && filtro[prop] != obj[prop]) {
						b = false; break;
					}
				}
				clear();
				return b;
			} else {
				for (prop in filtro) {
					if (obj.hasOwnProperty(prop) && filtro[prop]==obj[prop]) {
						clear();
						return true;
					}
				}
			}
			return false;
		}
		public function clear ():void {
			for (c in filtro) delete filtro[c];
		}
	}
}