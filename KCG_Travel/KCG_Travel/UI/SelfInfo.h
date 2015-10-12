//
//  ViewController.h
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SelfInfoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>

{
    IBOutlet UIView         *thisView;
    IBOutlet UILabel        *lwait;
    IBOutlet UILabel        *lMainTitle;
    IBOutlet UISearchBar    *thisSearchBar;
    IBOutlet MKMapView      *thisMap;
    IBOutlet UILabel        *lHint;
    IBOutlet UIToolbar      *thisToolBar;
    
    //Event
    UITapGestureRecognizer  *singleTap;
    NSString                *sSendName;
    //MKPointAnnotation       *sendPoint;

    Global                  *global;
    NSMutableArray          *allPoint;
    NSMutableArray          *allPointXY;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

-(IBAction)bGotoAction_Action:(id)sender;
-(IBAction)bGotoScence_Action:(id)sender;
-(IBAction)bGotoFood_Action:(id)sender;
-(IBAction)bGotoHotel_Action:(id)sender;
-(IBAction)bGotoSelf_Action:(id)sender;
@end

