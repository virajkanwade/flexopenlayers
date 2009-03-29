/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {

	/**
	* @class
	*/
	public class Icon {

		/** image url
		* @type String */
		public var url:String;

		/** @type Size */
		public var size:Size;

		/** distance in pixels to offset the image when being rendered
		* @type Pixel */
		public var offset:Pixel;

		/** Function to calculate the offset (based on the size)
		 * @type Pixel */
		public var calculateOffset:Pixel;

		/** @type UIElement */
		public var imageCanvas:Canvas

		/** @type Pixel */
		public var px:Pixel

		/**
		* @constructor
		*
		* @param {String} url
		* @param {Size} size
		* @param {Function} calculateOffset
		*/
		public function Icon(url:String, size:Size, offset:Pixel, calculateOffset:Function):void {
			this.url = url;
			this.size = (size) ? size : new Size(20,20);
			this.offset = (offset) ? offset : new Pixel(0,0);
			this.calculateOffset = calculateOffset;

			// TODO
			this.imageCanvas = Util.createAlphaImageCanvas();
		}

		public function destroy():void {
			this.imageCanvas = null;
		}

		/**
		 * @param {OpenLayers.Size} size
		 */
		public function setSize(size:Size):void {
			if (size != null) {
				this.size = size;
			}
			this.draw();
		}

		/** 
		* @param {Pixel} px
		* 
		* @return A new Image of this icon set at the location passed-in
		* @type UIElement
		*/
		public function draw(px:Pixel):Canvas {
			Util.modifyAlphaImageCanvas(this.imageCanvas, 
										null, 
										null, 
										this.size, 
										this.url, 
										"absolute");
			this.moveTo(px);
			return this.imageCanvas;
		}

		/**
		* @param {OpenLayers.Pixel} px
		*/
		public function moveTo(px:Pixel):void {
			//if no px passed in, use stored location
			if (px != null) {
				this.px = px;
			}

			if ((this.px != null) && (this.imageCanvas != null)) {
				if (this.calculateOffset) {
					this.offset = this.calculateOffset(this.size);  
				}
				var offsetPx = this.px.offset(this.offset);
				Util.modifyAlphaImageCanvas(this.imageCanvas, null, offsetPx);
			}
		},
    
	}
}