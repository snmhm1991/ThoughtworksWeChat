//
//  TWCommentsView.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWCommentsView.h"
#import "TWComment.h"
#import "TWUser.h"

static const CGFloat kMarginGap = 8.0f;
static const CGFloat kLabelMinHeight = 21.0f;

@interface TWCommentsView () {
    
}

@property (nonatomic, strong) NSArray *comments;
@end

@implementation TWCommentsView

- (id)initWithFrame:(CGRect)frame byComments:(NSArray *)comments {
    self = [super initWithFrame:frame];
    if (self) {
        self.comments = comments;
        self.backgroundColor = RGBCOLOR_HEX(0xF0F0F2);
    }
    return self;
}

- (void)draw {
    CGFloat viewHeight = kMarginGap/2.0f;
    for (int i = 0; i < self.comments.count; i++) {
        TWComment *comm = self.comments[i];
        UILabel *commentLabel = [self getEmptyLabel];
        commentLabel.text = [NSString stringWithFormat:@"%@:%@", comm.senderUser.username, comm.content];
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(kMarginGap/2.0f, viewHeight, commentLabel.frame.size.width, MAX(kLabelMinHeight, commentLabel.frame.size.height));
        [self addSubview:commentLabel];
        viewHeight += (commentLabel.frame.size.height + kMarginGap/2.0);
    }
    viewHeight += (kMarginGap/2.0);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
}

- (UILabel *)getEmptyLabel {
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - kMarginGap, kLabelMinHeight)];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    return contentLabel;
}

@end
