//
//  ThoughtworksWeChatTests.m
//  ThoughtworksWeChatTests
//
//  Created by YangFani on 2020/10/16.
//

#import <XCTest/XCTest.h>
#import "TWUser.h"
#import "TWTweet.h"

@interface ThoughtworksWeChatTests : XCTestCase

@end

@implementation ThoughtworksWeChatTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (NSBundle *)bundle4Tests
{
    return [NSBundle bundleForClass:[self class]];
}

- (void)testUserModelIsAvaliable
{
    NSString *filepath = [[self bundle4Tests] pathForResource:@"test_user" ofType:@"json"];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filepath]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    TWUser * user = [[TWUser alloc] initWithDic:dic];
    user = nil;
    if (!user) {
        XCTFail(@"⚠️ Error! parse user data is not correct!");
    }
}

- (void)testTweetListModelIsAvaliable
{
    NSString *filepath = [[self bundle4Tests] pathForResource:@"tweets" ofType:@"json"];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filepath]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!dic[@"sender"]) {
            return;
        }
        if (!dic[@"content"] && !dic[@"images"]) {
            return;
        }
        TWTweet * tweet = [[TWTweet alloc] initWithDic:dic];
        if (!tweet) {
            XCTFail(@"⚠️ Error! parse tweets data is not correct!");
        }
    }];
}

@end
