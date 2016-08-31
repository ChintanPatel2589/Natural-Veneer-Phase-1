//
//  TabViewDemoViewController.h
//  WebserviceDemo
//
//  Created by Priti Suthar on 7/20/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusTypeCollectionViewCell.h"
@interface OrderFormViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>{

    __weak IBOutlet UITableView *tblOrderList;
    __weak IBOutlet UISegmentedControl *segOrderType;
    __weak IBOutlet UICollectionView *collectionViewStatusTypes;
    NSInteger tappedStatus;
}
- (IBAction)segValueChanged:(UISegmentedControl *)sender;

@end
