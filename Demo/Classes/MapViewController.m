//
//  MapViewController.m
//  Demo
//
//  Created by Fabiano Francesconi on 20/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (nonatomic, retain) FFLocationManager *locationManager;
@property (nonatomic, retain) FFMapRoutes *mapRoutes;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	FFLocationManager *manager = [[FFLocationManager alloc] init];
	self.locationManager = manager;
	self.locationManager.delegate = self;
	[manager release];
	
	FFMapRoutes *routes = [[FFMapRoutes alloc] init];
	self.mapRoutes = routes;
	self.mapRoutes.mapView = self.myMapView;
	[routes release];
	
	self.myMapView.delegate = self;
	
	/* Run the simulator */
	[locationManager startUpdatingLocation];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[locationManager stopUpdatingLocation];
	
	self.locationManager = nil;
	self.mapRoutes = nil;
	self.myMapView = nil;
}


- (void)dealloc {
	[locationManager release];
	[mapRoutes release];
	[myMapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Location Delegates

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	/* Add the location to the map */
	[self.mapRoutes addCoordinate:newLocation.coordinate];
	
	if (!oldLocation) {
		MKCoordinateRegion region;
		MKCoordinateSpan span;
			
		region.center = newLocation.coordinate;
			
		/* zoom to maximum */
		span.latitudeDelta = 0.0001f;
		span.longitudeDelta = 0.0001f;
			
		region.span = span;
			
		[myMapView setRegion:region animated:YES];		
	}
	
	[myMapView setCenterCoordinate:newLocation.coordinate];
}

#pragma mark -
#pragma mark Map Delegates

- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	MKPolylineView* overlayView = nil;
	
	overlayView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
	overlayView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
	overlayView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
	overlayView.lineWidth = 3;
	
	return overlayView;
}

@end
