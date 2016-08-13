//
//  DealerListViewController.h
//  NaturalVeneer
//
//  Created by Chintan patel on 12/08/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerListCell.h"
@interface DealerListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrayDealerList;
    __weak IBOutlet UITableView *tblView;
}
@end
