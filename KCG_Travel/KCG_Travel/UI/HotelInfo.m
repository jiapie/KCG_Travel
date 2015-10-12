//
//  ViewController.m
//  KCG_Travel
//
//  Created by Lee, Chia-Pei on 2015/10/2.
//  Copyright © 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "HotelInfo.h"

@interface HotelInfoViewController ()

@end

@implementation HotelInfoViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *send = segue.destinationViewController;
    //NSLog(@"GoTo:%@",segue.identifier);
    [global.dGlobal setValue:sPage_HotelInfo forKey:sGlobal_from];
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
    //一般旅館,民宿
    tableTitleArray = [[NSArray alloc]initWithObjects:@"一般旅館", @"民宿", nil];
    [self showHotelInfo];
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

-(void)showHotelInfo
{
    tableArray = [[NSMutableArray alloc]init];
    tableArray02 = [[NSMutableArray alloc]init];

    NSArray *aHotolInfo01 = [global.dGlobal valueForKey:sJson_Hotel01];
    NSArray *aHotolInfo02 = [global.dGlobal valueForKey:sJson_Hotel02];
    //NSLog(@"Count:%ld,%ld",aHotolInfo01.count,aHotolInfo02.count);
    
    for(id item in aHotolInfo01)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        NSData *Address = [dItem valueForKey:@"地址"];
        NSData *Tel = [dItem valueForKey:@"電話"];
        //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
        
        NSString *sHotelInfo = [NSString stringWithFormat:@"%@ 電話:%@\n地點:%@",sName, Tel, Address];
        [tableArray addObject:sHotelInfo];
    }
    
    for(id item in aHotolInfo02)
    {
        NSDictionary *dItem = item;
        //NSLog(@"%@",dItem);
        
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        NSData *Address = [dItem valueForKey:@"地址"];
        NSData *Tel = [dItem valueForKey:@"電話"];
        //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
        
        NSString *sHotelInfo = [NSString stringWithFormat:@"%@ 電話:%@\n地點:%@",sName, Tel, Address];
        [tableArray addObject:sHotelInfo];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection:%ld",section);
    return [tableTitleArray objectAtIndex:section];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iCount;
    switch (section)
    {
        case 0:
            iCount = [tableArray count];
            break;
            
        case 1:
            iCount = [tableArray02 count];
            break;
            
        default:
            break;
    }
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = sSimpleTableItem;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 3;
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
            [Display setTableCell:tableView and:cell and:cell.textLabel.numberOfLines];
            break;
            
        case 1:
            cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
            [Display setTableCell:tableView and:cell and:cell.textLabel.numberOfLines];
            break;
            
        default:
            break;
    }
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
    [self performSegueWithIdentifier:sPage_FoodInfo sender:nil];
}

-(IBAction)bGotoHotel_Action:(id)sender
{
    //[self performSegueWithIdentifier:sPage_HotelInfo sender:nil];
}

-(IBAction)bGotoSelf_Action:(id)sender
{
    [self performSegueWithIdentifier:sPage_SelfInfo sender:nil];
}

@end
