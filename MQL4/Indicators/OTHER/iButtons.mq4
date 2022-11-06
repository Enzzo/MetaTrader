//+------------------------------------------------------------------+
//|                                                     iButtons.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

bool ButtonCreate(const long              chart_ID = 0,
                  const string            name = "Button",
                  const int               sub_window = 0,
                  const int               x = 1,
                  const int               y = 1,
                  const int               width = 18,
                  const int               height = 18,
                  const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER,
                  const string            text = "Button",
                  const string            font = "Arial",
                  const int               font_size = 10,
                  const color             clr = clrBlack,
                  const color             fill_clr = C'236,233,216',
                  const color             border_clr = clrNONE,
                  const bool              state = false,
                  const bool              back = false,
                  const bool              selection = false,
                  const bool              hidden = true,
                  const long              z_order = 0){
                  
   ResetLastError();
   
   if(!ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window,0,0)){
      Print(__FUNCTION__, ": не удалось создать кнопку! Код ошибки = ",GetLastError());
      return false;
   }
   
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, fill_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
   
   return true;

}

int OnInit(){

   ButtonCreate();
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
  
  
   return(rates_total);
}

void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name = NULL;
   
   for(int i = 0; i < total; i++){
      name = ObjectName(i);
      ObjectDelete(name);
   }
   
}
  
