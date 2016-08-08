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
    [btnBack setImage:[CommonMethods imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    lblViewTitle.text = _viewTitle;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.title = @"PHOTO GALLERY";
    scroller=[[TKScroller alloc]initWithFrame:self.view.bounds array:self.imageArray mode:kScrollModeImageLocal];
    scroller.translatesAutoresizingMaskIntoConstraints=NO;
    scroller.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scroller];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scroller);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[scroller]-1-|" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[scroller]-10-|"
                                                          options: NSLayoutFormatAlignAllRight
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
    [scroller updateFrame];
}

- (IBAction)btnBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
