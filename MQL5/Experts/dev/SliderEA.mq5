#property copyright "It's mine!!!!"
#property link "https://t.me/"
#property description "DESCIPTION"
#property description "second line of description"
#property description "you\ncan\ndo\nlike\nthis"

const long g_accountNumber = 67075958; // <0 is switch off this functional
const datetime g_endOfWork = D'02.07.2023 23:59:52'; // 0 is switch off  this functional
const string g_licenseKey = "3lSMVzKQ"; // "" or NULL is switch off  this functional
const string g_symbol = "EURUSD"; // "" or NULL is switch off  this functional

enum ENUM_SL_TYPE{
   SL_TYPE_OFF = 0,  // stop loss off
   SL_TYPE_FIX = 1,  // stop loss fix
   SL_TYPE_ZZ  = 2,  // stop loss by zig zag
};

enum ENUM_PROFIT_TYPE{
   PROFIT_OFF        = 0,  // функция отключена
   PROFIT_ON         = 1,  // функция включена
};

#include <Trade\Trade.mqh> 
CTrade trade;

      ENUM_TIMEFRAMES         mfi_time_frame       = PERIOD_M15; // Time frame to use
input string                  menucommentOpen      = "========================================";     // ***БЛОК ВХОДА В СДЕЛКУ***      
input int                     ExtDepth             = 34;
input int                     ExtDeviation         = 21;
input int                     ExtBackstep          = 12;
      double                  enter_level          = 60;
input int                     min_vertives         = 3;
input int                     min_breakdown        = 20;
input int                     max_breakdown        = 1000;
input string                  menucomment00        = "========================================";     // ***БЛОК ОСНОВНЫХ НАСТРОЕК***
input int                     max_spread           = 25;             // Max. spread
input double                  lot                  = 0.1;            // Lot
input double                  auto_lot             = 1000;           // Auto lot
input double                  risk                 = 2;              // Risk
input string                  menucommentMartin    = "========================================";     // ***БЛОК УСРЕДНЕНИЯ И МАРТИНА***
input int                     max_total_of_trades  = 10;             // Max. total of trades
input double                  lot_x                = 1.1;            // Lot X
input double                  min_distance_of_next_trade = 700;      // Min. distance of next trade 
input ENUM_PROFIT_TYPE        profit_funk          = true;           // Part close on profit
input double                  profit               = 50;             // Profit percent
input string                  menucomment01        = "========================================";     // ***БЛОК ТЕЙК-ПРОФИТА***
      bool                    enter_on_first_sl    = false;          // Enter on start sl
input double                  take_profit          = 500;            // Take profit
input double                  take_profit_for_all  = 900;            // All take profit
input double                  part_close_level     = 300;            // Take profit distance
input double                  part_close_percent   = 20;             // Take profit % 
input string                  menucommentSL        = "========================================";     // ***БЛОК СТОП-ЛОССА***
input ENUM_SL_TYPE            stop_loss_type       = SL_TYPE_FIX;    // Stop loss type
input double                  stop_loss_fix        = 5000;           // Stop Loss Fix
input double                  stop_loss_shift      = 40;             // Stop Loss shift by zig zag
input double                  stop_loss_max        = 500;            // Stop Loss Maximum
input double                  trall_start          = 300;            // Trailing stop loss start 
input double                  trall_distance       = 200;            // Trailing stop loss distance
input double                  trall_step           = 5;              // Trailing stop loss step 
input double                  stop_loss_for_all    = 700;            // All stop loss 
input double                  stop_loss_percent    = 23;             // All stop loss percent
input string                  menucomment02        = "========================================";       // =======================
input ENUM_ORDER_TYPE_FILLING set_filling          = ORDER_FILLING_FOK; // Filing Type
input ulong                   Magic                = 1357913;        // Magic
input string                  i_licenseKey         = "";             // License key

int      ii,ir,rr,dg=0,dig,dig_ind;
bool     Work=true;
string   Symb;
double   Pp,tick_size,min_lot;
bool     is_hedging = true;

int      zz_handle;
datetime time_bar;
double   zz_points[];
int      zz_point_direction[];

double   level_buy = 0;
double   level_buy_stop = 0;
double   level_sell = 0;
double   level_sell_stop = 0;

double   zz_near_up     = 0;
double   zz_near_down   = 0;

double   last_zz_point=0;

double   loss_total=0;
datetime chain_start_time = 0;

bool can_enter_on_sl = false;

bool CheckAccount(string& text){
   bool ret=g_accountNumber<0 || g_accountNumber==AccountInfoInteger(ACCOUNT_LOGIN);
   if (!ret)
      text+="Invalid account number\n";
   return ret;
}

bool CheckTime(string& text){
   bool ret=!g_endOfWork || TimeCurrent() < g_endOfWork;
   if (!ret)
      text+="Expert Advisor license has expired\n";
   return ret;   
}

bool CheckLicenseKey(string& text){
   bool ret= g_licenseKey==NULL || g_licenseKey=="" || g_licenseKey == i_licenseKey;
   if (!ret)
      text+="Invalid license key\n";
   return ret;   
}

bool CheckSymbol(string& text){
   bool ret= g_symbol==NULL || g_symbol=="" || g_symbol == _Symbol;
   if (!ret)
      text+="Invalid currency pair\n";
   return ret;   
}

bool CheckWorkOnTick(string& text){
   return CheckTime(text);
}

bool CheckWorkOnInit(string& text){
   bool ret = CheckAccount(text);
   ret = CheckLicenseKey(text) && ret;
   ret = CheckSymbol(text) && ret;
   ret = CheckWorkOnTick(text) && ret;
   return ret;
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void OnTick() {
   static string alertText="";
   /*
   MqlDateTime time;
   TimeCurrent(time);
   if(time.hour<18) return;
   if(time.hour==18 && time.min<35) return;
   */
   if (!CheckWorkOnTick(alertText)){
      Alert(alertText);
      ExpertRemove();
      return;
   }
   
   ulong position_ticket=0;
   ulong deal_ticket=0;
   double open_sl=0;

   // данные тика
   MqlTick tick;
   SymbolInfoTick(_Symbol,tick);

   // получение сигнала
   bool     new_bar = false;
   int      signal            = -1;
   double   signal_stop_loss  = 0;
   if(time_bar < iTime(NULL,mfi_time_frame,0)) {
      new_bar = true;
      
      double zz_value[2000];
      if(CopyBuffer(zz_handle,0,0,2000,zz_value)<2000) {
         Print("Can't get indicator data");
         return;
      }
      
      MqlRates rates[2000];
      if(CopyRates(_Symbol,0,0,2000,rates) < 2000) {
         Print("Can't get rates");
         return;
      }
      
      ArrayInitialize(zz_points,0);
      ArrayInitialize(zz_point_direction,0);
      int found_points = 0;
      
      zz_near_up = 0;
      zz_near_down = 0;
      
      int last_zz_direction = -1;
      for(ii=1999;ii>=0;ii--) {
         if(zz_value[ii]<=0) continue;
         //Print(ii," ",zz_value[ii]);
         int current_zz_direction = -1;
         if(zz_value[ii] < rates[ii].high) {
            current_zz_direction = 1;
            if(zz_near_down==0)
               zz_near_down = zz_value[ii];
         }
         if(zz_value[ii] > rates[ii].low) {
            current_zz_direction = 0;
            if(zz_near_up==0) 
               zz_near_up = zz_value[ii];
         }
         if(current_zz_direction!=last_zz_direction) {
            found_points++;
            ArrayResize(zz_points,found_points);
            ArrayResize(zz_point_direction,found_points);
            zz_points[found_points-1]           = zz_value[ii];
            zz_point_direction[found_points-1]  = current_zz_direction;
            last_zz_direction = current_zz_direction;
            //if(found_points>=6) break;
            continue;
         }
         if(current_zz_direction == last_zz_direction) {
            if(current_zz_direction==0 && zz_value[ii] > zz_points[found_points-1]) {
               zz_points[found_points-1] = zz_value[ii];
               continue;
            }
            if(current_zz_direction==1 && zz_value[ii] < zz_points[found_points-1]) {
               zz_points[found_points-1] = zz_value[ii];
               continue;
            }
         }
      }
      Print(DoubleToString(zz_points[2],_Digits)," ",DoubleToString(zz_points[1],_Digits)," ",DoubleToString(zz_points[0],_Digits));
      
      if(last_zz_point==0)
         last_zz_point = zz_points[0];
      
      level_buy = 0;
      level_sell = 0;
      
      // направление последней точки зиг-газа вниз
      if(zz_point_direction[0] == 1) {
         Print("down");
         // уровень на покупку -----------------------------------
         // последняя верхня точка была пробойной
         if(zz_points[1] >= zz_points[3] + min_breakdown*_Point && zz_points[1] <= zz_points[3] + max_breakdown*_Point) {
            // посчитаем количество понижающихся точек
            int down_point_series = 1;
            for(int p = 5; p<=found_points; p+=2) {
               if(zz_points[p] > zz_points[p-2] - min_breakdown*_Point) {
                  down_point_series++;
               }else{
                  break;
               }
            }
            // если серия достаточная - отметим цену входа
            if(down_point_series>=min_vertives) {
               level_buy = zz_points[1];
            }
         }
         // уровень на продажу -------------------------------------
         // убедимся что уровень еще не был пробит, или если точка 2 ранее была точкой 1
         if(zz_points[0] > zz_points[2] || last_zz_point == zz_points[2]) {
            // последняя нижняя точка была пробойной
            if(zz_points[2] <= zz_points[4] - min_breakdown*_Point && zz_points[2] >= zz_points[4] - max_breakdown*_Point) {
               // посчитаем количество повышающихся точек
               int up_point_series = 1;
               for(int p = 6; p<=found_points; p+=2) {
                  if(zz_points[p] < zz_points[p-2] + min_breakdown*_Point) {
                     up_point_series++;
                  }else{
                     break;
                  }
               }
               // если серия достаточная - отметим цену входа
               if(up_point_series>=min_vertives) {
                  level_sell = zz_points[2];
               }
            }
         }   
      }
      // направление последней точки зиг-газа вверх
      if(zz_point_direction[0] == 0) {
         Print("up");
         // уровень на продажу ----------------------------------------
         // последняя нижняя точка была пробойной
         if(zz_points[1] <= zz_points[3] - min_breakdown*_Point && zz_points[1] >= zz_points[3] - max_breakdown*_Point) {
            // посчитаем количество повышающихся точек
            int up_point_series = 1;
            for(int p = 5; p<=found_points; p+=2) {
               if(zz_points[p] < zz_points[p-2] + min_breakdown*_Point) {
                  up_point_series++;
               }else{
                  break;
               }
            }
            // если серия достаточная - отметим цену входа
            if(up_point_series>=min_vertives) {
               level_sell = zz_points[1];
            }
         }
         // уровень на покупку ---------------------------------------
         // убедиммся что уровень еще не был пробит, или если точка 2 ранее была точкой 1
         if(zz_points[0] < zz_points[2] || last_zz_point == zz_points[2]) {
            // последняя верхня точка была пробойной
            if(zz_points[2] >= zz_points[4] + min_breakdown*_Point && zz_points[2] <= zz_points[4] + max_breakdown*_Point) {
               // посчитаем количество понижающихся точек
               int down_point_series = 1;
               for(int p = 6; p<=found_points; p+=2) {
                  if(zz_points[p] > zz_points[p-2] - min_breakdown*_Point) {
                     down_point_series++;
                  }else{
                     break;
                  }
               }
               // если серия достаточная - отметим цену входа
               if(down_point_series>=min_vertives) {
                  level_buy = zz_points[2];
               }
            }
         }
      }
      // запомним последнюю точку зигзага
      last_zz_point = zz_points[0];
      
      // найдем ближайщий стоп лосс 
      if(zz_points[0] > zz_points[1]) {
         level_sell_stop = zz_points[0];
      }else{
         level_buy_stop = zz_points[0];
      }
      
      if(zz_points[1] > zz_points[2]) {
         level_sell_stop = zz_points[1];
      }else{
         level_buy_stop = zz_points[1];
      }      
      Print("level buy: ",DoubleToString(level_buy,_Digits)," level sell: ",DoubleToString(level_sell,_Digits));
      time_bar = iTime(NULL,mfi_time_frame,0);
      //sleep();
   }
 
   if(level_buy>0 && NormalizeDouble(tick.bid -level_buy,_Digits) > 0.0) {
      level_buy = 0;
      signal = 0;
      signal_stop_loss = level_buy_stop;
      Print("bid: ",DoubleToString(tick.bid,_Digits));
      Print("signal buy");
   }
   if(level_sell>0 && NormalizeDouble(level_sell - tick.bid,_Digits) > 0.0) {
      level_sell = 0;
      signal = 1;
      signal_stop_loss = level_sell_stop;
      Print("bid: ",DoubleToString(tick.bid,_Digits));
      Print("signal sell");
   }
      
   // учет позиции
   int      market_direction  = -1;
   ulong    market_ticket     = 0;
   int      market_orders     = 0;
   double   market_price_last = 0;
   double   market_price_first= 0;
   double   market_lot_first  = 0;
   double   market_take_profit= 0;
   double   market_stop_loss  = 0;
   double   market_price_sum  = 0;
   double   market_lot_sum    = 0;
   double   market_profit     = 0;
   datetime market_time_open  = 0;
   bool     market_part_close = false;
   double   market_sl_pips    = 0;
   
   if(is_hedging) {
      for(ii=PositionsTotal()-1;ii>=0;ii--) {
         position_ticket = PositionGetTicket(ii);
         if(!PositionSelectByTicket(position_ticket)) continue;
         if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
         double   position_price = PositionGetDouble(POSITION_PRICE_OPEN);
         double   position_lot   = PositionGetDouble(POSITION_VOLUME);
         double   position_tp    = PositionGetDouble(POSITION_TP);
         double   position_sl    = PositionGetDouble(POSITION_SL);
         market_ticket = position_ticket;
         market_stop_loss  = PositionGetDouble(POSITION_SL);
         market_take_profit= PositionGetDouble(POSITION_TP);
         market_price_sum  += position_price * position_lot;
         market_lot_sum    += position_lot;
         market_profit     += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
         market_time_open  = (datetime)PositionGetInteger(POSITION_TIME);
         double new_tp=0, new_sl=0;
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
            market_direction = 0;
            market_orders ++;
            if(position_price > market_price_first)
               market_price_first = position_price;
            if(position_price < market_price_last || market_price_last==0)
               market_price_last = position_price;
            if(position_lot<market_lot_first || market_lot_first==0)
               market_lot_first = position_lot;
            market_sl_pips += (position_price - tick.bid) / _Point;
         }
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
            market_direction = 1;
            market_orders ++;
            if(position_price < market_price_first || market_price_first==0)
               market_price_first = position_price;
            if(position_price > market_price_last)
               market_price_last = position_price;
            if(position_lot<market_lot_first || market_lot_first==0)
               market_lot_first = position_lot;
            market_sl_pips += (tick.ask - position_price) / _Point;
         }
      }
      HistorySelect(market_time_open,TimeCurrent());
      for(ii=HistoryDealsTotal()-1;ii>=0;ii--) {
         deal_ticket = HistoryDealGetTicket(ii);
         if(HistoryDealGetString(deal_ticket,DEAL_SYMBOL)!=_Symbol) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_MAGIC)!=Magic) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY)==DEAL_ENTRY_OUT) {
            market_part_close = true;
            break;
         }
      }
      if(market_lot_sum>0) 
         market_price_sum /= market_lot_sum;
   }
   if(!is_hedging) { 
      if(PositionSelect(_Symbol)) {
         market_ticket = PositionGetInteger(POSITION_TICKET);
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) 
            market_direction = 0;
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) 
            market_direction = 1;
         market_stop_loss  = PositionGetDouble(POSITION_SL);
         market_take_profit= PositionGetDouble(POSITION_TP);
         market_price_sum  = PositionGetDouble(POSITION_PRICE_OPEN);
         market_lot_sum    = PositionGetDouble(POSITION_VOLUME);
         market_profit     = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
         HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER));
         for(ii=HistoryDealsTotal()-1;ii>=0;ii--) {
            deal_ticket = HistoryDealGetTicket(ii);
            double   deal_price  = HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
            double   deal_lot    = HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
            if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_IN) {
               if(market_direction==0) {
                  market_orders++;
                  if(deal_price < market_price_last || market_price_last==0)
                     market_price_last = deal_price;
                  if(deal_lot < market_lot_first || market_lot_first==0)
                     market_lot_first = deal_lot;
               }
               if(market_direction==1) {
                  market_orders++;
                  if(deal_price > market_price_last)
                     market_price_last = deal_price;
                  if(deal_lot < market_lot_first || market_lot_first==0)
                     market_lot_first = deal_lot;
               }
            }else{
               market_part_close = true;
            }
         }
      }   
   }

   // есть позиция, возможно прерывание
   if(profit_funk && max_total_of_trades==1 && loss_total<0) {
      // закрытие по превышению
      if(market_profit >= -loss_total * ((100.0+profit)/100.0)) {
         double   new_lot  = lot;
         if(auto_lot>0) 
            new_lot *= MathFloor( AccountInfoDouble(ACCOUNT_BALANCE) / auto_lot);
         double open_lot = new_lot;
         if(risk>0) {
            open_lot *= MathFloor( AccountInfoDouble(ACCOUNT_BALANCE) / risk);
            double profit_1_lot=0;
            if(market_direction==0) {
               if(!OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,tick.ask,market_stop_loss,profit_1_lot)) {
                  Print("Не удалось расчитать лот");
                  return;
               }
            }
            if(market_direction==1) {
               if(!OrderCalcProfit(ORDER_TYPE_SELL,_Symbol,1.0,tick.bid,market_stop_loss,profit_1_lot)) {
                  Print("Не удалось расчитать лот");
                  return;
               }
            }
            open_lot = AccountInfoDouble(ACCOUNT_BALANCE) * (risk/100.0);
            open_lot /= -profit_1_lot;
            open_lot = NormalizeDouble(open_lot,dg);
         }
      
         Print("Закрытие позиции, так как ее прибыль превышает убыток");
         Print("Прибыль позиции: "+DoubleToString(market_profit,2)+" ранее полученный убыток: "+DoubleToString(loss_total,2));
         if(trade.PositionClose(market_ticket,-1)) {
            chain_start_time = TimeCurrent();
            GlobalVariableSet("zzp"+_Symbol+(string)Magic,chain_start_time);
            loss_total = 0;
         }
      }
      // закрытие по обратному сигналу
      if(signal!=-1 && signal!=market_direction /*&& market_profit >= -loss_total*/) {
         if(trade.PositionClose(market_ticket,-1)) {
            market_direction = -1;
            /*
            chain_start_time = TimeCurrent();
            GlobalVariableSet("zzp"+_Symbol+(string)Magic,chain_start_time);
            loss_total = 0;
            */
         }
      }
   }
   
   // проверка ТП первого ордера
   if(take_profit>0 && market_orders==1 && (loss_total>=0 || !profit_funk || max_total_of_trades>1)) {
      if(market_direction==0) {
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            if(NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits) != NormalizeDouble(market_price_sum + take_profit*_Point,_Digits))
               trade.PositionModify(position_ticket,PositionGetDouble(POSITION_SL),market_price_sum + take_profit*_Point);
         }
      }
      if(market_direction==1) {
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            if(NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits) != NormalizeDouble(market_price_sum - take_profit*_Point,_Digits))
               trade.PositionModify(position_ticket,PositionGetDouble(POSITION_SL),market_price_sum - take_profit*_Point);
         }
      }
   }

   // проверка ТП 
   if(take_profit_for_all>0 && market_orders>1) {
      if(market_direction==0) {
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            if(NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits) != NormalizeDouble(market_price_sum + take_profit_for_all*_Point,_Digits))
               trade.PositionModify(position_ticket,PositionGetDouble(POSITION_SL),market_price_sum + take_profit_for_all*_Point);
         }
      }
      if(market_direction==1) {
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            if(NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits) != NormalizeDouble(market_price_sum - take_profit_for_all*_Point,_Digits))
               trade.PositionModify(position_ticket,PositionGetDouble(POSITION_SL),market_price_sum - take_profit_for_all*_Point);
         }
      }
   }
      
   // проверка СЛ
   if(stop_loss_for_all>0 && market_sl_pips >= stop_loss_for_all) {
      Print("close by sl");
      for(ii=PositionsTotal()-1;ii>=0;ii--) {
         position_ticket = PositionGetTicket(ii);
         if(!PositionSelectByTicket(position_ticket)) continue;
         if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
         trade.PositionClose(position_ticket,3);
      }
   }

   // тралл
   if(trall_start>0 && (loss_total>=0 || !profit_funk || max_total_of_trades>1)) {
      if(market_direction==0 && NormalizeDouble((tick.bid - trall_start*_Point) - market_price_sum,_Digits)>0.0 &&
         NormalizeDouble((tick.bid - (trall_distance+trall_step)*_Point) - market_stop_loss,_Digits)>0.0) {
         market_stop_loss = tick.bid - trall_distance*_Point;
         can_enter_on_sl = false;
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            trade.PositionModify(position_ticket,market_stop_loss,PositionGetDouble(POSITION_TP));
         }      
      }
      if(market_direction==1 && NormalizeDouble(market_price_sum - (tick.ask + trall_start*_Point),_Digits)>0.0 &&
         (NormalizeDouble(market_stop_loss - (tick.ask + (trall_distance+trall_step)*_Point),_Digits)>0.0 || market_stop_loss==0)) {
         market_stop_loss = tick.ask + trall_distance*_Point;
         can_enter_on_sl = false;
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            trade.PositionModify(position_ticket,market_stop_loss,PositionGetDouble(POSITION_TP));
         }      
      }
   }

   // закрытие по СЛ %
   if(stop_loss_percent>0 && market_profit <= - AccountInfoDouble(ACCOUNT_BALANCE) * (stop_loss_percent/100.0)) {
      can_enter_on_sl = false;
      for(ii=PositionsTotal()-1;ii>=0;ii--) {
         position_ticket = PositionGetTicket(ii);
         if(!PositionSelectByTicket(position_ticket)) continue;
         if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
         trade.PositionClose(position_ticket);
      }   
   }
   
   // частичное закрытие
   if(market_direction!=-1 && !market_part_close && part_close_level>0) {
      bool need_part_close = false;
      if(market_direction==0 && NormalizeDouble((tick.bid - market_price_sum) - part_close_level*_Point,_Digits)>=0.0) 
         need_part_close = true;
      if(market_direction==1 && NormalizeDouble((market_price_sum - tick.ask) - part_close_level*_Point,_Digits)>=0.0) 
         need_part_close = true;
      if(need_part_close) {
         can_enter_on_sl = false;
         for(ii=PositionsTotal()-1;ii>=0;ii--) {
            position_ticket = PositionGetTicket(ii);
            Print(ii," ",position_ticket);
            if(!PositionSelectByTicket(position_ticket)) continue;
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
            double close_lot = NormalizeDouble(PositionGetDouble(POSITION_VOLUME) * (part_close_percent/100.0),dg);
            if(close_lot < min_lot) close_lot = min_lot;
            trade.PositionClosePartial(position_ticket,close_lot);
            Print("close partial");
         }   
      }
   }

   // переворот по стартовому стоп лосу
   if(market_direction == -1 && can_enter_on_sl && enter_on_first_sl) {
      Print("enter on sl");
      can_enter_on_sl = false;
      int   close_by_sl = -1;
      double close_by_sl_price_open = 0;
      HistorySelect(TimeCurrent()-864000,TimeCurrent());
      for(ii=HistoryDealsTotal()-1;ii>=0;ii--) {
         deal_ticket = HistoryDealGetTicket(ii);
         if(HistoryDealGetString(deal_ticket,DEAL_SYMBOL) != _Symbol) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_MAGIC) != Magic) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_IN && close_by_sl>=0) {
            close_by_sl_price_open = HistoryDealGetDouble(deal_ticket,DEAL_PRICE);
            break;
         }
         if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_OUT) {
            if(HistoryDealGetInteger(deal_ticket,DEAL_REASON) == DEAL_REASON_SL)
               close_by_sl = HistoryDealGetInteger(deal_ticket,DEAL_TYPE) == DEAL_TYPE_BUY ? 0 : 1;
            else
               break;
         }
      }
      Print(close_by_sl," ",close_by_sl_price_open);
      if(close_by_sl>=0) {
         open_sl = close_by_sl_price_open;
         /*
         if(close_by_sl==0) {
            open_sl = 0;
            if(stop_loss_type == SL_TYPE_FIX) 
               open_sl = tick.ask - stop_loss_fix*_Point;
            if(stop_loss_type == SL_TYPE_ZZ) {
               open_sl = level_buy_stop - stop_loss_shift*_Point;
               if(tick.ask - open_sl > stop_loss_max*_Point) 
                  open_sl = tick.ask - stop_loss_max*_Point;
            }
         }
         if(close_by_sl==1) {
            open_sl = 0;
            if(stop_loss_type == SL_TYPE_FIX) 
               open_sl = tick.bid + stop_loss_fix*_Point;
            if(stop_loss_type == SL_TYPE_ZZ) {
               open_sl = level_sell_stop + stop_loss_shift*_Point;
               if(open_sl - tick.bid > stop_loss_max*_Point) 
                  open_sl = tick.bid + stop_loss_max*_Point;
            }
         }
         */
         double open_lot = GetNewLot(close_by_sl,open_sl);
         
         double open_tp = 0;
         if(take_profit>0 && (loss_total>=0 || !profit_funk || max_total_of_trades>1)) {
            if(close_by_sl == 0)
               open_tp = tick.ask + take_profit*_Point;
            if(close_by_sl == 1) 
               open_tp = tick.bid - take_profit*_Point;      
         }
         if(close_by_sl==0) {
            open_sl = 0;
            if(stop_loss_type == SL_TYPE_FIX) 
               open_sl = tick.ask - stop_loss_fix*_Point;
            if(stop_loss_type == SL_TYPE_ZZ) {
               open_sl = zz_near_down - stop_loss_shift*_Point;
               if(tick.ask - open_sl > stop_loss_max*_Point) 
                  open_sl = tick.ask - stop_loss_max*_Point;
            }
            if(trade.Buy(open_lot,_Symbol,tick.ask,open_sl, open_tp)) {
               can_enter_on_sl = true;
               return;
            }
         }
         if(close_by_sl==1) {
            open_sl = 0;
            if(stop_loss_type == SL_TYPE_FIX) 
               open_sl = tick.bid + stop_loss_fix*_Point;
            if(stop_loss_type == SL_TYPE_ZZ) {
               open_sl = zz_near_up + stop_loss_shift*_Point;
               if(open_sl - tick.bid > stop_loss_max*_Point) 
                  open_sl = tick.bid + stop_loss_max*_Point;
            }
            if(trade.Sell(open_lot,_Symbol,tick.bid,open_sl, open_tp)) {
               can_enter_on_sl = true;
               return;
            }
         }
      }
   }

   // первый вход
   if(market_direction == -1 && signal!=-1) {
      Print(555," ",signal);
      if(NormalizeDouble((tick.ask-tick.bid) - max_spread*_Point,_Digits)>=0.0) {
         Print("big spread: ",DoubleToString(tick.ask-tick.bid,_Digits));
         return;
      }
      
      if(signal==0) {
         open_sl = 0;
         if(stop_loss_type == SL_TYPE_FIX) 
            open_sl = tick.ask - stop_loss_fix*_Point;
         if(stop_loss_type == SL_TYPE_ZZ) {
            open_sl = signal_stop_loss - stop_loss_shift*_Point;
            if(tick.ask - open_sl > stop_loss_max*_Point) 
               open_sl = tick.ask - stop_loss_max*_Point;
         }
      }
      if(signal==1) {
         open_sl = 0;
         if(stop_loss_type == SL_TYPE_FIX) 
            open_sl = tick.bid + stop_loss_fix*_Point;
         if(stop_loss_type == SL_TYPE_ZZ) {
            open_sl = signal_stop_loss + stop_loss_shift*_Point;
            if(open_sl - tick.bid > stop_loss_max*_Point) 
               open_sl = tick.bid + stop_loss_max*_Point;
         }
      }

      double open_lot = GetNewLot(signal,open_sl);
      
      double open_tp = 0;
      if(take_profit>0 && (loss_total>=0 || !profit_funk || max_total_of_trades>1)) {
         if(signal == 0)
            open_tp = tick.ask + take_profit*_Point;
         if(signal == 1) 
            open_tp = tick.bid - take_profit*_Point;      
      }
      if(signal==0) {
         Print("open buy ",DoubleToString(open_lot,2));
         if(trade.Buy(open_lot,_Symbol,tick.ask,open_sl, open_tp)) {
            can_enter_on_sl = true;
            if(loss_total>=0) {
               chain_start_time = TimeCurrent();
               GlobalVariableSet("zzp"+_Symbol+(string)Magic,chain_start_time);
            }
         }else{
            Print(trade.ResultRetcodeDescription());
         }
      }
      if(signal==1) {
         Print("open sell ",DoubleToString(open_lot,2));
         if(trade.Sell(open_lot,_Symbol,tick.bid,open_sl, open_tp)) {
            can_enter_on_sl = true;
            if(loss_total>=0) {
               chain_start_time = TimeCurrent();
               GlobalVariableSet("zzp"+_Symbol+(string)Magic,chain_start_time);
            }
         }else{
            Print(trade.ResultRetcodeDescription());
         }
      }
      //sleep();
   }
   // докупка
   if(market_direction==0 && market_orders < max_total_of_trades && signal==0 && 
     NormalizeDouble((market_price_last - tick.ask) - min_distance_of_next_trade*_Point,_Digits)>=0.0) { 
      open_sl = 0;
      if(stop_loss_type == SL_TYPE_FIX) 
         open_sl = tick.ask - stop_loss_fix*_Point;
      if(stop_loss_type == SL_TYPE_ZZ) {
         open_sl = signal_stop_loss - stop_loss_shift*_Point;
         if(tick.ask - open_sl > stop_loss_max*_Point) 
            open_sl = tick.ask - stop_loss_max*_Point;
      }
      trade.Buy(NormalizeDouble(market_lot_first * MathPow(lot_x,market_orders),dg),_Symbol,tick.ask,open_sl, take_profit>0 ? tick.ask + take_profit*_Point : 0);
   }
   if(market_direction==1 && market_orders < max_total_of_trades && signal==1 && 
     NormalizeDouble((tick.bid - market_price_last) - min_distance_of_next_trade*_Point,_Digits)>=0.0) {
      open_sl = 0;
      if(stop_loss_type == SL_TYPE_FIX) 
         open_sl = tick.bid + stop_loss_fix*_Point;
      if(stop_loss_type == SL_TYPE_ZZ) {
         open_sl = signal_stop_loss + stop_loss_shift*_Point;
         if(open_sl - tick.bid > stop_loss_max*_Point) 
            open_sl = tick.bid + stop_loss_max*_Point;
      }
      trade.Sell(NormalizeDouble(market_lot_first * MathPow(lot_x,market_orders),dg),_Symbol,tick.bid,open_sl, take_profit>0 ? tick.bid - take_profit*_Point : 0);
   }


}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void sleep() {
   ulong tick_count = GetTickCount();
   while(GetTickCount() - tick_count < 3000);
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void OnDeinit(const int reason) {
   return;
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
int OnInit() {
   static string alertText="";
   // TODO
//    if (!CheckWorkOnInit(alertText)){
//       Alert(alertText);
//       return INIT_FAILED;
//    }

   Symb=_Symbol;
   dig=_Digits;
   dig_ind = dig+1;
   Pp=_Point;
   if(Pp==0.00001 || Pp==0.001) Pp*=10;
   if(SymbolInfoDouble(Symb,SYMBOL_VOLUME_STEP)==0.01) dg=2; else
      if(SymbolInfoDouble(Symb,SYMBOL_VOLUME_STEP)==0.01) dg=1;
   tick_size=SymbolInfoDouble(Symb,SYMBOL_TRADE_TICK_SIZE);
   min_lot=NormalizeDouble(SymbolInfoDouble(Symb,SYMBOL_VOLUME_MIN),dg);
   trade.SetTypeFilling(set_filling);
   trade.SetExpertMagicNumber(Magic);
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING) is_hedging=false;
   
   //time_bar = iTime(NULL,mfi_time_frame,0);
   zz_handle = iCustom(NULL,0,"Examples\\ZigZag",ExtDepth,ExtDeviation,ExtBackstep);
   if(zz_handle==INVALID_HANDLE) {
      Alert("can't get zz hande");
      return(INIT_FAILED);
   }
   
   loss_total = 0;
   if(GlobalVariableCheck("zzp"+_Symbol+(string)Magic)) {
      chain_start_time = (datetime)GlobalVariableGet("lcf"+_Symbol+(string)Magic);
      HistorySelect(chain_start_time,TimeCurrent());
      for(ii=HistoryDealsTotal()-1;ii>=0;ii--) {
         ulong deal_ticket = HistoryDealGetTicket(ii);
         if(HistoryDealGetString(deal_ticket,DEAL_SYMBOL) != _Symbol) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_MAGIC) != Magic) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY)!=DEAL_ENTRY_OUT) continue;
         loss_total+=HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
      }
   }   
   OnTick();

   return(INIT_SUCCEEDED);
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
double NormalizeTickSize(double price) {
   price/=tick_size;
   price=NormalizeDouble(price,0);
   price*=tick_size;
   price=NormalizeDouble(price,_Digits);
   return(price);
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
double GetNewLot(int signal, double open_sl, double loss_add = 0) {
   Print("get new lot ",signal," ",DoubleToString(open_sl,_Digits)," ",DoubleToString(loss_add,2));
   MqlTick tick;
   SymbolInfoTick(_Symbol,tick);

   double   new_lot  = lot;
   if(auto_lot>0) 
      new_lot *= MathFloor( AccountInfoDouble(ACCOUNT_BALANCE) / auto_lot);
   
   double   new_risk = risk;
   int      loss_orders = 0;
   loss_total  = 0;
   if(max_total_of_trades==1 && chain_start_time>0 && lot_x!=1.0) {
      double last_lot = 0;
      HistorySelect(chain_start_time,TimeCurrent());
      for(ii = HistoryDealsTotal()-1; ii>=0;ii--) {
         ulong deal_ticket = HistoryDealGetTicket(ii);
         if(HistoryDealGetString(deal_ticket,DEAL_SYMBOL) != _Symbol) continue;
         if(HistoryDealGetInteger(deal_ticket,DEAL_MAGIC) != Magic) continue;
         if(HistoryDealGetDouble(deal_ticket,DEAL_VOLUME) > last_lot)
            last_lot = HistoryDealGetDouble(deal_ticket,DEAL_VOLUME);
         if(HistoryDealGetInteger(deal_ticket,DEAL_ENTRY) == DEAL_ENTRY_OUT) { 
            double deal_profit = HistoryDealGetDouble(deal_ticket,DEAL_PROFIT);
            loss_total += deal_profit;
            if(deal_profit<0)
               loss_orders++;
         }
      }
      if(loss_total>0) loss_orders = 0;
      if(loss_orders>0) {
         return( NormalizeDouble(last_lot * lot_x,dg));
      }
   }
   
   double open_lot = new_lot;
   if(risk>0) {
      open_lot *= MathFloor( AccountInfoDouble(ACCOUNT_BALANCE) / risk);
      double profit_1_lot=0;
      if(signal==0) {
         if(!OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,tick.ask,open_sl,profit_1_lot)) {
            Print("Не удалось расчитать лот");
            return(-1);
         }
      }
      if(signal==1) {
         if(!OrderCalcProfit(ORDER_TYPE_SELL,_Symbol,1.0,tick.bid,open_sl,profit_1_lot)) {
            Print("Не удалось расчитать лот");
            return(-1);
         }
      }
      
      open_lot = AccountInfoDouble(ACCOUNT_BALANCE) * (new_risk/100.0);
      open_lot /= -profit_1_lot;
      open_lot = NormalizeDouble(open_lot,dg);
   }
   
   if(open_lot < SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN))
      return(SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
   if(open_lot > SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX))
      return(SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
   
   return(open_lot);
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
