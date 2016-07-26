//
//  OrderHeaderView.h
//  WebserviceDemo
//
//  Created by rangam on 7/21/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblOrderName;
@property (weak, nonatomic) IBOutlet UILabel *lbltotalItem;
@property (weak, nonatomic) IBOutlet UIButton *btndropdown;

+(id)headerView;
-(void)setDetails:(NSDictionary *)dictInfo;
@end
