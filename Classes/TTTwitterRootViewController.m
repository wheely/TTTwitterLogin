//
//  TTTwitterRootViewController.m
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TTTwitterRootViewController.h"

#import "Atlas.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterRootViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    self.title = @"You are loggged in!";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)] autorelease];
}

- (void)logout {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:kLoginURLPath]];
}

@end

