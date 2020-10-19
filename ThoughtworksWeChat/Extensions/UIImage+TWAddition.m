//
//  UIImage+TWAddition.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "UIImage+TWAddition.h"

@implementation UIImage (TWAddition)

- (UIImage*)imageProportionScalingForMaxSize:(CGSize)maxSize {
    UIImage *sourceImage = self;
    UIImage *targetImage = nil;
    
    CGFloat sourceImageWidth = sourceImage.size.width;
    CGFloat sourceImageHeight = sourceImage.size.height;
    
    CGFloat targetWidth = 0.0f;
    CGFloat targetHeight = 0.0f;
    
    if (sourceImageWidth >= sourceImageHeight) { // landscape
        targetWidth = maxSize.width;
        targetHeight = sourceImageHeight * (targetWidth / sourceImageWidth);
    } else { // portrait
        targetHeight = maxSize.height;
        targetWidth = sourceImageWidth * (targetHeight / sourceImageHeight);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return targetImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
