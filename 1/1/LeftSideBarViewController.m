//
//  LeftNavViewController.m
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import "LeftSideBarViewController.h"
#import "FirstViewController.h"
#import "SideBarSelectedDelegate.h"
@interface LeftSideBarViewController ()
{
    NSArray *_dataList;
    int _selectIdnex;
}
@end

@implementation LeftSideBarViewController

@synthesize mainTableView,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataList = @[@"北京",@"上海",@"天津",@"重庆",@"广东"];
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:0]];
        _selectIdnex = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [_dataList objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        if (indexPath.row == _selectIdnex) {
            [delegate leftSideBarSelectWithController:nil];
        }else
        {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath.row]];
        }
        
    }
    _selectIdnex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UINavigationController *)subConWithIndex:(int)index
{
    FirstViewController *con = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    con.index = index+1;
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:con];
    nav.navigationBar.hidden = YES;
    return nav ;
}

@end
