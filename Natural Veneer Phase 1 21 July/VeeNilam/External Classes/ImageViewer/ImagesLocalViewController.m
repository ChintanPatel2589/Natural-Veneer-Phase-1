//
//  ImagesLocalViewController.m
//  TKScroller
//
//  Created by Toseefhusen on 27/02/14.
//  Copyright (c) 2014 Toseef Khilji. All rights reserved.
//


#import "ImagesLocalViewController.h"
@interface ImagesLocalViewController ()

@end

@implementation ImagesLocalViewController
@synthesize scroller;
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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    self.title = @"PHOTO GALLERY";
    // Do any additional setup after loading the view.
    scroller=[[TKScroller alloc]initWithFrame:self.view.frame array:self.imageArray mode:kScrollModeImageLocal];
    
    // scroller.translatesAutoresizingMaskIntoConstraints=NO;
    
    scroller.translatesAutoresizingMaskIntoConstraints=NO;
    scroller.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scroller];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scroller);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[scroller]-1-|" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[scroller]-|"
                                                          options: NSLayoutFormatAlignAllRight
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
