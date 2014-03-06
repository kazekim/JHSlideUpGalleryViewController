//
//  JHSlideUpGalleryViewController.m
//  JHSlideUpGalleryDemo
//
//  Created by KaZeKiM Macbook Pro on 3/5/14.
//  Copyright (c) 2014 kazekim. All rights reserved.
//

#import "JHSlideUpGalleryViewController.h"

@interface JHSlideUpGalleryViewController ()<UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGPoint previousVelocity;

@end

@implementation UIViewController(SlideUpGalleryView)

- (JHSlideUpGalleryViewController *)slideUpGalleryViewController{
    UIViewController *viewController = [self.view.superview firstAvailableUIViewController];
    
    while (!(viewController == nil || [viewController isKindOfClass:[JHSlideUpGalleryViewController class]])) {
        viewController = viewController.parentViewController;
    }
    
    return (JHSlideUpGalleryViewController *)viewController;
}

@end

@implementation JHSlideUpGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupValue];
    [self initGalleryView];
    
    [self setPanAreaView:self.view];
    
    [self addGestures];
}

-(void)setupValue
{
    _galleryHeight = 200;
    _animationDuration = 0.5f;
    _stateShowBottomStep = showBottomStepHide;
    _showBottomStep = showBottomStepHide;
    
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.overlayView setBackgroundColor:[UIColor blackColor]];
    [self.overlayView setAlpha:0.0f];
    [self.view addSubview:self.overlayView];
    [self.overlayView setHidden:YES];
}

-(void)initGalleryView
{
    if(self.galleryView){
        [self.galleryView removeFromSuperview];
        self.galleryView = Nil;
    }
    self.galleryView = [[ETFoursquareImages alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.galleryHeight)];
    [self.galleryView setImagesHeight:self.galleryHeight];
    if([[self.imageArray objectAtIndex:0] isKindOfClass:[NSString class]]){
        [self.galleryView setImageUrls:self.imageArray placeHolder:self.placeHolderImage];
    }else{
        [self.galleryView setImages:self.imageArray];
    }
    
    self.galleryView.layer.shouldRasterize = YES;
    self.galleryView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.galleryView.layer.shadowOpacity = 0.5f;
    self.galleryView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    self.galleryView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.galleryView.layer.shadowRadius = 4.0f;
    self.galleryView.alpha = 1;
    
    CGRect frame = self.galleryView.frame;
    frame.origin.y = self.view.frame.size.height;
    self.galleryView.frame = frame;
    
    [self.view addSubview:self.galleryView];
}

-(void)setGalleryHeight:(int)height
{
    _galleryHeight = height;
    
    [self initGalleryView];
}

-(void)setGalleryImageArray:(NSArray *) images
{
    self.imageArray = images;
    [self.galleryView setImages:images];
}

-(void)setGalleryImageUrlArray:(NSArray *) images placeHolder:(UIImage *)placeHolder
{
    self.imageArray = images;
    [self.galleryView setImageUrls:images placeHolder:placeHolder];
}

- (void)setFullScreenGalleryViewController:(UIViewController *)fullScreenGalleryViewController
{
    [fullScreenGalleryViewController.view removeFromSuperview];
    [fullScreenGalleryViewController willMoveToParentViewController:nil];
    [fullScreenGalleryViewController removeFromParentViewController];
    
    self->_fullScreenGalleryViewController = fullScreenGalleryViewController;
    
    CGRect frame = self.fullScreenGalleryViewController.view.frame;
    frame.origin.y = self.view.frame.size.height;
    self.fullScreenGalleryViewController.view.frame = frame;
    
    [self.fullScreenGalleryViewController.view setHidden:YES];
    [self.fullScreenGalleryViewController.view setAlpha:0.0f];

    [self.view addSubview:fullScreenGalleryViewController.view];
}

-(void)setPanAreaView:(UIView *)panAreaView{
    _panAreaView = panAreaView;
    
    [self addGestures];
}

#pragma mark -
#pragma mark UIGestureRecognizers

- (void)addGestures
{
    if (!self->_panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
        self.panGesture.delegate = self;
    }
    if (!self->_tapGesture) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClose:)];
    }
    
    [self attachTapGesture];
    [self.panAreaView addGestureRecognizer:self.panGesture];
}

- (void)attachTapGesture
{
    [self.overlayView removeGestureRecognizer:self.tapGesture];
    [self.overlayView addGestureRecognizer:self.tapGesture];
    [self.overlayView addGestureRecognizer:self.panGesture];
}

- (void)removeTapGestures
{
    [self.overlayView removeGestureRecognizer:self.tapGesture];
    [self.panAreaView addGestureRecognizer:self.panGesture];
}

- (void)addGalleryGestures
{
    if (!self->_tapGalleryGesture) {
        self.tapGalleryGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowFullScreenGallery:)];
    }
    
    [self attachGalleryGesture];
}

- (void)attachGalleryGesture
{
    [self removeGalleryGestures];
    [self.galleryView addGestureRecognizer:self.tapGalleryGesture];
}

- (void)removeGalleryGestures
{
    [self.galleryView removeGestureRecognizer:self.tapGalleryGesture];
}


- (void)dragView:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    UIView *senderView = self.view;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:senderView];
    
    
    switch ([(UIPanGestureRecognizer*)sender state]) {
        case UIGestureRecognizerStateBegan:{
            [self.view endEditing:YES];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            switch (self.showBottomStep) {
                case showBottomStepHide:
                {
                    [self snapToOrigin];
                    break;
                }
                case showBottomStep1:
                {
                    [self slideToStep1];
                    break;
                }
                case showBottomStep2:
                {
                    [self slideToStep2];
                    break;
                }
                default:
                    break;
            }
           
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGRect frame = self.galleryView.frame;
            CGRect fsGalleryFrame = self.fullScreenGalleryViewController.view.frame;
            float translateY = translatedPoint.y*frame.size.height/self.view.frame.size.height;
            CGPoint markPoint = CGPointMake(0, self.view.frame.size.height - self.galleryView.frame.size.height/2);
            
            if(self.stateShowBottomStep == showBottomStepHide){

                [self.overlayView setHidden:NO];
                
                if(frame.origin.y + translateY > self.view.frame.size.height - self.galleryView.frame.size.height){
                    frame.origin.y += translateY;
                    fsGalleryFrame.origin.y = frame.origin.y;
                    
                }else{
                    frame.origin.y = self.view.frame.size.height - self.galleryView.frame.size.height;
                    fsGalleryFrame.origin.y = frame.origin.y;
                }
                self.galleryView.frame = frame;
                self.fullScreenGalleryViewController.view.frame = fsGalleryFrame;
                
                [self.overlayView setAlpha:0.5f];
                
                if (markPoint.y > self.galleryView.frame.origin.y) {
                    self.showBottomStep = showBottomStep1;
                }else {
                    self.showBottomStep = showBottomStepHide;
                }

            }else if(self.stateShowBottomStep == showBottomStep1){
                
                if(fsGalleryFrame.origin.y +translateY > 0 && fsGalleryFrame.origin.y +translateY < frame.origin.y){

                    fsGalleryFrame.origin.y += translateY;
                    
                    if(fsGalleryFrame.origin.y < frame.origin.y){
                        [self showFullScreenGalleryView];
                    }
                    
                }else if(fsGalleryFrame.origin.y +translateY > frame.origin.y){
 
                    fsGalleryFrame.origin.y += translateY;
                    frame.origin.y = fsGalleryFrame.origin.y;
                    [self showGalleryView];
                    
                }else{
                    fsGalleryFrame.origin.y = 0;
                }
                
                self.fullScreenGalleryViewController.view.frame = fsGalleryFrame;
                self.galleryView.frame = frame;
                
                if (fsGalleryFrame.origin.y > markPoint.y) {
                    self.showBottomStep = showBottomStepHide;
                }else if (fsGalleryFrame.origin.y > frame.origin.y/2) {
                    self.showBottomStep = showBottomStep1;
                }else {
                    self.showBottomStep = showBottomStep2;
                }
                
            }
            
            _previousVelocity = velocity;

            break;
        }
  
        default:
            break;
    }

}

- (void)tapClose:(id)sender
{
    [self snapToOrigin];
}

-(void)tapShowFullScreenGallery:(id)sender
{
    [self slideToStep2];
}

- (void)didFinishSliding
{}

#pragma mark Animate

- (void)slideToStep1
{
    [self.overlayView setHidden:NO];
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.overlayView setAlpha:0.5f];
        self.galleryView.frame = CGRectMake(0, self.view.frame.size.height - self.galleryView.frame.size.height, self.galleryView.frame.size.width, self.galleryView.frame.size.height);
        self.fullScreenGalleryViewController.view.frame = CGRectMake(0, self.view.frame.size.height - self.galleryView.frame.size.height, self.fullScreenGalleryViewController.view.frame.size.width, self.fullScreenGalleryViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        
        
        [self didFinishSliding];
        [self addGalleryGestures];
        [self attachTapGesture];
        self.showBottomStep = showBottomStep1;
        self.stateShowBottomStep = showBottomStep1;
        
        [self showGalleryView];
    }];
}

- (void)slideToStep2
{
    [self showFullScreenGalleryView];
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.fullScreenGalleryViewController.view.frame = CGRectMake(0, 0, self.fullScreenGalleryViewController.view.frame.size.width, self.fullScreenGalleryViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        
        
        [self removeTapGestures];
        [self removeGalleryGestures];
        [self didFinishSliding];
        self.showBottomStep = showBottomStep2;
        self.stateShowBottomStep = showBottomStep2;
    }];
}

- (void)snapToOrigin
{
    [self.overlayView setAlpha:0.0f];
    [self.overlayView setHidden:YES];
    self.showBottomStep = showBottomStepHide;
    [UIView animateWithDuration:self.animationDuration / 2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect frame = CGRectMake(0, self.view.frame.size.height, self.galleryView.frame.size.width, self.galleryView.frame.size.height);
        self.galleryView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeTapGestures];
        [self didFinishSliding];
        [self removeGalleryGestures];
        self.showBottomStep = showBottomStepHide;
        self.stateShowBottomStep = showBottomStepHide;
    }];
}

- (void)showGalleryView
{
    if([self.galleryView isHidden]){
        [self.galleryView setHidden:NO];
        [UIView animateWithDuration:self.animationDuration / 2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.galleryView setAlpha:1.0f];
            [self.fullScreenGalleryViewController.view setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.fullScreenGalleryViewController.view setHidden:YES];
            
            [self attachGalleryGesture];
            [self attachTapGesture];
        }];
    }else{
        
    }
}

- (void)showFullScreenGalleryView
{
    if([self.fullScreenGalleryViewController.view isHidden]){
        [self.fullScreenGalleryViewController.view setHidden:NO];
        [UIView animateWithDuration:self.animationDuration / 2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.galleryView setAlpha:0.0f];
            [self.fullScreenGalleryViewController.view setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [self.galleryView setHidden:YES];
            
            [self removeGalleryGestures];
            [self removeTapGestures];
        }];
    }
}

@end
