# Multitaction / TUIO for Haxe #

This library provides support for TUIO communication with Multitaction
screen hardware.

# TUIO #
The `org.tuio` package contains a Haxe port of the [tuio-as3](https://github.com/lagerkoller/tuio-as3) library.
This is based on the DatagramSocket class, which there is a node.js polyfill for, meaning that this library only currently supports the `js` and `swf` targets.

# Multitaction #
The Multitaction layer sits on top of the tuio layer and processes the incoming data.
This includes a middleware stack for applying filters and transforms to the incoming data.