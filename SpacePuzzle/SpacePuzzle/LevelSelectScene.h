//
//  LevelSceneFinal.h
//  CIU196VVMD
//
//  Created by Nathalie Gunnarsson on 2013-12-03.
//  Copyright (c) 2013 VVMD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class SpacePuzzleController;

@interface LevelSelectScene : SKScene {
    //Locked values
    NSValue *mainLoc, *secLoc, *thirdLoc, *lastLoc, *outLocLeft, *outLocRight;
    NSNumber *mainScale, *secScale, *thirdScale, *lastScale, *outScaleLeft, *outScaleRight;
    int planetIndex, radius;
    float actionSpeed;
    BOOL rotActive;
    CGPoint lastTouch;
    NSString *fontRegular, *fontBold, *fontBoldItalic;
}
@property (nonatomic, strong) SpacePuzzleController *spCtrl;
@property BOOL contentCreated;

//List of all planet locations
@property (nonatomic, strong) NSArray* planetLocations;

//List of all planet scales
@property (nonatomic, strong) NSArray* planetScales;

//List of all level locations
@property (nonatomic, strong) NSArray* levelLocations;

//List of all the planet Nodes
@property (nonatomic, strong) NSMutableArray* planetNodes;

- (void) setAlphaLevelsOn:(SKNode *) planetImg ToVisible:(BOOL) toVisible;
- (void) userTapped:(UIGestureRecognizer *) sender;
- (void) userSwipeRight:(UIGestureRecognizer *) sender;
- (void) userSwipeLeft:(UIGestureRecognizer *) sender;
- (void) userPan:(UIGestureRecognizer *) sender;
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer;
@end
