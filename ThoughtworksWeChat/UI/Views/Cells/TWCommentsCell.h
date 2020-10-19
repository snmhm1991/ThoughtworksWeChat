//
//  TWCommentsCell.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWCommentsBaseCell.h"

@class TWTweet;
@interface TWCommentsCell : TWCommentsBaseCell

- (void)drawContent:(TWTweet *)tweet;

@end
