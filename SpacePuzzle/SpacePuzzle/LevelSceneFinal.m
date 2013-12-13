//
//  LevelSceneFinal.m
//  CIU196VVMD
//
//  Created by Nathalie Gunnarsson on 2013-12-03.
//  Copyright (c) 2013 VVMD. All rights reserved.
//

#import "LevelSceneFinal.h"
#import "SpacePuzzleController.h"
#import "MainScene.h"

@implementation LevelSceneFinal

@synthesize planetNodes = _planetNodes, planetLocations = _planetLocations;

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        
        // Definition of locked values
        outLocLeft  = [NSValue valueWithCGPoint: CGPointMake(-700,  180)];
        mainLoc     = [NSValue valueWithCGPoint: CGPointMake(0,     200)];
        secLoc      = [NSValue valueWithCGPoint: CGPointMake(230,   250)];
        thirdLoc    = [NSValue valueWithCGPoint: CGPointMake(290,   280)];
        lastLoc     = [NSValue valueWithCGPoint: CGPointMake(312,   298)];
        outLocRight = [NSValue valueWithCGPoint: CGPointMake(324,   308)];
        _planetLocations    = [NSArray arrayWithObjects:outLocLeft, mainLoc, secLoc, thirdLoc, lastLoc, outLocRight, nil];
        outScaleLeft= [NSNumber numberWithFloat:1.5     ];
        mainScale   = [NSNumber numberWithFloat:1.0     ];
        secScale    = [NSNumber numberWithFloat:0.25    ];
        thirdScale  = [NSNumber numberWithFloat:0.1     ];
        lastScale   = [NSNumber numberWithFloat:0.04    ];
        outScaleRight=[NSNumber numberWithFloat:0.02    ];
        _planetScales       = [NSArray arrayWithObjects: outScaleLeft, mainScale, secScale, thirdScale, lastScale, outScaleRight, nil];
        
        _levelLocations    = [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint: CGPointMake(150,  0)],
                               [NSValue valueWithCGPoint: CGPointMake(130,  90)],
                               [NSValue valueWithCGPoint: CGPointMake(50,  150)],
                               [NSValue valueWithCGPoint: CGPointMake(-50,  150)],
                               [NSValue valueWithCGPoint: CGPointMake(-130,  90)],
                               
                               [NSValue valueWithCGPoint: CGPointMake(-150,  0)],
                               [NSValue valueWithCGPoint: CGPointMake(-130,  -90)],
                               [NSValue valueWithCGPoint: CGPointMake(-50,  -150)],
                               [NSValue valueWithCGPoint: CGPointMake(50,  -150)],
                               [NSValue valueWithCGPoint: CGPointMake(130,  -90)], nil];
        
        fontRegular     = @"Exo2.0-Regular";
        fontBold        = @"Exo2.0-ExtraBold";
        fontBoldItalic  = @"Exo2.0-ExtraBoldItalic";
        
        planetIndex = 0;
        actionSpeed = 0.6;
        radius      = 200;
        rotActive   = false;
        lastTouch   = CGPointMake(0, 0);
        //
        
        // Initiate variables
        _planetNodes = [[NSMutableArray alloc] init];
        //
        
        // Set Background (Subject to change on different worlds)
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bgspace.png"];
        background.size = CGSizeMake(self.size.width, self.size.height);
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        background.zPosition = 0;
        
        [self addChild:background];
        // Rotate the background
        //SKAction *rotateBG = [SKAction repeatActionForever:[SKAction rotateByAngle:(0.5) duration:10]];
        //[background runAction:rotateBG];
        //
        
        // Initiate shade sprites
        SKTexture *shadeTexture = [SKTexture textureWithImageNamed:@"Shade_2x.png"];
        
        // Create the Planet Nodes (i is number of planets)
        for (int i = 0; i < 5; i++) {
            SKNode *planet = [[SKNode alloc] init];
            planet.zPosition = i;
            // Generates the name of the PNG, add IMG to Planetnode.
            NSMutableString *name = [[NSMutableString alloc] initWithString:@"planets"];
            [name appendString: [NSString stringWithFormat:@"%d",(i+1)]];
            [name appendString:@".png"];
            SKSpriteNode *planetImg = [SKSpriteNode spriteNodeWithImageNamed:name];
            [planetImg setName:@"planetImg"];
            [planet addChild:planetImg];
            
            // Add some shade to the planet
            SKSpriteNode *shade = [SKSpriteNode spriteNodeWithTexture:shadeTexture];
            [planet addChild:shade];
            
            // Add the name label (Subject to change with different names)
            SKLabelNode *planetLabel = [SKLabelNode labelNodeWithFontNamed:fontBoldItalic];
            planetLabel.text = @"Planet";
            planetLabel.fontSize = 30;
            planetLabel.fontColor = [UIColor whiteColor];
            planetLabel.position = CGPointMake(150, 180);
            [planet addChild:planetLabel];
            
            // Add the level sprites to the planet node
            SKTexture *levelTexture = [SKTexture textureWithImageNamed:@"3stars_1x.png"];
            for (int j = 0; j < _levelLocations.count; j++) {
                SKSpriteNode *level = [SKSpriteNode spriteNodeWithTexture:levelTexture];
                NSValue *temp = [_levelLocations objectAtIndex:j];
                [level setPosition:temp.CGPointValue];
                level.zPosition = 1000;
                level.alpha = 0;
                
                SKLabelNode *levelLabel = [SKLabelNode labelNodeWithFontNamed:fontBoldItalic];
                NSString *name = [NSString stringWithFormat:@"%d",(j+1)];
                levelLabel.text = name;
                [level setName:name];
                levelLabel.fontSize = 35;
                levelLabel.fontColor = [UIColor whiteColor];
                levelLabel.position = CGPointMake(0, -20);
                [level setZPosition:100];
                [level addChild:levelLabel];
                
                [planetImg addChild:level];
            }
            
            // Add the created planet to planetNodes
            [_planetNodes addObject:planet];
        }
        // Also add "ghost" planets
        for (int i = 0; i < 4; i++) {
            SKNode *planet = [[SKNode alloc] init];
            // Add the created planet to planetNodes
            [_planetNodes addObject:planet];
        }
        
        
        // Add the appropriate planets to the current scene (Subject: depending on how much completed)
        for (int i = planetIndex; i < planetIndex+4; i++) {
            // Add location
            NSValue *tempValue = [_planetLocations objectAtIndex:(i+1)];
            [[_planetNodes objectAtIndex:i] setPosition:tempValue.CGPointValue];
        
            // Add scale
            NSNumber *tempNumber = [_planetScales objectAtIndex:(i+1)];
            [[_planetNodes objectAtIndex:i] setScale:[tempNumber floatValue]];
            
            [[_planetNodes objectAtIndex:i] setZPosition:10-i];
            
            if (i == planetIndex) {
                for (id level in [[[_planetNodes objectAtIndex:i] childNodeWithName:@"planetImg"] children])
                {
                    [level setAlpha:1];
                    [level setBlendMode:SKBlendModeSubtract];
                }
            }
            
            // Add to scene
            [self addChild:[_planetNodes objectAtIndex:i]];
        }
        
        
        // Add the remaining not seen planets, both before and after.
        for (int i = 0; i < planetIndex; i++) {
            // Add location
            NSValue *tempValue = [_planetLocations objectAtIndex:(0)];
            [[_planetNodes objectAtIndex:i] setPosition:tempValue.CGPointValue];
            
            // Add scale
            NSNumber *tempNumber = [_planetScales objectAtIndex:(0)];
            [[_planetNodes objectAtIndex:i] setScale:[tempNumber floatValue]];
            
            // Add to scene
            [self addChild:[_planetNodes objectAtIndex:i]];
        }
        /////// WRONG
        for (int i = [_planetNodes count]-1; i > (planetIndex+3); i--) {
            // Add location
            NSValue *tempValue = [_planetLocations objectAtIndex:(5)];
            [[_planetNodes objectAtIndex:i] setPosition:tempValue.CGPointValue];
            
            // Add scale
            NSNumber *tempNumber = [_planetScales objectAtIndex:(5)];
            [[_planetNodes objectAtIndex:i] setScale:[tempNumber floatValue]];
            
            // Add to scene
            [self addChild:[_planetNodes objectAtIndex:i]];
        }
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
        tapRec.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:tapRec];
        
        UISwipeGestureRecognizer *swipeRightRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipeRight:)];
        swipeRightRec.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRightRec];
        
        UISwipeGestureRecognizer *swipeLeftRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipeLeft:)];
        swipeLeftRec.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeftRec];
        
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userPan:)];
        // Väntar på att de failar, osäker på att det är rätt väg att gå. Diverse anledningar.
        [panRec requireGestureRecognizerToFail: swipeLeftRec];
        [panRec requireGestureRecognizerToFail: swipeRightRec];
        [self.view addGestureRecognizer:panRec];
        
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
}

-(void)userTapped:(UIGestureRecognizer *)sender {
    NSLog(@"TAP");
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint touch = [sender locationInView:self.view];
        // Invertera y-axeln
        touch.y = 480 - touch.y;
        
        // Kolla om någon level är vald.
        for (id level in [[[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"] children]) {
            SKNode *temp = (SKNode*) level;
            
            CGPoint touchLevel = [self convertPoint:touch toNode:temp];
             
            if (abs(touchLevel.x) < 30 && abs(touchLevel.y) < 30) {
                /// STARTA NY LEVEL
                MainScene *s = [MainScene sceneWithSize:self.view.bounds.size];
                s.controller = self.spCtrl;
                self.spCtrl.scene = s;
                NSInteger levelInt = [[level name] integerValue];
                [self.spCtrl startGameWithWorld:planetIndex AndLevel:levelInt];
                s.scaleMode = SKSceneScaleModeAspectFill;
            //    [self.spCtrl startGame];
               // _scene.scaleMode = SKSceneScaleModeAspectFill;
                SKView *v = (SKView*)self.spCtrl.view;
                SKTransition *reveal = [SKTransition fadeWithDuration:2.0];
                [v presentScene:s transition:reveal];
                //[v presentScene:s];
            }
        }
    }
}

-(void)willMoveFromView:(SKView *)view {
    NSLog(@"moved from view");
}

- (void) userSwipeRight:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
  
        // Temp variables to be used on planets
        SKNode *temp = [[SKNode alloc] init];
        SKAction *move = [[SKAction alloc] init];
        SKAction *scale = [[SKAction alloc] init];
        SKAction *group = [[SKAction alloc] init];
        // Move all visible planets
        if (planetIndex != 0) {
            // Move and scale all planets
            for (int i = 0; i < 5; i++) {
                temp =  [_planetNodes objectAtIndex:(i+planetIndex-1)];
                move =  [SKAction moveTo:[[_planetLocations objectAtIndex:(i+1)] CGPointValue] duration:actionSpeed];
                scale = [SKAction scaleTo:[[_planetScales objectAtIndex:(i+1)] floatValue] duration:actionSpeed];
                group = [SKAction group:@[move,scale]];
                temp.zPosition = 10-i;
                [temp runAction:group];
            }
            
            // Hide and show levels on planets
            [self setAlphaLevelsOn:[[_planetNodes objectAtIndex:planetIndex]childNodeWithName:@"planetImg"]
                         ToVisible:false];
            [self setAlphaLevelsOn:[[_planetNodes objectAtIndex:planetIndex-1] childNodeWithName:@"planetImg"]
                         ToVisible:true];
            
            planetIndex--;
        } else {
            for (int i = 0; i < 4; i++) {
                float x = 30/(i+1);
                float y = 15/(i+1);
                temp =  [_planetNodes objectAtIndex:(i+planetIndex)];
                move =  [SKAction moveByX:x y:y duration:0.2];
                scale = [SKAction scaleBy:0.9 duration:0.2];
                SKAction *move2 =  [SKAction moveByX:-x y:-y duration:0.2];
                SKAction *scale2 = [SKAction scaleBy:(1/0.9) duration:0.2];
                group = [SKAction group:@[move,scale]];
                SKAction *group2 = [SKAction group:@[move2,scale2]];
                SKAction *sequence = [SKAction sequence:@[group, group2]];
                sequence.timingMode = SKActionTimingEaseInEaseOut;
                [temp runAction:sequence];
            }
        }
    }
}

- (void) userSwipeLeft:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        // Temp variables to be used on planets
        SKNode *temp = [[SKNode alloc] init];
        SKAction *move = [[SKAction alloc] init];
        SKAction *scale = [[SKAction alloc] init];
        SKAction *group = [[SKAction alloc] init];
        // Move all visible planets
        if (planetIndex != [_planetNodes count]-5) {
            for (int i = 0; i < 5; i++) {
                temp =  [_planetNodes objectAtIndex:(i+planetIndex)];
                move =  [SKAction moveTo:[[_planetLocations objectAtIndex:(i)] CGPointValue] duration:actionSpeed];
                scale = [SKAction scaleTo:[[_planetScales objectAtIndex:(i)] floatValue] duration:actionSpeed];
                group = [SKAction group:@[move,scale]];
                temp.zPosition = 10-i;
                [temp runAction:group];
            }
            
            // Hide and show levels on planets
            [self setAlphaLevelsOn:[[_planetNodes objectAtIndex:planetIndex]childNodeWithName:@"planetImg"]
                         ToVisible:false];
            [self setAlphaLevelsOn:[[_planetNodes objectAtIndex:planetIndex+1] childNodeWithName:@"planetImg"]
                         ToVisible:true];
            
            planetIndex++;
        } else {
            for (int i = 0; i < 4; i++) {
                float x = 30/(i+1);
                float y = 10/(i+1);
                temp =  [_planetNodes objectAtIndex:(i+planetIndex)];
                move =  [SKAction moveByX:-x y:-y duration:0.2];
                scale = [SKAction scaleBy:1.1 duration:0.2];
                SKAction *move2 =  [SKAction moveByX:x y:y duration:0.2];
                SKAction *scale2 = [SKAction scaleBy:(1/1.1) duration:0.2];
                group = [SKAction group:@[move,scale]];
                SKAction *group2 = [SKAction group:@[move2,scale2]];
                SKAction *sequence = [SKAction sequence:@[group, group2]];
                sequence.timingMode = SKActionTimingEaseInEaseOut;
                [temp runAction:sequence];
            }
        }
    }
}

- (void) setAlphaLevelsOn:(SKNode *)planetImg ToVisible:(BOOL)toVisible {

    SKAction *fade = [SKAction fadeAlphaTo:1 duration:actionSpeed];
    
    if (!toVisible) {
        fade = [SKAction fadeAlphaTo:0 duration:actionSpeed];
    }
    
    for (id level in [planetImg children]) {
        [level runAction:fade];
    }
}


- (void) userPan:(UIPanGestureRecognizer *)sender {
    CGPoint touch = [sender locationInView:self.view];
    CGPoint origo = [mainLoc CGPointValue];
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        rotActive = true;
        
        lastTouch = touch;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (rotActive) {
            
            // Find the lenghts of the triangle
            float a = sqrt(pow(lastTouch.x - origo.x, 2)+ pow(lastTouch.y - origo.y,2));
            float b = sqrt(pow(touch.x - origo.x, 2)+ pow(touch.y - origo.y,2));
            float c = sqrt(pow(lastTouch.x - touch.x, 2)+ pow(lastTouch.y - touch.y,2));
            // Cosinus-lagen
            float angle = acos((b*b + a*a - c*c)/(2*b*a));
            SKNode *temp = [[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"];
            
            float deltaFirst = atan2f(lastTouch.x - origo.x, lastTouch.y - origo.y);
            float deltaSecon = atan2f(touch.x - origo.x, touch.y - origo.y);
            
            if (deltaFirst > deltaSecon) {
                angle = angle * -1;
            }
            
            temp.zRotation = temp.zRotation + angle;
            
            for (id level in [[[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"] children]) {
                float levelRot = [level zRotation] - angle;
                [level setZRotation:(levelRot)];
            }
            
            /*
             rotate = [SKAction rotateByAngle:(dir) duration:1];
             //[[_planets objectAtIndex:0] runAction:rotate];
             [[[_planets objectAtIndex:0] childNodeWithName:@"planetImg"] runAction:rotate];
             rotate = [SKAction rotateByAngle:(-dir) duration:1];
             
             for (id level in [[[_planets objectAtIndex:0] childNodeWithName:@"planetImg"] children]) {
             [level runAction:rotate];
             }             */
            
            
            
            lastTouch = touch;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (rotActive) {

            CGPoint velocityPoint = [sender velocityInView:sender.view];
        
            //float velocity = abs((velocityPoint.x + velocityPoint.y)/2);
            //velocity = (velocity*M_PI)/ 180;
            //velocity = velocity / 10;
            float velocity = abs((velocityPoint.y * M_PI) / 180);
            velocity = velocity / 10;
            
            if (velocityPoint.y < 0) {
                velocity = velocity;
            } else if (velocityPoint.y >= 0) {
                velocity = velocity * -1;
            }
            
            SKAction *rotate = [SKAction rotateByAngle:(-velocity) duration:1];
            [rotate setTimingMode:SKActionTimingEaseOut];
            
            for (id level in [[[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"] children]) {
                [level runAction:rotate];
            }
                                                        
            rotate = [SKAction rotateByAngle:(velocity) duration:1];
            [rotate setTimingMode:SKActionTimingEaseOut];
            SKAction *block = [SKAction runBlock:^{
                rotActive = false;
            }];
            SKAction *sequence = [SKAction sequence:@[rotate,block]];
            
            SKNode *temp = [[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"];
            [temp runAction:sequence];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        if (rotActive) {
            SKNode *temp = [[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"];
            [temp removeAllActions];

            for (id level in [[[_planetNodes objectAtIndex:planetIndex] childNodeWithName:@"planetImg"] children]) {
                [level removeAllActions];
            }
            rotActive = false;
        }
    }
}

 








@end
