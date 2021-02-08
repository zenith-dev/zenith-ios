//
//	ReaderViewController.h
//	Reader v2.5.4
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "ReaderDocument.h"
#import "ReaderContentView.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ThumbsViewController.h"
#import "AnnotationViewController.h"
#import "ReaderAnnotateToolbar.h"
#import "DocumentsUpdate.h"
@class ReaderViewController;
@class ReaderMainToolbar;

@protocol ReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissReaderViewController:(ReaderViewController *)viewController;

@end

@interface ReaderViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate,
													ReaderMainToolbarDelegate,ReaderAnnotateToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate,
													ThumbsViewControllerDelegate>
{
@private // Instance variables

	ReaderDocument *document;

	UIScrollView *theScrollView;

	ReaderMainToolbar *mainToolbar;

    ReaderAnnotateToolbar *annotateToolbar;
    
	ReaderMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;

	UIPrintInteractionController *printInteraction;

	NSInteger currentPage;

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL isVisible;
}

@property (nonatomic, assign, readwrite) id <ReaderViewControllerDelegate> delegate;
@property (nonatomic, retain) AnnotationViewController *annotationController;
- (id)initWithReaderDocument:(ReaderDocument *)object;

@end
