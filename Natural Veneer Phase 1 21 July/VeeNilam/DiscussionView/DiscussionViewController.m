//
//  DiscussionViewController.m
//  NaturalVeneer
//
//  Created by Chintan Patel on 8/16/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "DiscussionViewController.h"
#import "NaturalVeneer-Swift.h"
@interface DiscussionViewController ()

@end

@implementation DiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self setInputbar];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Service Call
- (void)getAllChatMessages
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_discussionmsg]];
    [paramDict setObject:@"50" forKey:kWS_discussionmsg_Req_page_size];
    [paramDict setObject:@"1" forKey:kWS_discussionmsg_Req_start_index];
    [paramDict setObject:@"50" forKey:kWS_discussionmsg_Req_last_chat_id];
    if (![[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] isEqualToString:kuser_type_dealer]) {
        [paramDict setObject:[self.dataDictDealer valueForKey:kWS_dealerlist_Res_dealer_id] forKey:kWS_dealerlist_Res_dealer_id];
    }
    //[paramDict setObject:@"1" forKey:kWS_adddismsg_Req_last_chat_id];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        if ([[result valueForKey:@"success"]intValue] == 1){
            arrayChatList =[[NSMutableArray alloc]initWithArray: [result valueForKey:kData]];
            [tblView reloadData];
            [self scrollToTheBottom:NO];
        }
    }];
}
- (void)scrollToTheBottom:(BOOL)animated
{
    if (arrayChatList.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrayChatList.count-1 inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
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
            [self getAllChatMessages];
        }
    }];
}
#pragma mark IBActions
- (IBAction)btnSendTapped:(id)sender
{
    
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
#pragma mark - UITablview DataSource and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayChatList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize tmpSize = [CommonMethods textHeight:[[arrayChatList objectAtIndex:indexPath.row] valueForKey:kWS_discussionmsg_Res_chat_text] widthofLabel:200 fontName:[UIFont systemFontOfSize:17]];
    if (tmpSize.height > 70) {
       return  tmpSize.height+10;
    }else
        return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"ChatTableViewCell";
    ChatTableViewCell *cell = (ChatTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (arrayChatList.count>0) {
        [cell setLayoutWithDict:[arrayChatList objectAtIndex:indexPath.row]];
    }
    return cell;
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
    CGRect tmpInputBarFrame = self.inputbar.frame;
    tmpInputBarFrame.origin.y = self.view.frame.size.height - self.inputbar.frame.size.height;
    self.inputbar.frame = tmpInputBarFrame;
    
    tblView.frame = CGRectMake(tblView.frame.origin.x, viewNavigation.frame.size.height+5, tblView.frame.size.width, (self.view.frame.size.height-self.inputbar.frame.size.height-viewNavigation.frame.size.height-10));
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
        tblView.frame = CGRectMake(tblView.frame.origin.x, viewNavigation.frame.size.height+5, tblView.frame.size.width, (self.view.frame.size.height - keyboardRect.size.height-viewNavigation.frame.size.height-self.inputbar.frame.size.height-10));
        CGRect tmpInputBarFrame = self.inputbar.frame;
        tmpInputBarFrame.origin.y = self.view.frame.size.height - keyboardRect.size.height - self.inputbar.frame.size.height;
        self.inputbar.frame = tmpInputBarFrame;
        [self scrollToTheBottom:NO];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChatBar methods
-(void)setInputbar
{
    self.inputbar.placeholder = nil;
    self.inputbar.delegate = self;
    self.inputbar.leftButtonImage = [UIImage imageNamed:@"share"];
    self.inputbar.rightButtonText = @"Send";
    self.inputbar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];
}
#pragma mark - InputbarDelegate

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    [self sendMessageWithComment:inputbar.text];
}
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
}
@end
