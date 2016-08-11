//
//  DEMONavigationController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ViewController.h"

@interface DEMONavigationController ()

@property (strong, readwrite, nonatomic)DEMOMenuViewController *menuViewController;

@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    //UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.navigationBar.frame.size.height)];
    //UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    //[image setFrame:CGRectMake(50, 0, 100, 25)];
    //float yOfImageLogo = ((view.frame.size.height/2)-(image.frame.size.height/2));
    //[image setFrame:CGRectMake(50, yOfImageLogo, 110, 30)];
    //[view addSubview:image];
    [[UINavigationBar appearance] setBarTintColor:AppGreenColor];
    [[UINavigationBar appearance] setTranslucent:NO];

    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
   // [self.navigationBar addSubview:view];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
        UIViewController *lastViewController = [[self viewControllers] lastObject];
        if(![lastViewController isKindOfClass:[ViewController class]]) {
            [self.frostedViewController presentMenuViewController];
        }
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    UIViewController *lastViewController = [[self viewControllers] lastObject];
    if(![lastViewController isKindOfClass:[ViewController class]]) {
        [self.frostedViewController panGestureRecognized:sender];
    }
}

@end
