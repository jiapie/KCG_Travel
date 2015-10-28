//
//  MessageBox.h
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/2/26.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#ifndef shennong_produce_Display_h
#define shennong_produce_Display_h

#import "Global.h"

#define StartTopH       30
#define MainMenuBarH    30
#define SearchBarH      44
#define HintBarH        21
#define MenuBarH        44

#define Row_OneLine     25
#define Row_Height      70
#define Cell_Height     60
#define Cell_Space      2

#define FONTSIZE_10             10
#define FONTSIZE_14             14
#define FONTSIZE_16             16
#define FONTSIZE_18             18
#define FONTSIZE_20             20
#define FONTSIZE_22             22
#define FONTSIZE_24             24
#define FONTSIZE_28             28
#define FONTSIZE_32             32
#define FONTSIZE_36             36
#define FONTSIZE_38             38
#define FONTSIZE_40             40

static NSString *Font_Helvetica = @"Helvetica";

@interface Display: NSObject
+(void)getAllFontName;
+(CGFloat) getSpaceWidth;
+(CGFloat) getFontSize;
+(CGFloat) getTableRowHight:(NSInteger)Line;
//View
+(void) setScreen:(id)thisView;
+(void) setFontStyle:(id)thisObject and:(enum NSTextAlignment)type;
+(void) setTableCell:(UITableView *)tableView and:(UITableViewCell *)cell and:(NSInteger)Line;
//MainTitle
+(void)setMainTitle:(id)MainTitle;
+(void)setMainTitleButton:(id)thisButton and:(BOOL)bFirst and:(NSInteger)iIndex;
+(void) setBackButton:(UIButton*)thisButton;
//SearchBar
+(void) setSearchBar:(UISearchBar *)thisSearchBar;
//WorkArea
+(void)setWorkArea:(id)thisArea and:(BOOL)bBar;
//Hint
+(void) setHintBar:(id)thisBar;
//SystemButton
//+(void) setSystemButton:(UIButton*)thisButton and:(NSInteger)iIndex and:(BOOL)bHidden;
+(void) setToolBar:(UIToolbar *)thisToolBar;
+(void) setSubToolBar:(UIToolbar *)thisToolBar;
//SubView
+(void) setSubScreen:(id)thisView;
+(void) setSubLabel:(id)thisLabel and:(NSInteger)iIndex;
+(void) setSubButton:(id)thisButton and:(NSInteger)iIndex;
+(void) setTableView:(id)thisTableView;
@end
#endif
