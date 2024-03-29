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
#include <Controls\Button.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>

#define INDENT_LEFT     (11)
#define INDENT_TOP      (11)
#define CONTROLS_GAP_X  (5)
#define BUTTON_WIDTH    (100)
#define BUTTON_HEIGHT   (20)

class CAppWindowTwoButtons : public CAppDialog{
private:
   CButton m_button1;
   CButton m_button2;

protected:
   CPositionInfo  m_position;
   CTrade         m_trade;
   CAccountInfo   m_account;

public:
   CAppWindowTwoButtons();
   ~CAppWindowTwoButtons();

   virtual bool Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2) override;
   virtual bool OnEvent(const int id, const long &lparam, const double &dparam, const string& sparam) override;

protected:
   bool CreateButton1();
   bool CreateButton2();

   void OnClickButton1();
   void OnClickButton2();

   virtual void Minimize() override;
};

// CAppDialog AppWindow;
CAppWindowTwoButtons AppWindow;
CButton m_button1;
CButton m_button2;

int OnInit(){

   if(!AppWindow.Create(0, "Lot By Risk", 0, 20, 20, 360, 324)){
      return (INIT_FAILED);
   }

   // if(!CreateButton1()){
   //    return (false);
   // }
   // if(!CreateButton2()){
   //    return (false);
   // }

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


EVENT_MAP_BEGIN(CAppWindowTwoButtons)
   ON_EVENT(ON_CLICK, m_button1, OnClickButton1)
   ON_EVENT(ON_CLICK, m_button2, OnClickButton2)
EVENT_MAP_END(CAppDialog)

CAppWindowTwoButtons::CAppWindowTwoButtons(){};

CAppWindowTwoButtons::~CAppWindowTwoButtons(){};

bool CAppWindowTwoButtons::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2){
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2)){
      return (false);
   }
   if(!CreateButton1()){
      return (false);
   }
   if(!CreateButton2()){
      return (false);
   }
   return (true);
}

bool CAppWindowTwoButtons::CreateButton1(){
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP;
   int x2 = x1 + BUTTON_WIDTH;
   int y2 = y1 + BUTTON_HEIGHT;
   string prefix = Name();

   if(!m_button1.Create(0, prefix + "Button1", 0, x1, y1, x2, y2)){
      return false;
   }
   if(!m_button1.Text("Open BUY")){
      return false;
   }
   if(!Add(m_button1)){
      return (false);
   }

   return (true);
}

bool CAppWindowTwoButtons::CreateButton2(){
   int x1 = INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1 = INDENT_TOP;
   int x2 = x1 + BUTTON_WIDTH;
   int y2 = y1 + BUTTON_HEIGHT;
   
   string prefix = Name();

   if(!m_button2.Create(0, prefix + "Button2", 0, x1, y1, x2, y2)){
      return (false);
   }
   if(!m_button2.Text("Close")){
      return (false);
   }
   if(!Add(m_button2)){
      return (false);
   }
   
   return (true);
}

void CAppWindowTwoButtons::Minimize(){
   //--- переменная для получения панели быстрой торговли
   long one_click_visible = -1;  // 0 - панели быстрой торговли нет
   if(!ChartGetInteger(m_chart_id, CHART_SHOW_ONE_CLICK, 0, one_click_visible)){
      Print(__FUNCTION__, " Error Code = ", GetLastError());
   }

   //--- минимальный отступ для свёрнутой панели приложения
   int min_y_indent = 28;
   if(one_click_visible){
      min_y_indent = 100; // отступ, если быстрая торговля показана на графике
   }

   //--- получим текущий отступ для свёрнутой панели приложения
   int current_y_top = m_min_rect.top;
   int current_y_bottom = m_min_rect.bottom;
   int height = current_y_bottom - current_y_top;

   //--- вычислим новый минимальный отступ от верха для свёрнутой панели приложения
   if(m_min_rect.top != min_y_indent){
      m_min_rect.top = min_y_indent;
      //--- сместим так же нижнюю границу свернутой иконки
      m_min_rect.bottom = m_min_rect.top + height;
   }

   //--- теперь можно вызвать метод базового класса
   CAppDialog::Minimize();
}

void CAppWindowTwoButtons::OnClickButton1(){
   if(m_account.TradeMode() == ACCOUNT_TRADE_MODE_DEMO){
      m_trade.Buy(.01);
   }
}

void CAppWindowTwoButtons::OnClickButton2(){
   if(m_account.TradeMode() == ACCOUNT_TRADE_MODE_DEMO){
      for(int i = PositionsTotal() - 1; i >= 0; --i){
         if(m_position.SelectByIndex(i)){
            if(m_position.Symbol() == Symbol()){
               m_trade.PositionClose(m_position.Ticket());
            }
         }
      }
   }
}