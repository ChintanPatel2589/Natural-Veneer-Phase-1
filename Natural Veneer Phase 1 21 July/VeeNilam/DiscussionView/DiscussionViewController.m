//
//  DiscussionViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "DiscussionViewController.h"

@interface DiscussionViewController ()

@end

@implementation DiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    textViewChat.text = @"";
    self.handler = [[GrowingTextViewHandler alloc]initWithTextView:textViewChat withHeightConstraint:heightConstraint];
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:INT_MAX];
    arrayChatList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    [self performSelector:@selector(getAllChatMessages) withObject:nil afterDelay:0.1];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Service Call
- (void)getAllChatMessages
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_discussionmsg]];
    [paramDict setObject:@"20" forKey:kWS_discussionmsg_Req_page_size];
    [paramDict setObject:@"1" forKey:kWS_discussionmsg_Req_start_index];
    if (![[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] isEqualToString:kuser_type_dealer]) {
        [paramDict setObject:[self.dataDictDealer valueForKey:kWS_dealerlist_Res_dealer_id] forKey:kWS_dealerlist_Res_dealer_id];
    }
    //[paramDict setObject:@"1" forKey:kWS_adddismsg_Req_last_chat_id];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arrayChatList = [result valueForKey:kData];
            [tblView reloadData];
        }
    }];
}
- (void)sendMessageWithComment:(NSString *)comment
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_adddismsg]];
    [paramDict setObject:comment forKey:kWS_adddismsg_Req_comment];
    if (![[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] isEqualToString:kuser_type_dealer]) {
        [paramDict setObject:[self.dataDictDealer valueForKey:kWS_dealerlist_Res_dealer_id] forKey:kWS_adddismsg_Req_receiver_id];
    }
    [paramDict setObject:@"9" forKey:kWS_adddismsg_Req_last_chat_id];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
        }
    }];
}
#pragma mark IBActions
- (IBAction)btnSendTapped:(id)sender
{
    [self sendMessageWithComment:textViewChat.text];
}
- (IBAction)btnBackTappedInSameClass:(id)sender
{
    if ([[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] isEqualToString:kuser_type_dealer]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [super btnBackTapped:self];
    }
    
}
#pragma mark Chat TextView Methods
- (void)textViewDidChange:(UITextView *)textView {
    [self enableSendButton];
    [self.handler resizeTextViewWithAnimation:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (void)enableSendButton
{
    if (textViewChat.text.length >0) {
        btnSendMsg.enabled = true;
    }else
        btnSendMsg.enabled = false;
}
-(IBAction)hideKeyBoard
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}
- (void)keyboardWillHide:(NSNotification *)n
{
    //NSDictionary* userInfo = [n userInfo];
    //CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    viewChat.frame = CGRectMake(viewChat.frame.origin.x, self.view.frame.size.height - viewChat.frame.size.height, viewChat.frame.size.width, viewChat.frame.size.height);
    tblView.frame = CGRectMake(tblView.frame.origin.x, viewNavigation.frame.size.height+5, tblView.frame.size.width, (self.view.frame.size.height-viewChat.frame.size.height-viewNavigation.frame.size.height-10));
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:curve];
        
    } completion:^(BOOL finished) {
 
        tblView.frame = CGRectMake(tblView.frame.origin.x, viewNavigation.frame.size.height+5, tblView.frame.size.width, (self.view.frame.size.height - keyboardRect.size.height-viewNavigation.frame.size.height-viewChat.frame.size.height-10));
        viewChat.frame = CGRectMake(viewChat.frame.origin.x, self.view.frame.size.height - keyboardRect.size.height - viewChat.frame.size.height, viewChat.frame.size.width, viewChat.frame.size.height);
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
