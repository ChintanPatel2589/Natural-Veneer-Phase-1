//
//  OrderViewCell.m
//  WebserviceDemo
//
//  Created by rangam on 7/21/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import "OrderViewCell.h"

@implementation OrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellDetail:(NSDictionary *)dict{
   
    lblorderText.text = [NSString stringWithFormat:@"%d",[dict[@"TEXT"] intValue]];


}

@end
