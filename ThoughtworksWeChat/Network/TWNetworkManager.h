//
//  TWNetworkManager.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Successed)(id responseObject);
typedef void(^Failure)(void);

@interface TWNetworkManager : NSObject

+ (instancetype)manager;

- (void)fetchUserInfo:(Successed)successed failure:(Failure)failure;
//the start page is 1
- (void)fetchTweetList:(NSInteger)page success:(Successed)successed failure:(Failure)failure;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
