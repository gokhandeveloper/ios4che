/*=====================
 -- Pixl --
 
 Created for CodeCanyon
 by FV iMAGINATION
 =====================*/

#import "ViewController.h"
#import "CLImageEditor.h"

@interface ViewController ()
<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
@end

@implementation ViewController
@synthesize _imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Rounds the ButtonsView corners
    _buttonsView.layer.cornerRadius = _buttonsView.bounds.size.width /40;
    
    [self refreshImageView];
    
    // Initializes the iAd & AdMob banners
    [self initiAdBanner];
    [self initgAdBanner];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BUTTONS ================================
- (IBAction)savePicButt:(id)sender {
    [self savePic];
}
- (IBAction)newPicButt:(id)sender {
    [self newPic];
}
- (IBAction)editPicButt:(id)sender {
    [self editPic];
}



#pragma mark - ACTIONS CALLED BY THE BUTTONS  ========================

// Sets a new Image/Picture up
- (void)newPic {

    picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate   = self;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose an Option"
        delegate:self cancelButtonTitle:@"Cancel"
        destructiveButtonTitle: nil
        otherButtonTitles:
                            @"Take a Picture",
                            @"Choose from Photo Library",
                            nil];
    
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];

    
}
#pragma mark- ACTIONSHEET DELEGATE ===================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    if(buttonIndex == actionSheet.cancelButtonIndex) {
        return;
        
        
    } else if(buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
    // Open the YCameraView Controller ===========
    YCameraViewController *camController = [[YCameraViewController alloc]
    initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion: nil];
    });
    }
        
    // Open Photo Library
    } else  if(buttonIndex == 1) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:picker animated:YES completion:nil];
        });
    }
    
    
    
}




// Opens the Image Editor to edit your Picture
- (void)editPic {
    if(_imageView.image){
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:_imageView.image delegate:self];

        [self presentViewController:editor animated:YES completion:nil];
    }
    else{
        [self newPic];
    }
}

// Saves the edited image (with sharing options)
- (void)savePic {
    if(_imageView.image)  {
        
        // Calls the sharing method showing the Image Preview
        [self checkingInstalledApp];

    } else {
        // Lets you choose where to pick your image/picture from
        [self newPic];
    }
}


/* =================
 NOTE: The following methods work only on real device, not iOS Simulator, and you should have apps like Instagram, iPhoto, etc. already installed into your device!
================= */
-(void)checkingInstalledApp {
    
    NSLog(@"This code works only on device. Please test it on iPhone/iPad!");
    
    // makes an NSURL file to the processed Image that needs to be saved
    NSURL *fileURL;
    imageFile.delegate = self;
    
    //Saves the Image to default device directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
    UIImage *image = _imageView.image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    //Loads the Image
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
    
    // Creates the URL path to the Image
    fileURL = [[NSURL alloc] initFileURLWithPath:getImagePath];
    imageFile = [UIDocumentInteractionController interactionControllerWithURL:fileURL];


    
    // Opens the Document Interaction controller for Sharing options
    if (fileURL) {
        // Initializes Document Interaction Controller
        imageFile = [UIDocumentInteractionController interactionControllerWithURL:fileURL];

        // Configures Document Interaction Controller
        [imageFile setDelegate:self];
        
        // Shows a Full Screen Preview of the edited Image
        [imageFile presentPreviewAnimated:YES];
    }

}

// DocumentInteractionController delegate
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    
    // Opens an AlertView as sharing result when the Document Interaction Controller gets dismissed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have fun with Pixl!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}




#pragma mark- ImagePicker delegate ==============

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];

}



#pragma mark- CLImageEditor delegate =================

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    _imageView.image = image;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [self refreshImageView];
}




#pragma mark - YCameraViewController Delegate
- (void)didFinishPickingImage:(UIImage *)image{
    
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)yCameraControllerDidCancel{
    [_imageView setImage:[UIImage imageNamed:@"default.jpg"]];
}


#pragma mark- ScrollView settings ==============

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.superview.frame.size.width;
    CGFloat H = _imageView.superview.frame.size.height;
    
    CGRect rct = _imageView.superview.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.superview.frame = rct;
}

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    _imageView.frame = CGRectMake(0, 0, W, H);
    _imageView.superview.bounds = _imageView.bounds;
}

- (void)resetZoomScaleWithAnimate:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}


// Refreshes the Image ===========================
- (void)refreshImageView  {
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimate:NO];
}




#pragma mark - iAd + AdMob BANNER METHODS ==================

-(void)initiAdBanner
{
    if (!self.iAdBannerView)
    {
        CGRect rect = CGRectMake(0, self.view.frame.size.height, 0, 0);
        self.iAdBannerView = [[ADBannerView alloc]initWithFrame:rect];
        self.iAdBannerView.delegate = self;
        self.iAdBannerView.hidden = TRUE;
        [self.view addSubview:self.iAdBannerView];
    }
}

-(void)initgAdBanner
{
    if (!self.gAdBannerView)
    {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  {
            // iPad
            CGRect rect = CGRectMake(0, self.view.frame.size.height, GAD_SIZE_468x60.width, GAD_SIZE_468x60.height);
            self.gAdBannerView = [[GADBannerView alloc] initWithFrame:rect];
        } else {
            // iPhone
            CGRect rect = CGRectMake(0, self.view.frame.size.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height);
            self.gAdBannerView = [[GADBannerView alloc] initWithFrame:rect];
        }
    }
    
    // ** IMPORTANT: YOU MUST COPY THE UNIT ID YOU'VE GOT
    //FROM REGISTERING YOUR APP IN www.apps.admob.com HERE:
    
    self.gAdBannerView.adUnitID = @"ca-app-pub-MY_UNIT_ID_NUMBER";
    
    self.gAdBannerView.rootViewController = self;
    self.gAdBannerView.delegate = self;
    self.gAdBannerView.hidden = TRUE;
    [self.view addSubview:self.gAdBannerView];
}


// Hide the banner by sliding down
-(void)hideBanner:(UIView*)banner
{
    if (banner && ![banner isHidden])
    {
        [UIView beginAnimations:@"hideBanner" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = TRUE;
    }
}

// Show the banner by sliding up
-(void)showBanner:(UIView*)banner
{
    if (banner && [banner isHidden])
    {
        [UIView beginAnimations:@"showBanner" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = FALSE;
    }
}

// Called before the add is shown, time to move the view
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd load");
    [self hideBanner:self.gAdBannerView];
    [self showBanner:self.iAdBannerView];
}

// Called when an error occured
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd error: %@", error);
    [self hideBanner:self.iAdBannerView];
    [self.gAdBannerView loadRequest:[GADRequest request]];
}

// Called before ad is shown, good time to show the add
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"Admob load");
    [self hideBanner:self.iAdBannerView];
    [self showBanner:self.gAdBannerView];
}

// An error occured
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Admob error: %@", error);
    [self hideBanner:self.gAdBannerView];
}


@end
