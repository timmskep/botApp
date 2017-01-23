package screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HomeScreen extends PanelScreen
	{

		private var currentQuestion:Number = 0;
		private var questionsList:List;

		override protected function initialize():void
		{
			super.initialize();

			this.title = "Bot or Not";
			this.layout = new AnchorLayout();

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
			var questionsArray:Array = new Array();

			for (var parent:String in rawData) {
				var tempObject:Object = new Object();
				tempObject.id = parent;

				for (var child:* in rawData[parent]) {
					tempObject[child] = rawData[parent][child];
				}

				questionsArray.push(tempObject);
				tempObject = null;
			}

			var layoutForList:HorizontalLayout = new HorizontalLayout();
			layoutForList.hasVariableItemDimensions = true;

			questionsList = new List();
			questionsList.addEventListener("go-next", showNextQuestion);
			questionsList.addEventListener("submit-answer", logAnswer);
			questionsList.dataProvider = new ListCollection(questionsArray);
			questionsList.layout = layoutForList;
			questionsList.hasElasticEdges = false;
			questionsList.itemRendererType = QuestionRenderer;
			questionsList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			questionsList.snapToPages = true;
			questionsList.horizontalScrollPolicy = questionsList.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this.addChild(questionsList);
		}

		private function showNextQuestion(event:starling.events.Event):void
		{
			currentQuestion++;
			questionsList.scrollToPageIndex(currentQuestion, 0, 1);
		}

		private function logAnswer(event:starling.events.Event):void
		{
			var myObject:Object = new Object();
			myObject.question_id = event.data.questionId;
			myObject.correct_answer = event.data.correctAnswer;
			myObject.user_id = Constants.LOGGED_USER_DATA.user_id;
			myObject.timestamp = new Date().getTime();

			var request:URLRequest = new URLRequest(Constants.FIREBASE_USER_STATS_URL + Constants.LOGGED_USER_DATA.user_id +
					".json" + "?auth=" + Constants.FIREBASE_AUTH_TOKEN);
			request.data = JSON.stringify(myObject);
			request.method = URLRequestMethod.POST;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, answerSent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}

		private function answerSent(event:flash.events.Event):void
		{
			event.currentTarget.removeEventListener(flash.events.Event.COMPLETE, answerSent);
			trace(event.currentTarget.data);
		}

		private function errorHandler(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			trace(event.currentTarget.data);
		}

	}
}