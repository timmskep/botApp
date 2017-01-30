package utils
{
	import starling.textures.Texture;

	public class EmbeddedAssets
	{
		[Embed(source="./../assets/icons/menu.png")]
		private static const menu:Class;
		public static const menuButtonTexture:Texture = Texture.fromEmbeddedAsset(menu);

		[Embed(source="./../assets/icons/menu_down.png")]
		private static const menu_down:Class;
		public static const menuDownButtonTexture:Texture = Texture.fromEmbeddedAsset(menu_down);

	}
}
