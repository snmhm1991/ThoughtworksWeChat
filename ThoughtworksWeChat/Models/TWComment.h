//
//  TWComment.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWBaseModel.h"

@class TWUser;
@interface TWComment : TWBaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TWUser *senderUser;

- (id)initWithDic:(NSDictionary *)userInfo;

@end
