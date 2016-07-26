//
//  TrialByTrialTTCViewController.h
//  EdenAdult
//
//  Created by Chintan Patel on 7/12/16.
//  Copyright © 2016 Yama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListViewCell.h"
#import "CartViewController.h"
#import "UIImageView+WebCache.h"
@interface ProductListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *collectionViewProductList;
    NSMutableArray *arraayData;
}

@end
