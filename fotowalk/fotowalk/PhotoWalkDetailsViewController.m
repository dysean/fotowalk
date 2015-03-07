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
#import "LocationManager.h"

@interface PhotoWalkDetailsViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *locationsView;

- (IBAction)onGo:(id)sender;

@end

@implementation PhotoWalkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.photoWalk.name;

    [[LocationManager sharedInstance] ensureLocationServices];

    self.mapView.showsUserLocation = YES;
    self.mapView.region = [self.mapView regionThatFits:[self regionForPhotoWalk]];
    [self.mapView addAnnotations:self.photoWalk.locations];
}

static CLLocationDegrees const kMinLatitude = -90.0;
static CLLocationDegrees const kMaxLatitude = 90.0;
static CLLocationDegrees const kMinLongitude = -180.0;
static CLLocationDegrees const kMaxLongitude = 180.0;
static CLLocationDegrees const kOffsetSpan = 1.2;

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

    MKCoordinateSpan spanWithOffset = MKCoordinateSpanMake(span.latitudeDelta * kOffsetSpan,
                                                           span.longitudeDelta * kOffsetSpan);

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 2,
                                                               maxLon - span.longitudeDelta / 2);
    return MKCoordinateRegionMake(center, spanWithOffset);
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