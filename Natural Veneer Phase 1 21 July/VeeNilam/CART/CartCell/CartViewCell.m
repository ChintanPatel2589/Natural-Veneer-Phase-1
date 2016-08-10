//
//  CartView_m
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/15/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "CartViewCell.h"

@implementation CartViewCell
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict
{
    [_btnRemoveFromCart.layer setCornerRadius:(_btnRemoveFromCart.frame.size.height/2)];
    [_btnRemoveFromCart.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_btnRemoveFromCart.layer setBorderWidth:1];
    _lblCategory.text = [tmpDataDict valueForKey:kWS_cartlist_Res_category_name];
    _lblSeries.text = [tmpDataDict valueForKey:kWS_grouplist_Res_series_name];
    _lblProduct.text = [tmpDataDict valueForKey:kWS_grouplist_Res_product_name];
    _lblGroup.text = [tmpDataDict valueForKey:kWS_grouplist_Res_group_name];
    [_imgViewProduct sd_setImageWithURL:[NSURL URLWithString:[tmpDataDict valueForKey:kWS_grouplist_Res_image] ]
                           placeholderImage:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(IBAction)btnRemoveCartTapped:(UIButton *)sender
{
    [self.delegate btnRemoveFromCartTapped:(int)(sender.tag - 1)];
}
@end
