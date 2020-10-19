//
//  TWImageCacheManager.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWImageCacheManager : NSObject

- (void)cacheImage:(UIImage *)image withKey:(NSString *)nameKey;
- (UIImage *)getImageByKey:(NSString *)nameKey;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
