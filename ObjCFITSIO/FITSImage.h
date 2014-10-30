//
//  FITSImage.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 22/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSConstants.h"
#import <Cocoa/Cocoa.h>

@class FITSHeader;
@class FITSImage;
@class FITSSpectrum;

typedef void(^FITSImageBlock_t)(FITSImage *newImage);
typedef void(^FITSImageScalingBlock_t)(double progress);

@interface FITSImage : NSObject 

@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;
@property (nonatomic, assign, readonly) FITSImageType type;
@property (nonatomic, assign, readonly) FITSSize size;
@property (nonatomic, readonly) double *rawIntensity;
@property (nonatomic, readonly) double *currentApparentIntensity;

+ (FITSImage *)imageWithType:(FITSImageType)t size:(FITSSize)s;

- (BOOL)is1D;
- (BOOL)is2D;
- (long)numberOfPixels;

- (FITSHeader *)header;
- (NSString *)humanSizeDescription;

- (void)setImageData:(double *)rawImageData;

// 2D
- (NSImage *)image;
- (CGImageRef)CGImage;
- (const unsigned char *)bitmapData;

- (NSImage *)imageScaledToSize:(NSSize)s;
- (CGImageRef)CGImageScaledToSize:(NSSize)s;

- (NSColor *)colorAtPoint:(NSPoint)p;
- (CGFloat)normalizedIntensityAtPoint:(NSPoint)p;
- (CGFloat)averageIntensityInRectWithCenter:(NSPoint)p width:(CGFloat)w;

// Transformation functions, note that there implementation **should** use set2DImageData
// after they perform transformation on the rawIntensity.
- (void)applyLinearScaleWithBias:(double)bias contrast:(double)contrast;
- (void)applySqrtScaleWithBias:(double)bias contrast:(double)contrast;
- (void)applySquaredScaleWithBias:(double)bias contrast:(double)contrast;
- (void)applyAsinhScaleWithBias:(double)bias contrast:(double)contrast;
- (void)applyLogScaleWithBias:(double)bias contrast:(double)contrast exponent:(double)exp;
- (void)applyPowerScaleWithBias:(double)bias contrast:(double)contrast exponent:(double)exp;

// 1D
- (FITSSpectrum *)spectrum;
- (CGFloat)spectrumLength;

- (void)applyZscalingOnProgress:(FITSImageScalingBlock_t)progressBlock onCompletion:(FITSImageBlock_t)completionBlock;

@end
