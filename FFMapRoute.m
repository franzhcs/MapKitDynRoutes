//
//  FFMapRoute.m
//
//  Created by Fabiano Francesconi on 19/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import "FFMapRoute.h"

@interface FFMapRoute ()
- (void) generatePolyline;
@end

@implementation FFMapRoute

- (id) initWithPoints:(NSArray *)newPoints {
	if (self = [super init]) {
		/* Retain an own copy of the segment array */
		self.points = [NSMutableArray arrayWithArray:newPoints];
		
		[self generatePolyline];
	}
	
	return self;
}

- (void) dealloc {
	self.line = nil;
	self.points = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark Public Methods

- (void) updateRouteWithPoints:(NSArray *)newPoints {
	/* Drop the old data */
	if (self.points) {
		self.points = nil;
		self.line = nil;
	}

	/* Generate the new one */
	self.points = [NSMutableArray arrayWithArray:newPoints];
	[self generatePolyline];
}

#pragma mark -
#pragma mark Private Methods

- (void) generatePolyline {
	/* Prepare an array of MKMapPoint in order to prepare the polyline */
	MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * [points count]);
	int idx=0;

	/* Fill mapPoints array with the coordinate converted in MKMapPoint */
	for (NSData *value in points) {
		CLLocationCoordinate2D *coordinate = (CLLocationCoordinate2D *) [value bytes];
		MKMapPoint point = MKMapPointForCoordinate(*coordinate);
		mapPoints[idx] = point;
		idx++;
	}

	/* Generate the polyline */
	MKPolyline *segmentLine = [MKPolyline polylineWithPoints:mapPoints count:[points count]];

	/* Free the array */
	free(mapPoints);

	/* Retain the line. We need it in order to remove this (that's going to be added to the mapView
	 in form of overlay) when aggregation occurs */
	self.line = segmentLine;
}

@end
