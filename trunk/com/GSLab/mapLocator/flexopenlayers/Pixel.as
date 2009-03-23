/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	/**
	* @class This class represents a screen coordinate, in x and y coordinates
	*/
	class Pixel {

		/** @type float **/
		public var x:Number = 0.0;

		/** @type float **/
		public var y:Number = 0.0;

		/**
		* @constructor
		*
		* @param {float} x
		* @param {float} y
		*/
		public function Pixel(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}

		/**
		* @return string representation of Pixel. ex: "x=200.4,y=242.2"
		* @type str
		*/
		public function toString():String {
			return ("x=" + this.x + ",y=" + this.y);
		}

		/**
		* @type Pixel
		*/
		public function copyOf():Pixel {
			return this.clone();
		}

		/**
		* @param {Pixel} px
		*
		* @return whether or not the point passed in as parameter is equal to this
		* 	note that if px passed in is null, returns false
		* @type bool
		*/
		public function equals(px:Pixel) {
			var equals:Boolean = false;
			if (px != null) {
				equals = ((this.x == px.x) && (this.y == px.y));
			}
			return equals;
		}

		/**
		* @param {int} x
		* @param {int} y
		*
		* @return a new Pixel with this pixel's x&y augmented by the
		*         values passed in.
		* @type Pixel
		*/
		public function add(x, y):Pixel {
			return new Pixel(this.x + x, this.y + y);
		}

		/**
		* @param {Pixel} px
		*
		* @return a new Pixel with this pixel's x&y augmented by the
		*         x&y values of the pixel passed in.
		* @type Pixel
		*/
		public function offset(px):Pixel {
			return this.add(px.x, px.y);
		}

	}
}