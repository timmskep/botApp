package
{
	import feathers.controls.BasicButton;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextFormat;

	import utils.RoundedRect;

	public class QuestionRenderer extends LayoutGroupListItemRenderer
	{
		private static const RED:uint = 0xDB3340;
		private static const GREEN:uint = 0x33DB7A;
		private static const BLUE:uint = 0x3394DB;

		private var selectedAnswer:Boolean; //True is Bot, False is Not Bot
		private var questionTextLabel:Label;
		private var botLabel:Label;
		private var sourceGroup:LayoutGroup;
		private var sourceLabel:Label;
		private var grayOVerlay:BasicButton;
		private var botButton:Button;
		private var notbotButton:Button;
		private var infoButton:Button;

		public function QuestionRenderer()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();

			this.width = stage.stageWidth;
			this.height = stage.stageHeight - 50;

			var myLayout:VerticalLayout = new VerticalLayout();
			myLayout.horizontalAlign = HorizontalAlign.CENTER;
			myLayout.gap = 20;

			this.layout = myLayout;
			this.backgroundSkin = new Quad(3, 3, 0xEEEEEE);

			/*
			 Text group block
			 */
			var textGroup:LayoutGroup = new LayoutGroup();
			textGroup.layout = new AnchorLayout();
			textGroup.layoutData = new VerticalLayoutData(90, 100);
			textGroup.backgroundSkin = RoundedRect.createRoundedRect(0xCCCCCC);
			this.addChild(textGroup);

			questionTextLabel = new Label();
			questionTextLabel.layoutData = new AnchorLayoutData(20, 20, 20, 20);
			questionTextLabel.fontStyles = new TextFormat("Rubik", 18, 0x000000);
			questionTextLabel.fontStyles.leading = 7;
			questionTextLabel.wordWrap = true;
			textGroup.addChild(questionTextLabel);

			/*
			 Source text group
			 */
			sourceGroup = new LayoutGroup();
			sourceGroup.layout = new AnchorLayout();
			sourceGroup.layoutData = new VerticalLayoutData(90, NaN);
			sourceGroup.height = 100;
			this.addChild(sourceGroup);

			botLabel = new Label();
			botLabel.fontStyles = new TextFormat("Rubik", 30, 0x000000);
			botLabel.fontStyles.leading = 3;
			botLabel.layoutData = new AnchorLayoutData(10, NaN, NaN, NaN, 0, NaN);
			sourceGroup.addChild(botLabel);

			sourceLabel = new Label();
			sourceLabel.fontStyles = new TextFormat("Rubik", 18, 0x000000);
			sourceLabel.fontStyles.leading = 3;
			sourceLabel.layoutData = new AnchorLayoutData(NaN, 10, 10, 10, 0, NaN);
			sourceLabel.wordWrap = true;
			sourceGroup.addChild(sourceLabel);

			var infoIcon:ImageLoader = new ImageLoader();
			infoIcon.source = "assets/icons/info.png";
			infoIcon.width = infoIcon.height = 30;

			infoButton = new Button();
			infoButton.addEventListener(Event.TRIGGERED, showSourceDetails);
			infoButton.defaultIcon = infoIcon;
			infoButton.layoutData = new AnchorLayoutData(10, 10, NaN, NaN);
			sourceGroup.addChild(infoButton);

			grayOVerlay = new BasicButton();
			grayOVerlay.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			grayOVerlay.defaultSkin = RoundedRect.createRoundedRect(0xCCCCCC);
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

			botButton = new Button();
			botButton.addEventListener(Event.TRIGGERED, function ():void
			{
				selectedAnswer = true;
				revealAnswer();
			});
			botButton.defaultIcon = botIcon;
			bottomGroup.addChild(botButton);

			var nextIcon:ImageLoader = new ImageLoader();
			nextIcon.source = "assets/icons/next.png";
			nextIcon.width = nextIcon.height = 50;

			var nextButton:Button = new Button();
			nextButton.addEventListener(Event.TRIGGERED, function ():void
			{
				var bubblingEvent:Event = new Event("go-next", true, _data);
				dispatchEvent(bubblingEvent);

			});
			nextButton.defaultIcon = nextIcon;
			bottomGroup.addChild(nextButton);

			var notbotIcon:ImageLoader = new ImageLoader();
			notbotIcon.source = "assets/icons/notbot.png";
			notbotIcon.width = notbotIcon.height = 70;

			notbotButton = new Button();
			notbotButton.addEventListener(Event.TRIGGERED, function ():void
			{
				selectedAnswer = false;
				revealAnswer();
			});
			notbotButton.defaultIcon = notbotIcon;
			bottomGroup.addChild(notbotButton);

			var bottomSpacer:LayoutGroup = new LayoutGroup();
			bottomSpacer.width = bottomSpacer.height = 5;
			this.addChild(bottomSpacer);

		}

		private function showSourceDetails(event:Event):void
		{
			questionTextLabel.text = _data.source;
		}

		private function revealAnswer():void
		{
			botButton.isEnabled = false;
			notbotButton.isEnabled = false;

			grayOVerlay.visible = false;
			infoButton.visible = true;

			if (selectedAnswer === _data.bot) {

				botLabel.fontStyles.color = BLUE;
				sourceLabel.fontStyles.color = BLUE;
				sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(BLUE);

				var correctAnswerEvent:Event = new Event("submit-answer", true, {questionId: _data.id, correctAnswer:true});
				dispatchEvent(correctAnswerEvent);

			} else {

				if (_data.bot === true) {
					botLabel.text = "BOT";
					botLabel.fontStyles.color = GREEN;
					sourceLabel.fontStyles.color = GREEN;
					sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(GREEN);
				} else {
					botLabel.text = "NOT";
					botLabel.fontStyles.color = RED;
					sourceLabel.fontStyles.color = RED;
					sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(RED);
				}

				var incorrectAnswerEvent:Event = new Event("submit-answer", true, {questionId: _data.id, correctAnswer:false});
				dispatchEvent(incorrectAnswerEvent);

			}

		}

		override protected function commitData():void
		{
			if (this._data && this._owner) {
				
				botButton.isEnabled = true;
				notbotButton.isEnabled = true;

				/*
				We reset everything to white
				 */
				infoButton.visible = false;
				botLabel.fontStyles.color = 0xFFFFFF;
				sourceLabel.fontStyles.color = 0xFFFFFF;
				sourceGroup.backgroundSkin = RoundedRect.createRoundedRect(0xFFFFFF);
				grayOVerlay.visible = true;
				questionTextLabel.text = '"<i>' + _data.text + '"</i>';
				sourceLabel.text = _data.source_short;

				if (_data.bot === true) {
					botLabel.text = "BOT";
				} else {
					botLabel.text = "NOT";
				}

			} else {

			}

		}

	}
}