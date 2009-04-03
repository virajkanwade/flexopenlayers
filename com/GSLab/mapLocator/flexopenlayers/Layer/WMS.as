/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Layer {

	// @require: OpenLayers/Layer/Grid.js

	/*
	* @class
	*/
	class WMS extends Grid {

		/** @final @type hash */
		public final var DEFAULT_PARAMS:Object = { service: "WMS",
						  version: "1.1.1",
						  request: "GetMap",
						  styles: "",
						  exceptions: "application/vnd.ogc.se_inimage",
						  format: "image/jpeg"
						 };

		/**
		* @constructor
		*
		* @param {str} name
		* @param {str} url
		* @param {hash} params
		*/
		public function WMS(name:String, url:String, params:Object):void {
			var newArguments:Array = new Array();
			if (arguments.length > 0) {
				//uppercase params
				params = Util.upperCaseObject(params);
				newArguments.push(name, url, params);
			}
			super(newArguments);

			if (arguments.length > 0) {
				Util.applyDefaults(
							   this.params,
							   Util.upperCaseObject(this.DEFAULT_PARAMS)
							   );
			}
		}

		/** WFS layer is never a base class.
		 * @type Boolean
		 */
		public function isBaseLayer():Boolean {
			return (this.params.TRANSPARENT != 'true');
		}

		/**
		* @param {String} name
		* @param {hash} params
		*
		* @returns A clone of this Layer.WMS, with the passed-in
		*          parameters merged in.
		* @type Layer.WMS
		*/
		public function clone(name:String, params:Object) {
			var mergedParams = {};
			Object.extend(mergedParams, this.params);
			Object.extend(mergedParams, params);
			var obj = new WMS(name, this.url, mergedParams);
			obj.setTileSize(this.tileSize);
			return obj;
		}

		/**
		* addTile creates a tile, initializes it (via 'draw' in this case), and 
		* adds it to the layer div. 
		*
		* @param {Bounds} bounds
		*
		* @returns The added Tile.FOLImage
		* @type Tile.FOLImage
		*/
		public function addTile(bounds:Bounds, position:Pixel):FOLImage {
			url = this.getFullRequestString(
						 {BBOX:bounds.toBBOX(),
						  WIDTH:this.tileSize.w,
						  HEIGHT:this.tileSize.h});
			
			return new FOLImage(this, position, bounds, 
												 url, this.tileSize);
		}
	}
}