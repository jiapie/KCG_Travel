//
//  ViewController.h
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface HotelInfoViewController : UIViewController
{
    IBOutlet UIView         *thisView;
    IBOutlet UIImageView    *thisBackground;
    IBOutlet UILabel        *lwait;
    IBOutlet UILabel        *lMainTitle;
    IBOutlet UIButton       *bHotel01;      //旅館
    IBOutlet UIButton       *bHotel02;      //民宿
    IBOutlet UITableView    *thisTableView;
    IBOutlet UILabel        *lHint;
    IBOutlet UIToolbar      *thisToolBar;
    
    Global                  *global;
    NSString                *sSendName;
    
    NSArray                 *tableTitleArray;
    NSMutableArray          *tableArray;
    NSMutableArray          *tableArray02;
}

-(IBAction)bGotoAction_Action:(id)sender;
-(IBAction)bGotoScence_Action:(id)sender;
-(IBAction)bGotoFood_Action:(id)sender;
-(IBAction)bGotoHotel_Action:(id)sender;
-(IBAction)bGotoSelf_Action:(id)sender;

-(IBAction)bHotel01_Action:(id)sender;
-(IBAction)bHotel02_Action:(id)sender;
@end
