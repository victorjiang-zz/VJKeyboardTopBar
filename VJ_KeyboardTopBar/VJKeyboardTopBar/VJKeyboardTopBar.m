//
//  VJKeyboardTopBar.m
//  VJ_KeyboardTopBar
//
//  Created by Victor Jiang on 1/26/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "VJKeyboardTopBar.h"

@implementation VJKeyboardTopBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
}

#pragma mark - init
- (instancetype)initWithTextInputViewArray:(NSArray *)textInputViewArray
{
    if (self = [super init]) {
        // Initialization code
        
//      set frame
        CGSize windowSize = [[[UIApplication sharedApplication] delegate] window].bounds.size;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        CGFloat height = 0;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            height = windowSize.width;
        } else {
            height = windowSize.height;
        }
        
        self.frame = CGRectMake(0, 0, height, 44);
        self.backgroundColor = [UIColor clearColor];
        
//      barItem
        _prevButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(previous)];
        _nextButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(next)];
        _fixedSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpaceButtonItem.width = 20;
        _flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
//      toolbar
        _toolBar = [[UIToolbar alloc] initWithFrame:self.frame];
        _toolBar.autoresizesSubviews = YES;
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (VJ_IsIOS7) {
            _toolBar.barStyle = UIBarStyleDefault;
        } else {
            _toolBar.barStyle = UIBarStyleBlackTranslucent;
        }
        _toolBar.items = [NSArray arrayWithObjects:_prevButtonItem, _fixedSpaceButtonItem,  _nextButtonItem, _flexibleSpaceButtonItem, _doneButtonItem, nil];
        [self addSubview:_toolBar];
        
//      set Default value
        if (textInputViewArray.count < 2) {
            _isShowPreAndNext = NO;
        } else {
            _isShowPreAndNext = YES;
        }
        _textInputViewArray = textInputViewArray;
        
//      set textInputView's inputAccessoryView
        for (int i = 0; i < _textInputViewArray.count; i++) {
            id textInputView = [_textInputViewArray objectAtIndex:i];
            if ([textInputView isKindOfClass:[UITextField class]]) {
                ((UITextField *)textInputView).inputAccessoryView = self;
            } else if ([textInputView isKindOfClass:[UITextView class]]) {
                ((UITextView *)textInputView).inputAccessoryView = self;
            }
        }
        
//      add notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    }
    
    return self;
}

#pragma mark - bar item action
- (void)previous
{
    NSInteger index = [_textInputViewArray indexOfObject:_currentEditTextInputView];
    if (index > 0) {
        [[_textInputViewArray objectAtIndex:index - 1] becomeFirstResponder];
    }
}

- (void)next
{
    NSInteger index = [_textInputViewArray indexOfObject:_currentEditTextInputView];
    if (index < _textInputViewArray.count - 1) {
        [[_textInputViewArray objectAtIndex:index + 1] becomeFirstResponder];
    }
}

- (void)done
{
    if ([_currentEditTextInputView isKindOfClass:[UITextField class]]) {
        [((UITextField *)_currentEditTextInputView) resignFirstResponder];
    } else if ([_currentEditTextInputView isKindOfClass:[UITextView class]]) {
        [((UITextView *)_currentEditTextInputView) resignFirstResponder];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarDoneButtonPressed:textInputView:)]) {
        [self.delegate topBarDoneButtonPressed:self textInputView:_currentEditTextInputView];
    }
}

#pragma mark - GET Method
- (UIToolbar *)toolBar
{
    return _toolBar;
}

- (id<UITextInput>)currentEditTextInputView
{
    return _currentEditTextInputView;
}

- (NSArray *)textInputViewArray
{
    return _textInputViewArray;
}

#pragma mark - SET Method
- (void)setIsShowPreAndNext:(BOOL)isShowPreAndNext
{
    if (_textInputViewArray.count < 2) {
        _isShowPreAndNext = NO;
    } else {
        _isShowPreAndNext = isShowPreAndNext;
    }
}

#pragma mark - Notification
- (void)textInputViewDidBeginEditing:(NSNotification *)notification
{
    _currentEditTextInputView = notification.object;
    
    if (_isShowPreAndNext) {
        [_toolBar setItems:[NSArray arrayWithObjects:_prevButtonItem, _fixedSpaceButtonItem, _nextButtonItem, _flexibleSpaceButtonItem, _doneButtonItem, nil]];
    } else {
        [_toolBar setItems:[NSArray arrayWithObjects:_flexibleSpaceButtonItem, _doneButtonItem, nil]];
    }
    
    NSInteger index = [_textInputViewArray indexOfObject:_currentEditTextInputView];
    if (index > 0) {
        _prevButtonItem.enabled = YES;
    } else {
        _prevButtonItem.enabled = NO;
    }
    
    if (index < [_textInputViewArray count] - 1) {
        _nextButtonItem.enabled = YES;
    } else {
        _nextButtonItem.enabled = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBar:textInputViewDidBeginEditing:)]) {
        [self.delegate topBar:self textInputViewDidBeginEditing:(UIView *)_currentEditTextInputView];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarWillShow:keyboardHeight:)]) {
        [self.delegate topBarWillShow:self keyboardHeight:keyboardHeight];
    }
}


- (void)keyboardWillHidden:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBarWillHidden:)]) {
        [self.delegate topBarWillHidden:self];
    }
}






@end
