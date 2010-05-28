//
//  TTLogin.h
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface TTTwitterLogin : NSObject {
    NSString *_username;
    NSString *_password;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
