//
//  RootViewController.m
//  QRcode
//
//  Created by XiongJian on 14-6-23.
//  Copyright (c) 2014年 Static. All rights reserved.
//

#import "RootViewController.h"
#import "QRCodeGenerator.h"

@interface RootViewController () {
    BOOL imageIsUp;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageIsUp = YES;
    _resultView.editable = NO;
    _resultView.delegate = self;

    [_btnDecode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnEncode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    UIControl *con = [[UIControl alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [con addTarget:self action:@selector(textViewDidEndEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:con];
    [self.view sendSubviewToBack:con];
    [con release];
}

- (IBAction)clickDecode:(id)sender {
    _resultView.text = @"";
    _resultView.editable = NO;
    [_resultView resignFirstResponder];
    [_btnDecode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnEncode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    if (!imageIsUp) {
        [self moveView];
    }
}

- (IBAction)clickEncode:(id)sender {
    _resultView.editable = YES;
    _btnDo.enabled = NO;
    [_resultView resignFirstResponder];
    [_btnDecode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnEncode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    if (imageIsUp) {
        [self moveView];
    }
}

- (IBAction)clickDo:(id)sender {
    if (imageIsUp) {
        ZBarReaderViewController *zbar = [[ZBarReaderViewController alloc]init];
        [self presentViewController:zbar animated:YES completion:nil];
    } else {
        _imageView.image = [QRCodeGenerator qrImageForString:_resultView.text imageSize:_imageView.frame.size.width];
    }

}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    for (ZBarSymbol *sym in symbols) {
        _resultView.text = sym.data;
        NSLog(@"%@",sym.data);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    _resultView.editable = imageIsUp?NO:YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    _btnDo.enabled = [@"" isEqualToString:_resultView.text]?NO:YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (imageIsUp) {
        [self moveView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [_resultView resignFirstResponder];
}

- (void)moveView {
    CGRect oldFrame = _imageBgView.frame;

    [UIView animateWithDuration:1.0 animations:^{
        _imageBgView.frame = _resultView.frame;

        _resultView.frame = oldFrame;
    }];

    imageIsUp = _imageBgView.frame.origin.y < [[UIScreen mainScreen]bounds].size.height/2;
}

#pragma mark - dealloc
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_imageView release];
    [_btnDecode release];
    [_btnEncode release];
    [_resultView release];
    [_imageBgView release];
    [_btnDo release];
    [super dealloc];
}
@end
