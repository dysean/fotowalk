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
#import "RouteHelper.h"

@interface PhotoWalkDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FWCollectionViewLayoutDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *locationsView;
@property (strong, nonatomic) NSIndexPath *highlightedIndexPath;

- (IBAction)onGo:(id)sender;
- (UILabel *)titleForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UILabel *)descriptionForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PhotoWalkDetailsViewController

static CGFloat const kCellWidth = 220;
static CGFloat const kCellHeight = 220;
static CGFloat const kPhotoWidth = 150;
static CGFloat const kPhotoHeight = 150;
static CGFloat const kMarginRight = 20;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.title = self.photoWalk.name;

    [[LocationManager sharedInstance] ensureLocationServices];

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.region = [self.mapView regionThatFits:[self.photoWalk region]];
    [self.mapView addAnnotations:self.photoWalk.locations];

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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(didFinishCalculatingRoutes:) name:kRoutesAvailableNotification object:nil];
    [[RouteHelper sharedInstance] queueDirectionCalculation:self.photoWalk];
}

- (void)didFinishCalculatingRoutes:(NSNotification *) notification {
    NSDictionary *data = notification.userInfo;
    if ([data[kKeyPhotoWalkId] isEqualToString:self.photoWalk.photoWalkId]) {
        [self addRoutesOverlayForRoutes:data[kKeyRoutes]];
    }
}

- (void)addRoutesOverlayForRoutes:(NSArray*) routes {
    NSMutableArray *polylines = [NSMutableArray array];
    for (MKRoute *route in routes) {
        [polylines addObject:route.polyline];
    }
    [self.mapView addOverlays:polylines];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.photoWalk.locations.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat totalWidth = self.view.bounds.size.width;
    CGFloat leftMargin = (totalWidth / 2) - (kPhotoWidth / 2);
    if (section == 0) {
        return UIEdgeInsetsMake(0, leftMargin, 0, 0);
    } else if (section == self.photoWalk.locations.count - 1) {
        CGFloat rightMargin = (totalWidth / 2) - kCellWidth + (kPhotoWidth / 2);
        return UIEdgeInsetsMake(0, 0, 0, rightMargin);
    }
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];

    UILabel *title;
    UILabel *locationDescription;
    UIImageView *locationPhoto;
    if (cell.contentView.subviews.count == 3) {
        title = cell.contentView.subviews[0];
        locationPhoto = cell.contentView.subviews[1];
        locationDescription = cell.contentView.subviews[2];
    } else if (cell.contentView.subviews.count == 0) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kPhotoWidth, 15)];
        title.center = CGPointMake(kPhotoWidth / 2.0, 10);
        title.font = [UIFont systemFontOfSize:20];
        title.textColor = [UIColor whiteColor];
        title.hidden = YES;
        [cell.contentView addSubview:title];

        locationPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, kPhotoWidth, kPhotoHeight)];
        locationPhoto.clipsToBounds = YES;
        locationPhoto.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:locationPhoto];
        
        locationDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, kPhotoHeight + kMarginRight, kPhotoWidth, kCellHeight - kPhotoHeight - kMarginRight)];
        //locationDescription.center = CGPointMake(kPhotoWidth / 2.0, 10);
        locationDescription.font = [UIFont systemFontOfSize:12];
        locationDescription.textColor = [UIColor whiteColor];
        locationDescription.numberOfLines = 3;
        locationDescription.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:locationDescription];
        
    } else {
        NSLog(@"Houston, we have a problem!!!");
    }

    Location *location = self.photoWalk.locations[indexPath.section];
    Media *firstPhoto = location.photos[0];

    title.text = location.name;
    [title sizeToFit];
    title.center = CGPointMake(kPhotoWidth / 2.0, 10);
    title.alpha = 0;
    locationDescription.text = location.locationDescription;
    locationDescription.alpha = 0;

    [locationDescription sizeToFit];
    [locationPhoto setImageWithURL:[NSURL URLWithString:firstPhoto.url]];

    return cell;
}

- (NSArray *)subviewsForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.locationsView cellForItemAtIndexPath:indexPath];
    if (cell.contentView.subviews.count == 3) {
        return cell.contentView.subviews;
    }
    NSLog(@"Houston, we have a problem!!!");
    return nil;
}

- (UILabel *)titleForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self subviewsForItemAtIndexPath:indexPath][0];
}

- (UILabel *)descriptionForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self subviewsForItemAtIndexPath:indexPath][2];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (![overlay isKindOfClass:[MKPolyline class]]) {
        NSLog(@"Error: Unexpected MKOverlay.");
        return nil;
    }
    MKPolyline *polyline = overlay;
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    renderer.alpha = 0.2;
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}

- (void)collectionViewLayout:(FWCollectionViewLayout *)collectionViewLayout willHighlightCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.highlightedIndexPath isEqual:indexPath]) {
        return;
    }

    UILabel *previousTitle;
    UILabel *previousDescription;
    UILabel *newTitle;
    UILabel *newDescription;

    if (self.highlightedIndexPath) {
        for (id<MKAnnotation> annotationToDeselect in self.mapView.selectedAnnotations) {
            [self.mapView deselectAnnotation:annotationToDeselect animated:YES];
        }
        previousTitle = [self titleForItemAtIndexPath:self.highlightedIndexPath];
        previousDescription = [self descriptionForItemAtIndexPath:self.highlightedIndexPath];
    }

    if (indexPath != nil) {
        newTitle = [self titleForItemAtIndexPath:indexPath];
        newDescription = [self descriptionForItemAtIndexPath:indexPath];

        id<MKAnnotation> locationToSelect = self.photoWalk.locations[indexPath.section];
        [self.mapView selectAnnotation:locationToSelect animated:YES];
    }

    [UIView animateWithDuration:0.4 animations:^{
        previousTitle.alpha = 0;
        previousDescription.alpha = 0;
        newTitle.alpha = 1;
        newDescription.alpha = 1;
    }];

    self.highlightedIndexPath = indexPath;
}

- (Location *)currentLocation {
    if (self.highlightedIndexPath != nil) {
        return self.photoWalk.locations[self.highlightedIndexPath.section];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)view;
    pinView.pinColor = MKPinAnnotationColorRed;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)view;
    pinView.pinColor = MKPinAnnotationColorGreen;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if ([annotation isKindOfClass:[Location class]]) {
        Location *currentAnnotation = (Location *) annotation;
        if ([currentAnnotation isEqual:self.currentLocation]) {
            annView.pinColor = MKPinAnnotationColorGreen;
        }
    }
    return annView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGo:(id)sender {
    MapViewController *mapController = [[MapViewController alloc] init];
    mapController.photoWalk = self.photoWalk;
    [self.navigationController pushViewController:mapController animated:YES];
}

@end