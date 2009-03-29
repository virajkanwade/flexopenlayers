/* Copyright (c) 2009 Viraj Kanwade., published under the BSD license. */
package com.GSLab.mapLocator.flexopenlayers {

	/*
	 * Class
	 */
	public class Events {
		var BROWSER_EVENTS:Array = [
			"mouseover", "mouseout",
			"mousedown", "mouseup", "mousemove",
			"click", "dblclick",
			"resize", "focus", "blur"
		];

		// hash of Array(Function): events listener functions
		public var listeners:Array;

		// Object: the code object issuing application events
		public var object:Object;

		// UIElement: the UI element receiving browser events
		public var canvas:Canvas;

		// Array: list of support application events
		public var eventTypes:Array;

		/**
		* @param {Map} map
		* @param {UIElement} canvas
		*/
		public function Events(object:Object, canvas:Canvas, eventTypes:Array):void {
			this.listeners  = {};
			this.object     = object;
			this.canvas        = canvas;
			this.eventTypes = eventTypes;
			if (eventTypes) {
				for (var i = 0; i < this.eventTypes.length; i++) {
					// create a listener list for every custom application event
					this.listeners[ this.eventTypes[i] ] = [];
				}
			}
			for (var i = 0; i < this.BROWSER_EVENTS.length; i++) {
				var eventType = this.BROWSER_EVENTS[i];

				// every browser event has a corresponding application event
				// (whether it's listened for or not).
				this.listeners[ eventType ] = [];

				Event.observe(canvas, eventType, this.handleBrowserEvent.bindAsEventListener(this));
			}
			// disable dragstart in IE so that mousedown/move/up works normally
			Event.observe(canvas, "dragstart", Event.stop);
		}

		/**
		* @param {str} type
		* @param {Object} obj
		* @param {Function} func
		*/
		public function register(type:String, obj:Object, func:Function):void {
			if (func == null) {
				obj = this.object;
				func = obj;
			}
			var listeners:Array = this.listeners[type];
			listeners.push( {obj: obj, func: func} );
		}

		public function unregister(type:String, obj:Object, func:Function):void {
			var listeners:Array = this.listeners[type];
			for (var i = 0; i < listeners.length; i++) {
				if (listeners[i].obj == obj && listeners[i].type == type) {
					listeners.splice(i, 1);
					break;
				}
			}
		}

		public function remove(type:String):void {
			this.listeners[type].pop();
		}

		/**
		* @param {event} evt
		*/
		public function handleBrowserEvent(evt:Event):void {
			evt.xy = this.getMousePosition(evt);
			this.triggerEvent(evt.type, evt)
		}

		/**
		* @param {event} evt
		*
		* @return {Pixel}
		*/
		public function getMousePosition(evt:Event):void {
			if (!this.canvas.offsets) {
				this.canvas.offsets = Position.page(this.canvas);
			}
			return new Pixel(
							evt.clientX - this.div.offsets[0],
							evt.clientY - this.div.offsets[1]);
		}

		/**
		* @param {str} type
		* @param {event} evt
		*/
		public static function triggerEvent(type:String, evt:Event) {
			if (evt == null) {
				evt = {};
			}
			evt.object = this.object;
			evt.canvas = this.canvas;

			var listeners = this.listeners[type];
			for (var i:int = 0; i < listeners.length; i++) {
				var callback = listeners[i];
				var continueChain = callback.func.call(callback.obj, evt);
				if (continueChain != null && !continueChain) break;
			}
		}

	}
}