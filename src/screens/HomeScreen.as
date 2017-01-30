package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.filters.GlowFilter;

	public class HomeScreen extends PanelScreen
	{

		public static const GO_PLAY:String = "goPlay";

		override protected function initialize():void
		{
			super.initialize();

			this.title = "Bor or Not";
			this.layout = new AnchorLayout();

			var settingsIcon:ImageLoader = new ImageLoader();
			settingsIcon.source = "assets/icons/settings.png";
			settingsIcon.width = settingsIcon.height = 25;
			settingsIcon.color = 0x000000;

			var settingsButton:Button = new Button();
			settingsButton.defaultIcon = settingsIcon;
			settingsButton.styleNameList.add("header-button");
			this.headerProperties.leftItems = new <DisplayObject>[settingsButton];

			var playButton:Button = new Button();
			playButton.addEventListener(Event.TRIGGERED, function ():void
			{
				dispatchEventWith(GO_PLAY);
			});
			playButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, -50);
			playButton.filter = new GlowFilter(0x000000, .70, 1, 0.5);
			playButton.label = "Play";
			playButton.styleNameList.add("menu-button");
			this.addChild(playButton);

			var helpButton:Button = new Button();
			helpButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 50);
			helpButton.filter = new GlowFilter(0x000000, .70, 1, 0.5);
			helpButton.label = "Help";
			helpButton.styleNameList.add("menu-button");
			this.addChild(helpButton);

		}


	}
}