//
//  TabViewDemoViewController.m
//  WebserviceDemo
//
//  Created by Priti Suthar on 7/20/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import "OrderFormViewController.h"
#import "UISegmentedControl+Multiline.h"
#import "OrderHeaderView.h"
#import "OrderViewCell.h"
#import "api_Database.h"
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface OrderFormViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *selectedSection;
    NSMutableArray *arrOrderType, *arrayForBool;
    NSMutableArray *arrMainData;
    NSMutableArray *arrayDisplayData;
}

@end

@implementation OrderFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tappedStatus = 0;
    
    //arrOrderType = [@[@"CONFIRMED",@"YET TO ORDER",@"ORDERED",@"DELIVERED"]mutableCopy];
    [collectionViewStatusTypes registerNib:[UINib nibWithNibName:@"StatusTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StatusTypeCollectionViewCell"];
    [self setCollectionLauout];
    arrOrderType = [api_Database selectDataFromDatabase:kDatabaseName query:[NSString stringWithFormat:@"select * from %@",kstatus_code_Table]];
    //arrMainData = [@[@"CONFIRMED",@"CONFIRMED",@"CONFIRMED",@"CONFIRMED"]mutableCopy];

    [self setInitialLayout];
    segOrderType.selectedSegmentIndex= 0;
    [self setUpTwoLineNavigationTitle];
    // Do any additional setup after loading the view from its nib.
    [self getOrderListData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getOrderListData
{
    if ([CommonMethods connected]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(getOrderList) withObject:nil afterDelay:0.1];
    }else{
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Title];
    }
}
- (void)getOrderList
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_orderlist]];
    [paramDict setObject:[[arrOrderType objectAtIndex:tappedStatus] valueForKey:kWS_statussyn_Res_status_id] forKey:kWS_statussyn_Res_status_id];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arrMainData =[[NSMutableArray alloc]initWithArray:[[result valueForKey:kData] copy]];
            [self arrangeArrayDataToDisplayWithArray:arrMainData];
        }
            [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}
- (void)arrangeArrayDataToDisplayWithArray:(NSArray *)arrayData
{
    @try {
        arrayDisplayData = [NSMutableArray array];
        NSArray *uniqueArrary = [arrayData valueForKeyPath:@"@distinctUnionOfObjects.inquiry_code"];
        for (NSString *srtID in uniqueArrary) {
            NSMutableDictionary *tmpDataDict = [NSMutableDictionary dictionary];
            [tmpDataDict setObject:srtID forKey:kinquiry_code];
            NSArray *tmpArray = [self filteredArrayWithKey:@"inquiry_code" andValue:srtID withingArray:arrayData];
            [tmpDataDict setObject:[NSString stringWithFormat:@"%d",[tmpArray count]] forKey:kItems];
            int totalSheet = 0;
            for (NSDictionary *tmpDict in tmpArray) {
                NSArray *arrayQty = [tmpDict  valueForKey:kWS_grouplist_Res_sizes_quantity];
                for (NSDictionary *tmpQtyDict in arrayQty) {
                    totalSheet = totalSheet + [[tmpQtyDict valueForKey:kWS_grouplist_Res_quantity] intValue];
                }
            }
            [tmpDataDict setObject:[NSString stringWithFormat:@"%d",totalSheet] forKey:kSheets];
            [arrayDisplayData addObject:tmpDataDict];
            [tblOrderList reloadData];
        }
    } @catch (NSException *exception) {
        NSLog(@"arrangeArrayDataToDisplayWithArray:%@",exception.description);
    } @finally {
        
    }
    
}
- (NSArray *)filteredArrayWithKey:(NSString *)key andValue:(NSString *)value withingArray:(NSArray *)arrayData
{
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", key, value];//keySelected is NSString itself
    NSLog(@"predicate %@",predicateString);
    NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:[arrayData filteredArrayUsingPredicate:predicateString]];
    return filteredArray;
}
-(void)resetTableArrForBool{
    
    if(arrayForBool){
        [arrayForBool removeAllObjects];
        arrayForBool = nil;
    }
    
    arrayForBool = [NSMutableArray array];
    for (int i=0; i<[arrMainData count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    self.navigationController.navigationBar.translucent = NO;
}
-(void)setInitialLayout{
    
    int i = 0;
    for (i = 0; i < arrOrderType.count; i++) {
        [segOrderType removeSegmentAtIndex:i animated:NO];
        [segOrderType insertSegmentWithMultilineTitle:[[arrOrderType objectAtIndex:i] valueForKey:kWS_statussyn_Res_status_name] atIndex:i animated:NO];
    }
    
    [self setSegmentAttributes:segOrderType andFontSize:10];
    [self resetTableArrForBool];
}

-(void)setSegmentAttributes:(UISegmentedControl *)segControl andFontSize:(float)textsize {
    segControl.backgroundColor=[UIColor whiteColor];
    textsize=(!textsize)?(20.0f):textsize;
    
    [segControl.layer setCornerRadius:5];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:textsize]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:textsize]} forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor lightGrayColor]];
    
    //Divider image
    CGRect rect = CGRectMake(0.0f, 0.0f,1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UISegmentedControl appearance] setDividerImage:image forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    segControl.clipsToBounds=YES;
    
}
- (IBAction)segValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            //Confirmed
           arrMainData = [@[@"CONFIRMED",@"CONFIRMED",@"CONFIRMED",@"CONFIRMED"]mutableCopy];
            break;
        case 1:
            //yet to
            arrMainData = [@[@"YET TO ORDER",@"YET TO ORDER",@"YET TO ORDER"]mutableCopy];
            break;
        case 2:
            //Ordered
            arrMainData = [@[@"ORDER",@"ORDER"]mutableCopy];
            break;
        case 3:
            //delivered
            arrMainData = [@[@"DELIVERED",@"DELIVERED",@"DELIVERED",@"DELIVERED"]mutableCopy];
            break;
        default:
            break;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetTableArrForBool];
        [tblOrderList reloadData];
    });
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderViewCell * cell;
    
    if (indexPath.row < arrMainData.count) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"OrderViewCell" owner:self options:nil][0];
        }
        
        [cell setCellDetail:@{@"TEXT":@(indexPath.row)}];

    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCellID"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"OrderViewCell" owner:self options:nil][1];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([arrayForBool[section]intValue] == 1) {
        return arrMainData.count+1;//+1 for Last save Button
    }else
        return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayDisplayData.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    OrderHeaderView *headerView =[OrderHeaderView headerView];
    headerView.tag = section;
    
    NSString *str =[NSString stringWithFormat:@"Section %@",arrMainData[section]];
    [headerView setDetails:@{@"kOrderName":str,@"itemCount":@"2"}];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    
    [headerView addGestureRecognizer:headerTapped];
    [headerView layoutIfNeeded];
    if ([[arrayForBool objectAtIndex:section] boolValue] == 1) {
        [headerView.btndropdown setImage:[CommonMethods imageWithIcon:@"fa-caret-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:30] forState:UIControlStateNormal];
    }
    return  headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        if (indexPath.row < arrMainData.count) {
            OrderViewCell *orderviewcell = [[NSBundle mainBundle] loadNibNamed:@"OrderViewCell" owner:self options:nil][0];
            return orderviewcell.contentView.frame.size.height;
       
        }else{
            OrderViewCell *orderviewcell = [[NSBundle mainBundle] loadNibNamed:@"OrderViewCell" owner:self options:nil][1];
            return orderviewcell.contentView.frame.size.height;
        }
    }else {
        return 0;
    }
    
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        
        [self resetTableArrForBool];
        for (int i=0; i<[arrMainData count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        
        }
        [tblOrderList reloadData];
//        [tblOrderList reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    /*************** Close the section, once the data is selected ***********************************/
    /*
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [tblOrderList reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
     */ 
    
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
#pragma mark - UICollectionView DataSource and Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return arrOrderType.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatusTypeCollectionViewCell" forIndexPath:indexPath];
    if (arrOrderType.count > 0) {
        if (indexPath.row == tappedStatus) {
            cell.lblStatusType.textColor = AppGreenColor;
            cell.lblStatusType.font = [UIFont boldSystemFontOfSize:14];
        }else{
            cell.lblStatusType.textColor = [UIColor darkGrayColor];
            cell.lblStatusType.font = [UIFont systemFontOfSize:14];
        }
        cell.lblStatusType.text = [[arrOrderType objectAtIndex:indexPath.row] valueForKey:kWS_statussyn_Res_status_name];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrOrderType.count > 0) {
        tappedStatus = indexPath.row;
        [self getOrderListData];
        [collectionViewStatusTypes reloadData];
    }
}
- (void)setCollectionLauout
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(110,35);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    collectionViewStatusTypes.collectionViewLayout = flow;
    collectionViewStatusTypes.backgroundColor = [UIColor whiteColor];
}
@end

