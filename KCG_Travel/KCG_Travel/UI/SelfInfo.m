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
    [self ReloadRecordData];
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(setAllPoint:) withObject:@"" waitUntilDone:YES];
    });
    */
    //NOW
    //[self bAim_Action:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(UI_IS_IOS8_AND_HIGHER)
    {
        [self.locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    thisMap.showsUserLocation = YES;
    //[thisMap setMapType:MKMapTypeHybrid];
    [thisMap setZoomEnabled:YES];
    [thisMap setScrollEnabled:YES];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [thisMap addGestureRecognizer:singleTap];
    
    tableArray = [[NSArray alloc]initWithObjects:@"楠梓區", @"左營區", @"鼓山區", @"三民區", @"鹽埕區", @"前金區", @"新興區", @"苓雅區", @"前鎮區", @"旗津區", @"小港區", @"鳳山區", @"大寮區", @"鳥松區", @"林園區", @"仁武區", @"大樹區", @"大社區", @"岡山區", @"路竹區", @"橋頭區", @"梓官區", @"彌陀區", @"永安區", @"燕巢區", @"田寮區", @"阿蓮區", @"茄萣區", @"湖內區", @"旗山區", @"美濃區", @"內門區", @"杉林區", @"甲仙區", @"六龜區", @"茂林區", @"桃源區", @"那瑪夏區", nil];
    
    //設定所觸發的事件條件與對應事件
    [segmented01 addTarget:self action:@selector(segmented01ControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [segmented02 addTarget:self action:@selector(segmented02ControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = sSimpleTableItem;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    [Display setTableCell:tableView and:cell and:cell.textLabel.numberOfLines];
    
    return cell;
}

//selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath: indexPath];
    [bChooseLocation setTitle:cellView.textLabel.text forState:UIControlStateNormal];
    //+(MKPointAnnotation *) getAddressLatLng:(NSString *)sAddress;

    NSString *sAddress = [NSString stringWithFormat:@"%@%@",sKaohsiungCity, cellView.textLabel.text];
    MKPointAnnotation *point = [Global getAddressLatLng:sAddress];
    MKCoordinateRegion region = {point.coordinate ,NearbyMap};
    [thisMap setRegion:region animated:YES];

    [thisTableView setHidden:YES];
    
    //RECORD
    RecordInfo = [global.dGlobal valueForKey:sJson_Record];
    [RecordInfo setValue:cellView.textLabel.text forKey:sJson_Area];
    [global.dGlobal setValue:RecordInfo forKey:sJson_Record];
}

-(void)DisplayScreen
{
    //View
    [Display setScreen:thisView];
    [Display setScreen:thisBackground];
    //MainTitle
    [Display setMainTitle:lMainTitle];
    [Display setMainTitleButton:bMenu and:YES and:0];
    [Display setMainTitleButton:bMap and:NO and:1];
    [Display setMainTitleButton:bAim and:NO and:0];
    //SearchBar
    [Display setSearchBar:thisSearchBar];
    //MapView
    [Display setWorkArea:thisMap and:YES];
    //[thisMap setHidden:YES];
    //Hint
    [Display setHintBar:lHint];
    //SystemButton
    [Display setToolBar:thisToolBar];
    
    //SubScreen
    [Display setSubScreen:settingsView];
    [Display setSubLabel:lLocation01 and:0];
    [Display setSubButton:segmented01 and:0];    
    [Display setSubLabel:lLocation02 and:1];
    [Display setSubButton:bChooseLocation and:1];
    [bChooseLocation setEnabled:NO];
    [Display setSubLabel:lType and:2];
    [Display setSubButton:segmented02 and:2];
    
    [Display setTableView:thisTableView];
    [thisTableView setHidden:YES];
}

-(void) setAllPoint:(NSString *)sSearch
{
    //NSLog(@"setAllPoint search:%@",sSearch);
    
    allPoint        = [[NSMutableArray alloc]init];
    allPointXY      = [[NSMutableArray alloc]init];
    
    //NSLog(@"sSearch:%@",sSearch);
    [self showMRT:sSearch];
    [self showSceneInfo:sSearch];
    [self showFoodInfo:sSearch];
    [self showHotelInfo:sSearch];
    
    [thisMap addAnnotations:allPoint];
}

-(void) ReloadRecordData
{//READ RECORD
    RecordInfo = [global.dGlobal valueForKey:sJson_Record];
    //NSLog(@"RECORD :%@",RecordInfo);
    
    NSString *sType = [NSString stringWithFormat:@"%@",[RecordInfo valueForKey:sJson_Type]];
    if([sType isEqualToString:sTypeScene])
    {
        segmented02.selectedSegmentIndex = 0;
    }
    else if([sType isEqualToString:sTypeFood])
    {
        segmented02.selectedSegmentIndex = 1;
    }
    else if([sType isEqualToString:sTypeHotel01])
    {
        segmented02.selectedSegmentIndex = 2;
    }
    else //if([sType isEqualToString:sTypeHotel02])
    {
        segmented02.selectedSegmentIndex = 3;
    }
    //NSLog(@"sType:%@",sType);
    [self segmented02ControlIndexChanged:segmented02];
    
    NSString *sLocation = [NSString stringWithFormat:@"%@",[RecordInfo valueForKey:sJson_Loaction]];
    //目前所在位置, 最近的捷運站, 行政區
    if([sLocation isEqualToString:sLocationNow])
    {
        segmented01.selectedSegmentIndex = 0;
    }
    else if([sLocation isEqualToString:sLocationMRT])
    {
        segmented01.selectedSegmentIndex = 1;
    }
    else
    {
        segmented01.selectedSegmentIndex = 2;
    }
    //NSLog(@"sLocation:%@",sLocation);
    [self segmented01ControlIndexChanged:segmented01];
    
    //行政區
    NSString *sArea = [NSString stringWithFormat:@"%@",[RecordInfo valueForKey:sJson_Area]];
    if(![sArea isEqualToString:@""])
    {
        NSString *sAddress = [NSString stringWithFormat:@"%@%@",sKaohsiungCity, sArea];
        MKPointAnnotation *point = [Global getAddressLatLng:sAddress];
        MKCoordinateRegion region = {point.coordinate ,NearbyMap};
        [thisMap setRegion:region animated:YES];
    }
}

-(void)showMRT:(NSString *)sSearch
{
    //NSLog(@"showMRT");    
    NSString *sPath = [[NSBundle mainBundle] bundlePath];
    NSString *sFile = [sPath stringByAppendingPathComponent:@"MRT.json"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:sFile] == YES)
    {
        NSFileHandle *handle01 = [NSFileHandle fileHandleForReadingAtPath:sFile];
        NSData *sAllData = [[NSData alloc]initWithData:[handle01 readDataToEndOfFile]];
        NSArray *aMRTInfo = [NSArray arrayWithJSONData:sAllData];
        //NSLog(@"aMRTInfo:%@",aMRTInfo);
        
        for(id item in aMRTInfo)
        {
            NSDictionary *dItem = item;
            
            NSData *dNo = [dItem valueForKey:@"車站編號"];
            NSString *sDNo = [NSString stringWithFormat:@"%@",dNo];
            sDNo = [sDNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSData *cName = [dItem valueForKey:@"車站中文名稱"];
            NSString *sCName = [NSString stringWithFormat:@"%@",cName];
            sCName = [sCName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSData *eName = [dItem valueForKey:@"車站英文名稱"];
            NSString *sEName = [NSString stringWithFormat:@"%@",eName];
            sEName = [sEName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            //經度
            NSData *Longitude = [dItem valueForKey:@"車站經度"];
            NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
            double dbLongitude = [sLongitude doubleValue];
            //緯度
            NSData *Latitude = [dItem valueForKey:@"車站緯度"];
            NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
            double dbLatitude = [sLatitude doubleValue];
            
            CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
            
            NSString *title = [[NSString alloc]initWithFormat:@"[捷運] (%@) %@ %@",sDNo, sCName, sEName];;
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.title = title;
            point.coordinate = naviCoord;
            
            [allPoint addObject:point];
        }
    }
}

-(void)showSceneInfo:(NSString *)sSearch
{
    //NSLog(@"showSceneInfo");
    
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
    
    //地點 (景點,餐廳, 旅館, 民宿, 捷運)
    if([[annotation title] isEqualToString:sCurrentLocation])
    {//不換 (原點)
        annotationView = nil;
    }
    else
    {
        //景點
        NSRange searchResult = [[annotation title] rangeOfString:sTypeScene];
        if(searchResult.location != NSNotFound)
        {
            annotationView.image = [UIImage imageNamed:sPicScence];
        }
        
        //餐廳
        searchResult = [[annotation title] rangeOfString:sTypeFood];
        if(searchResult.location != NSNotFound)
        {
            annotationView.image = [UIImage imageNamed:sPicFood];
        }
        
        //旅館
        searchResult = [[annotation title] rangeOfString:sTypeHotel01];
        if(searchResult.location != NSNotFound)
        {
            annotationView.image = [UIImage imageNamed:sPicHotel01];
        }
        
        //民宿
        searchResult = [[annotation title] rangeOfString:sTypeHotel02];
        if(searchResult.location != NSNotFound)
        {
            annotationView.image = [UIImage imageNamed:sPicHotel02];
        }
        
        //捷運
        searchResult = [[annotation title] rangeOfString:sTypeMRT];
        if(searchResult.location != NSNotFound)
        {
            NSRange searchColor = [[annotation title] rangeOfString:@"R"];
            if(searchColor.location != NSNotFound)
            {
                annotationView.image = [UIImage imageNamed:sPicMRTR];
            }
            else
            {
                annotationView.image = [UIImage imageNamed:sPicMRTO];
            }
        }
        
        //最愛
        //NSLog(@"title:%@",[annotation title]);
        NSArray *fSplit = [[annotation title] componentsSeparatedByString:@" "];
        if(fSplit.count > 1)
        {
            if([Global bFavorite_Check:[global.dGlobal valueForKey:sJson_Favorite] and:fSplit[1]] == YES)
            {
                //NSLog(@"Love:%@",[annotation title]);
                annotationView.image = [UIImage imageNamed:sPicLike];
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

-(IBAction)bMenu_Action:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = settingsView.frame;
    //NSLog(@"x:%f,y:%f,w:%f,h:%f",vButtonView.frame.origin.x,vButtonView.frame.origin.y,vButtonView.frame.size.width,vButtonView.frame.size.height);
    
    if (rect.origin.y <0)
    {//Show
        //NSLog(@"Show");
        rect.origin.y = StartTopH + MainMenuBarH;        
    }
    else //if (rect.origin.y >= 0)
    {//Hide
        //NSLog(@"Hide");
        rect.origin.y = 0 - rect.size.height;
        [thisTableView setHidden:YES];
    }
    settingsView.frame = rect;
    [UIView commitAnimations];
}

-(IBAction)bMap_Action:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:sMapMode
                message:@""
                delegate:self
                cancelButtonTitle:cCancel
                otherButtonTitles:sMapMode01, sMapMode02, sMapMode03,nil];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0)
    {
        thisMap.mapType = (buttonIndex - 1);
    }
}

-(IBAction)bAim_Action:(id)sender
{
    double dbLatitude = self.locationManager.location.coordinate.latitude;
    double dbLongitude = self.locationManager.location.coordinate.longitude;
    
    if((dbLatitude != 0) && (dbLongitude != 0))
    {
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

-(IBAction)bChooseLocation_Action:(id)sender
{
    if(thisTableView.hidden == YES)
    {
        [thisTableView setHidden:NO];
    }
    else
    {
        [thisTableView setHidden:YES];
    }
}

- (void)segmented01ControlIndexChanged:(id)sender
{
    //NSLog(@"title:%@",[sender title]);
    //NSLog(@"segmented01ControlIndexChanged %@", [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
    
    [bChooseLocation setEnabled:NO];
    [thisTableView setHidden:YES];
    
    /*
    NSArray *pointsArray = [thisMap annotations];
    [thisMap removeAnnotations:pointsArray];
    [allPoint removeAllObjects];
    */
    
    //RECORD
    RecordInfo = [global.dGlobal valueForKey:sJson_Record];
    [RecordInfo setValue:[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] forKey:sJson_Loaction];
    [global.dGlobal setValue:RecordInfo forKey:sJson_Record];
    
    switch ([sender selectedSegmentIndex])
    {
        case 0: //所在位置
            [self bAim_Action:nil];
            break;

        case 1: //最近捷運站
            {
                double dbLatitude = self.locationManager.location.coordinate.latitude;
                double dbLongitude = self.locationManager.location.coordinate.longitude;
                if((dbLatitude != 0) && (dbLongitude != 0))
                {
                    MKCoordinateRegion region = {self.locationManager.location.coordinate,NearbyMap};
                    //[thisMap setRegion:region animated:YES];
                    
                    CLLocationCoordinate2D touchCoordinate = region.center;
                    NSInteger iNear = [self CalDistanceFromMRT:touchCoordinate];
                    if(iNear >=0)
                    {
                        MKPointAnnotation *sendPoint = allPoint[iNear];
                        MKCoordinateRegion region = {sendPoint.coordinate, NearbyMap};
                        [thisMap setRegion:region animated:YES];
                    }
                }
                else
                {
                    //Taiwan Center
                    MKCoordinateRegion region = {KcgSiWei, NearbyMap};
                    
                    CLLocationCoordinate2D touchCoordinate = region.center;
                    NSInteger iNear = [self CalDistanceFromMRT:touchCoordinate];
                    if(iNear >=0)
                    {
                        MKPointAnnotation *sendPoint = allPoint[iNear];
                        MKCoordinateRegion region = {sendPoint.coordinate, NearbyMap};
                        [thisMap setRegion:region animated:YES];
                    }
                    
                }
            }
            break;
            
        case 2: //行政區
            [bChooseLocation setEnabled:YES];
            break;
    
        default:
            break;
    }
}

- (void)segmented02ControlIndexChanged:(id)sender
{
    //NSLog(@"title:%@",[sender title]);
    //NSLog(@"segmented02ControlIndexChanged %@", [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
    
    NSString *sSearch = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    //NSLog(@"search:%@",sSearch);
    [thisTableView setHidden:YES];
    NSArray *pointsArray = [thisMap annotations];
    [thisMap removeAnnotations:pointsArray];
    [allPoint removeAllObjects];
    
    //RECORD
    RecordInfo = [global.dGlobal valueForKey:sJson_Record];
    [RecordInfo setValue:[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] forKey:sJson_Type];
    [global.dGlobal setValue:RecordInfo forKey:sJson_Record];

     switch ([sender selectedSegmentIndex])
     {//地點 (景點,餐廳, 旅館, 民宿)
         case 0: //景點
         case 1: //餐廳
         case 2: //旅館
         case 3: //民宿
             {
                dispatch_async(dispatch_get_main_queue(), ^{[self performSelectorOnMainThread:@selector(setAllPoint:) withObject:sSearch waitUntilDone:YES];
                });
             }
             break;
             
         default:
             break;
     }
}

-(NSInteger) CalDistanceFromMRT:(CLLocationCoordinate2D)gotoPoint
{
    NSInteger iNear = -1;
    double    dbshortdistance = 0;
    
    for(NSInteger i=0;i<allPoint.count;i++)
    {
        MKPointAnnotation *thisPoint = allPoint[i];
        
        NSRange rSearchResult1 = [thisPoint.title rangeOfString:sTypeMRT];
        if(rSearchResult1.location != NSNotFound)
        {
            //NSLog(@"Cal %@",thisPoint.title);
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
    }
    
    if(dbshortdistance > dbShortDistance)
    {
        iNear = -1;
    }
    return  iNear;
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
