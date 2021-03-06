//+------------------------------------------------------------------+
//|                                                    iLarryTDW.mq4 |
//|                                                           Sergey |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window

string pref = "TDW";
input int days = 360;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   DeleteObject(pref);
//---
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   DeleteObject(pref);
   Comment("");
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &_time[],
                const double &_open[],
                const double &high[],
                const double &low[],
                const double &_close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
   
   static datetime pTime = 0;
   static datetime cTime[1];
   CopyTime(Symbol(), PERIOD_D1, 0, 1, cTime);
   
   if(pTime != cTime[0]){
      DeleteObject(pref);
      MqlDateTime t;
      
      int rMON = 0.0;
      int rTUE = 0.0;
      int rWED = 0.0;
      int rTHU = 0.0;
      int rFRI = 0.0;
      
      int bearMON = 0;
      int bearTUE = 0;
      int bearWED = 0;
      int bearTHU = 0;
      int bearFRI = 0;
      
      int bullMON = 0;
      int bullTUE = 0;
      int bullWED = 0;
      int bullTHU = 0;
      int bullFRI = 0;
      
      //uint weeks = 0;
      string s = "";
      double open[];
      double close[];
      datetime time[];
      CopyOpen(Symbol(), PERIOD_D1, 0, days, open);
      CopyClose(Symbol(),PERIOD_D1, 0, days, close);
      CopyTime(Symbol(), PERIOD_D1, 0, days, time);
      ArraySetAsSeries(open, true);
      ArraySetAsSeries(close, true);
      ArraySetAsSeries(time, true);
      for(int i = days - 1; i > 0; i--){
         
         TimeToStruct(time[i], t);
         DayToString(t);
         switch(t.day_of_week){
            case 1:
               //weeks++;
               if(close[i] < open[i]) bearMON++;
               else bullMON++;
               rMON = (bullMON == 0 && bearMON == 0)?0:(int)bullMON/((double)(bullMON + bearMON)/100);
               s = "Вторник";
               break;
            case 2:
               if(close[i] < open[i]) bearTUE++;
               else bullTUE++;
               rTUE = (bullTUE == 0 && bearTUE == 0)?0:(int)bullTUE/((double)(bullTUE + bearTUE)/100);
               s = "Среда";
               break;
            case 3:
               if(close[i] < open[i]) bearWED++;
               else bullWED++;
               rWED = (bullWED == 0 && bearWED == 0)?0:(int)bullWED/((double)(bullWED + bearWED)/100);
               s = "Четверг";
               break;
            case 4:
               if(close[i] < open[i]) bearTHU++;
               else bullTHU++;
               rTHU = (bullTHU == 0 && bearTHU == 0)?0:(int)bullTHU/((double)(bullTHU + bearTHU)/100);
               s = "Пятница";
               break;
            case 5:
               if(close[i] < open[i]) bearFRI++;
               else bullFRI++;
               rFRI = (bullFRI == 0 && bearFRI == 0)?0:(int)bullFRI/((double)(bullFRI + bearFRI)/100);
               s = "Понедельник";
               break;
         }
      }
      Comment(s+"\nПонедельник \t\t"+rMON+" %"+"\nВторник \t\t"+rTUE+" %"+"\nСреда \t\t"+rWED+" %"+"\nЧетверг \t\t"+rTHU+" %"+"\nПятница \t\t"+rFRI+" %");
      //TableCreate(pref+"table", 15, 15, 200, 130);
      //LabelCreate(pref+"l1", "Понедельник", 20, 20);
      pTime = cTime[0];   
   }   
      
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

string DayToString(MqlDateTime& dt){
   datetime d = StructToTime(dt);
   switch(dt.day_of_week){
      case 1: VCreate(pref + TimeToString(d), d);
         return "Понедельник";
      case 2: return "Вторник";
      case 3: return "Среда";
      case 4: return "Четверг";
      case 5: return "Пятница";
   }
   return "";
}

bool VCreate(const string name, const datetime time){
   ObjectCreate(ChartID(), name, OBJ_VLINE, 0, time, 0);
   ObjectSetInteger(ChartID(), name, OBJPROP_STYLE, 2);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, clrBlue);
   return true;
}

void DeleteObject(string n){
   int t = ObjectsTotal();
   for(int i = t-1; i>=0; i--){
      string s = ObjectName(0, i);
      if(StringFind(s, n) != -1)
         ObjectDelete(0, s);
   }
}

bool LabelCreate(const string name, const string text, int x, int y){
   if(!ObjectCreate(ChartID(), name, OBJ_TEXT, 0, 0, 0))return false;
   ObjectSetInteger(ChartID(), name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(ChartID(), name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(ChartID(), name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(ChartID(), name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   return true;
}

bool TableCreate(const string name, int x, int y, int w, int h){
   if(!ObjectCreate(ChartID(), name, OBJ_RECTANGLE_LABEL, 0, 0, 0))return false;
   ObjectSetInteger(ChartID(), name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(ChartID(), name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(ChartID(), name, OBJPROP_XSIZE, w);
   ObjectSetInteger(ChartID(), name, OBJPROP_YSIZE, h);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(ChartID(), name, OBJPROP_ALIGN, CORNER_LEFT_UPPER);
   ObjectSetInteger(ChartID(), name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   return true;
}