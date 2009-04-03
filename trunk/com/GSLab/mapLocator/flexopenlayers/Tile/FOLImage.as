/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Tile {

	// @require: Tile.js
	/**
	* @class
	*/
	public class FOLImage extends Tile {

		/** @type UIElement image */
		//public var imgCanvas:Canvas;
		public var img:Image;

		/** 
		* @constructor
		*
		* @param {Grid} layer
		* @param {Pixel} position
		* @param {Bounds} bounds
		* @param {String} url
		* @param {Size} size
		*/
		public function FOLImage(layer:Grid, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(arguments);
		}

		public function destroy():void {
			if ((this.img != null) && (this.img.parentNode == this.layer.canvas)) {
				this.layer.canvas.removeChild(this.img);
			}
			this.img = null;
			super.destroy(arguments);
		}

		/**
		*/
		public function draw(transparent:Boolean):void {
			if (false) { // don't actually use the alpha PNG hack right now
						 // it has a fiercely bad effect on IE6's performance
				// if (transparent) {
				this.img = Util.createAlphaImage(null,
															   this.position,
															   this.size,
															   this.url,
															   "absolute");
			} else {
				this.img = Util.createImage(null,
														  this.position,
														  this.size,
														  this.url,
														  "absolute");
			}
			this.layer.canvas.appendChild(this.img);
		}

	}
}