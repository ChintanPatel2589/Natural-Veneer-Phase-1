//
//  TabViewDemoViewController.m
//  WebserviceDemo
//
//  Created by Priti Suthar on 7/20/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import "TabViewDemoViewController.h"
#import "UISegmentedControl+Multiline.h"
#import "OrderHeaderView.h"
#import "OrderViewCell.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface TabViewDemoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *selectedSection;
    NSMutableArray *arrOrderType, *arrayForBool;
    NSMutableArray *arrOrders;
}

@end

@implementation TabViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrOrderType = [@[@"CONFIRMED",@"YET TO ORDER",@"ORDERED",@"DELIVERED"]mutableCopy];
    arrOrders = [@[@"CONFIRMED",@"YET TO ORDER",@"ORDERED",@"DELIVERED"]mutableCopy];

    [self setInitialLayout];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)resetTableArrForBool{
    
    if(arrayForBool){
        [arrayForBool removeAllObjects];
        arrayForBool = nil;
    }
    
    arrayForBool = [NSMutableArray array];
    for (int i=0; i<[arrOrders count]; i++) {
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
        [segOrderType insertSegmentWithMultilineTitle:arrOrderType[i] atIndex:i animated:NO];
    }
    
    [self setSegmentAttributes:segOrderType andFontSize:10];
    [self resetTableArrForBool];
}

-(void)setSegmentAttributes:(UISegmentedControl *)segControl andFontSize:(float)textsize {
    segControl.backgroundColor=[UIColor clearColor];
    textsize=(!textsize)?(20.0f):textsize;
    
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
           arrOrders = [@[@"CONFIRMED",@"CONFIRMED",@"CONFIRMED",@"CONFIRMED"]mutableCopy];
            break;
        case 1:
            //yet to
            arrOrders = [@[@"YET TO ORDER",@"YET TO ORDER",@"YET TO ORDER"]mutableCopy];
            break;
        case 2:
            //Ordered
            arrOrders = [@[@"ORDER",@"ORDER"]mutableCopy];
            break;
        case 3:
            //delivered
            arrOrders = [@[@"DELIVERED",@"DELIVERED",@"DELIVERED",@"DELIVERED"]mutableCopy];
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
    
    if (indexPath.row < arrOrders.count) {
        
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
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([arrayForBool[section]intValue] == 1) {
        return arrOrders.count+1;//+1 for Last save Button
    }else
        return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrOrders.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    OrderHeaderView *headerView =[OrderHeaderView headerView];
    headerView.tag = section;
    
    NSString *str =[NSString stringWithFormat:@"Section %@",arrOrders[section]];
    [headerView setDetails:@{@"kOrderName":str,@"itemCount":@"2"}];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    
    [headerView addGestureRecognizer:headerTapped];
    [headerView layoutIfNeeded];
    
    return  headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        if (indexPath.row < arrOrders.count) {
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
        for (int i=0; i<[arrOrders count]; i++) {
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


@end

