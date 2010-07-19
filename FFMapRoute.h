//
//  FFMapRoute.h
//  iScout
//
//  Created by Fabiano Francesconi on 19/07/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FFMapRoute : NSObject {
	NSUInteger level;
	MKPolyline *line;
}

@property (nonatomic, retain) MKPolyline *line;
@property (nonatomic, assign) NSUInteger level;

@end
