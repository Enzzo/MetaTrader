//+------------------------------------------------------------------+
//|                                                       ZZElse.mq4 |
//|                                           Copyright © 2011, AZM. |
//|                                                 azmgod@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, AZM."
#property link      "azmgod@gmail.com"

extern int chart               = 3;
extern double lot              = 0.1;
extern bool loss_percent_lot   = false;
extern double  maxrisk         = 2;
extern int profit_dn           = 210;
extern double loss_dn          = 15;
extern int profit_up           = 80;
extern double loss_up          = 35;
extern int indent_dn           = 1;
extern int indent_up           = 6;
extern int magic               = 187;

extern string ZigZag_parameters;
extern int ExtDepth            = 15;
extern int ExtDeviatiion       = 0;
extern int ExtBackstep         = 3;

int count;
double digit,ml;string com="zzelse";
int dec,k;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init(){
//----
   digit  = MarketInfo(Symbol(),MODE_DIGITS); //sp  = MarketInfo(Symbol(),MODE_SPREAD); 
   if (digit==5 || digit==3) dec=10;if(digit==5)k=100000;if(digit==3)k=1000;
   if (digit==4 || digit==2) dec=1; if(digit==4)k=10000; if(digit==2)k=100;
   ml=MarketInfo(Symbol(),MODE_MINLOT); //s=MarketInfo(Symbol(),MODE_STOPLEVEL);
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start(){//if(count>3)return;
  if(!b())return 0;
//----
   setdown();
   setup();//count++;
   movelossup();
   movelossdn();
   trallossdn();
   trallossup();
//----
   return(0);
}
//+------------------------------------------------------------------+
void trallossdn(){
   int i,t;
   bool order;
   double sl,op_pr,tp;
   double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,1);
   
   if(zdn==0)return;
   for(i=OrdersTotal() - 1; i>=0; i--){                                   // Цикл перебора ордеров
      if(OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(1!=OrderType())continue;
         order=true; 
         t=OrderTicket();
         op_pr=OrderOpenPrice();
         tp=OrderTakeProfit();
         sl=OrderStopLoss(); 
      }
   }
   if(!order)return;
   for( i=2;i<Bars;i++){
      double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zup!=0)break;
   }
   if(sl>zup)
   bool x = OrderModify(t,op_pr,zup,tp,0);
}
//+------------------------------------------------------------------+
void trallossup(){
   int i,t;
   bool order;
   double sl,op_pr,tp;
   double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,1);
   if(zup==0)return;
   for(i=OrdersTotal()-1; i>=0; i--){                                   // Цикл перебора ордеров
      if (OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(0!=OrderType())continue;
         order=true; t=OrderTicket();op_pr=OrderOpenPrice();tp=OrderTakeProfit();sl=OrderStopLoss(); 
      }
   }
   if(!order)return;
   for( i=2;i<Bars;i++){
      double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdn!=0)break;
   }
   if(sl<zdn)
   bool x = OrderModify(t,op_pr,zdn,tp,0);
}
//+------------------------------------------------------------------+
void movelossup(){
   int i,t;
   bool order;
   double sl,nsl,op_pr,tp;
   double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,1);
   if(zup==0)return;
   for(i=OrdersTotal()-1; i>=0; i--){                   // Цикл перебора ордеров
      if (OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(4!=OrderType()&&0!=OrderType())continue;
         order=true; t=OrderTicket();op_pr=OrderOpenPrice();tp=OrderTakeProfit();sl=OrderStopLoss(); 
      }
   }
   if(!order)return;
   for( i=2;i<Bars;i++){
      double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdn!=0)break;
   }
   while(i<Bars){
      zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zup!=0)break;
      i++;
   }
   while(i<Bars){
      double nextzdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(nextzdn!=0)break;
      i++;
   }
   sl=NormalizeDouble(sl,Digits);if(sl!=nextzdn)return;
   nsl=NormalizeDouble((zup-(((zup-zdn)/100)*loss_up)),Digits);
   bool x = OrderModify(t,op_pr,nsl,tp,0);
}
//+------------------------------------------------------------------+
void movelossdn(){
   int i,t;
   bool order;
   double sl,nsl,op_pr,tp;
   double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,1);
   if(zdn==0)return;//Print("lsdn");
   for(i=OrdersTotal()-1; i>=0; i--){               // Цикл перебора ордеров
      if (OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(5!=OrderType()&&1!=OrderType())continue;
         order=true; t=OrderTicket();op_pr=OrderOpenPrice();tp=OrderTakeProfit();sl=OrderStopLoss(); 
      }
   }
   if(!order)return;
   for( i=2;i<Bars;i++){
      double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zup!=0)break;
   }
   while(i<Bars){
      zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdn!=0)break;
      i++;
   }
   while(i<Bars){
      double nextzup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(nextzup!=0)break;
      i++;
   }
   sl=NormalizeDouble(sl,Digits);if(sl!=nextzup)return;
   nsl=NormalizeDouble((zdn+(((zup-zdn)/100)*loss_dn)),Digits);
   bool x = OrderModify(t,op_pr,nsl,tp,0);
}
//+------------------------------------------------------------------+
void setdown(){
   int t;
   double sl;
   double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,1);
   if(zup==0)return;
   //Print(TimeHour(TimeCurrent()));
   //Print("zup "+zup);
   for(int i=2;i<Bars;i++){
      double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdn!=0)break;
   }
   //Print("zdn "+zdn);
   while(i<Bars){
      zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zup!=0)break;i++;
   }
   //Print("zup2 "+zup);
   while(i<Bars){
      double zdnext=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdnext!=0)break;i++;
   }
   //Print("zdnext "+zdnext);
   if(zdn<zdnext)return;
   for(i=OrdersTotal()-1; i>=0; i--){               // Цикл перебора ордеров
      if (OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(5!=OrderType())continue;
         sl=OrderStopLoss(); t=OrderTicket(); bool order=true;
      }
   }
   if(sl!=zup&&order){
      bool d = OrderDelete(t);
      order=false;
   }
   if(order)return;sl=NormalizeDouble(zup,Digits);
   double pr=NormalizeDouble(zdn-(dec*indent_dn*Point),Digits);
   double tp=NormalizeDouble(pr-(dec*profit_dn*Point),Digits);
   if(loss_percent_lot)lot=GetLoss((sl-pr)*k);if(lot<ml)lot=ml;
   bool x = OrderSend(Symbol(),5,lot,pr,0,sl,tp,com,magic);
}
//+------------------------------------------------------------------+
void setup(){
   int t;
   double sl;
   double zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,1);
   if(zdn==0)return;
   //Print(TimeHour(TimeCurrent()));
   //Print("zdn "+zdn);
   
   for(int i=2;i<Bars;i++){
      double zup=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zup!=0)break;
   }
   //Print("zup "+zup);
   while(i<Bars){
      zdn=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,2,i);
      if(zdn!=0)break;
      i++;
   }
   //Print("zdn2 "+zdn);
   while(i<Bars){
      double zunext=iCustom(Symbol(),chart,"ZigZag",ExtDepth,ExtDeviatiion,ExtBackstep,1,i);
      if(zunext!=0)break;
      i++;
   }
   //Print("zunext "+zunext);
   if(zup>zunext)return;
   for(i=OrdersTotal()-1; i>=0; i--){               // Цикл перебора ордеров
      if (OrderSelect(i,SELECT_BY_POS)==true){      // Если есть следующий
         if(magic!=OrderMagicNumber())continue;
         if(Symbol()!=OrderSymbol())continue;
         if(4!=OrderType())continue;
         sl=OrderStopLoss(); t=OrderTicket(); bool order=true;
      }
   }
   if(sl!=zdn&&order){
      bool d = OrderDelete(t);order=false;} 
   if(order)return;sl=NormalizeDouble(zdn,Digits);
   double pr=NormalizeDouble(zup+(dec*indent_up*Point),Digits);
   double tp=NormalizeDouble(pr+(dec*profit_up*Point),Digits);
   if(loss_percent_lot)lot=GetLoss((pr-sl)*k);if(lot<ml)lot=ml; 
   bool c = OrderSend(Symbol(),4,lot,pr,0,sl,tp,com,magic);
}
//+------------------------------------------------------------------+
bool b(){
//+------------------------------------------------------------------+
   static datetime New_Time=0;                  // Время текущего бара
   bool New_Bar=false;                          // Нового бара нет
   if(New_Time!=iTime(Symbol(),chart,0))                        // Сравниваем время
     {
      New_Time=iTime(Symbol(),chart,0);                         // Теперь время такое
      New_Bar=true;                             // Поймался новый бар
     }
     return(New_Bar);
   }
//+------------------------------------------------------------------+      
double GetLoss(int sloss){
   double Free    =AccountBalance();
   double LotVal  =MarketInfo(Symbol(),MODE_TICKVALUE);//стоимость 1 пункта 1 лота
   double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
   double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
   double Step    =MarketInfo(Symbol(),MODE_LOTSTEP);
   double Lot     =MathFloor((Free*maxrisk/100)/(sloss*LotVal)/Step)*Step;
   if(Lot<Min_Lot)  Lot=Min_Lot;
   if(Lot>Max_Lot)  Lot=Max_Lot;
   //Alert(Lot);
   //return(0);
   return(Lot);
}
//+------------------------------------------------------------------+