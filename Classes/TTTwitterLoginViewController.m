//
// Copyright 2010 Wheely
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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


/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show {
    if (show) {
        self.loadingView = _emptyTable;
    }
    else {
        self.loadingView = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSNotifications


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didStartLogin:(NSNotification*)notification {
    [self showLoading:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLogin:(NSNotification*)notification {
    [self showLoading:NO];
    [[[TTNavigator navigator] rootViewController] dismissModalViewControllerAnimated:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLogin:(NSNotification*)notification {
    [self showLoading:NO];
    TTAlertViewController* alert = [[[TTAlertViewController alloc] initWithTitle:@"TTTwitterLogin" message:@"Wrong username or password"] autorelease];
    [alert addCancelButtonWithTitle:@"OK" URL:nil];
    [alert showInView:self.view animated:YES];
}


@end
