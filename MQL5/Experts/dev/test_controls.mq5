//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#include <Controls\Defines.mqh>

#undef CONTROLS_FONT_NAME
#undef CONTROLS_FONT_SIZE

#undef CONTROLS_BUTTON_COLOR
#undef CONTROLS_BUTTON_COLOR_BG
#undef CONTROLS_BUTTON_COLOR_BORDER

#undef CONTROLS_DIALOG_COLOR_BORDER_LIGHT
#undef CONTROLS_DIALOG_COLOR_BORDER_DARK
#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CAPTION_TEXT
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BORDER

input string font_name                 = "Trebuchet MS";
input int   font_size                  = 10;

input color button_color               = C'0x3B,0x29,0x28';
input color button_color_bg            = C'0xDD,0xE2,0xEB';
input color button_color_border        = C'0xB2,0xC3,0xCF';

input color dialog_color_border_light  = White;
input color dialog_color_border_dart   = C'0xB6,0xB6,0xB6';
input color dialog_color_bg            = C'0xF0,0xF0,0xF0';
input color dialog_color_caption_text  = C'0x28,0x29,0x3B';
input color dialog_color_client_bg     = C'0xF7,0xF7,0xF7';
input color dialog_color_client_border = C'0xC8,0xC8,0xC8';

#define CONTROLS_FONT_NAME                   font_name
#define CONTROLS_FONT_SIZE                   font_size

#define CONTROLS_BUTTON_COLOR                button_color
#define CONTROLS_BUTTON_COLOR_BG             button_color_bg
#define CONTROLS_BUTTON_COLOR_BORDER         button_color_border

#define CONTROLS_DIALOG_COLOR_BORDER_LIGHT   dialog_color_border_light
#define CONTROLS_DIALOG_COLOR_BORDER_DARK    dialog_color_border_dart
#define CONTROLS_DIALOG_COLOR_BG             dialog_color_bg
#define CONTROLS_DIALOG_COLOR_CAPTION_TEXT   dialog_color_caption_text
#define CONTROLS_DIALOG_COLOR_CLIENT_BG      dialog_color_client_bg
#define CONTROLS_DIALOG_COLOR_CLIENT_BORDER  dialog_color_client_border

#include <Controls\Dialog.mqh>

CAppDialog AppWindow;

int OnInit(){

   if(!AppWindow.Create(0, "Lot By Risk", 0, 20, 20, 360, 324)){
      return (INIT_FAILED);
   }

   int total = AppWindow.ControlsTotal();
   CWndClient* myclient;
   for(int i = 0; i < total; ++i){
      CWnd* obj = AppWindow.Control(i);
      string name = obj.Name();
      PrintFormat("%d is %s", i, name);

      if(StringFind(name, "Client") > 0){
         CWndClient *client = (CWndClient*)obj;
         client.ColorBackground(clrRed);
         myclient=client;
         Print("client.ColorBackground(clrRed);");
         ChartRedraw();
      }
      if(StringFind(name, "Back") > 0){
         CPanel* panel = (CPanel*)obj;
         panel.ColorBackground(clrGreen);
         Print("panel.ColorBackground(clrGreen)");
         ChartRedraw();
      }
   }

   Sleep(5000);
   myclient.Destroy();

   AppWindow.Run();
   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   AppWindow.Destroy(reason);
}

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
   AppWindow.ChartEvent(id, lparam, dparam, sparam);
}