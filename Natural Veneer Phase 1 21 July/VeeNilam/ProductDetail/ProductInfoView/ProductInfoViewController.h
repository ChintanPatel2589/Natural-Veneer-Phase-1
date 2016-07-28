//
//  ProductInfoViewController.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/28/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewInfoCell.h"
@interface ProductInfoViewController : UIViewController<UITableViewDataSource>
{
    __weak IBOutlet UIButton *btnCloseProductInfoView;
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrayProductInfo;
   
}
@property(nonatomic,retain) NSDictionary *dataDict;
@end
