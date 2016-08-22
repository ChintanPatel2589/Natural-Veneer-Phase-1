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
    // Do any additional setup after loading the view from its nib.
}
#pragma mark IBActions
- (IBAction)btnSendTapped:(id)sender
{
    [self sendMessageWithComment:textViewChat.text];
}
- (void)sendMessageWithComment:(NSString *)comment
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_adddismsg]];
    [paramDict setObject:comment forKey:kWS_adddismsg_Req_Comment];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
        }
    }];
    
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
