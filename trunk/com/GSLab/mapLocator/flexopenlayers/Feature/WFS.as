/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Feature {
	/**
	 * @class
	 */
	public class WFS extends Feature{

		/**
		 * @constructor
		 *
		 * @param {Layer} layer
		 * @param {XMLNode} xmlNode
		 */
		public function WFS(layer:Layer, xmlNode:XMLNode):void {
			var newArguments = arguments;
			if (arguments.length > 0) {
				var data = this.processXMLNode(xmlNode);
				newArguments = new Array(layer, data.lonlat, data, data.id)
			}
			//TODO OpenLayers.Feature.prototype.initialize.apply(this, newArguments);
			super(newArguments);

			if (arguments.length > 0) {
				this.createMarker();
				this.layer.addMarker(this.marker);
			}
		}

		function function destroy():void {
			if (this.marker != null) {
				this.layer.removeMarker(this.marker);  
			}
			super.destroy(arguments);
			//TODO OpenLayers.Feature.prototype.destroy.apply(this, arguments);
		}

		/**
		 * @param {XMLNode} xmlNode
		 * 
		 * @returns Data Object with 'id', 'lonlat', and private properties set
		 * @type Object
		 */
		public function processXMLNode(xmlNode:XMLNode):Object {
			//this should be overridden by subclasses
			// must return an Object with 'id' and 'lonlat' values set
			var point:XMLNode = xmlNode.getElementsByTagName("Point");
			var text:String  = point[0].textContent;
			var floats:Array = text.split(",");

			return {lonlat: new LonLat(parseFloat(floats[0]),
												  parseFloat(floats[1])),
					id: null};

		}
    
	}
}