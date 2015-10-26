//
//  ViewController.h
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface DetailInfoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    IBOutlet UIView         *thisView;
    IBOutlet UIImageView    *thisBackground;
    IBOutlet UILabel        *lwait;
    IBOutlet UILabel        *lMainTitle;
    IBOutlet UIToolbar      *subToolBar;
    IBOutlet UITableView    *thisTableView;
    IBOutlet UILabel        *lHint;
    IBOutlet UIToolbar      *thisToolBar;
    
    Global                  *global;
    NSString                *sSendName;
    
    NSString                *section;
    NSString                *row;
    NSMutableDictionary     *tableDictionary;
    NSArray                 *tableTitleArray;
    NSMutableArray          *tableDisplayArray;
    
    BOOL                    bExist;
    BOOL                    bLocation;
    MKPointAnnotation       *point;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

-(IBAction)bGotoAction_Action:(id)sender;
-(IBAction)bGotoScence_Action:(id)sender;
-(IBAction)bGotoFood_Action:(id)sender;
-(IBAction)bGotoHotel_Action:(id)sender;
-(IBAction)bGotoSelf_Action:(id)sender;

//-(IBAction)bAim_Action:(id)sender;
-(IBAction)bNavigation_Action:(id)sender;
-(IBAction)bShareLine_Action:(id)sender;
-(IBAction)bShareFB_Action:(id)sender;
-(IBAction)bFAvorite_Action:(id)sender;
@end

