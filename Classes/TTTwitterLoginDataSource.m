//
//  TTLoginDataSource.m
//  TTTwitterLogin
//
//  Created by Anton Chirkunov on 28/5/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TTTwitterLoginDataSource.h"

#import "TTTwitterLoginModel.h"
#import "TTLogin.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterLoginDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if (self = [super init]) {
        _loginModel = [[TTTwitterLoginModel alloc] init];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_loginModel);
    TT_RELEASE_SAFELY(_usernameField);
    TT_RELEASE_SAFELY(_passwordField);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView *)tableView {    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    [sections addObject:@""];
    NSMutableArray *itemsRow = [[NSMutableArray alloc] init];
    
    _usernameField = [[UITextField alloc] init];
    _usernameField.placeholder = @"Username";
    _usernameField.keyboardType = UIKeyboardTypeDefault;
    _usernameField.returnKeyType = UIReturnKeyNext;
    _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.clearsOnBeginEditing = NO;
    _usernameField.delegate = self;
    _usernameField.text = _loginModel.credentials.username;
    [itemsRow addObject:_usernameField];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.placeholder = @"Password";
    _passwordField.returnKeyType = UIReturnKeyGo;
    _passwordField.secureTextEntry = YES;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.clearsOnBeginEditing = NO;
    _passwordField.delegate = self;
    _passwordField.text = @""; // Initialize the passwordfield nsstring
    [itemsRow addObject:_passwordField];
    
    [items addObject:itemsRow];
    TT_RELEASE_SAFELY(itemsRow);
    
    self.items = items;
    self.sections = sections;
    TT_RELEASE_SAFELY(items);
    TT_RELEASE_SAFELY(sections);
    
    [_usernameField becomeFirstResponder];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextFieldDelegate methods


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_passwordField becomeFirstResponder];
    }
    else {
        [_loginModel login:_usernameField.text password:_passwordField.text];
    }
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _loginModel;
}

@end
