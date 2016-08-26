//
//  ChatTableViewCell.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *lblChatMessageSender;
    __weak IBOutlet UILabel *lblChatMessageReceiver;
}

- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict;
@end
