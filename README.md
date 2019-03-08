# Multitaction / TUIO for Haxe #

This library provides support for TUIO communication with Multitaction
screen hardware.

# DatagramSocket #
The TUIO layer is built on top of the AS3 DatagramSocket API.
A polyfill has been build for this to add js support.
So currently this library only works on the `js` and `swf` targets.

# TUIO #
The `org.tuio` package contains a Haxe port of the [tuio-as3](https://github.com/lagerkoller/tuio-as3) library.
This works on top of the DatagramSocket and interprets incoming UDP packets as Touches / Markers / Pens.

# Multitaction #
The Multitaction layer sits on top of the tuio layer and processes the incoming data.
This includes a middleware stack for applying filters and transforms to the incoming data.

# Robotlegs #
The Multitaction layer is currently tightly integrated with Robotlegs (Pull Requests welcome).