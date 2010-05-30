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

static NSString* kHost = @"twitter.com";
static NSString* kTwitterLoginURL = @"http://twitter.com/statuses/user_timeline.xml";


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
    
    NSURLCredentialStorage *credentialsStorage = [NSURLCredentialStorage sharedCredentialStorage];
    NSDictionary *allCredentials = [credentialsStorage allCredentials];
    
    //iterate through all credentials to find the twitter host
    for (NSURLProtectionSpace *protectionSpace in allCredentials)
        if ([[protectionSpace host] isEqualToString:kHost]){
            //to get the twitter's credentials
            NSDictionary *credentials = [credentialsStorage credentialsForProtectionSpace:protectionSpace];
            //iterate through twitter's credentials, and erase them all
            for (NSString *credentialKey in credentials)
                [credentialsStorage removeCredential:[credentials objectForKey:credentialKey] forProtectionSpace:protectionSpace];
    }
    
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
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [super didUpdateObject:request.userInfo atIndexPath:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    if ([challenge previousFailureCount] == 0) {
        TTTwitterLogin* userInfo = request.userInfo;
        NSURLCredential* newCredential = [NSURLCredential credentialWithUser:userInfo.username password:userInfo.password persistence:NSURLCredentialPersistencePermanent];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    TT_RELEASE_SAFELY(_credentials);
    NSURLProtectionSpace* space = [[NSURLProtectionSpace alloc] initWithHost:kHost port:80 protocol:@"http" realm:@"Twitter API" authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    NSURLCredential* cred = [[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:space];
    
    _credentials = [[TTTwitterLogin alloc] init];
    _credentials.username = [cred user];
    _credentials.password = [cred password];
    
    TT_RELEASE_SAFELY(space);
    [self didFinishLoad];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return !!_credentials;
}


@end
