//
//  BlurTool.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BlurTool.h"

static NSString* const kCLBlurToolNormalIconName = @"normalIconAssetsName";
static NSString* const kCLBlurToolCircleIconName = @"circleIconAssetsName";
static NSString* const kCLBlurToolBandIconName = @"bandIconAssetsName";

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
};


@interface BlurCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface BlurBand : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat offset;
@end



@interface BlurTool()
<UIGestureRecognizerDelegate>

@end

@implementation BlurTool
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIImage *_blurImage;
    
    UISlider *_blurSlider;
    
    UIView *_handlerView;
    
    BlurCircle *_circleView;
    BlurBand *_bandView;
    CGRect _bandImageRect;
    
    CLBlurType _blurType;
}


#pragma mark- optional info
- (id)initWithImageEditor:(BlurFocusController *)editor
{
    self = [super init];
    if(self){
        self.editor   = editor;
    }
    return self;
}
+ (NSDictionary*)optionalInfo
{
    return @{
             kCLBlurToolNormalIconName : @"",
             kCLBlurToolCircleIconName : @"",
             kCLBlurToolBandIconName : @""
             };
}

#pragma mark-

- (void)setup
{
    _blurType = kCLBlurTypeNormal;
    _originalImage = self.editor.showingImg;
    _thumbnailImage = [_originalImage resize:self.editor.imageRect.size];
    
    
    _blurSlider = [self sliderWithValue:0.2 minimumValue:0 maximumValue:1];
    _blurSlider.superview.center = CGPointMake(self.editor.bottomView.width/2, self.editor.bottomView.top-30);
    
    _handlerView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    [self.editor.imageView.superview addSubview:_handlerView];
    [self setHandlerView];
    
    [self setDefaultParams];
    [self sliderDidChange:nil];
}

- (void)cleanup
{
    [_blurSlider.superview removeFromSuperview];
    [_handlerView removeFromSuperview];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *indicator = [self indicatorView];
        indicator.center = CGPointMake(self->_handlerView.width/2, self->_handlerView.height/2);
        [self->_handlerView addSubview:indicator];
        [indicator startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = [self->_originalImage gaussBlur:[self getBlurValue]];
        UIImage *image = [self buildResultImage:self->_originalImage withBlurImage:blurImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}
- (UIActivityIndicatorView*)indicatorView
{
    
    // default indicator view
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    indicatorView.layer.cornerRadius = 5;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    return indicatorView;
}

- (CGFloat)getBlurValue
{
    __block CGFloat value = 0;
    
    safe_dispatch_sync_main(^{
        value = self->_blurSlider.value;
    });
    return value;
}

#pragma mark-



- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    UIRotationGestureRecognizer *rot   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    
    tapGesture.delegate = self;
    //panGesture.delegate = self;
    pinch.delegate = self;
    rot.delegate = self;
    
    [_handlerView addGestureRecognizer:tapGesture];
    [_handlerView addGestureRecognizer:panGesture];
    [_handlerView addGestureRecognizer:pinch];
    [_handlerView addGestureRecognizer:rot];
}

- (void)setDefaultParams
{
    CGFloat W = 1.5*MIN(_handlerView.width, _handlerView.height);
    
    _circleView = [[BlurCircle alloc] initWithFrame:CGRectMake(_handlerView.width/2-W/2, _handlerView.height/2-W/2, W, W)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    
    CGFloat H = _handlerView.height;
    CGFloat R = sqrt((_handlerView.width*_handlerView.width) + (_handlerView.height*_handlerView.height));
    
    _bandView = [[BlurBand alloc] initWithFrame:CGRectMake(0, 0, R, H)];
    _bandView.center = CGPointMake(_handlerView.width/2, _handlerView.height/2);
    _bandView.backgroundColor = [UIColor clearColor];
    _bandView.color = [UIColor whiteColor];
    
    CGFloat ratio = _originalImage.size.width / self.editor.imageView.width;
    _bandImageRect = _bandView.frame;
    _bandImageRect.size.width  *= ratio;
    _bandImageRect.size.height *= ratio;
    _bandImageRect.origin.x *= ratio;
    _bandImageRect.origin.y *= ratio;
    
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = NO;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.view addSubview:container];
    
    return slider;
}

- (void)sliderDidChange:(UISlider*)slider
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self->_blurImage = [self->_thumbnailImage gaussBlur:[self getBlurValue]];
        [self buildThumbnailImage];
    });
}

- (void)buildThumbnailImage
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildResultImage:self->_thumbnailImage withBlurImage:self->_blurImage];
        
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *result = blurImage;
    
    switch (_blurType) {
        case kCLBlurTypeCircle:
            result = [self circleBlurImage:image withBlurImage:blurImage];
            break;
        case kCLBlurTypeBand:
            result = [self bandBlurImage:image withBlurImage:blurImage];
            break;
        default:
            break;
    }
    return result;
}

- (UIImage*)blurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage andMask:(UIImage*)maskImage
{
    UIImage *tmp = [image maskedImage:maskImage];
    
    UIGraphicsBeginImageContext(blurImage.size);
    {
        [blurImage drawAtPoint:CGPointZero];
        [tmp drawInRect:CGRectMake(0, 0, blurImage.size.width, blurImage.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    __block CGFloat ratio = 1;
    __block CGRect frame = CGRectZero;
    
    safe_dispatch_sync_main(^{
        ratio = image.size.width / self.editor.imageView.width;
        frame  = self->_circleView.frame;
    });
    
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask = [UIImage imageNamed:@"circle.png"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext() , [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}

- (UIImage*)bandBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    __block CGFloat offset = 0;
    
    safe_dispatch_sync_main(^{
        offset = self->_bandView.offset*image.size.width/self->_handlerView.width;
    });
    
    UIImage *mask = [UIImage imageNamed:@"band.png"];
    
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextRef context =  UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
        
        CGContextSaveGState(context);
        CGFloat ratio = image.size.width / _originalImage.size.width;
        CGFloat Tx = (_bandImageRect.size.width/2  + _bandImageRect.origin.x)*ratio;
        CGFloat Ty = (_bandImageRect.size.height/2 + _bandImageRect.origin.y)*ratio;
        
        CGContextTranslateCTM(context, Tx, Ty);
        CGContextRotateCTM(context, _bandView.rotation);
        CGContextTranslateCTM(context, 0, offset);
        CGContextScaleCTM(context, 1, _bandView.scale);
        CGContextTranslateCTM(context, -Tx, -Ty);
        
        CGRect rct = _bandImageRect;
        rct.size.width  *= ratio;
        rct.size.height *= ratio;
        rct.origin.x    *= ratio;
        rct.origin.y    *= ratio;
        
        [mask drawInRect:rct];
        
        CGContextRestoreGState(context);
        
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}

#pragma mark- Gesture handler

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didSelectedMenuAtIndex:(int)index{
    
    if(index!= _blurType){
        _blurType = index;
        
        [_circleView removeFromSuperview];
        [_bandView removeFromSuperview];
        
        switch (_blurType) {
            case kCLBlurTypeNormal:
                break;
            case kCLBlurTypeCircle:
                [_handlerView addSubview:_circleView];
                [_circleView setNeedsDisplay];
                break;
            case kCLBlurTypeBand:
                [_handlerView addSubview:_bandView];
                [_bandView setNeedsDisplay];
                break;
            default:
                break;
        }
        [self buildThumbnailImage];
    }
}

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    switch (_blurType) {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_handlerView];
            _circleView.center = point;
            [self buildThumbnailImage];
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_handlerView];
            point = CGPointMake(point.x-_handlerView.width/2, point.y-_handlerView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumbnailImage];
            break;
        }
        default:
            break;
    }
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    switch (_blurType) {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_handlerView];
            _circleView.center = point;
            [self buildThumbnailImage];
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_handlerView];
            point = CGPointMake(point.x-_handlerView.width/2, point.y-_handlerView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumbnailImage];
            break;
        }
        default:
            break;
    }
}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    switch (_blurType) {
        case kCLBlurTypeCircle:
        {
            static CGRect initialFrame;
            if (sender.state == UIGestureRecognizerStateBegan) {
                initialFrame = _circleView.frame;
            }
            
            CGFloat scale = sender.scale;
            CGRect rct;
            rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_handlerView.width, _handlerView.height)), 0.3*MIN(_handlerView.width, _handlerView.height));
            rct.size.height = rct.size.width;
            rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
            rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            
            _circleView.frame = rct;
            [self buildThumbnailImage];
            break;
        }
        case kCLBlurTypeBand:
        {
            static CGFloat initialScale;
            if (sender.state == UIGestureRecognizerStateBegan) {
                initialScale = _bandView.scale;
            }
            
            _bandView.scale = MIN(2, MAX(0.2, initialScale * sender.scale));
            [self buildThumbnailImage];
            break;
        }
        default:
            break;
    }
}

- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender
{
    switch (_blurType) {
        case kCLBlurTypeBand:
        {
            static CGFloat initialRotation;
            if (sender.state == UIGestureRecognizerStateBegan) {
                initialRotation = _bandView.rotation;
            }
            
            _bandView.rotation = MIN(M_PI/2, MAX(-M_PI/2, initialRotation + sender.rotation));
            [self buildThumbnailImage];
            break;
        }
        default:
            break;
    }
    
}

@end


#pragma mark- UI components

@implementation BlurCircle

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.x = 0.35*rct.size.width;
    rct.origin.y = 0.35*rct.size.height;
    rct.size.width *= 0.3;
    rct.size.height *= 0.3;
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeEllipseInRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kCLImageToolFadeoutDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

@end




@implementation BlurBand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _scale    = 1;
        _rotation = 0;
        _offset   = 0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self calcTransform];
}

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [self calcTransform];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self calcTransform];
}

- (void)calcTransform
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -self.offset*sin(self.rotation), self.offset*cos(self.rotation));
    transform = CGAffineTransformRotate(transform, self.rotation);
    transform = CGAffineTransformScale(transform, 1, self.scale);
    self.transform = transform;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.y = 0.3*rct.size.height;
    rct.size.height *= 0.4;
    
    CGContextSetLineWidth(context, 1/self.scale);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kCLImageToolFadeoutDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}


@end
