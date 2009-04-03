/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Image;

	/**
	* @class
	*/
	//var Util:Object = new Object();
    public class Util {
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
            var uObject:Object = new Object();
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
        }

        /**
        * @param {Object} params
        *
        * @returns a concatenation of the properties of an object in 
        *    http parameter notation. 
        *    (ex. <i>"key1=value1&key2=value2&key3=value3"</i>)
        * @type String
        */
        public static function getParameterString(params:Object):String {
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
            //TODO return _getScriptLocation() + "img/";
            return "";
        }

        /** These could/should be made namespace aware?
        *
        * @param {} p
        * @param {str} tagName
        *
        * @return {Array}
        */
        public static function getNodes(p:Canvas, tagName:String):Array {
        	/*
            var nodes:Array = [
                function ():Array {
                    return _getNodes(p.getChildren(), tagName);
                },
                function ():Array {
                    return _getNodes(p.getChildren(), tagName);
                }
            ];
            */
            // TODO
            var nodes:Array = [
                function ():Array {
                    return _getNodes(p.getChildren(), tagName);
                }
            ];
            return nodes;
        }

        /**
        * @param {Array} nodes
        * @param {str} tagName
        *
        * @return {Array}
        */
        private static function _getNodes(nodes:Array, tagName:String):Array {
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
		public static function getTagText(parent:Canvas, item:String, index:int):String {
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
			}
			return ""; 
		}

		public static function rad(x:Number):Number {
			return x*Math.PI/180;
		};

		public static function distVincenty(p1:LonLat, p2:LonLat):Number {
			var a:Number = 6378137, b:Number = 6356752.3142,  f:Number = 1/298.257223563;
			var L:Number = rad(p2.lon - p1.lon);
			var U1:Number = Math.atan((1-f) * Math.tan(rad(p1.lat)));
			var U2:Number = Math.atan((1-f) * Math.tan(rad(p2.lat)));
			var sinU1:Number = Math.sin(U1), cosU1:Number = Math.cos(U1);
			var sinU2:Number = Math.sin(U2), cosU2:Number = Math.cos(U2);
			var lambda:Number = L, lambdaP:Number = 2*Math.PI;
			var iterLimit:int = 20;
			while (Math.abs(lambda-lambdaP) > 1e-12 && --iterLimit>0) {
				var sinLambda:Number = Math.sin(lambda), cosLambda:Number = Math.cos(lambda);
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
			var d:Number = Number(s.toFixed(3))/1000; // round to 1mm precision
			return d;
		}

		/**
		 * @param {String} id
		 * @param {Pixel} px
		 * @param {Size} sz
		 * @param {String} position
		 * @param {String} border
		 * @param {String} overflow
		 */
		public static function modifyUIElement(element:*, id:String, px:Pixel, sz:Size, position:String = null, border:String = null, overflow:String = null):void {

			if (id) {
				element.id = id;
			}
			if (px) {
				element.x = px.x;
				element.y = px.y;
			}
			if (sz) {
				element.width = sz.w;
				element.height = sz.h;
			}
			var cnvs:Canvas = new Canvas();
			/* TODO
			if (position) {
				element.style.position = position;
			}
			*/
			/* TODO
			if (border) {
				element.style.border = border;
			}
			*/
			/* TODO
			if (overflow) {
				element.style.overflow = overflow;
			}
			*/
		}

		/** 
		* zIndex is NOT set
		*
		* @param {String} id
		* @param {Pixel} px
		* @param {Size} sz
		* @param {String} imgURL
		* @param {String} position
		* @param {String} border
		* @param {String} overflow
		*
		* @returns A canvas created with the specified attributes.
		* @type UIContainer
		*/
		public static function createCanvas(id:String = null, px:Pixel = null, sz:Size = null, imgURL:String = null, position:String = null, border:String = null, overflow:String = null):Canvas {

			var canvas:Canvas = new Canvas();

			//set specific properties
			//TODO dom.style.padding = "0";
			//TODO dom.style.margin = "0";
			if (imgURL) {
				// TODO canvas.backgroundImage = imgURL;
			}

			//set generic properties
			if (!id) {
				id = "FlexOpenLayersDiv" + (Math.random() * 10000 % 10000);
			}
			/* TODO
			if (!position) {
				position = "absolute";
			}
			*/
			modifyUIElement(canvas, id, px, sz, position, border, overflow);

			return canvas;
		}

		/** 
		* @param {String} id
		* @param {Pixel} px
		* @param {Size} sz
		* @param {String} imgURL
		* @param {String} position
		* @param {String} border
		*
		* @returns A Image element created with the specified attributes.
		* @type Image Element
		*/
		public static function createImage(id:String = "", px:Pixel = null, sz:Size = null, imgURL:String = "", position:String = null, border:String = null):Image {

			var image:Image = new Image();

			//set special properties
			//TODO image.style.alt = id;
			//TODO image.galleryImg = "no";
			if (imgURL) {
				image.source = imgURL;
			}

			//set generic properties
			if (!id) {
				id = "FlexOpenLayersDiv" + (Math.random() * 10000 % 10000);
			}
			/* TODO
			if (!position) {
				position = "relative";
			}
			*/
			modifyUIElement(image, id, px, sz, position, border);
				
			return image;
		};

		/** 
		* @param {Event} evt
		* @param {UIElement} elem
		*
		* @return {boolean}
		*/
		private static function mouseLeft(evt:Event, elem:*):Boolean {
			// start with the element to which the mouse has moved
			//var target:* = (evt.relatedTarget) ? evt.relatedTarget : evt.toElement;
			var target:* = evt.currentTarget;
			// walk up the DOM tree.
			while (target is Canvas && target != null) {
				target = target.parent();
			}
			// if the target we stop at isn't the div, then we've left the div.
			return (!target is Canvas);
		}

		public static function alphaHack():Boolean {
			/*
		    var arVersion = navigator.appVersion.split("MSIE");
		    var version = parseFloat(arVersion[1]);
		    
		    return ( (document.body.filters) && (version >= 5.5) && (version < 7) );
		    */
		    return false;
		}

		/** 
		* @param {UIElement} canvas Canvas containing Alpha-adjusted Image
		* @param {String} id
		* @param {Pixel} px
		* @param {Size} sz
		* @param {String} imgURL
		* @param {String} position
		* @param {String} border
		* @param {String} sizing 'crop', 'scale', or 'image'. Default is "scale"
		*/ 
		public static function modifyAlphaImageCanvas(canvas:Canvas, id:String, px:Pixel, sz:Size, imgURL:String, position:String = null, border:String = null, sizing:String = null):void {
		
		    modifyUIElement(canvas, id, px, sz);
		
		    var img:Image = canvas.getChildren()[0];
		
		    if (imgURL) {
		        img.source = imgURL;
		    }
		    
		    modifyUIElement(img, canvas.id + "_innerImage", null, sz, "relative", border);
		
			/* TODO
		    if (alphaHack()) {
		        div.style.display = "inline-block";
		        if (sizing == null) {
		            sizing = "scale";
		        }
		        div.style.filter = "progid:DXImageTransform.Microsoft" +
		                           ".AlphaImageLoader(src='" + img.src + "', " +
		                           "sizingMethod='" + sizing + "')";
		        img.style.filter = "progid:DXImageTransform.Microsoft" +
		                                ".Alpha(opacity=0)";
		    }
		    */
		};

		/** 
		* @param {String} id
		* @param {Pixel} px
		* @param {Size} sz
		* @param {String} imgURL
		* @param {String} position
		* @param {String} border
		* @param {String} sizing 'crop', 'scale', or 'image'. Default is "scale"
		*
		* @returns A UI Canvas created with a Image inside it. If the hack is 
		*           needed for transparency in IE, it is added.
		* @type UIElement
		*/ 
		public static function createAlphaImageCanvas(id:String, px:Pixel, sz:Size, imgURL:String, position:String, border:String, sizing:String):Canvas {
		    
		    var canvas:Canvas = createCanvas();
		    var img:Image = Util.createImage();
		    canvas.addChild(img);
		
		    modifyAlphaImageCanvas(canvas, id, px, sz, imgURL, position, border, sizing);
		    
		    return canvas;
		}

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
    Array.prototype.copyOf = function():Array {
        return this.clone();
    }

    /**
    * @param  {Object} item
    */
    Array.prototype.prepend = function(item:Object):void {
        this.splice(0, 0, item);
    }

    /**
    * @param  {Object} item
    */
    Array.prototype.append = function(item:Object):void {
        this.push(item);
    }

    /**
    */
    Array.prototype.clear = function():void {
        this.splice(0, this.length);
    };

}