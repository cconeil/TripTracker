//
//  COTripManager.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "COTripManager.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "Trip.h"

NSString * const COTripManagerDidCreateTripNotification = @"COTripManagerDidCreateTripNotification";

static const CLLocationSpeed kMilesPerHourConversion = 2.2369362920544;
static const CLLocationSpeed kMinimumStartSpeed = 10.0; // in MPH
static const NSTimeInterval kEndTripTimeInterval = 60.0; // in seconds
static NSString * const kTripTrackerCache = @"TripTrackerCache";

@interface COTripManager() <CLLocationManagerDelegate>

// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// Location
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *previousLocation;

// Tracking
@property (nonatomic, assign) BOOL recordingTrip;
@property (nonatomic, strong) NSTimer *endTripTimer;
@property (nonatomic, strong) Trip *currentTrip;

@end

@implementation COTripManager

+ (COTripManager *)sharedManager {
    static dispatch_once_t once;
    static COTripManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[COTripManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {

        // Managed Object Model
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TripTracker" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        // Persistent Object Store
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TripTracker.sqlite"];
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };

        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        if (_persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        } else {
            abort();
        }

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;

        [self clearCacheAndFetch];
    }
    return self;
}

#pragma mark -
- (NSArray *)trips {
    return self.fetchedResultsController.fetchedObjects ?: @[];
}

- (void)setTrackingEnabled:(BOOL)trackingEnabled {
    _trackingEnabled = trackingEnabled;
    if (_trackingEnabled) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager stopUpdatingLocation];

        if (self.recordingTrip) {
            [self endTrip];
            if (self.endTripTimer) {
                [self.endTripTimer invalidate];
                self.endTripTimer = nil;
            }
        }
    }
}

#pragma mark -
- (void)startRecordingAtLocation:(CLLocation *)location {
    self.recordingTrip = YES;
    self.currentTrip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    self.currentTrip.startDate = [NSDate date];
    self.currentTrip.startLongitude = location.coordinate.longitude;
    self.currentTrip.startLatitude = location.coordinate.latitude;
    [self addressStringForLocation:location completion:^(NSString *address) {
        self.currentTrip.startLocation = address;
    }];
}

- (void)endRecordingAtLocation:(CLLocation *)location completion:(void (^)())completion {
    Trip *tipClosure = self.currentTrip;
    tipClosure.endDate = [NSDate date];
    tipClosure.endLongitude = location.coordinate.longitude;
    tipClosure.endLatitude = location.coordinate.latitude;

    [self addressStringForLocation:location completion:^(NSString *address) {
        tipClosure.endLocation = address;
        if (completion) {
            completion();
        }
    }];
}

- (void)endTrip {
    self.recordingTrip = NO;
    [self endRecordingAtLocation:self.previousLocation completion:^{
        [self saveContext];
        [self clearCacheAndFetch];
        [[NSNotificationCenter defaultCenter] postNotificationName:COTripManagerDidCreateTripNotification object:nil];
    }];
}

-(NSString *)addressStringForLocation:(CLLocation *)location completion:(void (^)(NSString *address))completion {
    __block NSString *addressString = nil;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks firstObject];
            if (completion) {
                completion(placemark.thoroughfare);
            }
            return;
        } else {
            NSLog(@"Error getting address street from location: %@", [error localizedDescription]);
        }
    }];

    return addressString;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationSpeed speed = location.speed * kMilesPerHourConversion;

    self.previousLocation = location;
    if (speed > kMinimumStartSpeed) {
        if (!self.recordingTrip) {
            [self startRecordingAtLocation:location];
        } else {
            if (self.endTripTimer) {
                [self.endTripTimer invalidate];
                self.endTripTimer = nil;
            }
        }
    } else if (speed <= 0.0) {
        if (!self.endTripTimer) {
            self.endTripTimer = [NSTimer scheduledTimerWithTimeInterval:kEndTripTimeInterval target:self selector:@selector(endTrip) userInfo:nil repeats:NO];
        }
    }
}


#pragma mark - Core Data
- (void)saveContext {
    NSAssert(self.managedObjectContext != nil, @"managedObjectContext must be set.");
    NSError *error = nil;

    if (![self.managedObjectContext hasChanges]) {
        return;
    }

    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save trip to Core Data %@", [error localizedDescription]);
    }
}

- (void)clearCacheAndFetch {
    [NSFetchedResultsController deleteCacheWithName:kTripTrackerCache];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.entity = entityDescription;

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:kTripTrackerCache];
    [self.fetchedResultsController performFetch:nil];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
