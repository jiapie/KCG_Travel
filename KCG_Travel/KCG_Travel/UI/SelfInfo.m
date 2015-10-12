//
//  ViewController.m
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "SelfInfo.h"

@interface SelfInfoViewController ()

@end

@implementation SelfInfoViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *send = segue.destinationViewController;
    //NSLog(@"GoTo:%@",segue.identifier);
    [global.dGlobal setValue:sPage_SelfInfo forKey:sGlobal_from];
    [send setValue:global forKey:sValue_global];
    if([segue.identifier isEqualToString:sPage_DetailInfo])
    {
        [send setValue:sSendName forKey:sValue_sSendName];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self DisplayScreen];
    //[self setAllPoint:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(setAllPoint:) withObject:@"" waitUntilDone:YES];
    });
    
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(UI_IS_IOS8_AND_HIGHER)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    thisMap.showsUserLocation = YES;
    [thisMap setMapType:MKMapTypeHybrid];
    [thisMap setZoomEnabled:YES];
    [thisMap setScrollEnabled:YES];
    
    [self bAim_Action:nil];

    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [thisMap addGestureRecognizer:singleTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self releaseViewMemory];
}

- (void)releaseViewMemory
{
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    
    thisMap.showsUserLocation = NO;
    thisMap.delegate = nil;
    [thisMap removeFromSuperview];
    thisMap = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DisplayScreen
{
    //View
    [Display setScreen:thisView];
    //MainTitle
    [Display setMainTitle:lMainTitle and:NO];
    //SearchBar
    [Display setSearchBar:thisSearchBar];
    //MapView
    [Display setWorkArea:thisMap and:YES];
    //[thisMap setHidden:YES];
    //Hint
    [Display setHintBar:lHint];
    //SystemButton
    [Display setToolBar:thisToolBar];
}

-(void) setAllPoint:(NSString *)sSearch
{
    allPoint        = [[NSMutableArray alloc]init];
    allPointXY      = [[NSMutableArray alloc]init];
    
    //NSLog(@"sSearch:%@",sSearch);
    [self showSceneInfo:sSearch];
    [self showFoodInfo:sSearch];
    [self showHotelInfo:sSearch];
    
    [thisMap addAnnotations:allPoint];
}

-(void)showSceneInfo:(NSString *)sSearch
{
    NSArray *aSceneInfo = [global.dGlobal valueForKey:sJson_Scence];
    //NSLog(@"Count:%ld",aSceneInfo.count);
    
    for(id item in aSceneInfo)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        //NSString *sName = [NSString stringWithFormat:@"%@",Name];
        NSData *Address = [dItem valueForKey:@"Add"];
        //NSString *sAddress = [NSString stringWithFormat:@"%@",Address];
        NSData *Tel = [dItem valueForKey:@"Tel"];
        
        //經度
        NSData *Longitude = [dItem valueForKey:@"Px"];
        NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
        double dbLongitude = [sLongitude doubleValue];
        //緯度
        NSData *Latitude = [dItem valueForKey:@"Py"];
        NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
        double dbLatitude = [sLatitude doubleValue];
        
        CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
        
        NSString *title = [[NSString alloc]initWithFormat:@"[景點] %@",Name];
        NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.title = title;
        point.subtitle = subtitle;
        point.coordinate = naviCoord;
        
        BOOL bCheck = NO;
        if([sSearch isEqualToString:@""])
        {
            bCheck = YES;
        }
        NSRange rSearchResult1 = [title rangeOfString:sSearch];
        NSRange rSearchResult2 = [subtitle rangeOfString:sSearch];
        if((rSearchResult1.location != NSNotFound)||(rSearchResult2.location != NSNotFound)||(bCheck == YES))
        {
            //NSLog(@"add 1:%ld,2:%ld,3:%ld",rSearchResult1.location,rSearchResult2.location,bCheck);
            [allPoint addObject:point];
        }
    }
}

-(void)showFoodInfo:(NSString *)sSearch
{
    NSArray *aFoodInfo = [global.dGlobal valueForKey:sJson_Food];
    //NSLog(@"Count:%ld",aFoodInfo.count);
    
    for(id item in aFoodInfo)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        //NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        NSData *Address = [dItem valueForKey:@"Add"];
        NSData *Tel = [dItem valueForKey:@"Tel"];
        //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
        
        //經度
        NSData *Longitude = [dItem valueForKey:@"Px"];
        NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
        double dbLongitude = [sLongitude doubleValue];
        //緯度
        NSData *Latitude = [dItem valueForKey:@"Py"];
        NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
        double dbLatitude = [sLatitude doubleValue];
        
        CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
        
        NSString *title = [[NSString alloc]initWithFormat:@"[餐廳] %@",Name];
        NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.title = title;
        point.subtitle = subtitle;
        point.coordinate = naviCoord;
        
        BOOL bCheck = NO;
        if([sSearch isEqualToString:@""])
        {
            bCheck = YES;
        }
        NSRange rSearchResult1 = [title rangeOfString:sSearch];
        NSRange rSearchResult2 = [subtitle rangeOfString:sSearch];
        if((rSearchResult1.location != NSNotFound)||(rSearchResult2.location != NSNotFound)||(bCheck == YES))
        {
            [allPoint addObject:point];
        }
    }
}

-(void)showHotelInfo:(NSString *)sSearch
{
    NSArray *aHotolInfo01 = [global.dGlobal valueForKey:sJson_Hotel01];
    NSArray *aHotolInfo02 = [global.dGlobal valueForKey:sJson_Hotel02];
    //NSLog(@"Count:%ld,%ld",aHotolInfo01.count,aHotolInfo02.count);
    
    for(id item in aHotolInfo01)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        //NSString *sName = [NSString stringWithFormat:@"%@",Name];
        NSData *Address = [dItem valueForKey:@"地址"];
        //NSString *sAddress = [NSString stringWithFormat:@"%@",Address];
        //NSLog(@"地址:%@",sAddress);
        NSData *Tel = [dItem valueForKey:@"電話"];
        
        //經度
        NSData *Longitude = [dItem valueForKey:@"經度Lng"];
        NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
        double dbLongitude = [sLongitude doubleValue];
        //緯度
        NSData *Latitude = [dItem valueForKey:@"緯度Lat"];
        NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
        double dbLatitude = [sLatitude doubleValue];
        
        CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
        
        NSString *title = [[NSString alloc]initWithFormat:@"[旅館] %@",Name];
        NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.title = title;
        point.subtitle = subtitle;
        point.coordinate = naviCoord;
        
        BOOL bCheck = NO;
        if([sSearch isEqualToString:@""])
        {
            bCheck = YES;
        }
        NSRange rSearchResult1 = [title rangeOfString:sSearch];
        NSRange rSearchResult2 = [subtitle rangeOfString:sSearch];
        if((rSearchResult1.location != NSNotFound)||(rSearchResult2.location != NSNotFound)||(bCheck == YES))
        {
            [allPoint addObject:point];
        }
    }
    
    for(id item in aHotolInfo02)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        NSData *Address = [dItem valueForKey:@"地址"];
        //NSString *sAddress = [NSString stringWithFormat:@"%@",Address];
        //NSLog(@"地址:%@",sAddress);
        NSData *Tel = [dItem valueForKey:@"電話"];
        
        //經度
        NSData *Longitude = [dItem valueForKey:@"經度Lng"];
        NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
        double dbLongitude = [sLongitude doubleValue];
        //緯度
        NSData *Latitude = [dItem valueForKey:@"緯度Lat"];
        NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
        double dbLatitude = [sLatitude doubleValue];
        
        CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
        
        NSString *title = [[NSString alloc]initWithFormat:@"[民宿] %@",Name];
        NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.title = title;
        point.subtitle = subtitle;
        point.coordinate = naviCoord;
        
        BOOL bCheck = NO;
        if([sSearch isEqualToString:@""])
        {
            bCheck = YES;
        }
        NSRange rSearchResult1 = [title rangeOfString:sSearch];
        NSRange rSearchResult2 = [subtitle rangeOfString:sSearch];
        if((rSearchResult1.location != NSNotFound)||(rSearchResult2.location != NSNotFound)||(bCheck == YES))
        {
            [allPoint addObject:point];
        }
    }
}

//換圖, 換顏色
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //NSLog(@"viewForAnnotation");
    
    //換圖
    MKAnnotationView *annotationView = (MKAnnotationView *)[thisMap dequeueReusableAnnotationViewWithIdentifier:sAnnotationViewReuseIdentifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:sAnnotationViewReuseIdentifier];
    }
    
    //地點 (景點,餐廳, 旅館, 民宿)
    if([[annotation title] isEqualToString:sCurrentLocation])
    {//不換 (原點)
        annotationView = nil;
    }
    else
    {
        NSRange searchResult = [[annotation title] rangeOfString:sTypeScene];
        if(searchResult.location != NSNotFound)
        {
            annotationView.image = [UIImage imageNamed:sPicScence];
        }
        else
        {
            searchResult = [[annotation title] rangeOfString:sTypeFood];
            if(searchResult.location != NSNotFound)
            {
                annotationView.image = [UIImage imageNamed:sPicFood];
            }
            else
            {
                searchResult = [[annotation title] rangeOfString:sTypeHotel01];
                if(searchResult.location != NSNotFound)
                {
                    annotationView.image = [UIImage imageNamed:sPicHotel01];
                }
                else
                {
                    searchResult = [[annotation title] rangeOfString:sTypeHotel02];
                    if(searchResult.location != NSNotFound)
                    {
                        annotationView.image = [UIImage imageNamed:sPicHotel02];
                    }
                }
            }
        }
    }
    annotationView.annotation = annotation;
    // add below line of code to enable selection on annotation view
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   //NSLog(@"changed");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{//資料搜尋
    [thisSearchBar endEditing:YES];
    [thisSearchBar resignFirstResponder];
    
    NSArray *pointsArray = [thisMap annotations];
    [thisMap removeAnnotations:pointsArray];
    [allPoint removeAllObjects];
    
    if(![searchBar.text isEqualToString:@""])
    {
        //[self setAllPoint:searchBar.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(setAllPoint:) withObject:searchBar.text waitUntilDone:YES];
        });
    }
    //[self performSelector:@selector(setAllPoint:) withObject:searchBar.text];
}

-(IBAction)bAim_Action:(id)sender
{
    double dbLatitude = self.locationManager.location.coordinate.latitude;
    double dbLongitude = self.locationManager.location.coordinate.longitude;
    
    if((dbLatitude != 0) && (dbLongitude != 0))
    {
        //bLocation = true;
        MKCoordinateRegion region = {self.locationManager.location.coordinate,NearbyMap};
        [thisMap setRegion:region animated:YES];
    }
    else
    {//無法確認目前位置
        //Taiwan Center
        MKCoordinateRegion region = {KcgSiWei, NearbyMap};
        [thisMap setRegion:region animated:YES];
        
        if(sender != nil)
        {
            [MessageBox showWarningMsg:sErrorTitle and:sGetUserLocationError];
        }
    }
}

-(NSInteger) CalDistance:(CLLocationCoordinate2D)gotoPoint
{
    NSInteger iNear = -1;
    double    dbshortdistance = 0;
    
    for(NSInteger i=0;i<allPoint.count;i++)
    {
        MKPointAnnotation *thisPoint = allPoint[i];
        
        //經度
        double dbLongitude = thisPoint.coordinate.longitude;
        //緯度
        double dbLatitude = thisPoint.coordinate.latitude;
        
        double Location_latitude  = gotoPoint.latitude;
        double Location_longitude = gotoPoint.longitude;
        double distance = [Global distanceBetweenOrderBy:Location_latitude:dbLatitude :Location_longitude:dbLongitude];
        
        if((i == 0) || (distance < dbshortdistance))
        {
            dbshortdistance = distance;
            iNear = i;
        }
    }
    
    if(dbshortdistance > dbShortDistance)
    {
        iNear = -1;
    }
    return  iNear;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:thisMap];
    CLLocationCoordinate2D touchCoordinate =
    [thisMap convertPoint:touchPoint toCoordinateFromView:thisMap];
    
    NSInteger iNear = [self CalDistance:touchCoordinate];
    if(iNear >=0)
    {
        MKPointAnnotation *sendPoint = allPoint[iNear];
        sSendName = sendPoint.title;
        [self performSegueWithIdentifier:sPage_DetailInfo sender:nil];
    }
}

-(IBAction)bGotoAction_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_ActionInfo sender:nil];
}

-(IBAction)bGotoScence_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_SceneInfo sender:nil];
}

-(IBAction)bGotoFood_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_FoodInfo sender:nil];
}

-(IBAction)bGotoHotel_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_HotelInfo sender:nil];
}

-(IBAction)bGotoSelf_Action:(id)sender
{
    //[self performSegueWithIdentifier:sPage_SelfInfo sender:nil];
}
@end
