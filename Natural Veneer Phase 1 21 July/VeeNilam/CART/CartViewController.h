//
//  CartViewController.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/15/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCell/CartViewCell.h"
@interface CartViewController : UIViewController<CartViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayCartList;
    __weak IBOutlet UITableView *tblViewCartList;
}

@end
