/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Popup {

	// @require: Popup.js

	/**
	* @class
	*/
	public class Anchored extends Popup {
		/** "lr", "ll", "tr", "tl" - relative position of the popup.
		 * @type String */
		public var relativePosition:String;

		/** Object which must have expose a 'size' (Size) and
		 *                                 'offset' (Pixel)
		 * @type Object */
		public var anchor:Object;

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
		public function Anchored(id:String, lonlat:LonLat, size:Size, contentHTML:String, anchor:Object) {
			var newArguments = new Array(id, lonlat, size, contentHTML);

			//TODO Popup.prototype.initialize.apply(this, newArguments);
			super(newArguments);

			this.anchor = (anchor != null) ? anchor
										   : { size: new Size(0,0),
											   offset: new Pixel(0,0)};
		}

		/**
		* @param {Pixel} px
		*
		* @returns Reference to a div that contains the drawn popup
		* @type DOMElement
		*/
		public function draw(px:Pixel):void {
			if (px == null) {
				if ((this.lonlat != null) && (this.map != null)) {
					px = this.map.getLayerPxFromLonLat(this.lonlat);
				}
			}

			//calculate relative position
			this.relativePosition = this.calculateRelativePosition(px);

			//TODO return Popup.prototype.draw.apply(this, arguments);
			return super.draw(arguments);
		}

		/**
		 * @private
		 *
		 * @param {Pixel} px
		 *
		 * @returns The relative position ("br" "tr" "tl" "bl") at which the popup
		 *           should be placed
		 * @type String
		 */
		private function calculateRelativePosition(px:Pixel):String {
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);

			var extent:Extent = this.map.getExtent();
			var quadrant = extent.determineQuadrant(lonlat);

			return Bounds.oppositeQuadrant(quadrant);
		}

		/**
		* @param {Pixel} px
		*/
		public function moveTo(px:Pixel):void {

			var newPx:Pixel = this.calculateNewPx(px);

			var newArguments:Array = new Array(newPx);
			//OpenLayers.Popup.prototype.moveTo.apply(this, newArguments);
			super.apply(newArguments);
		}

		/**
		* @param {Size} size
		*/
		public function setSize(size:Size):void {
			//TODO OpenLayers.Popup.prototype.setSize.apply(this, arguments);
			super.setSize(arguments);

			if ((this.lonlat) && (this.map)) {
				var px = this.map.getLayerPxFromLonLat(this.lonlat);
				this.moveTo(px);
			}
		}

		/**
		 * @private
		 *
		 * @param {Pixel} px
		 *
		 * @returns The the new px position of the popup on the screen
		 *           relative to the passed-in px
		 * @type Pixel
		 */
		public function calculateNewPx(px:Pixel):Pixel {
			var newPx:Pixel = px.offset(this.anchor.offset);

			var top:Boolean = (this.relativePosition.charAt(0) == 't');
			newPx.y += (top) ? -this.size.h : this.anchor.size.h;

			var left:Boolean = (this.relativePosition.charAt(1) == 'l');
			newPx.x += (left) ? -this.size.w : this.anchor.size.w;

			return newPx;
		}

	}
}