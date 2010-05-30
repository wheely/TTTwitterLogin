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
- (BOOL)persistView:(NSMutableDictionary*)state {
    TTTwitterLoginDataSource* dataSource = (TTTwitterLoginDataSource*)self.dataSource;
    [state setObject:dataSource.usernameField.text forKey:@"username"];
    return [super persistView:state];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)restoreView:(NSDictionary*)state {
    if (self.dataSource) {
        TTTwitterLoginDataSource* dataSource = (TTTwitterLoginDataSource*)self.dataSource;
        NSString* username = [state objectForKey:@"username"];
        dataSource.usernameField.text = username;
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[TTTwitterLoginDataSource alloc] init] autorelease];
    NSLog(@"Model created");
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


- (void)model:(id<TTModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[[TTNavigator navigator] rootViewController] dismissModalViewControllerAnimated:NO];
    [super model:model didUpdateObject:object atIndexPath:indexPath];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    //id userInfo = [error userInfo];
    TTAlertViewController* alert = [[[TTAlertViewController alloc] initWithTitle:@"TTTwitterLogin" message:TTDescriptionForError(error)] autorelease];
    [alert addCancelButtonWithTitle:@"OK" URL:nil];
    [alert showInView:self.view animated:YES];
    [super model:model didFailLoadWithError:error];
}


@end
