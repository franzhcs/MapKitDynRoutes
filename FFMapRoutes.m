//
//  FFMapRoute.m
//  iScout
//
//  Created by Fabiano Francesconi on 10/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import "FFMapRoutes.h"

@interface FFMapRoutes ()
- (void) addOverlayToMapViewWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (void) manageOverlaysInMapView;

@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, retain) NSMutableArray *lines;
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
@end

@implementation FFMapRoutes

- (id) init {
	if (self = [super init]) {
		points = [[NSMutableArray alloc] init];
		lines = [[NSMutableArray alloc] init];
		*routes = malloc(class_getInstanceSize([FFMapRoute class]) * kAGGREGATION_FACTOR);
	}
	
	return self;
}

- (void) dealloc {
	[points release];
	[lines release];
	[super dealloc];
}

#pragma mark -

- (void) addCoordinate:(CLLocationCoordinate2D)coordinate {
	/* Wrap the coordinate inside a NSData object */
	NSData *value = [NSData dataWithBytes:&coordinate length:sizeof(CLLocationCoordinate2D)];
	[points addObject:value];
	
	[self addOverlayToMapViewWithCoordinate:coordinate];
}

- (void) addOverlayToMapViewWithCoordinate:(CLLocationCoordinate2D) coordinate {
	/* If we don't have a last coordinate, then wait for a second point */
	if ((lastCoordinate.latitude == 0) && (lastCoordinate.longitude == 0)) {
		lastCoordinate = coordinate;
		return;
	}
	
	/* If we have kAGGREGATION_FACTOR segments, aggregate those */
	if ([lines count] == kAGGREGATION_FACTOR) {
		[self manageOverlaysInMapView];
	} else {
		/* Add the new segment */
		MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * 2);
		mapPoints[0] = MKMapPointForCoordinate(lastCoordinate);
		mapPoints[1] = MKMapPointForCoordinate(coordinate);
	
		/* Generate the polyline */
		MKPolyline *segmentLine = [MKPolyline polylineWithPoints:mapPoints count:2];
	
		/* Add the segment to the mapview overlays */
		[mapView addOverlay:segmentLine];
		[lines addObject:segmentLine];

		free(mapPoints);
	}
	
	lastCoordinate = coordinate;
}

- (void) manageOverlaysInMapView {
	/* Aggregate all the points into a single polyline */
	MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * [points count]);
	int idx = 0;
	
	for (NSData *value in points) {
		CLLocationCoordinate2D *coordinate = (CLLocationCoordinate2D *) [value bytes];
		MKMapPoint point = MKMapPointForCoordinate(*coordinate);
		mapPoints[idx] = point;
		idx++;
	}
	
	/* Generate the new line */
	MKPolyline *segmentLine = [MKPolyline polylineWithPoints:mapPoints count:[points count]];

	/* Discard the old polyline */
	NSMutableArray *discardedLines = [NSMutableArray array];

	for (MKPolyline *line in lines) {
		[discardedLines addObject:line];
		[mapView removeOverlay:line];
		
		printf("Removed an overlay\n");
	}
	
	[lines removeObjectsInArray:discardedLines];
	
	/* Add the new polyline */
	[mapView addOverlay:segmentLine];
	[lines addObject:segmentLine];
	
	free(mapPoints);
}
@end
