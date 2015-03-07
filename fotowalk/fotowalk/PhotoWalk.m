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

+ (PhotoWalk *)defaultPhotoWalk {
    static PhotoWalk * defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultInstance == nil) {
            
            // Dolores Park
            Media *photoAtDolores = [[Media alloc] init];
            photoAtDolores.url = @"https://igcdn-photos-b-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/10953373_501077883364017_1166879384_n.jpg";
            Location *doloresPark = [[Location alloc] init];
            doloresPark.name = @"Dolores Park";
            doloresPark.coordinate = CLLocationCoordinate2DMake(37.760006, -122.427074);
            doloresPark.photos = @[photoAtDolores];

            // Balmy Alley
            Media *photoAtBalmyAlley = [[Media alloc] init];
            photoAtBalmyAlley.url = @"https://scontent-iad.cdninstagram.com/hphotos-xaf1/t51.2885-15/10990593_843507585688191_1387495202_n.jpg";
            Location *balmyAlley = [[Location alloc] init];
            balmyAlley.name = @"Balmy Alley";
            balmyAlley.coordinate = CLLocationCoordinate2DMake(37.751884, -122.412366);
            balmyAlley.photos = @[photoAtBalmyAlley];

            // Mission Photo Walk
            defaultInstance = [[PhotoWalk alloc] init];
            defaultInstance.name = @"Mission";
            defaultInstance.length = 300.0; // meters
            defaultInstance.locations = @[doloresPark, balmyAlley];
        }
    });
    return defaultInstance;
    
}

@end