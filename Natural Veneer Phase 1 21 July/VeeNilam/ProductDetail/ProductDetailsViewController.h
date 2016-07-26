//
//  ProductDetailsViewController.h
//  NaturalVeneer
//
//  Created by Chintan patel on 19/07/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsViewController : UIViewController
{
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UILabel *lblProductDesc;
    __weak IBOutlet UIImageView *imgViewProduct;
    
    __weak IBOutlet UIButton *btnInfo;
    __weak IBOutlet UIButton *btnPlay;
    
}
@property(nonatomic,retain)NSDictionary *dataDict;
@end
