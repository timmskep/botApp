package
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.motion.Slide;

	import screens.HomeScreen;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{

		private static const HOME_SCREEN:String = "homeScreen";

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			new CustomTheme();

			var myNavigator:StackScreenNavigator = new StackScreenNavigator();
			myNavigator.pushTransition = Slide.createSlideLeftTransition();
			myNavigator.popTransition = Slide.createSlideRightTransition();
			this.addChild(myNavigator);

			var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
			myNavigator.addScreen(HOME_SCREEN, homeScreenItem);

			myNavigator.rootScreenID = HOME_SCREEN;

		}

	}
}
