//
//  DealerListCell.m
//  NaturalVeneer
//
//  Created by Chintan patel on 12/08/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "DealerListCell.h"

@implementation DealerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [imgView.layer setCornerRadius:imgView.frame.size.height/2];
    [lblUnreadMsgCount.layer setCornerRadius:lblUnreadMsgCount.frame.size.height/2];
    [lblUnreadMsgCount.layer setMasksToBounds:YES];
    lblUnreadMsgCount.backgroundColor = AppGreenColor;
}
- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict
{
    lblDealerName.text = [tmpDataDict valueForKey:kWS_dealerlist_Res_dealer_name];
    lblDesc.text = @"Test Description";
    lblTime.text = @"yesterday";
    lblUnreadMsgCount.text = @"1";
    imgView.image = [CommonMethods imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:60];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
