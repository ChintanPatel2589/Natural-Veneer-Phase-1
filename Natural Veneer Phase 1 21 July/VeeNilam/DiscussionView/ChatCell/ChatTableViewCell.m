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
    CGSize tmpSize = [CommonMethods textHeight:[tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text] widthofLabel:200 fontName:[UIFont systemFontOfSize:17]];
    if ([[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_id] intValue] == [[tmpDataDict valueForKey:kWS_discussionmsg_Res_created_by] intValue]) {//Me
        lblChatMessageSender.text =[NSString stringWithFormat:@"%@" ,[tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text]];
        lblChatMessageSender.hidden = false;
        lblChatMessageReceiver.hidden = true;
        
        _bubbleImageSender.hidden = false;
        _bubbleImageReceiver.hidden = true;
        
        imgLogo.hidden  = true;
        [self needsUpdateConstraints];
        [self setBubbleForMe:YES andHeight:tmpSize.height];
    }else{//Receiver
        lblChatMessageReceiver.text = [NSString stringWithFormat:@"%@" ,[tmpDataDict valueForKey:kWS_discussionmsg_Res_chat_text]];
        [self setRadiousToLogoImage];
        
        lblChatMessageReceiver.hidden = false;
        lblChatMessageSender.hidden = true;
        
        _bubbleImageSender.hidden = true;
        _bubbleImageReceiver.hidden = false;
        
        [self needsUpdateConstraints];
        [self setBubbleForMe:NO andHeight:tmpSize.height];
    }
    
}
- (void)setBubbleForMe:(BOOL)isMe andHeight:(float)height
{
    //Margins to Bubble
    CGFloat marginLeft = 5;
    CGFloat marginRight = 0;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 0;
    CGFloat bubble_width;
    CGFloat bubble_height = MIN(height + 8,
                                lblChatMessageSender.frame.origin.y + lblChatMessageSender.frame.size.height + 6);
    
    if (isMe) {
        
        bubble_x = MIN(self.frame.origin.x -marginLeft,lblChatMessageSender.frame.origin.x - 2*marginLeft);
        
        _bubbleImageSender.image = [[self imageNamed:@"BubbleOutgoing.png"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        
        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
        _bubbleImageSender.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
        _bubbleImageSender.autoresizingMask = self.autoresizingMask;
    }
    else
    {
        bubble_x = marginRight;
        _bubbleImageReceiver.image = [[self imageNamed:@"BubbleIncoming.png"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        bubble_width = MAX(self.frame.origin.x + self.frame.size.width + marginLeft,
                           lblChatMessageReceiver.frame.origin.x + lblChatMessageReceiver.frame.size.width + 2*marginLeft);
        _bubbleImageReceiver.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
        _bubbleImageReceiver.autoresizingMask = self.autoresizingMask;
    }
}
-(UIImage *)imageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName
                      inBundle:[NSBundle bundleForClass:[self class]]
 compatibleWithTraitCollection:nil];
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
