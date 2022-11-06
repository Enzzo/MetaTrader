//+------------------------------------------------------------------+
//|                                                        TABLE.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

input string comment = "Количество баров: ";//Количество баров
input int monthBars =   1; //месяца
input int weekBars  =   1; //недели
input int dayBars   =  10; //дни
input color clr     = clrBlack; //Цвет

int OnInit(){
   DeleteObjects();
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
   
   int arm = AvrRange(PERIOD_MN1, monthBars);
   int arw = AvrRange(PERIOD_W1,  weekBars );
   int ard = AvrRange(PERIOD_D1,  dayBars  );
   
   int sm = Spread(PERIOD_MN1);
   int sw = Spread(PERIOD_W1 );
   int sd = Spread(PERIOD_D1 );
   
   SetLabel("TABLE0", "месяц",              clr, 100, 10, 0, 9);
   SetLabel("TABLE1", "неделя",             clr, 150, 10, 0, 9);
   SetLabel("TABLE2", "день",               clr, 210, 10, 0, 9);
   SetLabel("TABLE3", "ср. диаппазон",      clr, 10,  30, 0, 9);
   SetLabel("TABLE4", "пройдено",           clr, 30,  50, 0, 9);
   SetLabel("TABLE5", IntegerToString(arm), clr, 105, 30 ,0, 9);
   SetLabel("TABLE6", IntegerToString(arw), clr, 160, 30 ,0, 9);
   SetLabel("TABLE7", IntegerToString(ard), clr, 210, 30 ,0, 9);
   SetLabel("TABLE8", IntegerToString(sm),  sm > 0 ? clrGreen : clrRed, 105, 50, 0, 9);
   SetLabel("TABLE9", IntegerToString(sw),  sw > 0 ? clrGreen : clrRed, 160, 50, 0, 9);
   SetLabel("TABLE10",IntegerToString(sd),  sd > 0 ? clrGreen : clrRed, 210, 50, 0, 9);
   return(rates_total);
}

void deinit() {
  DeleteObjects();
}


void SetLabel(string nm, string tx, color cl, int xd, int yd, int cr=0, int fs=9) {
  if (ObjectFind(nm)<0) ObjectCreate(nm, OBJ_LABEL, 0, 0,0);
  ObjectSetText(nm, tx, fs);
  ObjectSet(nm, OBJPROP_COLOR    , cl);
  ObjectSet(nm, OBJPROP_XDISTANCE, xd);
  ObjectSet(nm, OBJPROP_YDISTANCE, yd);
  ObjectSet(nm, OBJPROP_CORNER   , cr);
  ObjectSet(nm, OBJPROP_FONTSIZE , fs);
}

void DeleteObjects() {
  string st="TABLE";
  int    i;

  for (i=0; i<11; i++)ObjectDelete(st+IntegerToString(i));
}

int AvrRange(ENUM_TIMEFRAMES period, int count){
   MqlRates rates[];
   CopyRates(Symbol(), period, 1, count, rates);
   if(ArraySize(rates) < count)
      return 0;
      
   double sum = 0.0;
   
   for(int i = 0; i < count; i++){
      sum += rates[i].high - rates[i].low;
   }
   
   return (int)(sum/count/Point());  
}

int Dist(ENUM_TIMEFRAMES period, int count){
   MqlRates rates[];
   CopyRates(Symbol(), period, 0, count, rates);
   if(ArraySize(rates) < count)
      return 0;
   
   double dist = rates[count-1].close - rates[0].open;
   
   return (int)(dist/Point());
}

int Spread(ENUM_TIMEFRAMES period){
   MqlRates rates[];
   CopyRates(Symbol(), period, 0, 1, rates);
   if(ArraySize(rates) < 1)
      return 0;
   
   double spread = 0.0;
   
   if(rates[0].close > rates[0].open)
      spread = rates[0].high - rates[0].low;
   else
      spread = rates[0].low - rates[0].high;
   
   return (int)(spread/Point());
}