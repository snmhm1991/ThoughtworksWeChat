//
//  TWUser.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWBaseModel.h"

@interface TWUser : TWBaseModel

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *profileImage;

- (id)initWithDic:(NSDictionary *)userInfo;

@end
