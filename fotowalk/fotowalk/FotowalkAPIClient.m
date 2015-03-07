//
//  FotowalkAPIClient.m
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "FotowalkAPIClient.h"

@interface FotowalkAPIClient()

@end

@implementation FotowalkAPIClient

static NSString* const kApplicationID = @"ANvjVEEiSKoyNeVMNYUHVtRBiEhDikI0XB9Qc7FT";
static NSString* const kRestAPIKey = @"PzWNtLJgkh1l4a6E3z0Le9LNiNoHtVYlkqXi2OD2";
static NSString* const kAPIUrl = @"https://api.parse.com/1/functions/hello";

- (instancetype) init {
    self = [super init];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:kApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
        [self.requestSerializer setValue:kRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

+ (FotowalkAPIClient *) sharedInstance {
    static FotowalkAPIClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[FotowalkAPIClient alloc] init];
        }
    });
    return instance;
}

- (void) mediaForLocation:(CLLocationCoordinate2D)location completion:(void (^) (NSArray *media, NSError *error)) completion {
    NSNumber *latitude = [NSNumber numberWithDouble:location.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.longitude];
    NSDictionary *data = @{@"lat" : latitude, @"long": longitude};
    [self POST:kAPIUrl parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseMedia = [Media mediaWithArray:responseObject[@"result"]];
        completion(responseMedia, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
