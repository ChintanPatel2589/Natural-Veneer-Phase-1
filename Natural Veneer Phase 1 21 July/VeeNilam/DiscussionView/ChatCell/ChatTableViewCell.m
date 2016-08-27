//
//  ChatTableViewCell.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //[CommonMethods setRadiousAndBorderToUILabel:lblChatMessageSender];
    //[CommonMethods setRadiousAndBorderToUILabel:lblChatMessageReceiver];
    // Initialization code
}

- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict
{
    if ([[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_id] intValue] == [[tmpDataDict valueForKey:kWS_discussionmsg_Res_created_by] intValue]) {//Me
        lblChatMessageSender.text =[NSString stringWithFormat:@"%@" ,[tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text]];
        lblChatMessageSender.hidden = false;
        lblChatMessageReceiver.hidden = true;
        imgLogo.hidden  = true;
        
    }else{//Receiver
        lblChatMessageReceiver.text = [NSString stringWithFormat:@"%@" ,[tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text]];
        [self setRadiousToLogoImage];
        lblChatMessageReceiver.hidden = false;
        lblChatMessageSender.hidden = true;
        
    }
}
- (void)setRadiousToLogoImage
{
    imgLogo.hidden = false;
    [imgLogo.layer setCornerRadius:imgLogo.frame.size.height/2];
    [imgLogo.layer setBorderColor:[AppGreenColor CGColor]];
    [imgLogo.layer setBorderWidth:1];
    [imgLogo.layer setMasksToBounds:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
