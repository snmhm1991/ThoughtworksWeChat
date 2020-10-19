//
//  TWImageCacheManager.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/17.
//

#import "TWImageCacheManager.h"

static const NSInteger kMaxCachedImageNumber = 10;

@interface TWImageCacheManager (){
    dispatch_queue_t _gcdBarrierQueue;
}

@property (nonatomic, strong) NSMutableArray *cacheOrderArr;
@property (nonatomic, strong) NSMutableDictionary *cachePoolDic;

@end

@implementation TWImageCacheManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _gcdBarrierQueue = dispatch_queue_create("tw.wechat.imageCacheBarrier", DISPATCH_QUEUE_CONCURRENT);
        self.cacheOrderArr = [@[] mutableCopy];
        self.cachePoolDic = [@{} mutableCopy];
        [self createImgCacheFolder];
    }
    return self;
}

- (void)dealloc
{
    _gcdBarrierQueue = nil;
}

#pragma mark - Public Methods
- (void)cacheImage:(UIImage *)image withKey:(NSString *)nameKey
{
    
    TWImageCacheManager __weak *weakSelf = self;
    dispatch_barrier_async(_gcdBarrierQueue, ^{
        [weakSelf cacheImage:image inMemoryByName:nameKey];
        [weakSelf writeImageToDisk:image withName:nameKey];
    });
}

- (UIImage *)getImageByKey:(NSString *)nameKey
{
    UIImage *imgFindFor = nil;
    
    imgFindFor = self.cachePoolDic[nameKey];
    if (!imgFindFor) {
        imgFindFor = [self getImageFromFileSystem:nameKey];
    }
    
    return imgFindFor;
}

- (void)clearCache
{
    [self.cacheOrderArr removeAllObjects];
    [self.cachePoolDic removeAllObjects];
}

#pragma mark - Private Methods
- (UIImage *)getImageFromFileSystem:(NSString *)imgUrl
{
    NSString *imgFilePath = [self getImgPathByFileName:imgUrl];
    UIImage *imgFindFor = [UIImage imageWithContentsOfFile:imgFilePath];
    if (imgFindFor) {
        [self cacheImage:imgFindFor inMemoryByName:imgUrl];
    }
    return imgFindFor;
}

- (void)writeImageToDisk:(UIImage *)image withName:(NSString *)nameKey
{
    @autoreleasepool {
        NSData* imgData = UIImagePNGRepresentation(image);
        NSString *imgFilePath = [self getImgPathByFileName:nameKey];
        [imgData writeToFile:imgFilePath atomically:YES];
    }
}

- (void)cacheImage:(UIImage *)image inMemoryByName:(NSString *)nameKey
{
    if (!image) {
        return;
    }
    
    if (self.cacheOrderArr.count >= kMaxCachedImageNumber) {
        NSString *firstKey = self.cacheOrderArr[0];
        [self.cachePoolDic removeObjectForKey:firstKey];
        [self.cacheOrderArr removeObjectAtIndex:0];
    }
    
    [self.cachePoolDic setObject:image forKey:nameKey];
    [self.cacheOrderArr addObject:nameKey];
}

- (NSString *)getImgPathByFileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@", [self getImgCacheFolder], fileName];
}

- (NSString *)getImgCacheFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/images",cacheFolder];
}

- (BOOL)createImgCacheFolder
{
    NSString *imgCacheFolder = [self getImgCacheFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imgCacheFolder]) {
        @synchronized(self){
            NSFileManager* manager = [NSFileManager defaultManager];
            NSError *error = nil;
            if (![manager createDirectoryAtPath:imgCacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
