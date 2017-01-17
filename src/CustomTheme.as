package
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.themes.StyleNameFunctionTheme;

	import starling.display.Quad;
	import starling.text.TextFormat;

	public class CustomTheme extends StyleNameFunctionTheme
	{

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
			this.getStyleProviderForClass(Button).setFunctionForStyleName("header-button", this.setHeaderButtonStyles);

			this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
			this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
			this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
		}

		//-------------------------
		// Button
		//-------------------------

		private function setHeaderButtonStyles(button:Button):void
		{
			var quad:Quad = new Quad(45, 45, 0xFFFFFF);
			quad.alpha = .3;

			button.downSkin = quad;
			button.height = button.width = 45;
		}

		//-------------------------
		// Header
		//-------------------------

		private function setHeaderStyles(header:Header):void
		{
			var skin:Quad = new Quad(3, 50, 0xFFFFFF);
			header.backgroundSkin = skin;
			header.fontStyles = new TextFormat("_sans", 20, 0x000000, "left");
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