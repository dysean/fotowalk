//
//  PhotoWalk.h
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "Location.h"

@interface PhotoWalk : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, strong) NSArray *locations;

+ (PhotoWalk *)defaultPhotoWalk;
- (MKCoordinateRegion)region;

@end
