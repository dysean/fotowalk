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