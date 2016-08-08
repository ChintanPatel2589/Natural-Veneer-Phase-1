//
//  ProductDetailsViewController.m
//  NaturalVeneer
//
//  Created by Chintan patel on 19/07/16.
//  Copyright © 2016 Rangam Infotech. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ImagesLocalViewController.h"
@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lblTitle.text = @"GROUP";
    self.navigationController.navigationBarHidden = true;
    [self setDefaultData];
}
-(void)setDefaultData
{
    [imgViewProduct sd_setImageWithURL:[NSURL URLWithString:[self.dataDict valueForKey:kWS_grouplist_Res_image_big]]
                 placeholderImage:nil
                          options:SDWebImageRefreshCached];
    lblProductName.text = [self.dataDict valueForKey:kWS_grouplist_Res_product_name];
    lblProductDesc.text = [self.dataDict valueForKey:kWS_grouplist_Res_group_name];
    [btnBack setImage:[CommonMethods imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20] forState:UIControlStateNormal];
    
    [btnZoom setImage:[CommonMethods imageWithIcon:@"fa-search-plus" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:40] forState:UIControlStateNormal];
}

#pragma mark - IBActions
- (IBAction)btnAddtoCartTapped:(id)sender
{
    arraySizeAndQty = [NSMutableArray arrayWithArray:[self.dataDict valueForKey:kWS_grouplist_Res_sizes_quantity]];
    [btnCloseAddtoCartView setImage:[CommonMethods imageWithIcon:@"fa-times-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:30] forState:UIControlStateNormal];
    [self.view addSubview:viewAddToCart];
    viewAddToCart.frame = self.view.frame;
    [txtViewDesc.layer setBorderWidth:1];
    [txtViewDesc.layer setBorderColor:[[UIColor grayColor] CGColor]];
}
- (IBAction)btnAddToCartSubmitTapped:(id)sender
{
    if ([CommonMethods connected]) {
        [[CPLoader sharedLoader]showLoader:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self submitAddToCart];
        });
    }else{
        [CommonMethods showAlertViewWithMessage:kNoInternetConnection_alert_Msg];
    }
}
- (IBAction)btnBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)submitAddToCart
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *tmpDict in arraySizeAndQty) {
        NSMutableDictionary *tmpOrderArray = [NSMutableDictionary dictionary];
        [tmpOrderArray setObject:[tmpDict valueForKey:kWS_addtocart_req_required_quantity] forKey:[tmpDict valueForKey:kWS_grouplist_Res_product_size_id]];
        [tmpArray addObject:tmpOrderArray];
    }
    NSMutableDictionary *paramDict =[[NSMutableDictionary alloc]initWithDictionary:[CommonMethods getDefaultValueDictWithActionName:kWS_addtocart]];
    [paramDict setObject:[self.dataDict valueForKey:kWS_grouplist_Res_group_id] forKey:kWS_addtocart_req_product_group_id];
    [paramDict setObject:[self.dataDict valueForKey:kWS_grouplist_Res_product_id] forKey:kWS_addtocart_req_product_id];
    [paramDict setObject:[self.dataDict valueForKey:kWS_grouplist_Res_group_id] forKey:kWS_addtocart_req_group_id];
    [paramDict setObject:[CommonMethods getJSONString:tmpArray] forKey:kWS_addtocart_req_required_quantity];
    [paramDict setObject:kWS_addtocart forKey:kAction];
    [[WebServiceHandler sharedWebServiceHandler] callWebServiceWithParam:paramDict withCompletion:^(NSDictionary *result) {
        [[CPLoader sharedLoader] hideSpinner];
        if ([[result valueForKey:@"success"]intValue] == 1){
            [self btnCloseAddToCartTapped:nil];
            [CommonMethods showAlertViewWithMessage:@"Your order placed successfully. Thanks for order."];
        }else{
            [CommonMethods showAlertViewWithMessage:@"Some error occured while placing your order. Please try after some time."];
        }
    }];
}
- (IBAction)btnCloseAddToCartTapped:(id)sender
{
    [viewAddToCart removeFromSuperview];
}
- (IBAction)btnInfoTapped:(id)sender
{
    prodInfoViewOBJ = [[ProductInfoViewController alloc]initWithNibName:@"ProductInfoViewController" bundle:nil];
    prodInfoViewOBJ.dataDict = self.dataDict;
    [self.view addSubview:prodInfoViewOBJ.view];
    prodInfoViewOBJ.view.frame = self.view.frame;
}
- (IBAction)btnPlayTapped:(id)sender
{
    
}
- (IBAction)imageTappedForZoom:(UIButton *)sender
{
    ImagesLocalViewController *localImage = [[ImagesLocalViewController alloc]init];
    localImage.imageArray = [[NSMutableArray alloc ]initWithObjects:imgViewProduct.image,nil];
    localImage.title = @"PHOTO GALLERY";
    localImage.viewTitle = lblProductName.text;
    [self.navigationController pushViewController:localImage animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - OrderList TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arraySizeAndQty.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier=@"AddToCartCell";
    AddToCartCell *cell = (AddToCartCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (arraySizeAndQty.count>0) {
        [cell setLayoutWithData:[arraySizeAndQty objectAtIndex:indexPath.row]];
        cell.txtRequiredQuantity.tag = indexPath.row;
    }
    return cell;
}
#pragma mark - TableView Delegate
- (void)textFieldEditingBegin:(id)cell withTextField:(UITextField *)textField
{
    int availabelQty = [[[arraySizeAndQty objectAtIndex:textField.tag] valueForKey:kWS_grouplist_Res_quantity] intValue];
    if (availabelQty >= [textField.text intValue]) {
        [self replaceObjextAtIndex:textField.tag dict:textField.text];
    }else{
        textField.text = [NSString stringWithFormat:@"%d",availabelQty];
        [textField becomeFirstResponder];
        [CommonMethods showAlertViewWithMessage:[NSString stringWithFormat:@"Only %d availabel. you can't order more then this.",availabelQty]];
    }
    
}
- (void)replaceObjextAtIndex:(NSInteger)index dict:(NSString *)reqQty
{
    NSMutableDictionary *tmpDict = [[arraySizeAndQty objectAtIndex:index] mutableCopy];
    [tmpDict setObject:reqQty forKey:kWS_addtocart_req_required_quantity];
    [arraySizeAndQty replaceObjectAtIndex:index withObject:tmpDict];
}
#pragma textView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self slideUpKeyBoard];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self hideKeyboard];
        return NO;
    }
    
    return YES;
}
-(void)slideUpKeyBoard
{
    if (!isKeyUp) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard) name:@"NeedToHideKeyboard" object:nil];
        isKeyUp=true;
        [UIView beginAnimations:@"S" context:nil];
        self.view.frame = CGRectOffset(self.view.frame, 0, -110);
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
        self.view.frame = CGRectOffset(self.view.frame, 0, 110);
        [UIView commitAnimations];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
