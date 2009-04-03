/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import mx.containers.Canvas;
	import mx.controls.Text;

	/**
	* @class
	*/
	public class Popup {
		public static var count:int = 0;
		public static var WIDTH:int = 200;
		public static var HEIGHT:int = 200;
		public static var COLOR:String = "white";
		public static var OPACITY:Number = 1;
		public static var BORDER_SIZE:int = 0;
		
	    /** @type Events*/
	    public var events:Events;
	    
	    /** @type String */
	    public var id:String;
	
	    /** @type LonLat */
	    public var lonlat:LonLat;
	
	    /** @type UIElement */
	    public var canvas:Canvas;
	    
	    /** try to replicate div.innerHTML **/
	    public var canvasInnerHTMLElem:Text;
	
	    /** @type Size*/
	    public var size:Size;    
	
	    /** @type String */
	    public var contentHTML:String;
	    
	    /** @type String */
	    public var backgroundColor:String;
	    
	    /** @type float */
	    public var opacity:Number;
	
	    /** @type int */
	    public var border_size:int;
	
	    /** this gets set in Map.js when the popup is added to the map
	     * @type Map */
	    public var map:Map;


	    /** 
	    * @constructor
	    * 
	    * @param {String} id
	    * @param {LonLat} lonlat
	    * @param {Size} size
	    * @param {String} contentHTML
	    */
	    public function Popup(id:String = null, lonlat:LonLat = null, size:Size = null, contentHTML:String = null) {
	        Popup.count += 1;
	        this.id = (id != null) ? id : "Popup" + Popup.count;
	        this.lonlat = lonlat;
	        this.size = (size != null) ? size : new Size(Popup.WIDTH, Popup.HEIGHT);
	        if (contentHTML != null) { 
	             this.contentHTML = contentHTML;
	        }
	        this.backgroundColor = Popup.COLOR;
	        this.opacity = Popup.OPACITY;
	        this.border_size = Popup.BORDER_SIZE;
	
	        this.canvas = Util.createCanvas(this.id + "_canvas", null, null, null, null, null, "hidden");
	        
	        this.canvasInnerHTMLElem = new Text();
	        
	        this.events = new Events(this, this.canvas, null);
	    }
	
	    /** 
	    */
	    public function destroy():void {
	        if (this.map != null) {
	            this.map.removePopup(this);
	        }
	        this.canvas = null;
	        this.map = null;
	    }

	    /** 
	    * @param {Pixel} px
	    * 
	    * @returns Reference to a canvas that contains the drawn popup
	    * @type UIElement
	    */
	    public function draw(px:Pixel = null):Canvas {
	        if (px == null) {
	            if ((this.lonlat != null) && (this.map != null)) {
	                px = this.map.getLayerPxFromLonLat(this.lonlat);
	            }
	        }
	        
	        this.setSize();
	        this.setBackgroundColor();
	        this.setOpacity();
	        this.setBorder();
	        this.setContentHTML();
	        this.moveTo(px);
	
	        return this.canvas;
	    }
	
	    /** 
	     * if the popup has a lonlat and its map members set, 
	     *  then have it move itself to its proper position
	     */
	    public function updatePosition():void {
	        if ((this.lonlat) && (this.map)) {
	                var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
	                this.moveTo(px);            
	        }
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
	     * @returns Boolean indicating whether or not the popup is visible
	     * @type Boolean
	     */
	    public function visible():Boolean {
	        return this.canvas.visible;
	    }
	
	    /**
	     * 
	     */
	    public function toggle():void {
	        this.canvas.visible = !this.canvas.visible;
	    }
	
	    /**
	     *
	     */
	    public function show():void {
	        this.canvas.visible = true;
	    }
	
	    /**
	     *
	     */
	    public function hide():void {
	        this.canvas.visible = false;
	    }
	
	    /**
	    * @param {Size} size
	    */
	    public function setSize(size:Size = null):void { 
	        if (size != null) {
	            this.size = size; 
	        }
	        
	        if (this.canvas != null) {
	            this.canvas.width = this.size.w;
	            this.canvas.height = this.size.h;
	        }
	    }  
	
	    /**
	    * @param {String} color
	    */
	    public function setBackgroundColor(color:String = null):void { 
	        if (color != null) {
	            this.backgroundColor = color; 
	        }
	        
	        if (this.canvas != null) {
	        	this.canvas.setStyle("backgroundColor", this.backgroundColor);
	        }
	    }
	    
	    /**
	    * @param {float} opacity
	    */
	    public function setOpacity(opacity:Number = -1):void { 
	        if (opacity != -1) {
	            this.opacity = opacity; 
	        }
	        
	        if (this.canvas != null) {
	            // for Mozilla and Safari
	            this.canvas.alpha = this.opacity;
	
	            // for IE
	            // TODO this.div.style.filter = 'alpha(opacity=' + this.opacity*100 + ')';
	        }
	    }
	    
	    /**
	    * @param {int} border
	    */
	    public function setBorder(border_size:int = -1):void { 
	        if (border_size != -1) {
	            this.border_size = border_size;
	        }
	      
	      	// TODO  
	        //if (this.canvas != null) {
	        //    this.canvas.border = this.border;
	        //}
	    }
	    
	    /**
	    * @param {String} contentHTML
	    */
	    public function setContentHTML(contentHTML:String = null):void {
	        if (contentHTML != null) {
	            this.contentHTML = contentHTML;
	        }
	        
	        if (this.canvas != null) {
	            this.canvasInnerHTMLElem.text = this.contentHTML;
	        }    
	    }
	}
}