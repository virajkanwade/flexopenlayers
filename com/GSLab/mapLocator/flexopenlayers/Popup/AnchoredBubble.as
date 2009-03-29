/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Popup {

	// @require: Popup/Anchored.js

	/**
	* @class
	*/
	public class AnchoredBubble extends Anchored {

		//Border space for the rico corners
		public static CORNER_SIZE = 5;

		/**
		* @constructor
		*
		* @param {String} id
		* @param {LonLat} lonlat
		* @param {Size} size
		* @param {String} contentHTML
		* @param {Object} anchor  Object which must expose a
		*                         - 'size' (Size) and
		*                         - 'offset' (Pixel)
		*                         (this is generally an Icon)
		*/
		public function AnchoredBubble(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object) {
			//TODO Popup.Anchored.prototype.initialize.apply(this, arguments);
			super(arguments);
		}

		/**
		* @param {Pixel} px
		*
		* @returns Reference to a div that contains the drawn popup
		* @type UIElement
		*/
		public function draw(px:Pixel):Canvas {

			//TODO Popup.Anchored.prototype.draw.apply(this, arguments);
			super.draw(arguments);

			// make the content Div
			var contentSize:Size = this.size.copyOf();
			contentSize.h -= (2 * CORNER_SIZE);

			var id:String = this.canvas.id + "-contentDiv";
			this.contentCanvas = Util.createCanvas(id, null, contentSize,
														null, "relative", null,
														"hidden");
			this.canvas.appendChild(this.contentCanvas);
			this.setContentHTML();

			//TODO this.setRicoCorners(true);

			//set the popup color and opacity
			this.setBackgroundColor();
			this.setOpacity();

			return this.canvas;
		}

		/**
		* @param {Size} size
		*/
		public function setSize(size:Size):void {
			//TODO Popup.Anchored.prototype.setSize.apply(this, arguments);
			super.setSize(arguments);

			if (this.contentDiv != null) {

				var contentSize:Size = this.size.copyOf();
				contentSize.h -= (2 * CORNER_SIZE);

				this.contentCanvas.height = contentSize.h;

				//size has changed - must redo corners
				//TODO this.setRicoCorners(false);
			}
		}

		/**
		 * @param {String} color
		 */
		public function setBackgroundColor(color:String):void {
			if (color != undefined) {
				this.backgroundColor = color;
			}

			if (this.canvas != null) {
				if (this.contentCanvas != null) {
					//this.canvas.background = "transparent";
					this.canvas.alpha = 0;
					//TODO Rico.Corner.changeColor(this.contentCanvas, this.backgroundColor);
				}
			}
		}

		/**
		 * @param {float} opacity
		 */
		public function setOpacity(opacity:Number):void {
			if (opacity != undefined) {
				this.opacity = opacity;
			}

			if (this.canvas != null) {
				if (this.contentCanvas != null) {
					//Rico.Corner.changeOpacity(this.contentCanvas, this.opacity);
					this.contentCanvas.alpha = opacity;
				}
			}
		}

		/** Bubble Popups can not have a border
		 *
		 * @param {int} border
		 */
		public function setBorder(border:int):void {
			this.border = 0;
		}

		/**
		 * @param {String} contentHTML
		 */
		public function setContentHTML(contentHTML:String):void {
			if (contentHTML != null) {
				this.contentHTML = contentHTML;
			}

			if (this.contentCanvas != null) {
				this.contentCanvas.innerHTML = this.contentHTML;
			}
		}

		/**
		 * @private
		 *
		 * @param {Boolean} firstTime Is this the first time the corners are being
		 *                             rounded?
		 *
		 * update the rico corners according to the popup's
		 * current relative postion
		 */
		private function setRicoCorners(firstTime:Boolean):void {
			/**
			var corners:String = this.getCornersToRound(this.relativePosition);
			var options:Object = {corners: corners,
							 color: this.backgroundColor,
						   bgColor: "transparent",
							 blend: false};

			if (firstTime) {
				Rico.Corner.round(this.canvas, options);
			} else {
				Rico.Corner.reRound(this.contentCanvas, options);
				//set the popup color and opacity
				this.setBackgroundColor();
				this.setOpacity();
			}
			**/
		}

		/** 
		 * @private
		 * 
		 * @returns The proper corners string ("tr tl bl br") for rico
		 *           to round
		 * @type String
		 */
		private function getCornersToRound():String {

			var corners:Array = ['tl', 'tr', 'bl', 'br'];

			//we want to round all the corners _except_ the opposite one. 
			var corner = Bounds.oppositeQuadrant(this.relativePosition);
			corners.remove(corner);

			return corners.join(" ");
		}

	}
}