//
//  TWMomentsTableHeaderView.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWMomentsTableHeaderView.h"

@interface TWMomentsTableHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation TWMomentsTableHeaderView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    [self addSubview:self.imageView];
    [self addSubview:self.avatarView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarView.right = self.width - 15.f;
    self.avatarView.bottom = self.height + 20.f;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 4.f;
        _avatarView.backgroundColor = color_with_rgba(0, 0, 0, 0.5);
    }
    return _avatarView;
}

- (void)setAvatarImageUrl:(NSString *)avatarImageUrl
{
    _avatarImageUrl = avatarImageUrl;
    [self.avatarView setImageWithUrlString:avatarImageUrl];
}

- (void)setProfileImageUrl:(NSString *)profileImageUrl
{
    _profileImageUrl = profileImageUrl;
    [self.imageView setImageWithUrlString:profileImageUrl];
}

@end
