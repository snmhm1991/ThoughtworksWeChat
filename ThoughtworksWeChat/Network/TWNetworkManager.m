//
//  TWNetworkManager.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "TWNetworkManager.h"
#import "AFHTTPSessionManager.h"
#import "TWUser.h"
#import "TWTweet.h"

#define TWURLHost @"https://thoughtworks-mobile-2018.herokuapp.com"
#define TWUserHost @"/user/jsmith"
#define TWTweetsHost @"/user/jsmith/tweets"

@interface TWNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSArray * tweetList;

@end

@implementation TWNetworkManager

+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy  = securityPolicy;
        _sessionManager = manager;
    }
    return _sessionManager;
}

- (void)clearCache
{
    self.tweetList = nil;
}

- (void)fetchUserInfo:(Successed)successed failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",TWURLHost,TWUserHost];
    [self.sessionManager GET:url parameters:nil headers:nil progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject) {
            if (failure) {
                failure();
            }
            return;
        }
        
        TWUser * user = [[TWUser alloc] initWithDic:responseObject];
        if (successed) {
            successed(user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)fetchTweetList:(NSInteger)page success:(Successed)successed failure:(Failure)failure
{
    //if tweet data is already exist,just read data from cache page
    if (self.tweetList.count > 0) {
        if (successed) {
            NSArray * array = [self p_tweetListWithPage:page];
            successed(array);
        }
        return;
    }
    
    [self p_fetchTweetList:^(NSArray<TWTweet *> * tweets) {
        self.tweetList = tweets;
        if (successed) {
            NSArray * array = [self p_tweetListWithPage:page];
            successed(array);
        }
    } failure:failure];
}

- (void)p_fetchTweetList:(Successed)successed failure:(Failure)failure
{
    NSString * url = [NSString stringWithFormat:@"%@%@",TWURLHost,TWTweetsHost];
    [self.sessionManager GET:url parameters:nil headers:nil progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSArray class]]) {
            if (failure) {
                failure();
            }
            return;
        }
        
        NSMutableArray * array = [NSMutableArray array];
        
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!dic[@"sender"]) {
                return;
            }
            if (!dic[@"content"] && !dic[@"images"]) {
                return;
            }
            TWTweet * tweet = [[TWTweet alloc] initWithDic:dic];
            if (tweet) {
                [array addObject:tweet];
            }
        }];
        if (successed) {
            successed(array);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (NSArray *)p_tweetListWithPage:(NSInteger)page
{
    int pageCount = 5;
    NSArray * array = nil;
    NSInteger pageSize = page * pageCount;
    
    if (pageSize <= self.tweetList.count) {
        array = [self.tweetList subarrayWithRange:NSMakeRange((page - 1) * pageCount, pageCount)];
    }
    else if (pageSize > self.tweetList.count && (page - 1) * pageCount < self.tweetList.count){
        NSInteger diff = self.tweetList.count - (page - 1) * pageCount;
        array = [self.tweetList subarrayWithRange:NSMakeRange((page - 1) * pageCount, diff)];
    }
    return array;
}

@end
