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
    
    if ([CommonMethods connected]) {
        [[CPLoader sharedLoader]showLoader:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getCartList];
        });
    }else{
        [[CPLoader sharedLoader]hideSpinner];
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (void)getCartList
{
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:[CommonMethods getDefaultValueDictWithActionName:kWS_cartlist] withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            
            arrayCartList =[[NSMutableArray alloc]initWithArray:[result valueForKey:@"data"]];
            [tblViewCartList reloadData];
        }else{
            [CommonMethods showAlertViewWithMessage:kErrorAlertMsg];
        }
    }];
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
        [[CPLoader sharedLoader]showLoader:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeItemFromCartAtIndex:tappedIndex];
            
        });
    }else{
        [CommonMethods showAlertViewWithMessage:kErrorAlertMsg];
    }
}
- (void)removeItemFromCartAtIndex:(NSInteger)tappedIndex
{
    NSMutableDictionary *paramDict = [CommonMethods getDefaultValueDictWithActionName:kWS_removecartitem];
    [paramDict setObject:[[arrayCartList objectAtIndex:tappedIndex] valueForKey:kWS_removecartitem_req_inquiry_id]  forKey:kWS_removecartitem_req_inquiry_id];
    [[CPLoader sharedLoader]showLoader:self.view];
    [[WebServiceHandler sharedWebServiceHandler]callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        [self performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:YES];
        if ([[result valueForKey:@"success"]intValue] == 1){
            [arrayCartList removeObjectAtIndex:tappedIndex];
            [tblViewCartList reloadData];
        }else{
            [CommonMethods showAlertViewWithMessage:kErrorAlertMsg];
        }
        
    }];
}
-(void)hideSpinner
{
    [[CPLoader sharedLoader]hideSpinner];
}
- (IBAction)btnGenerateOrderFormTapped:(id)sender{

    
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
