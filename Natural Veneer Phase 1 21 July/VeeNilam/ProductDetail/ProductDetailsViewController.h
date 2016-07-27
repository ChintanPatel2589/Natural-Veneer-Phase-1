//
//  ProductDetailsViewController.h
//  NaturalVeneer
//
//  Created by Chintan patel on 19/07/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ProductDetailsViewController : BaseViewController
{
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UILabel *lblProductDesc;
    __weak IBOutlet UIImageView *imgViewProduct;
    
    __weak IBOutlet UIButton *btnInfo;
    __weak IBOutlet UIButton *btnPlay;
    __weak IBOutlet UIButton *btnZoom;
    
}
@property(nonatomic,retain)NSDictionary *dataDict;
@end
