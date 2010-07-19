//
//  FFMapRoute.m
//
//  Created by Fabiano Francesconi on 19/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import "FFMapRoute.h"

@interface FFMapRoute ()
@end

@implementation FFMapRoute

- (id) initWithSegment:(NSArray *)segment {
	if (self = [super init]) {
		NSMutableArray *newpoints = [[NSMutableArray alloc] initWithArray:segment];
		self.points = newpoints;
		[newpoints release];
		
		MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * [points count]);
		int idx=0;

		for (NSData *value in points) {
			CLLocationCoordinate2D *coordinate = (CLLocationCoordinate2D *) [value bytes];
			MKMapPoint point = MKMapPointForCoordinate(*coordinate);
			mapPoints[idx] = point;
			idx++;
		}
		
		/* Generate the new line */
		MKPolyline *segmentLine = [MKPolyline polylineWithPoints:mapPoints count:[points count]];
		
		free(mapPoints);
		
		self.line = segmentLine;
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

- (void) addPointsFromArray:(NSArray *)newPoints {
	[points addObjectsFromArray:newPoints];
}

- (void) addPoint:(CLLocationCoordinate2D) coordinate {
	NSData *newPoint = [NSData dataWithBytes:&coordinate length:sizeof(CLLocationCoordinate2D)];
	[points addObject:newPoint];
}

@end
