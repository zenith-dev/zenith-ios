//
//  AnnotationViewController.h
//	ThatPDF v0.3.1
//
//	Created by Brett van Zuiden.
//	Copyright © 2013 Ink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReaderDocument.h"
#import "Annotation.h"
#import "ReaderContentView.h"
#import "AnnotationStore.h"
extern NSString *const AnnotationViewControllerType_None;
extern NSString *const AnnotationViewControllerType_Sign;
extern NSString *const AnnotationViewControllerType_RedPen;
extern NSString *const AnnotationViewControllerType_Text;

@interface AnnotationViewController : UIViewController
@property(nonatomic,retain) NSString *annotationType;
@property(nonatomic,retain) ReaderDocument *document;
@property NSInteger currentPage;

- (id)initWithDocument:(ReaderDocument *)document;
- (void)moveToPage:(int)page contentView:(ReaderContentView*) view;
- (void) hide;
- (void) clear;
- (void) undo;

- (AnnotationStore*) annotations;

@end