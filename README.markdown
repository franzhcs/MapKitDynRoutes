# MapKitDynRoutes

iOS4 library to manage dynamic routes on MKMapView.
This library tries to handle the lack of methods to manage growing routes without
repainting all of those anytime.

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

## Thanksgiving
I want to say thanks to Walter 'DaK_TaLeS' for spending few nights talking about how to develop the algorithm used by this library and for supporting (and injuring) me all the time.

## License

This library and the associated demo are licensed under MIT license.
However, if you are using this library and you want to share with me the fact that it suits your needs, please drop me a line. I'll be glad to hear that.

Fabiano aka 'elbryan'
