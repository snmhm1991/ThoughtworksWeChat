//
//  TWAlbumView.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWAlbumView.h"
#import "TWImageCacheManager.h"

static const CGFloat kMaxWidth = 170.0f;
static const CGFloat kMaxHeight = 170.0f;
static const CGFloat kMarginGap = 8.0f;

@interface TWAlbumView (){
    
}

@property (nonatomic, strong) NSArray *imagesArr;

@end
@implementation TWAlbumView

- (id)initWithFrame:(CGRect)frame byImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.imagesArr = images;
    }
    return self;
}

- (void)restore {
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)draw {
    if (1 == self.imagesArr.count) {
        [self drawOnePhoto];
    } else {
        [self drawMutiplePhotos];
    }
}

#pragma mark - Private Methods
- (void)drawOnePhoto {
    NSString *imageURL = self.imagesArr[0];
    UIImage *imageFindFor = [[TWImageCacheManager sharedInstance] getImageByKey:[imageURL MD5]];
    if (!imageFindFor) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMarginGap, kMaxWidth, kMaxHeight)];
        [self addSubview:imageView];
        [imageView setImageWithUrlString:imageURL];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kMaxHeight + 2 * kMarginGap);
        
    } else {
        UIImage *image = imageFindFor;
        image = [image imageProportionScalingForMaxSize:CGSizeMake(kMaxWidth, kMaxHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMarginGap, image.size.width, image.size.height)];
        imageView.image = image;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, image.size.height + 2 * kMarginGap);
    }
}

- (void)drawMutiplePhotos {
    CGFloat viewHeight = 0.0f;
    CGFloat squareSize = (self.frame.size.width - 2 * kMarginGap) / 3.0f;
    
    for (int i = 0; i < self.imagesArr.count; i++) {
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        
        NSString *imageURL = self.imagesArr[i];
        UIImage *imageFindFor = [[TWImageCacheManager sharedInstance] getImageByKey:[imageURL MD5]];
        if (!imageFindFor) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(column * (squareSize + kMarginGap), row * (squareSize + kMarginGap), squareSize, squareSize)];
            [self addSubview:imageView];
            [imageView setImageWithUrlString:imageURL];
            
        } else {
            UIImage *image = imageFindFor;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(column * (squareSize + kMarginGap), row * (squareSize + kMarginGap), squareSize, squareSize)];
            imageView.image = image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:imageView];
        }
        
        viewHeight = (row + 1) * (squareSize + kMarginGap) + kMarginGap;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
}


@end
