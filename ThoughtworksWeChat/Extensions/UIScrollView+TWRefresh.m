//
//  UIScrollView+TWRefresh.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "UIScrollView+TWRefresh.h"
#import <objc/runtime.h>

#define RereshViewWidth                     30
#define RefreshBegin                        60
#define TableFooterHeight                   44
#define RefreshAnimationHideenDelay         0.2
#define RefreshingAnimation                 @"rotationAnimation"

#define Loading                             @"我很努力地加载中..."
#define NoMore                              @"哎呀,没有了哦~"

static char kTWScrollRefreshDelegate;
static char kTWScrollIsRefreshing;
static char kTWScrollIsObserving;
static char kTWScrollHeaderView;
static char kTWScrollFooterView;
static char kObservingContentChangesContext;

@interface  UIScrollView ()

@property (assign, nonatomic) BOOL isRefreshing;
@property (assign, nonatomic) BOOL isObserving;

@end

@implementation UIScrollView (TWRefresh)

- (id<TWScrollViewRefreshDelegate>)refreshDelegate
{
    return objc_getAssociatedObject(self, &kTWScrollRefreshDelegate);
}

- (void)setRefreshDelegate:(id<TWScrollViewRefreshDelegate>)refreshDelegate
{
    self.isRefreshing = NO;
    self.scrollHeaderView.hidden = YES;
    [self setupNotifications];

    objc_setAssociatedObject(self, &kTWScrollRefreshDelegate, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isRefreshing
{
    return [objc_getAssociatedObject(self, &kTWScrollIsRefreshing) boolValue];
}

- (void)setIsRefreshing:(BOOL)isRefreshing
{
    objc_setAssociatedObject(self, &kTWScrollIsRefreshing, @(isRefreshing), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isObserving
{
    return [objc_getAssociatedObject(self, &kTWScrollIsObserving) boolValue];
}

- (void)setIsObserving:(BOOL)isObserving
{
    objc_setAssociatedObject(self, &kTWScrollIsObserving, @(isObserving), OBJC_ASSOCIATION_ASSIGN);
}

- (TWScrollHeaderView *)scrollHeaderView
{
    TWScrollHeaderView * headerView = objc_getAssociatedObject(self, &kTWScrollHeaderView);
    if(!headerView){
        headerView = [[TWScrollHeaderView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:headerView];
        [headerView setHidden:YES];
        self.scrollHeaderView = headerView;
    }
    return headerView;
}

- (TWScrollFooterView *)scrollFooterView
{
    TWScrollFooterView * footerView = objc_getAssociatedObject(self, &kTWScrollFooterView);
    if(!footerView){
        footerView = [[TWScrollFooterView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, TableFooterHeight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
        footerView.hidden = YES;
        self.scrollFooterView = footerView;
    }
    return footerView;
}

- (void)setScrollHeaderView:(TWScrollHeaderView *)scrollHeaderView
{
    objc_setAssociatedObject(self, &kTWScrollHeaderView, scrollHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setScrollFooterView:(TWScrollFooterView *)scrollFooterView
{
     objc_setAssociatedObject(self, &kTWScrollFooterView, scrollFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupNotifications
{
    self.isObserving = YES;
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:&kObservingContentChangesContext];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:&kObservingContentChangesContext];
    [self addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:&kObservingContentChangesContext];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(self.superview && newSuperview == nil){
        if(self.isObserving){
            self.isObserving = NO;
            [self removeObserver:self forKeyPath:@"contentSize" context:&kObservingContentChangesContext];
            [self removeObserver:self forKeyPath:@"contentOffset" context:&kObservingContentChangesContext];
            [self removeObserver:self forKeyPath:@"pan.state" context:&kObservingContentChangesContext];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onTimeOut) object:nil];
    }
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Notifications & KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == &kObservingContentChangesContext){
        if([keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"contentOffset"]){
            [self scrollViewDidScroll];
        }
        else if([keyPath isEqualToString:@"pan.state"]){
            NSInteger state = [[change objectForKey:@"new"] integerValue];
            if(state == UIGestureRecognizerStateEnded){
                [self scrollViewEndDraging];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private

-(void)scrollViewDidScroll
{
    if(self.isRefreshing){
        return;
    }
    int offsetY = self.contentOffset.y;
    if(offsetY < 0){
        if(self.scrollHeaderView.enablePulltoRefesh){
            self.scrollHeaderView.height = -offsetY + 1;
            self.scrollHeaderView.top = offsetY - 1;
            [self.scrollHeaderView setHidden:NO];
            
            [self showRefresh:offsetY];
        }
    }else{
        [self.scrollHeaderView setHidden:YES];
    }
    
    int contentHeight=self.contentSize.height;
    if(contentHeight>0 && offsetY>0  && offsetY > (contentHeight - self.frame.size.height) + self.scrollFooterView.defaultBottomInset){
        if(!self.isRefreshing && !self.scrollFooterView.isGetMore && self.scrollFooterView.enableUptoRefesh){
            self.scrollFooterView.isGetMore=YES;
            [self showLoadingMore:YES];
            if([self.refreshDelegate respondsToSelector:@selector(beginUpToRefresh:)]){
                [self.refreshDelegate beginUpToRefresh:self];
            }
        }
    }
    //content size变化时重设footer位置
    if(!self.scrollFooterView.hidden){
        self.scrollFooterView.top = self.contentSize.height;
    }
}

- (void)scrollViewEndDraging
{
    int offsetY=self.contentOffset.y;
    if(offsetY <= -RefreshBegin - self.scrollHeaderView.defaultTopInset && !self.isRefreshing && [self.scrollHeaderView.refreshView.image isEqual:self.scrollHeaderView.refreshImage]){                   //距离达到开始刷新的最小值
        [self startRefreshing:YES];
    }
}

- (void)showRefresh:(int)offsetY
{
    self.scrollHeaderView.refreshView.bottom = self.scrollHeaderView.height - (RefreshBegin - RereshViewWidth) / 2 + self.scrollHeaderView.topMargin;
    //NSLog(@"%f,top:%f,topMargin:%f",self.scrollHeaderView.height,self.scrollHeaderView.refreshView.top,self.scrollHeaderView.topMargin);
    BOOL isBeginRefresh= (offsetY <= -RefreshBegin - self.scrollHeaderView.defaultTopInset);
    
    if(!self.isRefreshing){
        UIImage * image = ( isBeginRefresh  ? self.scrollHeaderView.refreshImage : self.scrollHeaderView.dropImage);
        self.scrollHeaderView.refreshView.image = image;
        self.scrollHeaderView.refreshView.hidden = NO;
    }
    
    if(isBeginRefresh && !self.scrollHeaderView.isBecomeCircle){
        self.scrollHeaderView.isBecomeCircle=YES;

        [UIView animateWithDuration:0.1 animations:^{
            float rotateAngle = M_PI/2;
            CGAffineTransform transform =CGAffineTransformMakeRotation(rotateAngle);
            self.scrollHeaderView.refreshView.transform = transform;
        }];
    }
    if(!isBeginRefresh){
        self.scrollHeaderView.isBecomeCircle=NO;
        self.scrollHeaderView.refreshView.transform = CGAffineTransformIdentity;
    }
    
}

- (void)startRefreshing:(BOOL)enableNotify
{
    self.scrollFooterView.isGetMore=NO;
    self.isRefreshing=YES;
    [self.scrollHeaderView.refreshView setImage:self.scrollHeaderView.refreshImage];

    
    [self.scrollHeaderView.refreshView setHidden:NO];
    [self playRefreshAnimationPrivate:self.scrollHeaderView.refreshView];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self setContentInset:UIEdgeInsetsMake(RefreshBegin + self.scrollHeaderView.defaultTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)];
    }completion:^(BOOL finished) {
        if(enableNotify){
            if([self.refreshDelegate respondsToSelector:@selector(beginPullToRefreshing:)]){
                [self.refreshDelegate beginPullToRefreshing:self];
            }
        }else{
            [self stopAnimation];
        }
    }];
}

- (void)playRefreshAnimationPrivate:(UIImageView*)imgView
{
    [self startAnimation:imgView from:M_PI/2 to:M_PI*5/2 duration:0.5 repeat:HUGE_VALF];
    [self performSelector:@selector(onTimeOut) withObject:nil afterDelay:10];                    //30S不出现结果直接退出
}

- (void)startAnimation:(UIImageView*)imgView from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration repeat:(CGFloat)repeat
{
    self.scrollHeaderView.refreshView.image = self.scrollHeaderView.refreshImage;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:from]; // 起始角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: to ];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeat;
    
    [imgView.layer addAnimation:rotationAnimation forKey:RefreshingAnimation];
}
- (void)doStopAnimation
{
    self.scrollHeaderView.isBecomeCircle=NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onTimeOut) object:nil];            //取消定时器
    
    [UIView animateWithDuration:RefreshAnimationHideenDelay delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollHeaderView.height=0;
        [self setContentInset:UIEdgeInsetsMake(self.scrollHeaderView.defaultTopInset,self.contentInset.left, self.contentInset.bottom, self.contentInset.right)];
    } completion:^(BOOL success){
        self.isRefreshing=NO;
        [self setContentInset:UIEdgeInsetsMake(self.scrollHeaderView.defaultTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)];
    }];
    [self.scrollHeaderView.refreshView.layer removeAnimationForKey:RefreshingAnimation];
    self.scrollHeaderView.refreshView.transform = CGAffineTransformIdentity;
    self.scrollHeaderView.refreshView.image = self.scrollHeaderView.dropImage;
}


- (void)playRefreshAnimation
{
    [self playRefreshAnimationPrivate:self.scrollHeaderView.refreshView];
}

- (void)stopAnimation
{
    [self performSelector:@selector(doStopAnimation) withObject:self afterDelay:RefreshAnimationHideenDelay];
}

- (void)scrollTableToFoot:(BOOL)animated
{
    if (self.contentSize.height > self.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height-self.height) animated:animated];
    }
}

- (void)showFooterNoMore
{
    [self showFooterNoMoreDelay];
}

- (void)showFooterNoMoreAfterAnimationFinished
{
    [self performSelector:@selector(showFooterNoMoreDelay) withObject:nil afterDelay:RefreshAnimationHideenDelay];
}

- (void)showFooterNoMoreDelay
{
    self.scrollFooterView.isGetMore=YES;
    [self.scrollFooterView.activityView stopAnimating];
    [self.scrollFooterView.upLabel setText: self.scrollFooterView.footerViewText];
    [self hiddenFooter:NO];
}

- (void)showLoadingMore:(BOOL)isShow
{
    [self.scrollFooterView.upLabel setText:[NSString stringWithFormat:@"      %@",Loading]];
    [self.scrollFooterView.activityView startAnimating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollFooterView.isGetMore = isShow;
        [self hiddenFooter:!isShow];
    });
}

- (void)loadingFailed
{
    [self showLoadingMore:NO];
    self.scrollFooterView.enableUptoRefesh = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollFooterView.enableUptoRefesh = YES;
    });
}

- (void)hiddenFooter:(BOOL)hidden
{
    float footerHeight = (hidden ? 0 : TableFooterHeight);

    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left,  self.scrollFooterView.defaultBottomInset + footerHeight, self.contentInset.right);
    self.scrollFooterView.top = self.contentSize.height;
    self.scrollFooterView.hidden = hidden;
    [self addSubview:self.scrollFooterView];
}

- (void)onTimeOut
{
    if(self.isRefreshing){
        if([self.refreshDelegate respondsToSelector:@selector(didGetTimeOutSign:)]){
            [self.refreshDelegate didGetTimeOutSign:self];
        }
    }
    [self doStopAnimation];
}

@end

@interface TWScrollHeaderView ()

@end

@implementation TWScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.isBecomeCircle=NO;
        self.enablePulltoRefesh = YES;
        self.clipsToBounds = YES;
        self.dropImage = [UIImage imageNamed:@"loadmore_arrow"];
        self.refreshImage = [UIImage imageNamed:@"loadmore_refreshing"];
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-RereshViewWidth)/2, 0, RereshViewWidth, RereshViewWidth)];
    [self.refreshView setImage:self.dropImage];
    [self.refreshView setContentMode:UIViewContentModeCenter];
    [self.refreshView setHidden:YES];
    [self addSubview:self.refreshView];
}

@end

@implementation TWScrollFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.isGetMore = NO;
    self.enableUptoRefesh = YES;
    self.footerViewText = NoMore;
    
    self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, TableFooterHeight)];
    [self.upLabel setBackgroundColor:[UIColor clearColor]];
    [self.upLabel setTextColor:color_with_rgb(174, 174, 174)];
    [self.upLabel setText:Loading];
    [self.upLabel setFont:[UIFont systemFontOfSize:15]];
    [self.upLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.activityView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80 , (TableFooterHeight-30)/2, 30, 30)];
    [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView startAnimating];
    
    [self addSubview:self.activityView];
    [self addSubview:self.upLabel];
}

@end
