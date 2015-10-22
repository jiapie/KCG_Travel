//
//  Global.h
//  shennong-produce
//
//  Created by Lee, Chia-Pei on 2015/4/21.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#ifndef shennong_produce_Global_h
#define shennong_produce_Global_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <Mapkit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "httpEX.h"
#import "jsonEX.h"
#import "MessageBox.h"
#import "Display.h"

//IOS Version
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//UI IPAD,IPHONE
#define UI_IS_IPAD      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//IPHONE(iPhone 5,6,6PLUS)
#define IPHONE4_SCREEN_WIDTH    320
#define UI_IS_IPHONE4   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS   (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations

#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width
static NSString *sFile_MRTData                      = @"MRT.json";
static NSString *sFile_Favorite                     = @"Favorite.json";
//頁面切換
static NSString *sPage_MainMenu                     = @"MainMenu";
static NSString *sPage_ActionInfo                   = @"ActionInfo";
static NSString *sPage_SceneInfo                    = @"SceneInfo";
static NSString *sPage_FoodInfo                     = @"FoodInfo";
static NSString *sPage_HotelInfo                    = @"HotelInfo";
static NSString *sPage_SelfInfo                     = @"SelfInfo";
static NSString *sPage_DetailInfo                   = @"DetailInfo";
//Map
static CLLocationCoordinate2D TaiwanCenter          = {23.5832,120.5825};
static CLLocationCoordinate2D KcgSiWei              = {22.6208359,120.3120159};
static MKCoordinateSpan AllMap                      = {3.50f, 3.50f};
static MKCoordinateSpan NearbyMap                   = {0.015f, 0.015f};
static double dbShortDistance                       = 3.0;
//TableView
static NSString *sSimpleTableItem   = @"SimpleTableItem";
//MapView
static NSString *sAnnotationViewReuseIdentifier     = @"annotationViewReuseIdentifier";
static NSString *sCurrentLocation   = @"CurrentLocation";
//pic
static NSString *sPicScence     = @"Marker_Footprint.png";
static NSString *sPicFood       = @"Marker_Restaurant.png";
static NSString *sPicHotel01    = @"Marker_Hotel01.png";
static NSString *sPicHotel02    = @"Marker_Hotel02.png";
static NSString *sPicMRTR       = @"MRT_R.png";
static NSString *sPicMRTO       = @"MRT_O.png";
static NSString *sPicLike       = @"Like_F.png";

//URL
//活動資料
static NSString *sGetActionInfoURL    = @"http://data.kaohsiung.gov.tw/Opendata/DownLoad.aspx?Type=2&CaseNo1=AV&CaseNo2=3&FileType=1&Lang=C&FolderType=O";
//景點資料
static NSString *sGetSceneInfoURL    = @"http://data.kaohsiung.gov.tw/Opendata/DownLoad.aspx?Type=2&CaseNo1=AV&CaseNo2=1&FileType=1&Lang=C&FolderType=O";
//餐飲資料
static NSString *sGetFoodInfoURL    = @"http://data.kaohsiung.gov.tw/Opendata/DownLoad.aspx?Type=2&CaseNo1=AV&CaseNo2=2&FileType=1&Lang=C&FolderType=O";
//一般旅館
static NSString *sGetHotel01InfoURL    = @"http://data.kaohsiung.gov.tw/Opendata/DownLoad.aspx?Type=2&CaseNo1=AV&CaseNo2=4&FileType=2&Lang=C&FolderType=O%22";
//民宿
static NSString *sGetHote02InfoURL    = @"http://data.kaohsiung.gov.tw/Opendata/DownLoad.aspx?Type=2&CaseNo1=AV&CaseNo2=5&FileType=2&Lang=C&FolderType=O";

static NSString *cOK                = @"確定";
static NSString *cCancel            = @"取消";
static NSString *cDataProcessWait   = @"資料處理中";
static NSString *cNonInfo           = @"近期沒有相關訊息";

//sCity
static NSString *sKaohsiungCity     = @"高雄市";
//sLocation
//目前所在位置, 最近的捷運站, 行政區
static NSString *sLocationNow       = @"目前所在位置";
static NSString *sLocationMRT       = @"最近的捷運站";
static NSString *sLocationArea      = @"行政區";
//sType
static NSString *sTypeScene         = @"景點";
static NSString *sTypeFood          = @"餐廳";
static NSString *sTypeHotel01       = @"旅館";
static NSString *sTypeHotel02       = @"民宿";
static NSString *sTypeMRT           = @"捷運";
//Map
static NSString *sMapMode           = @"地圖模式";
static NSString *sMapMode01         = @"道路模式";
static NSString *sMapMode02         = @"衛星空照圖";
static NSString *sMapMode03         = @"道路地圖混合空拍圖";
//Json
static NSString *sJson_Action       = @"Action";
static NSString *sJson_Scence       = @"Scence";
static NSString *sJson_Food         = @"Food";
static NSString *sJson_Hotel01      = @"Hotel01";
static NSString *sJson_Hotel02      = @"Hotel02";
static NSString *sJson_Record       = @"Record";
static NSString *sJson_Favorite     = @"Favorite";

//Json Record
static NSString *sJson_Loaction     = @"Location";
static NSString *sJson_Area         = @"Area";
static NSString *sJson_Type         = @"Type";
//
static NSString *sJson_name         = @"name";
//static NSString *sJson_unit         = @"unit";
//Send,Receive
static NSString *sValue_global      = @"global";
static NSString *sValue_sSendName   = @"sSendName";
//static NSString *sValue_sendPoint   = @"sendPoint";
static NSString *sValue_tableDictionary = @"tableDictionary";
static NSString *sValue_title       = @"title";
static NSString *sValue_section     = @"section";
static NSString *sValue_row         = @"row";
//Global
static NSString *sGlobal_from        = @"from";
//Date
static NSString *sDateTimeFormat    = @"yyyy/MM/dd hh:mm:ss";
enum ChooseDateMode
{
    DisplayAllData = 0,
    DisplayToday,
    DisplayThisWeek,
    DisplayThisMonth
};

@interface Global: NSObject
{
    NSMutableDictionary *dGlobal;
    NSArray             *aLoaction;
    enum ChooseDateMode chooseDateMode;
}

@property NSMutableDictionary   *dGlobal;
@property NSArray               *aLocation;
@property enum ChooseDateMode   chooseDateMode;
-(void)createData;
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;
+(NSDictionary *)getChooseLocation:(NSArray *)aAllLoaction and:(NSString *)name;
+(double)calDuringDays:(NSDate *)fromDate and:(NSDate *)toDate;
+(MKPointAnnotation *) getAddressLatLng:(NSString *)sAddress;
+(double) CalDistanceFromTaiwan:(CLLocationCoordinate2D)gotoPoint;
+(void)writeFavoriteData:(NSArray *)array;
+(BOOL)bFavorite_Check:(NSArray *)array and:(NSString *)sName;
@end

#endif
