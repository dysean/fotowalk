//
//  MapViewController.m
//  fotowalk
//
//  Created by Sarp Centel on 3/6/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "MapViewController.h"
#import "FotowalkAPIClient.h"
#import "PhotoWalk.h"
#import "Location.h"
#import "Media.h"
#import "UIImageView+AFNetworking.h"
#import "RouteHelper.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@property (weak, nonatomic) IBOutlet UIImageView *photoWalkImage;
@property (weak, nonatomic) IBOutlet UITextView *directions;

@property (assign, nonatomic) Location *currentLocation;
@property (assign, nonatomic) MKRoute *currentRoute;

- (IBAction)onNextButton:(id)sender;
- (IBAction)onPreviousButton:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Photo Walk";
    
    self.mapView.delegate = self;
    self.mapView.region = [self.mapView regionThatFits:[self.photoWalk region]];
    [self.mapView addAnnotations:self.photoWalk.locations];
    
    self.currentLocation = [self.photoWalk.locations firstObject];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(didFinishCalculatingRoutes:) name:kRoutesAvailableNotification object:nil];
    [[RouteHelper sharedInstance] queueDirectionCalculation:self.photoWalk];
    /*
    [[FotowalkAPIClient sharedInstance] mediaForLocation: CLLocationCoordinate2DMake(40.730952, 73.991290) completion:^(NSArray *media, NSError *error) {
        if (!error) {
            NSLog(@"Great success!");
        } else {
            NSLog(@"Epic fail");
        }
    }];
    */
}

- (void)didFinishCalculatingRoutes:(NSNotification *) notification {
    NSDictionary *data = notification.userInfo;
    if ([data[kKeyPhotoWalkId] isEqualToString:self.photoWalk.photoWalkId]) {
        self.routes = data[kKeyRoutes];
        self.currentRoute = [self.routes firstObject];
        [self addRoutesOverlayForRoutes:self.routes];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addRoutesOverlayForRoutes:(NSArray *) routes {
    NSMutableArray *polylines = [NSMutableArray array];
    for (MKRoute *route in routes) {
        [polylines addObject:route.polyline];
    }
    [self.mapView addOverlays:polylines];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if ([annotation isKindOfClass:[Location class]]) {
        Location *currentAnnotation = (Location *) annotation;
        if (currentAnnotation == self.currentLocation) {
            annView.pinColor = MKPinAnnotationColorGreen;
        }
    }
    return annView;
}

- (void) setPhotoWalk:(PhotoWalk *)photoWalk {
    _photoWalk = photoWalk;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (![overlay isKindOfClass:[MKPolyline class]]) {
        NSLog(@"Error: Unexpected MKOverlay.");
        return nil;
    }
    MKPolyline *polyline = overlay;
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    if (polyline == self.currentRoute.polyline) {
        renderer.strokeColor = [UIColor greenColor];
    } else {
        renderer.strokeColor = [UIColor blueColor];
    }
    renderer.lineWidth = 2.0;
    return renderer;
}

- (void) redrawMapAnnotations {
    NSArray *annotations = self.mapView.annotations;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:annotations];
}

- (void) redrawMapOverlays {
    NSArray *overlays = self.mapView.overlays;
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlays:overlays];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setCurrentRoute:(MKRoute *)currentRoute {
    _currentRoute = currentRoute;
    [self redrawMapOverlays];
}

- (void)setCurrentLocation:(Location *)currentLocation {
    _currentLocation = currentLocation;
    Media *firstPhoto = [currentLocation.photos firstObject];
    [self.photoWalkImage setImageWithURL:[NSURL URLWithString:firstPhoto.url]];
    [self redrawMapAnnotations];
}

- (IBAction)onNextButton:(id)sender {
    // Change pin
    NSArray * locations = self.photoWalk.locations;
    NSInteger currentIndex = [locations indexOfObject:self.currentLocation];
    if (currentIndex < locations.count - 1) {
        currentIndex++;
        self.currentLocation = locations[currentIndex];
    }
    // Change road highlight
    NSInteger currentRouteIndex = [self.routes indexOfObject:self.currentRoute];
    if (currentRouteIndex < self.routes.count - 1) {
        currentRouteIndex++;
        self.currentRoute = self.routes[currentRouteIndex];
    }
}

- (IBAction)onPreviousButton:(id)sender {
    // Change pin
    NSArray * locations = self.photoWalk.locations;
    NSInteger currentIndex = [locations indexOfObject:self.currentLocation];
    if (currentIndex > 0) {
        currentIndex--;
        self.currentLocation = locations[currentIndex];
    }
    // Change road highlight
    NSInteger currentRouteIndex = [self.routes indexOfObject:self.currentRoute];
    if (currentRouteIndex > 0) {
        currentRouteIndex--;
        self.currentRoute = self.routes[currentRouteIndex];
    }
}
@end
