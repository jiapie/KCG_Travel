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
        
        CGFloat fFont = [self getFontSize];
        if((thisLabel.frame.size.width / thisLabel.text.length) < [self getFontSize])
        {
            fFont = FONTSIZE_14;
            //fFont = FONTSIZE_20;
        }
        
        [thisLabel setFont:[UIFont fontWithName:Font_Helvetica size:fFont]];
        thisLabel.adjustsFontSizeToFitWidth = YES;
        thisLabel.contentMode = UIControlContentVerticalAlignmentCenter;
        thisLabel.textAlignment = type;
    }
    else if ([thisObject isKindOfClass:[UITextField class]])
    {
        UITextField *thisField = (UITextField *)thisObject;
        [thisField setFont:[UIFont fontWithName:Font_Helvetica size:[self getFontSize]]];
        thisField.adjustsFontSizeToFitWidth = YES;
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
    tableView.rowHeight = [self getTableRowHight:Line];
    CGFloat cellH = tableView.rowHeight / Line;
    CGFloat cellW = UI_SCREEN_W - cellH;
    [cell.textLabel setFrame:CGRectMake(0, 0, cellW, cellH)];
    //cell.textLabel.frame = CGRectMake(0, 0, cellW, cellH);
    [Display setFontStyle:cell.textLabel and:NSTextAlignmentLeft];
    [cell.textLabel setFont:[UIFont fontWithName:Font_Helvetica size:FONTSIZE_20]];
}

+(void)setScreen:(id)thisView
{
    [thisView setFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_H)];
    //NSLog(@"%f,%f",UI_SCREEN_W,UI_SCREEN_H);
}

+(void)setMainTitle:(id)MainTitle and:(BOOL)bBack
{
    CGFloat W = UI_SCREEN_W;
    CGFloat H = MainMenuBarH;
    CGFloat X = 0;
    CGFloat Y = StartTopH ;

    if(bBack == YES)
    {
        W = (UI_SCREEN_W - MainMenuBarH);
        //H = MainMenuBarH;
        X = MainMenuBarH;
        //Y = StartTopH ;
    }

    [MainTitle setFrame:CGRectMake(X, Y, W, H)];
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
    CGFloat W = UI_SCREEN_W;
    CGFloat X = 0;
    CGFloat Y = StartTopH + MainMenuBarH;
    CGFloat H = SearchBarH;

    [thisSearchBar setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"WorkArea %f,%f,%f,%f",X,Y,W,H);
}

+(void)setWorkArea:(id)thisArea and:(BOOL)bBar
{
    CGFloat W = UI_SCREEN_W;
    CGFloat X = 0;
    CGFloat Y = StartTopH + MainMenuBarH;
    CGFloat H = UI_SCREEN_H - StartTopH - MainMenuBarH - HintBarH - MenuBarH;
    if(bBar == YES)
    {
        Y = StartTopH + MainMenuBarH + SearchBarH;
        H = UI_SCREEN_H - StartTopH - MainMenuBarH - SearchBarH - HintBarH - MenuBarH;
    }

    [thisArea setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"WorkArea %f,%f,%f,%f",X,Y,W,H);
}

+(void)setHintBar:(id)thisBar
{
    CGFloat W = UI_SCREEN_W;
    CGFloat H = HintBarH;
    CGFloat X = 0;
    CGFloat Y = UI_SCREEN_H - MenuBarH - H;
    
    [thisBar setFrame:CGRectMake(X, Y, W, H)];
    //NSLog(@"ToolsBar %f,%f,%f,%f",X,Y,W,H);
}

/*
+(void)setSystemButton:(UIButton*)thisButton and:(NSInteger)iIndex and:(BOOL)bHidden
{
    CGFloat buttonW = UI_SCREEN_W / 5;
    CGFloat buttonH = buttonW;
    CGFloat buttonX = (buttonW * iIndex);
    CGFloat buttonY = (UI_SCREEN_H - buttonH);
    
    [thisButton setFrame:CGRectMake(buttonX, buttonY,buttonW, buttonH)];
    [thisButton setBackgroundColor:[UIColor whiteColor]];
    
    [[thisButton layer] setCornerRadius:10.0f];
    [[thisButton layer] setBorderWidth:1.0f];
    [[thisButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    thisButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    thisButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    thisButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if(bHidden == YES)
    {
        [thisButton setHidden:YES];
    }
}
*/

+(void)setToolBar:(UIToolbar *)thisToolBar
{
    CGFloat toolbarW = UI_SCREEN_W;
    CGFloat toolbarH = MenuBarH;
    CGFloat toolbarX = 0;//(buttonW * iIndex);
    CGFloat toolbarY = (UI_SCREEN_H - toolbarH);
    
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

+(void) setSubToolBar:(UIToolbar *)thisToolBar
{
    CGFloat toolbarW = UI_SCREEN_W;
    CGFloat toolbarX = 0;
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
@end
