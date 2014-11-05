//
//  COHomeViewController.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "COHomeViewController.h"
#import "COTripLoggingControlView.h"
#import "COTripTableViewCell.h"
#import "UIColor+COAdditions.h"
#import "COTripManager.h"
#import <CoreLocation/CoreLocation.h>

static const CGFloat kTripLoggingControlViewHeight = 70.0;
static const CGFloat kTripTableViewCellHeight = 55.0;
static NSString * const kTripTableViewCellIdentifier = @"TripTableViewCell";

@interface COHomeViewController() <UITableViewDataSource, UITableViewDelegate, COTripLoggingControlViewDelegate>

@property (nonatomic, strong) COTripLoggingControlView *tripLoggingControlView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation COHomeViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tripLoggingControlView = [[COTripLoggingControlView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kTripLoggingControlViewHeight)];
    self.tripLoggingControlView.backgroundColor = [UIColor whiteColor];
    self.tripLoggingControlView.delegate = self;
    [self.view addSubview:self.tripLoggingControlView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.tripLoggingControlView.frame), self.view.frame.size.width, self.view.frame.size.height - self.tripLoggingControlView.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[COTripTableViewCell class] forCellReuseIdentifier:kTripTableViewCellIdentifier];
    [self.view addSubview:self.tableView];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tipManagerDidLogTrip) name:COTripManagerDidCreateTripNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COTripManagerDidCreateTripNotification object:nil];
}

#pragma mark -
- (void)tipManagerDidLogTrip {
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [COTripManager sharedManager].trips.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTripTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    COTripTableViewCell *cell = (COTripTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTripTableViewCellIdentifier forIndexPath:indexPath];

    Trip *trip = [COTripManager sharedManager].trips[indexPath.row];
    cell.trip = trip;

    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - COTripLoggingControlViewDelegate
- (void)tripLoggingControlViewDidUpdateLogging:(COTripLoggingControlView *)tripLogggingControlView {
    [COTripManager sharedManager].trackingEnabled = tripLogggingControlView.logging;
}

@end
