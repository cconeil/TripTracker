//
//  COMapViewController.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/5/14.
//
//

#import "COMapViewController.h"
#import <MapKit/MapKit.h>
#import "COMapPin.h"

@interface COMapViewController()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;
@end

@implementation COMapViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];

    [self createAnnotations];
    [self addAnnotationsToMap];
    [self displayAnnotationsOnMap];
}

#pragma mark -
- (void)createAnnotations {
    COMapPin *startPin = [[COMapPin alloc] init];
    startPin.coordinate = CLLocationCoordinate2DMake(self.trip.startLatitude, self.trip.startLongitude);
    startPin.title = NSLocalizedString(@"Start Location", nil);
    startPin.subtitle = self.trip.startLocation;

    COMapPin *endPin = [[COMapPin alloc] init];
    endPin.coordinate = CLLocationCoordinate2DMake(self.trip.endLatitude, self.trip.endLongitude);
    endPin.title = NSLocalizedString(@"End Location", nil);
    endPin.subtitle = self.trip.endLocation;

    self.annotations = @[startPin, endPin];
}

- (void)addAnnotationsToMap {
    for (COMapPin *pin in self.annotations) {
        [self.mapView addAnnotation:pin];
    }
}

- (void)displayAnnotationsOnMap {
    [self.mapView showAnnotations:self.annotations animated:YES];
}

@end
