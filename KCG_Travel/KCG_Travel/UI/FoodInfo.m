//
//  ViewController.m
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "FoodInfo.h"

@interface FoodInfoViewController ()

@end

@implementation FoodInfoViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *send = segue.destinationViewController;
    //NSLog(@"GoTo:%@",segue.identifier);
    [global.dGlobal setValue:sPage_FoodInfo forKey:sGlobal_from];
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
    // Do any additional setup after loading the view, typically from a nib.
    [self showFoodInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    //MapView
    [Display setWorkArea:thisTableView and:NO];
    //[thisMap setHidden:YES];
    //Hint
    [Display setHintBar:lHint];
    //SystemButton
    [Display setToolBar:thisToolBar];
}

-(void)showFoodInfo
{
    tableArray = [[NSMutableArray alloc]init];

    NSArray *aFoodInfo = [global.dGlobal valueForKey:sJson_Food];
    //NSLog(@"Count:%ld",aFoodInfo.count);
    
    for(id item in aFoodInfo)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"Name"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        NSData *Address = [dItem valueForKey:@"Add"];
        NSData *Tel = [dItem valueForKey:@"Tel"];
        //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
        
        NSData *Opentime = [dItem valueForKey:@"Opentime"];
        NSString *sOpentime = [NSString stringWithFormat:@"%@",Opentime];
        
        NSString *sFoodInfo = [NSString stringWithFormat:@"%@ 電話:%@\n地點:%@\n開放時間:%@",sName, Tel, Address, sOpentime];
        [tableArray addObject:sFoodInfo];
    }
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
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    [Display setTableCell:tableView and:cell and:cell.textLabel.numberOfLines];
    
    return cell;
}

//selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath: indexPath];
    NSArray *fSplit = [cellView.textLabel.text componentsSeparatedByString:@"\n"];
    sSendName = fSplit[0];
    
    [self performSegueWithIdentifier:sPage_DetailInfo sender:nil];
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
    //[self performSegueWithIdentifier:sPage_FoodInfo sender:nil];
}

-(IBAction)bGotoHotel_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_HotelInfo sender:nil];
}

-(IBAction)bGotoSelf_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_SelfInfo sender:nil];
}
@end
