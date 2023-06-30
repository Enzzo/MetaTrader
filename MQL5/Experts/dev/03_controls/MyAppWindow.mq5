//+------------------------------------------------------------------+
//|                                                  MyAppWindow.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property description "Приложение MyAppWindow на основе класса CMyAppDialog"
#property description "Добавлены кнопки для установки цвета фона и заголовка"

#include "MyAppDialog.mqh"
#include <Controls\Button.mqh>

#define XRGB(r, g, b)   ((uchar(r)<<16)|(uchar(g)<<8)|uchar(b))
#define GETRGB(clr)     ((clr) & 0xFFFFFFFF)

#define INDENT_LEFT         (11)
#define INDENT_TOP          (11)
#define CONTROLS_GAP_X      (5)
#define BUTTON_WIDTH        (100)
#define BUTTON_HEIGHT       (20)

CMyAppDialog AppDialog;
CButton m_button1;
CButton m_button2;

bool CreateBackButton();
bool CreateCaptionButton();
color GetRandomColor();

int OnInit(){
    if(!AppDialog.Create(0, "My App Dialog", 0, 10, 10, 300, 200)){
        return (INIT_FAILED);
    }
    if(!CreateBackButton()){
        return (INIT_FAILED);
    }
    if(!CreateCaptionButton()){
        return (INIT_FAILED);
    }
    AppDialog.Run();
    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
    AppDialog.Destroy(reason);
}

void OnChartEvent(  const int id,
                    const long& lparam,
                    const double& dparam,
                    const string& sparam){
    if(StringFind(sparam, "Back") == 0 && id == (CHARTEVENT_OBJECT_CLICK)){
        PrintFormat("sparam = %s", sparam);
        AppDialog.ColorBackground(GetRandomColor());
    }
    if(StringFind(sparam, "Caption") == 0 && id == (CHARTEVENT_OBJECT_CLICK)){
        PrintFormat("sparam = %s", sparam);
        AppDialog.ColorCaption(GetRandomColor());
    }
    AppDialog.ChartEvent(id, lparam, dparam, sparam);
}

bool CreateBackButton(){
    int x1 = INDENT_LEFT;
    int y1 = INDENT_TOP;
    int x2 = x1 + BUTTON_WIDTH;
    int y2 = y1 + BUTTON_HEIGHT;

    if(!m_button1.Create(0, "Back", 0, x1, y1, x2, y2)){
        return (false);
    }
    if(!m_button1.Text("Back")){
        return (false);
    }
    if(!AppDialog.Add(m_button1)){
        return (false);
    }
    return (true);
}

bool CreateCaptionButton(){
    int x1=INDENT_LEFT+BUTTON_WIDTH+CONTROLS_GAP_X;     // x1 = 11  + 2 * (100 + 5) = 221 pixels
    int y1=INDENT_TOP;                                  // y1                       = 11  pixels
    int x2=x1+BUTTON_WIDTH;                             // x2 = 221 + 100           = 321 pixels
    int y2=y1+BUTTON_HEIGHT; 

    if(!m_button2.Create(0, "Caption", 0, x1, y1, x2, y2)){
        return (false);
    }
    if(!m_button2.Text("Caption")){
        return (false);
    }
    if(!AppDialog.Add(m_button2)){
        return (false);
    }
    return (true);
}

color GetRandomColor(){
    return (color)GETRGB(XRGB(rand()%255, rand()%255, rand()%255));
}