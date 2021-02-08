//  UnderLineLabel.m

#import "UnderLineLabel.h"

@implementation UnderLineLabel
@synthesize highlightedColor = _highlightedColor;
@synthesize shouldUnderline = _shouldUnderline;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)setShouldUnderline:(BOOL)shouldUnderline
{
    _shouldUnderline = shouldUnderline;
    if (_shouldUnderline) {
        [self setup];
    }
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setup];
}
- (void)setup
{
    [self setUserInteractionEnabled:TRUE];
    if (_actionView) {
        _actionView.frame=self.bounds;
        _actionView.tag=self.tag;
        
    }else
    {
       _actionView = [[UIControl alloc] initWithFrame:self.bounds];
        [_actionView setBackgroundColor:[UIColor clearColor]];
        [_actionView addTarget:self action:@selector(appendHighlightedColor) forControlEvents:UIControlEventTouchDown];
        _actionView.tag=self.tag;
        [_actionView addTarget:self
                        action:@selector(removeHighlightedColor)
              forControlEvents:UIControlEventTouchCancel |
         UIControlEventTouchUpInside |
         UIControlEventTouchDragOutside |
         UIControlEventTouchUpOutside];
        [self addSubview:_actionView];
        [self sendSubviewToBack:_actionView];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_actionView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)appendHighlightedColor
{
    self.backgroundColor = self.highlightedColor;
}

- (void)removeHighlightedColor
{
    self.backgroundColor = [UIColor clearColor];
}
@end