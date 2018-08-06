//
//  DrawVC.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawVC.h"
#import "DrawTool.h"
@interface DrawVC ()
{
    CGSize _originalImageSize;
    
    CGPoint _prevDraggingPosition;
    UIView *_menuView;
    UISlider *_colorSlider;
    UISlider *_widthSlider;
    UIView *_strokePreview;
    UIView *_strokePreviewBackground;
    UIImageView *_eraserIcon;
}
@property (nonatomic,weak) UIImageView *drawingView;
@property (nonatomic,strong) DrawTool *drawTool;
@end

@implementation DrawVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize imgSize = self.imageRect.size;
    //计算涂鸦层view的frame
    //layoutSubviews之后重新计算frame
    self.drawingView.frame = (CGRect){(self.imageView.width-imgSize.width)/2,(self.imageView.height-imgSize.height)/2,imgSize};
//    _originalImageSize = self.imageRect.size;
//
//    _menuView.frame = self.optionView.bounds;
//    //CGAffineTransformMakeTranslation实现以初始位置为基准,在x轴方向上平移x单位,在y轴方向上平移y单位
//    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-self.bottomView.top);
//    [UIView animateWithDuration:kCLImageToolAnimationDuration
//                     animations:^{
//                         _menuView.transform = CGAffineTransformIdentity;
//                     }];
    
    
    CGFloat W = 70;
    
    _colorSlider.frame = CGRectMake(0, 0, _menuView.width - W - 20, 34);
    _colorSlider.left = 10;
    _colorSlider.top  = 5;
    _colorSlider.value = 0;
    _colorSlider.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    
    _widthSlider.frame = CGRectMake(0, 0, _colorSlider.width, 34);
    _widthSlider.left = 10;
    _widthSlider.top = _colorSlider.bottom + 5;
    _widthSlider.value = 0.1;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    
//    _strokePreview.frame = CGRectMake(0, 0, W - 5, W - 5);
//    _strokePreview.layer.cornerRadius = _strokePreview.height/2;
//    _strokePreview.layer.borderWidth = 1;
//    _strokePreview.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _strokePreview.center = CGPointMake(_menuView.width-W/2, _menuView.height/2);
//    _strokePreviewBackground.frame = _strokePreview.frame;
//    _strokePreviewBackground.layer.cornerRadius = _strokePreviewBackground.height/2;
//    _strokePreviewBackground.alpha = 0.3;
//
//    _eraserIcon.frame = _strokePreview.frame;
//
//    [self colorSliderDidChange:_colorSlider];
//    [self widthSliderDidChange:_widthSlider];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.showImage;
    
    self.drawTool = [[DrawTool alloc]initWithImageEditor:self];
    
    UIImageView *drawingView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    self.drawingView = drawingView;
    [self.imageView addSubview:drawingView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    panGesture.maximumNumberOfTouches = 1;
    _drawingView.userInteractionEnabled = YES;
    [_drawingView addGestureRecognizer:panGesture];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = self.optionView.backgroundColor;
    [self.optionView addSubview:_menuView];
    
    [self setMenu];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}
- (UISlider*)defaultSliderWithWidth:(CGFloat)width
{
    UISlider *slider = [[UISlider alloc] init];
    
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    slider.thumbTintColor = [UIColor whiteColor];
    
    return slider;
}

- (UIImage*)colorSliderBackground
{
    CGSize size = _colorSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(5, (size.height-10)/2, size.width-10, 5);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5].CGPath;
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {
        0.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
    CGFloat locations[] = {0.0f, 0.9/3.0, 1/3.0, 1.5/3.0, 2/3.0, 2.5/3.0, 1.0};
    
    CGPoint startPoint = CGPointMake(5, 0);
    CGPoint endPoint = CGPointMake(size.width-5, 0);
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)widthSliderBackground
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [UIColor lightGrayColor];
    
    CGFloat strRadius = 1;
    CGFloat endRadius = size.height/2 * 0.6;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2 - 2);
    CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIColor*)colorForValue:(CGFloat)value
{
    if(value<1/3.0){
        return [UIColor colorWithWhite:value/0.3 alpha:1];
    }
    return [UIColor colorWithHue:((value-1/3.0)/0.7)*2/3.0 saturation:1 brightness:1 alpha:1];
}

- (void)setMenu
{
    CGSize imgSize = self.imageRect.size;
    //计算涂鸦层view的frame
    self.drawingView.frame = (CGRect){(self.imageView.width-imgSize.width)/2,(self.imageView.height-imgSize.height)/2,imgSize};
    _originalImageSize = self.imageRect.size;
    
    _menuView.frame = self.optionView.bounds;
    //CGAffineTransformMakeTranslation实现以初始位置为基准,在x轴方向上平移x单位,在y轴方向上平移y单位
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-self.bottomView.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformIdentity;
                     }];
    CGFloat W = 70;
    
    _colorSlider = [self defaultSliderWithWidth:_menuView.width - W - 20];
    [_colorSlider addTarget:self action:@selector(colorSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _colorSlider.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    _colorSlider.value = 0;
    [_menuView addSubview:_colorSlider];
    
    _widthSlider = [self defaultSliderWithWidth:_colorSlider.width];
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.1;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_menuView addSubview:_widthSlider];
    
    _strokePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 5, W - 5)];
    _strokePreview.layer.cornerRadius = _strokePreview.height/2;
    _strokePreview.layer.borderWidth = 1;
    //
    _strokePreview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _strokePreview.center = CGPointMake(_menuView.width-W/2, _menuView.height/2);
    [_menuView addSubview:_strokePreview];
    
    _strokePreviewBackground = [[UIView alloc] initWithFrame:_strokePreview.frame];
    _strokePreviewBackground.layer.cornerRadius = _strokePreviewBackground.height/2;
    _strokePreviewBackground.alpha = 0.3;
    [_strokePreviewBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strokePreviewDidTap:)]];
    [_menuView insertSubview:_strokePreviewBackground aboveSubview:_strokePreview];
    
    _eraserIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _eraserIcon.image  =  [UIImage imageNamed:@"btn_eraser.png"];
    _eraserIcon.hidden = YES;
    [_menuView addSubview:_eraserIcon];
    
    [self colorSliderDidChange:_colorSlider];
    [self widthSliderDidChange:_widthSlider];
    
    _menuView.clipsToBounds = NO;
}

- (void)colorSliderDidChange:(UISlider*)sender
{
    if(_eraserIcon.hidden){
        _strokePreview.backgroundColor = [self colorForValue:_colorSlider.value];
        _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
        _colorSlider.thumbTintColor = _strokePreview.backgroundColor;
    }
}

- (void)widthSliderDidChange:(UISlider*)sender
{
    CGFloat scale = MAX(0.05, _widthSlider.value);
    _strokePreview.transform = CGAffineTransformMakeScale(scale, scale);
    _strokePreview.layer.borderWidth = 2/scale;
}

- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender
{
    _eraserIcon.hidden = !_eraserIcon.hidden;
    
    if(_eraserIcon.hidden){
        [self colorSliderDidChange:_colorSlider];
    }
    else{
        _strokePreview.backgroundColor = [UIColor lightGrayColor];
        _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
    }
}

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:_prevDraggingPosition to:currentDraggingPosition];
    }
    _prevDraggingPosition = currentDraggingPosition;
}

-(void)drawLine:(CGPoint)from to:(CGPoint)to
{
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_drawingView.image drawAtPoint:CGPointZero];
    
    CGFloat strokeWidth = MAX(1, _widthSlider.value * 65);
    UIColor *strokeColor = _strokePreview.backgroundColor;
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(!_eraserIcon.hidden){
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    
    _drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}


- (UIImage *)showingImg{
    return self.imageView.image;
}

- (void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    if (self.imageView) {
        self.imageView.image = showImage;
    }
}

- (IBAction)saveClick:(id)sender{
    __weak typeof(self) weakSelf = self;
    [self executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *info) {
        if (weakSelf.imageBlock) {
            self.imageBlock(image);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.showImage.size, self.bgView.bounds);
}
- (void)executeWithCompletionBlock:(void (^)(UIImage *image, NSError *error, NSDictionary *info))completionBlock
{
    UIImage *backgroundImage = self.imageView.image;
    UIImage *foregroundImage = _drawingView.image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImageWithBackgroundImage:backgroundImage foregroundImage:foregroundImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}
- (UIImage*)buildImageWithBackgroundImage:(UIImage*)backgroundImage foregroundImage:(UIImage*)foregroundImage
{
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, NO, backgroundImage.scale);
    
    [backgroundImage drawAtPoint:CGPointZero];
    [foregroundImage drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
