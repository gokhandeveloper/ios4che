//
//  PhotoShapViewController.m
//  NoshedItStaging
//
//  Created by yuvraj on 08/01/14.
//  Copyright (c) 2014 limbasiya.nirav@gmail.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "YCameraViewController.h"
#import "AppDelegate.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface YCameraViewController ()

@end

@implementation YCameraViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _photoCaptureButton.layer.cornerRadius = _photoCaptureButton.bounds.size.width /2;
    
    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
	// Do any additional setup after loading the view.
    pickerDidShow = NO;
    
    // Today Implementation
    FrontCamera = NO;
    _captureImage.hidden = YES;
    
    // Setup UIImagePicker Controller
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    
    croppedImageWithoutOrientation = [[UIImage alloc] init];
    
    initializeCamera = YES;
    photoFromCam = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (initializeCamera){
        initializeCamera = NO;
        
        // Initialize camera
        [self initializeCamera];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [_imagePreview release];
    [_captureImage release];
    [imgPicker release];
    imgPicker = nil;
    
    if (session)
        [session release], session=nil;
    
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;    
}

#pragma mark - CAMERA INITIALIZATION =============

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    if (session)
        [session release], session=nil;
    
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[_imagePreview.layer addSublayer:captureVideoPreviewLayer];
	
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera=nil;
    AVCaptureDevice *backCamera=nil;
    
    // Checks if device available
    if (devices.count==0) {
        NSLog(@"No Camera Available");
        [self disableCameraDeviceControls];
        return;
    }
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        
        if ([backCamera hasFlash]){
            [backCamera lockForConfiguration:nil];
            if (self.flashToggleButton.selected)
                [backCamera setFlashMode:AVCaptureFlashModeOn];
            else
                [backCamera setFlashMode:AVCaptureFlashModeOff];
            [backCamera unlockForConfiguration];
            
            [self.flashToggleButton setEnabled:YES];
        }
        else{
            if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [backCamera lockForConfiguration:nil];
                [backCamera setFlashMode:AVCaptureFlashModeOff];
                [backCamera unlockForConfiguration];
            }
            [self.flashToggleButton setEnabled:NO];
        }
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        [self.flashToggleButton setEnabled:NO];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
     
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
}

- (IBAction)snapImage:(id)sender {
    [_photoCaptureButton setEnabled:NO];
    
    if (!haveImage) {
        _captureImage.image = nil; //remove old image from view
        _captureImage.hidden = NO; //show the captured image view
        _imagePreview.hidden = YES; //hide the live video feed
        [self capImage];
   
    } else {
    
        _captureImage.hidden = YES;
        _imagePreview.hidden = NO;
        haveImage = NO;
    }
}
// Method to capture Image from AVCaptureSession
- (void) capImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//process captured image, crop, resize and rotate
- (void) processImage:(UIImage *)image {
    haveImage = YES;
    photoFromCam = YES;
    
    
    /*
    
    UIImage *smallImage = [self imageWithImage:image scaledToWidth: _captureImage.frame.size.width];
                           //640.0f];
    //UIGraphicsGetImageFromCurrentImageContext();
    CGRect cropRect = CGRectMake(0, 105, 640, self.view.frame.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    // adjust image orientation
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationLeft] autorelease];
            break;
        case UIDeviceOrientationLandscapeRight:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationRight] autorelease];
            break;
            
        case UIDeviceOrientationFaceUp:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationUp] autorelease];
            break;
        
        case UIDeviceOrientationPortraitUpsideDown:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                      scale: 1.0
                                                orientation: UIImageOrientationDown] autorelease];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    CGImageRelease(imageRef);

    
    [_captureImage setImage:croppedImage];
*/
    
    _captureImage.image = image;
    
    [self setCapturedImage];
}

- (void)setCapturedImage{
    // Stop capturing image
    [session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self hideControllers];
}

#pragma mark - Device Availability Controls
- (void)disableCameraDeviceControls{
    self.cameraToggleButton.enabled = NO;
    self.flashToggleButton.enabled = NO;
    self.photoCaptureButton.enabled = NO;
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (info) {
        photoFromCam = NO;
        
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        if (outputImage) {
            _captureImage.hidden = NO;
            _captureImage.image = outputImage;
            
            [self dismissViewControllerAnimated:YES completion:nil];

            // Hide Top/Bottom controller after taking photo for editing
            [self hideControllers];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    initializeCamera = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - GRID BUTTON ===========
- (IBAction)gridToogle:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            self.ImgViewGrid.alpha = 0.0f;
        } completion:nil];
    }
    else{
        sender.selected = YES;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            self.ImgViewGrid.alpha = 1.0f;
        } completion:nil];
    }
}

/*
-(IBAction)switchToLibrary:(id)sender {
    
    if (session) {
        [session stopRunning];
    }
    
//    self.captureImage = nil;
    
//    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:NULL];
}


- (IBAction)skipped:(id)sender{

    if ([delegate respondsToSelector:@selector(yCameraControllerdidSkipped)]) {
        [delegate yCameraControllerdidSkipped];
    }
    
    // Dismiss self view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

#pragma mark - CANCEL BUTTON ============
-(IBAction) cancel:(id)sender {
    if ([delegate respondsToSelector:@selector(yCameraControllerDidCancel)]) {
        [delegate yCameraControllerDidCancel];
    }
    
    // Dismiss self view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)donePhotoCapture:(id)sender{

    if ([delegate respondsToSelector:@selector(didFinishPickingImage:)]) {
        [delegate didFinishPickingImage:self.captureImage.image];
    }

    // Dismiss self view controller
  //  [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - RETAKE PHOTO BUTTON ============
- (IBAction)retakePhoto:(id)sender{
    [_photoCaptureButton setEnabled:YES];
    _captureImage.image = nil;
    _imagePreview.hidden = NO;
    
    // Shows Camera Controls
    [self showControllers];
    
    haveImage = NO;
    FrontCamera = NO;
    [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
}


#pragma mark - SWITCH CAMERA BUTTON ============
- (IBAction)switchCamera:(UIButton *)sender { //switch cameras front and rear cameras
    // Stop current recording process
    [session stopRunning];
    
    if (sender.selected) {  // Switch to Back camera
        sender.selected = NO;
        FrontCamera = NO;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
    else {                  // Switch to Front camera
        sender.selected = YES;
        FrontCamera = YES;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
}


#pragma mark - FLASH BUTTON ============
- (IBAction)toogleFlash:(UIButton *)sender{
    if (!FrontCamera) {
        if (sender.selected) { // Set flash off
            [sender setSelected:NO];
            
            NSArray *devices = [AVCaptureDevice devices];
            for (AVCaptureDevice *device in devices) {
                
                NSLog(@"Device name: %@", [device localizedName]);
                
                if ([device hasMediaType:AVMediaTypeVideo]) {
                    
                    if ([device position] == AVCaptureDevicePositionBack) {
                        NSLog(@"Device position : back");
                        if ([device hasFlash]){
                            
                            [device lockForConfiguration:nil];
                            [device setFlashMode:AVCaptureFlashModeOff];
                            [device unlockForConfiguration];
                            
                            break;
                        }
                    }
                }
            }

        }
        else{                  // Set flash on
            [sender setSelected:YES];
            
            NSArray *devices = [AVCaptureDevice devices];
            for (AVCaptureDevice *device in devices) {
                
                NSLog(@"Device name: %@", [device localizedName]);
                
                if ([device hasMediaType:AVMediaTypeVideo]) {
                    
                    if ([device position] == AVCaptureDevicePositionBack) {
                        NSLog(@"Device position : back");
                        if ([device hasFlash]){
                            
                            [device lockForConfiguration:nil];
                            [device setFlashMode:AVCaptureFlashModeOn];
                            [device unlockForConfiguration];
                            
                            break;
                        }
                    }
                }
            }

        }
    }
}

#pragma mark - SHOW/HIDE TOP BAR CONTROLS ==================
- (void)hideControllers{
    [UIView animateWithDuration:0.2 animations:^{
        _photoBar.center = CGPointMake(_photoBar.center.x, _photoBar.center.y+116.0);
        _topBar.center = CGPointMake(_topBar.center.x, _topBar.center.y-44.0);
    } completion:nil];
}

- (void)showControllers{
    [UIView animateWithDuration:0.2 animations:^{
        _photoBar.center = CGPointMake(_photoBar.center.x, _photoBar.center.y-116.0);
        self.topBar.center = CGPointMake(_topBar.center.x, _topBar.center.y+44.0);
    } completion:nil];
}

@end
