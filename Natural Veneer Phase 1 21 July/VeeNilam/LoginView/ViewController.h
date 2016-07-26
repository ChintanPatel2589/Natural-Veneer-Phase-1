//
//  ViewController.h
//  VeeNilam
//
//  Created by Vrushank Rindani on 5/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartViewController.h"
#import "ProductListViewController.h"
@interface ViewController : UIViewController<UITextFieldDelegate>
{
    BOOL isKeyUp;
    //Login
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    
    //OTP
     IBOutlet UIView *viewOTP;
    __weak IBOutlet UITextField *txtOTP;
    __weak IBOutlet UIButton *btnOTP;
    
    //Reset Password
     IBOutlet UIView *viewResetPass;
    
    __weak IBOutlet UITextField *txtForgotPassEmail;
    __weak IBOutlet UIButton *btnResetPass;
        
}
@end
