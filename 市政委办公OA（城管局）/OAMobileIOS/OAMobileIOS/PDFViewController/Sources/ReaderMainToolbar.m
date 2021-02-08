//
//	ReaderMainToolbar.m
//	Reader v2.5.4
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>

@implementation ReaderMainToolbar

#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define EMAIL_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define TITLE_HEIGHT 28.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame document:nil];
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object
{
	assert(object != nil); // Check

	if ((self = [super initWithFrame:frame]))
	{
		CGFloat viewWidth = self.bounds.size.width;

		UIImage *imageH = [UIImage imageNamed:@"Reader-Button-H.png"];
		UIImage *imageN = [UIImage imageNamed:@"Reader-Button-N.png"];

		UIImage *buttonH = [imageH stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImage *buttonN = [imageN stretchableImageWithLeftCapWidth:5 topCapHeight:0];

		CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));

		CGFloat leftButtonX = BUTTON_X; // Left button start X position

#if (READER_STANDALONE == FALSE) // Option

		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];

		doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, DONE_BUTTON_WIDTH, BUTTON_HEIGHT);
		[doneButton setTitle:NSLocalizedString(@"返回", @"button") forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		doneButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:doneButton]; leftButtonX += (DONE_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (DONE_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (DONE_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_STANDALONE Option

#if (READER_ENABLE_THUMBS == TRUE) // Option

		UIButton *thumbsButton = [UIButton buttonWithType:UIButtonTypeCustom];

		thumbsButton.frame = CGRectMake(leftButtonX, BUTTON_Y, THUMBS_BUTTON_WIDTH, BUTTON_HEIGHT);
		[thumbsButton setImage:[UIImage imageNamed:@"Reader-Thumbs.png"] forState:UIControlStateNormal];
		[thumbsButton addTarget:self action:@selector(thumbsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[thumbsButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[thumbsButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		thumbsButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:thumbsButton]; //leftButtonX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_ENABLE_THUMBS Option

		CGFloat rightButtonX = viewWidth; // Right button start X position

#if (READER_BOOKMARKS == TRUE) // Option

		rightButtonX -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];

		flagButton.frame = CGRectMake(rightButtonX, BUTTON_Y, MARK_BUTTON_WIDTH, BUTTON_HEIGHT);
		//[flagButton setImage:[UIImage imageNamed:@"Reader-Mark-N.png"] forState:UIControlStateNormal];
		[flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		flagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

		[self addSubview:flagButton]; titleWidth -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		markButton = [flagButton retain]; markButton.enabled = NO; markButton.tag = NSIntegerMin;

		markImageN = [[UIImage imageNamed:@"Reader-Mark-N.png"] retain]; // N image
		markImageY = [[UIImage imageNamed:@"Reader-Mark-Y.png"] retain]; // Y image

#endif // end of READER_BOOKMARKS Option

//#if (READER_ENABLE_MAIL == TRUE) // Option
//
//		if ([MFMailComposeViewController canSendMail] == YES) // Can email
//		{
//			unsigned long long fileSize = [object.fileSize unsignedLongLongValue];
//
//			if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
//			{
//				rightButtonX -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
//
//				UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//				emailButton.frame = CGRectMake(rightButtonX, BUTTON_Y, EMAIL_BUTTON_WIDTH, BUTTON_HEIGHT);
//				[emailButton setImage:[UIImage imageNamed:@"Reader-Smaller.png"] forState:UIControlStateNormal];
//				[emailButton addTarget:self action:@selector(smallerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//				[emailButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//				[emailButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//				emailButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//
//				[self addSubview:emailButton]; titleWidth -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
//			}
//		}
//
//#endif // end of READER_ENABLE_MAIL Option

//#if (READER_ENABLE_PRINT == TRUE) // Option
//
//		if (object.password == nil) // We can only print documents without passwords
//		{
//			Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
//
//			if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
//			{
//				rightButtonX -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
//
//				UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//				printButton.frame = CGRectMake(rightButtonX, BUTTON_Y, PRINT_BUTTON_WIDTH, BUTTON_HEIGHT);
//				[printButton setImage:[UIImage imageNamed:@"Reader-Bigger.png"] forState:UIControlStateNormal];
//				[printButton addTarget:self action:@selector(biggerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//				[printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//				[printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//				printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//
//				[self addSubview:printButton]; titleWidth -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
//			}
//		}
//
//#endif // end of READER_ENABLE_PRINT Option

        //@“＋”按钮
        rightButtonX -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
        UIButton *smallerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        smallerButton.frame = CGRectMake(rightButtonX, BUTTON_Y, EMAIL_BUTTON_WIDTH, BUTTON_HEIGHT);
        [smallerButton setImage:[UIImage imageNamed:@"Reader-Smaller.png"] forState:UIControlStateNormal];
        [smallerButton addTarget:self action:@selector(smallerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [smallerButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
        [smallerButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        smallerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:smallerButton]; titleWidth -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
        
        //@“－”按钮
        rightButtonX -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
        UIButton *biggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        biggerButton.frame = CGRectMake(rightButtonX, BUTTON_Y, PRINT_BUTTON_WIDTH, BUTTON_HEIGHT);
        [biggerButton setImage:[UIImage imageNamed:@"Reader-Bigger.png"] forState:UIControlStateNormal];
        [biggerButton addTarget:self action:@selector(biggerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [biggerButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
        [biggerButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        biggerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:biggerButton]; titleWidth -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);

        
        
        rightButtonX -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
        
        UIButton *annotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        annotateButton.frame = CGRectMake(rightButtonX, BUTTON_Y, PRINT_BUTTON_WIDTH, BUTTON_HEIGHT);
        [annotateButton setImage:[UIImage imageNamed:@"Reader-Annotate"] forState:UIControlStateNormal];
        [annotateButton addTarget:self action:@selector(annotateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [annotateButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
        [annotateButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        annotateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        annotateButton.exclusiveTouch = YES;
        
        [self addSubview:annotateButton]; titleWidth -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
        

		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);

			UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];

			titleLabel.textAlignment = UITextAlignmentCenter;
			titleLabel.font = [UIFont systemFontOfSize:19.0f]; // 19 pt
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
			titleLabel.shadowColor = [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
			titleLabel.minimumFontSize = 14.0f;
			titleLabel.text = [object.fileName stringByDeletingPathExtension];

			[self addSubview:titleLabel]; [titleLabel release];
		}
	}

	return self;
}

- (void)dealloc
{
	[markButton release], markButton = nil;

	[markImageN release], markImageN = nil;
	[markImageY release], markImageY = nil;

	[super dealloc];
}

- (void)setBookmarkState:(BOOL)state
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{

#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

- (void)thumbsButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self thumbsButton:button];
}

//- (void)printButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self printButton:button];
//}
//
//- (void)emailButtonTapped:(UIButton *)button
//{
//	[delegate tappedInToolbar:self emailButton:button];
//}
- (void)biggerButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self biggerButton:button];
}

- (void)smallerButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self smallerButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self markButton:button];
}
- (void)annotateButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self annotateButton:button];
}
@end
