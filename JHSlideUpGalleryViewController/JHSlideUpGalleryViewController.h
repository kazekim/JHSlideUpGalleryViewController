//
//  JHSlideUpGalleryViewController.h
//  JHSlideUpGalleryDemo
//
//  Created by KaZeKiM Macbook Pro on 3/5/14.
//  Copyright (c) 2014 kazekim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETFoursquareImages.h"
#import "UIView+FindUIViewController.h"

@interface JHSlideUpGalleryViewController : UIViewController

typedef NS_ENUM(NSInteger, ShowBottomStep)
{
    showBottomStepHide,
    showBottomStep1,
    showBottomStep2
};

@property (strong,nonatomic) UIView *panAreaView;
@property (strong,nonatomic) UIImage *placeHolderImage;

@property (nonatomic) int galleryHeight;
@property (nonatomic) CGFloat animationDuration;
@property (strong, nonatomic) NSArray *imageArray;

@property (strong,nonatomic) UIView *overlayView;
@property (strong, nonatomic) IBOutlet ETFoursquareImages *galleryView;
@property (strong, nonatomic) IBOutlet UIViewController *fullScreenGalleryViewController;

#pragma mark Gestures
@property (strong, nonatomic) UIGestureRecognizer *panGesture;
@property (strong, nonatomic) UIGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIGestureRecognizer *tapGalleryGesture;

#pragma mark Visibility
@property ShowBottomStep showBottomStep;
@property ShowBottomStep stateShowBottomStep;

#pragma mark Animations
- (void)slideToStep1;
- (void)slideToStep2;
- (void)snapToOrigin;

#pragma mark Gallery Manage
-(void)setGalleryHeight:(int)height;
-(void)setGalleryImageArray:(NSArray *) images;
-(void)setGalleryImageUrlArray:(NSArray *) images placeHolder:(UIImage *)placeHolder;


@end


@interface UIViewController(SlideUpGalleryView)

- (JHSlideUpGalleryViewController *)slideUpGalleryViewController;

@end