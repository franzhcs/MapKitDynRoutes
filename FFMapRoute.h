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

/* Init the object with a list of points */
- (id) initWithPoints:(NSArray *)newPoints;

/* Add coordinate to the local array by wrapping it into a NSData object */
/* This method is useful when you created a placeholder that is an empty FFMapRoute instance. */
/* With this method you can drop the existing points and regenerate the new polyline */
- (void) updateRouteWithPoints:(NSArray *)newPoints;

@end
