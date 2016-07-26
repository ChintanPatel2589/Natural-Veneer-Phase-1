//
//  ProductDetailsViewController.m
//  NaturalVeneer
//
//  Created by Chintan patel on 19/07/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ImagesLocalViewController.h"
@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultData];
}
-(void)setDefaultData
{
    [imgViewProduct sd_setImageWithURL:[NSURL URLWithString:[self.dataDict valueForKey:kWS_grouplist_Res_image]]
                 placeholderImage:nil
                          options:SDWebImageRefreshCached];
    lblProductName.text = [self.dataDict valueForKey:kWS_grouplist_Res_product_name];
    lblProductDesc.text = [self.dataDict valueForKey:kWS_grouplist_Res_group_name];
}

#pragma mark - IBActions
- (IBAction)btnAddtoCartTapped:(id)sender
{
    
}
- (IBAction)btnInfoTapped:(id)sender
{
    
}
- (IBAction)btnPlayTapped:(id)sender
{
    
}
- (IBAction)imageTappedForZoom:(UITapGestureRecognizer *)sender
{
    ImagesLocalViewController *localImage = [[ImagesLocalViewController alloc]init];
    localImage.imageArray = [[NSMutableArray alloc ]initWithObjects:imgViewProduct.image,nil];
    localImage.title = @"PHOTO GALLERY";
    [self.navigationController pushViewController:localImage animated:YES];
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
