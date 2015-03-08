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
- (IBAction)onClickMapButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fotowalk";
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.estimatedRowHeight = 300;
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"PhotoWalkTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoWalkTableViewCell"];
    [self.mainTableView reloadData];
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

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoWalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoWalkTableViewCell"];

    PhotoWalk *walk = [PhotoWalk defaultPhotoWalk];
    cell.photoWalk = walk;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PhotoWalkDetailsViewController *detailsController = [[PhotoWalkDetailsViewController alloc] init];
    detailsController.photoWalk = [PhotoWalk defaultPhotoWalk];
    [self.navigationController pushViewController:detailsController animated:YES];
}

@end
