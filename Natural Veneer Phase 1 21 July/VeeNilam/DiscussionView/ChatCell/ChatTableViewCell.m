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
    lblChatMessageReceiver.hidden = true;
    lblChatMessageSender.hidden = true;
    [CommonMethods setRadiousAndBorderToUILabel:lblChatMessageSender];
    [CommonMethods setRadiousAndBorderToUILabel:lblChatMessageReceiver];
    // Initialization code
}

- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict
{
    if ([[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_id] intValue] == [[tmpDataDict valueForKey:kWS_discussionmsg_Res_created_by] intValue]) {//Me
        lblChatMessageSender.text = [tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text];
        lblChatMessageSender.hidden = false;

    }else{//Receiver
        lblChatMessageReceiver.text = [tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text];
        
        lblChatMessageReceiver.hidden = false;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
