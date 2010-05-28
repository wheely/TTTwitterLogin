//
//  TTTwitterLoginAppDelegate.m
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"

#import "TTTwitterRootViewController.h"
#import "TTTwitterLoginViewController.h"

#import "Atlas.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;

    TTURLMap* map = navigator.URLMap;

    [map from:@"*" toViewController:[TTWebController class]];
    [map from:kAppRootURLPath toSharedViewController:[TTTwitterRootViewController class]];
    [map from:kLoginURLPath toModalViewController:[TTTwitterLoginViewController class]];
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
        [navigator openURLAction:[TTURLAction actionWithURLPath:kLoginURLPath]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}


@end
