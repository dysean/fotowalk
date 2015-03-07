//
//  Media.h
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Media : NSObject

@property(strong, nonatomic) NSString *mediaId;
@property(strong, nonatomic) NSString *text;
@property(assign, nonatomic) CLLocationCoordinate2D location;
@property(strong, nonatomic) NSString *place;

- (id) initWithDictionary: (NSDictionary *)dictionary;
+ (NSArray *) mediaWithArray:(NSArray *) array;

@end
