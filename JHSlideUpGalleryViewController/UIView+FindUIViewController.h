//
//  UIView+FindUIViewController.h
//  JHSlideUpGalleryDemo
//
//  Created by KaZeKiM Macbook Pro on 3/5/14.
//  Copyright (c) 2014 kazekim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end