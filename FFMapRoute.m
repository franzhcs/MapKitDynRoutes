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
		points = [[NSMutableArray alloc] initWithArray:segment];
		
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
		
		self.line = segmentLine;
	}
	
	return self;
}

- (void) dealloc {
	[line release];
	[points release];

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
