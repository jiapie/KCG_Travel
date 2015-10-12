//
//  MessageBox.h
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/2/26.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#ifndef shennong_produce_MessageBox_h
#define shennong_produce_MessageBox_h

#import "Global.h"

//Error Msg (http)
static NSString *sNormalTitle           = @"狀態回覆";
static NSString *sErrorTitle            = @"錯誤訊息";
static NSString *sWarningTitle          = @"警告訊息";
static NSString *sGetUserLocationError  = @"無法確認使用者位置";
//ShareFB,Line
static NSString *sCallSocialComposeVew  = @"成功呼叫 SocialComposeView";
static NSString *sNonInstallFB          = @"裝置上沒有安裝Facebook";
static NSString *sNonInstallLINE        = @"裝置上沒有安裝LINE";
static NSString *sCantNavigation        = @"無法確認目前所在位置";

@interface MessageBox: NSObject
+(void)showWarningMsg:(NSString *)sTitle and:(NSString *)sWarning;
+(void)showWaitMessage:(UIView *)thisView and:(UILabel *)lwait and:(NSString *)sMsg;
+(void)endWaitMessage:(UIView *)thisView and:(UILabel *)lwait;
//+(UIAlertView *)showWaitMessageAlert:(NSString *)sMsg;
//+(void)endWaitMessageAlert:(UIAlertView *)message;
@end
#endif
