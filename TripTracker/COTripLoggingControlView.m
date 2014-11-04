//
//  COTripLoggingControlView.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "COTripLoggingControlView.h"
#import "UIColor+COAdditions.h"

static const CGFloat kHorizontalPadding = 16.0;
static const CGFloat kTrackingLabelFontSize = 16.0;
static const CGFloat kSeparatorViewHeight = 1.0;

@interface COTripLoggingControlView()

@property (nonatomic, assign, readwrite) BOOL tracking;
@property (nonatomic, strong) UISwitch *trackingSwitch;
@property (nonatomic, strong) UILabel *trackingLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation COTripLoggingControlView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _trackingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _trackingLabel.textColor = [UIColor co_mediumGrayColor];
        _trackingLabel.font = [UIFont boldSystemFontOfSize:kTrackingLabelFontSize];
        _trackingLabel.text = NSLocalizedString(@"Trip Logging", nil);
        [self addSubview:_trackingLabel];

        _trackingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        _trackingSwitch.onTintColor = [UIColor co_lyftGreenColor];
        [self addSubview:_trackingSwitch];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - kSeparatorViewHeight, self.frame.size.width, kSeparatorViewHeight)];
        _separatorView.backgroundColor = [UIColor co_cellSeparatorColor];
        _separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.trackingSwitch sizeToFit];

    CGRect trackingSwitchFrame = self.trackingSwitch.frame;
    trackingSwitchFrame.origin.x = self.frame.size.width - trackingSwitchFrame.size.width - kHorizontalPadding;
    trackingSwitchFrame.origin.y = (self.frame.size.height - trackingSwitchFrame.size.height) / 2.0;
    self.trackingSwitch.frame = trackingSwitchFrame;

    [self.trackingLabel sizeToFit];
    self.trackingLabel.frame = CGRectMake(kHorizontalPadding, (self.frame.size.height - self.trackingLabel.frame.size.height) / 2.0, self.frame.size.width - trackingSwitchFrame.size.width - 2.0 * kHorizontalPadding, self.trackingLabel.frame.size.height);
}

@end
