/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
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
		* OR
	    * @param {String} str Comma-separated Lon,Lat coordinate string.
        *                     (ex. <i>"5,40"</i>)
         */
        public function LonLat():void {
        	var lon:Number;
        	var lat:Number;
        	if(arguments.length == 0) {
        		return;
        	} else if(arguments.length == 1 && arguments[0] is String) {
        		var str:String = arguments[0];
	            var pair:Array = str.split(",");
	            lon = parseFloat(pair[0]);
	            lat = parseFloat(pair[1]);
        	} else if(arguments.length == 2 && arguments[0] is Number && arguments[1] is Number) {
        		lon = arguments[0];
        		lat = arguments[1];
        	}
            this.lon = lon;
            this.lat = lat;
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
}