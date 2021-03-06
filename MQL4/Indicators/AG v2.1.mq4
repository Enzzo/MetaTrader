#property description "Индикатор, который издает алерт (звуковой сигнал), когда цена бьется в одну и ту же точку несколько раз. По ТС Александра Герчика"
#property copyright "Новые и другие программы на http://www.fermamoney.ru/"
#property link      "http://www.fermamoney.ru/"
#property version   "2.00"
#property strict
#property indicator_chart_window
input ENUM_TIMEFRAMES TimeFrame=PERIOD_D1;
input int CountBar=4;
input int Counter=3;
input int Distance=200;
input bool UseAlert=true;
input bool Back=false;
input color ColorHigh=clrDeepSkyBlue;
input color ColorLow=clrDarkOrange;
input ENUM_LINE_STYLE Style=STYLE_SOLID;
double ArrayHigh[],ArrayLow[],ArrayPriceLow[][2],ArrayPriceHigh[][2];
int HighCounter,LowCounter;
datetime BarTime;

int OnInit(){
   ArrayResize(ArrayHigh,CountBar);
   ArrayResize(ArrayLow,CountBar);
   if(CountBar<Counter+1) {Print("CountBar не может быть меньше Counter+1."); return(INIT_FAILED);} 
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
   
   if(isNewBar()){
      for(int i=1; i<CountBar+1; i++){
         ArrayHigh[i-1]=iHigh(Symbol(),TimeFrame,i);ArrayLow[i-1]=iLow(Symbol(),TimeFrame,i);
      }
      for(int i=0; i<CountBar; i++){
         HighCounter=-1;LowCounter=-1;
         ArrayFree(ArrayPriceLow);ArrayFree(ArrayPriceHigh);
         for(int z=i; z<CountBar; z++){
            if(ArrayHigh[i]+Distance*Point>=ArrayHigh[z] && ArrayHigh[i]-Distance*Point<=ArrayHigh[z] && z!=i) {
                  HighCounter++;
                     ArrayResize(ArrayPriceHigh,ArraySize(ArrayPriceHigh)/2+1);
                     ArrayPriceHigh[HighCounter][0]=ArrayHigh[i];
                     ArrayPriceHigh[HighCounter][1]=(double)iTime(Symbol(),TimeFrame,i);
               }
            if(ArrayLow[i]+Distance*Point>=ArrayLow[z] && ArrayLow[i]-Distance*Point<=ArrayLow[z] && z!=i) {
                  LowCounter++;
                     ArrayResize(ArrayPriceLow,ArraySize(ArrayPriceLow)/2+1);
                     ArrayPriceLow[LowCounter][0]=ArrayLow[i];
                     ArrayPriceLow[LowCounter][1]=(double)iTime(Symbol(),TimeFrame,i);
               }
            if(HighCounter+1>=Counter) {
               if(UseAlert) Alert(Symbol()+" Найдено "+(string)Counter+" отскоков цены от High уровня "+(string)ArrayPriceHigh[0][0]); 
               if(ObjectFind("High"+(string)ArrayPriceHigh[0][0])==-1){
                  ObjectCreate("High"+(string)ArrayPriceHigh[0][0],OBJ_TREND,0,(datetime)ArrayPriceHigh[HighCounter][1]-TimeFrame*60*2,ArrayPriceHigh[0][0],(datetime)ArrayPriceHigh[0][1]+TimeFrame*60*0,ArrayPriceHigh[0][0]);
                  ObjectSet("High"+(string)ArrayPriceHigh[0][0],OBJPROP_RAY,False);
                  ObjectSet("High"+(string)ArrayPriceHigh[0][0],OBJPROP_BACK,Back);
                  ObjectSet("High"+(string)ArrayPriceHigh[0][0],OBJPROP_COLOR,ColorHigh);
                  ObjectSet("High"+(string)ArrayPriceHigh[0][0],OBJPROP_STYLE,Style);
                  }
                  break;
            }
            if(LowCounter+1>=Counter) {
               if(UseAlert) Alert(Symbol()+" Найдено "+(string)Counter+" отскоков цены от Low уровня "+(string)ArrayPriceLow[0][0]); 
               if(ObjectFind("Low"+(string)ArrayPriceLow[0][0])==-1){
                  ObjectCreate("Low"+(string)ArrayPriceLow[0][0],OBJ_TREND,0,(datetime)ArrayPriceLow[LowCounter][1]-TimeFrame*60*2,ArrayPriceLow[0][0],(datetime)ArrayPriceLow[0][1]+TimeFrame*60*0,ArrayPriceLow[0][0]);
                  ObjectSet("Low"+(string)ArrayPriceLow[0][0],OBJPROP_RAY,False);
                  ObjectSet("Low"+(string)ArrayPriceLow[0][0],OBJPROP_BACK,Back);
                  ObjectSet("Low"+(string)ArrayPriceLow[0][0],OBJPROP_COLOR,ColorLow);
                  ObjectSet("Low"+(string)ArrayPriceLow[0][0],OBJPROP_STYLE,Style);
               }
               break;
            }
         }
      }
   }
   return(rates_total);
  }
bool isNewBar()
{
   if (BarTime==iTime(Symbol(),TimeFrame,0))return(false);
   BarTime=iTime(Symbol(),TimeFrame,0); return(true);
}