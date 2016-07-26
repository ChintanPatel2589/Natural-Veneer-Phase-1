//
//  CartViewCell.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/15/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CartViewCellDelegate<NSObject>
- (void)btnRemoveFromCartTapped:(NSInteger)tappedIndex;
@end

@interface CartViewCell : UITableViewCell
{
    __weak id<CartViewCellDelegate> delegate;
}
@property(nonatomic,weak)id<CartViewCellDelegate> delegate;

@property(nonatomic,weak) IBOutlet UILabel *lblCategory;
@property(nonatomic,weak) IBOutlet UILabel *lblSeries;
@property(nonatomic,weak) IBOutlet UILabel *lblGroup;
@property(nonatomic,weak) IBOutlet UILabel *lblProduct;
@property(nonatomic,weak) IBOutlet UILabel *lblSizeQTY;
@property(nonatomic,weak) IBOutlet UIButton *btnRemoveFromCart;
@property(nonatomic,weak) IBOutlet UIImageView *imgViewProduct;
@property(nonatomic,weak) IBOutlet UIView *viewBorder;


@end
