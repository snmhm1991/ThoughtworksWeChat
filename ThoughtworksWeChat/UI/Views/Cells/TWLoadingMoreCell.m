//
//  TWLoadingMoreCell.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWLoadingMoreCell.h"

#define LOADINGMORECELL_PULLUP      @"Pull up to loading more..."
#define LOADINGMORECELL_LOADING     @"Loading..."

@interface TWLoadingMoreCell (){
}

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation TWLoadingMoreCell

- (void)startLoadingAnimation {
    [self stopLoadingAnimation];
    
    TWLoadingMoreCell __weak *weakSelf = self;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.0);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakSelf.activityView.hidden = NO;
        weakSelf.contentLabel.text = LOADINGMORECELL_LOADING;
        [weakSelf.activityView startAnimating];
    });
}

- (void)stopLoadingAnimation {
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    self.contentLabel.text = LOADINGMORECELL_PULLUP;
}

- (void)drawRect:(CGRect)rect {
    if (!self.contentLabel) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = LOADINGMORECELL_PULLUP;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    
    if (!self.activityView) {
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.hidesWhenStopped = YES;
        self.activityView = act;
        self.activityView.frame = CGRectMake(15.0f, 15.0f, self.activityView.frame.size.width, self.activityView.frame.size.height);
        self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.activityView];
    }
}

- (void)layoutSubviews {
}

+ (CGFloat)cellHeight:(id)dataModel {
    return 48.0f;
}

@end
