//
//  TWLoadingView.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "TWLoadingView.h"

@interface TWLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView * activityView;

@end

@implementation TWLoadingView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 100, 100)]) {
        self.backgroundColor = color_with_rgba(0, 0, 0, 0.7);
        self.layer.cornerRadius = 12.f;
        [self addSubview:self.activityView];
    }
    return self;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
    }
    return _activityView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.activityView.center = CGPointMake(self.width / 2 + 3, self.height / 2);
}

@end
