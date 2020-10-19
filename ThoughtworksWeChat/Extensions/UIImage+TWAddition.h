//
//  UIImage+TWAddition.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import <UIKit/UIKit.h>

@interface UIImage (TWAddition)

- (UIImage*)imageProportionScalingForMaxSize:(CGSize)maxSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
