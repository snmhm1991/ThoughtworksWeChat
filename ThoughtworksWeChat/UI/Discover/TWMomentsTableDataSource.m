//
//  TWMomentsTableDataSource.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "TWMomentsTableDataSource.h"
#import "TWCommentsCell.h"

#define cellIdentifier @"TWCommentsCell"

@implementation TWMomentsTableDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.tweetList = [NSMutableArray array];
    }
    return self;
}

- (void)registerCellClasses:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tweetList.count) {
        return [[UITableViewCell alloc] init];
    }

    TWCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.0f);
    TWTweet *tweet = self.tweetList[indexPath.row];
    [cell drawContent:tweet];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweet *tweet = self.tweetList[indexPath.row];
    return [TWCommentsCell cellHeight:tweet];
}

@end
