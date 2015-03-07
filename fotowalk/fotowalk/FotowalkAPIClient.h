//
//  FotowalkAPIClient.h
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "AFNetworking.h"
#import "Media.h"

@interface FotowalkAPIClient : AFHTTPRequestOperationManager

+ (FotowalkAPIClient *) sharedInstance;

- (void) mediaForLocation:(CLLocationCoordinate2D)location completion:(void (^) (NSArray *media, NSError *error)) completion;

@end
