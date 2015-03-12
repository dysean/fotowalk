//
//  Location.m
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSString *)title {
    return self.name;
}

@end
