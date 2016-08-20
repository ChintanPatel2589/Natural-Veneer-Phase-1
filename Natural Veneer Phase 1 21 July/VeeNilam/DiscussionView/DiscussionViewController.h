//
//  DiscussionViewController.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextViewHandler.h"
@interface DiscussionViewController : BaseViewController
{
     __weak IBOutlet UITextView *textView;
     __weak IBOutlet NSLayoutConstraint *heightConstraint;
    NSMutableArray *arrayChatList;
    IBOutlet UIView *viewChat;
    __weak IBOutlet UITableView *tblView;
}
@property (strong, nonatomic) GrowingTextViewHandler *handler;
@property (nonatomic,retain)NSDictionary *dataDictDealer;
@end
