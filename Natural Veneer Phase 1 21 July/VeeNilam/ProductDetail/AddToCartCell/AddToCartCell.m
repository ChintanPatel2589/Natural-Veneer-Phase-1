//
//  AddToCartCell.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/28/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "AddToCartCell.h"

@implementation AddToCartCell
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setLayoutWithData:(NSDictionary *)dataDict
{
    lblQty.text = [dataDict valueForKey:kWS_grouplist_Res_quantity];
    lblSize.text = [dataDict valueForKey:kWS_grouplist_Res_size_name];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textFieldEditingBegin:self withTextField:textField];
}
@end
