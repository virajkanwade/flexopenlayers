/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import mx.containers.Canvas;

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

        /** Takes a hash and copies any keys that don't exist from
        *   another hash, by analogy with Object.extend() from
        *   Prototype.js.
        *
        * @param {Object} to
        * @param {Object} from
        *
        * @type Object
        */
        public static function applyDefaults(to:Object, from:Object):Object {
            for (var key:String in from) {
                if (to[key] == null) {
                    to[key] = from[key];
                }
            }
            return to;
        };

        /**
        * @param {Object} params
        *
        * @returns a concatenation of the properties of an object in 
        *    http parameter notation. 
        *    (ex. <i>"key1=value1&key2=value2&key3=value3"</i>)
        * @type String
        */
        public static function getParameterString(params:Object) {
            var paramsArray:Array = new Array();
            
            for (var key:String in params) {
                var value:Object = params[key];
                //skip functions
                if (typeof value == 'function') continue;
            
                paramsArray.push(key + "=" + value);
            }
            
            return paramsArray.join("&");
        };

        /** 
        * @returns The fully formatted image location string
        * @type String
        */
        public function getImagesLocation():String {
            return _getScriptLocation() + "img/";
        };

        // TODO
        /** These could/should be made namespace aware?
        *
        * @param {} p
        * @param {str} tagName
        *
        * @return {Array}
        */
        public static function getNodes(p:Canvas, tagName:String):Array {
            var nodes:Array = Try.these(
                function () {
                    return _getNodes(p.documentElement.childNodes,
                                                    tagName);
                },
                function () {
                    return _getNodes(p.childNodes, tagName);
                }
            );
            return nodes;
        };

        /**
        * @param {Array} nodes
        * @param {str} tagName
        *
        * @return {Array}
        */
        private function _getNodes(nodes:Array, tagName:String):Array {
            var retArray:Array = new Array();
            for (var i:int=0;i<nodes.length;i++) {
                if (nodes[i].nodeName==tagName) {
                    retArray.push(nodes[i]);
                }
            }

            return retArray;
        };

		/**
		* @param {} parent
		* @param {str} item
		* @param {int} index
		*
		* @return {str}
		*/
		public static function getTagText(parent:Object, item:String, index:int):String {
			var result:Array = getNodes(parent, item);
			if (result && (result.length > 0))
			{
				if (!index) {
					index=0;
				}
				if (result[index].childNodes.length > 1) {
					return result.childNodes[1].nodeValue; 
				}
				else if (result[index].childNodes.length == 1) {
					return result[index].firstChild.nodeValue; 
				}
			} else { 
				return ""; 
			}
		};

		public static function rad(x:Number):Number {
			return x*Math.PI/180;
		};

		public static function distVincenty(p1:Pixel, p2:Pixel):Number {
			var a:Number = 6378137, b:Number = 6356752.3142,  f:Number = 1/298.257223563;
			var L:Number = rad(p2.lon - p1.lon);
			var U1:Number = Math.atan((1-f) * Math.tan(rad(p1.lat)));
			var U2:Number = Math.atan((1-f) * Math.tan(rad(p2.lat)));
			var sinU1:Number = Math.sin(U1), cosU1:Number = Math.cos(U1);
			var sinU2:Number = Math.sin(U2), cosU2:Number = Math.cos(U2);
			var lambda:Number = L, lambdaP:Number = 2*Math.PI;
			var iterLimit:int = 20;
			while (Math.abs(lambda-lambdaP) > 1e-12 && --iterLimit>0) {
				var sinLambda:Number = Math.sin(lambda), cosLambda = Math.cos(lambda);
				var sinSigma:Number = Math.sqrt((cosU2*sinLambda) * (cosU2*sinLambda) +
				(cosU1*sinU2-sinU1*cosU2*cosLambda) * (cosU1*sinU2-sinU1*cosU2*cosLambda));
				if (sinSigma==0) return 0;  // co-incident points
				var cosSigma:Number = sinU1*sinU2 + cosU1*cosU2*cosLambda;
				var sigma:Number = Math.atan2(sinSigma, cosSigma);
				var alpha:Number = Math.asin(cosU1 * cosU2 * sinLambda / sinSigma);
				var cosSqAlpha:Number = Math.cos(alpha) * Math.cos(alpha);
				var cos2SigmaM:Number = cosSigma - 2*sinU1*sinU2/cosSqAlpha;
				var C:Number = f/16*cosSqAlpha*(4+f*(4-3*cosSqAlpha));
				lambdaP = lambda;
				lambda = L + (1-C) * f * Math.sin(alpha) *
				(sigma + C*sinSigma*(cos2SigmaM+C*cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)));
			}
			if (iterLimit==0) return NaN  // formula failed to converge
			var uSq:Number = cosSqAlpha * (a*a - b*b) / (b*b);
			var A:Number = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)));
			var B:Number = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)));
			var deltaSigma:Number = B*sinSigma*(cos2SigmaM+B/4*(cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)-
				B/6*cos2SigmaM*(-3+4*sinSigma*sinSigma)*(-3+4*cos2SigmaM*cos2SigmaM)));
			var s:Number = b*A*(sigma-deltaSigma);
			var d:Number = s.toFixed(3)/1000; // round to 1mm precision
			return d;
		};
	}




    /**
    * @param {String} sStart
    * 
    * @returns Whether or not this string starts with the string passed in.
    * @type Boolean
    */
    String.prototype.startsWith = function(sStart:String):Boolean{
        return (this.substr(0,sStart.length) == sStart);
    };

    /** Remove an object from an array. Iterates through the array
    *    to find the item, then removes it.
    *
    * @param {Object} item
    * 
    * @returns A reference to the array
    * @type Array
    */
    Array.prototype.remove = function(item:Object):Array {
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
    Array.prototype.copyOf = function() {
        return this.clone();
    };

    /**
    * @param  {Object} item
    */
    Array.prototype.prepend = function(item) {
        this.splice(0, 0, item);
    };

    /**
    * @param  {Object} item
    */
    Array.prototype.append = function(item:Object):void {
        this.push(item);
    };

    /**
    */
    Array.prototype.clear = function():void {
        this.splice(0, this.length);
    };

// TODO
/**
OpenLayers.Util.modifyDOMElement
OpenLayers.Util.createDiv -> Should map to createCanvas
OpenLayers.Util.createImage
OpenLayers.Util.alphaHack
OpenLayers.Util.modifyAlphaImageDiv
OpenLayers.Util.createAlphaImageDiv
OpenLayers.Util.mouseLeft
**/
}