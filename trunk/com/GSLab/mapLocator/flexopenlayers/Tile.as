/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {

	/*
	 * Tile
	 *
	 * @class This is a class designed to designate a single tile, however
	 * it is explicitly designed to do relatively little. Tiles store information
	 * about themselves -- such as the URL that they are related to, and their
	 * size - but do not add themselves to the layer canvas automatically, for
	 * example.
	 */
	public class Tile {

		/** @type Layer */
		public var layer:Layer;

		/** @type String url of the request */
		public var url:String;

		/** @type Bounds */
		public var bounds:Bounds;

		/** @type Size */
		public var size:Size;

		/** Top Left pixel of the tile
		* @type Pixel */
		public var position:Pixel;

		/**
		* @constructor
		*
		* @param {Layer} layer
		* @param {Pixel} position
		* @param {Bounds} bounds
		* @param {String} url
		* @param {Size} size
		*/
		public function Tile(layer:Layer, position:Pixel, bounds:Bounds, url:String, size:Size):void {
			if (arguments.length > 0) {
				this.layer = layer;
				this.position = position;
				this.bounds = bounds;
				this.url = url;
				this.size = size;
			}
		}

		/** nullify references to prevent circular references and memory leaks
		*/
		public function destroy():void {
			this.layer  = null;
			this.bounds = null;
			this.size = null;
		}

		/**
		*/
		public function draw():void {

		// HACK HACK - should we make it a standard to put this sort of warning
		//             message in functions that are supposed to be overridden?
		//
		//        Log.warn(this.CLASS_NAME + ": draw() not implemented");

		}

		/** remove this tile from the ds
		*/
		public function remove():void {
		}

		/**
		* @type Pixel
		*/
		public function getPosition():Pixel {
			return this.position;
		}

	}
}