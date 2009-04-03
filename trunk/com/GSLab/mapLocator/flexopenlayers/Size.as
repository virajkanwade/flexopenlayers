/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
    /**
    * @class This class represents a width and height pair
    */
	public class Size {

		/** @type float */
		public var w:Number = 0.0;

		/** @type float */
		public var h:Number = 0.0;


		/**
		* @constructor
		*
		* @param {float} w
		* @param {float} h
		*/
		public function Size(w:Number, h:Number):void {
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
		* @type Size
		*/
		public function copyOf():Size {
	        return new Size(this.w, this.h);
		}

		/**
		* @param {Size} sz
		* @returns Boolean value indicating whether the passed-in Size
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