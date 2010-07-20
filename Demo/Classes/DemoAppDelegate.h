//
//  DemoAppDelegate.h
//  Demo
//
//  Created by Fabiano Francesconi on 20/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface DemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	MapViewController *mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

