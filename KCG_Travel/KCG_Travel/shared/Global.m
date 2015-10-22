//
//  Global.m
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/4/21.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "Global.h"

@implementation Global
@synthesize dGlobal;
@synthesize aLocation;
@synthesize chooseDateMode;

-(void)createData
{
    dGlobal         = [[NSMutableDictionary alloc]init];
    aLoaction       = [[NSArray alloc]init];
    chooseDateMode  = DisplayAllData;
    
    //Search Record
    NSMutableDictionary *RecordInfo = [[NSMutableDictionary alloc]init];
    [RecordInfo setValue:sLocationNow forKey:sJson_Loaction];
    [RecordInfo setValue:@"" forKey:sJson_Area];
    [RecordInfo setValue:sTypeScene forKey:sJson_Type];
    [dGlobal setValue:RecordInfo forKey:sJson_Record];
    
    //Favorite
    NSString *sWorkPath = NSTemporaryDirectory();
    NSString *sFilename = [sWorkPath stringByAppendingPathComponent:sFile_Favorite];
    //NSLog(@"sFilename:%@",sFilename);
    //Data
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:sFilename] == YES)
    {//讀出來用
        NSFileHandle *handle01 = [NSFileHandle fileHandleForReadingAtPath:sFilename];
        NSData *sAllData = [handle01 readDataToEndOfFile];
        //NSLog(@"sAllData:%@",sAllData);
        [handle01 closeFile];
        
        if(sAllData != nil)
        {
            //1) read JSON
            NSError *err = nil;
            NSArray *aFavoriteInfo = [NSJSONSerialization JSONObjectWithData:sAllData options: NSJSONReadingMutableContainers error: &err];
        
            //NSLog(@"err:%@",err.description);
            [dGlobal setValue:aFavoriteInfo forKey:sJson_Favorite];
        }
        else
        {
            NSArray *aFavoriteInfo = [[NSArray alloc]init];
            [dGlobal setValue:aFavoriteInfo forKey:sJson_Favorite];            
        }
    }
}

+(void)writeFavoriteData:(NSArray *)array;
{
    NSString *sWorkPath = NSTemporaryDirectory();
    NSString *sFilename = [sWorkPath stringByAppendingPathComponent:sFile_Favorite];
    //NSLog(@"Filename:%@",sFilename);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:sFilename] == YES)
    {
        [fm removeItemAtPath:sFilename error:nil];
    }
    
    //寫檔
    [[NSFileManager defaultManager] createFileAtPath:sFilename contents:nil attributes:nil] ;
    NSFileHandle *handle01  = [NSFileHandle fileHandleForWritingAtPath:sFilename];
    NSString *jsonString = [NSArray NSArraytoJSON:array];
    NSData *sAllData = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    [handle01 writeData:sAllData];
    [handle01 closeFile];
}

+(BOOL)bFavorite_Check:(NSArray *)array and:(NSString *)sName
{
    BOOL bFavorite = NO;
    
    //NSArray *array = [global.dGlobal valueForKey:sJson_Favorite];
    for(id item in array)
    {
        NSString *sItem = item;
        NSRange searchResult = [sName rangeOfString:sItem];
        //NSLog(@"sName:%@,sItem:%@, Length:%ld",sName,sItem,searchResult.location);
        //if([sItem isEqualToString:sName])
        if(searchResult.location != NSNotFound)
        {
            bFavorite = YES;
            break;
        }
    }
    
    return  bFavorite;
}

+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2
{
    double radLat1  =   lat1 * M_PI / 180;
    double radLat2  =   lat2 * M_PI / 180;
    double radLng1  =   lng1 * M_PI / 180;
    double radLng2  =   lng2 * M_PI / 180;
    double EARTH_RADIUS =   6378.137;            //地球半徑 (km)
    
    if (radLat1 < 0)
    {
        radLat1 = M_PI / 2 + fabs(radLat1);// south
    }
    if (radLat1 > 0)
    {
        radLat1 = M_PI / 2 - fabs(radLat1);// north
    }
    if (radLng1 < 0)
    {
        radLng1 = M_PI * 2 - fabs(radLng1);// west
    }
    if (radLat2 < 0)
    {
        radLat2 = M_PI / 2 + fabs(radLat2);// south
    }
    if (radLat2 > 0)
    {
        radLat2 = M_PI / 2 - fabs(radLat2);// north
    }
    if (radLng2 < 0)
    {
        radLng2 = M_PI * 2 - fabs(radLng2);// west
    }
    
    double x1 = EARTH_RADIUS * cos(radLng1) * sin(radLat1);
    double y1 = EARTH_RADIUS * sin(radLng1) * sin(radLat1);
    double z1 = EARTH_RADIUS * cos(radLat1);
    
    double x2 = EARTH_RADIUS * cos(radLng2) * sin(radLat2);
    double y2 = EARTH_RADIUS * sin(radLng2) * sin(radLat2);
    double z2 = EARTH_RADIUS * cos(radLat2);
    
    double d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)+ (z1 - z2) * (z1 - z2));
    
    double theta = acos((EARTH_RADIUS * EARTH_RADIUS + EARTH_RADIUS * EARTH_RADIUS - d * d) / (2 * EARTH_RADIUS * EARTH_RADIUS));
    
    double distance = theta * EARTH_RADIUS;
    
    return  distance;
}

+(NSDictionary *)getChooseLocation:(NSArray *)aAllLoaction and:(NSString *)name
{
    NSDictionary *dLoaction = [[NSDictionary alloc]init];
    
    for(NSInteger i=0;i<aAllLoaction.count;i++)
    {
        dLoaction = aAllLoaction[i];
        if([name isEqualToString:[dLoaction valueForKey:sJson_name]])
        {
            //NSLog(@"name:%@",name);
            break;
        }
    }
    
    return dLoaction;
}

+(double)calDuringDays:(NSDate *)fromDate and:(NSDate *)toDate
{//During DAYs
    
    //NSDate *fromDate = [NSDate date];
    //NSDate *toDate = DateACTTOP;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDate];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    double DuringDays = [difference day];
    
    return  DuringDays;
}

//getLatLongFrom Address
+(MKPointAnnotation *) getAddressLatLng:(NSString *)sAddress
{
    NSArray *fSplit = [sAddress componentsSeparatedByString:@"，"];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    NSString *sSearchLocation = @"https://maps.googleapis.com/maps/api/geocode/json?address=\"[address]\"&sensor=false&language=zh-TW";
    sSearchLocation = [sSearchLocation stringByReplacingOccurrencesOfString:@"[address]" withString:fSplit[0]];
    //NSLog(@"Location:%@",sSearchLocation);
    NSString *encodeUrl = [sSearchLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"encode url: %@", encodeUrl);
    
    NSString *sUrl = encodeUrl;
    NSURL *url = [HttpEx toURL:sUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLResponse *response;
    NSError *err;
    NSData *httpBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if(httpBody == nil)
    {
        point = nil;
    }
    else
    {
        //NSLog(@"body:%@,err:%@",httpBody,err.description);
        __autoreleasing NSError* error =nil;
        NSDictionary *bGetLoactionData = [NSJSONSerialization JSONObjectWithData:httpBody options:NSJSONReadingMutableContainers error: &error];
        //NSLog(@"dGet:%@",bGetLoactionData);
        
        NSArray *aResults = [bGetLoactionData valueForKey:@"results"];
        NSDictionary *dResults = aResults[0];
        NSDictionary *dGeometry = [dResults valueForKey:@"geometry"];
        NSDictionary *dLoaction = [dGeometry valueForKey:@"location"];
        //NSLog(@"location:%@",dLoaction);
        NSData *dLat = [dLoaction valueForKey:@"lat"];
        NSString *sLat = [NSString stringWithFormat:@"%@",dLat];
        double dbLat = [sLat doubleValue];
        NSData *dLng = [dLoaction valueForKey:@"lng"];
        NSString *sLng = [NSString stringWithFormat:@"%@",dLng];
        double dbLng = [sLng doubleValue];
        //NSLog(@"%@,%@",sLat,sLng);
        
        CLLocationCoordinate2D naviCoord = CLLocationCoordinate2DMake(dbLat,dbLng);
        double distance = [Global CalDistanceFromTaiwan:naviCoord];
        //NSLog(@"dis:%f",distance);
        if(distance < 200.0)
        {
            point.title = sAddress;
            point.coordinate = naviCoord;
        }
        else
        {//太遠
            point = nil;
        }
    }
    return point;
}

+(double) CalDistanceFromTaiwan:(CLLocationCoordinate2D)gotoPoint
{
    double Location_latitude  = gotoPoint.latitude;
    double Location_longitude = gotoPoint.longitude;
    
    double distance = [Global distanceBetweenOrderBy:Location_latitude:TaiwanCenter.latitude :Location_longitude:TaiwanCenter.longitude];
    
    return  distance;
}
@end
