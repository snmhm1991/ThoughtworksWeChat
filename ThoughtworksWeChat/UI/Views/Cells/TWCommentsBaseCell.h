//
//  TWCommentsBaseCell.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import <UIKit/UIKit.h>

@interface TWCommentsBaseCell : UITableViewCell

+ (CGFloat)cellHeight:(id)dataModel;
+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;
@end
