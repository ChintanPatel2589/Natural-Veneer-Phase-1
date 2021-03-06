//
//  ProductDetailsViewController.h
//  NaturalVeneer
//
//  Created by Chintan patel on 19/07/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AddToCartCell.h"
#import "ProductInfoViewController.h"
@interface ProductDetailsViewController : BaseViewController<UITableViewDataSource,UITextViewDelegate,AddToCartCellDelegate>
{
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UILabel *lblProductDesc;
    __weak IBOutlet UIImageView *imgViewProduct;
    

    __weak IBOutlet UIButton *btnCloseAddtoCartView;
    IBOutlet UIView *viewAddToCart;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UITextView *txtViewDesc;
   
    BOOL isKeyUp;
    ProductInfoViewController *prodInfoViewOBJ;
    NSMutableArray *arraySizeAndQty;
    NSMutableArray *arrayOrderList;
    
}
@property(nonatomic,retain)NSDictionary *dataDict;
@end
