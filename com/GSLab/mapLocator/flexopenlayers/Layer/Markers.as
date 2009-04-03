/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Layer {
	import com.GSLab.mapLocator.flexopenlayers.Layer;
	import com.GSLab.mapLocator.flexopenlayers.Marker;
	

	// @require: Layer.js
	/**
	* @class
	*/
	public class Markers extends Layer {
	    /** internal marker list
	    * @type Array(Marker) */
	    public var markers:Array;
    
	    /**
	    * @constructor
	    *
	    * @param {String} name
	    */
	    public function Markers(name):void {
	        super(arguments);
	        this.markers = new Array();
	    }
	    
	    /**
	     * 
	     */
	    public function destroy():void {
	        this.clearMarkers();
	        markers = null;
	        super.destroy(arguments);
	    }

	    /** 
	    * @param {Bounds} bounds
	    * @param {Boolean} zoomChanged
	    */
	    public function moveTo(bounds:Bounds, zoomChanged:Boolean):void {
	        if (zoomChanged) {
	            this.redraw();
	        }
	    }
    
	    /** WFS layer is never a base class. 
	     * @type Boolean
	     */
	    public function isBaseLayer():Boolean {
	        return false;
	    }
    
	    /**
	    * @param {Marker} marker
	    */
	    public function addMarker(marker:Marker):void {
	        this.markers.append(marker);
	        if (this.map && this.map.getExtent()) {
	            marker.map = this.map;
	            this.drawMarker(marker);
	        }
	    }

	    /**
	     * @param {Marker} marker
	     */
	    public function removeMarker(marker:Marker):void {
	        this.markers.remove(marker);
	        if ((marker.icon != null) && (marker.icon.imageCanvas != null) &&
	            (marker.icon.imageCanvas.parentNode == this.canvas) ) {
	            this.canvas.removeChild(marker.icon.imageCanvas);    
	        }
	    }

	    /**
	     * 
	     */
	    public function clearMarkers():void {
	        if (this.markers != null) {
	            while(this.markers.length > 0) {
	                this.removeMarker(this.markers[0]);
	            }
	        }
	    }
	
	    /** clear all the marker div's from the layer and then redraw all of them.
	    *    Use the map to recalculate new placement of markers.
	    */
	    public function redraw():void {
	        for(var i:int=0; i < this.markers.length; i++) {
	            this.drawMarker(this.markers[i]);
	        }
	    }
	
	    /** Calculate the pixel location for the marker, create it, and 
	    *    add it to the layer's div
	    * 
	    * @private 
	    * 
	    * @param {OpenLayers.Marker} marker
	    */
	    private function drawMarker(marker:Marker):void {
	        var px:Pixel = this.map.getLayerPxFromLonLat(marker.lonlat);
	        var markerImg:Canvas = marker.draw(px);
	        if (!marker.drawn) {
	            this.canvas.addChild(markerImg);
	            marker.drawn = true;
	        }
	    }
    
	}
}