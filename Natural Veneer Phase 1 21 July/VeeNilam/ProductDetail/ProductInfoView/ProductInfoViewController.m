//
//  ProductInfoViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/28/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ProductInfoViewController.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnCloseProductInfoView setImage:[CommonMethods imageWithIcon:@"fa-times-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:30] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnCloseProductInfoTapped:(id)sender{
    [self.view removeFromSuperview];
}
#pragma mark - OrderList TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 27;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"ProductViewInfoCell";
    ProductViewInfoCell *cell = (ProductViewInfoCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setBorderWidth:1];
    if (arrayProductInfo.count>0) {
        
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
