# MapKitDynRoutes

iOS4 library to manage dynamic routes on MKMapView.
This library tries to handle the lack of methods to manage growing routes without
repainting all of those anytime.

## Features
FFMapRoute(s) provide two classes that manage a growing route using an algorithm to aggregate points without having the polyline to be redraw/regenerated every time a new point is acquired.
Furthemore, this set of classes, comes with a simulator that injects coordinates using a timer.

## How it works
It works using an incremental way to add segments based on a integer factor.
That value is called kAGGREGATION_FACTOR and its value is set to 3, by default (please, check _kAGGREGATION_FACTOR_ macro in _FFMapRoutes.h_).
In order to explain it better, I'm going to drop you an example.
Let's say the factor is 3 and the tracking begins.
The segment sequence will be:  

A-B, B-C, C-D

-- **aggregation** --
	A-B-C-D
-- **end of aggregation** --

A-B-C-D, D-E, E-F, F-G

-- **aggregation** --
	A-B-C-D, D-E-F-G
-- **end of aggregation** --

A-B-C-D, D-E-F-G, ..

-- **aggregation** --
	...
-- **end of aggregation** --

	A-B-C-D, D-E-F-G, G-H-I-J

-- **aggregation** --
	A-B-C-D-E-F-G-H-I-J
-- **end of aggregation** --

and so on.

## Requirements

* Xcode 3.2.3 with iOS 4 SDK or Xcode 4 Preview.
* Project file (.xcodeproj) needs to:

  1. C/C++ Compiler Version (GCC_VERSION) set to "LLVM compiler 1.5"
  2. Other C Flags (OTHER_CFLAGS) should add "-Xclang -fobjc-nonfragile-abi2" flags. 
  3. Base SDK (SDKROOT) should be "iPhone Device 4.0"
  4. Deployment Target (IPHONEOS_DEPLOYMENT_TARGET) can be "iPhone OS 3.1" if you want.

## Note

<code>-Xclang</code> here means "pass argument to the clang compiler," and the argument is <code>-fobjc-nonfragile-abi2</code>. So you should add '**"-Xclang -fobjc-nonfragile-abi2"**' into $OTHER_CFLAGS as single argument that contains one space in between, and not add them as two arguments like '**-Xclang -fobjc-nonfragile-abi2**'.

For more details, check ["-Xclang -fobjc-nonfragile-abi2" is single flag with one argument][1].

## Thanksgiving
I want to say thanks to Walter 'DaK_TaLeS' for spending few nights talking about how to develop the algorithm used by this library and for supporting (and injuring) me all the time.

## License

This library and the associated demo are licensed under MIT license.
However, if you are using this library and you want to share with me the fact that it suits your needs, please drop me a line. I'll be glad to hear that.

[1]:http://digdog.tumblr.com/post/833744044/xclang-fobjc-nonfragile-abi2-is-single-flag-with 

Fabiano aka 'elbryan'
