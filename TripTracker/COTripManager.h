//
//  COTripManager.h
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import <Foundation/Foundation.h>

extern NSString * const COTripManagerDidCreateTripNotification;

@interface COTripManager : NSObject

// Setting trackingEnabled will turn on location services and start to add trips
// internally.  Trips are available through the trips property
@property (nonatomic, assign) BOOL trackingEnabled;

// Access all of the trips that are stored
@property (nonatomic, strong, readonly) NSArray *trips;
@property (nonatomic, assign, readonly, getter=isRecordingTrip) BOOL recordingTrip;

+ (COTripManager *)sharedManager;

@end





