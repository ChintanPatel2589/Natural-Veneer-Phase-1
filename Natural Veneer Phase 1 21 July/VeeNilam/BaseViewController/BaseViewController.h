//
//  BaseViewController.h
//  NaturalVeneer
//
//  Created by Chintan Patel on 7/27/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"
@interface BaseViewController : UIViewController
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UIButton *btnSearch;
    __weak IBOutlet UIButton *btnCart;
    __weak IBOutlet UIButton *btnForm;
    __weak IBOutlet UIButton *btnAlert;
    __weak IBOutlet UIButton *btnClone;
    __weak IBOutlet UIButton *btnNextArrow;
    __weak IBOutlet UIButton *btnMenu;
    __weak IBOutlet UIView *viewNavigation;
    __weak IBOutlet UIButton *btnBack;
    __weak IBOutlet UIButton *btnInfo;
    __weak IBOutlet UIButton *btnPlay;
    __weak IBOutlet UIButton *btnZoom;
    M13BadgeView *badgeView;
}
@end
