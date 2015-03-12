//
//  MapViewController.h
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PhotoWalk.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) PhotoWalk* photoWalk;
@end
