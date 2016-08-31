//
//  TrialByTrialTTCViewController.m
//  EdenAdult
//
//  Created by Chintan Patel on 7/12/16.
//  Copyright © 2016 Yama. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductDetailsViewController.h"
#import "OrderFormViewController.h"
#import "api_Database.h"
@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;
    lblTitle.text = @"NATURAL";
    [collectionViewProductList registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
    //[self performSelector:@selector(setDefaultData) withObject:nil afterDelay:0.1];
    [self setDefaultData];
    pageIndex = @"0";
    pageSize = @"20";
}
- (void)setDefaultData
{
    refreshControl = [[UIRefreshControl alloc]init];
    [collectionViewProductList addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshCollectionViewData) forControlEvents:UIControlEventValueChanged];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:0.1];
    //[self getDataFromServer];
    
}
- (void)refreshCollectionViewData
{
    [self getDataFromServer];
    [refreshControl endRefreshing];
}
- (void)getDataFromServer
{
    if ([CommonMethods connected]) {
        [self callWsGetProductListWithSearchTerm:nil];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
}
-(void)search
{
    
}
-(void)showCart{
    CartViewController *cartViewOBJ= [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartViewOBJ animated:YES];
}
-(void)clone
{
    
}

#pragma mark WebService Calling
-(void)callWsGetProductListWithSearchTerm:(NSString *)strForSearch
{
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    [paramDict setObject:[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Req_auth_token] forKey:kWS_grouplist_Req_auth_token];
    [paramDict setObject:kWS_grouplist forKey:kWS_grouplist_Req_action];
    [paramDict setObject:[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] forKey:kWS_grouplist_Req_user_type];
    [paramDict setObject:[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_id] forKey:kWS_grouplist_Req_type_id];
    [paramDict setObject:pageIndex forKey:kWS_grouplist_Req_start_index];
    [paramDict setObject:pageSize forKey:kWS_grouplist_Req_page_size];
    if (strForSearch.length > 0) {
        [paramDict setObject:strForSearch forKey:kWS_grouplist_Req_search_term];
    }
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arraayData =[[NSMutableArray alloc]initWithArray:[result valueForKey:kData]];
            [collectionViewProductList reloadData];
            pageSize = [NSString stringWithFormat:@"%d",[pageSize intValue]+20];
            pageIndex = [NSString stringWithFormat:@"%d",[pageIndex intValue]+1];
        }else{
            [CommonMethods showAlertViewWithMessage:[result valueForKey:@"error while getting products."]];
        }
        [self getStatusIDs];
    }];
}
- (void)getStatusIDs
{
    [[WebServiceHandler sharedWebServiceHandler]callWebServiceWithParam:[CommonMethods getDefaultValueDictWithActionName:kWS_statussyn] withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"] boolValue]== true) {
            [self insertDataIntoStatusCodeTable:[result valueForKey:kData]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)insertDataIntoStatusCodeTable:(NSArray *)arrayData
{
    [api_Database genericQueryforDatabase:kDatabaseName query:[NSString stringWithFormat:@"delete from %@",kstatus_code_Table]];
    for (NSDictionary *tmpDict in arrayData) {
        [api_Database genericQueryforDatabase:kDatabaseName query:[NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@) values (%d,\"%@\",\"%@\",\"%@\")",kstatus_code_Table,kWS_statussyn_Res_status_id,kWS_statussyn_Res_sort_order,kWS_statussyn_Res_status_name,kWS_statussyn_Res_is_price_editable,[[tmpDict valueForKey:kWS_statussyn_Res_status_id] intValue],[tmpDict valueForKey:kWS_statussyn_Res_sort_order],[tmpDict valueForKey:kWS_statussyn_Res_status_name],[tmpDict valueForKey:kWS_statussyn_Res_is_price_editable]]];
    }
}
#pragma mark Cell Delegate
-(void)ansButtonTappedAtIndex:(NSInteger)index WithAns:(NSString *)ans
{
    
}
#pragma mark - UICollectionView DataSource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return arraayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ProductListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductListViewCell" forIndexPath:indexPath];
    if (arraayData.count > 0) {
        [cell setCellLayout:[arraayData objectAtIndex:indexPath.row]];
        [cell.imgViewProuct sd_setImageWithURL:[NSURL URLWithString:[[arraayData objectAtIndex:indexPath.row] valueForKey:kWS_grouplist_Res_image_big] ]
                          placeholderImage:nil];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (arraayData.count > 0) {
            ProductDetailsViewController *prodDetailOBJ = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
            prodDetailOBJ.dataDict = [arraayData objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:prodDetailOBJ animated:YES];
    }

}
#pragma mark - Serach View Controller
#pragma mark Content Filtering
#pragma mark - search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callWsGetProductListWithSearchTerm:nil];
    });
    [collectionViewProductList reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callWsGetProductListWithSearchTerm:searchBar.text];
    });
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBarProduct setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBarProduct setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching{
    
    [searchBarProduct resignFirstResponder];
    searchBarProduct.text  = @"";
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
#pragma mark - Menu Icon Action

-(void)setUpTwoLineNavigationTitle {
    CGFloat width = 0.95 * self.view.frame.size.width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, width, self.navigationController.navigationBar.frame.size.height)];
    contentView.backgroundColor = [UIColor clearColor];
    
    CGRect titleRect = contentView.frame;
    titleRect.origin.y = -1;
    titleRect.size.height = self.navigationController.navigationBar.frame.size.height;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleRect];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:17.0];
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"NATURAL";
    [contentView addSubview:titleView];
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.navigationItem.titleView = contentView;
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
