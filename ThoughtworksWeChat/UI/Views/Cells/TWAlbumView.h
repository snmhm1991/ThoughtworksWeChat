//
//  TWAlbumView.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import <UIKit/UIKit.h>

@interface TWAlbumView : UIView

- (id)initWithFrame:(CGRect)frame byImages:(NSArray *)images;
- (void)draw;
- (void)restore;

@end
