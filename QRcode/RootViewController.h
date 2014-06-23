//
//  RootViewController.h
//  QRcode
//
//  Created by XiongJian on 14-6-23.
//  Copyright (c) 2014年 Static. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RootViewController : UIViewController <UITextViewDelegate, ZBarReaderViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *imageBgView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *btnDecode;
@property (retain, nonatomic) IBOutlet UIButton *btnEncode;
@property (retain, nonatomic) IBOutlet UIButton *btnDo;
@property (retain, nonatomic) IBOutlet UITextView *resultView;

- (IBAction)clickDecode:(id)sender;
- (IBAction)clickEncode:(id)sender;
- (IBAction)clickDo:(id)sender;
@end
