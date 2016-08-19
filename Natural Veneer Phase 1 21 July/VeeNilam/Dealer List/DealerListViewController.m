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
        [self performSelector:@selector(getDealerList) withObject:nil afterDelay:0.1];
    }else{
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)getDealerList
{
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:[CommonMethods getDefaultValueDictWithActionName:kWS_dealerlist] withCompletion:^(NSDictionary *result) {
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
