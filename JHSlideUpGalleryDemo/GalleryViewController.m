//
//  GalleryViewController.m
//  JHSlideUpGalleryDemo
//
//  Created by KaZeKiM Macbook Pro on 3/5/14.
//  Copyright (c) 2014 kazekim. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeButtonClicked:(id)sender{
    
    [self.slideUpGalleryViewController slideToStep1];
}

@end
