/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */

package {

	/**
	* @class
	*/
	//var Util:Object = new Object();
    class Util {
        /** Creates a new hash and copies over all the keys from the 
        *    passed-in object, but storing them under an uppercased
        *    version of the key at which they were stored.
        * 
        * @param {Object} object
        *
        * @returns A new Object with all the same keys but uppercased
        * @type Object
        */ 
        public static function upperCaseObject(object:Object):Object {
            var uObject = new Object();
            for (var key:String in object) {
                uObject[key.toUpperCase()] = object[key];
            }
            return uObject;
        }

    }

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

    /**
    * @class This class represents a width and height pair
    */
	class Size {

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
			return this.clone();
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

    /**
    * @class This class represents a longitude and latitude pair
    */
    class LonLat {

        /** @type float */
        public var lon:Number = 0.0;

        /** @type float */
        public var lat:Number = 0.0;

        /**
        * @constructor
        *
        * @param {float} lon
        * @param {float} lat
        */
        public function LonLat(lon:Number, lat:Number):void {
            this.lon = lon;
            this.lat = lat;
        }

        /** Alternative constructor that builds a new LonLat from a
        *    parameter string
        *
        * @constructor
        *
        * @param {String} str Comma-separated Lon,Lat coordinate string.
        *                     (ex. <i>"5,40"</i>)
        *
        */
        public function LonLat(str:String):void {
            var pair:Array = str.split(",");
            this.lon = parseFloat(pair[0]);
            this.lat = parseFloat(pair[1]);
        }

        /**
        * @param {String} str Comma-separated Lon,Lat coordinate string.
        *                     (ex. <i>"5,40"</i>)
        *
        * @returns New LonLat object built from the passed-in String.
        * @type LonLat
        */
        public static function fromString(str:String):LonLat {
            var pair:Array = str.split(",");
            return new LonLat(parseFloat(pair[0]),
                                         parseFloat(pair[1]));
        }

        /**
        * @return String representation of LonLat object.
        *         (ex. <i>"lon=5,lat=42"</i>)
        * @type String
        */
        public function toString():String {
            return ("lon=" + this.lon + ",lat=" + this.lat);
        }

        /**
        * @return Shortened String representation of LonLat object.
        *         (ex. <i>"5, 42"</i>)
        * @type String
        */
        public function toShortString():String {
            return (this.lon + ", " + this.lat);
        }

        /**
        * @return New LonLat object with the same lon and lat values
        * @type LonLat
        */
        public function copyOf():LonLat {
            return this.clone();
        }

        /**
        * @param {float} lon
        * @param {float} lat
        *
        * @return A new LonLat object with the lon and lat passed-in
        *         added to this's.
        * @type LonLat
        */
        public function add(lon:Number, lat:Number):LonLat {
            return new LonLat(this.lon + lon, this.lat + lat);
        }

        /**
        * @param {LonLat} ll
        * @returns Boolean value indicating whether the passed-in LonLat
        *          object has the same lon and lat components as this
        *          note that if ll passed in is null, returns false
        *
        * @type bool
        */
        public function equals(ll:LonLat):Boolean {
            var equals:Boolean = false;
            if (ll != null) {
                equals = ((this.lon == ll.lon) && (this.lat == ll.lat));
            }
            return equals;
        }
    }

    /**
    * @class This class represents a bounding box.
    *        Data stored as left, bottom, right, top floats
    */
    class Bounds {

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
        */
        public function Bounds(left:Number, bottom:Number, right:Number, top:Number):Void {
            this.left = left;
            this.bottom = bottom;
            this.right = right;
            this.top = top;
        }

        /** Alternative constructor that builds a new OpenLayers.Bounds from a 
        *    parameter string
        * @constructor
        * 
        * 
        * @param {String} str Comma-separated bounds string. (ex. <i>"5,42,10,45"</i>)
        *
        */
        public function Bounds(str:String):void {
            var bounds = str.split(",");
            OpenLayers.Bounds.fromArray(bounds);
        }

        /** Alternative constructor that builds a new OpenLayers.Bounds
        *    from an array
        * 
        * @constructor
        * 
        * @param {Array} bbox Array of bounds values (ex. <i>[5,42,10,45]</i>)
        *
        */
        public function Bounds(bbox:Array):void {
            this.left = parseFloat(bbox[0]);
            this.bottom = parseFloat(bbox[1]);
            this.right = parseFloat(bbox[2]);
            this.top = parseFloat(bbox[3]);
        }

        /** Alternative constructor that builds a new OpenLayers.Bounds
        *    from an OpenLayers.Size
        * 
        * @constructor
        * 
        * @param {OpenLayers.Size} size
        *
        */
        public function Bounds(size:Size):void {
            this.left = 0;
            this.bottom = size.h;
            this.right = size.w;
            this.top = 0;
        }

        /** Function that builds a new OpenLayers.Bounds from a 
        *    parameter string
        * 
        * 
        * @param {String} str Comma-separated bounds string. (ex. <i>"5,42,10,45"</i>)
        *
        * @returns New OpenLayers.Bounds object built from the passed-in String.
        * @type OpenLayers.Bounds
        */
        public static function fromString(str:String):Bounds {
            var bounds = str.split(",");
            return OpenLayers.Bounds.fromArray(bounds);
        }

        /** Function that builds a new OpenLayers.Bounds
        *    from an array
        * 
        * @static function
        * 
        * @param {Array} bbox Array of bounds values (ex. <i>[5,42,10,45]</i>)
        *
        * @returns New OpenLayers.Bounds object built from the passed-in Array.
        * @type OpenLayers.Bounds
        */
        public static function fromArray(bbox:Array):Bounds {
            return new OpenLayers.Bounds(parseFloat(bbox[0]),
                                        parseFloat(bbox[1]),
                                        parseFloat(bbox[2]),
                                        parseFloat(bbox[3]));
        }

        /** Static function that builds a new OpenLayers.Bounds
        *    from an OpenLayers.Size
        * 
        * @constructor
        * 
        * @param {OpenLayers.Size} size
        *
        * @returns New OpenLayers.Bounds object built with top and left set to 0 and
        *           bottom right taken from the passed-in OpenLayers.Size.
        * @type OpenLayers.Bounds
        */
        public static function fromSize(size:Size):Bounds {
            return new OpenLayers.Bounds(0,
                                        size.h,
                                        size.w,
                                        0);
        }

        /**
        * @returns A fresh copy of the bounds
        * @type OpenLayers.Bounds
        */
        public function copyOf():Bounds {
            return this.clone();
        }

        /**
        * @param {OpenLayers.Bounds} bounds
        * @returns Boolean value indicating whether the passed-in OpenLayers.Bounds
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
        * @return String representation of OpenLayers.Bounds object.
        *         (ex.<i>"left-bottom=(5,42) right-top=(10,45)"</i>)
        * @type String
        */
        public function toString():String {
            return ( "left-bottom=(" + this.left + "," + this.bottom + ")"
                     + " right-top=(" + this.right + "," + this.top + ")" );
        }

        /**
        * @return Simple String representation of OpenLayers.Bounds object.
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
        * @returns An OpenLayers.Size which represents the size of the box
        * @type OpenLayers.Size
        */
        public function getSize():Size {
            return new OpenLayers.Size(this.getWidth(), this.getHeight());
        }

        /**
        * @returns An OpenLayers.Pixel which represents the center of the bounds
        * @type OpenLayers.Pixel
        */
        public function getCenterPixel():Pixel {
            return new OpenLayers.Pixel( (this.left + this.right) / 2,
                                         (this.bottom + this.top) / 2);
        }

        /**
        * @returns An OpenLayers.LonLat which represents the center of the bounds
        * @type OpenLayers.LonLat
        */
        public function getCenterLonLat():LonLat {
            return new OpenLayers.LonLat( (this.left + this.right) / 2,
                                          (this.bottom + this.top) / 2);
        }

        /**
        * @param {float} x
        * @param {float} y
        *
        * @returns A new OpenLayers.Bounds whose coordinates are the same as this,
        *          but shifted by the passed-in x and y values
        * @type OpenLayers.Bounds
        */
        public function add(x:Number, y:Number):Bounds {
            return new OpenLayers.Box(this.left + x, this.bottom + y,
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
        * @param {OpenLayers.Bounds} bounds
        * @param {Boolean} partial If true, only part of passed-in
        *                          OpenLayers.Bounds needs be within this bounds.
        *                          If false, the entire passed-in bounds must be
        *                          within. Default is false
        * @param {Boolean} inclusive Whether or not to include the border.
        *                            Default is true
        *
        * @return Whether or not the passed-in OpenLayers.Bounds object is
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

            var inLeft;
            var inTop;
            var inRight;
            var inBottom;

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
         * @param {OpenLayers.LonLat} lonlat
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

    // Not sure if this can be done.
    class String extends String {
        public function startsWith(sStart:String):Boolean {
            return (this.substr(0,sStart.length) == sStart);
        }
        
    }
    
    // Not sure if this can be done.
    class Array extends Array {
        /** Remove an object from an array. Iterates through the array
        *    to find the item, then removes it.
        *
        * @param {Object} item
        * 
        * @returns A reference to the array
        * @type Array
        */
        public function remove(item:Object):Array {
            for(var i:int=0; i < this.length; i++) {
                if(this[i] == item) {
                    this.splice(i,1);
                    //break;more than once??
                }
            }
            return this;
        }

        /**
        * @returns A fresh copy of the array
        * @type Array
        */
        public function copyOf():Array {
            return this.clone();
        }

        /**
        * @param  {Object} item
        */
        public function prepend(item:Object):void {
            this.splice(0, 0, item);
        }

        /**
        * @param  {Object} item
        */
        public function append(item:Object):void {
            this.push(item);
        }
        
        /**
        *
        */
        public function clear():void {
            this.splice(0, this.length);
        }
    }
    

}