//
//  OrderViewCell.h
//  WebserviceDemo
//
//  Created by rangam on 7/21/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewCell : UITableViewCell{
    __weak IBOutlet UILabel *lblorderText;

}
- (void)setCellDetail:(NSDictionary *)dict;
@end
