//
//  CartViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/15/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CART";
    [self setMenuIcon];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)setMenuIcon
{
    self.navigationController.navigationBar.translucent = NO;
    UIImage *icon = [UIImage imageWithIcon:@"fa-bars" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:25];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:icon
                                                          style:UIBarButtonItemStylePlain
                                                         target:(DEMONavigationController *)self.navigationController
                                                         action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem=_btn;
}
#pragma mark - Cell Delegate
- (void)btnRemoveFromCartTapped:(NSInteger)tappedIndex{
    
}
- (IBAction)btnGenerateOrderFormTapped:(id)sender{

    
}
-(IBAction)btnContinueShopppingTapped:(id)sender{

    
}
#pragma mark - UITablview DataSource and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"CartViewCell";
    CartViewCell *cell = (CartViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.viewBorder.layer setBorderWidth:1];
    [cell.viewBorder.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (arrayCartList.count>0) {
        
        cell.btnRemoveFromCart.tag = indexPath.row+1;
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
