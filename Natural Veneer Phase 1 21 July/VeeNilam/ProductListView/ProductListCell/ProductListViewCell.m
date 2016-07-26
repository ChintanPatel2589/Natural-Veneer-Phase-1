//
//  PlayerCustomCell.m
//  HEKXO_RelayFBO
//
//  Created by Sandip Patel on 12/31/15.
//  Copyright © 2015 Utkal Patel. All rights reserved.
//

#import "ProductListViewCell.h"


@implementation ProductListViewCell

- (void)awakeFromNib {
    [self setDefaultLayout];
        
}
-(void)setDefaultLayout{
    
    
}
-(void)setCellLayout:(NSDictionary*)dict{
    _lblProductName.text = [dict valueForKey:kWS_grouplist_Res_product_name];
    _lblGroupName.text = [dict valueForKey:kWS_grouplist_Res_group_name];
    _lblGoupID.text = [dict valueForKey:kWS_grouplist_Res_group_id];
}






@end
