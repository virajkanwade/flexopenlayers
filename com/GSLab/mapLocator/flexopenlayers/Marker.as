/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {

	/**
	* @class
	*/
	public class Marker {
		/** @type Icon */
		public var icon:Marker;

		/** location of object
		* @type LonLat */
		public var lonlat:LonLat;

		/** @type Events*/
		public var events:Events;

		/** @type Map */
		public var map:Map;

		/**
		* @constructor
		*
		* @param {Icon} icon
		* @param {LonLat lonlat
		*/
		public function Marker(lonlat:LonLat, icon:Icon):void {
			this.lonlat = lonlat;
			this.icon = (icon) ? icon : Marker.defaultIcon();

			this.events = new Events(this, this.icon.imageCanvas, null);
		}

		public function destroy():void {
			this.map = null;

			if (this.icon != null) {
				this.icon.destroy();
				this.icon = null;
			}
		}

		/**
		* @param {Pixel} px
		*
		* @return A new Image with this marker´s icon set at the
		*         location passed-in
		* @type UIElement
		*/
		public function draw(px:Pixel):Canvas {
			return this.icon.draw(px);
		}

		/**
		* @param {Pixel} px
		*/
		public function moveTo(px:Pixel):void {
			if ((px != null) && (this.icon != null)) {
				this.icon.moveTo(px);
			}
		}

		/**
		 * @returns Whether or not the marker is currently visible on screen.
		 * @type Boolean
		 */
		public function onScreen():Boolean {

			var onScreen:Boolean = false;
			if (this.map) {
				var screenBounds = this.map.getExtent();
				onScreen = screenBounds.contains(this.lonlat.lon, this.lonlat.lat);
			}
			return onScreen;
		}

		/**
		 * @param {float} inflate
		 */
		public function inflate(inflate:float):void {
			if (this.icon) {
				var newSize = new Size(this.icon.size.w * inflate,
												  this.icon.size.h * inflate);
				this.icon.setSize(newSize);
			}
		}

	}
}