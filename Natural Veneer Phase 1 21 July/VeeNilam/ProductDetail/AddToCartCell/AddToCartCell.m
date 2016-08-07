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
    lblQty.text = [NSString stringWithFormat:@"%d",[[dataDict valueForKey:kWS_grouplist_Res_quantity] intValue]];
    lblSize.text = [dataDict valueForKey:kWS_grouplist_Res_size_name];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [CommonMethods checkNumberOnly:string];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] >0) {
        [self.delegate textFieldEditingBegin:self withTextField:textField];
    }

    
}
@end
