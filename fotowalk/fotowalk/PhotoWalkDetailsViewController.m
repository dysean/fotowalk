//
//  PhotoWalkDetailsViewController.m
//  fotowalk
//
//  Created by Danilo Resende on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "PhotoWalkDetailsViewController.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "Media.h"
#import "LocationManager.h"
#import "UIImageView+AFNetworking.h"
#import "FWCollectionViewLayout.h"

@interface PhotoWalkDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FWCollectionViewLayoutDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *locationsView;
@property (strong, nonatomic) NSIndexPath *highlightedIndexPath;

- (IBAction)onGo:(id)sender;

@end

@implementation PhotoWalkDetailsViewController

static CGFloat const kCellWidth = 220;
static CGFloat const kCellHeight = 220;
static CGFloat const kPhotoWidth = 200;
static CGFloat const kPhotoHeight = 200;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.title = self.photoWalk.name;

    [[LocationManager sharedInstance] ensureLocationServices];

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.region = [self.mapView regionThatFits:[self.photoWalk region]];
    [self.mapView addAnnotations:self.photoWalk.locations];
    [self.mapView addOverlay:[self walkRouteOverlay]];



    FWCollectionViewLayout *layout = [[FWCollectionViewLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.delegate = self;

    self.locationsView.dataSource = self;
    self.locationsView.delegate = self;
    self.locationsView.allowsSelection = NO;
    self.locationsView.allowsMultipleSelection = NO;
    self.locationsView.collectionViewLayout = layout;
    [self.locationsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LocationCell"];

    [self collectionViewLayout:layout willHighlightCellAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (MKPolyline *)walkRouteOverlay {
    CLLocationCoordinate2D coordinates[self.photoWalk.locations.count];
    NSUInteger index = 0;
    for (Location *location in self.photoWalk.locations) {
        coordinates[index++] = location.coordinate;
    }
    return [MKPolyline polylineWithCoordinates:coordinates count:self.photoWalk.locations.count];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    // TODO: the route needs to follow the roads, maybe we need to call google maps here =(
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:[self walkRouteOverlay]];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 1.0;
    return renderer;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.photoWalk.locations.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];

    UILabel *title;
    UIImageView *locationPhoto;
    if (cell.contentView.subviews.count == 2) {
        title = cell.contentView.subviews[0];
        locationPhoto = cell.contentView.subviews[1];
    } else if (cell.contentView.subviews.count == 0) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kPhotoWidth, 15)];
        title.center = CGPointMake(kPhotoWidth / 2.0, 10);
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:title];

        locationPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kPhotoWidth, kPhotoHeight)];
        locationPhoto.clipsToBounds = YES;
        locationPhoto.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:locationPhoto];
    } else {
        NSLog(@"Houston, we have a problem!!!");
    }

    Location *location = self.photoWalk.locations[indexPath.section];
    Media *firstPhoto = location.photos[0];

    title.text = location.name;
    [title sizeToFit];
    title.center = CGPointMake(kPhotoWidth / 2.0, 10);
    [locationPhoto setImageWithURL:[NSURL URLWithString:firstPhoto.url]];

    return cell;
}

- (void)collectionViewLayout:(FWCollectionViewLayout *)collectionViewLayout willHighlightCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.highlightedIndexPath isEqual:indexPath]) {
        return;
    }

    if (self.highlightedIndexPath) {
        for (id<MKAnnotation> annotationToDeselect in self.mapView.selectedAnnotations) {
            [self.mapView deselectAnnotation:annotationToDeselect animated:YES];
        }
    }

    id<MKAnnotation> locationToSelect = self.photoWalk.locations[indexPath.section];
    [self.mapView selectAnnotation:locationToSelect animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGo:(id)sender {
    MapViewController *mapController = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];
}

@end