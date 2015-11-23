//
//  ViewController.h
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

enum DisplayMode
{
    DisplayMRT = 0,
    DisplayLocation,
};

@interface SelfInfoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>

{
    IBOutlet UIView         *thisView;
    IBOutlet UIImageView    *thisBackground;
    IBOutlet UILabel        *lwait;
    IBOutlet UILabel        *lMainTitle;
    IBOutlet UIButton       *bMenu;
    IBOutlet UIButton       *bMap;
    IBOutlet UIButton       *bAim;
    IBOutlet UISearchBar    *thisSearchBar;
    IBOutlet MKMapView      *thisMap;
    IBOutlet UILabel        *lHint;
    IBOutlet UIToolbar      *thisToolBar;
    //SubMenu
    IBOutlet UIView         *settingsView;
    IBOutlet UILabel        *lLocation01;
    IBOutlet UILabel        *lLocation02;
    IBOutlet UILabel        *lType;
    IBOutlet UISegmentedControl  *segmented01;
    IBOutlet UIButton       *bChooseLocation;
    IBOutlet UISegmentedControl  *segmented02;
    IBOutlet UITableView    *thisTableView;
    //Event
    UITapGestureRecognizer  *singleTap;
    NSString                *sSendName;
    //MKPointAnnotation       *sendPoint;

    Global                  *global;
    NSMutableArray          *allPoint;
    NSMutableArray          *allPointXY;
    NSMutableArray          *tableArray;
    NSMutableDictionary     *RecordInfo;
    
    enum DisplayMode        iDisplayMode;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

-(IBAction)bGotoAction_Action:(id)sender;
-(IBAction)bGotoScence_Action:(id)sender;
-(IBAction)bGotoFood_Action:(id)sender;
-(IBAction)bGotoHotel_Action:(id)sender;
-(IBAction)bGotoSelf_Action:(id)sender;

-(IBAction)bMenu_Action:(id)sender;
-(IBAction)bMap_Action:(id)sender;
-(IBAction)bAim_Action:(id)sender;
-(IBAction)bChooseLocation_Action:(id)sender;
@end

