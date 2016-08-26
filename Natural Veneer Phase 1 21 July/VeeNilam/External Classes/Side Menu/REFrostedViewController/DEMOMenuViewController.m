//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "ViewController.h"
#import "DEMONavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ProductListViewController.h"
#import "OrderFormViewController.h"
#import "CartViewController.h"
#import "DealerListViewController.h"
#import "DiscussionViewController.h"
@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self addLogoView];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 127 , 106)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"MainLogo.png"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        //        imageView.layer.masksToBounds = YES;
        //        imageView.layer.cornerRadius = 50.0;
        //        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        //        imageView.layer.borderWidth = 3.0f;
        //        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //        imageView.layer.shouldRasterize = YES;
        //        imageView.clipsToBounds = YES;
        
        UILabel *lblWelcome = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 0, 24)];
        lblWelcome.text =@"Welcome";
        lblWelcome.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        lblWelcome.backgroundColor = [UIColor clearColor];
        lblWelcome.textColor = [UIColor whiteColor];
        [lblWelcome sizeToFit];
        lblWelcome.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (lblWelcome.frame.origin.y+lblWelcome.frame.size.height + 5), 0, 24)];
        label.text =[NSString stringWithFormat:@"%@",[CommonMethods getValueFromNSUserDefaultsWithKey:kWS_Login_Req_email]];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        //[view addSubview:lblWelcome];
        //[view addSubview:label];
        view;
    });
    
    arrayMenu = [[NSArray alloc]initWithObjects:@"DASHBOARD",  @"DISCUSSION", @"UPDATES",@"ORDER FORMS",@"LOGOUT", nil];
}
- (void)addLogoView
{
    
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = AppGreenColor;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    NSString *imageName;
    switch (indexPath.row) {
        case 0:
        {
            imageName=@"fa-home";
        }
            break;
        case 1:
        {
            imageName=@"fa-comments-o";
        }
            break;
        case 2:
        {
            imageName=@"fa-bell-o";
        }
            break;
        case 3:
        {
            imageName=@"fa-building-o";
        }
            break;
        case 4:
        {
            imageName=@"fa-sign-out";
        }
            break;
        default:
            break;
    }
    cell.imageView.image = [CommonMethods imageWithIcon:imageName backgroundColor:[UIColor clearColor] iconColor:AppGreenColor fontSize:20];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = AppGreenColor;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id viewControllerOBJ = nil;
    switch (indexPath.row) {
        case 0:{
                viewControllerOBJ =(ProductListViewController *)[[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
            }
            break;
        case 1:{
                if ([[CommonMethods getLoggedUserValueFromNSUserDefaultsWithKey:kWS_Login_Res_user_type] isEqualToString:kuser_type_dealer]) {
                    [self.frostedViewController hideMenuViewController];
                    [self performSelector:@selector(presentDiscussionViewForDealer) withObject:nil afterDelay:0.1];
                    return;
                }else{
                    viewControllerOBJ = (DealerListViewController *)[[DealerListViewController alloc]initWithNibName:@"DealerListViewController" bundle:nil];
                }
            }
            break;
        case 2:{
            
        }
            break;
        case 3:
            {
                viewControllerOBJ =(OrderFormViewController *)[[OrderFormViewController alloc]initWithNibName:@"OrderFormViewController" bundle:nil];
            }
            break;
        case 4:
            {
                [CommonMethods saveDataIntoPreference:nil forKey:kloggedUserInfo];
                viewControllerOBJ =(ViewController *)[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
            }
            break;
        case 5:
            break;
        default:
            
            break;
    }
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:viewControllerOBJ];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
- (void)presentDiscussionViewForDealer
{
    DiscussionViewController *disuOBJ = [[DiscussionViewController alloc]initWithNibName:@"DiscussionViewController" bundle:nil];
    [self presentViewController:disuOBJ animated:YES completion:nil];
}
#pragma mark - Menu Switch Methods

-(void)logOut
{
    [CommonMethods saveDataIntoPreference:nil forKey:kloggedUserInfo];
    ViewController *viewControllerOBJ =[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:viewControllerOBJ];
    self.frostedViewController.contentViewController = navigationController;
}
#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrayMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        //NSArray *titles = @[@"Event", @"View Invitation", @"Media Share",@"Update/Send RSVP", @"Logout"];
        cell.textLabel.text = arrayMenu[indexPath.row];
        
    } 
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = kColorLoginButton;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

@end
