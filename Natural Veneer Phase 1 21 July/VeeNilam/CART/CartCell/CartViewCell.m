//
//  CartViewCell.m
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(IBAction)btnRemoveCartTapped:(UIButton *)sender
{
    [self.delegate btnRemoveFromCartTapped:(sender.tag - 1)];
}
@end
