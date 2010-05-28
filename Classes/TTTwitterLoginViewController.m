//
//  TTLoginViewController.m
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TTTwitterLoginViewController.h"

#import "Atlas.h"
#import "TTTwitterLoginDataSource.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterLoginViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    self.tableViewStyle = UITableViewStyleGrouped;
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TT_RELEASE_SAFELY(_emptyTable);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
    
    // disable scrolling after the table view is created
    self.tableView.scrollEnabled = NO;
    
    // Create an empty table view a activity label to better update the table
    _emptyTable = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    TTTableActivityItem *activityCell = [TTTableActivityItem itemWithText:@"Logging in"];
    _emptyTable.rowHeight = 88;
    _emptyTable.backgroundColor = [UIColor clearColor];
    _emptyTable.dataSource = [[TTListDataSource dataSourceWithItems:[NSArray arrayWithObject:activityCell]] retain];
    _emptyTable.scrollEnabled = NO;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[TTTwitterLoginDataSource alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didStartLogin:)
                                                 name: @"didStartLogin"
                                               object: self.dataSource.model];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didLogin:)
                                                 name: @"didLogin"
                                               object: self.dataSource.model];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didFailLogin:)
                                                 name: @"didFailLogin"
                                               object: self.dataSource.model];
}

- (void)didStartLogin:(NSNotification*)notification {
    [self showLoading:YES];
}


- (void)didLogin:(NSNotification*)notification {
    [self showLoading:NO];
    [[[TTNavigator navigator] rootViewController] dismissModalViewControllerAnimated:NO];
}


- (void)didFailLogin:(NSNotification*)notification {
    [self showLoading:NO];
    TTAlertViewController* alert = [[[TTAlertViewController alloc] initWithTitle:@"TTTwitterLogin" message:@"Wrong username or password"] autorelease];
    [alert addCancelButtonWithTitle:@"OK" URL:nil];
    [alert showInView:self.view animated:YES];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show {
    if (show) {
        self.loadingView = _emptyTable;
    }
    else {
        self.loadingView = nil;
    }
}


@end
