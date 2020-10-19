//
//  TWComment.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWComment.h"
#import "TWUser.h"

@implementation TWComment

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.content = userInfo[@"content"];
        self.senderUser = [[TWUser alloc] initWithDic:userInfo[@"sender"]];
    }
    return self;
}

@end
