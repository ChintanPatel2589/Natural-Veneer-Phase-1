//
//  AddToCartCell.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/28/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddToCartCellDelegate<NSObject>
- (void)textFieldEditingBegin:(id)cell withTextField:(UITextField *)textField;
@end

@interface AddToCartCell : UITableViewCell<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *lblSize;
    __weak IBOutlet UILabel *lblQty;
    
    __weak id <AddToCartCellDelegate> delegate;
}
@property(nonatomic)__weak IBOutlet UITextField *txtRequiredQuantity;
- (void)setLayoutWithData:(NSDictionary *)dataDict;
@property(nonatomic) __weak id <AddToCartCellDelegate> delegate;
@end
