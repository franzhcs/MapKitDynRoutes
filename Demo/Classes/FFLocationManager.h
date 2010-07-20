//
//  FFLocationManager.h
//
//  Created by Fabiano Francesconi on 15/02/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define ROUTE_FILE_NAME @"route"
#define TIMER_INTERVAL 3

@interface FFLocationManager : CLLocationManager {
	NSArray *pointsArray;
	NSInteger pointsArrayIndex;
	NSTimer *aTimer;
	
	NSMutableArray *oldLocations;
	NSInteger oldLocationsIndex;
}

@property (nonatomic,retain) NSArray *pointsArray;
@property (nonatomic,assign) NSInteger pointsArrayIndex;
@property (nonatomic,retain) NSTimer *aTimer;

-(void)injectNextLocation;
- (float) getRandomValue:(float)min toMax:(float)max;

@end
