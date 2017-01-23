package
{
	public class Constants
	{
		public static var LOGGED_USER_DATA:Object;
		public static var FIREBASE_AUTH_TOKEN:String; //Also known as the access_token

		public static const FIREBASE_API_KEY:String = "";

		private static const AUTH_BASE_URL:String = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/";

		public static const GUEST_SIGNUP:String = AUTH_BASE_URL + "signupNewUser?key=" + FIREBASE_API_KEY;
		public static const FIREBASE_AUTH_TOKEN_URL:String = "https://securetoken.googleapis.com/v1/token?key=" + FIREBASE_API_KEY;

		private static const PROJECT_ID:String = "INSERT-PROJECT-ID";
		public static const FIREBASE_QUESTIONS_URL:String = 'https://' + PROJECT_ID + '.firebaseio.com/bot_app.json';
		public static const FIREBASE_USER_STATS_URL:String = 'https://' + PROJECT_ID + '.firebaseio.com/bot_app_stats/';

	}
}