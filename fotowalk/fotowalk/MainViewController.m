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
#import "PhotoWalkTableViewCell.h"



@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentCity = @"San Francisco";
    
    self.title = self.currentCity;

    self.cityDictionary = [City defaultCityDictionary];
    self.currentPhotoWalk = self.cityDictionary[self.currentCity];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButton)];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.estimatedRowHeight = 300;
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"PhotoWalkTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoWalkTableViewCell"];
    [self.mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onMapButton {
    MapViewController *mapController = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *photoWalks = self.currentPhotoWalk;
    return photoWalks.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoWalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoWalkTableViewCell"];
    
    PhotoWalk *walk = self.currentPhotoWalk[indexPath.row];
    cell.photoWalk = walk;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoWalkDetailsViewController *detailsController = [[PhotoWalkDetailsViewController alloc] init];
    detailsController.photoWalk = self.currentPhotoWalk[indexPath.row];
    [self.navigationController pushViewController:detailsController animated:YES];
}

@end
