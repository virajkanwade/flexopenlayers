/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import mx.containers.Canvas;
	
	class Control {
		/** this gets set in the addControl() function in Map
		* @type Map */
		public var map:Map;

		/** @type DOMElement */
		public var canvas:Canvas;

		/** @type Pixel */
		public var position:Pixel;

		/**
		* @constructor
		*/
		public function Control(options:Object):void {
			Object.extend(this, options);
		}

		/**
		* @param {Pixel} px
		*
		* @returns A reference to the canvas containing the control
		* @type DOMElement
		*/
		public function draw(px:Pixel):Canvas {
			if (this.canvas == null) {
				this.canvas = Util.createCanvas();
			}
			if (px != null) {
				this.position = px.copyOf();
			}
			this.moveTo(this.position);
			return this.canvas;
		}

		/**
		* @param {Pixel} px
		*/
		public function moveTo(px:Pixel):void {
			if ((px != null) && (this.canvas != null)) {
				this.canvas.x = px.x;
				this.canvas.y = px.y;
			}
		}

		/**
		*/
		public function destroy():void {
			// eliminate circular references
			this.map = null;
		}

	}
}