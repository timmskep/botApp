package screens
{
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextFormat;

	import utils.RoundedRect;

	public class HomeScreen extends PanelScreen
	{
		private var currentQuestion:Number = 0;
		private var questionsArray:Array;

		private var questionTextLabel:Label;
		private var botLabel:Label;
		private var sourceGroup:LayoutGroup;
		private var sourceLabel:Label;
		private var grayOVerlay:BasicButton;

		override protected function initialize():void
		{

			this.title = "Bot or Not";

			var myLayout:VerticalLayout = new VerticalLayout();
			myLayout.gap = 20;
			myLayout.horizontalAlign = HorizontalAlign.CENTER;
			this.layout = myLayout;

			var settingsIcon:ImageLoader = new ImageLoader();
			settingsIcon.source = "assets/icons/settings.png";
			settingsIcon.width = settingsIcon.height = 25;
			settingsIcon.color = 0x000000;

			var settingsButton:Button = new Button();
			settingsButton.defaultIcon = settingsIcon;
			settingsButton.styleNameList.add("header-button");
			this.headerProperties.leftItems = new <DisplayObject>[settingsButton];

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);
		}

		private function transitionComplete(event:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionComplete);

			loadQuestions();
		}

		private function loadQuestions():void
		{
			var request:URLRequest = new URLRequest(Constants.FIREBASE_QUESTIONS_URL);

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, questionsLoaded);
			loader.load(request);
		}

		private function questionsLoaded(event:flash.events.Event):void
		{
			this.removeEventListener(flash.events.Event.COMPLETE, questionsLoaded);

			var rawData:Object = JSON.parse(event.currentTarget.data);
			questionsArray = new Array();

			for (var parent:String in rawData) {
				var tempObject:Object = new Object();
				tempObject.id = parent;

				for (var child:* in rawData[parent]) {
					tempObject[child] = rawData[parent][child];
				}

				questionsArray.push(tempObject);
				tempObject = null;
			}

			initUI();
		}

		private function initUI():void
		{
			var textGroup:LayoutGroup = new LayoutGroup();
			textGroup.layout = new AnchorLayout();
			textGroup.layoutData = new VerticalLayoutData(100, 100);
			this.addChild(textGroup);

			questionTextLabel = new Label();
			questionTextLabel.layoutData = new AnchorLayoutData(20, 20, 20, 20);
			questionTextLabel.fontStyles = new TextFormat("_sans", 18, 0x000000);
			questionTextLabel.fontStyles.leading = 7;
			questionTextLabel.wordWrap = true;
			textGroup.addChild(questionTextLabel);

			sourceGroup = new LayoutGroup();
			sourceGroup.layout = new AnchorLayout();
			sourceGroup.layoutData = new VerticalLayoutData(90, NaN);
			sourceGroup.height = 100;
			this.addChild(sourceGroup);

			botLabel = new Label();
			botLabel.fontStyles = new TextFormat("_sans", 30, 0x000000);
			botLabel.layoutData = new AnchorLayoutData(10, NaN, NaN, NaN, 0, NaN);
			sourceGroup.addChild(botLabel);

			sourceLabel = new Label();
			sourceLabel.fontStyles = new TextFormat("_sans", 18, 0x000000);
			sourceLabel.fontStyles.leading = 3;
			sourceLabel.layoutData = new AnchorLayoutData(NaN, 10, 10, 10, 0, NaN);
			sourceLabel.wordWrap = true;
			sourceGroup.addChild(sourceLabel);

			var infoIcon:ImageLoader = new ImageLoader();
			infoIcon.source = "assets/icons/info.png";
			infoIcon.width = infoIcon.height = 30;

			var infoButton:Button = new Button();
			infoButton.addEventListener(starling.events.Event.TRIGGERED, showSourceDetails);
			infoButton.defaultIcon = infoIcon;
			infoButton.layoutData = new AnchorLayoutData(10, 10, NaN, NaN);
			sourceGroup.addChild(infoButton);

			grayOVerlay = new BasicButton();
			grayOVerlay.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			grayOVerlay.defaultSkin = RoundedRect.createRoundedRect(0xCCCCCCC);
			sourceGroup.addChild(grayOVerlay);

			/*
			 Bottom group block
			 */
			var layoutForBottomGrpup:HorizontalLayout = new HorizontalLayout();
			layoutForBottomGrpup.horizontalAlign = HorizontalAlign.CENTER;
			layoutForBottomGrpup.verticalAlign = VerticalAlign.MIDDLE;
			layoutForBottomGrpup.gap = 15;

			var bottomGroup:LayoutGroup = new LayoutGroup();
			bottomGroup.layoutData = new VerticalLayoutData(100, NaN);
			bottomGroup.layout = layoutForBottomGrpup;
			this.addChild(bottomGroup);

			var botIcon:ImageLoader = new ImageLoader();
			botIcon.source = "assets/icons/bot.png";
			botIcon.width = botIcon.height = 70;

			var botButton:Button = new Button();
			botButton.addEventListener(starling.events.Event.TRIGGERED, revealAnswer);
			botButton.defaultIcon = botIcon;
			bottomGroup.addChild(botButton);

			var nextIcon:ImageLoader = new ImageLoader();
			nextIcon.source = "assets/icons/next.png";
			nextIcon.width = nextIcon.height = 50;

			var nextButton:Button = new Button();
			nextButton.addEventListener(starling.events.Event.TRIGGERED, function ():void
			{
				grayOVerlay.visible = true;
				currentQuestion++;
				showQuestion();
			});
			nextButton.defaultIcon = nextIcon;
			bottomGroup.addChild(nextButton);

			var notbotIcon:ImageLoader = new ImageLoader();
			notbotIcon.source = "assets/icons/notbot.png";
			notbotIcon.width = notbotIcon.height = 70;

			var notbotButton:Button = new Button();
			notbotButton.addEventListener(starling.events.Event.TRIGGERED, revealAnswer);
			notbotButton.defaultIcon = notbotIcon;
			bottomGroup.addChild(notbotButton);

			var bottomSpacer:LayoutGroup = new LayoutGroup();
			bottomSpacer.width = bottomSpacer.height = 5;
			this.addChild(bottomSpacer);

			showQuestion();
		}

		private function showSourceDetails(event:starling.events.Event):void
		{
			questionTextLabel.text = questionsArray[currentQuestion].source;
		}

		private function revealAnswer(event:starling.events.Event):void
		{
			grayOVerlay.visible = false;
		}

		private function showQuestion():void
		{
			questionTextLabel.text = '"<i>' + questionsArray[currentQuestion].text + '"</i>';

			sourceLabel.text = questionsArray[currentQuestion].source_short;

			if (questionsArray[currentQuestion].bot === true) {
				botLabel.text = "BOT";
				botLabel.fontStyles.color = 0x3DCF8A;
				sourceLabel.fontStyles.color = 0x3DCF8A;
				sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(0xE8FAF1);
			} else {
				botLabel.text = "NOT";
				botLabel.fontStyles.color = 0xE55B50;
				sourceLabel.fontStyles.color = 0xE55B50;
				sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(0xF8D7D5);
			}

		}

	}
}
