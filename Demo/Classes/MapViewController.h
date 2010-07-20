//
//  MapViewController.h
//  Demo
//
//  Created by Fabiano Francesconi on 20/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FFLocationManager.h"
#import "FFMapRoutes.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
	MKMapView *myMapView;
	
	FFLocationManager *locationManager;
	FFMapRoutes *mapRoutes;
}

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;

@end
