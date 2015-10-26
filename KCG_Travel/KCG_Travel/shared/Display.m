//
//  MessageBox.m
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/2/26.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "Display.h"

@implementation Display:NSObject
+(void)getAllFontName
{// 列出iPhone上所有的字体    // List all fonts on iPhone
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+(CGFloat) getSpaceWidth
{
    CGFloat temp;
    
    if(UI_IS_IPHONE4)
    {
        temp = 1;
    }
    else if(UI_IS_IPHONE5)
    {
        temp = 2;
    }
    else if(UI_IS_IPHONE6)
    {
        temp = 3;
    }
    else
    {
        temp = 5;
    }
    
    return temp;
}

+(CGFloat) getFontSize
{
    CGFloat fontsize = FONTSIZE_22;
    
    if(UI_IS_IPAD)
    {
        fontsize = FONTSIZE_36;
    }
    
    return fontsize;
}

+(void) setFontStyle:(id)thisObject and:(enum NSTextAlignment)type
{
    if([thisObject isKindOfClass:[UILabel class]])
    {
        //CGFloat fontsize = FONTSIZE_22;
        UILabel *thisLabel = (UILabel *)thisObject;
        
        /*
        CGFloat fFont = [self getFontSize];
        if((thisLabel.frame.size.width / thisLabel.text.length) < [self getFontSize])
        {
            fFont = FONTSIZE_14;
            //fFont = FONTSIZE_20;
        }
        */
        [thisLabel setFont:[UIFont fontWithName:Font_Helvetica size:FONTSIZE_18]];
        //thisLabel.adjustsFontSizeToFitWidth = YES;
        thisLabel.contentMode = UIControlContentVerticalAlignmentCenter;
        thisLabel.textAlignment = type;
    }
    else if ([thisObject isKindOfClass:[UITextField class]])
    {
        UITextField *thisField = (UITextField *)thisObject;
        //[thisField setFont:[UIFont fontWithName:Font_Helvetica size:[self getFontSize]]];
        [thisField setFont:[UIFont fontWithName:Font_Helvetica size:FONTSIZE_18]];
        //thisField.adjustsFontSizeToFitWidth = YES;
        thisField.contentMode = UIControlContentVerticalAlignmentCenter;
        thisField.textAlignment = type;
    }
}

+(CGFloat) getTableRowHight:(NSInteger)Line
{
    CGFloat fontsize = [self getFontSize];
    CGFloat space = [self getSpaceWidth];
    CGFloat LineHeight = (fontsize + space) * (Line + 1);
    
    //NSLog(@"LineHeight:%f",LineHeight);
    return LineHeight;
}

+(void) setTableCell:(UITableView *)tableView and:(UITableViewCell *)cell and:(NSInteger)Line
{
    [cell setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]];
    
    tableView.rowHeight = [self getTableRowHight:Line];
    CGFloat cellH = tableView.rowHeight / Line;
    CGFloat cellW = (UI_SCREEN_W * 0.9) - cellH;
    [cell.textLabel setFrame:CGRectMake(0, 0, cellW, cellH)];
    [Display setFontStyle:cell.textLabel and:NSTextAlignmentLeft];
    [cell.textLabel setFont:[UIFont fontWithName:Font_Helvetica size:FONTSIZE_20]];
}

+(void)setScreen:(id)thisView
{
    [thisView setFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_H)];
    //NSLog(@"%f,%f",UI_SCREEN_W,UI_SCREEN_H);
}

+(void)setMainTitle:(id)MainTitle
{
    CGFloat W = UI_SCREEN_W * 0.9;
    CGFloat H = MainMenuBarH;
    CGFloat X = 0 + (UI_SCREEN_W * 0.05);
    CGFloat Y = StartTopH ;

    [MainTitle setFrame:CGRectMake(X, Y, W, H)];
    [MainTitle setBackgroundColor:[UIColor clearColor]];
}

+(void)setMainTitleButton:(id)thisButton and:(BOOL)bFirst and:(NSInteger)iIndex
{
    CGFloat W = MainMenuBarH;
    CGFloat H = MainMenuBarH;
    CGFloat X = 0 + (UI_SCREEN_W * 0.05) + (MainMenuBarH * iIndex);
    if(bFirst == NO)
    {
        X = (UI_SCREEN_W * 0.9) -  MainMenuBarH - (MainMenuBarH * iIndex);
    }
    CGFloat Y = StartTopH ;
    
    [thisButton setFrame:CGRectMake(X, Y, W, H)];
}

+(void)setBackButton:(UIButton*)thisButton
{
    CGFloat H = MainMenuBarH;
    CGFloat W = H;
    CGFloat X = 0;
    CGFloat Y = StartTopH;
    
    [thisButton setFrame:CGRectMake(X, Y, W, H)];

    [[thisButton layer] setCornerRadius:10.0f];
    [[thisButton layer] setBorderWidth:1.0f];
    [[thisButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    thisButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    thisButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    thisButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

+(void) setSearchBar:(UISearchBar *)thisSearchBar
{
    CGFloat W = UI_SCREEN_W * 0.9;
    CGFloat X = 0 + (UI_SCREEN_W * 0.05);
    CGFloat Y = StartTopH + MainMenuBarH;
    CGFloat H = SearchBarH;

    [thisSearchBar setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"WorkArea %f,%f,%f,%f",X,Y,W,H);
}

+(void)setWorkArea:(id)thisArea and:(BOOL)bBar
{
    CGFloat W = UI_SCREEN_W * 0.9;
    CGFloat X = 0 + (UI_SCREEN_W * 0.05);
    CGFloat Y = StartTopH + MainMenuBarH;
    CGFloat H = (UI_SCREEN_H * 0.95) - StartTopH - MainMenuBarH - HintBarH - MenuBarH;
    if(bBar == YES)
    {
        Y = StartTopH + MainMenuBarH + SearchBarH;
        H = (UI_SCREEN_H * 0.95) - StartTopH - MainMenuBarH - SearchBarH - HintBarH - MenuBarH;
    }

    [thisArea setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"WorkArea %f,%f,%f,%f",X,Y,W,H);
    [thisArea setBackgroundColor:[UIColor clearColor]];
}

+(void)setHintBar:(id)thisBar
{
    CGFloat W = UI_SCREEN_W * 0.9;
    CGFloat H = HintBarH;
    CGFloat X = 0 + (UI_SCREEN_W * 0.05);
    CGFloat Y = (UI_SCREEN_H * 0.95) - MenuBarH - H;
    
    [thisBar setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"ToolsBar %f,%f,%f,%f",X,Y,W,H);
}

+(void)setToolBar:(UIToolbar *)thisToolBar
{
    CGFloat toolbarW = UI_SCREEN_W * 0.9;
    CGFloat toolbarH = MenuBarH;
    CGFloat toolbarX = 0  + (UI_SCREEN_W * 0.05);
    CGFloat toolbarY = (UI_SCREEN_H * 0.95) - toolbarH;
    
    [thisToolBar setFrame:CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)];
    [thisToolBar setBackgroundColor:[UIColor whiteColor]];
    
    for(NSInteger i=0;i<thisToolBar.items.count;i++)
    {
        //NSLog(@"W  = %.f",UI_SCREEN_W);
        //50
        CGFloat W = 45;
        if(UI_IS_IPHONE6)
        {//60
            W = 54;
        }
        else if (UI_IS_IPHONE6PLUS)
        {//68
            W = 63;
        }
        
        thisToolBar.items[i].width = W;
    }
}

+(void) setSubToolBar:(UIToolbar *)thisToolBar
{
    CGFloat toolbarW = UI_SCREEN_W * 0.9;
    CGFloat toolbarX = 0  + (UI_SCREEN_W * 0.05);
    CGFloat toolbarY = StartTopH + MainMenuBarH;
    CGFloat toolbarH = SearchBarH;
    
    [thisToolBar setFrame:CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)];
    [thisToolBar setBackgroundColor:[UIColor whiteColor]];
    
    for(NSInteger i=0;i<thisToolBar.items.count;i++)
    {
        //NSLog(@"W  = %.f",UI_SCREEN_W);
        
        //320
        CGFloat W = 50;
        if(UI_IS_IPHONE6)
        {//375
            W = 60;
        }
        else if (UI_IS_IPHONE6PLUS)
        {//414
            W = 68;
        }
        
        thisToolBar.items[i].width = W;
    }
}

+(void) setSubScreen:(id)thisView
{
    CGFloat H = 170.0;
    [thisView setFrame:CGRectMake((UI_SCREEN_W * 0.05), 0 - H, (UI_SCREEN_W * 0.9), H)];
    //NSLog(@"%f,%f",UI_SCREEN_W,UI_SCREEN_H);
}

+(void) setSubLabel:(id)thisLabel and:(NSInteger)iIndex
{
    CGFloat labelW = 40.0;
    CGFloat labelX = 10.0;
    CGFloat labelY = 40.0 + 40.0 * iIndex;
    CGFloat labelH = 30.0;
    
    [thisLabel setFrame:CGRectMake(labelX,labelY,labelW,labelH)];
}

+(void) setSubButton:(id)thisButton and:(NSInteger)iIndex
{
    //60,70.300,30    
    CGFloat buttonW = (UI_SCREEN_W * 0.9) - 10.0 - 60.0;
    CGFloat buttonX = 60.0;
    CGFloat buttonY = 40.0 + 40.0 * iIndex;
    CGFloat buttonH = 30.0;
    
    [thisButton setFrame:CGRectMake(buttonX,buttonY,buttonW,buttonH)];
}

+(void) setTableView:(id)thisTableView
{
    CGFloat H = 170.0;
    [thisTableView setFrame:CGRectMake((UI_SCREEN_W * 0.05), (StartTopH + MainMenuBarH + H) , (UI_SCREEN_W * 0.9), H)];
}
@end
