/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Tile {

	// @require: Tile.js
	/**
	* @class
	*/
	public class WFS extends Tile {

		/** @type Array(OpenLayers.Feature)*/ 
		public var features:Array;

		/** 
		* @constructor
		*
		* @param {Layer} layer
		* @param {Pixel} position
		* @param {Bounds} bounds
		* @param {String} url
		* @param {Size} size
		*/
		public function WFS(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			super(arguments);
			
			this.features = new Array();
		}

		/**
		 * 
		 */
		private function destroy():void {
			for(var i:int=0; i < this.features.length; i++) {
				this.features[i].destroy();
			}
			super.destroy(arguments);
		}

		/**
		*/
		public function draw():void {
			this.loadFeaturesForRegion(this.requestSuccess);        
		}

		/** get the full request string from the ds and the tile params 
		*     and call the AJAX loadURL(). 
		*
		*     input are function pointers for what to do on success and failure.
		* 
		* @param {function} success
		* @param {function} failure
		*/
		public function loadFeaturesForRegion(success:Function, failure:Function):void {

			if (!this.loaded) {
			
				if (this.url != "") {
			
					// TODO: Hmmm, this stops multiple loads of the data when a 
					//       result isn't immediately retrieved, but it's hacky. 
					//       Do it better.
					this.loaded = true; 
					// TODO OpenLayers.loadURL(this.url, null, this, success, failure);
				}
			}
		}
    
		/** Return from AJAX request
		*
		* @param {} request
		*/
		private function requestSuccess(e:ResultEvent):void {
			var result:Object = e.result;
			
			/* TODO
			var resultFeatures = doc.getElementsByTagName("featureMember");
				
			//clear old featureList
			this.features = new Array();

			for (var i=0; i < resultFeatures.length; i++) {
			
				var feature = new this.layer.featureClass(this.layer, 
														  resultFeatures[i]);
				this.features.append(feature);
			}
			*/
		}

	}
}