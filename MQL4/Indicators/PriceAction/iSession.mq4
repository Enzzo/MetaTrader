//+------------------------------------------------------------------+
//|                                                      session.mq4 |
//|                                                             Enzo |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

enum Sessions{
   h0,      //00:00
   h1,      //01:00
   h2,      //02:00
   h3,      //03:00
   h4,      //04:00
   h5,      //05:00
   h6,      //06:00
   h7,      //07:00
   h8,      //08:00
   h9,      //09:00
   h10,     //10:00
   h11,     //11:00
   h12,     //12:00
   h13,     //13:00
   h14,     //14:00
   h15,     //15:00
   h16,     //16:00
   h17,     //17:00
   h18,     //18:00
   h19,     //19:00
   h20,     //20:00
   h21,     //21:00
   h22,     //22:00
   h23      //23:00
};

//PUBLIC VARIABLES

input string note = "<----------- Сессия по GMT ----------->";
input string pref = "session_";
input Sessions oSession = 6;
input Sessions cSession = 15;
input color sessionColor = clrLightCyan;

//PRIVATE VARIABLES
datetime lTime;
int length;       //длина сессии
int n;            //количество сессий
long chart_ID;
datetime startTime;
datetime endTime;
double lowPrice;
double highPrice;

//FUNCTIONS
void DrawSession(int i){
   if(!Session(i)){
      startTime   = 0;
      endTime     = 0;
      highPrice   = 0;
      lowPrice    = 0;
      length      = 0;
      return;
   }
   
   if(startTime == 0){
      startTime = Time[i];
      return;
   }
   
   length++;
   
   startTime = Time[length + i];
   endTime = Time[i];
   lowPrice = Low[i];
   
   for(int j = (1+i); j <= (length+i); j++){
      
      if (highPrice < High[j])
         highPrice = NormalizeDouble(High[j],Digits());
      
      if (lowPrice > Low[j])
         lowPrice = NormalizeDouble(Low[j], Digits());
   } 
   string name = pref+ IntegerToString(n);
   
   if(ObjectFind(chart_ID, name)!= -1){
      Print("Deleting ",name);
      if(!ObjectDelete(chart_ID, name)){
         Print(__FUNCTION__, GetLastError(),"Ошибка удаления");
         ResetLastError();
      }
   }
   //Print("Create: name - ",name, " start: ",startTime, " high: ",highPrice,"  end: ",endTime, " low: ",lowPrice);
   if(!ObjectCreate(chart_ID, name, OBJ_RECTANGLE, 0, startTime, highPrice, endTime, lowPrice)){
      Print(__FUNCTION__, GetLastError(),"Ошибка создания объекта.");
      ResetLastError();
   }
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, sessionColor);
}

bool Session(int i){
   if(TimeHour(Time[i]) >= oSession && TimeHour(Time[i]) < cSession){      
      if(TimeHour(Time[i]) == oSession)
         n++;
      return true;
   }
   return false;
}

int OnInit(){
   lTime = 0;
   chart_ID = ChartID();
   startTime = 0;
   endTime = 0;
   highPrice = 0.0;
   lowPrice = 0.0;
   length = 0;
   
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
    
   if(lTime == 0)
      for(int i = rates_total-2; i > 0; i--){
         DrawSession(i);
      }
   
   if(lTime == time[0])
      return rates_total;
   
   lTime = time[0];
      
   DrawSession(0);
   
   return(rates_total);
}

void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name;
   for(int i = total; i > 0; i--){
      name = pref+IntegerToString(i);
         if(ObjectFind(chart_ID, name)!= -1)
            ObjectDelete(chart_ID, name);

   }
}