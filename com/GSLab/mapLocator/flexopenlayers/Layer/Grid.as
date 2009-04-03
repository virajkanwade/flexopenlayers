/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers.Layer {

	// @require: OpenLayers/Layer.js
	// @require: OpenLayers/Util.js
	/*
	 * @Class
	 */
	public class Grid extends Layer {
		public static TILE_WIDTH:int = 256;
		public static TILE_HEIGHT:int = 256;

		// str: url
		public var url:String;

		// hash: params
		public var params:Object;

		// tileSize: OpenLayers.Size
		public var tileSize:Size;

		// grid: Array(Array())
		// this is an array of rows, each row is an array of tiles
		public var grid:Array;

		/**
		* @constructor
		*
		* @param {str} name
		* @param {str} url
		* @param {hash} params
		*/
		public function Grid(name:String, url:String, params:Object):void {
			var newArguments:Arguments = arguments;
			if (arguments.length > 0) {
				newArguments = [name];
			}
			super(newArguments);
			this.url = url;
			this.params = params;
			this.tileSize = new Size(TILE_WIDTH,
										TILE_HEIGHT);
		}

		/**
		 *
		 */
		private function destroy():void {
			this.params = null;
			this.clearGrid();
			this.grid = null;
			super.destroy(arguments);
		}

		public function setTileSize(size:Size):void {
			this.tileSize = size.copyOf();
		}

		/**
		 * moveTo
		 * moveTo is a function called whenever the map is moved. All the moving
		 * of actual 'tiles' is done by the map, but moveTo's role is to accept
		 * a bounds and make sure the data that that bounds requires is pre-loaded.
		 * @param {Bounds}
		 */
		public function moveTo(bounds:bounds, zoomChanged:Boolean):void {
			if (!this.getVisibility()) {
				if (zoomChanged) {
					this.grid = null;
				}
				return;
			}
			if (!this.grid || zoomChanged) {
				this._initTiles();
			} else {
				var i = 0;
				while (this.getGridBounds().bottom > bounds.bottom) {
				   this.insertRow(false);
				}
				while (this.getGridBounds().left > bounds.left) {
				   this.insertColumn(true);
				}
				while (this.getGridBounds().top < bounds.top) {
				   this.insertRow(true);
				}
				while (this.getGridBounds().right < bounds.right) {
				   this.insertColumn(false);
				}
			}
		}

		public function getGridBounds():Bounds {
			var topLeftTile:Tile = this.grid[0][0];
			var bottomRightTile:Tile = this.grid[this.grid.length-1][this.grid[0].length-1];
			return new Bounds(topLeftTile.bounds.left,
									 bottomRightTile.bounds.bottom,
									 bottomRightTile.bounds.right,
									 topLeftTile.bounds.top);
		}

		/**
		*/
		private function _initTiles():void {

			//first of all, clear out the main div
			//this.div.innerHTML = "";
			this.canvas.textHTML = "";

			//now clear out the old grid and start a new one
			this.clearGrid();
			this.grid = new Array();

			var viewSize:Size = this.map.getSize();
			var bounds:Bounds = this.map.getExtent();
			var extent:Bounds = this.map.getFullExtent();
			var resolution:Number = this.map.getResolution();
			var tilelon:Number = resolution*this.tileSize.w;
			var tilelat:Number = resolution*this.tileSize.h;

			var offsetlon:Number = bounds.left - extent.left;
			var tilecol:Number = Math.floor(offsetlon/tilelon);
			var tilecolremain:Number = offsetlon/tilelon - tilecol;
			var tileoffsetx:Number = -tilecolremain * this.tileSize.w;
			var tileoffsetlon:Number = extent.left + tilecol * tilelon;

			var offsetlat:Number = bounds.top - (extent.bottom + tilelat);
			var tilerow:Number = Math.ceil(offsetlat/tilelat);
			var tilerowremain:Number = tilerow - offsetlat/tilelat;
			var tileoffsety:Number = -tilerowremain * this.tileSize.h;
			var tileoffsetlat:Number = extent.bottom + tilerow * tilelat;

			tileoffsetx = Math.round(tileoffsetx); // heaven help us
			tileoffsety = Math.round(tileoffsety);

			this.origin = new Pixel(tileoffsetx,tileoffsety);

			var startX:Number = tileoffsetx;
			var startLon:Number = tileoffsetlon;

			do {
				var row:Array = new Array();
				this.grid.append(row);
				tileoffsetlon = startLon;
				tileoffsetx = startX;
				do {
					var tileBounds:Bounds = new Bounds(tileoffsetlon,
														   tileoffsetlat,
														   tileoffsetlon+tilelon,
														   tileoffsetlat+tilelat);

					var tile:Tile = this.addTile(tileBounds,
											new Pixel(tileoffsetx - parseInt(this.map.layerContainerCanvas.x),
															 tileoffsety - parseInt(this.map.layerContainerCanvas.y))
															);
					tile.draw((this.params.TRANSPARENT == 'true'));
					row.append(tile);

					tileoffsetlon += tilelon;
					tileoffsetx += this.tileSize.w;
				} while (tileoffsetlon < bounds.right)

				tileoffsetlat -= tilelat;
				tileoffsety += this.tileSize.h;
			} while(tileoffsetlat > bounds.bottom - tilelat)

		}

		/**
		* @param {bool} prepend - if true, prepend to beginning.
		*                         if false, then append to end
		*/
		public function insertRow(prepend:Boolean):void {
			var modelRowIndex:int = (prepend) ? 0 : (this.grid.length - 1);
			var modelRow:Array = this.grid[modelRowIndex];

			var newRow:Array = new Array();

			var resolution:Number = this.map.getResolution();
			var deltaY:Number = (prepend) ? -this.tileSize.h : this.tileSize.h;
			var deltaLat:Number = resolution * -deltaY;

			for (var i:int=0; i < modelRow.length; i++) {
				var modelTile:Tile = modelRow[i];
				var bounds:Bounds = modelTile.bounds.copyOf();
				var position:Pixel = modelTile.position.copyOf();
				bounds.bottom = bounds.bottom + deltaLat;
				bounds.top = bounds.top + deltaLat;
				position.y = position.y + deltaY;
				var newTile:Tile = this.addTile(bounds, position);
				newTile.draw((this.params.TRANSPARENT == 'true'));
				newRow.append(newTile);
			}

			if (newRow.length>0){
				if (prepend) {
					this.grid.prepend(newRow);
				} else {
					this.grid.append(newRow);
				}
			}
		}

		/**
		* @param {bool} prepend - if true, prepend to beginning.
		*                         if false, then append to end
		*/
		public function insertColumn(prepend:Boolean):void {
			var modelCellIndex:int;
			var deltaX:Number = (prepend) ? -this.tileSize.w : this.tileSize.w;
			var resolution:Number = this.map.getResolution();
			var deltaLon:Number = resolution * deltaX;

			for (var i:int=0; i<this.grid.length; i++) {
				var row:Array = this.grid[i];
				modelTileIndex = (prepend) ? 0 : (row.length - 1);
				var modelTile:Tile = row[modelTileIndex];

				var bounds:Bounds = modelTile.bounds.copyOf();
				var position:Pixel = modelTile.position.copyOf();
				bounds.left = bounds.left + deltaLon;
				bounds.right = bounds.right + deltaLon;
				position.x = position.x + deltaX;
				var newTile:Tile = this.addTile(bounds, position);
				newTile.draw((this.params.TRANSPARENT == 'true'));

				if (prepend) {
					row = row.prepend(newTile);
				} else {
					row = row.append(newTile);
				}
			}
		}

		/** combine the ds's serverPath with its params and the tile's params.
		*
		*    does checking on the serverPath variable, allowing for cases when it
		*     is supplied with trailing ? or &, as well as cases where not.
		*
		*    return in formatted string like this:
		*        "server?key1=value1&key2=value2&key3=value3"
		*
		* @return {str}
		*/
		public function getFullRequestString(params:Object):String {
			var requestString:String = "";
			this.params.SRS = this.map.projection;
			// concat tile params with layer params and convert to string
			var allParams:Object = Object.extend(this.params, params);
			var paramsString:String = Util.getParameterString(allParams);

			var server:String = this.url;
			var lastServerChar:String = server.charAt(server.length - 1);

			if ((lastServerChar == "&") || (lastServerChar == "?")) {
				requestString = server + paramsString;
			} else {
				if (server.indexOf('?') == -1) {
					//serverPath has no ? -- add one
					requestString = server + '?' + paramsString;
				} else {
					//serverPath contains ?, so must already have paramsString at the end
					requestString = server + '&' + paramsString;
				}
			}
			return requestString;
		}

		/** go through and remove all tiles from the grid, calling
		*    destroy() on each of them to kill circular references
		*
		* @private
		*/
		private function clearGrid():void {
			if (this.grid) {
				while(this.grid.length > 0) {
					var row:Array = this.grid[0];
					while(row.length > 0) {
						var tile:Tile = row[0];
						tile.destroy();
						row.remove(tile);
					}
					this.grid.remove(row);
				}
			}
		}

		/**
		* addTile gives subclasses of Grid the opportunity to create an
		* Tile of their choosing. The implementer should initialize
		* the new tile and take whatever steps necessary to display it.
		*
		* @param {Bounds} bounds
		*
		* @returns The added Tile
		* @type Tile
		*/
		public function addTile(bounds:Bounds, position:Pixel):Tile {
			// Should be implemented by subclasses
		}

	}
}