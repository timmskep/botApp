package
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.themes.StyleNameFunctionTheme;

	import starling.display.Quad;
	import starling.text.TextFormat;

	import utils.EmbeddedAssets;

	public class CustomTheme extends StyleNameFunctionTheme
	{
		[Embed(source="assets/fonts/Rubik-Regular.ttf", fontFamily="Rubik", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="false")]
		private static const RUBIK_FONT:Class;

		[Embed(source="assets/fonts/Play-Regular.ttf", fontFamily="Play", fontWeight="normal", fontStyle="normal", mimeType="application/x-font", embedAsCFF="false")]
		private static const PLAY_FONT:Class;

		public function CustomTheme()
		{
			super();
			this.initialize();
		}

		/*
		 The following 3 methods are required to set up a Custom Theme.
		 */
		private function initialize():void
		{
			this.initializeGlobals();
			this.initializeStyleProviders();
		}

		private function initializeGlobals():void
		{
			/*
			 This app uses TextFieldTextRenderer for its HTML text capabilities.
			 */
			FeathersControl.defaultTextRendererFactory = function ():ITextRenderer
			{
				var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				renderer.isHTML = true;
				return renderer;
			}
		}

		/*
		 This method is where all of our custom styles get registered so they can be used in the app.
		 There are 2 types of styles, the default and the custom styles. We separate them for better readibility.
		 */
		private function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).setFunctionForStyleName("back-button", this.setBackButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("header-button", this.setHeaderButtonStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("menu-button", this.setMenuButtonStyles);

			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
		}

		//-------------------------
		// Button
		//-------------------------

		private function setBackButtonStyles(button:Button):void
		{
			var backButtonIcon:ImageLoader = new ImageLoader();
			backButtonIcon.source = "assets/icons/back.png";
			backButtonIcon.height = backButtonIcon.width = 25;
			backButtonIcon.color = 0x000000;

			button.defaultIcon = backButtonIcon;

			var quad:Quad = new Quad(45, 45, 0xFFFFFF);
			quad.alpha = .3;

			button.downSkin = quad;
			button.height = button.width = 45;
		}

		private function setHeaderButtonStyles(button:Button):void
		{
			var quad:Quad = new Quad(45, 45, 0xFFFFFF);
			quad.alpha = .3;

			button.downSkin = quad;
			button.height = button.width = 45;
		}

		private function setMenuButtonStyles(button:Button):void
		{
			var skin:ImageLoader = new ImageLoader();
			skin.source = EmbeddedAssets.menuButtonTexture;
			skin.width = 250;
			skin.height = 60;

			var downSkin:ImageLoader = new ImageLoader();
			downSkin.source = EmbeddedAssets.menuDownButtonTexture;
			downSkin.width = 250;
			downSkin.height = 60;

			button.width = 250;
			button.height = 60;
			button.defaultSkin = skin;
			button.upSkin = skin;
			button.downSkin = downSkin;
			button.fontStyles = new TextFormat("Play", 24, 0x3394DB, "left");
		}

		//-------------------------
		// Header
		//-------------------------

		private function setHeaderStyles(header:Header):void
		{
			var skin:Quad = new Quad(3, 50, 0xFFFFFF);
			header.backgroundSkin = skin;
			header.fontStyles = new TextFormat("Play", 20, 0x3394DB);
			header.gap = 5;
			header.paddingLeft = header.paddingRight = 2;
		}

		//-------------------------
		// Label
		//-------------------------

		private function setLabelStyles(label:Label):void
		{
			label.fontStyles = new TextFormat("_sans", 14, 0xFFFFFFF, "left");
		}

		//-------------------------
		// PanelScreen
		//-------------------------

		private function setPanelScreenStyles(screen:PanelScreen):void
		{
			screen.backgroundSkin = new Quad(3, 3, 0xEEEEEE);
			screen.hasElasticEdges = false;
		}

	}
}