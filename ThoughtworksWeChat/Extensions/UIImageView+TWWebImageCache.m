//
//  UIImageView+TWWebImageCache.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "UIImageView+TWWebImageCache.h"
#import "TWImageCacheManager.h"
#import "NSString+TWEncoder.h"

@implementation UIImageView (TWWebImageCache)

- (void)setImageWithUrlString:(NSString *)url
{
    UIImage * image = [[TWImageCacheManager sharedInstance] getImageByKey:[url MD5]];
    if (image) {
        self.image = image;
        return;
    }
    
    self.image = [UIImage imageNamed:@"default_image"];
    
    //download image
    [self downloadImageFromInternet:url finished:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    }];
}

- (void)downloadImageFromInternet:(NSString *)url finished:(void(^)(UIImage * image))finished
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *imgUrl = [NSURL URLWithString:url];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        
        if ( imgData ) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                [[TWImageCacheManager sharedInstance] cacheImage:image withKey:[url MD5]];
            }
            if (finished) {
                finished(image);
            }
        } else {
            if (finished) {
                finished(nil);
            }
        }
    });
}

@end
