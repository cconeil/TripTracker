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
static const CGFloat kVerticalMargin = 12.0;
static const CGFloat kVerticalPadding = 4.0;
static const CGFloat kRouteLabelFontSize = 14.0;
static const CGFloat kTimeLableFontSize = 12.0;
static const CGFloat kSeparatorViewHeight = 1.0;
static const CGFloat kIconImageWidth = 26.5;
static const CGFloat kBottomMargin = 10.0;

@interface COTripTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *routeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation COTripTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car_icon"]];
        [self.contentView addSubview:_iconImageView];

        _routeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _routeLabel.textColor = [UIColor co_mediumGrayColor];
        _routeLabel.font = [UIFont boldSystemFontOfSize:kRouteLabelFontSize];
        _routeLabel.numberOfLines = 0;
        [self.contentView addSubview:_routeLabel];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor co_lightGrayColor];
        _timeLabel.font = [UIFont italicSystemFontOfSize:kTimeLableFontSize];
        _timeLabel.numberOfLines = 0;
        [self.contentView addSubview:_timeLabel];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - kSeparatorViewHeight, self.frame.size.width, kSeparatorViewHeight)];
        _separatorView.backgroundColor = [UIColor co_cellSeparatorColor];
        _separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_separatorView];
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

    CGFloat labelWidth = self.frame.size.width - kIconImageWidth - kHorizontalPadding - 2.0 * kHorizontalMargin;
    self.routeLabel.frame = CGRectMake(CGRectGetMaxX(iconImageViewFrame) + kHorizontalPadding, kVerticalMargin, labelWidth, 0.0);
    [self.routeLabel sizeToFit];

    self.timeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x, CGRectGetMaxY(self.routeLabel.frame) + kVerticalPadding, labelWidth, 0.0);
    [self.timeLabel sizeToFit];
}

#pragma mark - Height
+ (CGFloat)heightWithTrip:(Trip *)trip forWidth:(CGFloat)width {
    CGFloat height = 0.0;

    CGFloat labelWidth = width - kIconImageWidth - kHorizontalPadding - 2.0 * kHorizontalMargin;
    height += kVerticalMargin;
    height += [self routeHeightWithTrip:trip andWidth:labelWidth];
    height += kVerticalPadding;
    height += [self timeSpanHeightWithTrip:trip andWidth:labelWidth];
    height += kBottomMargin;

    return height;
}

+ (CGFloat)routeHeightWithTrip:(Trip *)trip andWidth:(CGFloat)width {
    if (trip.route.length == 0) {
        return 0.0;
    }

    NSAttributedString *attributedRoute = [[NSAttributedString alloc] initWithString:trip.route attributes:[self routeLabelAttributes]];

    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    return [attributedRoute boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+ (CGFloat)timeSpanHeightWithTrip:(Trip *)trip andWidth:(CGFloat)width {
    if (trip.timeSpan.length == 0) {
        return 0.0;
    }

    NSAttributedString *attributedTimeSpan = [[NSAttributedString alloc] initWithString:trip.timeSpan attributes:[self timeSpanLabelAttributes]];

    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    return [attributedTimeSpan boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

#pragma mark - Attributes
+ (NSDictionary *)routeLabelAttributes {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = [NSParagraphStyle defaultParagraphStyle];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:kRouteLabelFontSize];
    return attributes;
}

+ (NSDictionary *)timeSpanLabelAttributes {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = [NSParagraphStyle defaultParagraphStyle];
    attributes[NSFontAttributeName] = [UIFont italicSystemFontOfSize:kTimeLableFontSize];
    return attributes;
}

@end
