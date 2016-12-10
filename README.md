## fuse-orientation

### What?
Library to get the device orientation in [Fuse](http://www.fusetools.com/). Currently supports iOS only.

### Why?
Because sometimes you want the device's orientation even if the orientation is locked.

## Installation

1. Clone this repo
2. Add a reference to the local `fuse-orientation.unoproj` in your project's .unoproj file, e.g.

```
"Projects": [
  "../fuse-orientation/fuse-orientation.unoproj",
],
```

## Usage:

1. In the root of your app, subscribe to orientation updates:
```
var orientation = require("OrientationChangeListener");
orientation.subscribe();
```

2. Elsewhere, you can listen to the event:
```
var listener = require("OrientationChangeListener");
listener.on("orientationChanged", function(val) {
  // val will be one of "portrait_up", "portrait_down", "landscape_left", or "landscape_right"
});
```
