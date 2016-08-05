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
    [imgViewProduct sd_setImageWithURL:[NSURL URLWithString:[self.dataDict valueForKey:kWS_grouplist_Res_image]]
                 placeholderImage:nil
                          options:SDWebImageRefreshCached];
    lblProductName.text = [self.dataDict valueForKey:kWS_grouplist_Res_product_name];
    lblProductDesc.text = [self.dataDict valueForKey:kWS_grouplist_Res_group_name];
    [btnZoom setImage:[CommonMethods imageWithIcon:@"fa-search-plus" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:40] forState:UIControlStateNormal];
}

#pragma mark - IBActions
- (IBAction)btnAddtoCartTapped:(id)sender
{
    arraySizeAndQty = [NSArray arrayWithArray:[self.dataDict valueForKey:kWS_grouplist_Res_sizes_quantity]];
    [btnCloseAddtoCartView setImage:[CommonMethods imageWithIcon:@"fa-times-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:30] forState:UIControlStateNormal];
    [self.view addSubview:viewAddToCart];
    viewAddToCart.frame = self.view.frame;
    [txtViewDesc.layer setBorderWidth:1];
    [txtViewDesc.layer setBorderColor:[[UIColor grayColor] CGColor]];
}
- (IBAction)btnAddToCartSubmitTapped:(id)sender
{
    
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (arraySizeAndQty.count>0) {
        [cell setLayoutWithData:[arraySizeAndQty objectAtIndex:indexPath.row]];
    }
    return cell;
}
#pragma mark - TableView Delegate
- (void)textFieldEditingBegin:(id)cell withTextField:(UITextField *)textField
{
    
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
