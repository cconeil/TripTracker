//
//  COTripLoggingControlView.h
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import <UIKit/UIKit.h>

@protocol COTripLoggingControlViewDelegate;

@interface COTripLoggingControlView : UIView

@property (nonatomic, assign, readonly, getter=isLogging) BOOL logging;
@property (nonatomic, weak) id<COTripLoggingControlViewDelegate> delegate;

@end

@protocol COTripLoggingControlViewDelegate <NSObject>
- (void)tripLoggingControlViewDidUpdateLogging:(COTripLoggingControlView *)tripLogggingControlView;
@end