//
//  DealerListViewController.m
//  NaturalVeneer
//
//  Created by Chintan patel on 12/08/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "DealerListViewController.h"
#import "DiscussionViewController.h"
@interface DealerListViewController ()

@end

@implementation DealerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([CommonMethods connected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(getDealerListWithSearchTerm:) withObject:nil afterDelay:0.1];
    }else{
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)getDealerListWithSearchTerm:(NSString *)searchStr
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_dealerlist]];
    if (searchStr != nil) {
        [paramDict setObject:searchStr forKey:kWS_grouplist_Req_search_term];
    }
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arrayDealerList =[[NSMutableArray alloc]initWithArray:[result valueForKey:@"data"]];
            [tblView reloadData];
        }else{
           [CommonMethods showAlertViewWithMessage:[result valueForKey:kmessage]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}
#pragma mark - UITablview DataSource and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayDealerList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"DealerListCell";
    DealerListCell *cell = (DealerListCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    if (arrayDealerList.count>0) {
        
        [cell setLayoutWithDict:[arrayDealerList objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrayDealerList.count >0) {
        [self gotoDiscussionWithIndexPath:indexPath];
    }
}
- (void)gotoDiscussionWithIndexPath:(NSIndexPath *)indexPath
{
    DiscussionViewController *discussionViewOBJ = [[DiscussionViewController alloc]initWithNibName:@"DiscussionViewController" bundle:nil];
    discussionViewOBJ.dataDictDealer = [arrayDealerList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:discussionViewOBJ animated:YES];
}
#pragma mark - Serach View Controller
#pragma mark Content Filtering
#pragma mark - search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDealerListWithSearchTerm:nil];
    });
    [tblView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDealerListWithSearchTerm:searchBar.text];
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
