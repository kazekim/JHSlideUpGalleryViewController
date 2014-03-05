//
//  ETFoursquareImages.h
//  ETFoursquareImagesDemo
//
//  Created by Eugene Trapeznikov on 11/21/13.
//  Copyright (c) 2013 Eugene Trapeznikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ETFoursquareImages : UIView <UIScrollViewDelegate> {
    NSMutableArray *imagesArray;
    
    UIScrollView *imagesScrollView;
    
    int imagesHeight;
    int imagesScrollStart;
    float scrollingKoef;
    
    BOOL pageControlIsChangingPage;
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) int pageControlHeight;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;

-(void)setImages:(NSArray *)_imagesArray;
-(void)setImageUrls:(NSArray *)_urlsArray placeHolder:(UIImage *)placeHolder;

-(void)setImagesHeight:(int)_imagesHeight;

@end
