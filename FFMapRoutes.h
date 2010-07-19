//
//  FFMapRoute.h
//  iScout
//
//  Created by Fabiano Francesconi on 10/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FFMapRoute.h"

/* Each kAGGREGATION_FACTOR points, aggregate those in a single polyline */
#define kAGGREGATION_FACTOR 10

@interface FFMapRoutes: NSObject {
	NSMutableArray *points;
	NSMutableArray *lines;

	MKMapView *mapView;
	
	CLLocationCoordinate2D lastCoordinate;
	
	/* Array of routes */
	FFMapRoute **routes;
}

@property (nonatomic, assign) MKMapView *mapView;

- (void) addCoordinate:(CLLocationCoordinate2D)coordinate;

@end
