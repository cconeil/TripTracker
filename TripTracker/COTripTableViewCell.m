//
//  COTripTableViewCell.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "COTripTableViewCell.h"
#import "UIColor+COAdditions.h"

static const CGFloat kHorizontalMargin = 15.0;
static const CGFloat kHorizontalPadding = 15.0;
static const CGFloat kVerticalMargin = 15.0;
static const CGFloat kVerticalPadding = 8.0;
static const CGFloat kRouteLabelFontSize = 12.0;
static const CGFloat kTimeLableFontSize = 10.0;

@interface COTripTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *routeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation COTripTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_icon"]];
        [self addSubview:_iconImageView];

        _routeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _routeLabel.textColor = [UIColor co_mediumGrayColor];
        _routeLabel.font = [UIFont boldSystemFontOfSize:kRouteLabelFontSize];
//        _routeLabel.text = @"1639 3rd Street > 568 Brannan Street";
        [self addSubview:_routeLabel];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor co_lightGrayColor];
        _timeLabel.font = [UIFont italicSystemFontOfSize:kTimeLableFontSize];
//        _timeLabel.text = @"1:50pm - 2:05pm (15 min)";
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setTrip:(Trip *)trip {
    if (_trip == trip) {
        return;
    }

    _trip = trip;

    _routeLabel.text = trip.route;
    _timeLabel.text = trip.timeSpan;

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect iconImageViewFrame = self.iconImageView.frame;
    iconImageViewFrame.origin.x = kHorizontalMargin;
    iconImageViewFrame.origin.y = (self.frame.size.height - iconImageViewFrame.size.height) / 2.0;
    self.iconImageView.frame = iconImageViewFrame;

    [self.routeLabel sizeToFit];
    self.routeLabel.frame = CGRectMake(CGRectGetMaxX(iconImageViewFrame) + kHorizontalPadding, kVerticalMargin, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);

    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x, CGRectGetMaxY(self.routeLabel.frame) + kVerticalPadding, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
}

@end
