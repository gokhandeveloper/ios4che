//
//  DicomShowViewController.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-09.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface DicomShowViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITabBarDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
{
   UIImage *m_originalImage;
  //  UIImage *m_currentImage;
  //  GPUImageView *m_imgDicom;
  //  GPUImagePicture *m_srcImage;
  //
  //  GPUImageFilter *m_filter;
//    GPUImageBrightnessFilter *m_brightnessFilter;
//    GPUImageContrastFilter *m_contrastFilter;
//    GPUImageColorInvertFilter *m_colorInvertFilter;
//    GPUImageTransformFilter *m_transformFilter;
    IBOutlet __weak UIScrollView *_scrollView;
    IBOutlet __weak UIImageView *_imageView;
    
}

- (IBAction)pushedEditBtn:(id)sender;

- (IBAction)pushedSaveBtn:(id)sender;



@end
