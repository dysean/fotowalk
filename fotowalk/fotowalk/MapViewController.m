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

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@property (weak, nonatomic) IBOutlet UIImageView *photoWalkImage;
@property (weak, nonatomic) IBOutlet UITextView *directions;

- (IBAction)onNextButton:(id)sender;
- (IBAction)onPreviousButton:(id)sender;

@end

@implementation MapViewController

- (void)drawLineForLocations:(NSArray *)locations
{
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc([locations count] * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < locations.count; i++) {
        coordinateArray[i] = ((Location*) locations[i]).coordinate;
    }
  
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:locations.count];
    [self.mapView addOverlay:self.routeLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Walk";
    
    Location *firstLocation = [self.photoWalk.locations firstObject];
    Media *firstPhoto = [firstLocation.photos firstObject];
    [self.photoWalkImage setImageWithURL:[NSURL URLWithString:firstPhoto.url]];
    
    self.mapView.delegate = self;
    self.mapView.region = [self.mapView regionThatFits:[self.photoWalk region]];
    [self.mapView addAnnotations:self.photoWalk.locations];
    [self drawLineForLocations:self.photoWalk.locations];
    
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

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onNextButton:(id)sender {
    NSLog(@"onNextButton");
}

- (IBAction)onPreviousButton:(id)sender {
    NSLog(@"onPreviousButton");
}
@end
