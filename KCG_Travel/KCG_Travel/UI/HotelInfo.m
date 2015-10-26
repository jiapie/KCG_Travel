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
    [Display setScreen:thisBackground];
    //MainTitle
    [Display setMainTitle:lMainTitle];
    [Display setMainTitleButton:bHotel01 and:YES and:0];
    [Display setMainTitleButton:bHotel02 and:YES and:1];
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
        
        NSData *Star = [dItem valueForKey:@"星等"];
        NSString *sStar = [NSString stringWithFormat:@"%@",Star];
        
        NSData *Name = [dItem valueForKey:@"旅宿名稱"];
        NSString *sName = [NSString stringWithFormat:@"%@",Name];
        
        NSData *Address = [dItem valueForKey:@"地址"];
        NSData *Tel = [dItem valueForKey:@"電話"];
        //NSString *sConnectMsg = [NSString stringWithFormat:@"電話:%@ 地址:%@",Tel,Address];
        
        NSString *sHotelInfo = [NSString stringWithFormat:@"%@,%@\n電話:%@\n地址:%@",sStar, sName, Tel, Address];
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
        
        NSString *sHotelInfo = [NSString stringWithFormat:@"%@\n電話:%@\n地址:%@",sName, Tel, Address];
        [tableArray02 addObject:sHotelInfo];
    }
    
    [thisTableView reloadData];
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
    [Display setTableCell:tableView and:cell and:cell.textLabel.numberOfLines];
    CGFloat cell_H = cell.textLabel.frame.size.height * 2;
    
    switch (indexPath.section)
    {
        case 0: //旅館
            {
                NSArray *fSplit = [[tableArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
                NSString *sTitle = fSplit[1];
                
                UIButton *bStarButton =[UIButton buttonWithType:UIButtonTypeCustom];
                bStarButton.frame = CGRectMake(2.0, 2.0, (cell_H - 4.0), (cell_H - 4.0));
                NSString *sImage = @"3Star.png"; //4Star.png, 5Star.png
                if([fSplit[0] isEqualToString:@"4星"])
                {
                    sImage = @"4Star.png";
                }
                else if([fSplit[0] isEqualToString:@"5星"])
                {
                    sImage = @"5Star.png";
                }
                [bStarButton setImage:[UIImage imageNamed:sImage] forState:UIControlStateNormal];
                
                [[bStarButton layer] setCornerRadius:10.0f];
                [[bStarButton layer] setBorderWidth:1.0f];
                [[bStarButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                [cell addSubview:bStarButton];
                
                UILabel *lContent = [[UILabel alloc]initWithFrame: CGRectMake(cell_H , 0.0, (UI_SCREEN_W - cell_H), cell_H)];
                //lContent.adjustsFontSizeToFitWidth = YES;
                lContent.numberOfLines = 3;
                lContent.text = sTitle;
                [cell addSubview:lContent];
                //cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
            }
            break;
            
        case 1: //民宿
            {
                //NSLog(@"cell_H %f",cell_H);
                UIButton *bStarButton =[UIButton buttonWithType:UIButtonTypeCustom];
                bStarButton.frame = CGRectMake(2.0, 2.0, (cell_H - 4.0), (cell_H - 4.0));
                NSString *sImage = @"OtherHotel.png";
                [bStarButton setImage:[UIImage imageNamed:sImage] forState:UIControlStateNormal];
                
                [[bStarButton layer] setCornerRadius:10.0f];
                [[bStarButton layer] setBorderWidth:1.0f];
                [[bStarButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                [cell addSubview:bStarButton];
                
                UILabel *lContent = [[UILabel alloc]initWithFrame: CGRectMake(cell_H , 0.0, (UI_SCREEN_W - cell_H), cell_H)];
                //lContent.adjustsFontSizeToFitWidth = YES;
                lContent.numberOfLines = 3;
                lContent.text = [tableArray02 objectAtIndex:indexPath.row];
                [cell addSubview:lContent];
                //cell.textLabel.text = [tableArray02 objectAtIndex:indexPath.row];
            }
            break;
            
        default:
            break;
    }
    return cell;
}

//selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cellView = [tableView cellForRowAtIndexPath: indexPath];
    //NSLog(@"section:%ld, %@",cellView.textLabel.text);
    //NSArray *fSplit = [cellView.textLabel.text componentsSeparatedByString:@"\n"];
    //sSendName = fSplit[0];
    
    switch (indexPath.section)
    {
        case 0: //旅館
            {
                NSString *sContent = [tableArray objectAtIndex:indexPath.row];
                NSArray *fSplit = [sContent componentsSeparatedByString:@","];
                NSString *sTitle = fSplit[1];
                
                fSplit = [sTitle componentsSeparatedByString:@"\n"];
                sSendName = fSplit[0];
            }
            break;
            
        case 1: //民宿
            {
                NSString *sContent = [tableArray02 objectAtIndex:indexPath.row];
                NSArray *fSplit = [sContent componentsSeparatedByString:@"\n"];
                sSendName = fSplit[0];
            }
            break;
            
        default:
            break;
    }
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

-(IBAction)bHotel01_Action:(id)sender
{
    [self showHotelInfo];
    
    tableTitleArray = [[NSArray alloc]initWithObjects:@"一般旅館", @"", nil];
    tableArray02 = [[NSMutableArray alloc]init];
    [thisTableView reloadData];
}

-(IBAction)bHotel02_Action:(id)sender
{
    [self showHotelInfo];
    
    tableTitleArray = [[NSArray alloc]initWithObjects:@"", @"民宿", nil];
    tableArray = [[NSMutableArray alloc]init];
    [thisTableView reloadData];
}
@end
