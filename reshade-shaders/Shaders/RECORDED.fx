	////////////////////////////////////////////////////////////////////////////
	//
	// RECORDED OR NOT by L00, v2.4
	// a ReShade for Ready or Not:
	// https://www.nexusmods.com/readyornot/mods/2634
	// 
	// DO NOT REDISTRIBUTE AND DO NOT SELL THIS FILE.
	// IF YOU BOUGHT THIS FILE FROM A PAYWALLED PRESET : ASK FOR A REFUND!
	//
	////////////////////////////////////////////////////////////////////////////
	//
	// NO PERMISSION IS GRANTED TO USE THIS FILE, THE PRESETS 
	// AND THE SETTINGS WITH ANOTHER PRESET THAN RECORDED OR NOT.
	//
	// CREDITS: this file is a collection of modified codes
	// from many different sources customised and put together 
	// to work in synergy with shared variables to offer a specific experience.
	// Names of original authors can be found next to the UI declarations below.
	//
	/////////////////////////////////////////////////////////////////////////////

#include "ReShadeUI.fxh"
#include "ReShade.fxh"



uniform int UIVersion <ui_type = "radio";ui_label = " ";ui_text ="v2.4 by L00"
"\n\nPress PAGE UP to toggle Full camera Stamps"
"\nPress PAGE DOWN to toggle subdued camera Stamps"
"\nPress HOME to toggle Depth of Field (Performance Boost)"
"\nPress DELETE to toggle Screen-Shake"
"\nPress CAPSLOCK to toggle the FOG Disabler with Ambiant occlusion changes"
"\nPress INSERT to toggle Night / Dark mode"
"\n(active if a little icon appears in the bottom left corner of the screen)"
"\n\nConsidering how much of a heavy lifting Recorded or Not is doing and if you need better performances, you may lower the advanced graphics option / post-processing slider of Ready Or Not to medium or even low without any important visual loss";ui_category = ">> RECORDED or NOT : TRUE BODYCAMS <<";ui_category_closed = false;>;

uniform int iKeyNight <
		ui_category = ">> RECORDED or NOT : TRUE BODYCAMS <<"; ui_type = "combo"; ui_label = "Night Settings Key"; ui_items = "none\0Insert\0Pause\0F9\0F10\0F11\0F12\0";> = 1;

uniform int iKBD <
		ui_category = ">> RECORDED or NOT : TRUE BODYCAMS <<"; ui_type = "combo"; ui_label = "Keyboard"; ui_items = "QWERTY\0AZERTY\0";> = false;
		
	//////////////////////////////////////////////////
	//
	// USER INTERFACE
	//
//KEYS
// NIGHT bISNIGHT
uniform bool kInsert <source="key"; keycode=45; toggle=true;>; //https://keycode.info
uniform bool kPause <source="key"; keycode=19; toggle=true;>; //https://keycode.info
uniform bool kF9 <source="key"; keycode=120; toggle=true;>; //https://keycode.info
uniform bool kF10 <source="key"; keycode=121; toggle=true;>; //https://keycode.info
uniform bool kF11 <source="key"; keycode=122; toggle=true;>; //https://keycode.info
uniform bool kF12 <source="key"; keycode=123; toggle=true;>; //https://keycode.info

uniform bool kLeftArrow <source="key"; keycode=37; toggle=true;>; //https://keycode.info
uniform bool kUpArrow <source="key"; keycode=38; toggle=true;>; //https://keycode.info
uniform bool kDownArrow <source="key"; keycode=40; toggle=true;>; //https://keycode.info
uniform bool kRightArrow <source="key"; keycode=39; toggle=true;>; //https://keycode.info

//Shortcut FOG
uniform bool klOCKS <source="key"; keycode=20; toggle=true;>; //https://keycode.info

//Shortcut DOF
uniform bool kHome <source="key"; keycode=36; toggle=true;>; //https://keycode.info //

//Shortcuts Camera Stamps
uniform bool kpageUp <source="key"; keycode=33; toggle=true;>; //https://keycode.info //
uniform bool kpageDown <source="key"; keycode=34; toggle=true;>; //https://keycode.info //

//Shortcuts Lens Motion
uniform bool kDel <source="key"; keycode=46; toggle=true;>; //https://keycode.info //

uniform bool kStrafeLeft <source="key"; keycode=81; toggle=false;>; //https://keycode.info //
uniform bool kStrafeLeftUS <source="key"; keycode=65; toggle=false;>; //https://keycode.info //
uniform bool kStrafeRight <source="key"; keycode=68; toggle=false;>; //https://keycode.info //

uniform bool kStrafeForward <source="key"; keycode=90; toggle=false;>; //https://keycode.info //
uniform bool kStrafeForwardUS <source="key"; keycode=87; toggle=false;>; //https://keycode.info //
uniform bool kStrafeBack <source="key"; keycode=83; toggle=false;>; //https://keycode.info //

uniform bool RightMouseDown < source = "mousebutton"; keycode = 1; toggle = false; >; //FOR ME TESTING ONLY

// ------------------------------------------------ ENV. SETTINGS ------------------------------------------------------------------
uniform bool USE_ENV <ui_category = ":: ENVIRONMENTS ::"; ui_label = "USE ENVIRONMENT TWEAKS"; ui_category_closed = true;> = true;
#define skyColorThreshold 75
uniform float skyExposure <__UNIFORM_SLIDER_FLOAT1
	ui_label = "Sky Exposure";ui_category = ":: ENVIRONMENTS ::";ui_min = 0.0;ui_max = 2.0;ui_step = 0.1;> = 0.0;

uniform float SkyDistance < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 100000.0; ui_step = 1.0; ui_label = "Sky Distance";ui_category = ":: ENVIRONMENTS ::";> = 500.0;

uniform float fBlackPointDepth < __UNIFORM_SLIDER_FLOAT1
		ui_label = "Fog Lift"; ui_category = ":: ENVIRONMENTS ::";ui_min = -500.0; ui_max = 0.0f; ui_step = 5;> = 0.0;

uniform float DepthFogPow < __UNIFORM_SLIDER_FLOAT1
	ui_min = 1.0; ui_max = 100.0; ui_step = 0.1; ui_label = "Fog Distance";ui_category = ":: ENVIRONMENTS ::";> = 10.0;

uniform bool bShowDepth <
		ui_label = "Show Fog Depth";ui_category = ":: ENVIRONMENTS ::";ui_category_closed = true;> = false;

uniform float fCtrstDown <
        ui_label = "Untonemap";ui_category = ":: ENVIRONMENTS ::";ui_type = "slider";ui_min = -1.0;ui_max = 1.0;> = 0.0;
	
// ------------------------------------------------ LENS SETTINGS ------------------------------------------------------------------	
// LENS DEPTH OF FIELD by Frans Bouma, aka Otis

uniform int iAnamorphic <
		ui_category = ":: LENS ::"; ui_type = "combo"; ui_label = "LENS Type"; ui_items = "Spherical\0Anamorphic\0";ui_category_closed = true;> = false;

uniform bool USE_DOF <ui_category = ":: LENS ::"; ui_label = "DEPTH OF FIELD";> = true;

uniform float fBlurSize <
        ui_type = "slider";ui_label = "Depth of Field size"; ui_category = ":: LENS ::";ui_min = 0.0;ui_max = 1.0;> = 1.0;
		
uniform float FNumber < __UNIFORM_SLIDER_FLOAT1
	ui_min = 1.0; ui_max = 22.0; ui_step = 0.1; ui_label = "LENS Aperture"; ui_category = ":: LENS ::";> = 2.8;

uniform bool bUseApertureAdaptation <ui_label = "Link Aperture to Exposure";ui_category = ":: LENS ::";> = false;

uniform float FocalLength <
	ui_category = ":: LENS ::";ui_label = "LENS Focal length (mm)";ui_type = "drag";ui_min = 8.0; ui_max = 600.0;ui_step = 1.0;> = 100.00;

// SHAKING by L00
uniform bool USE_LensShake <ui_category = ":: LENS ::"; ui_label = "LENS MOTION";> = true;
#define bUseRandom 0

uniform float2 fShakeAmplitude < __UNIFORM_SLIDER_FLOAT2
	ui_label = "Lens Motion Amplitude [Vertical | Horizontal]"; ui_category = ":: LENS ::";ui_min = 0.0; ui_max = 10.0; ui_step = 0.001;> = float2(0.1, 1.0);

uniform float2 fShakeFrequency < __UNIFORM_SLIDER_FLOAT2
	ui_label = "Lens Motion Amount [Vertical | Horizontal]"; ui_category = ":: LENS ::";ui_min = 0.0; ui_max = 100.0; ui_step = 1.0;> = float2(1.0, 2.0);

uniform float2 fShakeDuration < __UNIFORM_SLIDER_FLOAT2
	ui_label = "Lens Motion [Duration | Frequency]"; ui_category = ":: LENS ::";ui_min = 0.0; ui_max = 100.0; ui_step = 0.01;> = float2(1.0, 1.0);

// LENS HAZE by Ganossa
uniform bool USE_LensHaze <ui_category = ":: LENS ::"; ui_label = "LENS HAZE";> = true;

uniform float fLensHazeIntensity < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 50.0; ui_label = "Lens haze intensity"; ui_category = ":: LENS ::";> = 10.0;

uniform float fLensHazeAdaptation < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 10.0; ui_label = "Lens Haze dispersion"; ui_category = ":: LENS ::";> = 0.70;
	
uniform float fLensHazeCompression < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 10.0; ui_label = "Lens Haze compression"; ui_category = ":: LENS ::";> = 1.00;
	
uniform int fLensHazeLightLevel < __UNIFORM_SLIDER_INT1
	ui_min = 0; ui_max = 4; ui_label = "Lens Haze levels"; ui_category = ":: LENS ::";> = 2;

// LENS DIRT by Ganossa
uniform bool bUseLensDirt <ui_label = "LENS DIRT";ui_category = ":: LENS ::";> = true;

uniform bool bUseVeryLensDirt <ui_label = "Very Dirty";ui_category = ":: LENS ::";> = true;

uniform float fLensDirtIntensity < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 100.0; ui_label = "Lens Dirt intensity"; ui_category = ":: LENS ::";> = 1.0;

uniform float fLensDirtRefractionPower < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 100.0; ui_label = "Lens Dirt Refraction power"; ui_category = ":: LENS ::";> = 2.0;


// LENS SHADOW by Christian Cann Schuldt Jensen ~ CeeJay.dk
uniform bool bUseLenShadow <ui_label = "LENS SHADOW";ui_category = ":: LENS ::";> = true;
	
uniform float fLensShadowShape < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.15; ui_max = 10.0; ui_label = "Lens Shadow Shape"; ui_category = ":: LENS ::";> = 1.0;

uniform int iLensShadowDistance < __UNIFORM_SLIDER_INT1
	ui_min = 2; ui_max = 100; ui_label = "Lens Shadow Distance";ui_category = ":: LENS ::";> = 2;
	
uniform float fLensShadowSoftness < __UNIFORM_SLIDER_FLOAT1
	ui_min = -5.0; ui_max = 5.0; ui_label = "Lens Shadow softness";ui_category = ":: LENS ::";> = 2.0;

uniform float fLensShadowResult < __UNIFORM_SLIDER_FLOAT1
	ui_min = -50.0; ui_max = 1.0;ui_label = "Lens Shadow Intensity";ui_category = ":: LENS ::";> = -1.0;


// RATIO by Fubax
uniform bool bUseLensDistortion <ui_label = "LENS DISTORTION";ui_category = ":: LENS ::";> = true;

uniform float fLensProps < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Lens Proportion";ui_category = ":: LENS ::";ui_min = -1.0; ui_max = 1.0;> = 0.0;
	
uniform bool FitScreen <ui_label = "Auto scaling"; ui_category = ":: LENS ::";> = true;
uniform bool bLensDistPerfectFit <ui_label = "Pixel Perfect";ui_category = ":: LENS ::";> = true;


// DISTORTION by icelaglace & McFly
uniform float fFisheyeDistortion <
	ui_type = "drag";ui_min = -1.000; ui_max = 1.000;ui_label = "Lens Fisheye Distortion"; ui_category = ":: LENS ::";> = 0.01;

uniform float fFisheyeDistortionEdges <
	ui_type = "drag";ui_min = -1.000; ui_max = 1.000;ui_label = "Lens Edges Distortion"; ui_category = ":: LENS ::";> = 0.7;

uniform float fFisheyeCA <
	ui_type = "drag";ui_min = -1.00; ui_max = 1.00;ui_label = "Lens Chromatic Aberration"; ui_category = ":: LENS ::";> = 0.002;


// GAUSS BLUR by Ioxa
uniform bool bUseLensBlur <ui_label = "LENS QUALITY"; ui_category = ":: LENS ::";> = true;

uniform float LensBlur_PrePassOffset < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.00; ui_max = 2.00; ui_label = "Lens softness"; ui_category = ":: LENS ::";> = 0.00;


// SHARPENING by Christian Cann Schuldt Jensen ~ CeeJay.dk
uniform float fLensSharpnessRadius < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 10.0; ui_label = "Lens Sharpness: Radius"; ui_category = ":: LENS ::";> = 1.0;

uniform float2 fLensSharpness < __UNIFORM_SLIDER_FLOAT2
	ui_min = -10.0; ui_max = 100.0;ui_step = 1.0; ui_label = "Lens Sharpness: Near | Far"; ui_category = ":: LENS ::";> = float2(1.0,0.0);

uniform float DepthSharpPow < __UNIFORM_SLIDER_FLOAT1
	ui_min = 1.0; ui_max = 100.0; ui_step = 0.1; ui_label = "Lens Sharpness: Depth Curve";ui_category = ":: LENS ::";> = 100.0;

//------------------------------------------------ CAMERA SETTINGS ----------------------------------------------------------------

uniform float Exposure <__UNIFORM_SLIDER_FLOAT1
	ui_label = "EV: Offset";ui_category = ":: CAMERA ::";ui_min = -6.0;ui_max = 6.0;ui_step = 0.2;ui_category_closed = true;> = 0.0;

uniform int AdaptMetering <
	ui_category = ":: CAMERA ::";ui_type = "combo";ui_label = "Exposure Metering";ui_items = "Matrix\0Center-weighted\0Spot\0";> = false;

uniform int iISO <
	ui_category = ":: CAMERA ::";ui_type = "combo";ui_label = "ISO";ui_items = "_100\0_100F\0_200\0_200F\0_400\0_400F\0_600\0_800\0_800F\0_1200\0_1200F\0";> = false;

// FILMIC SHARPEN by Prod80
uniform float fSensorSizeSharpness < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Sensor Size Offset";ui_category = ":: CAMERA ::";ui_min = 0.0; ui_max = 2.0; ui_step = 0.01;> = 0.1;

uniform float fSensorCA <
	ui_type = "drag";ui_min = 0.0;ui_max = 1.0;ui_step = 0.01;ui_label = "Sensor Aberration";ui_category = ":: CAMERA ::";> = 0.5;	

// WHITE BALANCE by Prod80
uniform bool AutoWhiteBalance < ui_category = ":: CAMERA ::";> = true;

uniform float fWhitePointCorrectionIntensity <
        ui_type = "slider";ui_label = "White Point Correction Intensity";ui_category = ":: CAMERA ::";ui_min = 0.0f;ui_max = 1.0f;> = 1.0;

uniform float fAutoBalanceIntensity <
        ui_type = "slider";ui_label = "Automatic Balance Intensity";ui_category = ":: CAMERA ::";ui_min = 0.0f;ui_max = 5.0f;> = 0.5;
		
uniform uint Kelvin <
        ui_label = "Manual White Balance Offset";ui_category = ":: CAMERA ::";ui_type = "slider";ui_min = 1000;ui_max = 40000;> = 6500;

uniform bool bMidpointRespectGamma <
	ui_label = "Gamma Preservation";ui_category = ":: CAMERA ::";> = true;

uniform bool LumPreservation <
        ui_label = "Luminance Preservation";ui_category = ":: CAMERA ::";> = true;
	
//------------------------------------------------ CAMERA PROFILE ----------------------------------------------------------------
		
// LUT and CC by Jacob Maximilian Fober and Prod80
uniform int iLUTSet <
		ui_category = ":: CAMERA PROFILE ::"; ui_type = "combo"; ui_label = "Camera Color Profile"; ui_items = "Raw\0CamCorder_VHS\0AxonBody2\0AxonBody4\0Motorola\0UnRecord\0GoPro\0";ui_category_closed = true;> = false;

uniform float2 LutChromaLuma < __UNIFORM_SLIDER_FLOAT2
	ui_label = "Camera Profile [chroma | luma]"; ui_category = ":: CAMERA PROFILE ::";ui_min = 0.0; ui_max = 1.0; ui_step = 0.005;> = float2(1.0, 1.0);

uniform float fGamma <
        ui_label = "Gamma Output";ui_category = ":: CAMERA PROFILE ::";ui_type = "slider";ui_min = 0.1;ui_max = 2.0;> = 1.0;

uniform float saturation_limit <
        ui_type = "slider";ui_label = "Saturation Limit";ui_category = ":: CAMERA PROFILE ::";ui_min = 0.0;ui_max = 1.0;> = 1.0;

// SHADOW DESATURATION by Boris Vorontsov
uniform float fDesaturateShadows <
        ui_label = "Shadow Desaturation";ui_category = ":: CAMERA PROFILE ::";ui_type = "slider";ui_min = 0.0;ui_max = 2.0;> = 1.0;

//----------------------------------------------- FIRMWARE SETTINGS ------------------------------------------------------------
// COLOR DISTORTIONS by leilei, Matsilagi, IDDQD and hunterk
uniform bool bColorDistortion <ui_category = ":: FIRMWARE ::"; ui_label = "Use Firmware Options";ui_category_closed = true;> = true;

uniform int iInternalRes <
		ui_category = ":: FIRMWARE ::"; ui_type = "combo"; ui_label = "Internal Resolution"; ui_items = "GameRes\0_1080p\0_720p\0_520\0_480\0";> = false;

uniform float fFirmwareSharpening < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Firmware Enhancement";ui_category = ":: FIRMWARE ::";ui_min = 0.0; ui_max = 100.0; ui_step = 0.01;> = 60.0;

uniform float fSmoothing <
        ui_type = "slider";ui_label = "Vertical Smoothing";ui_category = ":: FIRMWARE ::";ui_min = 0.0;ui_max = 1.0;> = 0.0;
	
// GAUSS BLUR by Ioxa
uniform float fFirmwareFiltering < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.00; ui_max = 2.00; ui_label = "Firmware Filtering"; ui_category = ":: FIRMWARE ::";> = 0.5;

uniform int iBitRate <
		ui_category = ":: FIRMWARE ::"; ui_type = "combo"; ui_label = "MPEG Encoding"; ui_items = "_50Mb/s\0_20Mb/s\0_10Mb/s\0_5Mb/s\0_1Mb/s\0_75kb/s\0_50Kb/s\0_25Kb/s\0_10Kb/s\0_5Kb/s\0_1Kb/s\0";> = false;
	
uniform float fPixelSharpIntensity < __UNIFORM_SLIDER_FLOAT1
	ui_min = 0.0; ui_max = 3.0; ui_label = "Pixel Sharpness";ui_category = ":: FIRMWARE ::";> = 0.65;

uniform bool bUseVHS <ui_category = ":: POST-PROCESSING ::";ui_label = "VHS";ui_category_closed = true;> = true;
uniform bool bUseInterlaced <ui_category = ":: POST-PROCESSING ::";ui_label = "Interlaced";> = true;


// CAMERA STAMPS & CLOCK SETTINGS by KingEric & yunghas
uniform int iLogoSet <
		ui_category = ":: CAMERA STAMPS ::"; ui_type = "combo"; ui_label = "Camera set"; ui_items = "None\0VHS\0HelmetCam\0Axon_2\0Axon_4\0Motorola\0GoPro\0LiveLeak\0";ui_category_closed = true;> = false;

uniform bool DEVBUILD <ui_category = "::  RECORDED or NOT 2.4 ::"; ui_label = "DevBuild";ui_category_closed = true;> = false;

uniform float fTEST < __UNIFORM_SLIDER_FLOAT1
		ui_min = 0.0; ui_max = 10.0;ui_step = 0.001; ui_label = "Test: lemme check this";ui_category = "::  RECORDED or NOT 2.4 ::";> = 1.0;

	


	//////////////////////////////////////////////////
	//
	// SETTINGS
	//
	//////////////////////////////////////////////////
#define bToggleDOF USE_DOF || kHome
#define LDepth 				ReShade::GetLinearizedDepth
#define Intensity 0.75

#define fSensorSize 0
#define AutoFocusPoint float2(0.5,0.38)
#define AdaptFocalPoint float2(0.5,0.5) //.48

#define fVHSmix 0.4

#define offset_bias 0.2
#define show_sharpen 0
#define Preview 0
#define Clamp 0.555
#define UseAutoFocus 1
#define AutoFocusTransitionSpeed 0.2f
#define AdaptTime 0.5
#define AdaptTimeColor 1.0
#define bMidpointAverage 0

#define FarPlaneMaxBlur 2.0 
#define NearPlaneMaxBlur fBlurSize 
#define BlurQuality 8.0 //16
#define BokehBusyFactor 1.0
#define PostBlurSmoothing 0.1
#define HighlightBoost lerp(1.0, 0.7,fLensSharpness.x*0.01)
#define HighlightSharpeningFactor 2.0
#define HighlightShape 0

#define FocusCrosshairColor float4(1.0,0.0,1.0,1.0)
#define FocusPlaneColor float3(0.0,0.0,1.0)
#define HighlightAnamorphicAlignmentFactor 1.0
#define HighlightAnamorphicSpreadFactor 0.9
#define HighlightGammaFactor 1.0
#define HighlightShapeGamma 1.0
#define HighlightShapeRotationAngle 0.0

#define ManualFocusPlane 10.0
#define MitigateUndersampling 0
#define OutOfFocusPlaneColor float3(0.8,0.8,0.8)
#define OutOfFocusPlaneColorTransparency 0.7
#define ShowCoCValues 0
#define ShowOutOfFocusPlaneOnMouseDown 0
#define UseMouseDrivenAutoFocus 0

#define alDirtOVInt fLensDirtIntensity*0.33

#define AutoWhitePoint 1
#define whitepoint_method 1
#define blackpoint_method 1

/// DEFINITIONS
#define CD_BOKEH_SHAPE (__RENDERER__ >= 0xa000)
#define GEMFX_PIXEL_SIZE float2(1.0f / (BUFFER_WIDTH / 16.0f), 1.0f / (BUFFER_HEIGHT / 16.0f))
#define CoefLuma float3(0.2126, 0.7152, 0.0722)
#define perfectCenter float2(0.5f,0.5f)
#define BlackColor float4(0.0,0.0,0.0,1.0)

/// CONSTANTS
#if __RESHADE_FXC__		// Freestyle
	#define OUT_OF_FOCUS_PLANE_COLORTRANSPARENCY 	0.5
#endif
	
//#define SENSOR_SIZE			0.024		// Height of the 35mm full-frame format (36mm x 24mm)
#define PI 					3.1415926535897932
#define TILE_SIZE			1			// amount of pixels left/right/up/down of the current pixel. So 4 is 9x9
#define TILE_MULTIPLY		1
#define GROUND_TRUTH_SCREEN_WIDTH	1920.0f
#define GROUND_TRUTH_SCREEN_HEIGHT	1200.0f


#ifndef BUFFER_PIXEL_SIZE
	#define BUFFER_PIXEL_SIZE	ReShade::PixelSize
#endif
#ifndef BUFFER_SCREEN_SIZE
	#define BUFFER_SCREEN_SIZE	ReShade::ScreenSize
#endif

uniform float2 AL_t < source = "pingpong"; min = 0.0f; max = 6.28f; step = float2(0.1f, 0.2f); >;

uniform float FrameTime <source = "frametime";>;
uniform int FrameCount < source = "framecount"; >;

uniform float4 gDate    < source = "date"; >;
static const int2 AdaptResolution = 256;
static const int AdaptMipLevels = 9;
static const float3 LumaWeights = float3(0.299, 0.587, 0.114);

#define LUT_BLOCK_SIZE 64

#define LUT_DIMENSIONS int2(LUT_BLOCK_SIZE*LUT_BLOCK_SIZE, LUT_BLOCK_SIZE)
#define LUT_PIXEL_SIZE 1.0/LUT_DIMENSIONS

#define HW 1.00
#define LUM_R (76.0f/255.0f)
#define LUM_G (150.0f/255.0f)
#define LUM_B (28.0f/255.0f)

uniform float Timer < source = "timer"; >;
#define ftimer2 Timer*0.001

static const float dithertable[16] = {
	16.0,4.0,13.0,1.0,   
	8.0,12.0,5.0,9.0,
	14.0,2.0,15.0,3.0,
	6.0,10.0,7.0,11.0		
};

#define mod(x,y) (x-y*floor(x/y))
#define texture_size float2(BUFFER_WIDTH, BUFFER_HEIGHT)

#define pi 2.0*asin(1.0)
#define fjpg(x) (x!=0.?1.:1./sqrt(2.))

#define iTime mod(float(FrameCount), 7.0)

static const float2 f2Resolution = float2(BUFFER_WIDTH, BUFFER_HEIGHT);
static const float2 f2PixelSize = 1.0 / f2Resolution;


	//////////////////////////////////////////////////
	//
	// TEXTURES
	//
	//////////////////////////////////////////////////
	
// DOF 
texture texCDCurrentFocus		{ Width = 1; Height = 1; Format = R16F; };		// for storing the current focus depth obtained from the focus point
texture texCDPreviousFocus		{ Width = 1; Height = 1; Format = R16F; };		// for storing the previous frame's focus depth from texCDCurrentFocus.
texture texCDCoC				{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R16F; };
texture texCDCoCTileTmp			{ Width = BUFFER_WIDTH/(TILE_SIZE*TILE_MULTIPLY); Height = BUFFER_HEIGHT/(TILE_SIZE*TILE_MULTIPLY); Format = R16F; };	// R is MinCoC
texture texCDCoCTile			{ Width = BUFFER_WIDTH/(TILE_SIZE*TILE_MULTIPLY); Height = BUFFER_HEIGHT/(TILE_SIZE*TILE_MULTIPLY); Format = R16F; };	// R is MinCoC
texture texCDCoCTileNeighbor	{ Width = BUFFER_WIDTH/(TILE_SIZE*TILE_MULTIPLY); Height = BUFFER_HEIGHT/(TILE_SIZE*TILE_MULTIPLY); Format = R16F; };	// R is MinCoC
texture texCDCoCTmp1			{ Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = R16F; };	// half res, single value
texture texCDCoCBlurred			{ Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RG16F; };	// half res, blurred CoC (r) and real CoC (g)
texture texCDBuffer1 			{ Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RGBA16F; };
texture texCDBuffer2 			{ Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RGBA16F; }; 
texture texCDBuffer3 			{ Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT/2; Format = RGBA16F; };// needed for tentfilter as far/near have to be preserved in buffer 1 and 2
texture texCDBuffer4 			{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 	// Full res upscale buffer
texture texCDBuffer5 			{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 	// Full res upscale buffer. We need 2 as post smooth needs 2
texture texCDNoise				< source = "Dirt.jpg"; > { Width = 512; Height = 512; Format = RGBA8; };

// LENS HAZE
texture alInTex  { Width = BUFFER_WIDTH / 16; Height = BUFFER_HEIGHT / 16; Format = RGBA32F; };
texture alOutTex { Width = BUFFER_WIDTH / 16; Height = BUFFER_HEIGHT / 16; Format = RGBA32F; };
texture detectIntTex { Width = 32; Height = 32; Format = RGBA8; };
texture detectLowTex { Width = 1; Height = 1; Format = RGBA8; };
texture dirtTex    < source = "Dirt.jpg";    > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture dirtOVRTex < source = "RefractionRed.jpg"; > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture dirtOVBTex < source = "RefractionBlue.jpg"; > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture lensDBTex  < source = "Dirt.jpg";  > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture lensDB2Tex < source = "Dirt.jpg"; > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture lensDOVTex < source = "Dirt.jpg"; > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };
texture lensDUVTex < source = "Dirt.jpg"; > { Width = 1920; Height = 1080; MipLevels = 1; Format = RGBA8; };

//GAUSSIAN
texture GaussianBlur_PrePassTex < pooled = true; > { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };
texture GaussianBlur_PostPassTex < pooled = true; > { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA8; };

// TONEMAPPING
texture texColor { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; MipLevels = 5; };
texture texDS_1_Max { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1_Min { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1_Mid { Width = 32; Height = 32; Format = RGBA16F; };
texture texDS_1x1 { Width = 6; Height = 2; Format = RGBA16F; };
texture texPrevious { Width = 6; Height = 2; Format = RGBA16F; };
texture BackBufferTex : COLOR;	


// POSTEFFECTS
texture JPEG0_tex {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;Format = RGBA32F;};

// SHARP 
sampler BackBuffer
{
	Texture = ReShade::BackBufferTex;
	AddressU = MIRROR;
	AddressV = MIRROR;
	#if BUFFER_COLOR_BIT_DEPTH != 10
		SRGBTexture = true;
	#endif
};

// MASK

texture tVHSFull <source = "OV_VHS_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tHCLight <source = "OV_HC_Lite.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tHCFull <source = "OV_HC_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tBC2Full <source = "OV_BC2_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tBCFull <source = "OV_BC_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tMRLight <source = "OV_MR_Lite.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tMRFull <source = "OV_MR_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tGPLight <source = "OV_GP_Lite.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tGPFull <source = "OV_GP_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tLLLight <source = "OV_LL_Lite.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};
texture tLLFull <source = "OV_LL_Full.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};

texture tNightSet <source = "OV_NightSet.png";> {Width = BUFFER_WIDTH;Height = BUFFER_HEIGHT;};

// LUTS
texture LUTVHSTex < source = "l00_RecordedVHS.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };
texture LUTBCTex < source = "l00_RecordedAX2.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };
texture LUTBC2Tex < source = "l00_RecordedAX4.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };
texture LUTGPTex < source = "l00_RecordedGP.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };
texture LUTMRTex < source = "l00_RecordedMR.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };
texture LUTURTex < source = "l00_RecordedUR.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };


texture CtrstDownLUTTex < source = "L00_ContrastDown.png";>{ Width = LUT_DIMENSIONS.x; Height = LUT_DIMENSIONS.y; Format = RGBA8; };

// INTERLACED 
texture InterlacedTargetBuffer { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };

	//////////////////////////////////////////////////
	//
	// SAMPLERS
	//
	//////////////////////////////////////////////////
// DOF 
sampler	SamplerCDCurrentFocus		{ Texture = texCDCurrentFocus; };
sampler SamplerCDPreviousFocus		{ Texture = texCDPreviousFocus; };
sampler SamplerCDBuffer1 			{ Texture = texCDBuffer1; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDBuffer2 			{ Texture = texCDBuffer2; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDBuffer3 			{ Texture = texCDBuffer3; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDBuffer4 			{ Texture = texCDBuffer4; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDBuffer5 			{ Texture = texCDBuffer5; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoC				{ Texture = texCDCoC; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoCTmp1			{ Texture = texCDCoCTmp1; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoCBlurred			{ Texture = texCDCoCBlurred; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoCTileTmp			{ Texture = texCDCoCTileTmp; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoCTile			{ Texture = texCDCoCTile; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDCoCTileNeighbor	{ Texture = texCDCoCTileNeighbor; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; AddressU = MIRROR; AddressV = MIRROR; AddressW = MIRROR;};
sampler SamplerCDNoise				{ Texture = texCDNoise; MipFilter = POINT; MinFilter = POINT; MagFilter = POINT; AddressU = WRAP; AddressV = WRAP; AddressW = WRAP;};


#ifndef __RESHADE_FXC__		// Freestyle
	uniform float2 MouseCoords < source = "mousepoint"; >;
	uniform bool LeftMouseDown < source = "mousebutton"; keycode = 0; toggle = false; >;
#endif

// LENS HAZE
sampler alInColor { Texture = alInTex; };
sampler alOutColor { Texture = alOutTex; };
sampler dirtSampler { Texture = dirtTex; };
sampler dirtOVRSampler { Texture = dirtOVRTex; };
sampler dirtOVBSampler { Texture = dirtOVBTex; };
sampler lensDBSampler { Texture = lensDBTex; };
sampler lensDB2Sampler { Texture = lensDB2Tex; };
sampler lensDOVSampler { Texture = lensDOVTex; };
sampler lensDUVSampler { Texture = lensDUVTex; };
sampler detectIntColor { Texture = detectIntTex; };
sampler detectLowColor { Texture = detectLowTex; };

//GAUSSIAN
sampler GaussianBlur_PrePassSampler { Texture = GaussianBlur_PrePassTex;};
sampler GaussianBlur_PostPassSampler { Texture = GaussianBlur_PostPassTex;};

// TONEMAPPING
sampler samplerColor { Texture = texColor; };
sampler samplerDS_1_Max { Texture = texDS_1_Max;MipFilter = POINT;MinFilter = POINT;MagFilter = POINT;};
sampler samplerDS_1_Min {Texture = texDS_1_Min;MipFilter = POINT;MinFilter = POINT;MagFilter = POINT;};
sampler samplerDS_1_Mid {Texture = texDS_1_Mid;MipFilter = POINT;MinFilter = POINT;MagFilter = POINT;};
sampler samplerDS_1x1 {Texture   = texDS_1x1;MipFilter = POINT;MinFilter = POINT;MagFilter = POINT;};
sampler samplerPrevious { Texture   = texPrevious;MipFilter = POINT;MinFilter = POINT;MagFilter = POINT;};
sampler BackBuffer_Point {Texture = BackBufferTex;SRGBTexture = true;MinFilter = POINT;MagFilter = POINT;MipFilter = POINT;};
sampler BackBuffer_Linear{Texture = BackBufferTex;SRGBTexture = true;};
texture SmallTex {Width = AdaptResolution.x;Height = AdaptResolution.y;Format = R32F;MipLevels = AdaptMipLevels;};
sampler Small {Texture = SmallTex;};
texture LastAdaptTex {Format = R32F;};
sampler LastAdapt {Texture = LastAdaptTex;MinFilter = POINT;MagFilter = POINT;MipFilter = POINT;};

// LUTS
sampler LUTVHSSampler {Texture = LUTVHSTex; };
sampler LUTBCSampler {Texture = LUTBCTex; };
sampler LUTBC2Sampler {Texture = LUTBC2Tex; };
sampler LUTGPSampler {Texture = LUTGPTex; };
sampler LUTMRSampler {Texture = LUTMRTex; };
sampler LUTURSampler {Texture = LUTURTex; };

sampler CtrstDownLUTSampler {Texture = CtrstDownLUTTex; }; 

// POSTEFFECTS
sampler sJPEG0 {Texture = JPEG0_tex;};


// MASK 

sampler sVHSFull { Texture = tVHSFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sHCLight { Texture = tHCLight;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sHCFull { Texture = tHCFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sBCFull { Texture = tBCFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sBC2Full { Texture = tBC2Full;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sMRLight { Texture = tMRLight;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sMRFull { Texture = tMRFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sGPLight { Texture = tGPLight;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sGPFull { Texture = tGPFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};

sampler sNightSet { Texture = tNightSet;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};

sampler sLLLight { Texture = tLLLight;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};
sampler sLLFull { Texture = tLLFull;MinFilter = LINEAR;MagFilter = LINEAR;AddressU = BORDER;AddressV = BORDER;};

// INTERLACED 
sampler InterlacedBufferSampler { Texture = InterlacedTargetBuffer;MagFilter = POINT;MinFilter = POINT;MipFilter = POINT;};

// CHARACTERS 

texture2D texDigitsAxOG  < source = "DigitAxonOG.png"; > { Width = 256; Height = 37; };
sampler2D sampDigitsAxOG { Texture=texDigitsAxOG; };

texture2D texDigitsAxNG  < source = "DigitAxonNG.png"; > { Width = 256; Height = 37; };
sampler2D sampDigitsAxNG { Texture=texDigitsAxNG; };

texture2D texDigitGPM  < source = "DigitGPM.png"; > { Width = 256; Height = 37; };
sampler2D sampDigitGPM { Texture=texDigitGPM; };

texture2D texDigitHC  < source = "DigitHC.png"; > { Width = 128; Height = 19; };
sampler2D sampDigitHC { Texture=texDigitHC; };

texture2D texDigitVHS  < source = "DigitVHS.png"; > { Width = 256; Height = 37; };
sampler2D sampDigitVHS { Texture=texDigitVHS; };

	//////////////////////////////////////////////////
	//
	// STRUCTURES
	//
	//////////////////////////////////////////////////
// DOF
// simple struct for the Focus vertex shader.
	struct VSFOCUSINFO
	{
		float4 vpos : SV_Position;
		float2 texcoord : TEXCOORD0;
		float focusDepth : TEXCOORD1;
		float focusDepthInM : TEXCOORD2;
		float focusDepthInMM : TEXCOORD3;
		float pixelSizeLength : TEXCOORD4;
		float nearPlaneInMM : TEXCOORD5;
		float farPlaneInMM : TEXCOORD6;
	};

	struct VSDISCBLURINFO
	{
		float4 vpos : SV_Position;
		float2 texcoord : TEXCOORD0;
		float numberOfRings : TEXCOORD1;
		float farPlaneMaxBlurInPixels : TEXCOORD2;
		float nearPlaneMaxBlurInPixels : TEXCOORD3;
		float cocFactorPerPixel : TEXCOORD4;
		float highlightBoostFactor: TEXCOORD5;
	};	
	
	//////////////////////////////////////////////////
	//
	// HELPERS
	//
	//////////////////////////////////////////////////

float ResModifier()
{
	return BUFFER_HEIGHT/1440.0f;
}

float linearDepth(float nonLinDepth, float depthNearVar, float depthFarVar)
{
	return (2.0 * depthNearVar) / (depthFarVar + depthNearVar - nonLinDepth * (depthFarVar - depthNearVar));
}

float2 scale_uv(float2 uv, float2 scale, float2 center) {
	return (uv - center) * scale + center;
}

float3 rgb2yiq(float3 c){   
	return float3(
		(0.2989*c.x + 0.5959*c.y + 0.2115*c.z),
		(0.5870*c.x - 0.2744*c.y - 0.5229*c.z),
		(0.1140*c.x - 0.3216*c.y + 0.3114*c.z)
	);
}

float3 yiq2rgb(float3 c){				
	return float3(
		(1.0*c.x	+ 1.0*c.y	+ 1.0*c.z),
		(0.956*c.x	- 0.2720*c.y	- 1.1060*c.z),
		(0.6210*c.x	- 0.6474*c.y	+ 1.7046*c.z)
	);
}

float3 toYCbCr(float3 rgb)
{
    float3 RGB2Y =  float3( 0.299, 0.587, 0.114);
    float3 RGB2Cb = float3(-0.169,-0.331, 0.500);
    float3 RGB2Cr = float3(0.500,-0.419,-0.081);
	float3 newmat = float3(dot(rgb, RGB2Y), dot(rgb, RGB2Cb), dot(rgb, RGB2Cr));
	float3 addit = float3(0.0,0.5,0.5);
    return newmat+addit;
}

float2 Circle(float Start, float Points, float Point) 
{
	float Rad = (3.141592 * 2.0 * (1.0 / Points)) * (Point + Start);
	//return float2(sin(Rad), cos(Rad));
		return float2(-(.3+Rad), cos(Rad));

}

float3 pre( float2 coord ){
    return floor(256.0*(toYCbCr(tex2D(ReShade::BackBuffer, coord/ReShade::ScreenSize.xy).xyz) - .5));
}

float3 DCT8x8( float2 coord, float2 uv ) {
    float3 res = float3(0,0,0);
    for(float x = 0.; x < 8.; x++){
    	for(float y = 0.; y < 8.; y++){
            res += pre(coord + float2(x,y)) *
                cos((2.*x+1.)*uv.x*pi/16.) *
                cos((2.*y+1.)*uv.y*pi/16.);
    	}
    }
    return res * .25 * fjpg(uv.x) * fjpg(uv.y);
}

float3 toRGB(float3 ybr) {
    return mul( float3x3(
        1., 0.00,     1.402,
        1.,-0.344136,-0.714136,
        1., 1.772,    0.00), ybr-float3(0,.5,.5));
}

float3 inp(float2 coord){
    return tex2Dfetch(sJPEG0, float4(int2(coord.xy),0,0)).xyz;
}

float3 IDCT8x8(float2 coord, float2 xy ) {
    float3 res = float3(0.0,0.0,0.0);
    for(float u = 0.; u < 8.0; u++){
    	for(float v = 0.; v < 8.0; v++){
            res += inp(coord + float2(u,v)) *
                fjpg(u) * fjpg(v) *
                cos((2.*xy.x+1.)*u*pi/16.) *
                cos((2.*xy.y+1.)*v*pi/16.);
    	}
    }
    return res * .25;
}

float3 HUEToRGB( in float H )
{
    return saturate( float3( abs( H * 6.0f - 3.0f ) - 1.0f,
                                  2.0f - abs( H * 6.0f - 2.0f ),
                                  2.0f - abs( H * 6.0f - 4.0f )));
}

float3 RGBToHCV( in float3 RGB )
{
    // Based on work by Sam Hocevar and Emil Persson
    float4 P         = ( RGB.g < RGB.b ) ? float4( RGB.bg, -1.0f, 2.0f/3.0f ) : float4( RGB.gb, 0.0f, -1.0f/3.0f );
    float4 Q1        = ( RGB.r < P.x ) ? float4( P.xyw, RGB.r ) : float4( RGB.r, P.yzx );
    float C          = Q1.x - min( Q1.w, Q1.y );
    float H          = abs(( Q1.w - Q1.y ) / ( 6.0f * C + 0.000001f ) + Q1.z );
    return float3( H, C, Q1.x );
}

float3 RGBToHSL( in float3 RGB )
{
    RGB.xyz          = max( RGB.xyz, 0.000001f );
    float3 HCV       = RGBToHCV(RGB);
    float L          = HCV.z - HCV.y * 0.5f;
    float S          = HCV.y / ( 1.0f - abs( L * 2.0f - 1.0f ) + 0.000001f);
    return float3( HCV.x, S, L );
}

float3 HSLToRGB( in float3 HSL )
{
    float3 RGB       = HUEToRGB(HSL.x);
    float C          = (1.0f - abs(2.0f * HSL.z - 1.0f)) * HSL.y;
    return ( RGB - 0.5f ) * C + HSL.z;
}

float3 KelvinToRGB( in float k )
{
    float3 ret;
    float kelvin     = clamp( k, 1000.0f, 40000.0f ) / 100.0f;
    if( kelvin <= 66.0f )
    {
        ret.r        = 1.0f;
        ret.g        = saturate( 0.39008157876901960784f * log( kelvin ) - 0.63184144378862745098f );
    }
    else
    {
        float t      = max( kelvin - 60.0f, 0.0f );
        ret.r        = saturate( 1.29293618606274509804f * pow( t, -0.1332047592f ));
        ret.g        = saturate( 1.12989086089529411765f * pow( t, -0.0755148492f ));
    }
    if( kelvin >= 66.0f )
        ret.b        = 1.0f;
    else if( kelvin < 19.0f )
        ret.b        = 0.0f;
    else
        ret.b        = saturate( 0.54320678911019607843f * log( kelvin - 10.0f ) - 1.19625408914f );
    return ret;
}

// RGB to YUV709 luma
static const float3 Luma709 = float3(0.2126, 0.7152, 0.0722);
// RGB to YUV601 luma
static const float3 Luma601 = float3(0.299, 0.587, 0.114);

// Overlay blending mode
float Overlay(float LayerA, float LayerB)
{
	float MinA = min(LayerA, 0.5);
	float MinB = min(LayerB, 0.5);
	float MaxA = max(LayerA, 0.5);
	float MaxB = max(LayerB, 0.5);
	return 2.0*((MinA*MinB+MaxA)+(MaxB-MaxA*MaxB))-1.5;
}

// Overlay blending mode for one input
float Overlay(float LayerAB)
{
	float MinAB = min(LayerAB, 0.5);
	float MaxAB = max(LayerAB, 0.5);
	return 2.0*((MinAB*MinAB+MaxAB)+(MaxAB-MaxAB*MaxAB))-1.5;
}

// Convert to linear gamma
float gamma(float grad) { return pow(abs(grad), 2.2); }

// sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
static const float3x3 ACESInputMat = float3x3
(
	0.59719, 0.35458, 0.04823,
	0.07600, 0.90834, 0.01566,
	0.02840, 0.13383, 0.83777
);

// ODT_SAT => XYZ => D60_2_D65 => sRGB
static const float3x3 ACESOutputMat = float3x3
(
	 1.60475, -0.53108, -0.07367,
	-0.10208,  1.10813, -0.00605,
	-0.00327, -0.07276,  1.07602
);

float3 RRTAndODTFit(float3 v)
{
	float3 a = v * (v + 0.0245786f) - 0.000090537f;
	float3 b = v * (0.983729f * v + 0.4329510f) + 0.238081f;
	return a / b;
}

	//////////////////////////////////////////////////
	//
	// FUNCTIONS
	//
	//////////////////////////////////////////////////
bool bISNIGHT()
{
	if (iKeyNight == 1 && kInsert) return true;
	if (iKeyNight == 2 && kPause) return true;
	if (iKeyNight == 3 && kF9) return true;
	if (iKeyNight == 4 && kF10) return true;
	if (iKeyNight == 5 && kF11) return true;
	if (iKeyNight == 6 && kF12) return true;

	else return false;
}
	
	// DOF
float3 AccentuateWhites(float3 fragment)
	{
		// apply small tow to the incoming fragment, so the whitepoint gets slightly lower than max.
		// De-tonemap color (reinhard). Thanks Marty :) 
		fragment = pow(abs(fragment), HighlightGammaFactor);
		return fragment / max((1.001 - (HighlightBoost * fragment)), 0.001);
	}
	
	float3 CorrectForWhiteAccentuation(float3 fragment)
	{
		// Re-tonemap color (reinhard). Thanks Marty :) 
		float3 toReturn = fragment / (1.001 + (HighlightBoost * fragment));
		return pow(abs(toReturn), 1.0/ HighlightGammaFactor);
	}
	
	// returns 2 vectors, (x,y) are up vector, (z,w) are right vector. 
	// In: pixelVector which is the current pixel converted into a vector where (0,0) is the center of the screen.
	float4 CalculateAnamorphicFactor(float2 pixelVector)
	{
		float HighlightAnamorphicFactor;
		if (iAnamorphic > 0) HighlightAnamorphicFactor = 0.2;
		else HighlightAnamorphicFactor = 1.0f;
		
		float normalizedFactor = lerp(1, HighlightAnamorphicFactor, lerp(length(pixelVector * 2), 1, HighlightAnamorphicSpreadFactor));
		return float4(0, 1 + (1-normalizedFactor), normalizedFactor, 0);
	}
	
	// Calculates a rotation matrix for the current pixel specified in texcoord, which can be used to rotate the bokeh shape to match
	// a distored field around the center of the screen: it rotates the anamorphic factors with this matrix so the bokeh shapes form a circle
	// around the center of the screen. 
	float2x2 CalculateAnamorphicRotationMatrix(float2 texcoord)
	{
		float2 pixelVector = normalize(texcoord - 0.5);
		float limiter = (1-HighlightAnamorphicAlignmentFactor)/2;
		pixelVector.y = clamp(pixelVector.y, -limiter, limiter);
		float2 refVector = normalize(float2(-0.5, 0));
		float2 sincosFactor = float2(0,0);
		// calculate the angle between the pixelvector and the ref vector and grab the sin/cos for that angle for the rotation matrix.
		sincos(atan2(pixelVector.y, pixelVector.x) - atan2(refVector.y, refVector.x), sincosFactor.x, sincosFactor.y);
		return float2x2(sincosFactor.y, sincosFactor.x, -sincosFactor.x, sincosFactor.y);
	}
	
	float2 MorphPointOffsetWithAnamorphicDeltas(float2 pointOffset, float4 anamorphicFactors, float2x2 anamorphicRotationMatrix)
	{
		pointOffset.x = pointOffset.x * anamorphicFactors.x + pointOffset.x*anamorphicFactors.z;
		pointOffset.y = pointOffset.y * anamorphicFactors.y + pointOffset.y*anamorphicFactors.w;
		return mul(pointOffset, anamorphicRotationMatrix);
	}
	
	// Gathers min CoC from a horizontal range of pixels around the pixel at texcoord, for a range of -TILE_SIZE+1 to +TILE_SIZE+1.
	// returns minCoC
	float PerformTileGatherHorizontal(sampler source, float2 texcoord)
	{
		float tileSize = TILE_SIZE * (BUFFER_SCREEN_SIZE.x / GROUND_TRUTH_SCREEN_WIDTH);
		float minCoC = 10;
		float coc;
		float2 coordOffset = float2(BUFFER_PIXEL_SIZE.x, 0);
		for(float i = 0; i <= tileSize; ++i) 
		{
			coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
			minCoC = min(minCoC, coc);
			coc = tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).r;
			minCoC = min(minCoC, coc);
			coordOffset.x+=BUFFER_PIXEL_SIZE.x;
		}
		return minCoC;
	}

	// Gathers min CoC from a vertical range of pixels around the pixel at texcoord from the high-res focus plane, for a range of -TILE_SIZE+1 to +TILE_SIZE+1.
	// returns min CoC
	float PerformTileGatherVertical(sampler source, float2 texcoord)
	{
		float tileSize = TILE_SIZE * (BUFFER_SCREEN_SIZE.y / GROUND_TRUTH_SCREEN_HEIGHT);
		float minCoC = 10;
		float coc;
		float2 coordOffset = float2(0, BUFFER_PIXEL_SIZE.y);
		for(float i = 0; i <= tileSize; ++i) 
		{
			coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
			minCoC = min(minCoC, coc);
			coc = tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).r;
			minCoC = min(minCoC, coc);
			coordOffset.y+=BUFFER_PIXEL_SIZE.y;
		}
		return minCoC;
	}
	
	// Gathers the min CoC of the tile at texcoord and the 8 tiles around it. 
	float PerformNeighborTileGather(sampler source, float2 texcoord)
	{
		float minCoC = 10;
		float tileSizeX = TILE_SIZE * (BUFFER_SCREEN_SIZE.x / GROUND_TRUTH_SCREEN_WIDTH);
		float tileSizeY = TILE_SIZE * (BUFFER_SCREEN_SIZE.y / GROUND_TRUTH_SCREEN_HEIGHT);
		// tile is TILE_SIZE*2+1 wide. So add that and substract that to get to neighbor tile right/left.
		// 3x3 around center.
		float2 baseCoordOffset = float2(BUFFER_PIXEL_SIZE.x * (tileSizeX*2+1), BUFFER_PIXEL_SIZE.x * (tileSizeY*2+1));
		for(float i=-1;i<2;i++)
		{
			for(float j=-1;j<2;j++)
			{
				float2 coordOffset = float2(baseCoordOffset.x * i, baseCoordOffset.y * j);
				float coc = tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).r;
				minCoC = min(minCoC, coc);
			}
		}
		return minCoC;
	}

	// Calculates an RGBA fragment based on the CoC radius specified, for debugging purposes.
	// In: 	radius, the CoC radius to calculate the fragment for
	//		showInFocus, flag which will give a blue edge at the focus plane if true
	// Out:	RGBA fragment for color buffer based on the radius specified. 
	float4 GetDebugFragment(float radius, bool showInFocus)
	{
		float4 toReturn = (radius/2 <= length(BUFFER_PIXEL_SIZE)) && showInFocus ? float4(0.0, 0.0, 1.0, 1.0) : float4(radius, radius, radius, 1.0);
		if(radius < 0)
		{
			toReturn = float4(-radius, 0, 0, 1);
		}
		return toReturn;
	}
	
	// Gets the tap from the shape pointed at with the shapeSampler specified, over the angle specified, from the distance of the center in shapeRingDistance
	// Returns in rgb the shape sample, and in a the luma.
	float4 GetShapeTap(float angle, float shapeRingDistance, sampler2D shapeSampler)
	{
		float2 pointOffsetForShape = float2(0,0);
		
		// we have to add 270 degrees to the custom angle, because it's scatter via gather, so a pixel that has to show the top of our shape is *above*
		// the highlight, and the angle has to be 270 degrees to hit it (as sampling the highlight *below it* is what makes it brighter).
		sincos(angle + (6.28318530717958 * HighlightShapeRotationAngle) + (6.28318530717958 * 0.75f), pointOffsetForShape.x, pointOffsetForShape.y);
		pointOffsetForShape.y*=-1.0f;
		float4 shapeTapCoords = float4((shapeRingDistance * pointOffsetForShape) + 0.5f, 0, 0);	// shapeRingDistance is [0, 0.5] so no need to multiply with 0.5 again
		float4 shapeTap = tex2Dlod(shapeSampler, shapeTapCoords);
		shapeTap.a = dot(shapeTap.rgb, float3(0.3, 0.59, 0.11));
		return shapeTap;
	}

	// Calculates the blur disc size for the pixel at the texcoord specified. A blur disc is the CoC size at the image plane.
	// In:	VSFOCUSINFO struct filled by the vertex shader VS_Focus
	// Out:	The blur disc size for the pixel at texcoord. Format: near plane: < 0. In-focus: 0. Far plane: > 0. Range: [-1, 1].
	float CalculateBlurDiscSize(VSFOCUSINFO focusInfo)
	{
		float pixelDepth = ReShade::GetLinearizedDepth(focusInfo.texcoord);
		float pixelDepthInM = pixelDepth * 1000.0;			// in meter
		
		float SENSOR_SIZE;
		if(fSensorSize == 2) SENSOR_SIZE = 0.024/3.0;
		else if (fSensorSize == 1) SENSOR_SIZE = 0.024/2.0;
		else SENSOR_SIZE = 0.024;
		
		// CoC (blur disc size) calculation based on [Lee2008]
		// CoC = ((EF / Zf - F) * (abs(Z-Zf) / Z)
		// where E is aperture size in mm, F is focal length in mm, Zf is depth of focal plane in mm, Z is depth of pixel in mm.
		// To calculate aperture in mm, we use D = F/N, where F is focal length and N is f-number
		// For the people getting confused: 
		// Remember element sizes are in mm, our depth sizes are in meter, so we have to divide S1 by 1000 to get from meter -> mm. We don't have to
		// divide the elements in the 'abs(x-S1)/x' part, as the 1000.0 will then simply be muted out (as  a / (x/1000) == a * (1000/x))
		// formula: (((f*f) / N) / ((S1/1000.0) -f)) * (abs(x - S1) / x)
		// where f = FocalLength, N = FNumber, S1 = focusInfo.focusDepthInM, x = pixelDepthInM. In-lined to save on registers. 
		float cocInMM = (((FocalLength*FocalLength) / FNumber) / ((focusInfo.focusDepthInM/1000.0) -FocalLength)) * 
						(abs(pixelDepthInM - focusInfo.focusDepthInM) / (pixelDepthInM + (pixelDepthInM==0)));
		float toReturn = clamp(saturate(abs(cocInMM) * SENSOR_SIZE), 0, 1); // divide by sensor size to get coc in % of screen (or better: in sampler units)
		return (pixelDepth < focusInfo.focusDepth) ? -toReturn : toReturn;
	}
	
	// calculate the sample weight based on the values specified. 
	float CalculateSampleWeight(float sampleRadiusInCoC, float ringDistanceInCoC)
	{
		return  saturate(sampleRadiusInCoC - ringDistanceInCoC + 0.5);
	}
	
	
	// Same as PerformDiscBlur but this time for the near plane. It's in a separate function to avoid a lot of if/switch statements as
	// the near plane blur requires different semantics.
	// Based on [Nilsson2012] and a variant of [Jimenez2014] where far/in-focus pixels are receiving a higher weight so they bleed into the near plane, 
	// In:	blurInfo, the pre-calculated disc blur information from the vertex shader.
	// 		source, the source to read RGBA fragments from. Luma in alpha
	//		shape, the shape sampler to use if shapes are used.
	// Out: RGBA fragment for the pixel at texcoord in source, which is the blurred variant of it if it's in the near plane. A is alpha
	// to blend with.
	float4 PerformNearPlaneDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source, sampler2D shapeSampler)
	{
		float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
		// r contains blurred CoC, g contains original CoC. Original is negative.
		float2 fragmentRadii = tex2Dlod(SamplerCDCoCBlurred, float4(blurInfo.texcoord, 0, 0)).rg;
		float fragmentRadiusToUse = fragmentRadii.r;

		if(fragmentRadii.r <=0)
		{
			// the blurred CoC value is still 0, we'll never end up with a pixel that has a different value than fragment, so abort now by
			// returning the fragment we already read.
			fragment.a = 0;
			return fragment;
		}
		
		// use one extra ring as undersampling is really prominent in near-camera objects.
		float numberOfRings = max(blurInfo.numberOfRings, 1) + 1;
		float pointsFirstRing = 7;
		// luma is stored in alpha
		float bokehBusyFactorToUse = saturate(1.0-BokehBusyFactor);		// use the busy factor as an edge bias on the blur, not the highlights
		float4 average = float4(fragment.rgb * fragmentRadiusToUse * bokehBusyFactorToUse, bokehBusyFactorToUse);
		float2 pointOffset = float2(0,0);
		float nearPlaneBlurInPixels = blurInfo.nearPlaneMaxBlurInPixels * fragmentRadiusToUse;
		float2 ringRadiusDeltaCoords = BUFFER_PIXEL_SIZE * (nearPlaneBlurInPixels / (numberOfRings-1));
		float pointsOnRing = pointsFirstRing;
		float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
		float4 anamorphicFactors = CalculateAnamorphicFactor(blurInfo.texcoord - 0.5); // xy are up vector, zw are right vector
		float2x2 anamorphicRotationMatrix = CalculateAnamorphicRotationMatrix(blurInfo.texcoord);
		bool useShape = HighlightShape > 0;
		float4 shapeTap = float4(1.0f, 1.0f, 1.0f, 1.0f);
		for(float ringIndex = 0; ringIndex < numberOfRings; ringIndex++)
		{
			float anglePerPoint = 6.28318530717958 / pointsOnRing;
			float angle = anglePerPoint;
			// no further weight needed, bleed all you want. 
			float weight = lerp(ringIndex/numberOfRings, 1, smoothstep(0, 1, bokehBusyFactorToUse));
			float shapeRingDistance = ((ringIndex+1)/numberOfRings) * 0.5f;
			for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
			{
				sincos(angle, pointOffset.y, pointOffset.x);
				// shapeLuma is in Alpha
				shapeTap = useShape ? GetShapeTap(angle, shapeRingDistance, shapeSampler) : shapeTap;
				// now transform the offset vector with the anamorphic factors and rotate it accordingly to the rotation matrix, so we get a nice
				// bending around the center of the screen.
				pointOffset = useShape ? pointOffset : MorphPointOffsetWithAnamorphicDeltas(pointOffset, anamorphicFactors, anamorphicRotationMatrix);
				float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
				float4 tap = tex2Dlod(source, tapCoords);
				tap.rgb *= useShape ? (shapeTap.rgb * HighlightShapeGamma) : 1.0f;
				// r contains blurred CoC, g contains original CoC. Original can be negative
				float2 sampleRadii = tex2Dlod(SamplerCDCoCBlurred, tapCoords).rg;
				float blurredSampleRadius = sampleRadii.r;
				float sampleWeight = weight * (shapeTap.a > 0.01 ? 1.0f : 0.0f);
				average.rgb += tap.rgb * sampleWeight;
				average.w += sampleWeight ;
				angle+=anglePerPoint;
			}
			pointsOnRing+=pointsFirstRing;
			currentRingRadiusCoords += ringRadiusDeltaCoords;
		}
		
		average.rgb/=(average.w + (average.w ==0));
		float alpha = saturate((min(2.5, NearPlaneMaxBlur) + 0.4) * (fragmentRadiusToUse > 0.1 ? (fragmentRadii.g <=0 ? 2 : 1) * fragmentRadiusToUse : max(fragmentRadiusToUse, -fragmentRadii.g)));
		fragment.rgb = average.rgb;
		fragment.a = alpha;
#if CD_DEBUG
		if(ShowNearPlaneAlpha)
		{
			fragment = float4(alpha, alpha, alpha, 1.0);
		}
#endif
#if CD_DEBUG
		if(ShowNearPlaneBlurred)
		{
			fragment.a = 1.0;
		}
#endif
		return fragment;
	}


	// Calculates the new RGBA fragment for a pixel at texcoord in source using a disc based blur technique described in [Jimenez2014] 
	// (Though without using tiles). Blurs far plane.
	// In:	blurInfo, the pre-calculated disc blur information from the vertex shader.
	// 		source, the source buffer to read RGBA data from. RGB is in HDR. A not used.
	//		shape, the shape sampler to use if shapes are used.
	// Out: RGBA fragment that's the result of the disc-blur on the pixel at texcoord in source. A contains luma of pixel.
	float4 PerformDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source, sampler2D shapeSampler)
	{
		const float pointsFirstRing = 7; 	// each ring has a multiple of this value of sample points. 
		float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
		float fragmentRadius = tex2Dlod(SamplerCDCoC, float4(blurInfo.texcoord, 0, 0)).r;
		// we'll not process near plane fragments as they're processed in a separate pass. 
		if(fragmentRadius < 0 || blurInfo.farPlaneMaxBlurInPixels <=0)
		{
			// near plane fragment, will be done in near plane pass 
			return fragment;
		}
		float bokehBusyFactorToUse = saturate(1.0-BokehBusyFactor);		// use the busy factor as an edge bias on the blur, not the highlights
		float4 average = float4(fragment.rgb * fragmentRadius * bokehBusyFactorToUse, bokehBusyFactorToUse);
		float2 pointOffset = float2(0,0);
		float2 ringRadiusDeltaCoords =  (BUFFER_PIXEL_SIZE * blurInfo.farPlaneMaxBlurInPixels * fragmentRadius) / blurInfo.numberOfRings;
		float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
		float cocPerRing = (fragmentRadius * FarPlaneMaxBlur) / blurInfo.numberOfRings;
		float pointsOnRing = pointsFirstRing;
		float4 anamorphicFactors = CalculateAnamorphicFactor(blurInfo.texcoord - 0.5); // xy are up vector, zw are right vector
		float2x2 anamorphicRotationMatrix = CalculateAnamorphicRotationMatrix(blurInfo.texcoord);
		bool useShape = HighlightShape > 0;
		float4 shapeTap = float4(1.0f, 1.0f, 1.0f, 1.0f);
		for(float ringIndex = 0; ringIndex < blurInfo.numberOfRings; ringIndex++)
		{
			float anglePerPoint = 6.28318530717958 / pointsOnRing;
			float angle = anglePerPoint;
			float ringWeight = lerp(ringIndex/blurInfo.numberOfRings, 1, bokehBusyFactorToUse);
			float ringDistance = cocPerRing * ringIndex;
			float shapeRingDistance = ((ringIndex+1)/blurInfo.numberOfRings) * 0.5f;
			for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
			{
				sincos(angle, pointOffset.y, pointOffset.x);
				// shapeLuma is in Alpha
				shapeTap = useShape ? GetShapeTap(angle, shapeRingDistance, shapeSampler) : shapeTap;
				// now transform the offset vector with the anamorphic factors and rotate it accordingly to the rotation matrix, so we get a nice
				// bending around the center of the screen.
				pointOffset = useShape ? pointOffset : MorphPointOffsetWithAnamorphicDeltas(pointOffset, anamorphicFactors, anamorphicRotationMatrix);
				float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
				float sampleRadius = tex2Dlod(SamplerCDCoC, tapCoords).r;
				float weight = (sampleRadius >=0) * ringWeight * CalculateSampleWeight(sampleRadius * FarPlaneMaxBlur, ringDistance) * (shapeTap.a > 0.01 ? 1.0f : 0.0f);
				float4 tap = tex2Dlod(source, tapCoords);
				tap.rgb *= useShape ? (shapeTap.rgb * HighlightShapeGamma) : 1.0f;
				average.rgb += tap.rgb * weight;
				average.w += weight;
				angle+=anglePerPoint;
			}
			pointsOnRing+=pointsFirstRing;
			currentRingRadiusCoords += ringRadiusDeltaCoords;
		}
		fragment.rgb = average.rgb / (average.w + (average.w==0));
		return fragment;
	}


	// Performs a small blur to the out of focus areas using a lower amount of rings. Additionally it calculates the luma of the fragment into alpha
	// and makes sure the fragment post-blur has the maximum luminosity from the taken samples to preserve harder edges on highlights. 
	// In:	blurInfo, the pre-calculated disc blur information from the vertex shader.
	// 		source, the source buffer to read RGBA data from
	// Out: RGBA fragment that's the result of the disc-blur on the pixel at texcoord in source. A contains luma of RGB.
	float4 PerformPreDiscBlur(VSDISCBLURINFO blurInfo, sampler2D source)
	{
		const float radiusFactor = 1.0/max(blurInfo.numberOfRings, 1);
		const float pointsFirstRing = max(blurInfo.numberOfRings-3, 2); 	// each ring has a multiple of this value of sample points. 
		
		float4 fragment = tex2Dlod(source, float4(blurInfo.texcoord, 0, 0));
		fragment.rgb = AccentuateWhites(fragment.rgb);
		if(!MitigateUndersampling)
		{
			// early out as we don't need this step
			return fragment;
		}

		float signedFragmentRadius = tex2Dlod(SamplerCDCoC, float4(blurInfo.texcoord, 0, 0)).x * radiusFactor;
		float absoluteFragmentRadius = abs(signedFragmentRadius);
		bool isNearPlaneFragment = signedFragmentRadius < 0;
		float blurFactorToUse = isNearPlaneFragment ? NearPlaneMaxBlur : FarPlaneMaxBlur;
		// Substract 2 as we blur on a smaller range. Don't limit the rings based on radius here, as that will kill the pre-blur.
		float numberOfRings = max(blurInfo.numberOfRings-2, 1);
		float4 average = absoluteFragmentRadius == 0 ? fragment : float4(fragment.rgb * absoluteFragmentRadius, absoluteFragmentRadius);
		float2 pointOffset = float2(0,0);
		// pre blur blurs near plane fragments with near plane samples and far plane fragments with far plane samples [Jimenez2014].
		float2 ringRadiusDeltaCoords = BUFFER_PIXEL_SIZE 
												* ((isNearPlaneFragment ? blurInfo.nearPlaneMaxBlurInPixels : blurInfo.farPlaneMaxBlurInPixels) *  absoluteFragmentRadius) 
												* rcp((numberOfRings-1) + (numberOfRings==1));
		float pointsOnRing = pointsFirstRing;
		float2 currentRingRadiusCoords = ringRadiusDeltaCoords;
		float cocPerRing = (signedFragmentRadius * blurFactorToUse) / numberOfRings;
		for(float ringIndex = 0; ringIndex < numberOfRings; ringIndex++)
		{
			float anglePerPoint = 6.28318530717958 / pointsOnRing;
			float angle = anglePerPoint;
			float ringDistance = cocPerRing * ringIndex;
			for(float pointNumber = 0; pointNumber < pointsOnRing; pointNumber++)
			{
				sincos(angle, pointOffset.y, pointOffset.x);
				float4 tapCoords = float4(blurInfo.texcoord + (pointOffset * currentRingRadiusCoords), 0, 0);
				float signedSampleRadius = tex2Dlod(SamplerCDCoC, tapCoords).x * radiusFactor;
				float absoluteSampleRadius = abs(signedSampleRadius);
				float isSamePlaneAsFragment = ((signedSampleRadius > 0 && !isNearPlaneFragment) || (signedSampleRadius <= 0 && isNearPlaneFragment));
				float weight = CalculateSampleWeight(absoluteSampleRadius * blurFactorToUse, ringDistance) * isSamePlaneAsFragment * 
								(absoluteFragmentRadius - absoluteSampleRadius < 0.001);
				float3 tap = tex2Dlod(source, tapCoords).rgb;
				average.rgb += AccentuateWhites(tap.rgb) * weight;
				average.w += weight;
				angle+=anglePerPoint;
			}
			pointsOnRing+=pointsFirstRing;
			currentRingRadiusCoords += ringRadiusDeltaCoords;
		}
		fragment.rgb = average.rgb/(average.w + (average.w==0));
		return fragment;
	}

	
	// Function to obtain the blur disc radius from the source sampler specified and optionally flatten it to zero. Used to blur the blur disc radii using a 
	// separated gaussian blur function.
	// In:	source, the source to read the blur disc radius value to process from
	//		texcoord, the coordinate of the pixel which blur disc radius value we have to process
	//		flattenToZero, flag which if true will make this function convert a blur disc radius value bigger than 0 to 0. 
	//		Radii bigger than 0 are in the far plane and we only want near plane radii in our blurred buffer.
	// Out: processed blur disc radius for the pixel at texcoord in source.
	float GetBlurDiscRadiusFromSource(sampler2D source, float2 texcoord, bool flattenToZero)
	{
		float coc = tex2Dlod(source, float4(texcoord, 0, 0)).r;
		// we're only interested in negative coc's (near plane). All coc's in focus/far plane are flattened to 0. Return the
		// absolute value of the coc as we're working with positive blurred CoCs (as the sign is no longer needed)
		return (flattenToZero && coc >= 0) ? 0 : abs(coc);
	}

	// Performs a single value gaussian blur pass in 1 direction (18 taps). Based on Ioxa's Gaussian blur shader. Used for near plane CoC blur.
	// Used on tiles so not expensive.
	// In:	source, the source sampler to read blur disc radius values to blur from
	//		texcoord, the coordinate of the pixel to blur the blur disc radius for
	// 		offsetWeight, a weight to multiple the coordinate with, containing typically the x or y value of the pixel size
	//		flattenToZero, a flag to pass on to the actual blur disc radius read function to make sure in this pass the positive values are squashed to 0.
	// 					   This flag is needed as the gaussian blur is used separably here so the second pass should not look for positive blur disc radii
	//					   as all values are already positive (due to the first pass).
	// Out: the blurred value for the blur disc radius of the pixel at texcoord. Greater than 0 if the original CoC is in the near plane, 0 otherwise.
	float PerformSingleValueGaussianBlur(sampler2D source, float2 texcoord, float2 offsetWeight, bool flattenToZero)
	{
		float offset[18] = { 0.0, 1.4953705027, 3.4891992113, 5.4830312105, 7.4768683759, 9.4707125766, 11.4645656736, 13.4584295168, 15.4523059431, 17.4461967743, 19.4661974725, 21.4627427973, 23.4592916956, 25.455844494, 27.4524015179, 29.4489630909, 31.445529535, 33.4421011704 };
		float weight[18] = { 0.033245, 0.0659162217, 0.0636705814, 0.0598194658, 0.0546642566, 0.0485871646, 0.0420045997, 0.0353207015, 0.0288880982, 0.0229808311, 0.0177815511, 0.013382297, 0.0097960001, 0.0069746748, 0.0048301008, 0.0032534598, 0.0021315311, 0.0013582974 };

		float coc = GetBlurDiscRadiusFromSource(source, texcoord, flattenToZero);
		coc *= weight[0];
		
		float2 factorToUse = offsetWeight * NearPlaneMaxBlur * 0.8f;
		for(int i = 1; i < 18; ++i)
		{
			float2 coordOffset = factorToUse * offset[i];
			float weightSample = weight[i];
			coc += GetBlurDiscRadiusFromSource(source, texcoord + coordOffset, flattenToZero) * weightSample;
			coc += GetBlurDiscRadiusFromSource(source, texcoord - coordOffset, flattenToZero) * weightSample;
		}
		
		return saturate(coc);
	}

	// Performs a full fragment (RGBA) gaussian blur pass in 1 direction (16 taps). Based on Ioxa's Gaussian blur shader.
	// Will skip any pixels which are in-focus. It will also apply the pixel's blur disc radius to further limit the blur range for near-focused pixels.
	// In:	source, the source sampler to read RGBA values to blur from
	//		texcoord, the coordinate of the pixel to blur. 
	// 		offsetWeight, a weight to multiple the coordinate with, containing typically the x or y value of the pixel size
	// Out: the blurred fragment(RGBA) for the pixel at texcoord. 
	float4 PerformFullFragmentGaussianBlur(sampler2D source, float2 texcoord, float2 offsetWeight)
	{
		float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
		float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
		const float3 lumaDotWeight = float3(0.3, 0.59, 0.11);
		
		float coc = tex2Dlod(SamplerCDCoC, float4(texcoord, 0, 0)).r;
		float4 fragment = tex2Dlod(source, float4(texcoord, 0, 0));
		float fragmentLuma = dot(fragment.rgb, lumaDotWeight);
		float4 originalFragment = fragment;
		float absoluteCoC = abs(coc);
		float lengthPixelSize = length(BUFFER_PIXEL_SIZE);
		if(absoluteCoC < 0.2 || PostBlurSmoothing < 0.01 || fragmentLuma < 0.3)
		{
			// in focus or postblur smoothing isn't enabled or not really a highlight, ignore
			return fragment;
		}
		fragment.rgb *= weight[0];
		float2 factorToUse = offsetWeight * PostBlurSmoothing;
		for(int i = 1; i < 6; ++i)
		{
			float2 coordOffset = factorToUse * offset[i];
			float weightSample = weight[i];
			float sampleCoC = tex2Dlod(SamplerCDCoC, float4(texcoord + coordOffset, 0, 0)).r;
			float maskFactor = abs(sampleCoC) < 0.2;		// mask factor to avoid near/in focus bleed.
			fragment.rgb += (originalFragment.rgb * maskFactor * weightSample) + 
							(tex2Dlod(source, float4(texcoord + coordOffset, 0, 0)).rgb * (1-maskFactor) * weightSample);
			sampleCoC = tex2Dlod(SamplerCDCoC, float4(texcoord - coordOffset, 0, 0)).r;
			maskFactor = abs(sampleCoC) < 0.2;
			fragment.rgb += (originalFragment.rgb * maskFactor * weightSample) + 
							(tex2Dlod(source, float4(texcoord - coordOffset, 0, 0)).rgb * (1-maskFactor) * weightSample);
		}
		return saturate(fragment);
	}

	// Functions which fills the passed in struct with focus data. This code is factored out to be able to call it either from a vertex shader
	// (in d3d10+) or from a pixel shader (d3d9) to work around compilation issues in reshade.
	void FillFocusInfoData(inout VSFOCUSINFO toFill)
	{
		// Reshade depth buffer ranges from 0.0->1.0, where 1.0 is 1000 in world units. All camera element sizes are in mm, so we state 1 in world units is 
		// 1 meter. This means to calculate from the linearized depth buffer value to meter we have to multiply by 1000.
		// Manual focus value is already in meter (well, sort of. This differs per game so we silently assume it's meter), so we first divide it by
		// 1000 to make it equal to a depth value read from the depth linearized depth buffer.
		// Read from sampler on current focus which is a 1x1 texture filled with the actual depth value of the focus point to use.
		toFill.focusDepth = tex2Dlod(SamplerCDCurrentFocus, float4(0, 0, 0, 0)).r;
		toFill.focusDepthInM = toFill.focusDepth * 1000.0; 		// km to m
		toFill.focusDepthInMM = toFill.focusDepthInM * 1000.0; 	// m to mm
		toFill.pixelSizeLength = length(BUFFER_PIXEL_SIZE);
		
		float SENSOR_SIZE;
		if(fSensorSize == 2) SENSOR_SIZE = 0.024/3.0;
		else if (fSensorSize == 1) SENSOR_SIZE = 0.024/2.0;
		else SENSOR_SIZE = 0.024;
		
		// HyperFocal calculation, see https://photo.stackexchange.com/a/33898. Useful to calculate the edges of the depth of field area
		float hyperFocal = (FocalLength * FocalLength) / (FNumber * SENSOR_SIZE);
		float hyperFocalFocusDepthFocus = (hyperFocal * toFill.focusDepthInMM);
		toFill.nearPlaneInMM = (hyperFocalFocusDepthFocus / (hyperFocal + (toFill.focusDepthInMM - FocalLength)));	// in mm
		toFill.farPlaneInMM = hyperFocalFocusDepthFocus / (hyperFocal - (toFill.focusDepthInMM - FocalLength));		// in mm
	}

	// From: https://www.shadertoy.com/view/4lfGDs
	// Adjusted for dof usage. Returns in a the # of taps accepted: a tap is accepted if it has a coc in the same plane as center.
	float4 SharpeningPass_BlurSample(in sampler2D source, in float2 texcoord, in float2 xoff, in float2 yoff, in float centerCoC, inout float3 minv, inout float3 maxv)
	{
		float3 v11 = tex2D(source, texcoord + xoff).rgb;
		float3 v12 = tex2D(source, texcoord + yoff).rgb;
		float3 v21 = tex2D(source, texcoord - xoff).rgb;
		float3 v22 = tex2D(source, texcoord - yoff).rgb;
		float3 center = tex2D(source, texcoord).rgb;
		
		float v11CoC = tex2D(SamplerCDCoC, texcoord + xoff).r;
		float v12CoC = tex2D(SamplerCDCoC, texcoord + yoff).r;
		float v21CoC = tex2D(SamplerCDCoC, texcoord - xoff).r;
		float v22CoC = tex2D(SamplerCDCoC, texcoord - yoff).r;
		float accepted = sign(centerCoC)==sign(v11CoC)? 1.0f: 0.0f;
		accepted+= sign(centerCoC)==sign(v12CoC)? 1.0f: 0.0f;
		accepted+= sign(centerCoC)==sign(v21CoC)? 1.0f: 0.0f;
		accepted+= sign(centerCoC)==sign(v22CoC)? 1.0f: 0.0f;
	
		// keep track of min/max for clamping later on so we don't get dark halos.
		minv = min(minv, v11);
		minv = min(minv, v12);
		minv = min(minv, v21);
		minv = min(minv, v22);
	
		maxv = max(maxv, v11);
		maxv = max(maxv, v12);
		maxv = max(maxv, v21);
		maxv = max(maxv, v22);
		return float4((v11 + v12 + v21 + v22 + 2.0 * center) * 0.166667, accepted);
	}

	// From: https://www.shadertoy.com/view/4lfGDs
	// Adjusted for dof usage. Returns in a the # of taps accepted: a tap is accepted if it has a coc in the same plane as center.
	float3 SharpeningPass_EdgeStrength(in float3 fragment, in sampler2D source, in float2 texcoord, in float sharpeningFactor)
	{
		const float spread = 0.5;
		float2 offset = float2(1.0, 1.0) / BUFFER_SCREEN_SIZE.xy;
		float2 up    = float2(0.0, offset.y) * spread;
		float2 right = float2(offset.x, 0.0) * spread;

		float3 minv = 1000000000;
		float3 maxv = 0;

		float centerCoC = tex2D(SamplerCDCoC, texcoord).r;
		float4 v12 = SharpeningPass_BlurSample(source, texcoord + up, 			right, up, centerCoC, minv, maxv);
		float4 v21 = SharpeningPass_BlurSample(source, texcoord - right, 		right, up, centerCoC, minv, maxv);
		float4 v22 = SharpeningPass_BlurSample(source, texcoord, 				right, up, centerCoC, minv, maxv);
		float4 v23 = SharpeningPass_BlurSample(source, texcoord + right, 		right, up, centerCoC, minv, maxv);
		float4 v32 = SharpeningPass_BlurSample(source, texcoord - up, 			right, up, centerCoC, minv, maxv);
		// rest of the pixels aren't used
		float accepted = v12.a + v21.a + v23.a + v32.a;
		if(accepted < 15.5)
		{
			// contains rejected tap, reject the entire operation. This is ok, as it's not necessary for the final pixel color.
			return fragment;
		}
		// all pixels accepted, calculated edge strength.
		float3 laplacian_of_g = v12.rgb + v21.rgb + v22.rgb * -4.0 + v23.rgb + v32.rgb;
		return clamp(fragment - laplacian_of_g.rgb * sharpeningFactor, minv, maxv);
	}

// TONEMAPPING 
float3 Blur(float2 uv, float d){
	float t = (sin(iTime*5.0+uv.y*5.0))/10.0;
    float b = 1.0;
    t=0.0;
    float2 PixelOffset=float2(d+.0005*t,0);
    
    float Start = 2.0 / 14.0;
    float2 Scale = 0.66 * 4.0 * 2.0 * PixelOffset.xy;
    
    float3 N0 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 0.0) * Scale).rgb;
    float3 N1 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 1.0) * Scale).rgb;
    float3 N2 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 2.0) * Scale).rgb;
    float3 N3 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 3.0) * Scale).rgb;
    float3 N4 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 4.0) * Scale).rgb;
    float3 N5 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 5.0) * Scale).rgb;
    float3 N6 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 6.0) * Scale).rgb;
    float3 N7 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 7.0) * Scale).rgb;
    float3 N8 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 8.0) * Scale).rgb;
    float3 N9 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 9.0) * Scale).rgb;
    float3 N10 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 10.0) * Scale).rgb;
    float3 N11 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 11.0) * Scale).rgb;
    float3 N12 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 12.0) * Scale).rgb;
    float3 N13 = tex2D(ReShade::BackBuffer, uv + Circle(Start, 14.0, 13.0) * Scale).rgb;
    float3 N14 = tex2D(ReShade::BackBuffer, uv).rgb;
    
	float4 clr = tex2D(ReShade::BackBuffer, uv);
    float W = 1.0 / 15.0;
    
    clr.rgb= 
		(N0 * W) +
		(N1 * W) +
		(N2 * W) +
		(N3 * W) +
		(N4 * W) +
		(N5 * W) +
		(N6 * W) +
		(N7 * W) +
		(N8 * W) +
		(N9 * W) +
		(N10 * W) +
		(N11 * W) +
		(N12 * W) +
		(N13 * W) +
		(N14 * W);
    return  float3(clr.xyz)*b;
}

float onOff(float a, float b, float c, float fc)
{
	return step(c, sin((fc * 0.001) + a*cos((fc * 0.001)*b)));
}


int2 toLut2D(int3 lut3D)
{
	return int2(lut3D.x+lut3D.z, lut3D.y);
}

/// white balance
float3 interpolate( float3 o, float3 n, float factor, float ft )
    {
        return lerp( o.xyz, n.xyz, 1.0f - exp( -factor * ft ));
    }

float3 ACESFitted(float3 color)
{
	
	color = mul(ACESInputMat, color);

	// Apply RRT and ODT
	color = RRTAndODTFit(color);

	color = mul(ACESOutputMat, color);

	// Clamp to [0, 1]
	color = saturate(color);
	
	return color;
}

// TONEMAPPER
float get_adapt()
{
	int AdaptPrecision;
	if (AdaptMetering == 0) AdaptPrecision = 0;
	if (AdaptMetering == 1) AdaptPrecision = 4;
	if (AdaptMetering == 2) AdaptPrecision = 9;
	
	return tex2Dlod(
		Small,
		float4(AdaptFocalPoint, 0, AdaptMipLevels - AdaptPrecision)).x;
}

float3 tonemap(float3 color, float exposure)
{
	color = pow(color, 1.0/2.2);
	color = ACESFitted(color * exposure);
	color = pow(color,2.2);
	return color;
}

//DRAW CLOCK
float2 gAspect() { return float2(1024*5, -137*14); }
uint2  getID(float k, float m) { float r = floor(k/m); return float2(r, k - r*m); }

	//////////////////////////////////////////////////
	//
	// VERTEX SHADERS
	//
	//////////////////////////////////////////////////
// DOF 
// Vertex shader which is used to calculate per-frame static focus info so it's not done per pixel, but only per vertex. 
	VSFOCUSINFO VS_Focus(in uint id : SV_VertexID)
	{
		VSFOCUSINFO focusInfo;
		
		focusInfo.texcoord.x = (id == 2) ? 2.0 : 0.0;
		focusInfo.texcoord.y = (id == 1) ? 2.0 : 0.0;
		focusInfo.vpos = float4(focusInfo.texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);

#if __RENDERER__ <= 0x9300 	// doing focusing in vertex shaders in dx9 doesn't work for auto-focus, so we'll just do it in the pixel shader instead
		// fill in dummies, will be filled in pixel shader. Less fast but it is what it is...
		focusInfo.focusDepth = 0;
		focusInfo.focusDepthInM = 0;
		focusInfo.focusDepthInMM = 0;
		focusInfo.pixelSizeLength = 0;
		focusInfo.nearPlaneInMM = 0;
		focusInfo.farPlaneInMM = 0;
#else
		FillFocusInfoData(focusInfo);
#endif
		return focusInfo;
	}

	// Vertex shader which is used to calculate per-frame static info for the disc blur passes so it's not done per pixel, but only per vertex. 
	VSDISCBLURINFO VS_DiscBlur(in uint id : SV_VertexID)
	{
		VSDISCBLURINFO blurInfo;

		blurInfo.texcoord.x = (id == 2) ? 2.0 : 0.0;
		blurInfo.texcoord.y = (id == 1) ? 2.0 : 0.0;
		blurInfo.vpos = float4(blurInfo.texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
		
		blurInfo.numberOfRings = round(BlurQuality);
		float pixelSizeLength = length(BUFFER_PIXEL_SIZE);
		blurInfo.farPlaneMaxBlurInPixels = (FarPlaneMaxBlur / 100.0) / pixelSizeLength;
		blurInfo.nearPlaneMaxBlurInPixels = (NearPlaneMaxBlur / 100.0) / pixelSizeLength;
		blurInfo.cocFactorPerPixel = length(BUFFER_PIXEL_SIZE) * blurInfo.farPlaneMaxBlurInPixels;	// not needed for near plane.
		return blurInfo;
	}

// TONEMAPPER
void PostProcessVST(
	uint id : SV_VERTEXID,
	out float4 p : SV_POSITION,
	out float2 uv : TEXCOORD)
{
	uv.x = (id == 2) ? 2.0 : 0.0;
	uv.y = (id == 1) ? 2.0 : 0.0;
	p = float4(uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}

void TonemapperACESVST(uint id : SV_VERTEXID,out float4 p : SV_POSITION,out float2 uv : TEXCOORD0,out float inv_white : TEXCOORD1,out float exposure : TEXCOORD2)
{
	PostProcessVST(id, p, uv);

	if (bISNIGHT()) exposure -= 0.2;
	
	exposure = exp2(Exposure);

	float adapt = get_adapt();

	float fMin;	
	if (bUseApertureAdaptation) 
	{
		fMin = FNumber*0.1;
		fMin = clamp(fMin, 0.1, 1.0); //0.3,1.0
	}
	else fMin = 0.5f;
	
	if (bISNIGHT()) fMin = 0.75f;
	
	adapt = clamp(adapt, fMin, 50.0);
	exposure /= adapt;

	inv_white = AutoWhitePoint ? rcp(tonemap(1.0, exposure).x) : 1.0;
}

/// DRAW CLOCK
float4 vs_Clock( uint id : SV_VERTEXID, out float2 uv : TEXCOORD ) : SV_POSITION
{
	float gScaleClk;
	float2 gPosClk;
	
	if (iLogoSet == 0) return 0.0;
	else
	{
		int2 gid = getID(id, 4); //0:[0, 0], 1:[0, 1], 2:[0, 2], 3:[0, 3], 4:[1, 0], 5:[1, 1], 6:[1, 2], 7:[1, 3], 8:[2, 0]...
		int2 vid = getID(gid.y, 2); //0:[0, 0], 1:[0, 1], 2:[1, 0], 3:[1, 1]
		int2 hm  = getID(gDate.w/60, 60);
		int2 ms  = getID(gDate.w, 60);
		int2 hh  = getID(hm.x, 10) + 1;
		int2 mm  = getID(hm.y, 10) + 1;
		int2 ss  = getID(ms.y, 10) + 1;
		int2 yr  = getID((int(gDate.x))%100, 10) + 1;
		int2 yr2 = getID(int(gDate.x)/100, 10) + 1;
		int2 mo  = getID(int(gDate.y), 10) + 1;
		int2 dy  = getID(int(gDate.z), 10) + 1;

		if (iLogoSet == 1) //VHS
		{
		gScaleClk = 0.400000;
		gPosClk = float2(-0.734000,-0.590000);
		int  did[] = { hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0,0, 0, 0, 0 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		if (iLogoSet == 2) //HC
		{
		gScaleClk = 0.220000;
		gPosClk = float2(-0.030000,0.860000);
		int  did[] = { hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0,0, 0, 0, 0 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		if (iLogoSet == 3) //BCam OldGen
		{
		gScaleClk = 0.292825;
		gPosClk = float2(0.374000,0.852000);
		int  did[] = {yr2.x, yr2.y, yr.x, yr.y, 11, mo.x, mo.y, 11, dy.x, dy.y, 0,0, hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y,0, 0, 0, 0, 0, 0, 0 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		
		if (iLogoSet == 4) //BCam NewGen
		{
		gScaleClk = 0.253000;
		gPosClk = float2(0.401000,0.875000);
		int  did[] = { 0, 0, yr.x, yr.y, 11, mo.x, mo.y, 11, dy.x, dy.y, 0, hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y, 0, 13, 1, 6, 1, 1 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		
		if (iLogoSet == 5) //MotoR
		{
		gScaleClk = 0.220000;
		gPosClk = float2(-0.820000,0.945000);
		int  did[] = { yr2.x, yr2.y, yr.x, yr.y, 11, mo.x, mo.y, 11, dy.x, dy.y, 0, hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y, 0, 0, 0, 0, 0, 0 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		
		if (iLogoSet == 6) //GoPro
		{
		gScaleClk = 0.120000;
		gPosClk = float2(-0.949000,0.950000);
		int  did[] = { hh.x, hh.y, 12, mm.x, mm.y, 12, ss.x, ss.y, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0,0, 0, 0, 0 };
		uv = float2((did[gid.x] + vid.x)/14., vid.y);
		}
		
		
		float2 size = float2((1.0/BUFFER_WIDTH), (1.0/BUFFER_HEIGHT)) * gAspect() * (gScaleClk*ResModifier()) * .1;
		
		size = lerp(-size, size, float2((gid.x + (gid.y > 1.5)) / 5., uv.y));
		return float4(gPosClk + size, 0, 1);
	}
}
	
float rand(float2 co)
{
        float a = 12.9898;
        float b = 78.233;
        float c = 43758.5453;
        float dst= dot(co.xy ,float2(a,b));
        float snm= dst % 3.14; //this was broken aswell
        return frac(sin(snm) * c);
}

	//////////////////////////////////////////////////
	//
	// PIXEL SHADERS
	//
	//////////////////////////////////////////////////
// DOF 
// Pixel shader which determines the focus depth for the current frame, which will be stored in the currentfocus texture.
	void PS_DetermineCurrentFocus(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment=0.0;
		else 
		{
			#if __RESHADE_FXC__		// Freestyle
					float manualFocusPlaneValue = ManualFocusPlane * ManualFocusPlaneMaxRange;
					fragment = UseAutoFocus ? lerp(tex2D(SamplerCDPreviousFocus, float2(0, 0)).r, ReShade::GetLinearizedDepth(AutoFocusPoint), AutoFocusTransitionSpeed) 
											: (manualFocusPlaneValue / 1000);
			#else
					float2 autoFocusPointToUse = UseMouseDrivenAutoFocus ? MouseCoords * BUFFER_PIXEL_SIZE : AutoFocusPoint;
					fragment = UseAutoFocus ? lerp(tex2D(SamplerCDPreviousFocus, float2(0, 0)).r, ReShade::GetLinearizedDepth(autoFocusPointToUse), AutoFocusTransitionSpeed) 
											: (ManualFocusPlane / 1000);
			#endif
		}
	}
	
	// Pixel shader which copies the single value of the current focus texture to the previous focus texture so it's preserved for the next frame.
	void PS_CopyCurrentFocus(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
			else fragment = tex2D(SamplerCDCurrentFocus, float2(0, 0)).r;
	}
	
	// Pixel shader which produces a blur disc radius for each pixel and returns the calculated value. 
	void PS_CalculateCoCValues(VSFOCUSINFO focusInfo, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else 
		{
			#if __RENDERER__ <= 0x9300 	// doing focusing in vertex shaders in dx9 doesn't work for auto-focus, so we'll just do it in the pixel shader instead
					FillFocusInfoData(focusInfo);
			#endif
					fragment = CalculateBlurDiscSize(focusInfo);
		}
	}
	
	// Pixel shader which will perform a pre-blur on the frame buffer using a blur disc smaller than the original blur disc of the pixel. 
	// This is done to overcome the undersampling gaps we have in the main blur disc sampler [Jimenez2014].
	void PS_PreBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformPreDiscBlur(blurInfo, ReShade::BackBuffer);
	}

	// Pixel shader which performs the far plane blur pass.
	void PS_BokehBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformDiscBlur(blurInfo, SamplerCDBuffer1, SamplerCDBuffer1);

	}

	// Pixel shader which performs the near plane blur pass. Uses a blurred buffer of blur disc radii, based on a combination of [Jimenez2014] (tiles)
	// and [Nilsson2012] (blurred CoC).
	void PS_NearBokehBlur(VSDISCBLURINFO blurInfo, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformNearPlaneDiscBlur(blurInfo, SamplerCDBuffer2, SamplerCDBuffer2);

	}
	
	// Pixel shader which performs the CoC tile creation (horizontal gather of min CoC)
	void PS_CoCTile1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformTileGatherHorizontal(SamplerCDCoC, texcoord);
	}

	// Pixel shader which performs the CoC tile creation (vertical gather of min CoC)
	void PS_CoCTile2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformTileGatherVertical(SamplerCDCoCTileTmp, texcoord);
	}
	
	// Pixel shader which performs the CoC tile creation with neighbor tile info (horizontal and vertical gather of min CoC)
	void PS_CoCTileNeighbor(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformNeighborTileGather(SamplerCDCoCTile, texcoord);
	}
	
	// Pixel shader which performs the first part of the gaussian blur on the blur disc values
	void PS_CoCGaussian1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float fragment : SV_Target0)
	{
		// from source CoC to tmp1
		if (!bToggleDOF) fragment = 0.0;
		else fragment = PerformSingleValueGaussianBlur(SamplerCDCoCTileNeighbor, texcoord, 
												  float2(BUFFER_PIXEL_SIZE.x * (BUFFER_SCREEN_SIZE.x/GROUND_TRUTH_SCREEN_WIDTH), 0.0), true);
	}

	// Pixel shader which performs the second part of the gaussian blur on the blur disc values
	void PS_CoCGaussian2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float2 fragment : SV_Target0)
	{
		// from tmp1 to tmp2. Merge original CoC into g.
		if (!bToggleDOF) fragment = 0.0;
		else fragment = float2(PerformSingleValueGaussianBlur(SamplerCDCoCTmp1, texcoord, 
														 float2(0.0, BUFFER_PIXEL_SIZE.y * (BUFFER_SCREEN_SIZE.y/GROUND_TRUTH_SCREEN_HEIGHT)), false), 
						  tex2D(SamplerCDCoCTileNeighbor, texcoord).x);
	}
	
	// Pixel shader which combines 2 half-res sources to a full res output. From texCDBuffer1 & 2 to texCDBuffer4.
	void PS_Combiner(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = tex2D(ReShade::BackBuffer, texcoord);
		else 
		{
			// first blend far plane with original buffer, then near plane on top of that. 
			float4 originalFragment = tex2D(ReShade::BackBuffer, texcoord);
			originalFragment.rgb = AccentuateWhites(originalFragment.rgb);
			float4 farFragment = tex2D(SamplerCDBuffer3, texcoord);
			float4 nearFragment = tex2D(SamplerCDBuffer1, texcoord);
			float pixelCoC = tex2D(SamplerCDCoC, texcoord).r;
			// multiply with far plane max blur so if we need to have 0 blur we get full res 
			float realCoC = pixelCoC * clamp(0, 1, FarPlaneMaxBlur);
			if(HighlightSharpeningFactor > 0.0f)
			{
				// sharpen the fragments pre-combining
				float sharpeningFactor = abs(pixelCoC) * 80.0 * HighlightSharpeningFactor;		// 80 is a handpicked number, just to get high sharpening.
				farFragment.rgb = SharpeningPass_EdgeStrength(farFragment.rgb, SamplerCDBuffer3, texcoord, sharpeningFactor * realCoC);
				nearFragment.rgb = SharpeningPass_EdgeStrength(nearFragment.rgb, SamplerCDBuffer1, texcoord, sharpeningFactor * (abs(pixelCoC) * clamp(0, 1, NearPlaneMaxBlur)));
			}
			// all CoC's > 0.1 are full far fragment, below that, we're going to blend. This avoids shimmering far plane without the need of a 
			// 'magic' number to boost up the alpha.
			float blendFactor = (realCoC > 0.1) ? 1 : smoothstep(0, 1, (realCoC / 0.1));
			fragment = lerp(originalFragment, farFragment, blendFactor);
			fragment.rgb = lerp(fragment.rgb, nearFragment.rgb, nearFragment.a * (NearPlaneMaxBlur != 0));
	#if CD_DEBUG
			if(ShowOnlyFarPlaneBlurred)
			{
				fragment = farFragment;
			}
	#endif
			fragment.rgb = CorrectForWhiteAccentuation(fragment.rgb);
			fragment.a = 1.0;
		}
	}

	// Pixel shader which performs a 9 tap tentfilter on the far plane blur result. This tent filter is from the composition pass 
	// in KinoBokeh: https://github.com/keijiro/KinoBokeh/blob/master/Assets/Kino/Bokeh/Shader/Composition.cginc
	// See also [Jimenez2014] for a discussion about this filter.
	void PS_TentFilter(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = tex2D(ReShade::BackBuffer, texcoord);
		else 
		{
			float4 coord = BUFFER_PIXEL_SIZE.xyxy * float4(1, 1, -1, 0);
			float4 average;
			average = tex2D(SamplerCDBuffer2, texcoord - coord.xy);
			average += tex2D(SamplerCDBuffer2, texcoord - coord.wy) * 2;
			average += tex2D(SamplerCDBuffer2, texcoord - coord.zy);
			average += tex2D(SamplerCDBuffer2, texcoord + coord.zw) * 2;
			average += tex2D(SamplerCDBuffer2, texcoord) * 4;
			average += tex2D(SamplerCDBuffer2, texcoord + coord.xw) * 2;
			average += tex2D(SamplerCDBuffer2, texcoord + coord.zy);
			average += tex2D(SamplerCDBuffer2, texcoord + coord.wy) * 2;
			average += tex2D(SamplerCDBuffer2, texcoord + coord.xy);
			fragment = average / 16;
		}
	}


	// Pixel shader which performs the first part of the gaussian post-blur smoothing pass, to iron out undersampling issues with the disc blur
	void PS_PostSmoothing1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = tex2D(ReShade::BackBuffer, texcoord);
		else fragment = PerformFullFragmentGaussianBlur(SamplerCDBuffer4, texcoord, float2(BUFFER_PIXEL_SIZE.x, 0.0));
	}

	// Pixel shader which performs the second part of the gaussian post-blur smoothing pass, to iron out undersampling issues with the disc blur
	// It also displays the focusing overlay helpers if the mouse button is down and the user enabled ShowOutOfFocusPlaneOnMouseDown.
	// it displays the near and far plane at the hyperfocal planes (calculated in vertex shader) with the overlay color and the in-focus area in between
	// as normal. It then also blends the focus plane as a separate color to make focusing really easy. 
	void PS_PostSmoothing2AndFocusing(in VSFOCUSINFO focusInfo, out float4 fragment : SV_Target0)
	{
		if (!bToggleDOF) fragment = tex2D(ReShade::BackBuffer, focusInfo.texcoord);
		else 
		{
			if(ShowCoCValues)
			{
				fragment = GetDebugFragment(tex2D(SamplerCDCoC, focusInfo.texcoord).r, true);
				return;
			}
	#if CD_DEBUG
			if(ShowNearCoCTilesBlurredG)
			{
				fragment = GetDebugFragment(tex2D(SamplerCDCoCBlurred, focusInfo.texcoord).g, false);
				return;
			}
			if(ShowNearCoCTiles)
			{
				fragment = GetDebugFragment(tex2D(SamplerCDCoCTile, focusInfo.texcoord).r, true);
				return;
			}
			if(ShowNearCoCTilesBlurredR)
			{
				fragment = GetDebugFragment(tex2D(SamplerCDCoCBlurred, focusInfo.texcoord).r, true);
				return;
			}
			if(ShowNearCoCTilesNeighbor)
			{
				fragment = GetDebugFragment(tex2D(SamplerCDCoCTileNeighbor, focusInfo.texcoord).r, true);
				return;
			}
	#endif
			fragment = PerformFullFragmentGaussianBlur(SamplerCDBuffer5, focusInfo.texcoord, float2(0.0, BUFFER_PIXEL_SIZE.y));
			float4 originalFragment = tex2D(SamplerCDBuffer4, focusInfo.texcoord);
			// Dither
			float2 uv = float2(BUFFER_WIDTH, BUFFER_HEIGHT) / float2( 512.0f, 512.0f ); // create multiplier on texcoord so that we can use 1px size reads on gaussian noise texture (since much smaller than screen)
			uv.xy = uv.xy * focusInfo.texcoord.xy;
			float noise = tex2D(SamplerCDNoise, uv).x; // read, uv is scaled, sampler is set to tile noise texture (WRAP)
			fragment.xyz = saturate(fragment.xyz + lerp( -0.5/255.0, 0.5/255.0, noise)); // apply dither
			// End Dither
			float coc = abs(tex2Dlod(SamplerCDCoC, float4(focusInfo.texcoord, 0, 0)).r);
			fragment.rgb = lerp(originalFragment.rgb, fragment.rgb, saturate(coc < length(BUFFER_PIXEL_SIZE) ? 0 : 4 * coc));
			fragment.w = 1.0;
			
	#if __RENDERER__ <= 0x9300 	// doing focusing in vertex shaders in dx9 doesn't work for auto-focus, so we'll just do it in the pixel shader instead
			FillFocusInfoData(focusInfo);
	#endif
	#if __RESHADE_FXC__		// Freestyle
			bool ShowOutOfFocusPlaneOnMouseDown = ShowFocusingOverlay;
			bool LeftMouseDown = true;
			float3 OutOfFocusPlaneColor = float3(0.8, 0.8, 0.8);
			float3 FocusPlaneColor = float3(0.0, 0.0, 1.0);
			float OutOfFocusPlaneColorTransparency = OUT_OF_FOCUS_PLANE_COLORTRANSPARENCY;
			float4 FocusCrosshairColor = float4(1.0, 0.0, 1.0, 1.0);
	#endif
			if(ShowOutOfFocusPlaneOnMouseDown && LeftMouseDown)
			{
				float depthPixelInMM = ReShade::GetLinearizedDepth(focusInfo.texcoord) * 1000.0 * 1000.0;
				float4 colorToBlend = fragment;
				if(depthPixelInMM < focusInfo.nearPlaneInMM || (focusInfo.farPlaneInMM > 0 && depthPixelInMM > focusInfo.farPlaneInMM))
				{
					colorToBlend = float4(OutOfFocusPlaneColor, 1.0);
				}
				else
				{
					if(abs(coc) < focusInfo.pixelSizeLength)
					{
						colorToBlend = float4(FocusPlaneColor, 1.0);
					}
				}
				fragment = lerp(fragment, colorToBlend, OutOfFocusPlaneColorTransparency);
				if(UseAutoFocus)
				{
	#if __RESHADE_FXC__		// Freestyle
					float2 focusPointCoords = AutoFocusPoint;
	#else
					float2 focusPointCoords = UseMouseDrivenAutoFocus ? MouseCoords * BUFFER_PIXEL_SIZE : AutoFocusPoint;
	#endif
					fragment = lerp(fragment, FocusCrosshairColor, FocusCrosshairColor.w * saturate(exp(-BUFFER_WIDTH * length(focusInfo.texcoord - float2(focusPointCoords.x, focusInfo.texcoord.y)))));
					fragment = lerp(fragment, FocusCrosshairColor, FocusCrosshairColor.w * saturate(exp(-BUFFER_HEIGHT * length(focusInfo.texcoord - float2(focusInfo.texcoord.x, focusPointCoords.y)))));
				}
			}
		}
	}

// HAZE
void PS_AL_DetectInt(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 detectInt : SV_Target0)
{
	detectInt = tex2D(ReShade::BackBuffer, texcoord);
}

void PS_AL_DetectLow(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 detectLow : SV_Target0)
{
	detectLow = 0;

	if (USE_LensHaze) 
	{
		if (texcoord.x != 0.5 && texcoord.y != 0.5)
			discard;

		[loop]
		for (float i = 0.0; i <= 1; i += 0.03125)
		{
			[unroll]
			for (float j = 0.0; j <= 1; j += 0.03125)
			{
				detectLow.xyz += tex2D(detectIntColor, float2(i, j)).xyz;
			}
		}

		detectLow.xyz /= 32 * 32;
	}
}

void PS_AL_DetectHigh(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 x : SV_Target)
{
	x = tex2D(ReShade::BackBuffer, texcoord);
	if (USE_LensHaze) 
	{
		x = float4(x.rgb * pow(abs(max(x.r, max(x.g, x.b))), 2.0), 1.0f);

		float base = (x.r + x.g + x.b); base /= 3;

		float nR = (x.r * 2) - base;
		float nG = (x.g * 2) - base;
		float nB = (x.b * 2) - base;

		[flatten]
		if (nR < 0)
		{
			nG += nR / 2;
			nB += nR / 2;
			nR = 0;
		}
		[flatten]
		if (nG < 0)
		{
			nB += nG / 2;
			[flatten] if (nR > -nG / 2) nR += nG / 2; else nR = 0;
			nG = 0;
		}
		[flatten]
		if (nB < 0)
		{
			[flatten] if (nR > -nB / 2) nR += nB / 2; else nR = 0;
			[flatten] if (nG > -nB / 2) nG += nB / 2; else nG = 0;
			nB = 0;
		}

		[flatten]
		if (nR > 1)
		{
			nG += (nR - 1) / 2;
			nB += (nR - 1) / 2;
			nR = 1;
		}
		[flatten]
		if (nG > 1)
		{
			nB += (nG - 1) / 2;
			[flatten] if (nR + (nG - 1) < 1) nR += (nG - 1) / 2; else nR = 1;
			nG = 1;
		}
		[flatten]
		if (nB > 1)
		{
			[flatten] if (nR + (nB - 1) < 1) nR += (nB - 1) / 2; else nR = 1;
			[flatten] if (nG + (nB - 1) < 1) nG += (nB - 1) / 2; else nG = 1;
			nB = 1;
		}

		x.r = nR; x.g = nG; x.b = nB;
	}
}

void PS_AL_HGB(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 hgb : SV_Target)
{
	if (!USE_LensHaze) hgb = tex2D(ReShade::BackBuffer, texcoord);
	else 
	{
		const float sampleOffsets[5] = { 0.0, 2.4347826, 4.3478260, 6.2608695, 8.1739130 };
		const float sampleWeights[5] = { 0.16818994, 0.27276957, 0.111690125, 0.024067905, 0.0021112196 };

		hgb = tex2D(alInColor, texcoord) * sampleWeights[0];
		hgb = float4(max(hgb.rgb - 64.0, 0.0), hgb.a);
		float stepMult = 1.08 + (AL_t.x / 100) * 0.02;

		[flatten]
		if ((texcoord.x + sampleOffsets[1] * GEMFX_PIXEL_SIZE.x) < 1.05)
			hgb += tex2D(alInColor, texcoord + float2(sampleOffsets[1] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[1] * stepMult;
		[flatten]
		if ((texcoord.x - sampleOffsets[1] * GEMFX_PIXEL_SIZE.x) > -0.05)
			hgb += tex2D(alInColor, texcoord - float2(sampleOffsets[1] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[1] * stepMult;

		[flatten]
		if ((texcoord.x + sampleOffsets[2] * GEMFX_PIXEL_SIZE.x) < 1.05)
			hgb += tex2D(alInColor, texcoord + float2(sampleOffsets[2] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[2] * stepMult;
		[flatten]
		if ((texcoord.x - sampleOffsets[2] * GEMFX_PIXEL_SIZE.x) > -0.05)
			hgb += tex2D(alInColor, texcoord - float2(sampleOffsets[2] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[2] * stepMult;

		[flatten]
		if ((texcoord.x + sampleOffsets[3] * GEMFX_PIXEL_SIZE.x) < 1.05)
			hgb += tex2D(alInColor, texcoord + float2(sampleOffsets[3] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[3] * stepMult;
		[flatten]
		if ((texcoord.x - sampleOffsets[3] * GEMFX_PIXEL_SIZE.x) > -0.05)
			hgb += tex2D(alInColor, texcoord - float2(sampleOffsets[3] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[3] * stepMult;

		[flatten]
		if ((texcoord.x + sampleOffsets[4] * GEMFX_PIXEL_SIZE.x) < 1.05)
			hgb += tex2D(alInColor, texcoord + float2(sampleOffsets[4] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[4] * stepMult;
		[flatten]
		if ((texcoord.x - sampleOffsets[4] * GEMFX_PIXEL_SIZE.x) > -0.05)
			hgb += tex2D(alInColor, texcoord - float2(sampleOffsets[4] * GEMFX_PIXEL_SIZE.x, 0.0)) * sampleWeights[4] * stepMult;
	}
}

void PS_AL_VGB(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 vgb : SV_Target)
{
	if (!USE_LensHaze) vgb = tex2D(ReShade::BackBuffer, texcoord);
	else 
	{
		const float sampleOffsets[5] = { 0.0, 2.4347826, 4.3478260, 6.2608695, 8.1739130 };
		const float sampleWeights[5] = { 0.16818994, 0.27276957, 0.111690125, 0.024067905, 0.0021112196 };

		vgb = tex2D(alOutColor, texcoord) * sampleWeights[0];
		vgb = float4(max(vgb.rgb - 64.0, 0.0), vgb.a);
		float stepMult = 1.08 + (AL_t.x / 100) * 0.02;

		[flatten]
		if ((texcoord.y + sampleOffsets[1] * GEMFX_PIXEL_SIZE.y) < 1.05)
			vgb += tex2D(alOutColor, texcoord + float2(0.0, sampleOffsets[1] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[1] * stepMult;
		[flatten]
		if ((texcoord.y - sampleOffsets[1] * GEMFX_PIXEL_SIZE.y) > -0.05)
			vgb += tex2D(alOutColor, texcoord - float2(0.0, sampleOffsets[1] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[1] * stepMult;

		[flatten]
		if ((texcoord.y + sampleOffsets[2] * GEMFX_PIXEL_SIZE.y) < 1.05)
			vgb += tex2D(alOutColor, texcoord + float2(0.0, sampleOffsets[2] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[2] * stepMult;
		[flatten]
		if ((texcoord.y - sampleOffsets[2] * GEMFX_PIXEL_SIZE.y) > -0.05)
			vgb += tex2D(alOutColor, texcoord - float2(0.0, sampleOffsets[2] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[2] * stepMult;

		[flatten]
		if ((texcoord.y + sampleOffsets[3] * GEMFX_PIXEL_SIZE.y) < 1.05)
			vgb += tex2D(alOutColor, texcoord + float2(0.0, sampleOffsets[3] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[3] * stepMult;
		[flatten]
		if ((texcoord.y - sampleOffsets[3] * GEMFX_PIXEL_SIZE.y) > -0.05)
			vgb += tex2D(alOutColor, texcoord - float2(0.0, sampleOffsets[3] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[3] * stepMult;

		[flatten]
		if ((texcoord.y + sampleOffsets[4] * GEMFX_PIXEL_SIZE.y) < 1.05)
			vgb += tex2D(alOutColor, texcoord + float2(0.0, sampleOffsets[4] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[4] * stepMult;
		[flatten]
		if ((texcoord.y - sampleOffsets[4] * GEMFX_PIXEL_SIZE.y) > -0.05)
			vgb += tex2D(alOutColor, texcoord - float2(0.0, sampleOffsets[4] * GEMFX_PIXEL_SIZE.y)) * sampleWeights[4] * stepMult;
	}
}

float4 PS_AL_Magic(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 base = tex2D(ReShade::BackBuffer, texcoord);
	
	if (!USE_LensHaze) return base;
	else 
	{
		float4 high = tex2D(alInColor, texcoord);
		float adapt = 0;

	#if __RENDERER__ < 0xa000 && !__RESHADE_PERFORMANCE_MODE__
		[flatten]
	#endif

		//DetectLow
		float4 detectLow = tex2D(detectLowColor, 0.5) / 4.215;
		float low = sqrt(0.241 * detectLow.r * detectLow.r + 0.691 * detectLow.g * detectLow.g + 0.068 * detectLow.b * detectLow.b);
		//.DetectLow

		low = pow(low * 1.25f, 2);
		adapt = low * (low + 1.0f) * fLensHazeAdaptation * fLensHazeIntensity * 5.0f;

		

		high = min(0.0325f, high) * 1.15f;
		float4 highOrig = high;

		float2 flipcoord = 1.0f - texcoord;
		float4 highFlipOrig = tex2D(alInColor, flipcoord);
		highFlipOrig = min(0.03f, highFlipOrig) * 1.15f;

		float4 highFlip = highFlipOrig;
		float4 highLensSrc = high;

	#if __RENDERER__ < 0xa000 && !__RESHADE_PERFORMANCE_MODE__
		[flatten]
	#endif
		if (bUseLensDirt)
		{
			float4 dirt = tex2D(dirtSampler, texcoord);
			float4 dirtOVR = tex2D(dirtOVRSampler, texcoord);
			float4 dirtOVB = tex2D(dirtOVBSampler, texcoord);

			float maxhigh = max(high.r, max(high.g, high.b));
			float threshDiff = maxhigh - 3.2f;

			[flatten]
			if (threshDiff > 0)
			{
				high.r = (high.r / maxhigh) * 3.2f;
				high.g = (high.g / maxhigh) * 3.2f;
				high.b = (high.b / maxhigh) * 3.2f;
			}

			float4 highDirt = bUseVeryLensDirt ? highOrig * dirt * fLensDirtIntensity : highOrig * high * fLensDirtIntensity;

		
			highDirt *= 1.0f + 0.5f * sin(AL_t.x);

			float highMix = highOrig.r + highOrig.g + highOrig.b;
			float red = highOrig.r / highMix;
			float green = highOrig.g / highMix;
			float blue = highOrig.b / highMix;
			highOrig = highOrig + highDirt;


			high = high + high * dirtOVR * alDirtOVInt * green;
			high = high + highDirt;
			high = high + highOrig * dirtOVB * alDirtOVInt * blue;
			high = high + highOrig * dirtOVR * alDirtOVInt* red;
			


			highLensSrc = high * 85f * pow(1.25f - (abs(texcoord.x - 0.5f) + abs(texcoord.y - 0.5f)), 2);
		}

		float origBright = max(highLensSrc.r, max(highLensSrc.g, highLensSrc.b));
		float maxOrig = max((1.8f * 0.5) - pow(origBright * (0.5f - abs(texcoord.x - 0.5f)), 4), 0.0f);
		float smartWeight = maxOrig * max(abs(flipcoord.x - 0.5f), 0.3f * abs(flipcoord.y - 0.5f)) * (2.2 - 1.2 * (abs(flipcoord.x - 0.5f))) * fLensDirtRefractionPower;
		smartWeight = min(0.85f, max(0, smartWeight - adapt));

	#if __RENDERER__ < 0xa000 && !__RESHADE_PERFORMANCE_MODE__
		[flatten]
	#endif

			float4 lensDB = tex2D(lensDBSampler, texcoord);
			float4 lensDB2 = tex2D(lensDB2Sampler, texcoord);
			float4 lensDOV = tex2D(lensDOVSampler, texcoord);
			float4 lensDUV = tex2D(lensDUVSampler, texcoord);

			float4 highLens = highFlip * lensDB * 0.7f * smartWeight;
			high += highLens;

			highLens = highFlipOrig * lensDUV * 1.15f * smartWeight;
			highFlipOrig += highLens;
			high += highLens;

			highLens = highFlipOrig * lensDB2 * 0.7f * smartWeight;
			highFlipOrig += highLens;
			high += highLens;

			highLens = highFlipOrig * lensDOV * 1.15f * smartWeight / 2f + highFlipOrig * smartWeight / 2f;
			highFlipOrig += highLens;
			high += highLens;
		

		if (all(base.xyz == 1.0))
		{
			return 1.0;
		}

	#if __RENDERER__ < 0xa000 && !__RESHADE_PERFORMANCE_MODE__
		[flatten]
	#endif

			base.xyz *= max(0.0f, (1.0f - adapt * 0.75f * fLensHazeCompression * pow(abs(1.0f - (base.x + base.y + base.z) / 3), fLensHazeLightLevel)));
			float4 highSampleMix = (1.0 - ((1.0 - base) * (1.0 - high * 1.0)));
			float4 baseSample = lerp(base, highSampleMix, max(0.0f, fLensHazeIntensity - adapt));
			float baseSampleMix = baseSample.r + baseSample.g + baseSample.b;
			return baseSampleMix > 0.008 ? baseSample : lerp(base, highSampleMix, max(0.0f, (fLensHazeIntensity - adapt) * 0.85f) * baseSampleMix);
		}
}

// VIGNETTE

float4 PS_Vignette(float4 vpos : SV_Position, float2 tex : TexCoord) : SV_Target
{
	float4 color = tex2D(ReShade::BackBuffer, tex);
	if (bUseLenShadow) {
		// Set the center
		float2 distance_xy = tex - perfectCenter;

		// Adjust the ratio
		distance_xy *= float2((BUFFER_RCP_HEIGHT / BUFFER_RCP_WIDTH), fLensShadowShape);

		// Calculate the distance
		distance_xy /= fLensShadowSoftness;
		float distance = dot(distance_xy, distance_xy);

		// Apply the vignette
		color.rgb *= (1.0 + pow(distance, iLensShadowDistance * 0.5) * fLensShadowResult); //pow - multiply
	}
	return color;
}
	
// RATIO 

float3 PS_AspectRatio(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	bool Mask = false;
	
	// Center coordinates
	float2 coord = texcoord-0.5;
	
	if (!bUseLensDistortion) return tex2D(ReShade::BackBuffer, texcoord);
	else 
	{

		// Squeeze horizontally
		if (fLensProps<0)
		{
			coord.x *= abs(fLensProps)+1.0; // Apply distortion

			// Scale to borders
			if (FitScreen) coord /= abs(fLensProps)+1.0;
			else // Mask image borders
				Mask = abs(coord.x)>0.5;
		}
		// Squeeze vertically
		else if (fLensProps>0)
		{
			coord.y *= fLensProps+1.0; // Apply distortion

			// Scale to borders
			if (FitScreen) coord /= abs(fLensProps)+1.0;
			else // Mask image borders
				Mask = abs(coord.y)>0.5;
		}

		// Coordinates back to the corner
		coord += 0.5;

		// Sample display image and return
		if (!FitScreen) // If borders are visible
			return Mask? BlackColor.rgb : tex2D(ReShade::BackBuffer, coord).rgb;
		else
			return Mask? BlackColor.rgb : tex2D(ReShade::BackBuffer, coord).rgb;
	}
}	
	
// DISTORTION 

float3 PS_FISHEYE_CA(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
	float fFisheyeDistortionModifier;
	float fFisheyeDistortionCubicModifier;
	
	if (bUseLensDistortion) 
	{
		if (bUseInterlaced || bLensDistPerfectFit) 
		{
			fFisheyeDistortionModifier = saturate(lerp(0.0,0.135f,fFisheyeDistortion));
			fFisheyeDistortionCubicModifier = saturate(lerp(0.0,0.075f,fFisheyeDistortionEdges));
		}
		else 
		{
			fFisheyeDistortionModifier = saturate(lerp(0.0,0.115f,fFisheyeDistortion));
			fFisheyeDistortionCubicModifier = saturate(lerp(0.0,0.055f,fFisheyeDistortionEdges));
		}

		
		float4 coord=0.0;
		coord.xy=texcoord.xy;
		coord.w=0.0;

		color.rgb = 0.0;
		  
		float3 eta = float3(1.0+(fFisheyeCA*0.1)*0.9,1.0+(fFisheyeCA*0.1)*0.6,1.0+(fFisheyeCA*0.1)*0.3);
		float2 center;
		center.x = coord.x-0.5;
		center.y = coord.y-0.5;
		float LensZoom = 1.0/(0.5f + fFisheyeDistortionModifier + fFisheyeDistortionCubicModifier);

		float r2 = (texcoord.y-0.5) * (texcoord.y-0.5);// + (texcoord.y-0.5) * (texcoord.y-0.5);
		float f = 0;

		if( fFisheyeDistortionEdges == 0.0){
			f = 1 + r2 * fFisheyeDistortion;
		}else{
					f = 1 + r2 * (fFisheyeDistortion + fFisheyeDistortionEdges * sqrt(r2));
		};

		float x = f*LensZoom*(coord.x-0.5)+0.5;
		float y = f*LensZoom*(coord.y-0.5)+0.5;
		
		float2 rCoords = (f*eta.r)*LensZoom*(center.xy*0.5)+0.5;
		float2 gCoords = (f*eta.g)*LensZoom*(center.xy*0.5)+0.5;
		float2 bCoords = (f*eta.b)*LensZoom*(center.xy*0.5)+0.5;
		
		color.x = tex2D(ReShade::BackBuffer,rCoords).r;
		color.y = tex2D(ReShade::BackBuffer,gCoords).g;
		color.z = tex2D(ReShade::BackBuffer,bCoords).b;
	}
	
	return color.rgb;
}	

// GAUSSIAN 01

float3 PS_GaussianBlur_PrePass1(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{
	  
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	if (bUseLensBlur && LensBlur_PrePassOffset > 0.0) {

		if(LensBlur_PrePassOffset < 1.0)	
		{
			float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
			float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 4; ++i)
			{
				color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * LensBlur_PrePassOffset).rgb * weight[i];
				color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * LensBlur_PrePassOffset).rgb * weight[i];
			}
		}	

		if(LensBlur_PrePassOffset >= 1.0)	
		{
			float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
			float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 6; ++i)
			{
				color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * (LensBlur_PrePassOffset-1.0)).rgb * weight[i];
				color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * (LensBlur_PrePassOffset-1.0)).rgb * weight[i];
			}
		}	
	}
		
	return saturate(color);
}

//

float3 PS_GaussianBlur_PrePassFinal(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{

	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	if (bUseLensBlur && LensBlur_PrePassOffset > 0.0) {
		if(LensBlur_PrePassOffset < 1.0)
		{
			float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
			float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 4; ++i)
			{
				color += tex2D(GaussianBlur_PrePassSampler, texcoord + float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * LensBlur_PrePassOffset).rgb * weight[i];
				color += tex2D(GaussianBlur_PrePassSampler, texcoord - float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * LensBlur_PrePassOffset).rgb * weight[i];
			}
		}	

		if(LensBlur_PrePassOffset >= 1.0)
		{
			float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
			float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 6; ++i)
			{
				color += tex2D(GaussianBlur_PrePassSampler, texcoord + float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * (LensBlur_PrePassOffset-1.0)).rgb * weight[i];
				color += tex2D(GaussianBlur_PrePassSampler, texcoord - float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * (LensBlur_PrePassOffset-1.0)).rgb * weight[i];
			}
		}	
	}
	
	return saturate(color);
}

// GAUSSIAN 02

float3 PS_GaussianBlur_PostPass1(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{
	  
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	if (fFirmwareFiltering > 0.0) {

		if(fFirmwareFiltering < 1.0)	
		{
			float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
			float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 4; ++i)
			{
				color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * fFirmwareFiltering).rgb * weight[i];
				color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * fFirmwareFiltering).rgb * weight[i];
			}
		}	

		if(fFirmwareFiltering >= 1.0)	
		{
			float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
			float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 6; ++i)
			{
				color += tex2D(ReShade::BackBuffer, texcoord + float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * (fFirmwareFiltering-1.0)).rgb * weight[i];
				color += tex2D(ReShade::BackBuffer, texcoord - float2(offset[i] * BUFFER_PIXEL_SIZE.x, 0.0) * (fFirmwareFiltering-1.0)).rgb * weight[i];
			}
		}	
	}
		
	return saturate(color);
}

//

float3 PS_GaussianBlur_PostPassFinal(in float4 pos : SV_Position, in float2 texcoord : TEXCOORD) : COLOR
{

	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	if (fFirmwareFiltering > 0.0) {
		if(fFirmwareFiltering < 1.0)
		{
			float offset[4] = { 0.0, 1.1824255238, 3.0293122308, 5.0040701377 };
			float weight[4] = { 0.39894, 0.2959599993, 0.0045656525, 0.00000149278686458842 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 4; ++i)
			{
				color += tex2D(GaussianBlur_PostPassSampler, texcoord + float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * fFirmwareFiltering).rgb * weight[i];
				color += tex2D(GaussianBlur_PostPassSampler, texcoord - float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * fFirmwareFiltering).rgb * weight[i];
			}
		}	

		if(fFirmwareFiltering >= 1.0)
		{
			float offset[6] = { 0.0, 1.4584295168, 3.40398480678, 5.3518057801, 7.302940716, 9.2581597095 };
			float weight[6] = { 0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922, 0.0019913644 };
			
			color *= weight[0];
			
			[loop]
			for(int i = 1; i < 6; ++i)
			{
				color += tex2D(GaussianBlur_PostPassSampler, texcoord + float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * (fFirmwareFiltering-1.0)).rgb * weight[i];
				color += tex2D(GaussianBlur_PostPassSampler, texcoord - float2(0.0, offset[i] * BUFFER_PIXEL_SIZE.y) * (fFirmwareFiltering-1.0)).rgb * weight[i];
			}
		}	
	}
	
	return saturate(color);
}

// SHARPENING 01

float3 PS_LumaSharpenPrePass(float4 position : SV_Position, float2 tex : TEXCOORD) : SV_Target
{

	float3 ori = tex2D(ReShade::BackBuffer, tex).rgb;
	
	if (!bUseLensBlur) return ori;
	else 
	{
		float fLensDofSharpMulti = 1.0;
		if (kHome) fLensDofSharpMulti = 0.5;
		
		float3 sharp_strength_luma = ((CoefLuma * lerp(fLensSharpness.x, fLensSharpness.y, saturate(pow(LDepth(tex),DepthSharpPow)))) * fLensDofSharpMulti);
		float sharp_clamp = saturate(lerp(1.0, 0.5, fLensSharpness.x*0.01));
		float3 blur_ori;

		blur_ori  = tex2D(ReShade::BackBuffer, tex + float2(BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y) * 0.5 * (fLensSharpnessRadius*ResModifier())).rgb; // South East
		blur_ori += tex2D(ReShade::BackBuffer, tex - BUFFER_PIXEL_SIZE * 0.5 * (fLensSharpnessRadius*ResModifier())).rgb;  // South West
		blur_ori += tex2D(ReShade::BackBuffer, tex + BUFFER_PIXEL_SIZE * 0.5 * (fLensSharpnessRadius*ResModifier())).rgb; // North East
		blur_ori += tex2D(ReShade::BackBuffer, tex - float2(BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y) * 0.5 * (fLensSharpnessRadius*ResModifier())).rgb; // North West

		blur_ori *= 0.25;  // ( /= 4) Divide by the number of texture fetches

		// -- Calculate the sharpening --
		float3 sharp = ori - blur_ori;  //Subtracting the blurred image from the original image


		// -- Adjust strength of the sharpening and clamp it--
		float4 sharp_strength_luma_clamp = float4(sharp_strength_luma * (0.5 / sharp_clamp),0.5); //Roll part of the clamp into the dot

		//sharp_luma = saturate((0.5 / sharp_clamp) * sharp_luma + 0.5); //scale up and clamp
		float sharp_luma = saturate(dot(float4(sharp,1.0), sharp_strength_luma_clamp)); //Calculate the luma, adjust the strength, scale up and clamp
		sharp_luma = (sharp_clamp * 2.0) * sharp_luma - sharp_clamp; //scale down


		// -- Combining the values to get the final sharpened pixel	--
		float3 outputcolor = ori + sharp_luma;    // Add the sharpening to the the original.

		if (show_sharpen)
		{
			outputcolor = saturate(0.5 + (sharp_luma * 4.0)).rrr;
		}

		return saturate(outputcolor);
	}
}

// TONEMAPPING 
//LUT 
void CCLUT(float4 vois : SV_Position, float2 TexCoord : TEXCOORD, out float3 Image : SV_Target)
{
	Image = tex2D(ReShade::BackBuffer, TexCoord).rgb;

	Image.rgb = pow(Image,fGamma);
	
	float fNightKSet = 0.0f;
	if (bISNIGHT()) fNightKSet = 1.0f;
	
	// Color Temperature
	float3 kColor    = KelvinToRGB( Kelvin-fNightKSet );
    float3 oLum      = RGBToHSL( Image.xyz );
    float3 blended   = Image.xyz * kColor.xyz;
    float3 resHSV    = RGBToHSL( blended.xyz );
    float3 resRGB    = HSLToRGB( float3( resHSV.xy, oLum.z ));
    Image.xyz        = LumPreservation ? resRGB.xyz : blended.xyz;
	
	float3 lut3D = Image*(LUT_BLOCK_SIZE-1);
	float2 lut2D[2];
		// Front
		lut2D[0].x = floor(lut3D.z)*LUT_BLOCK_SIZE+lut3D.x;
		lut2D[0].y = lut3D.y;
		// Back
		lut2D[1].x = ceil(lut3D.z)*LUT_BLOCK_SIZE+lut3D.x;
		lut2D[1].y = lut3D.y;
	lut2D[0] = (lut2D[0]+0.5)*LUT_PIXEL_SIZE;
	lut2D[1] = (lut2D[1]+0.5)*LUT_PIXEL_SIZE;


	float3 LutImage;
	if (iLUTSet == 0) LutImage = Image; //RAW
	if (iLUTSet == 1)
		LutImage = lerp(
			tex2D(LUTVHSSampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTVHSSampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);
	if (iLUTSet == 2)
		LutImage = lerp(
			tex2D(LUTBCSampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTBCSampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);
	if (iLUTSet == 3)
		LutImage = lerp(
			tex2D(LUTBC2Sampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTBC2Sampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);
	if (iLUTSet == 4)
		LutImage = lerp(
			tex2D(LUTMRSampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTMRSampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);
	
	if (iLUTSet == 5)
		LutImage = lerp(
			tex2D(LUTURSampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTURSampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);
	if (iLUTSet == 6)
		LutImage = lerp(
			tex2D(LUTGPSampler, lut2D[0]).rgb, // Front Z
			tex2D(LUTGPSampler, lut2D[1]).rgb, // Back Z
			frac(lut3D.z)
		);

	// Blend LUT image with original
	if ( all(LutChromaLuma==1.0) )
		Image = LutImage;
	else
	{
		Image = lerp(
			normalize(Image),
			normalize(LutImage),
			LutChromaLuma.x
		)*lerp(
			length(Image),
			length(LutImage),
			LutChromaLuma.y
		);
	}

	//+++ desaturate shadows
	float	tempgray;
	float4	tempvar;

	tempgray=dot(Image.xyz, 0.3333);
	tempvar.x=saturate(1.0-tempgray);
	tempvar.x*=tempvar.x;
	tempvar.x*=tempvar.x;
	Image=lerp(Image, tempgray, fDesaturateShadows*tempvar.x);
	
	
	// Saturation Limit 
	Image.xyz = RGBToHSL( Image.xyz );
	Image.y = min( Image.y, saturation_limit );
    Image.xyz = HSLToRGB( Image.xyz );

}

// COLOR BALANCE
float4 PS_WriteColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
    {
        return tex2D( ReShade::BackBuffer, texcoord );
    }

//Downscale to 32x32 min/max color matrix
    void PS_MinMax_1( float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 minValue : SV_Target0, out float4 maxValue : SV_Target1, out float4 midValue : SV_Target2 )
    {
        float3 currColor;
        float3 minMethod0  = 1.0f;
        float3 minMethod1  = 1.0f;
        float3 maxMethod0  = 0.0f;
        float3 maxMethod1  = 0.0f;
        midValue           = 0.0f;

        float getMid;   float getMid2;
        float getMin;   float getMin2;
        float getMax;   float getMax2;

        float3 prevMin     = tex2D( samplerPrevious, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
        float3 prevMax     = tex2D( samplerPrevious, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
        float middle       = dot( float2( dot( prevMin.xyz, 0.333333f ), dot( prevMax.xyz, 0.333333f )), 0.5f );
        middle             = ( bMidpointAverage ) ? middle : 0.5f;

        // RenderTarget size is 32x32
        float pst          = 0.03125f;    // rcp( 32 )
        float hst          = 0.5f * pst;  // half size

        // Sample texture
        float2 stexSize    = float2( BUFFER_WIDTH/1, BUFFER_HEIGHT/1 );
        uint OFFSET        = 1 + 1 * 3;
        float2 start       = floor(( texcoord.xy - hst ) * stexSize.xy );    // sample block start position
        float2 stop        = floor(( texcoord.xy + hst ) * stexSize.xy );    // ... end position

        [loop]
        for( int y = start.y; y < stop.y && y < stexSize.y; y += OFFSET )
        {
            for( int x = start.x; x < stop.x && x < stexSize.x; x += OFFSET )
            {
                currColor      = tex2Dfetch( samplerColor, int2( x, y ), 0 ).xyz;
                // Dark color detection methods
                // Per channel
                minMethod0.xyz = min( minMethod0.xyz, currColor.xyz );
                // By color
                getMin         = max( max( currColor.x, currColor.y ), currColor.z ) + dot( currColor.xyz, 1.0f );
                getMin2        = max( max( minMethod1.x, minMethod1.y ), minMethod1.z ) + dot( minMethod1.xyz, 1.0f );
                minMethod1.xyz = ( getMin2 >= getMin ) ? currColor.xyz : minMethod1.xyz;
                // Mid point detection
                getMid         = dot( abs( currColor.xyz - middle ), 1.0f );
                getMid2        = dot( abs( midValue.xyz - middle ), 1.0f );
                midValue.xyz   = ( getMid2 >= getMid ) ? currColor.xyz : midValue.xyz;
                
				// Light color detection methods
                // Per channel
                maxMethod0.xyz = max( currColor.xyz, maxMethod0.xyz );
                // By color
                getMax         = dot( currColor.xyz, 1.0f );
                getMax2        = dot( maxMethod1.xyz, 1.0f );
                maxMethod1.xyz = ( getMax >= getMax2 ) ? currColor.xyz : maxMethod1.xyz;
            }
        }

        minValue.xyz       = blackpoint_method ? minMethod1.xyz : minMethod0.xyz;
        maxValue.xyz       = whitepoint_method ? maxMethod1.xyz : maxMethod0.xyz;
        // Return
        minValue           = float4( minValue.xyz, 1.0f );
        maxValue           = float4( maxValue.xyz, 1.0f );
        midValue           = float4( midValue.xyz, 1.0f );
    }

    //Downscale to 32x32 to 1x1 min/max colors
    float4 PS_MinMax_1x1( float4 pos : SV_Position, float2 texcoord : TEXCOORD ) : SV_Target
    {
        float3 minColor; float3 maxColor; float3 midColor;
        float3 minValue; float3 maxValue; float3 midValue;
        float getMin;    float getMin2;
        float getMax;    float getMax2;
        float3 minMethod0  = 1.0f;
        float3 minMethod1  = 1.0f;
        float3 maxMethod0  = 0.0f;
        float3 maxMethod1  = 0.0f;
        midValue           = 0.0f;
        //Get texture resolution
        int2 SampleRes     = 32;
        float Sigma        = 0.0f;

        for( int y = 0; y < SampleRes.y; ++y )
        {
            for( int x = 0; x < SampleRes.x; ++x )
            {   
                // Dark color detection methods
                minColor       = tex2Dfetch( samplerDS_1_Min, int2( x, y ), 0 ).xyz;
                // Per channel
                minMethod0.xyz = min( minMethod0.xyz, minColor.xyz );
                // By color
                getMin         = max( max( minColor.x, minColor.y ), minColor.z ) + dot( minColor.xyz, 1.0f );
                getMin2        = max( max( minMethod1.x, minMethod1.y ), minMethod1.z ) + dot( minMethod1.xyz, 1.0f );
                minMethod1.xyz = ( getMin2 >= getMin ) ? minColor.xyz : minMethod1.xyz;
                // Mid point detection
                midColor       += tex2Dfetch( samplerDS_1_Mid, int2( x, y ), 0 ).xyz;
                Sigma          += 1.0f;
                // Light color detection methods
                maxColor       = tex2Dfetch( samplerDS_1_Max, int2( x, y ), 0 ).xyz;
                // Per channel
                maxMethod0.xyz = max( maxColor.xyz, maxMethod0.xyz );
                // By color
                getMax         = dot( maxColor.xyz, 1.0f );
                getMax2        = dot( maxMethod1.xyz, 1.0f );
                maxMethod1.xyz = ( getMax >= getMax2 ) ? maxColor.xyz : maxMethod1.xyz;
            }
        }

        minValue.xyz       = blackpoint_method ? minMethod1.xyz : minMethod0.xyz;
        maxValue.xyz       = whitepoint_method ? maxMethod1.xyz : maxMethod0.xyz;
        midValue.xyz       = midColor.xyz / Sigma;

        maxValue.xyz       = ( minValue.xyz >= maxValue.xyz ) ? float3( 1.0f, 1.0f, 1.0f ) : maxValue.xyz;

        float3 prevMin     = tex2D( samplerPrevious, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
        float3 prevMid     = tex2D( samplerPrevious, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
        float3 prevMax     = tex2D( samplerPrevious, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;

        float time         = FrameTime * 0.001f;
		maxValue.xyz       = lerp( prevMax.xyz, maxValue.xyz, saturate((FrameTime * 0.001) / AdaptTimeColor));
        minValue.xyz       = lerp( prevMin.xyz, minValue.xyz, saturate((FrameTime * 0.001) / AdaptTimeColor));
        midValue.xyz       = lerp( prevMid.xyz, midValue.xyz, saturate((FrameTime * 0.001) / AdaptTimeColor)); 
        // Return
        if( pos.x < 2 )
            return float4( minValue.xyz, 1.0f );
        else if( pos.x >= 2 && pos.x < 4 )
            return float4( midValue.xyz, 1.0f );
        else
            return float4( maxValue.xyz, 1.0f );
        return float4( 0.5, 0.5, 0.5, 1.0 );
    }

    float4 PS_RemoveTint(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
    {
        float4 color       = tex2D( samplerColor, texcoord );
		
		if (AutoWhiteBalance) 
		{
			// Grab min, max, mid values
			float3 minValue    = tex2D( samplerDS_1x1, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
			float3 midValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
			float3 maxValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
			// Get middle correction method
			float middle       = dot( float2( dot( minValue.xyz, 0.333333f ), dot( maxValue.xyz, 0.333333f )), 0.5f );
			middle             = bMidpointAverage ? middle : 0.5f;
			// Set min value
			minValue.xyz       = lerp( 0.0f, minValue.xyz, 1.0 );
			minValue.xyz       = minValue.xyz;
			// Set max value
			maxValue.xyz       = lerp( 1.0f, maxValue.xyz, fWhitePointCorrectionIntensity );
			maxValue.xyz       = maxValue.xyz;
			// Set mid value
			midValue.xyz       = midValue.xyz - middle;
			midValue.xyz       *= fAutoBalanceIntensity;
			midValue.xyz       = midValue.xyz;
			// Main color correction
			color.xyz          = saturate( color.xyz - minValue.xyz ) / ( maxValue.xyz - minValue.xyz );
			// White Point luma preservation
			float avgMax       = dot( maxValue.xyz, 0.333333f );
			color.xyz          = lerp( color.xyz, color.xyz * avgMax, 1.0 );
			// Black Point luma preservation
			float avgMin       = dot( minValue.xyz, 0.333333f );
			//color.xyz          = lerp( color.xyz, color.xyz * ( 1.0f - avgMin ) + avgMin, rt_bp_rl_str );
			// Mid Point correction
			float avgCol       = dot( color.xyz, 0.333333f ); // Avg after main correction
			float avgMid       = dot( midValue.xyz, 0.333333f );
			avgCol             = 1.0f - abs( avgCol * 2.0f - 1.0f );
			color.xyz          = saturate( color.xyz - midValue.xyz * avgCol + avgMid * avgCol * bMidpointRespectGamma );

		}

        return float4( color.xyz, 1.0f );
    }

    float4 PS_StorePrev( float4 pos : SV_Position, float2 texcoord : TEXCOORD ) : SV_Target
    {
        float3 minValue    = tex2D( samplerDS_1x1, float2( texcoord.x / 6.0f, texcoord.y )).xyz;
        float3 midValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 2.0f ) / 6.0f, texcoord.y )).xyz;
        float3 maxValue    = tex2D( samplerDS_1x1, float2(( texcoord.x + 4.0f ) / 6.0f, texcoord.y )).xyz;
        if( pos.x < 2 )
            return float4( minValue.xyz, 1.0f );
        else if( pos.x >= 2 && pos.x < 4 )
            return float4( midValue.xyz, 1.0f );
        else
            return float4( maxValue.xyz, 1.0f );
    }

// ACES 

float4 GetSmallPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
	float adapt = dot(tex2D(BackBuffer_Linear, uv).rgb, LumaWeights);
	
	float fAdaptCurve;
	float fNightIsoSet = 1.0f;
	if (bISNIGHT()) fNightIsoSet = 2.0f;
	
		if (iISO==0) fAdaptCurve = 5.0; 		//100
			if (iISO==1) fAdaptCurve = 10.0; 	//100f
		
		if (iISO==2) fAdaptCurve = 4.0;		//200
			if (iISO==3) fAdaptCurve = 8.0; 	//200f
		
		if (iISO==4) fAdaptCurve = 3.2;		//400
			if (iISO==5) fAdaptCurve = 6.0; 	//400f
		
		if (iISO==6) fAdaptCurve = 2.5;		//600
			
		if (iISO==7) fAdaptCurve = 1.5;		//800
			if (iISO==8) fAdaptCurve = 2.2; 	//800f
		
		if (iISO==9) fAdaptCurve = 1.0;		//1200
			if (iISO==10) fAdaptCurve = 1.5; //1200f
		
	if (bISNIGHT()) adapt *= 10.0;
	else adapt *= fAdaptCurve;

	float last = tex2Dfetch(LastAdapt, 0).x;
	float AT = AdaptTime;
	if (AdaptTime > 0.0)
		
		if (AdaptMetering < 1) AT -= 0.2;
		if (AdaptMetering > 1) AT += 0.2;
		adapt = lerp(last, adapt, saturate((FrameTime * 0.001) / AT));

	return adapt;
}

float4 SaveAdaptPS(float4 p : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
	return get_adapt();
}

float4 PS_TonemapperACES(float4 p : SV_POSITION,float2 uv : TEXCOORD0,float inv_white : TEXCOORD1,float exposure : TEXCOORD2) : SV_TARGET
{
	float4 color = tex2D(BackBuffer_Point, uv);
	color.rgb = lerp(color.rgb,tonemap(color.rgb, exposure) * inv_white,Intensity);
	return color;
}

// POST EFFECTS
void PS_JPEG1(in float4 pos : SV_POSITION, in float2 txcoord : TEXCOORD0, out float4 col : COLOR0)
{
    if (iBitRate == 0) col = tex2D(ReShade::BackBuffer, txcoord);
	else 
	{
		col.w = 0.;
		
		float fBitrateQuality = lerp(0.1,1.4, iBitRate*0.1);
		float2 texcoord = txcoord * ReShade::ScreenSize;
		float2 uv = floor(texcoord-8.0*floor(texcoord/8.0));

		int CombmA, mA[64] = {  16,  11,  10,  16,  24,  40,  51,  61,
					12,  12,  14,  19,  26,  58,  60,  55,
					14,  13,  16,  24,  40,  57,  69,  56,
					14,  17,  22,  29,  51,  87,  80,  62,
					18,  22,  37,  56,  68, 109, 103,  77,
					24,  35,  55,  64,  81, 104, 113,  92,
					49,  64,  78,  87, 103, 121, 120, 101,
					72,  92,  95,  98, 112, 100, 103,  99
				  };
		//uv range needs to be set to range of array. from lowest number to max value.
		float q = fBitrateQuality*float(CombmA = mA[int(uv.x+uv.y*8.)]);
		col.xyz = (floor(.5+DCT8x8(8.*floor(texcoord/8.0),uv)/q))*q;
	}
}

void PS_JPEG2(in float4 pos : SV_POSITION, in float2 txcoord : TEXCOORD0, out float4 col : COLOR0)
{
    if (iBitRate == 0) col = tex2D(ReShade::BackBuffer, txcoord);
	else {
		float4 oriCol =  tex2D(ReShade::BackBuffer, txcoord);
		col.w = 0.;
		float2 texcoord = txcoord * ReShade::ScreenSize;
		float2 uv = floor(texcoord-8.0*floor(texcoord/8.0));
		col.xyz = lerp(oriCol, toRGB(IDCT8x8(8.*floor(texcoord/8.),uv)/256.+.5), saturate(iBitRate*0.2));
	}

}

float4 PS_ColorBanding(float4 pos : SV_Position, float2 uv : TEXCOORD0) : SV_Target
{
	float4 color = tex2D(ReShade::BackBuffer, uv);

	if (fSmoothing > 0.0f && bColorDistortion)
	{
		float2 texcoord  = uv;
		float2 texcoord2  = uv;
		texcoord2.x *= texture_size.x;
		texcoord2.y *= texture_size.y;

		float fc = mod(float(FrameCount), 2.0);
		float4 colorSmooth = color;
		
		int taps = int(3);

		float tap = 2.0f/taps;
		float2 texcoord4  = uv;
		texcoord4.x = texcoord4.x;
		texcoord4.y = texcoord4.y + ((tap*(taps/2))/480.0f*fSmoothing);
		float4 blur1 = tex2D(ReShade::BackBuffer, texcoord4);
		int bl;
		float4 ble;
		
		ble.r = 0.00f;
		ble.g = 0.00f;
		ble.b = 0.00f;

		for (bl=0;bl<taps;bl++)
			{
				texcoord4.y += (tap / 480.0f*fSmoothing);
				ble.rgb += tex2D(ReShade::BackBuffer, texcoord4).rgb / taps;
			}

			colorSmooth.rgb = ( ble.rgb );
		

		// Dither. ALWAYS do this for 16bpp
		int ditdex = 	int(mod(texcoord2.x, 4.0)) * 4 + int(mod(texcoord2.y, 4.0)); 	
		int yeh = 0;
		float ohyes;
		float4 how;

		for (yeh=ditdex; yeh<(ditdex+16); yeh++) 	ohyes =  ((((dithertable[yeh-15]) - 1) * 0.1));
		colorSmooth.rb -= (ohyes / 128);
		colorSmooth.g -= (ohyes / 128);
		{
			float4 reduct;		// 16 bits per pixel (5-6-5)
			reduct.r = 32;
			reduct.g = 64;	
			reduct.b = 32;
			how = colorSmooth;
			how = pow(how, float4(1.0f, 1.0f, 1.0f, 1.0f));  	how *= reduct;  	how = floor(how);	how = how / reduct;  	how = pow(how, float4(1.0f, 1.0f, 1.0f, 1.0f));
		}

		colorSmooth.rb = how.rb;
		colorSmooth.g = how.g;
		
		
		// RGB565 clamp

		colorSmooth.rb = round(colorSmooth.rb * 32)/32;
		colorSmooth.g = round(colorSmooth.g * 64)/64;
		
		color=colorSmooth;
	}

	return color;

}

#define wiggle 0.16

float2 jumpy(float2 uv, float fc)
{
	float2 look = uv;
	float window = 1./(1.+80.*(look.y-mod(fc/4.,1.))*(look.y-mod(fc/4.,1.)));
	look.x += 0.05 * sin(look.y*10. + fc)/20.*onOff(4.,4.,.3, fc)*(0.5+cos(fc*20.))*window;
	float vShift = (0.1*wiggle) * 0.4*onOff(2.,3.,.9, fc)*(sin(fc)*sin(fc*20.) + 
										 (0.5 + 0.1*sin(fc*200.)*cos(fc)));
	look.y = mod(look.y - 0.01 * vShift, 1.);
	return look;
}

void PS_SensorCA(in float4 pos : SV_POSITION, in float2 txcoord : TEXCOORD0, out float4 color : COLOR0)
{
	if (bColorDistortion && fSensorCA > 0.0) 
	{
		float d = .1-round(mod(iTime/3.0,1.0))*.1;
		float2 uv;
		float s;
		
		if (bUseVHS) 
		{
			uv = jumpy(txcoord.xy, iTime);
			s = 0.0001 * wiggle * -d + 0.0001 * wiggle * sin(iTime);
		}
		else 
		{
			uv = txcoord.xy;
			s=0.0;
		}

		float e = min(.30,pow(max(0.0,cos(uv.y*4.0+.3)-.75)*(s+0.5)*1.0,3.0))*25.0;
		float r = (iTime*(2.0*s));
		uv.x += abs(r*pow(min(.003,(-uv.y+(.01*mod(iTime, 17.0))))*3.0,2.0));
		
		d = .051+abs(sin(s/4.0));
		float c = max(0.0001,.002*d) * fSensorCA;

		float4 final;
		final.xyz =Blur(uv,c+c*(uv.x));
		float y = rgb2yiq(final.xyz).r;
		
		uv.x += .01*d;
		c *= 6.0;
		final.xyz =Blur(uv,c);
		float i = rgb2yiq(final.xyz).g;
		
		uv.x += .005*d;
		
		c *= 2.50;
		final.xyz =Blur(uv,c);
		float q = rgb2yiq(final.xyz).b;
		final = float4(yiq2rgb(float3(y,i,q))-pow(s+e*2.0,3.0), 1.0);
		
		color = final;
	}
	else color = tex2D(ReShade::BackBuffer, txcoord).rgb;
}

// LUMA SHARP DETAILS 


float3 PS_LumaSharpenPassDetails(float4 position : SV_Position, float2 tex : TEXCOORD) : SV_Target
{
	// -- Get the original pixel --
	float3 ori = tex2D(ReShade::BackBuffer, tex).rgb; // ori = original pixel
	
	if (fPixelSharpIntensity < 0.1) return ori;
	else 
	{
		float fDofPixSharpMulti = 1.0;
		if (kHome) fDofPixSharpMulti = 0.9;
		float3 sharp_strength_luma = ((CoefLuma * fPixelSharpIntensity) * fDofPixSharpMulti); //I'll be combining even more multipliers with it later on

		float3 blur_ori;

			blur_ori  = tex2D(ReShade::BackBuffer, tex + float2(0.5 * BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y * offset_bias)).rgb;  // South South East
			blur_ori += tex2D(ReShade::BackBuffer, tex + float2(offset_bias * -BUFFER_PIXEL_SIZE.x, 0.5 * -BUFFER_PIXEL_SIZE.y)).rgb; // West South West
			blur_ori += tex2D(ReShade::BackBuffer, tex + float2(offset_bias * BUFFER_PIXEL_SIZE.x, 0.5 * BUFFER_PIXEL_SIZE.y)).rgb; // East North East
			blur_ori += tex2D(ReShade::BackBuffer, tex + float2(0.5 * -BUFFER_PIXEL_SIZE.x, BUFFER_PIXEL_SIZE.y * offset_bias)).rgb; // North North West

			blur_ori /= 4.0; 

			sharp_strength_luma *= 0.666; 

		float3 sharp = ori - blur_ori;  

		float4 sharp_strength_luma_clamp = float4(sharp_strength_luma * (0.5 / 1.0),0.5); 

		float sharp_luma = saturate(dot(float4(sharp,1.0), sharp_strength_luma_clamp)); 
		sharp_luma = (1.0 * 2.0) * sharp_luma - 1.0; 

		float3 outputcolor = ori + sharp_luma;

		return saturate(outputcolor);
	}
}

float3 PS_FilmicSharpen(float4 pos : SV_Position, float2 UvCoord : TEXCOORD) : SV_Target
{

	// Sample display image
	float3 Source = tex2D(BackBuffer, UvCoord).rgb;

	// Generate and apply radial mask
	float Mask;

	// Generate radial mask
	float fFirmDofSharp = 1.0;
	if (kHome) fFirmDofSharp *= 0.8;
	Mask = 1.0-length(UvCoord*2.0-1.0);
	Mask = Overlay(Mask)* (fFirmwareSharpening*fFirmDofSharp) * ResModifier();
	// Bypass
	if (Mask <= 0) return Source;

	// Get pixel size
	float2 Pixel = BUFFER_PIXEL_SIZE*(fSensorSizeSharpness*ResModifier());

	// Sampling coordinates
	float2 NorSouWesEst[4] = {
		float2(UvCoord.x, UvCoord.y+Pixel.y),
		float2(UvCoord.x, UvCoord.y-Pixel.y),
		float2(UvCoord.x+Pixel.x, UvCoord.y),
		float2(UvCoord.x-Pixel.x, UvCoord.y)
	};

	const float3 LumaCoefficient = Luma709;

	// Luma high-pass
	float HighPass = 0.0;
	[unroll]
	for(int i=0; i<4; i++)
		HighPass += dot(tex2D(BackBuffer, NorSouWesEst[i]).rgb, LumaCoefficient);

	HighPass = 0.5-0.5*(HighPass*0.25-dot(Source, LumaCoefficient));

	// Sharpen strength
	HighPass = lerp(0.5, HighPass, Mask);

	// Clamp sharpening
	HighPass = Clamp!=1.0? clamp(HighPass, 1.0-Clamp, Clamp) : HighPass;

	float3 Sharpen = float3(
		Overlay(Source.r, HighPass),
		Overlay(Source.g, HighPass),
		Overlay(Source.b, HighPass)
	);

	return Preview? gamma(HighPass) : Sharpen;
}

/// CAMERA STAMPS
float4 PS_Logo(float4 pos : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET 
{
	float2 ar = f2Resolution.x > f2Resolution.y ? float2(f2Resolution.x / f2Resolution.y, 1.0) : float2(1.0, f2Resolution.y / f2Resolution.x);
	float2 corrected = ReShade::ScreenSize;
	
	float2 stretch = lerp(ReShade::ScreenSize * f2PixelSize / ar, corrected * ReShade::PixelSize, 1.0);

	float2 uv_Logo;

	uv_Logo = scale_uv(uv,stretch,float2(perfectCenter.x, 1.0 - perfectCenter.y));

	float4 original = tex2D(ReShade::BackBuffer, uv);
	float4 Logo;

	float fOVRAlpha=0.0;
	
	if (iLogoSet == 1) //VHS
	{
		if (kpageUp) Logo = tex2D(sVHSFull, uv_Logo);
		fOVRAlpha = 0.75;
	}
	
	if (iLogoSet == 2) //HeadCAM
	{
		if (kpageDown) Logo = tex2D(sHCLight, uv_Logo);
		if (kpageUp) Logo = tex2D(sHCFull, uv_Logo);
		fOVRAlpha = 0.8;
	}
	
	if (iLogoSet == 3) //BCam old
	{
		if (kpageUp) Logo = tex2D(sBCFull, uv_Logo);
		fOVRAlpha = 0.9;
	}
	
	if (iLogoSet == 4) //BCam new
	{
		if (kpageUp) Logo = tex2D(sBC2Full, uv_Logo);
		fOVRAlpha = 1.0;
	}
	
	if (iLogoSet == 5) //Motorola
	{
		if (kpageDown) Logo = tex2D(sMRLight, uv_Logo);
		if (kpageUp) Logo = tex2D(sMRFull, uv_Logo);
		fOVRAlpha = 0.8;
	}
	
	if (iLogoSet == 6) //Gpro
	{
		if (kpageDown) Logo = tex2D(sGPLight, uv_Logo);
		if (kpageUp) Logo = tex2D(sGPFull, uv_Logo);
		fOVRAlpha = 0.8;
	}
	
	if (iLogoSet == 7) //LiveLeak
	{
		if (kpageDown) Logo = tex2D(sLLLight, uv_Logo);
		if (kpageUp) Logo = tex2D(sLLFull, uv_Logo);
		fOVRAlpha = 0.75;
	}
	
	original = lerp(original, Logo, Logo.a * fOVRAlpha);
	
	if (bISNIGHT()) 
	{
		float4 LogoNightSet = tex2D(sNightSet, uv_Logo);
		original += lerp(0.0f, LogoNightSet, LogoNightSet.a * 0.75);
	}
	
	return original;
}

/// CAMERA CLOCKS
float4 ps_oClock( float4 vpos : SV_POSITION, float2 uv : TEXCOORD ) : SV_TARGET 
{
    
	float4 original = tex2D(ReShade::BackBuffer, uv);
		if (iLogoSet == 0) return original;
	
	
	float4 clockColor;
	float fClkAlpha;
	if (iLogoSet == 1) //VHS
	{
		if (kpageDown || kpageUp) clockColor = tex2D(sampDigitVHS, uv);
		fClkAlpha = 0.75 + 0.13;
	}
	if (iLogoSet == 2) //HeadCAM
	{
		if (kpageUp) clockColor = tex2D(sampDigitHC, uv);
		fClkAlpha = 0.8 + 0.08;
	}
	if (iLogoSet == 3) //BCam old
	{
		if (kpageDown || kpageUp) clockColor = tex2D(sampDigitsAxOG, uv);
		fClkAlpha = 0.9 + 0.055;
	}
	if (iLogoSet == 4) //BCam new
	{
		if (kpageDown || kpageUp) clockColor = tex2D(sampDigitsAxNG, uv);
		fClkAlpha = 1.0 + 0.098;
	}
	if (iLogoSet == 5) //Motorola
	{
		if (kpageDown || kpageUp) clockColor = tex2D(sampDigitGPM, uv);
		fClkAlpha = 0.8 + 0.05;
	}

	if (iLogoSet == 6) //Gpro
	{
		if (kpageDown || kpageUp) clockColor = tex2D(sampDigitGPM, uv);
		fClkAlpha = 0.8 + 0.1;
	}
	return lerp(0.0, clockColor, clockColor.a * fClkAlpha);
}


// VHS 

void PS_VHS5(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 OutGet3 : SV_Target)
{
    float4 origcolor4=tex2D(ReShade::BackBuffer, texcoord);
    
	if (!bUseVHS) OutGet3 = origcolor4;
	else {
	
	float magnitude = 0.0001;
   
    // Set up offset
    float2 offsetRedUV = texcoord;
    offsetRedUV.x = texcoord.x + rand(float2(ftimer2*0.03,texcoord.y*0.42)) * 0.001;
    offsetRedUV.x += sin(rand(float2(ftimer2*0.2, texcoord.y)))*magnitude;
   
    float2 offsetGreenUV = texcoord;
    offsetGreenUV.x = texcoord.x + rand(float2(ftimer2*0.004,texcoord.y*0.002)) * 0.004;
    offsetGreenUV.x += sin(ftimer2*9.0)*magnitude;
   
    float2 offsetBlueUV = texcoord;
    offsetBlueUV.x = texcoord.y;
    offsetBlueUV.x += rand(float2(cos(ftimer2.x*0.01),sin(texcoord.y)));
   
    // Load Texture
    float r = tex2D(ReShade::BackBuffer, offsetRedUV).r;
    float g = tex2D(ReShade::BackBuffer, offsetGreenUV).g;
    float b = tex2D(ReShade::BackBuffer, texcoord).b;
   

    OutGet3 = lerp(origcolor4,float4(r,g,b,1.0),fVHSmix);
    }
}

// SKY EXPOSURE 

float3 PS_skyExposure(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	float3 lut3D = color*(LUT_BLOCK_SIZE-1);
	float2 lut2D[2];
		lut2D[0].x = floor(lut3D.z)*LUT_BLOCK_SIZE+lut3D.x;
		lut2D[0].y = lut3D.y;
		lut2D[1].x = ceil(lut3D.z)*LUT_BLOCK_SIZE+lut3D.x;
		lut2D[1].y = lut3D.y;

	lut2D[0] = (lut2D[0]+0.5)*LUT_PIXEL_SIZE;
	lut2D[1] = (lut2D[1]+0.5)*LUT_PIXEL_SIZE;

	float3 CtrstDLut = lerp(
		tex2D(CtrstDownLUTSampler, lut2D[0]).rgb, // Front Z
		tex2D(CtrstDownLUTSampler, lut2D[1]).rgb, // Back Z
		frac(lut3D.z)
	);


	color = lerp(color, CtrstDLut, fCtrstDown);

	if (USE_ENV && !bISNIGHT()) 
	{
		float depth = LDepth(texcoord);
		float skyDepth = linearDepth(depth, 0.5f, SkyDistance);
		
		float3 colorSky = color;

		colorSky = lerp(color,pow(color, 1.0/2.2), skyExposure*0.75);
		colorSky.b = lerp(colorSky.b, pow(colorSky.b,0.88),skyExposure);

		float DarkColorThreshold = (skyColorThreshold/255.0)+0.0001;
		float mix = dot(color.rgb, 0.333333);
		float mask = 1.0;
		mask = lerp(0.0, lerp(0.0,1.0,smoothstep(DarkColorThreshold-(DarkColorThreshold*0.2),DarkColorThreshold+(DarkColorThreshold*0.2),mix)), skyDepth);

		color = lerp(color, colorSky, mask);
		
		/// BLACK POINT
		if (fBlackPointDepth != 0.0)
		{
			float3 blackColor = lerp(color, pow(color,1.4), abs(fBlackPointDepth)*0.005);
			blackColor = blackColor * (255.0 / (255 - fBlackPointDepth)) - ((fBlackPointDepth / 255.0) *  (255.0 / (255 - fBlackPointDepth)));
			float Grayscale = dot(blackColor, Luma709);
			blackColor = saturate(lerp(Grayscale, blackColor, 1 + abs(fBlackPointDepth)*0.002));
			
			color = lerp(color, blackColor, saturate(pow(LDepth(texcoord),DepthFogPow)));	
		}
	}
	// Debug
	if (bShowDepth) color = pow(LDepth(texcoord),DepthFogPow);
	return color;
}

float GetInternalResModifier()
{ 
	float fFisheyeDistortionModifier;
	float fFisheyeDistortionCubicModifier;
	float fLensZoomCompensation;
	
	if (bUseLensDistortion) 
	{
		if (bUseInterlaced || bLensDistPerfectFit) 
		{
			fFisheyeDistortionModifier = saturate(lerp(0.0,0.135f,fFisheyeDistortion));
			fFisheyeDistortionCubicModifier = saturate(lerp(0.0,0.075f,fFisheyeDistortionEdges));
		}
		else 
		{
			fFisheyeDistortionModifier = saturate(lerp(0.0,0.115f,fFisheyeDistortion));
			fFisheyeDistortionCubicModifier = saturate(lerp(0.0,0.055f,fFisheyeDistortionEdges));
		}
		
		fLensZoomCompensation = fFisheyeDistortionModifier - fFisheyeDistortionCubicModifier;
	}
	else fLensZoomCompensation = 0.0;
	
	float fResModifier;
	
	if (BUFFER_HEIGHT >= 1440) 
		{
			if (iInternalRes == 0) fResModifier = 1.0; // 1440p
			if (iInternalRes == 1) fResModifier = 0.75; // 1080p
			if (iInternalRes == 2) fResModifier = 0.5; // 720p
			if (iInternalRes == 3) fResModifier = 0.362; // 520p
			if (iInternalRes == 4) fResModifier = 0.334; // 480p
		}
	
	if (BUFFER_HEIGHT < 1440)
		{
			if (iInternalRes == 0) fResModifier = 1.0; // 1440p
			if (iInternalRes == 1) fResModifier = 1.0; // 1080p
			if (iInternalRes == 2) fResModifier = 0.667; // 720p
			if (iInternalRes == 3) fResModifier = 0.482; // 520p
			if (iInternalRes == 4) fResModifier = 0.445; // 480p
		}
		
	return saturate(fResModifier+fLensZoomCompensation);

}

float3 PS_ResolutionDown (float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color;
	if (!bColorDistortion) return tex2D(ReShade::BackBuffer, texcoord).rgb;
	
	else 
	{
		float2 xCoord = texcoord-0.5;
		xCoord /= GetInternalResModifier();
		xCoord += 0.5;
		
		color = tex2D(ReShade::BackBuffer, xCoord).rgb;
	}
	
	return color;
}

float3 PS_ResolutionUp (float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color;
	if (!bColorDistortion) return tex2D(ReShade::BackBuffer, texcoord).rgb;
	
	else 
	{

		float2 xCoord = texcoord-0.5;
		xCoord *= GetInternalResModifier();
		xCoord += 0.5;
		
		color = tex2D(ReShade::BackBuffer, xCoord).rgb;
	}
	
	return color;
}


// INTERLACED 

void PS_InterlacedTargetPass(float4 vpos : SV_Position, float2 UvCoord : TEXCOORD,out float4 Target : SV_Target)
{
	if (bUseInterlaced) {
	// Interlaced rows boolean
	bool OddPixel = frac(int(ReShade::ScreenSize.y * UvCoord.y) * 0.5) != 0.0;
	bool OddFrame = frac(FrameCount * 0.5) != 0.0;
	bool BottomHalf = UvCoord.y > 0.5;

	// Flip flop saving texture between top and bottom half of the RenderTarget
	float2 Coordinates;
	Coordinates.x = UvCoord.x;
	Coordinates.y = UvCoord.y * 2.0;
	// Adjust flip flop coordinates
	float hPixelSizeY = ReShade::PixelSize.y * 0.5;
	Coordinates.y -= BottomHalf ? 1.0 + hPixelSizeY : hPixelSizeY;
	// Flip flop save to Render Target texture
	Target = (OddFrame ? BottomHalf : UvCoord.y < 0.5) ?
		float4(tex2D(ReShade::BackBuffer, Coordinates).rgb, 1.0) : 0.0;
	// Outputs raw BackBuffer to InterlacedTargetBuffer for the next frame
	}
	else Target = tex2D(ReShade::BackBuffer, UvCoord);
}

void PS_Interlaced(float4 vpos : SV_Position, float2 UvCoord : TEXCOORD,out float3 Image : SV_Target)
{
	if (bUseInterlaced) {
	// Interlaced rows boolean
	bool OddPixel = frac(int(ReShade::ScreenSize.y * UvCoord.y) * 0.5) != 0.0;
	bool OddFrame = frac(FrameCount * 0.5) != 0.0;
	// Calculate coordinates of BackBuffer texture saved at previous frame
	float2 Coordinates = float2(UvCoord.x, UvCoord.y * 0.5);
	float qPixelSizeY = ReShade::PixelSize.y * 0.25;
	Coordinates.y += OddFrame ? qPixelSizeY : qPixelSizeY + 0.5;
	// Sample odd and even rows
	Image = OddPixel ? tex2D(ReShade::BackBuffer, UvCoord).rgb
	: tex2D(InterlacedBufferSampler, Coordinates).rgb;
	}
	else Image = tex2D(ReShade::BackBuffer, UvCoord).rgb;
}

///////////////////////////////////////////////////////////////////////////////////////////////
uniform float2 fRandomVert < source = "pingpong"; min = 1; max = 3; step = 0.5; smoothing = 0.0; >;
uniform float2 fRandomHori < source = "pingpong"; min = 0; max = 2; step = 1; smoothing = 0.0; >;

uniform float2 fRandomIntensity < source = "pingpong"; min = 1; max = 10; step = 0.3; smoothing = 0.0; >;
//uniform int iRandom_value < source = "random"; min = 0; max = 40; >;

#define shake_duration 	fShakeDuration.x
#define shake_often 	fShakeDuration.y

void PS_LensShake(float4 position : SV_Position, float2 tex : TEXCOORD, out float4 col : SV_Target) 
{
	bool isInMotion;
	
	if (iKBD == 0) isInMotion = kStrafeLeftUS || kStrafeRight || kStrafeForwardUS || kStrafeBack;
	if (iKBD == 1) isInMotion = kStrafeLeft || kStrafeRight || kStrafeForward || kStrafeBack;
	if (DEVBUILD) isInMotion = RightMouseDown || kStrafeLeft || kStrafeRight || kStrafeBack;
		

	if (!isInMotion || !USE_LensShake || kDel) col = tex2D(ReShade::BackBuffer, tex);
	else
	{
		float shake_size;
		if (DEVBUILD) shake_size = lerp(fShakeAmplitude.x*0.01, fShakeAmplitude.x*0.02, RightMouseDown || kStrafeForward || kStrafeForwardUS || kStrafeBack);
			else shake_size = lerp(fShakeAmplitude.x*0.01, fShakeAmplitude.x*0.02, kStrafeForward || kStrafeForwardUS || kStrafeBack);
		
		float trans_size = lerp(fShakeAmplitude.y*0.5, fShakeAmplitude.y*2.0, kStrafeLeft || kStrafeLeftUS || kStrafeRight); 
	
		float fShake_Vert;
		if (bUseRandom) fShake_Vert =shake_size*(fRandomIntensity*0.1);
			else fShake_Vert = shake_size;
		
		float shake_freq=fShakeFrequency.x;
		float trans_freq=fShakeFrequency.y;
		
		if (bUseRandom) shake_freq*=fRandomVert;
		if (bUseRandom) trans_freq*=fRandomHori;
		
		float2 uv = tex / f2Resolution;
		uv *= (1.0 - 2.0 * max(fShake_Vert, trans_size * fShake_Vert));

		float t = clamp(mod(ftimer2, shake_often), 0.0, shake_duration) / shake_duration;
		
		float shake_magnitude = fShake_Vert * sin(shake_freq * 2.0*3.14159*t) * (t+0.5)*t*t*(t-1.0)*(t-1.0)*15.5;
		float2 shake_direction = normalize(float2(0.0, 1.0));
		uv += shake_direction * shake_magnitude;
		
		float2 shake_transverse = float2(-shake_direction.y, shake_direction.x);
		float trans_magnitude = trans_size * fShake_Vert * sin(trans_freq * 2.*3.14159*t) * -t*(t-1.);
		uv += trans_magnitude * shake_transverse;

		col = tex2D(ReShade::BackBuffer, tex+uv);

	}

}


	//////////////////////////////////////////////////
	//
	// TECHNIQUES
	//
	//////////////////////////////////////////////////
technique RECORDED
{
	//SKYLIGHT
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_skyExposure;
	}

	///LENS
	//LENS HAZE	
	pass AL_DetectInt
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_AL_DetectInt;
		RenderTarget = detectIntTex;
	}
	pass AL_DetectLow
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_AL_DetectLow;
		RenderTarget = detectLowTex;
	}

	pass AL_DetectHigh
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_AL_DetectHigh;
		RenderTarget = alInTex;
	}

#define PASS_AL_H(i) \
	pass AL_H##i \
	{ \
		VertexShader = PostProcessVS; \
		PixelShader = PS_AL_HGB; \
		RenderTarget = alOutTex; \
	}
#define PASS_AL_V(i) \
	pass AL_V##i \
	{ \
		VertexShader = PostProcessVS; \
		PixelShader = PS_AL_VGB; \
		RenderTarget = alInTex; \
	}

	PASS_AL_H(1)
	PASS_AL_V(1)
	PASS_AL_H(2)
	PASS_AL_V(2)
	PASS_AL_H(3)
	PASS_AL_V(3)
	PASS_AL_H(4)
	PASS_AL_V(4)
	PASS_AL_H(5)
	PASS_AL_V(5)
	PASS_AL_H(6)
	PASS_AL_V(6)
	PASS_AL_H(7)
	PASS_AL_V(7)
	PASS_AL_H(8)
	PASS_AL_V(8)
	PASS_AL_H(9)
	PASS_AL_V(9)
	PASS_AL_H(10)
	PASS_AL_V(10)
	PASS_AL_H(11)
	PASS_AL_V(11)
	PASS_AL_H(12)
	PASS_AL_V(12)

	pass AL_Magic
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_AL_Magic;
	}

	//VIGNETTE
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Vignette;
	}

	//LENS BLUR
	pass BlurPrePass1
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_GaussianBlur_PrePass1;
		RenderTarget = GaussianBlur_PrePassTex;
	}
	pass BlurPrePassFinal
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_GaussianBlur_PrePassFinal;
	}
	
	// LENS SHARP
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_LumaSharpenPrePass;
	}

	//DOF
	pass DetermineCurrentFocus { VertexShader = PostProcessVS; PixelShader = PS_DetermineCurrentFocus; RenderTarget = texCDCurrentFocus; }
	pass CopyCurrentFocus { VertexShader = PostProcessVS; PixelShader = PS_CopyCurrentFocus; RenderTarget = texCDPreviousFocus; }
	pass CalculateCoC { VertexShader = VS_Focus; PixelShader = PS_CalculateCoCValues; RenderTarget = texCDCoC; }
	pass CoCTile1 { VertexShader = PostProcessVS; PixelShader = PS_CoCTile1; RenderTarget = texCDCoCTileTmp; }
	pass CoCTile2 { VertexShader = PostProcessVS; PixelShader = PS_CoCTile2; RenderTarget = texCDCoCTile; }
	pass CoCTileNeighbor { VertexShader = PostProcessVS; PixelShader = PS_CoCTileNeighbor; RenderTarget = texCDCoCTileNeighbor; }
	pass CoCBlur1 { VertexShader = PostProcessVS; PixelShader = PS_CoCGaussian1; RenderTarget = texCDCoCTmp1; }
	pass CoCBlur2 { VertexShader = PostProcessVS; PixelShader = PS_CoCGaussian2; RenderTarget = texCDCoCBlurred; }
	pass PreBlur { VertexShader = VS_DiscBlur; PixelShader = PS_PreBlur; RenderTarget = texCDBuffer1; }
	pass BokehBlur { VertexShader = VS_DiscBlur; PixelShader = PS_BokehBlur; RenderTarget = texCDBuffer2; }
	pass NearBokehBlur { VertexShader = VS_DiscBlur; PixelShader = PS_NearBokehBlur; RenderTarget = texCDBuffer1; }
	pass TentFilter { VertexShader = PostProcessVS; PixelShader = PS_TentFilter; RenderTarget = texCDBuffer3; }
	pass Combiner { VertexShader = PostProcessVS; PixelShader = PS_Combiner; RenderTarget = texCDBuffer4; }
	pass PostSmoothing1 { VertexShader = PostProcessVS; PixelShader = PS_PostSmoothing1; RenderTarget = texCDBuffer5; }
	pass PostSmoothing2AndFocusing { VertexShader = VS_Focus; PixelShader = PS_PostSmoothing2AndFocusing;}

	//LENS MOTION
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_LensShake;
	}
	
	//RATIO
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_AspectRatio;
	}
	
	//LENS
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_FISHEYE_CA;
	}

	//VHS
	pass VHSDistort 
	{ 
		VertexShader = PostProcessVS; 
		PixelShader = PS_VHS5; 
	}
	
	///CAMERA
	//COLOR BALANCE
	pass prod80_pass0
        {
            VertexShader       = PostProcessVS;
            PixelShader        = PS_WriteColor;
            RenderTarget       = texColor;
        }
        pass prod80_pass1
        {
            VertexShader       = PostProcessVS;
            PixelShader        = PS_MinMax_1;
            RenderTarget0      = texDS_1_Min;
            RenderTarget1      = texDS_1_Max;
            RenderTarget2      = texDS_1_Mid;
        }
        pass prod80_pass2
        {
            VertexShader       = PostProcessVS;
            PixelShader        = PS_MinMax_1x1;
            RenderTarget       = texDS_1x1;
        }
        pass prod80_pass3
        {
            VertexShader       = PostProcessVS;
            PixelShader        = PS_RemoveTint;
        }
        pass prod80_pass4
        {
            VertexShader       = PostProcessVS;
            PixelShader        = PS_StorePrev;
            RenderTarget       = texPrevious;
        }
		
	// TONEMAPPER	
	pass GetSmall
	{
		VertexShader = PostProcessVS;
		PixelShader = GetSmallPS;
		RenderTarget = SmallTex;
	}
	pass SaveAdapt
	{
		VertexShader = PostProcessVS;
		PixelShader = SaveAdaptPS;
		RenderTarget = LastAdaptTex;
	}
	pass Main
	{
		VertexShader = TonemapperACESVST;
		PixelShader = PS_TonemapperACES;
		SRGBWriteEnable = true;
	}
	
	// LUTS
	pass CC
	{
		VertexShader = PostProcessVS;
		PixelShader = CCLUT;
	}

	//STAMPS & Clock
	pass 
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Logo;
	}
	pass 
	{
        PrimitiveTopology   = TRIANGLESTRIP;
        VertexCount         = 100;
        VertexShader        = vs_Clock;
        PixelShader         = ps_oClock;
        SRGBWriteEnable 	= true;
		ClearRenderTargets 	= false;
		BlendEnable         = true;
		BlendOp = ADD;
        SrcBlend           	= SRCALPHA;
		DestBlend 			= INVSRCALPHA;
       }

	//DOWNSCALE
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_ResolutionDown;
	}

	///POST PROCESSING
	// ENCODING
	pass
	{
        VertexShader=PostProcessVS;
        PixelShader=PS_ColorBanding;
    }
	pass JPEG_Base 
	{
        VertexShader=PostProcessVS;
        PixelShader=PS_JPEG1;
		RenderTarget=JPEG0_tex;
    }
	pass JPEG_Final 
	{
        VertexShader=PostProcessVS;
        PixelShader=PS_JPEG2;
    }
	
	//INTERLACED
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_InterlacedTargetPass;
		RenderTarget = InterlacedTargetBuffer;
		ClearRenderTargets = false;
		BlendEnable = true;
		BlendOp = ADD;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
	}
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Interlaced;
	}
	
	//UPSCALE
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_ResolutionUp;
	}

	// DIRECTIONAL BLUR & CA
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_SensorCA;
	}

	// GAUSS POST PASS
	pass BlurPostPass1
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_GaussianBlur_PostPass1;
		RenderTarget = GaussianBlur_PostPassTex;
	}
	pass BlurPostPassFinal
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_GaussianBlur_PostPassFinal;
	}
	//SENSOR SHARP
		pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_FilmicSharpen;
		SRGBWriteEnable = true;
	}
	//PIXEL SHARP
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_LumaSharpenPassDetails;
	}

}
