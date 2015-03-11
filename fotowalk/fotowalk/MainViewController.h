//
//  MainViewController.h
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSDictionary *cityDictionary;
@property (nonatomic,strong) NSArray *currentPhotoWalk;
@property (nonatomic, strong) NSString *currentCity;

@end
