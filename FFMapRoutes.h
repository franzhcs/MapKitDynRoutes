//
//  FFMapRoute.h
//
//  Created by Fabiano Francesconi on 10/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FFMapRoute.h"

/* Each kAGGREGATION_FACTOR points, aggregate those in a single polyline */
#define kAGGREGATION_FACTOR 3

@interface FFMapRoutes: NSObject {
	/* The target mapview that will handle overlays */
	MKMapView *mapView;
	
	CLLocationCoordinate2D lastCoordinate;
	
	/* Array of routes */
	NSMutableArray *routes;
}

@property (nonatomic, assign) MKMapView *mapView;

- (void) addCoordinate:(CLLocationCoordinate2D) coordinate;

@end
