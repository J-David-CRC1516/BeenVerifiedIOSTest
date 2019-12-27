//
//  MapViewController.m
//  BeenVerifiedTest
//
//  Created by David Saborio Alvarado on 12/26/19.
//  Copyright © 2019 David Saborio Alvarado. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( _locationManager == nil )
        {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [_locationManager startUpdatingLocation];
        }

    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    
    [self checkLocationAccess];
    
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.mapView];

}

- (void)checkLocationAccess {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
//todo: manage
        case kCLAuthorizationStatusDenied:
            NSLog(@"never");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not yet");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"allowed always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"In use");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"allowed"); // allowed
        
    }
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"denied"); // denied
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText{
    NSLog(@"Text: %@", searchText);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchText completionHandler:^(NSArray* placemarks, NSError* error){
                     for (CLPlacemark* aPlacemark in placemarks)
                     {
                         CLLocationDegrees lat = aPlacemark.location.coordinate.latitude;
                         CLLocationDegrees lon = aPlacemark.location.coordinate.longitude;
                         
                         GMSCameraPosition *camera = [GMSCameraPosition
                         cameraWithLatitude:lat
                         longitude:lon
                         zoom:0.15
                         bearing:0
                         viewingAngle:0];
                         
                         [self addMarker:lat :lon :aPlacemark.country];
                         
                         [self->_mapView setCamera:camera];
                     }
                 }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
      
        CLLocation *crnLoc = [locations lastObject];
    
        CLLocationDegrees lat = crnLoc.coordinate.latitude;
        CLLocationDegrees lon = crnLoc.coordinate.longitude;
        
        GMSCameraPosition *camera = [GMSCameraPosition
        cameraWithLatitude:lat
        longitude:lon
        zoom:14
        bearing:0
        viewingAngle:0];
    
        [self addMarker:lat :lon :@"Current Location"];
        
        [_mapView setCamera:camera];
    
        [self.locationManager stopUpdatingLocation];
        
}

-(void) addMarker:(CLLocationDegrees)lat : (CLLocationDegrees)lon : (NSString*)name{
    [_mapView clear];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = name;
    marker.map = _mapView;    
}

@end
