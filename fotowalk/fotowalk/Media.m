//
//  Media.m
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "Media.h"

@implementation Media

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.mediaId = dictionary[@"id"];
        NSDictionary *caption = dictionary[@"caption"];
        if (![caption isKindOfClass:[NSNull class]]) {
            self.text = caption[@"text"];
        }
        NSDictionary *location = dictionary[@"location"];
        if (location) {
            double latitude = [location[@"latitude"] doubleValue];
            double longitude = [location[@"longitude"] doubleValue];
            self.location = CLLocationCoordinate2DMake(latitude, longitude);
            self.place = location[@"name"];
        }
    }
    return self;
}

+ (NSArray *) mediaWithArray: (NSArray*) array {
    NSMutableArray *mediaArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [mediaArray addObject:[[Media alloc] initWithDictionary:dictionary]];
    }
    return mediaArray;
}

@end
