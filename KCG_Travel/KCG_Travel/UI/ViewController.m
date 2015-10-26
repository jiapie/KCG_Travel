//
//  ViewController.m
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *send = segue.destinationViewController;
    //NSLog(@"GoTo:%@",segue.identifier);
    [send setValue:global forKey:sValue_global];
}

- (void) actIndicatorBegin:(NSString *)sWarningMsg
{
    //NSLog(@"actIndicatorBegin");
    [MessageBox showWaitMessage:thisView and:lwait and:sWarningMsg];
}

-(void) actIndicatorEnd
{
    //NSLog(@"actIndicatorEnd");
    [MessageBox endWaitMessage:thisView and:lwait];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self DisplayScreen];
    // Do any additional setup after loading the view, typically from a nib.
    global = [[Global alloc]init];
    [global createData];
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     [self performSelectorOnMainThread:@selector(actIndicatorBegin:) withObject:cDataProcessWait waitUntilDone:YES];
     });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(getAllInfo) withObject:nil waitUntilDone:YES];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(actIndicatorEnd) withObject:nil waitUntilDone:YES];
    });
    */
    [self getAllInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSegueWithIdentifier:sPage_ActionInfo sender:nil];
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
    [Display setScreen:thisBackground];
}

-(void)getAllInfo
{
    //活動資料,景點資料,餐飲資料,一般旅館,民宿
    //dAllStatus = [[NSMutableDictionary alloc]init];
    [self getStatus:sGetActionInfoURL and:sJson_Action];
    [self getStatus:sGetSceneInfoURL and:sJson_Scence];
    [self getStatus:sGetFoodInfoURL and:sJson_Food];
    [self getStatus:sGetHotel01InfoURL and:sJson_Hotel01];
    [self getStatus:sGetHote02InfoURL and:sJson_Hotel02];
}

-(BOOL)getStatus:(NSString *) sInfoUrl and:(NSString *)sDataType
{
    //0) Init
    BOOL bSend = YES;
    
    NSString *sUrl = sInfoUrl;
    //NSLog(@"sURL:%@",sUrl);
    NSURL *url = [HttpEx toURL:sUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLResponse *response;
    NSError *err;
    
    NSData *httpBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if(err == nil)
    {
        __autoreleasing NSError* error =nil;
        NSDictionary *dGetStatus = [NSJSONSerialization JSONObjectWithData:httpBody options:NSJSONReadingMutableContainers error: &error];
        //NSLog(@"dGetStatus:%@",sDataType);
    
        [global.dGlobal setValue:dGetStatus forKey:sDataType];
        //NSLog(@"Global:%@",[global.dGlobal valueForKey:sDataType]);
        
        if(error != nil)
        {
            bSend = NO;
        }
    }
    else
    {
        //NSLog(@"%@",err.description);
        bSend = NO;
    }
    
    return bSend;
}
@end
