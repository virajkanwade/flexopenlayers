/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import mx.containers.Canvas;
	
	public class Layer {

		/** @type String */
		public var name:String;

		/** @type DOMElement */
		public var canvas:Canvas;

		/** This variable is set in map.addLayer, not within the layer itself
		* @type Map */
		public var map:Map;
    
    public var viewPortLayer:Boolean;

		/**
		 * @constructor
		 *
		 * @param {String} name
		 */
		public function Layer(name:String):void {
			if (arguments.length > 0) {
				this.name = name;
				if (this.canvas == null) {
					this.canvas = Util.createCanvas();
					this.canvas.percentWidth = 100;
					this.canvas.percentHeight = 100;
				}
			}
		}

		/**
		 * Destroy is a destructor: this is to alleviate cyclic references which
		 * the Javascript garbage cleaner can not take care of on its own.
		 */
		public function destroy():void {
			if (this.map != null) {
				this.map.removeLayer(this);
			}
			this.map = null;
		}

		/**
		* @params {Bounds} bound
		* @params {Boolean} zoomChanged tells when zoom has changed, as layers have to do some init work in that case.
		*/
		public function moveTo(bound:Bounds, zoomChanged:Boolean):void {
			// not implemented here
			return;
		}

		/**
		 * @param {Map} map
		 */
		public function setMap(map:Map):void {
			this.map = map;
		}

		/**
		 * @returns Whether or not the layer is a base layer. This should be
		 *          determined individually by all subclasses.
		 * @type Boolean
		 */
		public function isBaseLayer():Boolean {
		   //this function should be implemented by all subclasses.
		   return false;
		}

		/**
		* @returns Whether or not the layer is visible
		* @type Boolean
		*/
		public function getVisibility():Boolean {
			return (this.canvas.visible);
		}

		/**
		* @param {bool} visible
		*/
		public function setVisibility(visible:Boolean):void {
			this.canvas.visible = visible;
			if ((visible) && (this.map != null)) {
				this.moveTo(this.map.getExtent(), false);
			}
		}

	}
}