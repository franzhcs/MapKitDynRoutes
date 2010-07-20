//
//  FFLocationManager.m
//
//  Created by Fabiano Francesconi on 15/02/10.
//  Copyright 2010 Fabiano Francesconi. All rights reserved.
//

#import "FFLocationManager.h"

@implementation FFLocationManager

@synthesize pointsArray, pointsArrayIndex, aTimer;

-(id)init {
	self = [super init];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:ROUTE_FILE_NAME ofType:@"csv"];
	NSString *fake_location = [[NSString alloc] initWithContentsOfFile:filePath];
	pointsArray = [[fake_location componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
	pointsArrayIndex = 0;
	oldLocationsIndex = 0;
	
	[fake_location release];
	
	oldLocations = [[NSMutableArray alloc] init];
	return self;
}

-(void)startUpdatingLocation {
	aTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(injectNextLocation) userInfo:nil repeats:YES];
}

-(void)stopUpdatingLocation {
	[aTimer invalidate];
}

-(void)injectNextLocation{

	if (pointsArray.count == pointsArrayIndex) {
		[self stopUpdatingLocation];
		return;
	}
	
	CLLocation *oldLocation = nil;
	
	if ([oldLocations count] > 0) {
		oldLocation = [oldLocations objectAtIndex:oldLocationsIndex];
		oldLocationsIndex++;
	}
	
	NSString *pointString = [pointsArray objectAtIndex:pointsArrayIndex];
	NSArray *latLong = [pointString componentsSeparatedByString:@","];
	
	CLLocationCoordinate2D coords;
	coords.latitude = [[latLong objectAtIndex:0] doubleValue];
	coords.longitude = [[latLong objectAtIndex:1] doubleValue];
	
	float altitude = [self getRandomValue:200 toMax:220];
	CLLocation *myLocation = [[CLLocation alloc] initWithCoordinate:coords altitude:altitude horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
	
	[self.delegate locationManager:self didUpdateToLocation:myLocation fromLocation:oldLocation];
	
	[oldLocations addObject:myLocation];
	[myLocation release];

	pointsArrayIndex++;
}

-(void)dealloc {
	[pointsArray release];
	[aTimer release];
	[oldLocations release];
	[super dealloc];
}

#pragma mark -
#pragma mark functions

- (float) getRandomValue:(float)min toMax:(float)max {
	NSNumber *rand;
	rand = [NSNumber numberWithUnsignedInt:arc4random()];
	return fmod([rand floatValue],(max-min+1))+min;
}

@end
