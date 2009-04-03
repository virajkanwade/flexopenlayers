/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
    /**
    * @class This class represents a bounding box.
    *        Data stored as left, bottom, right, top floats
    */
    public class Bounds {

        /** @type float */
        public var left:Number = 0.0;

        /** @type float */
        public var bottom:Number = 0.0;

        /** @type float */
        public var right:Number = 0.0;

        /** @type float */
        public var top:Number = 0.0;

        /**
        * @constructor
        *
        * @param {float} left
        * @param {float} bottom
        * @param {float} right
        * @param {float} top
        *
        * OR
        * 
        * @param {String} str Comma-separated bounds string. (ex. <i>"5,42,10,45"</i>)
        *
        * OR
        * 
        * @param {Array} bbox Array of bounds values (ex. <i>[5,42,10,45]</i>)
        *
        * OR
        * 
        * @param {Size} size
        *
        */
        public function Bounds(... arguments) {
            var left:Number;
            var bottom:Number;
            var right:Number;
            var top:Number;
            var bbox:Array;
        	if(arguments.length == 1) {
        		var obj:Object = arguments[0];
        		if(obj is String) {
		            bbox = String(obj).split(",");
		            left = parseFloat(bbox[0]);
                    bottom = parseFloat(bbox[1]);
                    right = parseFloat(bbox[2]);
                    top = parseFloat(bbox[3]);
        		} else if(obj is Array) {
        			bbox = obj as Array; 
		            left = parseFloat(bbox[0]);
		            bottom = parseFloat(bbox[1]);
		            right = parseFloat(bbox[2]);
		            top = parseFloat(bbox[3]);
        		} else if(obj is Size) {
		            left = 0;
		            bottom = obj.h;
		            right = obj.w;
		            top = 0;
        		}
        	} else if(arguments.length == 4) {
        		if(arguments[0] is Number && arguments[1] is Number && arguments[2] is Number && arguments[3] is Number) {
		            left = parseFloat(arguments[0]);
		            bottom = parseFloat(arguments[1]);
		            right = parseFloat(arguments[2]);
		            top = parseFloat(arguments[3]);
        		} else {
        			return;
        		}
        	} else {
        		return;
        	}
            this.left = left;
            this.bottom = bottom;
            this.right = right;
            this.top = top;
        }


        /** Function that builds a new Bounds from a 
        *    parameter string
        * 
        * 
        * @param {String} str Comma-separated bounds string. (ex. <i>"5,42,10,45"</i>)
        *
        * @returns New Bounds object built from the passed-in String.
        * @type Bounds
        */
        public static function fromString(str:String):Bounds {
            var bounds:Array = str.split(",");
            return Bounds.fromArray(bounds);
        }

        /** Function that builds a new Bounds
        *    from an array
        * 
        * @static function
        * 
        * @param {Array} bbox Array of bounds values (ex. <i>[5,42,10,45]</i>)
        *
        * @returns New Bounds object built from the passed-in Array.
        * @type Bounds
        */
        public static function fromArray(bbox:Array):Bounds {
            return new Bounds(parseFloat(bbox[0]),
                                        parseFloat(bbox[1]),
                                        parseFloat(bbox[2]),
                                        parseFloat(bbox[3]));
        }

        /** Static function that builds a new Bounds
        *    from an Size
        * 
        * @constructor
        * 
        * @param {Size} size
        *
        * @returns New Bounds object built with top and left set to 0 and
        *           bottom right taken from the passed-in Size.
        * @type Bounds
        */
        public static function fromSize(size:Size):Bounds {
            return new Bounds(0,
                                        size.h,
                                        size.w,
                                        0);
        }

        /**
        * @returns A fresh copy of the bounds
        * @type Bounds
        */
        public function copyOf():Bounds {
        	return new Bounds(this.left, this.bottom, 
                                     this.right, this.top);

        }

        /**
        * @param {Bounds} bounds
        * @returns Boolean value indicating whether the passed-in Bounds
        *          object has the same left, right, top, bottom components as this
        *           note that if bounds passed in is null, returns false
        *
        * @type bool
        */
        public function equals(bounds:Bounds):Boolean {
            var equals:Boolean = false;
            if (bounds != null) {
                equals = ((this.left == bounds.left) &&
                          (this.right == bounds.right) &&
                          (this.top == bounds.top) &&
                          (this.bottom == bounds.bottom));
            }
            return equals;
        }

        /**
        * @return String representation of Bounds object.
        *         (ex.<i>"left-bottom=(5,42) right-top=(10,45)"</i>)
        * @type String
        */
        public function toString():String {
            return ( "left-bottom=(" + this.left + "," + this.bottom + ")"
                     + " right-top=(" + this.right + "," + this.top + ")" );
        }

        /**
        * @return Simple String representation of Bounds object.
        *         (ex. <i>"5,42,10,45"</i>)
        * @type String
        */
        public function toBBOX():String {
            return (this.left + "," + this.bottom + ","
                    + this.right + "," + this.top);
        }

        /**
        * @returns The width of the bounds
        * @type float
        */
        public function getWidth():Number {
            return (this.right - this.left);
        }

        /**
        * @returns The height of the bounds
        * @type float
        */
        public function getHeight():Number {
            return (this.top - this.bottom);
        }

        /**
        * @returns An Size which represents the size of the box
        * @type Size
        */
        public function getSize():Size {
            return new Size(this.getWidth(), this.getHeight());
        }

        /**
        * @returns An Pixel which represents the center of the bounds
        * @type Pixel
        */
        public function getCenterPixel():Pixel {
            return new Pixel( (this.left + this.right) / 2,
                                         (this.bottom + this.top) / 2);
        }

        /**
        * @returns An LonLat which represents the center of the bounds
        * @type LonLat
        */
        public function getCenterLonLat():LonLat {
            return new LonLat( (this.left + this.right) / 2, (this.bottom + this.top) / 2);
        }

        /**
        * @param {float} x
        * @param {float} y
        *
        * @returns A new Bounds whose coordinates are the same as this,
        *          but shifted by the passed-in x and y values
        * @type Bounds
        */
        public function add(x:Number, y:Number):Bounds {
            return new Bounds(this.left + x, this.bottom + y,
                                      this.right + x, this.top + y);
        }

        /**
        * @param {float} x
        * @param {float} y
        * @param {Boolean} inclusive Whether or not to include the border.
        *                            Default is true
        *
        * @return Whether or not the passed-in coordinates are within this bounds
        * @type Boolean
        */
        public function contains(x:Number, y:Number, inclusive:Boolean = true):Boolean {

            /*
            //set default
            if (inclusive == null) {
                inclusive = true;
            }
            */

            var contains:Boolean = false;
            if (inclusive) {
                contains = ((x >= this.left) && (x <= this.right) &&
                            (y >= this.bottom) && (y <= this.top));
            } else {
                contains = ((x > this.left) && (x < this.right) &&
                            (y > this.bottom) && (y < this.top));
            }
            return contains;
        }

        /**
        * @param {Bounds} bounds
        * @param {Boolean} partial If true, only part of passed-in
        *                          Bounds needs be within this bounds.
        *                          If false, the entire passed-in bounds must be
        *                          within. Default is false
        * @param {Boolean} inclusive Whether or not to include the border.
        *                            Default is true
        *
        * @return Whether or not the passed-in Bounds object is
        *         contained within this bounds.
        * @type Boolean
        */
        public function containsBounds(bounds:Bounds, partial:Boolean = false, inclusive:Boolean = true):Boolean {

            /*
            //set defaults
            if (partial == null) {
                partial = false;
            }
            if (inclusive == null) {
                inclusive = true;
            }
            */

            var inLeft:Boolean;
            var inTop:Boolean;
            var inRight:Boolean;
            var inBottom:Boolean;

            if (inclusive) {
                inLeft = (bounds.left >= this.left) && (bounds.left <= this.right);
                inTop = (bounds.top >= this.bottom) && (bounds.top <= this.top);
                inRight= (bounds.right >= this.left) && (bounds.right <= this.right);
                inBottom = (bounds.bottom >= this.bottom) && (bounds.bottom <= this.top);
            } else {
                inLeft = (bounds.left > this.left) && (bounds.left < this.right);
                inTop = (bounds.top > this.bottom) && (bounds.top < this.top);
                inRight= (bounds.right > this.left) && (bounds.right < this.right);
                inBottom = (bounds.bottom > this.bottom) && (bounds.bottom < this.top);
            }

            return (partial) ? (inTop || inBottom) && (inLeft || inRight )
                             : (inTop && inLeft && inBottom && inRight);
        }

        /**
         * @param {LonLat} lonlat
         *
         * @returns The quadrant ("br" "tr" "tl" "bl") of the bounds in which
         *           the coordinate lies.
         * @type String
         */
        public function determineQuadrant(lonlat:LonLat):String {

            var quadrant:String = "";
            var center:LonLat = this.getCenterLonLat();

            quadrant += (lonlat.lat < center.lat) ? "b" : "t";
            quadrant += (lonlat.lon < center.lon) ? "l" : "r";

            return quadrant;
        }

        /**
         * @param {String} quadrant 
         * 
         * @returns The opposing quadrant ("br" "tr" "tl" "bl"). For Example, if 
         *           you pass in "bl" it returns "tr", if you pass in "br" it 
         *           returns "tl", etc.
         * @type String
         */
        public static function oppositeQuadrant(quadrant:String):String {
            var opp:String = "";
            
            opp += (quadrant.charAt(0) == 't') ? 'b' : 't';
            opp += (quadrant.charAt(1) == 'l') ? 'r' : 'l';
            
            return opp;
        }
    }
}