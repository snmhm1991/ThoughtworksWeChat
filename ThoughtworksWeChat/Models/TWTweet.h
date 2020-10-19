//
//  TWTweet.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWBaseModel.h"

@class TWUser;
@interface TWTweet : TWBaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TWUser *senderUser;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *comments;

- (id)initWithDic:(NSDictionary *)userInfo;

@end
