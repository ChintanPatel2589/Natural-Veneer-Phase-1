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
    lblTitle.text = @"CART";
    //[self setMenuIcon];
    
    if ([CommonMethods connected]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self performSelector:@selector(getCartList) withObject:nil afterDelay:0.1];
    }else{
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getCartList
{
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:[CommonMethods getDefaultValueDictWithActionName:kWS_cartlist] withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arrayCartList =[[NSMutableArray alloc]initWithArray:[result valueForKey:@"data"]];
                [self reloadTableData];
        }else{
            [self applyEmptyCartSettings];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}
- (void)reloadTableData
{
    [tblViewCartList reloadData];
    if (arrayCartList.count > 0) {
        btnContinueShopping.enabled = true;
        btnGenerateOrderForm.enabled = true;
    }else{
        [self applyEmptyCartSettings];
    }
    
}
- (void)applyEmptyCartSettings
{
    viewEmptyCart.hidden = false;
    btnContinueShopping.enabled = true;
    btnGenerateOrderForm.enabled = false;
    btnGenerateOrderForm.alpha = 0.6;
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
    if ([CommonMethods connected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(removeItemFromCartAtIndex:) withObject:[NSString stringWithFormat:@"%ld",(long)tappedIndex] afterDelay:0.1];
    }else{
        [CommonMethods showAlertViewWithMessage:kErrorAlertMsg];
    }
}
- (void)removeItemFromCartAtIndex:(NSString *)tappedIndex
{
    NSMutableDictionary *paramDict = [CommonMethods getDefaultValueDictWithActionName:kWS_removecartitem];
    [paramDict setObject:[[arrayCartList objectAtIndex:[tappedIndex intValue]] valueForKey:kWS_removecartitem_req_inquiry_id]  forKey:kWS_removecartitem_req_inquiry_id];
    [[WebServiceHandler sharedWebServiceHandler]callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([[result valueForKey:@"success"]intValue] == 1){
            [arrayCartList removeObjectAtIndex:[tappedIndex intValue]];
            [self reloadTableData];
        }else{
            [CommonMethods showAlertViewWithMessage:kErrorAlertMsg];
        }
    }];
}

#pragma mark IBACtions
- (IBAction)btnGenerateOrderFormTapped:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(checkOut) withObject:nil afterDelay:0.1];
}
-(void)checkOut
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *tmpDict in arrayCartList) {
        for (NSDictionary *tmpOrderList in [tmpDict valueForKey:kWS_grouplist_Res_sizes_quantity]) {
            NSMutableDictionary *tmpOrderArray = [NSMutableDictionary dictionary];
            [tmpOrderArray setObject:[tmpOrderList valueForKey:kquantity] forKey:[tmpOrderList valueForKey:kWS_grouplist_Res_product_size_id]];
            NSDictionary *tmpKeyDict = [[NSDictionary alloc]initWithObjectsAndKeys:tmpOrderArray,[tmpDict valueForKey:kWS_cartlist_Res_inquiry_id] ,nil];
            [tmpArray addObject:tmpKeyDict];
        }
    }
    NSMutableDictionary *paramDict =[[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_checkout]];
    [paramDict setObject:[CommonMethods getJSONString:tmpArray] forKey:kWS_addtocart_req_required_quantity];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[result valueForKey:@"success"]intValue] == 1){
            [CommonMethods showAlertViewWithMessage:[result valueForKey:kmessage]];
        }else{
            [CommonMethods showAlertViewWithMessage:@"Some error occured while adding item into cart."];
        }
    }];
}
-(IBAction)btnContinueShopppingTapped:(id)sender{

    
}

#pragma mark - UITablview DataSource and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCartList.count;
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
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.viewBorder.layer setBorderWidth:1];
    [cell.viewBorder.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (arrayCartList.count>0) {
        cell.btnRemoveFromCart.tag = indexPath.row+1;
        [cell setLayoutWithDict:[arrayCartList objectAtIndex:indexPath.row]];
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
