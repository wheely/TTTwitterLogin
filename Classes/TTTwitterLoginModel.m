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


#import "TTTwitterLoginModel.h"

#import "TTTwitterLogin.h"

static NSString* kTwitterLoginURL = @"http://%@:%@@twitter.com/statuses/user_timeline.xml";


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterLoginModel


@synthesize credentials = _credentials;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_credentials);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)login:(NSString *)username password:(NSString *)password {
    NSString* url = [NSString stringWithFormat:kTwitterLoginURL, username, password];
    TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
    
    
    request.httpMethod = @"GET";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.shouldHandleCookies = NO;
    
    id<TTURLResponse> response = [[TTURLDataResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);    
    
    TTTwitterLogin* userInfo = [[TTTwitterLogin alloc] init];
    userInfo.username = username;
    userInfo.password = password;
    request.userInfo = userInfo;
    TT_RELEASE_SAFELY(userInfo);
    
    [request send];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStartLogin" object:self userInfo:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTTwitterLogin* userInfo = request.userInfo;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.username forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didLogin" object:self userInfo:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    // Cancel the request
    [request cancel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailLogin" object:self userInfo:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailLogin" object:self userInfo:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    TT_RELEASE_SAFELY(_credentials);
    _credentials = [[TTTwitterLogin alloc] init];
    _credentials.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    _credentials.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    [self didFinishLoad];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoadingMore {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isOutdated {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return !!_credentials;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmpty {
    return NO;
}


@end
