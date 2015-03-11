//
//  City.m
//  fotowalk
//
//  Created by Sean Dy on 3/10/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "City.h"
#import "PhotoWalk.h"
#import "Media.h"

@implementation City


+ (NSDictionary *)defaultCityDictionary {
    static NSDictionary *defaultCityDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultCityDictionary == nil) {
            
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
            
            // Tacolicious
            Media *photoAtTacolicious = [[Media alloc] init];
            photoAtTacolicious.url = @"https://igcdn-photos-e-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/11008287_1554038204859724_452106543_n.jpg";
            Location *tacolicious = [[Location alloc] init];
            tacolicious.name = @"Tacolicious";
            tacolicious.coordinate = CLLocationCoordinate2DMake(37.761089, -122.421346);
            tacolicious.photos = @[photoAtTacolicious];
            
            // Golden Gate Park
            Media *photoAtGG = [[Media alloc] init];
            photoAtGG.url = @"https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/10788004_309694562555483_934540193_n.jpg";
            Location *goldenGate = [[Location alloc] init];
            goldenGate.name = @"Golden Gate Bridge";
            goldenGate.coordinate = CLLocationCoordinate2DMake(37.820132, -122.478684);
            goldenGate.photos = @[photoAtGG];
            
            // Hawk Hill
            Media *photoAtHawkHill = [[Media alloc] init];
            photoAtHawkHill.url = @"https://igcdn-photos-g-a.akamaihd.net/hphotos-ak-xfa1/t51.2885-15/11017613_1585074895071726_1700802936_n.jpg";
            Location *hawkHill = [[Location alloc] init];
            hawkHill.name = @"Hawk Hill";
            hawkHill.coordinate = CLLocationCoordinate2DMake(37.825594, -122.499406);
            hawkHill.photos = @[photoAtHawkHill];
            
            // Mission Photo Walk
            PhotoWalk *missionPhotoWalk = [[PhotoWalk alloc] init];
            missionPhotoWalk.name = @"Mission";
            missionPhotoWalk.length = 300.0; // meters
            missionPhotoWalk.locations = @[doloresPark, balmyAlley, tacolicious];

            // Golden Gate Photo Walk
            PhotoWalk *goldenGatePhotoWalk = [[PhotoWalk alloc] init];
            goldenGatePhotoWalk.name = @"Golden Gate";
            goldenGatePhotoWalk.length = 300.0; // meters
            goldenGatePhotoWalk.locations = @[goldenGate, hawkHill];
            
            NSDictionary *cityDictionary = @{@"San Francisco" : @[missionPhotoWalk, goldenGatePhotoWalk], @"New York City" : @[missionPhotoWalk]};
            
            defaultCityDictionary = [[NSDictionary alloc] init];
            defaultCityDictionary = cityDictionary;
        }
    });
    return defaultCityDictionary;
}

@end
