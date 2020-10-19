//
//  TWDiscoverTableViewController.m
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#import "TWDiscoverTableViewController.h"
#import "TWMomentsViewController.h"
#import "Constants.h"

@interface TWDiscoverTableViewController ()

@end

@implementation TWDiscoverTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] init];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        TWMomentsViewController * discoverVC = [[TWMomentsViewController alloc] init];
        discoverVC.hidesBottomBarWhenPushed = YES;
        discoverVC.view.backgroundColor = color_with_rgb(242, 242, 247);;
        [self.navigationController pushViewController:discoverVC animated:YES];
    }
}

@end
