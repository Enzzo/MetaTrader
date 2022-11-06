//+------------------------------------------------------------------+
//|                                                        Spawn.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int      magic    = 4123;     //Магик
input int      levels   = 40;       //Расстояние уровней стопов и ордеров (пункты)
input int      slippage = 5;        //Проскальзывание (пункты)
input double   volume   = 0.01;     //Объем лота
input double   multipler = 2;       //множитель объема для Мартингейла
//input double   profit   = 0.5;      //профит в долларах

//-------------------------------------------------------------
//
// action - триггер работы советника. Если true, 
//          то не выставляем открытых торговых позиций
//
// cmd    - тип торговой операции операции
//
// level1 - верхний уровень (тейкпрофиты ордеров BUY)
// level2 - второй уровень  (ордера BUY)
// level3 - третий уровень  (ордера SELL)
// level4 - нижний уровень  (тейкпрофиты ордеров SELL)
string   symbol;
int      mgc;
int      cmd;
int      slp;
int      lvl;
double   level1;
double   level2;
double   level3;
double   level4;
double   price;
double   sl;
double   tp;
double   vol;
double   mtp;
bool     action;  

int OnInit(){
   
   Init();
   
   mgc      = magic;
   symbol   = Symbol();   
   slp      = slippage;
   lvl      = levels;
   mtp      = multipler;
   /*
   if(Digits() == 3 || Digits() == 5){
      slp *= 10;
      lvl *= 10;
   }
   */
   return(INIT_SUCCEEDED);
}

void OnTick(){
   //если триггер выключен, выставляем открытую позицию
   if(!action){
      Start();
   }
   else
      Continue();
}

//инициализация параметров
void Init(){
   action   = false;   
   vol      = volume;
   price    = 0.0;
   sl       = 0.0;
   tp       = 0.0;
}

//Открывает только один текущий ордер
void Start(){
   Init();
   MqlTick  lastTick;
   SymbolInfoTick(symbol, lastTick);
   //если свеча бычья, то ставим ордер на BUY, включаем триггер
   if(lastTick.last > Open[0]){
      level1   = NormalizeDouble(lastTick.ask + lvl*Point(), Digits());
      level2   = NormalizeDouble(lastTick.ask, Digits());
      level3   = NormalizeDouble(lastTick.ask - lvl*Point(),Digits());
      level4   = NormalizeDouble(lastTick.ask - lvl*Point()*2, Digits());
      price    = level2;
      tp       = level1;
      sl       = level3;
      cmd      = OP_BUY;
      action   = true;
   }   
   //если свеча медвежья, то ставим ордер на SELL и включаем триггер
   else if (lastTick.last < Open[0]){
      level1   = NormalizeDouble(lastTick.bid + lvl*Point()*2,Digits());
      level2   = NormalizeDouble(lastTick.bid + lvl*Point(),Digits());
      level3   = NormalizeDouble(lastTick.bid,Digits());
      level4   = NormalizeDouble(lastTick.bid - lvl*Point(), Digits());
      price    = level3;
      tp       = level4;
      sl       = level2;
      cmd      = OP_SELL;
      action   = true;
   }
   //Print("price: ",price, " sl: ",sl," tp: ",tp);
   ResetLastError();
   if(!OrderSend(symbol, cmd, vol, price, slp, sl, tp, NULL, mgc)){
      Print(__FUNCTION__," Ошибка отправки ордера: ",GetLastError());
      return;
   };
}

void Continue(){
   MqlTick  lastTick;
   SymbolInfoTick(symbol, lastTick);
   int total   = OrdersTotal();
   int pTicket = 0; 
   int cTicket = 0;
   int type    = 0;
   bool cur    = false;
   bool pend   = false;
   
   if(total == 0){
      action = false;
      return;
   }
   
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == mgc){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cTicket = OrderTicket();
            type = OrderType();
            cur = true;
            /*if(OrderProfit() >= profit){
               ResetLastError();
               if(!OrderClose(cTicket, vol, lastTick.last, slp)){
                  Print(__FUNCTION__," Ошибка закрытия ордера: ",GetLastError());
                  return;
               };
            }*/
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
            pTicket = OrderTicket();
            pend = true;
         }
      }         
   }
   
   if(cur && !pend){
      int lCmd;
      double lPrice  = 0.0;
      double lSL     = 0.0;
      double lTP     = 0.0;
      
      if(type == OP_BUY){
         lCmd = OP_SELLSTOP;
         lPrice = level3;
         lSL    = level2;
         lTP    = level4;
      }
      
      else if(type == OP_SELL){
         lCmd = OP_BUYSTOP;
         lPrice = level2;
         lSL    = level3;
         lTP    = level1;
      }
      if(lPrice != 0.0){
         vol *= mtp;
         Print("vol = ",vol);
         ResetLastError();
         if(!OrderSend(symbol, lCmd, vol, lPrice, slp, lSL, lTP, NULL, mgc)){
            Print(__FUNCTION__, " Ошибка удаления ордера: ", GetLastError());
            return;
         }
      }
      return;
   }
   
   if(cur && pend){
      return;
   }
   
   if(!cur && pend){
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," Ошибка удаления ордера: ", GetLastError());
         return;
      }
      Init();
   }
   
}