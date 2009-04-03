/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Layer {
	import com.GSLab.mapLocator.flexopenlayers.Bounds;
	import com.GSLab.mapLocator.flexopenlayers.Pixel;
	import com.GSLab.mapLocator.flexopenlayers.Tile;
	
	
	// @require: OpenLayers/Layer/Grid.js
	// @require: OpenLayers/Layer/Markers.js
	/**
	* @class
	*/
	public class WFS extends Grid extends Markers {
	    /** @type Object */
	    public var featureClass:Class = WFS;

	    /** @final @type hash */
	    public final var DEFAULT_PARAMS:Object = { service: "WFS",
	                      version: "1.0.0",
	                      request: "GetFeature",
	                      typename: "docpoint"
	                    };

	    /**
	    * @constructor
	    *
	    * @param {str} name
	    * @param {str} url
	    * @param {hash} params
	    * @param {Object} featureClass
	    */
	    public function WFS(name:String, url:String, params:Object, featureClass:Class) {
	        if (featureClass != null) this.featureClass = featureClass;
	        
	        var newArguments:Array = new Array();
	        if (arguments.length > 0) {
	            //uppercase params
	            params = Util.upperCaseObject(params);
	            newArguments.push(name, url, params);
	        }
	        // TODO 
	        //Grid.prototype.initialize.apply(this, newArguments);
	        //Markers.prototype.initialize.apply(this, newArguments);
	    
	        if (arguments.length > 0) {
	            Util.applyDefaults(
	                           this.params, 
	                           Util.upperCaseObject(this.DEFAULT_PARAMS)
	                           );
	        }
	    }
    
	    /**
	     * 
	     */
	    public function destroy():void {
	        Grid.prototype.destroy.apply(this, arguments);
	        Markers.prototype.destroy.apply(this, arguments);
	    }
	    
	    /** 
	    * @param {Bounds} bounds
	    * @param {Boolean} zoomChanged
	    */
	    public function moveTo(bounds:Bounds, zoomChanged:Boolean):void {
	        Grid.prototype.moveTo.apply(this, arguments);
	        Markers.prototype.moveTo.apply(this, arguments);
	    }
	    
	    /** WFS layer is never a base class. 
	     * @type Boolean
	     */
	    public function isBaseLayer():Boolean {
	        return false;
	    }
	    
	    /**
	    * @param {String} name
	    * @param {hash} params
	    *
	    * @returns A clone of this Layer.WMS, with the passed-in
	    *          parameters merged in.
	    * @type Layer.WMS
	    */
	    public function clone(name:String, params:Object):WFS {
	        var mergedParams:Object = new Object();
	        Object.extend(mergedParams, this.params);
	        Object.extend(mergedParams, params);
	        var obj:WFS = new WFS(name, this.url, mergedParams);
	        obj.setTileSize(this.tileSize);
	        return obj;
	    }
	
	    /**
	    * addTile creates a tile, initializes it (via 'draw' in this case), and 
	    * adds it to the layer canvas. 
	    *
	    * @param {Bounds} bounds
	    *
	    * @returns The added Tile.WFS
	    * @type Tile.WFS
	    */
	    public function addTile:function(bounds:Bounds, position:Pixel):Tile.WFS {
	        var url:String = this.getFullRequestString({ BBOX:bounds.toBBOX() });
	
	        return new Tile.WFS(this, position, bounds, url, this.tileSize);
	    }
	}
}