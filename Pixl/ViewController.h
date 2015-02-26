/*=====================
 -- Pixl --
 
 Created for CodeCanyon
 by FV iMAGINATION
 =====================*/

// Ad banners imports
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>

#import "YCameraViewController.h"

#import <UIKit/UIKit.h>

UIImagePickerController *picker;

UIDocumentInteractionController *imageFile;
UIImage *combinedImage;

@interface ViewController : UIViewController
<
UIPopoverControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITabBarDelegate,
UIActionSheetDelegate,
UIScrollViewDelegate,
UIDocumentInteractionControllerDelegate,
GADBannerViewDelegate, ADBannerViewDelegate,
YCameraViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIView *imageContainer;



//Ad banners properties
@property (strong, nonatomic) ADBannerView *iAdBannerView;
@property (strong, nonatomic) GADBannerView *gAdBannerView;

// Views ==============
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *_imageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

// Buttons ===============
- (IBAction)savePicButt:(id)sender;
- (IBAction)newPicButt:(id)sender;
- (IBAction)editPicButt:(id)sender;




@end
