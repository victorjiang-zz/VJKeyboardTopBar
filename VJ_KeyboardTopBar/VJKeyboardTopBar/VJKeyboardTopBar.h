//
//  VJKeyboardTopBar.h
//  VJ_KeyboardTopBar

//  
//

//
//  Created by Victor Jiang on 1/26/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#define VJ_IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

#import <UIKit/UIKit.h>

@class VJKeyboardTopBar;

@protocol VJKeyboardTopBarDelegate <NSObject>

/**
 *  topBar will show/hidden , change view's frame
 *
 *  @param topBar
 *  @param textInputView
 *  @param keyboardHeight
 */
- (void)topBarWillShow:(VJKeyboardTopBar *)topBar keyboardHeight:(CGFloat)keyboardHeight;
- (void)topBarWillHidden:(VJKeyboardTopBar *)topBar;

/**
 *  move textInputView to visible
 *
 *  @param topBar
 *  @param textInputView 
 */
- (void)topBar:(VJKeyboardTopBar *)topBar textInputViewDidBeginEditing:(UIView *)textInputView;

@optional
- (void)topBarDoneButtonPressed:(VJKeyboardTopBar *)topBar textInputView:(id<UITextInput>)textInputView;

@end

@interface VJKeyboardTopBar : UIView
{
    NSArray             *_textInputViewArray;
    id<UITextInput>     _currentEditTextInputView;
    
    UIToolbar           *_toolBar;
    
    UIBarButtonItem     *_prevButtonItem;
    UIBarButtonItem     *_nextButtonItem;
    UIBarButtonItem     *_fixedSpaceButtonItem;
    UIBarButtonItem     *_flexibleSpaceButtonItem;
    UIBarButtonItem     *_doneButtonItem;
}

#pragma mark - Property

@property (nonatomic, weak) id<VJKeyboardTopBarDelegate> delegate;

//  Default YES, if _textInputViewArray.count < 2, value is NO.
@property (nonatomic, assign) BOOL isShowPreAndNext;

#pragma mark - Method
- (instancetype)initWithTextInputViewArray:(NSArray *)textInputViewArray;

- (UIToolbar *)toolBar;
- (id<UITextInput>)currentEditTextInputView;
- (NSArray *)textInputViewArray;

@end
