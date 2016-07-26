//
//  ViewController.m
//  VeeNilam
//
//  Created by Vrushank Rindani on 5/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultData];
}
-(void)setDefaultData
{
    btnLogin.backgroundColor = AppGreenColor;
    [CommonMethods setRadiousAndBorderToTextField:txtPassword];
    [CommonMethods setRadiousAndBorderToTextField:txtEmail];
    
    txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txtOTP.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txtForgotPassEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
    NSLog(@"%@",[CommonMethods getValueFromNSUserDefaultsWithKey:kloggedUserInfo]);
    [CommonMethods setRadiousAndBorderToTextField:txtOTP];
}
#pragma mark - IBActions
- (IBAction)btnLoginPressed:(id)sender
{

    if (![CommonMethods isValidStr:txtEmail.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter UserID."];
        return;
    }
    
    if (![CommonMethods validateEmailWithString:txtEmail.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter valid email."];
        return;
    }
    if (![CommonMethods isValidStr:txtPassword.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter password."];
        return;
    }
    [self hideKeyboard];
    [[CPLoader sharedLoader]showLoader:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkLoginDetails];
    });
}
- (IBAction)btnForgotPasswordPressed:(id)sender
{
    
    [CommonMethods setRadiousAndBorderToTextField:txtForgotPassEmail];
    txtForgotPassEmail.text = [CommonMethods getValueFromNSUserDefaultsWithKey:kWS_Login_Req_email];
    [self fadeInAnimationForView:viewResetPass];
    viewResetPass.frame = self.view.frame;
}
- (IBAction)btnSubmitOTPPressed:(id)sender
{
    if (![CommonMethods isValidStr:txtOTP.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter OTP."];
        return;
    }
    [self hideKeyboard];
    [[CPLoader sharedLoader]showLoader:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkOTP];
    });
}
- (IBAction)btnResendOTPPressed:(id)sender
{
    
}
- (IBAction)btnResetPassPressed:(id)sender
{
    if (![CommonMethods isValidStr:txtForgotPassEmail.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter Email ID."];
        return;
    }
    if (![CommonMethods validateEmailWithString:txtForgotPassEmail.text]) {
        [CommonMethods showAlertViewWithMessage:@"Please enter valid email."];
        return;
    }
    [self hideKeyboard];
    [[CPLoader sharedLoader]showLoader:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendEmailForForgotPass];
    });
}

#pragma mark - Service Calling
-(void)checkLoginDetails
{
    //Service Name
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    [paramDict setObject:txtPassword.text forKey:kWS_Login_Req_password];
    [paramDict setObject:txtEmail.text forKey:kWS_Login_Req_email];
    //[paramDict setObject:kWS_user_type forKey:kWS_Login_Req_user_type];
    //[paramDict setObject:@"-" forKey:kWS_Login_Req_auth_token];
    [paramDict setObject:kWS_loginvalidate forKey:kWS_Login_Req_action];

    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            [[NSUserDefaults standardUserDefaults]setObject:txtEmail.text forKey:kWS_Login_Req_email];
            [CommonMethods saveDataIntoPreference:[result valueForKey:@"data"] forKey:kloggedUserInfo];
            [CommonMethods setRadiousAndBorderToTextField:txtOTP];
            [self fadeInAnimationForView:viewOTP];
            viewOTP.frame = self.view.frame;
        }else{
            [CommonMethods showAlertViewWithMessage:@"Invalid username or password."];
        }
        [[CPLoader sharedLoader]hideSpinner];
    }];
}
-(void)checkOTP
{
    //Service Name
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    [paramDict setObject:txtOTP.text forKey:kWS_otp_verification_Req_OTP];
    
    [paramDict setObject:[CommonMethods getValueFromNSUserDefaultsWithKey:kWS_Login_Req_email] forKey:kWS_otp_verification_Req_email];
    [paramDict setObject:kWS_user_type forKey:kWS_otp_verification_Req_user_type];
    [paramDict setObject:[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Req_auth_token] forKey:kWS_otp_verification_Req_auth_token];
    [paramDict setObject:kWS_otp_verification forKey:kWS_Login_Req_action];
    
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            [self gotoProductList];
        }else{
            [CommonMethods showAlertViewWithMessage:@"Invalid username or password."];
        }
        [[CPLoader sharedLoader]hideSpinner];
    }];
}
- (void)sendEmailForForgotPass
{
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    [paramDict setObject:txtForgotPassEmail.text forKey:kWS_forgot_password_Req_email];
    [paramDict setObject:kWS_forgot_password forKey:kWS_Login_Req_action];
    
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            [self fadeOutAnimationForView:viewResetPass];
            
        }else{
            [CommonMethods showAlertViewWithMessage:@"Some error occured while sending Email."];
        }
        [[CPLoader sharedLoader]hideSpinner];
    }];
}
- (void)gotoProductList
{
    ProductListViewController *orderOBJ = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    [self.navigationController pushViewController:orderOBJ animated:YES];
}
- (void)fadeInAnimationForView:(UIView *)someView
{
    [someView setAlpha:0];
    [self.view addSubview:someView];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [someView setAlpha:1];
    [UIView commitAnimations];
}
- (void)fadeOutAnimationForView:(UIView *)someView{
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.5 ];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [someView setAlpha:0];
    [UIView commitAnimations];
}
//#pragma mark - Service Delegate
//-(void)webServiceResponse:(NSDictionary *)response serviceName:(NSString *)name
//{
//    if ([name isEqualToString:kWS_loginvalidate]) {
//        if ([[response valueForKey:@"success"]intValue] == 1){
//                [CommonMethods saveDataIntoPreference:[response valueForKey:@"data"] forKey:kloggedUserInfo];
//            [self fadeInAnimationForView:viewOTP];
//            }else{
//                [CommonMethods showAlertViewWithMessage:@"Invalid username or password."];
//        }
//     }
//    [[CPLoader sharedLoader]hideSpinner];
//}

#pragma mark - TexfField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self slideUpKeyBoard];
}
-(void)slideUpKeyBoard
{
    if (!isKeyUp) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard) name:@"NeedToHideKeyboard" object:nil];
        isKeyUp=true;
        [UIView beginAnimations:@"S" context:nil];
        self.view.frame = CGRectOffset(self.view.frame, 0, -140);
        [UIView commitAnimations];
    }
}
-(void)hideKeyboard
{
    if (isKeyUp) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        isKeyUp=false;
        [[self view] endEditing:TRUE];
        [UIView beginAnimations:@"S" context:nil];
        self.view.frame = CGRectOffset(self.view.frame, 0, 140);
        [UIView commitAnimations];
    }
}
#pragma mark - Touch Event Methods to Hide Keyboard
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (isKeyUp) {
        [self hideKeyboard];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
