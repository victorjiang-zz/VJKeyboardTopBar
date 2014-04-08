//
//  VJViewController.m
//  VJ_KeyboardTopBar
//
//  Created by Victor Jiang on 1/26/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "VJViewController.h"

@interface VJViewController ()
{
    VJKeyboardTopBar *_keyboardTopBar;
}


@end

@implementation VJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.baseScrollView.contentSize = self.baseScrollView.frame.size;
    
    _keyboardTopBar = [[VJKeyboardTopBar alloc] initWithTextInputViewArray:[NSArray arrayWithObjects:_textView, _textField1, _textField2, _textField3, _textField4, nil]];
    _keyboardTopBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VJKeyboardTopBarDelegate
- (void)topBarWillShow:(VJKeyboardTopBar *)topBar keyboardHeight:(CGFloat)keyboardHeight
{
    CGRect frame = self.baseScrollView.frame;
    frame.size.height = self.view.frame.size.height - keyboardHeight;
    self.baseScrollView.frame = frame;
    self.baseScrollView.contentSize = self.view.frame.size;
    
}

- (void)topBarWillHidden:(VJKeyboardTopBar *)topBar
{
    CGRect frame = self.baseScrollView.frame;
    frame.size.height = self.view.frame.size.height;
    self.baseScrollView.frame = frame;
}

- (void)topBar:(VJKeyboardTopBar *)topBar textInputViewDidBeginEditing:(UIView *)textInputView
{
    [self.baseScrollView scrollRectToVisible:textInputView.frame animated:YES];
}

- (void)topBarDoneButtonPressed:(VJKeyboardTopBar *)topBar textInputView:(id<UITextInput>)textInputView
{
    NSInteger index = [[topBar textInputViewArray] indexOfObject:textInputView];
    NSLog(@"index = %d", index);
}

#pragma mark - 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)associativeReferences
{
    
}

@end
