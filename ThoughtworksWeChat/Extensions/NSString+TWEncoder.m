//
//  NSString+TWEncoder.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "NSString+TWEncoder.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TWEncoder)

- (NSString *)MD5
{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash uppercaseString];
}

@end
