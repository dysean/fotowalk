//
//  LocationManager.h
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (LocationManager *)sharedInstance;

- (void)ensureLocationServices;
- (CLLocationCoordinate2D)userCurrentLocation;

@end
