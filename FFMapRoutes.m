//
//  FFMapRoute.m
//
//  Created by Fabiano Francesconi on 10/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import "FFMapRoutes.h"

@interface FFMapRoutes ()
- (void) addCoordinate:(CLLocationCoordinate2D)coordinate toArray:(NSMutableArray *)array;
- (void) aggregateRoutes;
- (void) aggregatePoints:(NSArray *)points toArray:(NSMutableArray *)array;
- (void) checkAggregationIsNeeded;

BOOL areCoordinateEqual(CLLocationCoordinate2D *aCoordinate, CLLocationCoordinate2D *bCoordinate);
@end

@implementation FFMapRoutes

- (id) init {
	if (self = [super init]) {
		routes = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[routes release];
	[super dealloc];
}

#pragma mark -
#pragma mark Public Methods

- (void) addCoordinate:(CLLocationCoordinate2D) coordinate {
	/* If we don't have a last coordinate, then wait for a second point */
	if ((lastCoordinate.latitude == 0) && (lastCoordinate.longitude == 0)) {
		lastCoordinate = coordinate;
		return;
	}

	NSMutableArray *lastroutes = [routes lastObject];
	
	/* If the last object does not exist means that the routes array is empty.
	 So create the first array */
	if (!lastroutes) {
		NSMutableArray *newroutes = [[NSMutableArray alloc] initWithCapacity:kAGGREGATION_FACTOR];
		[self addCoordinate:coordinate toArray:newroutes];

		[routes addObject:newroutes];
		
		[newroutes release];
	}
	/* Otherwisely, we need to check the level of the last array */
	else {
		/* Extract the existing route */
		FFMapRoute *route = [lastroutes lastObject];

		/* If the level is the minor one, than we are good */
		if (route.level == 1)
			[self addCoordinate:coordinate toArray:lastroutes];

		/* Otherwisely, we have to create a bogus element for all the missing levels */
		else {
			int currentLevel = route.level;
			for (int i=(currentLevel - 1); i>=1; i--) {
				NSMutableArray *placeholder = [[NSMutableArray alloc] initWithCapacity:kAGGREGATION_FACTOR];
				FFMapRoute *route = [[FFMapRoute alloc] init];
				route.level = i;
				[placeholder addObject:route];
				[routes addObject:placeholder];
				
				[route release];
				[placeholder release];
			}
			[self addCoordinate:coordinate];
		}
	}

	lastCoordinate = coordinate;

	[self checkAggregationIsNeeded];
}

#pragma mark -
#pragma mark Private Methods

BOOL areCoordinateEqual(CLLocationCoordinate2D *aCoordinate, CLLocationCoordinate2D *bCoordinate) {
	if ((aCoordinate->latitude == bCoordinate->latitude) &&
		(aCoordinate->longitude == bCoordinate->longitude))
		return TRUE;
	return FALSE;
}

- (void) addCoordinate:(CLLocationCoordinate2D)coordinate toArray:(NSMutableArray *)array {
	FFMapRoute *route;
	
	/* Wrap the new segment into a small array and add it to the newroutes array */
	NSMutableArray *segment = [[NSMutableArray alloc] initWithCapacity:2];
	NSData *aPoint = [NSData dataWithBytes:&lastCoordinate length:sizeof(CLLocationCoordinate2D)];
	NSData *bPoint = [NSData dataWithBytes:&coordinate length:sizeof(CLLocationCoordinate2D)];
	
	[segment addObject:aPoint];
	[segment addObject:bPoint];
	
	
	/* Check if we are in a bogus/placeholder situation */
	route = [array lastObject];
	
	/* if the polyline doesn't exist, then we have an empty class. Remove it and keep with the job. */
	if (route && (route.line == nil)) {
		[array removeLastObject];
		route = nil;
	}
	
	/* Otherwisely we have to create it */
	route = [[FFMapRoute alloc] initWithSegment:segment];
	/* Any new route has a level value of 1 */
	route.level = 1;
	[array addObject:route];
	
	[mapView addOverlay:[route line]];
	
	[route release];
	[segment release];
}

- (void) checkAggregationIsNeeded {
	/* check if aggregation algorithm should run */
	NSArray *lastroutes = [routes lastObject];
	
	if ([lastroutes count] == kAGGREGATION_FACTOR) {
		[self aggregateRoutes];
		[self checkAggregationIsNeeded];
	}
}

- (void) aggregateRoutes {
	NSArray *lastroutes;
	NSMutableArray *prevroutes;

	/* Extract the last points and remove those from the routes array */
	lastroutes = [[routes lastObject] retain];
	[routes removeLastObject];
	
	/* Extract the previously aggregated array, if any, and performs few checks */
	prevroutes = [routes lastObject];
	
	/* If it does not exist, then we have only to aggregate the lastroutes and higher its level */
	if (!prevroutes) {
		NSMutableArray *newAggregatePoints = [[NSMutableArray alloc] initWithCapacity:kAGGREGATION_FACTOR];
		[self aggregatePoints:lastroutes toArray:newAggregatePoints];
		
		[routes addObject:newAggregatePoints];
		[newAggregatePoints release];
	}
	/* Else, append it to the existing one */
	else {
		[self aggregatePoints:lastroutes toArray:prevroutes];
	}
	
	[lastroutes release];
}

- (void) aggregatePoints:(NSArray *)points toArray:(NSMutableArray *)array {
	CLLocationCoordinate2D prev;
	NSMutableArray *newPoints = [[NSMutableArray alloc] init];
	int level = 1;

	/* Check all the routes */
	for (FFMapRoute *route in points) {
		for (NSData *value in [route points]) {
			CLLocationCoordinate2D *coordinate = (CLLocationCoordinate2D *) [value bytes];
			if (areCoordinateEqual(&prev, coordinate))
				break;
			[newPoints addObject:value];
			prev = *coordinate;
		}
		level = route.level;
		/* Remove the overlay */
		[mapView removeOverlay:route.line];
	}
	
	FFMapRoute *newRoute = [[FFMapRoute alloc] initWithSegment:newPoints];
	[newPoints release];
	newRoute.level = ++level;
	
	[mapView addOverlay:[newRoute line]];
	
	[array addObject:newRoute];
	[newRoute release];
}

@end