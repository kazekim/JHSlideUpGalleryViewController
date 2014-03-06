//
//  ViewController.m
//  JHSlideUpGalleryDemo
//
//  Created by KaZeKiM Macbook Pro on 3/5/14.
//  Copyright (c) 2014 kazekim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.galleryHeight = 200;
    
    NSArray *images  = [NSArray arrayWithObjects:[UIImage imageNamed:@"horses"], [UIImage imageNamed:@"surfer"], [UIImage imageNamed:@"bridge"], nil];
    [self setGalleryImageArray:images];
    
    [self setPanAreaView:self.panView];
    
    self.fullScreenGalleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
