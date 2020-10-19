//
//  TWMomentsTableDataSource.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWMomentsTableDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<TWTweet *> * tweetList;

- (void)registerCellClasses:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
