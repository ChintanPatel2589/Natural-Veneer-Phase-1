//
//  DiscussionViewController.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCell.h"
#import "Inputbar.h"
@interface DiscussionViewController : BaseViewController<InputbarDelegate>
{
    
     __weak IBOutlet NSLayoutConstraint *heightConstraint;
    NSMutableArray *arrayChatList;
    
     IBOutlet UITableView *tblView;
    __weak IBOutlet UIButton *btnSendMsg;
}
@property (weak, nonatomic) IBOutlet Inputbar *inputbar;

@property (nonatomic,retain)NSDictionary *dataDictDealer;
@end
