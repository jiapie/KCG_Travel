//
//  ViewController.h
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface FoodInfoViewController : UIViewController
{
    IBOutlet UIView         *thisView;
    IBOutlet UIImageView    *thisBackground;
    IBOutlet UILabel        *lwait;
    IBOutlet UILabel        *lMainTitle;
    IBOutlet UITableView    *thisTableView;
    IBOutlet UILabel        *lHint;
    IBOutlet UIToolbar      *thisToolBar;
    
    Global                  *global;
    NSString                *sSendName;
    NSMutableArray          *tableArray;
}

-(IBAction)bGotoAction_Action:(id)sender;
-(IBAction)bGotoScence_Action:(id)sender;
-(IBAction)bGotoFood_Action:(id)sender;
-(IBAction)bGotoHotel_Action:(id)sender;
-(IBAction)bGotoSelf_Action:(id)sender;
@end

