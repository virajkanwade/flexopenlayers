/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {
	import mx.containers.Canvas;

	// @require: Util.js
	/**
	* @class
	*
	*
	*/
	class Map {
	    // Hash: base z-indexes for different classes of thing 
	    var Z_INDEX_BASE:Object = { Layer: 100, Popup: 200, Control: 1000 };
	
	    // Array: supported application event types
	    var EVENT_TYPES:Array = new Array( 
	        "addlayer", "removelayer", "movestart", "move", "moveend",
	        "zoomend", "layerchanged", "popupopen", "popupclose",
	        "addmarker", "removemarker", "clearmarkers", "mouseover",
	        "mouseout", "mousemove", "dragstart", "drag", "dragend"
	    );
	
	    // int: zoom levels, used to draw zoom dragging control and limit zooming
	    var maxZoomLevel:int = 16;
	
	    // Bounds
	    var maxExtent:Bounds = new Bounds(-180, -90, 180, 90);
	
	    /* projection */
	    var projection:String = "EPSG:4326";
	
	    /** @type Size */
	    var size:Size = null;
	
	    // float
	    var maxResolution:Number = 1.40625; // degrees per pixel 
	                                        // Default is whole world in 256 pixels, from GMaps
	
	    
	    // The canvas that our map lives in
	    var canvas:Canvas;
	
	    // The map's view port             
	    var viewPortCanvas:Canvas;
	
	    // The map's layer container
	    var layerContainerCanvas:Canvas;
	
	    // Array(Layer): ordered list of layers in the map
	    var layers:Array;
	
	    // Array(Control)
	    var controls:Array;
	
	    // Array(Popup)
	    var popups:Array;
	
	    // LonLat
	    var center:LonLat;
	
	    // int
	    var zoom:int;
	
	    // Events
	    var events:Array;
	
	    // Pixel
	    var mouseDragStart:Pixel;
		
	    /** @type Layer */
	    var baseLayer:Layer;
	
	    public function Map(cnvs:Canvas, options:Object) {
	        Object.extend(this, options);
	
	        this.canvas = cnvs;
	
	        // the viewPortCanvas is the outermost canvas we modify
	        var id:String = cnvs.id + "_FlexOpenLayers_ViewPort";
	        this.viewPortCanvas = createCanvas(id, null, null, null,
	                                                     "relative", null,
	                                                     "hidden");
	        this.viewPortCanvas.percentWidth = 100;
	        this.viewPortCanvas.percentHeight = 100;
	        this.canvas.addChild(this.viewPortCanvas);
	
	        // the layerContainerCanvas is the one that holds all the layers
	        id = cnvs.id + "_FlexOpenLayers_Container";
	        this.layerContainerCanvas = createCanvas(id);
	        this.viewPortCanvas.appendChild(this.layerContainerCanvas);
	
	        // TODO this.events = new Events(this, div, this.EVENT_TYPES);
	
	        this.updateSize();
	        // make the entire maxExtent fix in zoom level 0 by default
	        if (this.maxResolution == null || this.maxResolution == "auto") {
	            this.maxResolution = Math.max(
	                this.maxExtent.getWidth()  / this.size.w,
	                this.maxExtent.getHeight() / this.size.h );
	        }
	        // update the internal size register whenever the div is resized
	        // TODO this.events.register("resize", this, this.updateSize);
	
	        this.layers = [];
	        
	        if (!this.controls) {
	            this.controls = [];
	            this.addControl(new Control.MouseDefaults());
	            this.addControl(new Control.PanZoom());
	        }
	
	        this.popups = new Array();
	
	        // always call map.destroy()
	        // TODO Event.observe(window, 'unload', this.destroy.bindAsEventListener(this));
	    }
	
	    private function destroy():void {
	        if (this.layers != null) {
	            for(var i=0; i< this.layers.length; i++) {
	                this.layers[i].destroy();
	            } 
	            this.layers = null;
	        }
	        if (this.controls != null) {
	            for(var i=0; i< this.controls.length; i++) {
	                this.controls[i].destroy();
	            } 
	            this.controls = null;
	        }
	    }
	
	    /**
	    * @param {Layer} layer
	    */    
	    public function addLayer(layer:Layer):void {
	        layer.setMap(this);
	        // TODO layer.div.style.overflow = "";
	        // TODO layer.div.style.zIndex = this.Z_INDEX_BASE['Layer'] + this.layers.length;
	
	        if (layer.viewPortLayer) {
	            this.viewPortCanvas.appendChild(layer.canvas);
	        } else {
	            this.layerContainerCanvas.appendChild(layer.canvas);
	        }
	        this.layers.push(layer);
	
	        // hack hack hack - until we add a more robust layer switcher,
	        //   which is able to determine which layers are base layers and 
	        //   which are not (and put baselayers in a radiobutton group and 
	        //   other layers in checkboxes) this seems to be the most straight-
	        //   forward way of dealing with this. 
	        //
	        if (layer.isBaseLayer()) {
	            this.baseLayer = layer;
	        }
	        // TODO this.events.triggerEvent("addlayer");
	    }
	
	    /** Removes a layer from the map by removing its visual element (the 
	     *   layer.canvas property), then removing it from the map's internal list 
	     *   of layers, setting the layer's map property to null. 
	     * 
	     *   a "removelayer" event is triggered.
	     * 
	     *   very worthy of mention is that simply removing a layer from a map
	     *   will not cause the removal of any popups which may have been created
	     *   by the layer. this is due to the fact that it was decided at some
	     *   point that popups would not belong to layers. thus there is no way 
	     *   for us to know here to which layer the popup belongs.
	     *    
	     *     A simple solution to this is simply to call destroy() on the layer.
	     *     the default Layer class's destroy() function
	     *     automatically takes care to remove itself from whatever map it has
	     *     been attached to. 
	     * 
	     *     The correct solution is for the layer itself to register an 
	     *     event-handler on "removelayer" and when it is called, if it 
	     *     recognizes itself as the layer being removed, then it cycles through
	     *     its own personal list of popups, removing them from the map.
	     * 
	     * @param {Layer} layer
	     */
	    public function removeLayer(layer:Layer):void {
	        this.layerContainerCanvas.removeChild(layer.canvas);
	        this.layers.remove(layer);
	        layer.map = null;
	        // TODO this.events.triggerEvent("removelayer");
	    }
	
	    /**
	    * @param {Array(Layer)} layers
	    */    
	    public function addLayers(layers:Array):void {
	        for (var i:int = 0; i <  layers.length; i++) {
	            this.addLayer(layers[i]);
	        }
	    }
		
	    /**
	    * @param {Control} control
	    * @param {Pixel} px
	    */    
	    public function addControl(control:Control, px:Pixel) {
	        control.map = this;
	        this.controls.push(control);
	        var cnvs:Canvas = control.draw(px);
	        if (cnvs) {
	            // TODO div.style.zIndex = this.Z_INDEX_BASE['Control'] + this.controls.length;
	            this.viewPortDiv.appendChild(cnvs);
	        }
	    }
	
	    /** 
	    * @param {Popup} popup
	    */
	    public function addPopup(popup:Popup) {
	        popup.map = this;
	        this.popups.push(popup);
	        var popupCanvas = popup.draw();
	        if (popupCanvas) {
	            // TODO popupDiv.style.zIndex = this.Z_INDEX_BASE['Popup'] + this.popups.length;
	            this.layerContainerCanvas.appendChild(popupCanvas);
	        }
	    }
	    
	    /** 
	    * @param {Popup} popup
	    */
	    public function removePopup(popup:Popup):void {
	        this.popups.remove(popup);
	        if (popup.canvas) {
	            this.layerContainerCanvas.removeChild(popup.canvas);
	        }
	        popup.map = null;
	    }
	        
	    /**
	    * @return {float}
	    */
	    public function getResolution():Number {
	        // return degrees per pixel
	        return this.maxResolution / Math.pow(2, this.zoom);
	    }
	
	    /**
	    * @return {int}
	    */
	    public function getZoom():int {
	        return this.zoom;
	    }
	
	    /**
	    * @returns {Size}
	    */
	    public function getSize():Size {
	        return this.size;
	    }
	
	    /**
	    * @private
	    */
	    private function updateSize():void {
	        this.size = new Size(this.canvas.clientWidth, this.canvas.clientHeight);
	        this.events.canvas.offsets = null;
	        // Workaround for the fact that hidden elements return 0 for size.
	        if (this.size.w == 0 && this.size.h == 0) {
	            var dim = Element.getDimensions(this.canvas);
	            this.size.w = dim.width;
	            this.size.h = dim.height;
	        }
	        if (this.size.w == 0 && this.size.h == 0) {
	            this.size.w = parseInt(this.canvas.style.width);
	            this.size.h = parseInt(this.canvas.style.height);
	    	}
	    }
	
	    /**
	    * @return {LonLat}
	    */
	    public function getCenter():LonLat {
	        return this.center;
	    }
	
	    /**
	    * @return {Bounds}
	    */
	    public function getExtent():Bounds {
	        if (this.center) {
	            var res:Number = this.getResolution();
	            var size:Size = this.getSize();
	            var w_deg:Number = size.w * res;
	            var h_deg:Number = size.h * res;
	            return new Bounds(
	                this.center.lon - w_deg / 2, 
	                this.center.lat - h_deg / 2,
	                this.center.lon + w_deg / 2,
	                this.center.lat + h_deg / 2);
	        } else {
	            return null;
	        }
	    }
	
	    /**
	    * @return {Bounds}
	    */
	    public function getFullExtent():Bounds {
	        return this.maxExtent;
	    }
	    
	    public function getZoomLevels():int {
	        return this.maxZoomLevel;
	    }
	
	    /**
	    * @param {Bounds} bounds
	    *
	    * @return {int}
	    */
	    public function getZoomForExtent(bounds:Bounds):int {
	        var size:Size = this.getSize();
	        var width:Number = bounds.getWidth();
	        var height:Number = bounds.getHeight();
	        var deg_per_pixel:Number = (width > height ? width / size.w : height / size.h);
	        var zoom:Number = Math.log(this.maxResolution / deg_per_pixel) / Math.log(2);
	        return Math.floor(Math.min(Math.max(zoom, 0), this.getZoomLevels())); 
	    }
	    
	    /**
	     * @param {Pixel} layerPx
	     * 
	     * @returns px translated into view port pixel coordinates
	     * @type Pixel
	     * @private
	     */
	    private function getViewPortPxFromLayerPx(layerPx:Pixel):Pixel {
	        var viewPortPx:Pixel = layerPx.copyOf();
	
	        viewPortPx.x += parseInt(this.layerContainerDiv.style.left);
	        viewPortPx.y += parseInt(this.layerContainerDiv.style.top);
	
	        return viewPortPx;
	    }
	    
	    /**
	     * @param {Pixel} viewPortPx
	     * 
	     * @returns px translated into view port pixel coordinates
	     * @type Pixel
	     * @private
	     */
	    private function getLayerPxFromViewPortPx(viewPortPx:Pixel):Pixel {
	        var layerPx:Pixel = viewPortPx.copyOf();
	
	        layerPx.x -= parseInt(this.layerContainerDiv.style.left);
	        layerPx.y -= parseInt(this.layerContainerDiv.style.top);
	
	        return layerPx;
	    }
	
	    /**
	    * @param {Pixel} px
	    *
	    * @return {LonLat} 
	    */
	    public function getLonLatFromLayerPx(px:Pixel):LonLat {
	       //adjust for displacement of layerContainerDiv
	       var px:Pixel = this.getViewPortPxFromLayerPx(px);
	       return this.getLonLatFromViewPortPx(px);         
	    }
	    
	    /**
	    * @param {Pixel} viewPortPx
	    *
	    * @returns An LonLat which is the passed-in view port
	    *          Pixel, translated into lon/lat given the 
	    *          current extent and resolution
	    * @type LonLat
	    * @private
	    */
	    private function getLonLatFromViewPortPx(viewPortPx:Pixel):LonLat {
	        var center:LonLat = this.getCenter();        //map center lon/lat
	        var res:Number  = this.getResolution();
	        var size:Size = this.getSize();
	    
	        var delta_x:Number = viewPortPx.x - (size.w / 2);
	        var delta_y:Number = viewPortPx.y - (size.h / 2);
	        
	        return new LonLat(center.lon + delta_x * res ,
	                                     center.lat - delta_y * res); 
	    }
	
	    // getLonLatFromPixel is a convenience function for the API
	    /**
	    * @param {Pixel} pixel
	    *
	    * @returns An LonLat corresponding to the given
	    *          Pixel, translated into lon/lat using the 
	    *          current extent and resolution
	    * @type LonLat
	    */
	    public function getLonLatFromPixel(px:Pixel):LonLat {
			return this.getLonLatFromViewPortPx(px);
	    }
	
	    /**
	    * @param {LonLat} lonlat
	    *
	    * @returns An Pixel which is the passed-in LonLat, 
	    *          translated into layer pixels given the current extent 
	    *          and resolution
	    * @type Pixel
	    */
	    public function getLayerPxFromLonLat(lonlat:LonLat):Pixel {
	       //adjust for displacement of layerContainerDiv
	       var px:Pixel = this.getViewPortPxFromLonLat(lonlat);
	       return this.getLayerPxFromViewPortPx(px);         
	    }
	
	    /**
	    * @param {LonLat} lonlat
	    *
	    * @returns An Pixel which is the passed-in LonLat, 
	    *          translated into view port pixels given the current extent 
	    *          and resolution
	    * @type Pixel
	    * @private
	    */
	    private function getViewPortPxFromLonLat(lonlat:LonLat):Pixel {
	        var resolution:Number = this.getResolution();
	        var extent:Extent = this.getExtent();
	        return new Pixel(
	                       Math.round(1/resolution * (lonlat.lon - extent.left)),
	                       Math.round(1/resolution * (extent.top - lonlat.lat))
	                       );    
	    }
	
	    // getLonLatFromPixel is a convenience function for the API
	    /**
	    * @param {LonLat} lonlat
	    *
	    * @returns An Pixel corresponding to the LonLat
	    *          translated into view port pixels using the current extent 
	    *          and resolution
	    * @type Pixel
	    */
	    public function getPixelFromLonLat(lonlat:LonLat):Pixel {
			return this.getViewPortPxFromLonLat(lonlat);
	    }
	
	    /**
	    * @param {LonLat} lonlat
	    * @param {int} zoom
	    */
	    public function setCenter(lonlat:LonLat, zoom:int, minor:Boolean):void {
	        if (this.center) { // otherwise there's nothing to move yet
	            this.moveLayerContainer(lonlat);
	        }
	        this.center = lonlat.copyOf();
	        var zoomChanged:int = null;
	        if (zoom != null && zoom != this.zoom 
	            && zoom >= 0 && zoom <= this.getZoomLevels()) {
	            zoomChanged = (this.zoom == null ? 0 : this.zoom);
	            this.zoom = zoom;
	        }
	
	        if (!minor) this.events.triggerEvent("movestart");
	        this.moveToNewExtent(zoomChanged, minor);
	        if (!minor) this.events.triggerEvent("moveend");
	    }
	    
	    /**
	     * ZOOM TO BOUNDS FUNCTION
	     * @private
	     */
	    private function moveToNewExtent(zoomChanged:Boolean, minor:Boolean) {
	        if (zoomChanged != null) { // reset the layerContainerDiv's location
	            this.layerContainerCanvas.left = "0";
	            this.layerContainerCanvas.top  = "0";
	
	            //redraw popups
	            for (var i:int = 0; i < this.popups.length; i++) {
	                this.popups[i].updatePosition();
	            }
	
	        }
	        var bounds:Bounds = this.getExtent();
	        for (var i:int = 0; i < this.layers.length; i++) {
	            this.layers[i].moveTo(bounds, (zoomChanged != null), minor);
	        }
	        this.events.triggerEvent("move");
	        if (zoomChanged != null)
	            this.events.triggerEvent("zoomend", 
	                {oldZoom: zoomChanged, newZoom: this.zoom});
	    }
	
	    /**
	     * zoomIn
	     * Increase zoom level by one.
	     * @param {int} zoom
	     */
	    public function zoomIn():void {
	        if (this.zoom != null && this.zoom <= this.getZoomLevels()) {
	            this.zoomTo( this.zoom += 1 );
	        }
	    }
	    
	    /**
	     * zoomTo
	     * Set Zoom To int
	     * @param {int} zoom
	     */
	    public function zoomTo(zoom:int) {
	       if (zoom >= 0 && zoom <= this.getZoomLevels()) {
	            var oldZoom:int = this.zoom;
	            this.zoom = zoom;
	            this.moveToNewExtent(oldZoom);
	       }
	    }
	
	    /**
	     * zoomOut
	     * Decrease zoom level by one.
	     * @param {int} zoom
	     */
	    public function zoomOut():void {
	        if (this.zoom != null && this.zoom > 0) {
	            this.zoomTo( this.zoom - 1 );
	        }
	    }
	    
	    /**
	     * zoomToFullExtent
	     * Zoom to the full extent and recenter.
	     */
	    public function zoomToFullExtent():void {
	        var fullExtent:Bounds = this.getFullExtent();
	        this.setCenter(
	          new LonLat((fullExtent.left+fullExtent.right)/2,
	                                (fullExtent.bottom+fullExtent.top)/2),
	          this.getZoomForExtent(fullExtent)
	        );
	    }
	
	    /**
	    * @param {LonLat} lonlat
	    * @private
	    */
	    private function moveLayerContainer(lonlat:LonLat) {
	        var container:Canvas = this.layerContainerCanvas;
	        var resolution:Number = this.getResolution();
	
	        var deltaX:Number = Math.round((this.center.lon - lonlat.lon) / resolution);
	        var deltaY:Number = Math.round((this.center.lat - lonlat.lat) / resolution);
	     
	        var offsetLeft:int = parseInt(container.left);
	        var offsetTop:int  = parseInt(container.top);
	
	        container.left = (offsetLeft + deltaX);
	        container.top  = (offsetTop  - deltaY);
	    }
	
}
}