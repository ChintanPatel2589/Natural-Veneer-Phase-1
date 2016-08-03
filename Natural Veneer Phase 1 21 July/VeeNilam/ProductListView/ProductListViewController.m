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
@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lblTitle.text = @"NATURAL";
    //[self setMenuIcon];
    [collectionViewProductList registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
    [[CPLoader sharedLoader]showLoader:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([CommonMethods connected]) {
            [self callWsGetProductListWithSearchTerm:nil];
        }else{
            [[CPLoader sharedLoader]hideSpinner];
            [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
        }
    });
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
    [paramDict setObject:kWS_user_type forKey:kWS_grouplist_Req_user_type];
    [paramDict setObject:[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_id] forKey:kWS_grouplist_Req_type_id];
    [paramDict setObject:@"0" forKey:kWS_grouplist_Req_start_index];
    [paramDict setObject:@"20" forKey:kWS_grouplist_Req_page_size];
    if (strForSearch.length > 0) {
        [paramDict setObject:strForSearch forKey:kWS_grouplist_Req_search_term];
    }
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arraayData =[[NSMutableArray alloc]initWithArray:[result valueForKey:kData]];
            [collectionViewProductList reloadData];
        }else{
            [CommonMethods showAlertViewWithMessage:[result valueForKey:@"error"]];
        }
        [[CPLoader sharedLoader]hideSpinner];
    }];
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
        [cell.imgViewProuct sd_setImageWithURL:[NSURL URLWithString:[[arraayData objectAtIndex:indexPath.row] valueForKey:kWS_grouplist_Res_image] ]
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
    [[CPLoader sharedLoader]showLoader:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callWsGetProductListWithSearchTerm:nil];
    });
   
    [collectionViewProductList reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [[CPLoader sharedLoader]showLoader:self.view];
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
-(void)setMenuIcon
{
    
    UIImage *icon = [UIImage imageWithIcon:@"fa-bars" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:icon
                                                          style:UIBarButtonItemStylePlain
                                                         target:(DEMONavigationController *)self.navigationController
                                                         action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem=_btn;
    
    UIButton *tmpBtnSearch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [tmpBtnSearch setImage:[CommonMethods imageWithIcon:@"fa-search" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    UIBarButtonItem *btnSearch=[[UIBarButtonItem alloc]initWithCustomView:tmpBtnSearch];
    btnSearch.tintColor =[UIColor whiteColor];
    [tmpBtnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tmpBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [tmpBtn setImage:[CommonMethods imageWithIcon:@"fa-cart-arrow-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    UIBarButtonItem *btncart=[[UIBarButtonItem alloc]initWithCustomView:tmpBtn];
    btncart.tintColor =[UIColor whiteColor];
    [tmpBtn addTarget:self action:@selector(showCart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tmpBtnClone = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [tmpBtnClone setImage:[CommonMethods imageWithIcon:@"fa-clone" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    UIBarButtonItem *btnClone=[[UIBarButtonItem alloc]initWithCustomView:tmpBtnClone];
    btnClone.tintColor =[UIColor whiteColor];
    [tmpBtnClone addTarget:self action:@selector(clone) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *tmpBtnForm = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [tmpBtnForm setImage:[CommonMethods imageWithIcon:@"fa-building-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    UIBarButtonItem *btnForm=[[UIBarButtonItem alloc]initWithCustomView:tmpBtnForm];
    btnForm.tintColor =[UIColor whiteColor];
    [tmpBtnForm addTarget:self action:@selector(gotoOrderForm) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tmpBtnalert = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [tmpBtnalert setImage:[CommonMethods imageWithIcon:@"fa-bell-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    UIBarButtonItem *btnlert=[[UIBarButtonItem alloc]initWithCustomView:tmpBtnalert];
    btnClone.tintColor =[UIColor whiteColor];
    [tmpBtnClone addTarget:self action:@selector(clone) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: btncart,btnlert,btnForm,btnClone,btnSearch , nil]];
    [self setUpTwoLineNavigationTitle];
    
    
}
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
