//
//  PlayerCustomCell.h
//  HEKXO_RelayFBO
//
//  Created by Sandip Patel on 12/31/15.
//  Copyright © 2015 Utkal Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol TrialByTrialTTCCellDelegate<NSObject>
//- (void)ansButtonTappedAtIndex:(NSInteger)index WithAns:(NSString *)ans;
//@end

@interface ProductListViewCell : UICollectionViewCell{
    //__weak id<TrialByTrialTTCCellDelegate> delegate;
   
}
//@property(nonatomic,weak)id<TrialByTrialTTCCellDelegate> delegate;
@property(nonatomic,weak)IBOutlet UILabel *lblGoupID;
@property(nonatomic,weak)IBOutlet UILabel *lblProductName;
@property(nonatomic,weak)IBOutlet UILabel *lblGroupName;
@property(nonatomic,weak)IBOutlet UIImageView *imgViewProuct;

-(void)setCellLayout:(NSDictionary*)dict;


@end
