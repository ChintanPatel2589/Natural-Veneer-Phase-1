//
//  TabViewDemoViewController.h
//  WebserviceDemo
//
//  Created by Priti Suthar on 7/20/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFormViewController : BaseViewController{

    __weak IBOutlet UITableView *tblOrderList;
    __weak IBOutlet UISegmentedControl *segOrderType;
    
}
- (IBAction)segValueChanged:(UISegmentedControl *)sender;

@end
