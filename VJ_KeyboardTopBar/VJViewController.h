//
//  VJViewController.h
//  VJ_KeyboardTopBar
//
//  Created by Victor Jiang on 1/26/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VJKeyboardTopBar.h"
#import "objc/runtime.h"

@interface VJViewController : UIViewController<VJKeyboardTopBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
