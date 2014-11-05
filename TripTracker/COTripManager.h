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

@property (nonatomic, assign) BOOL trackingEnabled;
@property (nonatomic, assign, readonly) BOOL recordingTrip;
@property (nonatomic, strong, readonly) NSArray *trips;

+ (COTripManager *)sharedManager;

@end





