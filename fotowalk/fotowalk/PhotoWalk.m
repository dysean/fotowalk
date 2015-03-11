//
//  PhotoWalk.m
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "PhotoWalk.h"
#import "Media.h"


@implementation PhotoWalk

static CLLocationDegrees const kMinLatitude = -90.0;
static CLLocationDegrees const kMaxLatitude = 90.0;
static CLLocationDegrees const kMinLongitude = -180.0;
static CLLocationDegrees const kMaxLongitude = 180.0;
static CLLocationDegrees const kOffsetSpan = 0.005;

- (MKCoordinateRegion) region {
    CLLocationDegrees minLat = kMaxLatitude;
    CLLocationDegrees maxLat = kMinLatitude;
    CLLocationDegrees minLon = kMaxLongitude;
    CLLocationDegrees maxLon = kMinLongitude;
    
    for (Location *location in self.locations) {
        minLat = fmin(location.coordinate.latitude, minLat);
        maxLat = fmax(location.coordinate.latitude, maxLat);
        minLon = fmin(location.coordinate.longitude, minLon);
        maxLon = fmax(location.coordinate.longitude, maxLon);
    }
    
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    
    MKCoordinateSpan spanWithOffset = MKCoordinateSpanMake(span.latitudeDelta + kOffsetSpan,
                                                           span.longitudeDelta + kOffsetSpan);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 2,
                                                               maxLon - span.longitudeDelta / 2);
    return MKCoordinateRegionMake(center, spanWithOffset);
}


- (id) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.length = [dictionary[@"length"] floatValue];
//        
//        Location *location = dictionary[@"location"];
//        if (location) {
//            double latitude = [location[@"latitude"] doubleValue];
//            double longitude = [location[@"longitude"] doubleValue];
//            self.locations = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

@end