/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */

package {

	/**
	* @class
	*/
	var Util:Object = new Object();

	/**
	* @class This class represents a screen coordinate, in x and y coordinates
	*/
	class Pixel {

		/** @type float **/
		var x:Number = 0.0;

		/** @type float **/
		var y:Number = 0.0;

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
		* @param {OpenLayers.Pixel} px
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

	class Size {
		
		/** @type float */
		var w:Number = 0.0;

		/** @type float */
		var h:Number = 0.0;


		/**
		* @constructor
		*
		* @param {float} w
		* @param {float} h
		*/
		public function initialize(w:Number, h:Number):void {
			this.w = w;
			this.h = h;
		}

		/**
		* @return String representation of Size object.
		*         (ex. <i>"w=55,h=66"</i>)
		* @type String
		*/
		public function toString():String {
			return ("w=" + this.w + ",h=" + this.h);
		}

		/**
		* @return New Size object with the same w and h values
		* @type OpenLayers.Size
		*/
		public function copyOf():Size {
			return this.clone();
		}

		/**
		* @param {OpenLayers.Size} sz
		* @returns Boolean value indicating whether the passed-in OpenLayers.Size
		*          object has the same w and h components as this
		*          note that if sz passed in is null, returns false
		*
		* @type bool
		*/
		public function equals(sz:Size):Boolean {
			var equals:Boolean = false;
			if (sz != null) {
				equals = ((this.w == sz.w) && (this.h == sz.h));
			}
			return equals;
		}
	}

}
