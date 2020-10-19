//
//  TWTweet.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWTweet.h"
#import "TWUser.h"
#import "TWComment.h"

@implementation TWTweet

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.content = userInfo[@"content"];
        self.senderUser = [[TWUser alloc] initWithDic:userInfo[@"sender"]];
        
        NSMutableArray *mutComments = [@[] mutableCopy];
        NSArray *comments = userInfo[@"comments"];
        for (int i = 0; i < comments.count; i++) {
            [mutComments addObject:[[TWComment alloc] initWithDic:comments[i]]];
        }
        self.comments = [NSArray arrayWithArray:mutComments];
        
        NSMutableArray *mutImages = [@[] mutableCopy];
        NSArray *imgs = userInfo[@"images"];
        for (int j = 0; j < imgs.count; j++) {
            [mutImages addObject:imgs[j][@"url"]];
        }
        self.images = [NSArray arrayWithArray:mutImages];
    }
    return self;
}

@end
