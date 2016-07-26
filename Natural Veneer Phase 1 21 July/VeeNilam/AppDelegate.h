//
//  AppDelegate.h
//  VeeNilam
//
//  Created by Vrushank Rindani on 5/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "REFrostedViewController.h"
#import "ProductListViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id RootViewController;
 
@property (strong, nonatomic) UINavigationController *navController;
-(void)setRootLoginViewWithoutMenu;
-(void)setRootViewWithMenu;
@end

