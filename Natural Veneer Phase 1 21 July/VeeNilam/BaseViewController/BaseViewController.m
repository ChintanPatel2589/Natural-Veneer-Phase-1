//
//  BaseViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/27/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderFormViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;
    viewNavigation.backgroundColor = AppGreenColor;
    [btnMenu setImage:[UIImage imageWithIcon:@"fa-bars" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:25] forState:UIControlStateNormal];
    [btnSearch setImage:[CommonMethods imageWithIcon:@"fa-search" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    [btnCart setImage:[CommonMethods imageWithIcon:@"fa-cart-arrow-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    [btnClone setImage:[CommonMethods imageWithIcon:@"fa-clone" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    [btnForm setImage:[CommonMethods imageWithIcon:@"fa-building-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    [btnAlert setImage:[CommonMethods imageWithIcon:@"fa-bell-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - IBActions
- (IBAction)btnTapped:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            {
            
            }
            break;
        case 3:
        {
            [self gotoOrderForm];
        }
            break;
            
        default:
            break;
    }
}
- (void)gotoOrderForm
{
    OrderFormViewController *orderOBJ = [[OrderFormViewController alloc] initWithNibName:@"OrderFormViewController" bundle:nil];
    [self.navigationController pushViewController:orderOBJ animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end