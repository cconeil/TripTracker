//
//  COHomeViewController.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "COHomeViewController.h"
#import "COTripLoggingControlView.h"

static const CGFloat kTripLoggingControlViewHeight = 70.0;

@interface COHomeViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) COTripLoggingControlView *tripLoggingControlView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation COHomeViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tripLoggingControlView = [[COTripLoggingControlView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kTripLoggingControlViewHeight)];
    self.tripLoggingControlView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tripLoggingControlView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.tripLoggingControlView.frame), self.view.frame.size.width, self.view.frame.size.height - self.tripLoggingControlView.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate

@end
