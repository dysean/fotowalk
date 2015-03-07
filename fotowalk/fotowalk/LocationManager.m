//
//  LocationManager.m
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (LocationManager *)sharedInstance {
    static LocationManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)  {
            instance = [[LocationManager alloc] init];
        }
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)ensureLocationServices {
    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
    switch (locationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // Good to go!
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            // TODO: show alert
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self requestLocationServices];
            break;
    }
}

- (void)requestLocationServices {
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"New location authorization status: %d", status);
}

- (CLLocationCoordinate2D)userCurrentLocation {
    return self.locationManager.location.coordinate;
}

@end
