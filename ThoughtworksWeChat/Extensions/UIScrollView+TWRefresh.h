//
//  UIScrollView+TWRefresh.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TWScrollViewRefreshDelegate <NSObject>

@optional
- (void)beginPullToRefreshing:(UIScrollView *)scrollView;
- (void)beginUpToRefresh:(UIScrollView *)scrollView;
- (void)stopUptoRefreshAnimation:(UIScrollView *)scrollView;
- (void)didGetTimeOutSign:(UIScrollView *)scrollView;

@end

@interface TWScrollHeaderView : UIView

@property (strong,nonatomic) UIImageView *refreshView;            //刷新图片的ImageView
@property (strong,nonatomic) UIImage     *dropImage;            //下拉时图片
@property (strong,nonatomic) UIImage     *refreshImage;         //刷新时旋转图片
@property (assign,nonatomic) float        topMargin;
@property (assign,nonatomic) float        defaultTopInset;      //默认content inset
@property (assign,nonatomic) BOOL         isBecomeCircle;        //指针变为圆圈
@property (assign,nonatomic) BOOL         enablePulltoRefesh;        //下拉刷新是否可用

@end

@interface TWScrollFooterView : UIView

@property (assign,nonatomic) BOOL                          enableUptoRefesh;        //上拉刷新是否可用
@property (assign,nonatomic) BOOL                          isGetMore;            //是否正在上拉加载更多
@property (strong,nonatomic) UIActivityIndicatorView     * activityView;            //上拉刷新时的旋转圆环
@property (strong,nonatomic) UILabel                     * upLabel;                //上拉刷新的文字提示
@property (strong,nonatomic) NSString                    * footerViewText;        //底部显示文本
@property (assign,nonatomic) float                         defaultBottomInset;   //默认底部content inset


@end

@interface UIScrollView (TWRefresh)

- (void)stopAnimation;
- (void)scrollTableToFoot:(BOOL)animated;
- (void)startRefreshing:(BOOL)enableNotify;
- (void)playRefreshAnimation;
- (void)showFooterNoMore;
- (void)showFooterNoMoreAfterAnimationFinished;
- (void)showLoadingMore:(BOOL)isShow;
- (void)loadingFailed;

@property (strong, nonatomic) TWScrollHeaderView  *scrollHeaderView;
@property (strong, nonatomic) TWScrollFooterView  *scrollFooterView;
@property (weak, nonatomic) id<TWScrollViewRefreshDelegate> refreshDelegate;

@end

NS_ASSUME_NONNULL_END
