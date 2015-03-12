//
//  RouteHelper.m
//  fotowalk
//
//  Created by Sarp Centel on 3/11/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "RouteHelper.h"
#import "PhotoWalk.h"

@interface RouteHelper ()

// Cache Disabled for now, causes memory leak / crash
//@property (nonatomic, strong) NSMutableDictionary* cache;

@end

@implementation RouteHelper

NSString *const kRoutesAvailableNotification = @"kRoutesAvailableNotification";
NSString* const kKeyRoutes = @"kKeyRoutes";
NSString* const kKeyPhotoWalkId = @"kKeyPhotoWalkId";


- (instancetype) init {
    if (self = [super init]) {
//        self.cache = [[NSMutableDictionary alloc] init];
        self.routeQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (RouteHelper *) sharedInstance {
    static RouteHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[RouteHelper alloc] init];
        }
    });
    return instance;
}

- (MKMapItem *)mapItemForLocation:(Location *)location {
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil];
    return [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
}

- (void) queueDirectionCalculation:(PhotoWalk *) photoWalk {
    dispatch_async(self.routeQueue, ^{
        [self calculateDirections:photoWalk];
    });
}

- (void)calculateDirections:(PhotoWalk *) photoWalk {
    /*
    if (self.cache[photoWalk.photoWalkId]) {
        NSLog(@"Returning from cache");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ROUTE" object:nil userInfo:@{@"photowalk" : photoWalk.photoWalkId , @"routes" : self.cache[photoWalk.photoWalkId]}];
    }
    */
    
    NSArray *directionsArray = [self getDirectionsForPhotoWalk:photoWalk];
    NSMutableArray *routes = [NSMutableArray arrayWithCapacity:directionsArray.count];
    for (int i = 0; i < directionsArray.count; i++) {
        [routes addObject:[NSNull null]];
    }
    __block NSInteger routesReturned = 0;
    
    [directionsArray enumerateObjectsUsingBlock:^(MKDirections *directions, NSUInteger idx, BOOL *stop) {
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error while calculating directions: %@", error);
                return;
            }
            MKRoute *route = [response.routes firstObject];
            [routes replaceObjectAtIndex:idx withObject:route];
            routesReturned++;
            if (routesReturned == directionsArray.count) {
                NSLog(@"Finished routes");
//                self.cache[photoWalk.photoWalkId] = routes;
                [[NSNotificationCenter defaultCenter] postNotificationName:kRoutesAvailableNotification object:nil userInfo:@{kKeyPhotoWalkId : photoWalk.photoWalkId , kKeyRoutes : routes}];
            }
        }];
    }];
}

- (NSArray *)getDirectionsForPhotoWalk:(PhotoWalk *) photoWalk {
    NSMutableArray *directions = [NSMutableArray array];
    MKMapItem __block * lastMapItem = [self mapItemForLocation:[photoWalk.locations firstObject]];
    NSRange range;
    range.location = 1;
    range.length = photoWalk.locations.count - 1;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [photoWalk.locations enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(Location *currentLocation, NSUInteger idx, BOOL *stop) {
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
        directionsRequest.source = lastMapItem;
        directionsRequest.destination = [self mapItemForLocation:currentLocation];
        directionsRequest.transportType = MKDirectionsTransportTypeWalking;
        lastMapItem = directionsRequest.destination;
        [directions addObject:[[MKDirections alloc] initWithRequest:directionsRequest]];
    }];
    return directions;
}

@end
