package
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.motion.Slide;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	import screens.GameScreen;
	import screens.HomeScreen;

	import starling.display.Sprite;
	import starling.events.Event;

	import utils.ProfileManager;

	public class Main extends Sprite
	{

		private static const HOME_SCREEN:String = "homeScreen";
		private static const GAME_SCREEN:String = "gameScreen";

		private var myNavigator:StackScreenNavigator;

		public function Main()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected function addedToStageHandler(event:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);

			new CustomTheme();

			myNavigator = new StackScreenNavigator();
			myNavigator.pushTransition = Slide.createSlideLeftTransition();
			myNavigator.popTransition = Slide.createSlideRightTransition();
			this.addChild(myNavigator);

			var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
			homeScreenItem.setScreenIDForPushEvent(HomeScreen.GO_PLAY, GAME_SCREEN);
			myNavigator.addScreen(HOME_SCREEN, homeScreenItem);

			var gameScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GameScreen);
			gameScreenItem.addPopEvent(starling.events.Event.COMPLETE);
			myNavigator.addScreen(GAME_SCREEN, gameScreenItem);

			if (ProfileManager.isLoggedIn()) {

				Constants.LOGGED_USER_DATA = ProfileManager.loadProfile();

				var header:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");

				var myObject:Object = new Object();
				myObject.grant_type = "refresh_token";
				myObject.refresh_token = Constants.LOGGED_USER_DATA.refresh_token;

				var request:URLRequest = new URLRequest(Constants.FIREBASE_AUTH_TOKEN_URL);
				request.method = URLRequestMethod.POST;
				request.data = JSON.stringify(myObject);
				request.requestHeaders.push(header);

				var loader:URLLoader = new URLLoader();
				loader.addEventListener(flash.events.Event.COMPLETE, function ():void
				{
					var rawData:Object = JSON.parse(loader.data);
					Constants.FIREBASE_AUTH_TOKEN = rawData.access_token;
					myNavigator.rootScreenID = HOME_SCREEN;
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function ():void
				{
					trace(loader.data);
				});
				loader.load(request);

			} else {

				//Register User

				var header2:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");

				var registerRequest:URLRequest = new URLRequest(Constants.GUEST_SIGNUP);
				registerRequest.method = URLRequestMethod.POST;
				registerRequest.data = JSON.stringify({});
				registerRequest.requestHeaders.push(header2);

				var registerLoader:URLLoader = new URLLoader();
				registerLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				registerLoader.addEventListener(flash.events.Event.COMPLETE, registerComplete);
				registerLoader.load(registerRequest);

			}

		}

		private function errorHandler(event:IOErrorEvent):void
		{
			trace(event.currentTarget.data);
		}

		private function registerComplete(event:flash.events.Event):void
		{
			//The user has been registered to our Firebase project, now we are going to log in to get an access_token.
			var rawData:Object = JSON.parse(event.currentTarget.data);
			var header:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");

			var myObject:Object = new Object();
			myObject.grant_type = "refresh_token";
			myObject.refresh_token = rawData.refreshToken;

			var request:URLRequest = new URLRequest(Constants.FIREBASE_AUTH_TOKEN_URL);
			request.method = URLRequestMethod.POST;
			request.data = JSON.stringify(myObject);
			request.requestHeaders.push(header);

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, authComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}

		private function authComplete(event:flash.events.Event):void
		{
			var rawData:Object = JSON.parse(event.currentTarget.data);

			Constants.LOGGED_USER_DATA = rawData;
			Constants.FIREBASE_AUTH_TOKEN = rawData.id_token;
			ProfileManager.saveProfile(rawData);

			myNavigator.rootScreenID = HOME_SCREEN;
		}

	}
}
