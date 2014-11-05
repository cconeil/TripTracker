//
//  COTripTableViewCell.h
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface COTripTableViewCell : UITableViewCell

@property (nonatomic, strong) Trip *trip;
+ (CGFloat)heightWithTrip:(Trip *)trip forWidth:(CGFloat)width;

@end
