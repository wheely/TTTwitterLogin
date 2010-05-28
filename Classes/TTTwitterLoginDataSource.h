//
//  TTLoginDataSource.h
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class TTTwitterLoginModel;


@interface TTTwitterLoginDataSource : TTSectionedDataSource <UITextFieldDelegate> {
    TTTwitterLoginModel* _loginModel;
    UITextField* _usernameField;
    UITextField* _passwordField;
}

@end
