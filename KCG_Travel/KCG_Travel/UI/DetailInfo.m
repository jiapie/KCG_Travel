//
//  ViewController.m
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "DetailInfo.h"

@interface DetailInfoViewController ()

@end

@implementation DetailInfoViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *send = segue.destinationViewController;
    //NSLog(@"GoTo:%@",segue.identifier);
    [global.dGlobal setValue:sPage_DetailInfo forKey:sGlobal_from];
    [send setValue:global forKey:sValue_global];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self DisplayScreen];
    // Do any additional setup after loading the view, typically from a nib.
    //NSLog(@"From:%@",[global.dGlobal valueForKey:sGlobal_from]);
    //NSLog(@"Name:%@",sSendName);
    
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
    
    [self bAim_Action:nil];
    
    //名稱, 時間, 電話, 地址, 敘述
    tableDisplayArray = [[NSMutableArray alloc]init];
    tableTitleArray = [[NSArray alloc]initWithObjects:@"名稱", @"時間", @"電話", @"地址", @"敘述", nil];
    //Show Data
    [self showDetailData];
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
    [Display setMainTitle:lMainTitle];
    [Display setSubToolBar:subToolBar];
    //MapView
    [Display setWorkArea:thisTableView and:YES];
    //[thisMap setHidden:YES];
    //Hint
    [Display setHintBar:lHint];
    //SystemButton
    [Display setToolBar:thisToolBar];
    
    
    if([Global bFavorite_Check:[global.dGlobal valueForKey:sJson_Favorite] and:sSendName] == YES)
    {//Remove
        [subToolBar.items[3] setImage:[UIImage imageNamed:@"Like.png"]];
    }
    else
    {//Record
        [subToolBar.items[3] setImage:[UIImage imageNamed:sPicLike]];
    }
}

-(void)showActionInfo
{//名稱,時間, 電話, 地址, 敘述
    
    tableDisplayArray = [[NSMutableArray alloc]init];
    
    NSArray *aActionInfo = [global.dGlobal valueForKey:sJson_Action];
    //NSLog(@"Count:%ld",aActionInfo.count);
    
    for(id item in aActionInfo)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        if([sName isEqualToString:sSendName])
        {//名稱,時間,電話,地址,敘述
            
            //名稱
            [tableDisplayArray addObject:sName];
            
            //時間
            NSData *Start = [dItem valueForKey:@"Start"];
            NSString *sStart = [NSString stringWithFormat:@"%@",Start];
            NSData *End = [dItem valueForKey:@"End"];
            NSString *sEnd = [NSString stringWithFormat:@"%@",End];
            //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //[formatter setDateFormat:sDateTimeFormat];    // @"yyyy/MM/dd"
            //NSDate *dateEnd = [formatter dateFromString:sEnd];
            NSString *sTime = [NSString stringWithFormat:@"%@ ~ %@",sStart,sEnd];
            [tableDisplayArray addObject:sTime];
            
            //電話
            NSData *Tel = [dItem valueForKey:@"Tel"];
            NSString *sTel = [NSString stringWithFormat:@"%@",Tel];
            [tableDisplayArray addObject:sTel];

            //地址
            NSData *Address = [dItem valueForKey:@"Add"];
            NSString *sAdd = [NSString stringWithFormat:@"%@",Address];
            [tableDisplayArray addObject:sAdd];
            
            //敘述
            NSData *Description = [dItem valueForKey:@"Description"];
            NSString *sDescription = [NSString stringWithFormat:@"%@",Description];
            [tableDisplayArray addObject:sDescription];
            
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
            
            point = [[MKPointAnnotation alloc] init];
            point.title = title;
            point.subtitle = subtitle;
            point.coordinate = naviCoord;
            break;
        }
    }
}

-(void)showSceneInfo
{//名稱,時間, 電話, 地址, 敘述

    tableDisplayArray = [[NSMutableArray alloc]init];
    
    NSArray *aSceneInfo = [global.dGlobal valueForKey:sJson_Scence];
    //NSLog(@"Count:%ld",aSceneInfo.count);
    
    for(id item in aSceneInfo)
    {
        NSArray *fSplit = [sSendName componentsSeparatedByString:@" "];
        sSendName = fSplit[0];
        
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        if([sName isEqualToString:sSendName])
        {//名稱,時間,電話,地址,敘述
            
            //名稱
            [tableDisplayArray addObject:sName];

            //時間
            NSData *Opentime = [dItem valueForKey:@"Opentime"];
            NSString *sOpentime = [NSString stringWithFormat:@"%@",Opentime];
            [tableDisplayArray addObject:sOpentime];
            
            //電話
            NSData *Tel = [dItem valueForKey:@"Tel"];
            NSString *sTel = [NSString stringWithFormat:@"%@",Tel];
            [tableDisplayArray addObject:sTel];
            
            //地址
            NSData *Address = [dItem valueForKey:@"Add"];
            NSString *sAdd = [NSString stringWithFormat:@"%@",Address];
            [tableDisplayArray addObject:sAdd];
            //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
            
            //敘述
            NSData *Description = [dItem valueForKey:@"Toldescribe"];
            NSString *sDescription = [NSString stringWithFormat:@"%@",Description];
            [tableDisplayArray addObject:sDescription];
            
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
            
            point = [[MKPointAnnotation alloc] init];
            point.title = title;
            point.subtitle = subtitle;
            point.coordinate = naviCoord;
            
            break;
        }
    }
}

-(void)showFoodInfo
{//名稱,時間, 電話, 地址, 敘述
    
    tableDisplayArray = [[NSMutableArray alloc]init];
    
    NSArray *aFoodInfo = [global.dGlobal valueForKey:sJson_Food];
    //NSLog(@"Count:%ld",aFoodInfo.count);
    
    for(id item in aFoodInfo)
    {
        NSArray *fSplit = [sSendName componentsSeparatedByString:@" "];
        sSendName = fSplit[0];
        
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        if([sName isEqualToString:sSendName])
        {//名稱,時間,電話,地址,敘述
            
            //名稱
            [tableDisplayArray addObject:sName];
            
            //時間
            NSData *Opentime = [dItem valueForKey:@"Opentime"];
            NSString *sOpentime = [NSString stringWithFormat:@"%@",Opentime];
            [tableDisplayArray addObject:sOpentime];
            
            //電話
            NSData *Tel = [dItem valueForKey:@"Tel"];
            NSString *sTel = [NSString stringWithFormat:@"%@",Tel];
            [tableDisplayArray addObject:sTel];
            
            //地址
            NSData *Address = [dItem valueForKey:@"Add"];
            NSString *sAdd = [NSString stringWithFormat:@"%@",Address];
            [tableDisplayArray addObject:sAdd];
            
            //敘述
            NSData *Description = [dItem valueForKey:@"Description"];
            NSString *sDescription = [NSString stringWithFormat:@"%@",Description];
            [tableDisplayArray addObject:sDescription];
            
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
            
            point = [[MKPointAnnotation alloc] init];
            point.title = title;
            point.subtitle = subtitle;
            point.coordinate = naviCoord;
            
            break;
        }
    }
}

-(void)showHotelInfo
{//名稱,時間, 電話, 地址, 敘述
    
    BOOL bFind = NO;
    
    tableDisplayArray = [[NSMutableArray alloc]init];
    NSArray *aHotolInfo01 = [global.dGlobal valueForKey:sJson_Hotel01];
    NSArray *aHotolInfo02 = [global.dGlobal valueForKey:sJson_Hotel02];
    //NSLog(@"Count:%ld,%ld",aHotolInfo01.count,aHotolInfo02.count);
    
    for(id item in aHotolInfo01)
    {
        NSArray *fSplit = [sSendName componentsSeparatedByString:@" "];
        sSendName = fSplit[0];
        
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        //名稱
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        if([sName isEqualToString:sSendName])
        {//名稱,時間,電話,地址,敘述
            
            //名稱
            [tableDisplayArray addObject:sName];
            
            //時間
            [tableDisplayArray addObject:@"---"];
            
            //電話
            NSData *Tel = [dItem valueForKey:@"電話"];
            NSString *sTel = [NSString stringWithFormat:@"%@",Tel];
            [tableDisplayArray addObject:sTel];
            
            //地址
            NSData *Address = [dItem valueForKey:@"地址"];
            NSString *sAdd = [NSString stringWithFormat:@"%@",Address];
            [tableDisplayArray addObject:sAdd];
            
            //敘述
            [tableDisplayArray addObject:@"---"];
            
            //經度
            NSData *Longitude = [dItem valueForKey:@"經度Lng"];
            NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
            double dbLongitude = [sLongitude doubleValue];
            //緯度
            NSData *Latitude = [dItem valueForKey:@"經度Lng"];
            NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
            double dbLatitude = [sLatitude doubleValue];
            
            CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
            
            NSString *title = [[NSString alloc]initWithFormat:@"[景點] %@",Name];
            NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
            
            point = [[MKPointAnnotation alloc] init];
            point.title = title;
            point.subtitle = subtitle;
            point.coordinate = naviCoord;
            
            bFind = YES;
            break;
        }
    }
    
    
    if(bFind == NO)
    {
        for(id item in aHotolInfo02)
        {
            NSArray *fSplit = [sSendName componentsSeparatedByString:@" "];
            sSendName = fSplit[0];
            
            NSDictionary *dItem = item;
            //NSLog(@"%@",dItem);
            
            //名稱
            NSData *Name = [dItem valueForKey:@"旅宿名稱"];
            NSString *sName = [NSString stringWithFormat:@"%@",Name];
            
            if([sName isEqualToString:sSendName])
            {//名稱,時間,電話,地址,敘述
                
                //名稱
                [tableDisplayArray addObject:sName];
                
                //時間
                [tableDisplayArray addObject:@"---"];
                
                //電話
                NSData *Tel = [dItem valueForKey:@"電話"];
                NSString *sTel = [NSString stringWithFormat:@"%@",Tel];
                [tableDisplayArray addObject:sTel];
                
                //地址
                NSData *Address = [dItem valueForKey:@"地址"];
                NSString *sAdd = [NSString stringWithFormat:@"%@",Address];
                [tableDisplayArray addObject:sAdd];
                
                //敘述
                [tableDisplayArray addObject:@"---"];
                
                //經度
                NSData *Longitude = [dItem valueForKey:@"經度Lng"];
                NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
                double dbLongitude = [sLongitude doubleValue];
                //緯度
                NSData *Latitude = [dItem valueForKey:@"經度Lng"];
                NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
                double dbLatitude = [sLatitude doubleValue];
                
                CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
                
                NSString *title = [[NSString alloc]initWithFormat:@"[景點] %@",Name];
                NSString *subtitle = [[NSString alloc]initWithFormat:@"地址:%@ 電話:%@",Address,Tel];
                
                point = [[MKPointAnnotation alloc] init];
                point.title = title;
                point.subtitle = subtitle;
                point.coordinate = naviCoord;
                
                bFind = YES;
                break;
            }
        }
    }
}

-(void) showMRTInfo
{
    //NSLog(@"sSendName:%@",sSendName);
    
    tableDisplayArray = [[NSMutableArray alloc]init];
    NSString *sPath = [[NSBundle mainBundle] bundlePath];
    NSString *sFile = [sPath stringByAppendingPathComponent:sFile_MRTData];
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
            NSString *sDNo = [NSString stringWithFormat:@"(%@)",dNo];
            sDNo = [sDNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            //NSLog(@"sDNo:%@",sDNo);
            
            if([sDNo isEqualToString:sSendName])
            {//名稱,時間,電話,地址,敘述
                
                NSData *cName = [dItem valueForKey:@"車站中文名稱"];
                NSString *sCName = [NSString stringWithFormat:@"%@",cName];
                sCName = [sCName stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSData *eName = [dItem valueForKey:@"車站英文名稱"];
                NSString *sEName = [NSString stringWithFormat:@"%@",eName];
                sEName = [sEName stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *title = [NSString stringWithFormat:@"%@ %@ (%@)",sDNo,sCName,sEName];
                //名稱
                [tableDisplayArray addObject:title];
                
                //時間
                [tableDisplayArray addObject:@"---"];
                
                //電話
                [tableDisplayArray addObject:@"---"];
                
                //地址
                [tableDisplayArray addObject:@"---"];
                
                //敘述
                [tableDisplayArray addObject:@"---"];
                
                //經度
                NSData *Longitude = [dItem valueForKey:@"車站經度"];
                NSString *sLongitude = [NSString stringWithFormat:@"%@",Longitude];
                double dbLongitude = [sLongitude doubleValue];
                //緯度
                NSData *Latitude = [dItem valueForKey:@"車站緯度"];
                NSString *sLatitude = [NSString stringWithFormat:@"%@",Latitude];
                double dbLatitude = [sLatitude doubleValue];
                
                CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLatitude,dbLongitude);
                
                point = [[MKPointAnnotation alloc] init];
                point.title = title;
                //point.subtitle = subtitle;
                point.coordinate = naviCoord;
                break;
            }
        }
    }
}

-(void)showDetailData
{
    NSString *sFrom = [global.dGlobal valueForKey:sGlobal_from];
    if([sFrom isEqualToString:sPage_ActionInfo])
    {
        lMainTitle.text = @"活動資料";
        [self showActionInfo];
    }
    else if([sFrom isEqualToString:sPage_SceneInfo])
    {
        lMainTitle.text = @"景點資料";
        [self showSceneInfo];
    }
    else if([sFrom isEqualToString:sPage_FoodInfo])
    {
        lMainTitle.text = @"餐飲資料";
        [self showFoodInfo];
    }
    else if([sFrom isEqualToString:sPage_HotelInfo])
    {
        lMainTitle.text = @"旅館/民宿資料";
        [self showHotelInfo];
    }
    else if ([sFrom isEqualToString:sPage_SelfInfo])
    {//地點 (景點,餐廳, 旅館, 民宿)
    //[餐廳] 全省素食之家
        
        NSArray *fSplit = [sSendName componentsSeparatedByString:@" "];
        sSendName = fSplit[0];
        
        NSRange rSearchResult1 = [sSendName rangeOfString:sTypeScene];
        if(rSearchResult1.location != NSNotFound)
        {
            lMainTitle.text = @"景點資料";
            sSendName = fSplit[1];
            [self showSceneInfo];
        }
        
        rSearchResult1 = [sSendName rangeOfString:sTypeFood];
        if(rSearchResult1.location != NSNotFound)
        {
            lMainTitle.text = @"餐飲資料";
            sSendName = fSplit[1];
            [self showFoodInfo];
        }

        rSearchResult1 = [sSendName rangeOfString:sTypeHotel01];
        NSRange rSearchResult2 = [sSendName rangeOfString:sTypeHotel02];
        if((rSearchResult1.location != NSNotFound)||(rSearchResult2.location != NSNotFound))
        {
            lMainTitle.text = @"旅館/民宿資料";
            sSendName = fSplit[1];
            [self showHotelInfo];
        }
        
        //捷運
        rSearchResult1 = [sSendName rangeOfString:sTypeMRT];
        if((rSearchResult1.location != NSNotFound))
        {
            lMainTitle.text = @"捷運資料";
            sSendName = fSplit[1];
            [self showMRTInfo];
        }
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{//名稱,電話,地址,敘述
    return [tableTitleArray count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)iSection
{
    //NSLog(@"titleForHeaderInSection:%ld",section);
    return [tableTitleArray objectAtIndex:iSection];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
    //return [tableDisplayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = sSimpleTableItem;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    UIWebView *thisActionContent = [[UIWebView alloc]init];
    thisActionContent.frame = CGRectMake(0, 0, UI_SCREEN_W,400);
    
    switch (indexPath.section)
    {//名稱,電話,地址,敘述
        case 0://名稱
        case 1://時間
        case 2://電話
        case 3://地址
            [tableView setRowHeight:Row_OneLine];
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.frame = CGRectMake(0, 0, UI_SCREEN_W, Row_OneLine);
            cell.textLabel.text = tableDisplayArray[indexPath.section];
            break;
            
        case 4://敘述
            cell.textLabel.contentMode = UIControlContentHorizontalAlignmentFill;
            [tableView setRowHeight:400];
            [cell addSubview:thisActionContent];
            //thisActionContent.scalesPageToFit = YES;
            [thisActionContent loadHTMLString:tableDisplayArray[indexPath.section] baseURL:nil];
            break;
            
        default://其他
            cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            break;
    }
    return cell;
}

//selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cellView = [tableView cellForRowAtIndexPath: indexPath];
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
    [self performSegueWithIdentifier:sPage_SelfInfo sender:nil];
}

-(IBAction)bAim_Action:(id)sender
{
    double dbLatitude = self.locationManager.location.coordinate.latitude;
    double dbLongitude = self.locationManager.location.coordinate.longitude;
    
    if((dbLatitude != 0) && (dbLongitude != 0))
    {
        bLocation = YES;
        //MKCoordinateRegion region = {self.locationManager.location.coordinate,NearbyMap};
    }
    else
    {
        bLocation = NO;
    }
}

-(IBAction)bNavigation_Action:(id)sender
{
    if(bLocation == true)
    {
        //現在所在位置
        //CLLocationCoordinate2D naviCoord = self.locationManager.location.coordinate;
        
        // 取得目的地位置
        // 根據目的地設定一個大頭針標示
        MKPlacemark *mark = [[MKPlacemark alloc] initWithCoordinate:point.coordinate addressDictionary:nil];
        MKMapItem *setDestPoint = [[MKMapItem alloc] initWithPlacemark:mark];
        // 設定大頭針上的標籤資訊
        setDestPoint.name = point.title;    //@"目的地";
        
        // 取得起點位置
        // 根據起點座標設定一個大頭針標示
        double dbLatitude = self.locationManager.location.coordinate.latitude;
        double dbLongitude = self.locationManager.location.coordinate.longitude;
        MKPlacemark *markNow = [[MKPlacemark alloc] initWithCoordinate:
                                CLLocationCoordinate2DMake(dbLatitude, dbLongitude) addressDictionary:nil];
        MKMapItem *setSrcPoint = [[MKMapItem alloc] initWithPlacemark:markNow];
        // 設定大頭針上的標籤資訊
        setSrcPoint.name = @"現在位置";
    
        // 決定現在所在位置是起點還是終點
        NSArray *array = [[NSArray alloc] initWithObjects:setSrcPoint, setDestPoint, nil];
    
        //設定導航模式:行車, 走路
        NSDictionary *param = [NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
        //開啓內建的地圖
        [MKMapItem openMapsWithItems:array launchOptions:param];
    }
    else
    {
        [MessageBox showWarningMsg:sWarningTitle and:sCantNavigation];
    }
}

-(IBAction)bShareLine_Action:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]])
    {
        //文字
        NSString *plainString = @"分享的文字";
        NSString *contentKey = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)plainString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
        NSString *contentType = @"text";
        NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",
                               contentType, contentKey];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
        //網址
        NSString *shareurlString = @"分享的網址";
        NSString *contentKeyUrl = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)shareurlString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
        NSString *contentTypeUrl = @"text";
        NSString *urlStringUrl = [NSString stringWithFormat:@"line://msg/%@/%@",
                                  contentTypeUrl, contentKeyUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStringUrl]];
        
        //圖片
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
        NSString *pasteboardName = pasteboard.name;
        NSURL *imageURL = [NSURL URLWithString:@"分享的圖片"];
        [pasteboard setData:UIImagePNGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]]) forPasteboardType:@"public.png"];
        
        NSString *contentTypeImage = @"image";
        NSString *contentKeyImage = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)pasteboardName,NULL,CFSTR(":/?=,!$&'()*+;[]@#"),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        NSString *urlStringImage = [NSString stringWithFormat:@"line://msg/%@/%@",
                                    contentTypeImage, contentKeyImage];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStringImage]];
    }
    else
    {
        [MessageBox showWarningMsg:sWarningTitle and:sNonInstallLINE];
    }
}

-(IBAction)bShareFB_Action:(id)sender
{
    //判斷社群網站的服務是否可用
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        
        //建立對應社群網站的ComposeViewController
        SLComposeViewController *mySocialComposeView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        //插入文字
        [mySocialComposeView setInitialText:@"分享的文字"];
        
        //插入網址
        NSURL *myURL = [[NSURL alloc] initWithString:@"分享的網址"];
        [mySocialComposeView addURL: myURL];
        
        //插入圖片
        UIImage *myImage = [UIImage imageNamed:@"分享的圖片"];
        [mySocialComposeView addImage:myImage];
        
        //呼叫建立的SocialComposeView
        [self presentViewController:mySocialComposeView animated:YES completion:^{
            NSLog(@"%@",sCallSocialComposeVew);
        }];
    }
    else
    {
        [MessageBox showWarningMsg:sWarningTitle and:sNonInstallFB];
    }
}

-(IBAction)bFAvorite_Action:(id)sender
{
    //NSLog(@"Name:%@",sSendName);
    //NSLog(@"Favorite:%@",[global.dGlobal valueForKey:sJson_Favorite]);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    //Copy Data
    for(id item in [global.dGlobal valueForKey:sJson_Favorite])
    {
        [array addObject:item];
    }

    if([Global bFavorite_Check:[global.dGlobal valueForKey:sJson_Favorite] and:sSendName] == YES)
    {//Remove
        [sender setImage:[UIImage imageNamed:sPicLike]];

        for(id item in array)
        {
            NSString *sItem = item;
            if([sItem isEqualToString:sSendName])
            {
                [array removeObject:sSendName];
            }
        }
        [global.dGlobal setValue:array forKey:sJson_Favorite];
    }
    else
    {//Record
        [sender setImage:[UIImage imageNamed:@"Like.png"]];
        [array addObject:sSendName];
        [global.dGlobal setValue:array forKey:sJson_Favorite];
    }
    
    [Global writeFavoriteData:array];

}
@end
