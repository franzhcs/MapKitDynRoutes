//
//  FFMapRoute.h
//
//  Created by Fabiano Francesconi on 19/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FFMapRoute : NSObject {
	NSMutableArray *points;
	NSUInteger level;
	MKPolyline *line;
}

@property (nonatomic, retain) MKPolyline *line;
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, assign) NSUInteger level;

/* Init the object with a segment */
- (id) initWithSegment:(NSArray *)segment;

/* Add the points contained in newPoints array to the local array*/
- (void) addPointsFromArray:(NSArray *)newPoints;

/* Add coordinate to the local array by wrapping it into a NSData object */
- (void) addPoint:(CLLocationCoordinate2D) coordinate;

@end
