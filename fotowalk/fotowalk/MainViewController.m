//
//  MainViewController.m
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "PhotoWalkDetailsViewController.h"

@interface MainViewController ()
- (IBAction)onClickMapButton:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fotowalk";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickMapButton:(id)sender {
    MapViewController *mapController = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];
}

- (IBAction)onMissionWalk:(id)sender {
    PhotoWalkDetailsViewController *detailsController = [[PhotoWalkDetailsViewController alloc] init];
    detailsController.photoWalk = [PhotoWalk defaultPhotoWalk];
    [self.navigationController pushViewController:detailsController animated:YES];
}

@end
