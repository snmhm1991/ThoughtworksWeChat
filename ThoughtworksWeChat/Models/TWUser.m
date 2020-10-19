//
//  TWUser.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWUser.h"

@implementation TWUser

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.username = userInfo[@"username"];
        self.nickname = userInfo[@"nick"];
        self.avatar = userInfo[@"avatar"];
        self.profileImage = userInfo[@"profile-image"];
    }
    return self;
}

@end
