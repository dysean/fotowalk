//
//  RouteHelper.h
//  fotowalk
//
//  Created by Sarp Centel on 3/11/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoWalk;

extern NSString* const kRoutesAvailableNotification;
extern NSString* const kKeyRoutes;
extern NSString* const kKeyPhotoWalkId;

@interface RouteHelper : NSObject

@property (nonatomic, strong) dispatch_queue_t routeQueue;

+ (RouteHelper *) sharedInstance;
- (void) queueDirectionCalculation:(PhotoWalk *) photoWalk;

@end
