//
//  OrderHeaderView.m
//  WebserviceDemo
//
//  Created by rangam on 7/21/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView


+(id)headerView{
    
    OrderHeaderView *headerView =[[[NSBundle mainBundle] loadNibNamed:@"OrderHeaderView" owner:nil options:nil] lastObject];
    
    if ([headerView isKindOfClass:[OrderHeaderView class]])
        return headerView;
    else
        return nil;
}

-(void)setDetails:(NSDictionary *)dictInfo{
    
    [_btndropdown setImage:[CommonMethods imageWithIcon:@"fa-caret-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:30] forState:UIControlStateNormal];
    _lblOrderName.text = [NSString stringWithFormat:@"%@",dictInfo[@"kOrderName"]];
    _lbltotalItem.text =[NSString stringWithFormat:@"%@ items",dictInfo[@"itemCount"]];
}

-(void)setLabelAttributes:(NSArray *)arr fontsize:(CGFloat)fontSize{
    
    for (UILabel *lbl in arr) {
        
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:fontSize];
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.textColor=[UIColor whiteColor];
        lbl.numberOfLines = 0;
    }
    
}


-(void)SetAttrubutedstring:(NSString*)str username:(UILabel*)lbluser Font1:(NSString*)f1 font2:(NSString*)f2 size1:(CGFloat)sze1  size2:(CGFloat)sze2 {
    
    @try {
        UIFont *arialFont = [UIFont fontWithName:f1 size:sze1];
        NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
        NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:str attributes: arialDict];
        
        UIFont *VerdanaFont = [UIFont fontWithName:f2 size:sze2];
        NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
        NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: lbluser.text attributes:verdanaDict];
        // [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSMakeRange(0, 15))];
        
        [vAttrString appendAttributedString:aAttrString];
        lbluser.attributedText=vAttrString;
    }
    @catch (NSException *exception) {
        
    }
    
}


@end
