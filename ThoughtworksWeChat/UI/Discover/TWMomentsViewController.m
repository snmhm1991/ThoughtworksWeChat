//
//  TWMomentsViewController.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWMomentsViewController.h"
#import "TWMomentsTableHeaderView.h"
#import "TWMomentsTableDataSource.h"
#import "TWNetworkManager.h"
#import "TWUser.h"
#import "TWTweet.h"
#import "UIScrollView+TWRefresh.h"
#import "TWLoadingView.h"

@interface TWMomentsViewController ()<TWScrollViewRefreshDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TWMomentsTableHeaderView *headerView;

@property (nonatomic, strong) TWMomentsTableDataSource * dataSource;
@property (nonatomic, strong) TWLoadingView * loadingView;

@end

@implementation TWMomentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self fetchUserInfo];
    [self fetchTeweetList:YES];
}

- (void)dealloc
{
    [[TWNetworkManager manager] clearCache];
}

- (void)setupViews
{
    self.title = @"朋友圈";
    
    self.dataSource = [[TWMomentsTableDataSource alloc] init];
    self.headerView = [[TWMomentsTableHeaderView alloc] init];
    self.loadingView = [[TWLoadingView alloc] init];
    
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self.dataSource registerCellClasses:self.tableView];
    [self.view addSubview:self.loadingView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self.dataSource;
        _tableView.dataSource = self.dataSource;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.refreshDelegate = self;
        _tableView.scrollFooterView.enableUptoRefesh = YES;
    }
    return _tableView;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.loadingView.center = CGPointMake(self.tableView.width / 2, self.tableView.height / 2);
}

#pragma mark - Network request

- (void)fetchUserInfo
{
    [[TWNetworkManager manager] fetchUserInfo:^(TWUser * user) {
        self.headerView.avatarImageUrl = user.avatar;
        self.headerView.profileImageUrl = user.profileImage;
        self.headerView.hidden = NO;
    } failure:^{
        //request failed
    }];
}

- (void)fetchTeweetList:(BOOL)isRefresh
{
    if (isRefresh) {
        self.page = 1;
    }
    
    [[TWNetworkManager manager] fetchTweetList:self.page success:^(NSArray<TWTweet *> * tweetList) {
        if (isRefresh) {
            [self.dataSource.tweetList removeAllObjects];
        }
        if (tweetList.count > 0) {
            self.page++;
            [self.dataSource.tweetList addObjectsFromArray:tweetList];
            [self.tableView reloadData];
            [self.tableView showLoadingMore:NO];
        } else {
            [self.tableView showFooterNoMore];
        }
        [self.loadingView removeFromSuperview];
        [self.tableView stopAnimation];
    } failure:^{
        //request failed
        [self.tableView stopAnimation];
    }];
}

#pragma mark - TWScrollViewRefreshDelegate

- (void)beginPullToRefreshing:(UIScrollView *)scrollView
{
    [self fetchTeweetList:YES];
}

- (void)beginUpToRefresh:(UIScrollView *)scrollView
{
    [self fetchTeweetList:NO];
}

@end
