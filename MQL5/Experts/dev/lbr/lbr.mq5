#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo/"
#property version   "1.07"

#property description "The Lot by Risk trading panel is designed for manual trading."
#property description "This is an alternative means for sending orders."
#property description "The first feature of the panel is convenient placing of orders using control lines."
#property description "The second feature is the calculation of the order volume for a given risk and the presence of a stop loss line."

#include <Controls\Defines.mqh>

input int         MAGIC       = 111087;            // magic
input string      COMMENT     = "";                // comment
input int         FONT        = 7;
input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER; // base corner
input int         X_OFFSET    = 20;                // X - offset
input int         Y_OFFSET    = 20;                // Y - offset
input string      HK_TP       = "T";               // hotkey for TP
input string      HK_SL       = "S";               // hotkey for SL
input string      HK_PR       = "P";               // hotkey for PRICE
input color       L_TP        = clrGreen;        // take profit line color
input color       L_SL        = clrRed;          // stop loss line color
input color       L_PR        = clrOrange;       // price open line color
input int         SLIPPAGE    = 5;                 // slippage
input double      RISK        = 1.00;              // risk
input double      COMISSION   = 0.0;               // comission

#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG

#undef CONTROLS_DIALOG_COLOR_BORDER_LIGHT  
#undef CONTROLS_DIALOG_COLOR_BORDER_DARK   
#undef CONTROLS_DIALOG_COLOR_CLIENT_BORDER

#define CONTROLS_DIALOG_COLOR_BG             C'87,173,202'
#define CONTROLS_DIALOG_COLOR_CLIENT_BG      C'87,173,202'

#define CONTROLS_DIALOG_COLOR_BORDER_LIGHT  clrBlack
#define CONTROLS_DIALOG_COLOR_BORDER_DARK   C'0x00,0x00,0x00'
#define CONTROLS_DIALOG_COLOR_CLIENT_BORDER C'0x00,0x00,0x00'

#include <dev/lbr/lbr_view.mqh>

#define PANEL_WIDTH  110
#define PANEL_HEIGHT 108

LbrInputs inputs = {
    0, "LBR", 0, X_OFFSET, Y_OFFSET, PANEL_WIDTH, PANEL_HEIGHT, CORNER, FONT, DoubleToString(RISK, 2), COMMENT
};

LbrView lbr_view;

int OnInit(){

    lbr_view.Create(inputs);

    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
    lbr_view.Destroy(reason);
}

void OnTick(){
    lbr_view.Run();
}