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

@interface PhotoWalkDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *locationsView;

- (IBAction)onGo:(id)sender;

@end

@implementation PhotoWalkDetailsViewController

static CLLocationDegrees const kMinLatitude = -90.0;
static CLLocationDegrees const kMaxLatitude = 90.0;
static CLLocationDegrees const kMinLongitude = -180.0;
static CLLocationDegrees const kMaxLongitude = 180.0;
static CLLocationDegrees const kOffsetSpan = 0.005;

static CGFloat const kCellWidth = 200;
static CGFloat const kCellHeight = 200;
static CGFloat const kPhotoWidth = 180;
static CGFloat const kPhotoHeight = 180;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.photoWalk.name;

    [[LocationManager sharedInstance] ensureLocationServices];

    self.mapView.showsUserLocation = YES;
    self.mapView.region = [self.mapView regionThatFits:[self regionForPhotoWalk]];
    [self.mapView addAnnotations:self.photoWalk.locations];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    self.locationsView.dataSource = self;
    self.locationsView.delegate = self;
    self.locationsView.allowsSelection = NO;
    self.locationsView.allowsMultipleSelection = NO;
    self.locationsView.collectionViewLayout = layout;
    [self.locationsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LocationCell"];
}

- (MKCoordinateRegion)regionForPhotoWalk {
    CLLocationDegrees minLat = kMaxLatitude;
    CLLocationDegrees maxLat = kMinLatitude;
    CLLocationDegrees minLon = kMaxLongitude;
    CLLocationDegrees maxLon = kMinLongitude;

    for (Location *location in self.photoWalk.locations) {
        minLat = fmin(location.coordinate.latitude, minLat);
        maxLat = fmax(location.coordinate.latitude, maxLat);
        minLon = fmin(location.coordinate.longitude, minLon);
        maxLon = fmax(location.coordinate.longitude, maxLon);
    }

    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);

    MKCoordinateSpan spanWithOffset = MKCoordinateSpanMake(span.latitudeDelta + kOffsetSpan,
                                                           span.longitudeDelta + kOffsetSpan);

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 2,
                                                               maxLon - span.longitudeDelta / 2);
    return MKCoordinateRegionMake(center, spanWithOffset);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.photoWalk.locations.count * 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];

    UILabel *title;
    UIImageView *locationPhoto;
    if (cell.contentView.subviews.count >= 2) {
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

    Location *location = self.photoWalk.locations[indexPath.section % 2];
    Media *firstPhoto = location.photos[0];

    title.text = location.name;
    [title sizeToFit];
    title.center = CGPointMake(kPhotoWidth / 2.0, 10);
    [locationPhoto setImageWithURL:[NSURL URLWithString:firstPhoto.url]];

    return cell;
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