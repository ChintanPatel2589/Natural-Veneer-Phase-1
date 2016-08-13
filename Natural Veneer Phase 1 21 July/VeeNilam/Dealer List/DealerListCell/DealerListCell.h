//
//  DealerListCell.h
//  NaturalVeneer
//
//  Created by Chintan patel on 12/08/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealerListCell : UITableViewCell
{
    __weak IBOutlet UILabel *lblDealerName;
    __weak IBOutlet UILabel *lblDesc;
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UILabel *lblUnreadMsgCount;
    __weak IBOutlet UIImageView *imgView;
}
- (void)setLayoutWithDict:(NSDictionary *)tmpDataDict;
@end
