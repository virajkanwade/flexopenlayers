/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {

	/*
	 * @class
	 */
	class Feature {
	
		/** @type Events */
		public var events:Events;

		/** @type Layer */
		public var layer:Layer;

		/** @type String */
		public var id:String;
		
		/** @type LonLat */
		public var lonlat:LonLat;

		/** @type Object */
		public var data:Object;

		/** @type Marker */
		public var marker:Marker;

		/** @type Popup */
		public var popup:Popup;

		/** 
		 * @constructor
		 * 
		 * @param {OpenLayers.Layer} layer
		 * @param {String} id
		 * @param {OpenLayers.LonLat} lonlat
		 * @param {Object} data
		 */
		public function Feature(layer:Layer, lonlat:LonLat, data:Object, id:String):void {
			this.layer = layer;
			this.lonlat = lonlat;
			this.data = (data != null) ? data : new Object();
			this.id = (id ? id : 'f' + Math.random());
		}

		/**
		 * 
		 */
		public function destroy():void {

			//remove the popup from the map
			if ((this.layer != null) && (this.layer.map != null)) {
				if (this.popup != null) {
					this.layer.map.removePopup(this.popup);
				}
			}

			this.events = null;
			this.layer = null;
			this.id = null;
			this.lonlat = null;
			this.data = null;
			if (this.marker != null) {
				this.marker.destroy();
				this.marker = null;
			}
			if (this.popup != null) {
				this.popup.destroy();
				this.popup = null;
			}
		}
    
		/**
		 * @returns A Marker Object created from the 'lonlat' and 'icon' properties
		 *          set in this.data. If no 'lonlat' is set, returns null. If no
		 *          'icon' is set, Marker() will load the default image
		 * @type Marker
		 */
		public function createMarker():Marker {

			// TODO - why is this?
			var marker = null;
			
			if (this.lonlat != null) {
				this.marker = new Marker(this.lonlat, this.data.icon);
			}
			return this.marker;
		}

		/**
		 * 
		 */
		public function createPopup():Popup {

			if (this.lonlat != null) {
				
				var id:String = this.id + "_popup";
				var anchor = (this.marker) ? this.marker.icon : null;

				this.popup = new Popup.AnchoredBubble(id, 
														this.lonlat,
														this.data.popupSize,
														this.data.popupContentHTML,
														anchor); 
			}        
			return this.popup;
		}

	}
}