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
    ZBarReaderView *readerView;
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
    [_btnDo setTitle:@"Scan" forState:UIControlStateNormal];
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
    _btnDo.enabled = YES;
    [_btnDo setTitle:@"Scan" forState:UIControlStateNormal];
    [_btnDo setTitle:@"Scan" forState:UIControlStateDisabled];
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
    [readerView stop];
    [readerView removeFromSuperview];

    [_btnDo setTitle:@"Do" forState:UIControlStateNormal];
    [_btnDo setTitle:@"Do" forState:UIControlStateDisabled];
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
    [_resultView resignFirstResponder];

    if (imageIsUp) {
        for (UIView *temp in self.view.subviews) {
            if ([temp isKindOfClass:[ZBarReaderView class]]) {
                NSLog(@"---------");
                return;
            }
        }
        [self initScanView];
    } else {
        _imageView.image = [QRCodeGenerator qrImageForString:_resultView.text imageSize:_imageView.frame.size.width];
    }
}

- (void)initScanView {
    readerView = [[ZBarReaderView alloc]init];
//    readerView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    readerView.frame = CGRectMake(60, 100, _imageView.frame.size.width, _imageView.frame.size.height);
    readerView.readerDelegate = self;
    //关闭闪光灯
    readerView.torchMode = 0;
    //扫描区域
    readerView.scanCrop = CGRectMake(0, 0, 1, 1);
//    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readerView.frame) - 126, 200, 200);

    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    [self.view addSubview:readerView];
    //扫描区域计算
//    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];

    [readerView start];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;

    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;

    return CGRectMake(x, y, width, height);
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    for (ZBarSymbol *temp in symbols) {
        _resultView.text = temp.data;
        break;
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
