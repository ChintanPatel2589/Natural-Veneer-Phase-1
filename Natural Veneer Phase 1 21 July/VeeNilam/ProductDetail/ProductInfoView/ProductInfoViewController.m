//
//  ProductInfoViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/28/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ProductInfoViewController.h"
#define kTitle @"Title"
#define kDesc @"Desc"
@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayProductInfo = [[NSArray alloc]initWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"Series/Process",kTitle,kWS_grouplist_Res_series_name,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Product",kTitle,kWS_grouplist_Res_product_name,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Group",kTitle,kWS_grouplist_Res_group_name,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Description/Comment",kTitle,kWS_grouplist_Res_description,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Grain",kTitle,kWS_grouplist_Res_grain_name,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Exclusivity",kTitle,kWS_grouplist_Res_exclusivity,kDesc, nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Green Rating",kTitle,kWS_grouplist_Res_green_rating,kDesc, nil],nil];
        
    [btnCloseProductInfoView setImage:[CommonMethods imageWithIcon:@"fa-times-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:30] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnCloseProductInfoTapped:(id)sender{
    [self.view removeFromSuperview];
}
#pragma mark - OrderList TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"ProductViewInfoCell";
    ProductViewInfoCell *cell = (ProductViewInfoCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.lblTitle.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    cell.lblDetails.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setBorderWidth:1];
    if (arrayProductInfo.count>0) {
        cell.lblTitle.text = [[arrayProductInfo objectAtIndex:indexPath.row] valueForKey:kTitle];
        cell.lblDetails.text = [CommonMethods checkStr:[self.dataDict valueForKey:[[arrayProductInfo objectAtIndex:indexPath.row] valueForKey:kDesc]]];
    }
    return cell;
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
