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
            
            // Tacolicious
            Media *photoAtTacolicious = [[Media alloc] init];
            photoAtTacolicious.url = @"https://igcdn-photos-e-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/11008287_1554038204859724_452106543_n.jpg";
            Location *tacolicious = [[Location alloc] init];
            tacolicious.name = @"Tacolicious";
            tacolicious.coordinate = CLLocationCoordinate2DMake(37.761089, -122.421346);
            tacolicious.photos = @[photoAtTacolicious];

            // Clarion Alley
            Media *photoAtClarionAlley = [[Media alloc] init];
            photoAtClarionAlley.url = @"https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-15/10986090_1565543290396779_1090682747_n.jpg";
            Location *clarionAlley = [[Location alloc] init];
            clarionAlley.name = @"Clarion Alley";
            clarionAlley.coordinate = CLLocationCoordinate2DMake(37.763176, -122.419529);
            clarionAlley.photos = @[photoAtClarionAlley];

            // Gravel and Gold
            Media *photoAtGravelAndGold = [[Media alloc] init];
            photoAtGravelAndGold.url = @"https://igcdn-photos-b-a.akamaihd.net/hphotos-ak-xpa1/t51.2885-15/10576039_556757027779521_2135052316_n.jpg";
            Location *gravelAndGold = [[Location alloc] init];
            gravelAndGold.name = @"Gravel and Gold";
            gravelAndGold.coordinate = CLLocationCoordinate2DMake(37.757421, -122.420539);
            gravelAndGold.photos = @[photoAtGravelAndGold];

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
            defaultInstance.locations = @[doloresPark, tacolicious, clarionAlley, gravelAndGold, balmyAlley];
        }
    });
    return defaultInstance;
    
}

@end